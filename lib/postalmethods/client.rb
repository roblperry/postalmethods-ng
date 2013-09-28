require 'savon'
require 'base64'

module PostalMethods

  API_URI = "https://api.postalmethods.com/2009-02-26/PostalWS.asmx?WSDL"

  API_VALID_IMAGE_SIDE_SCALING = %w{Default FitToPage None}
  API_VALID_MAILING_PRIORITY = %w{Default FirstClass}
  API_VALID_OVERWRITE = [true, false]
  API_VALID_PERMISSIONS = %w{Account User}
  API_VALID_POSTCARD_SIZE = %w{Default Postcard_4_25X6}
  API_VALID_PRINT_COLOR = %w{Default Black FullColor}
  API_VALID_WORK_MODE = %w{Default Production Development}

  class Client
    extend Savon::Model

    client wsdl: API_URI

    global :log_level, :error
    global :pretty_print_xml, true
    global :open_timeout, 30
    global :convert_request_keys_to, :camelcase

    attr_accessor :username, :password, :api_key

    operations  :cancel_delivery,
                :delete_uploaded_file,
                :get_details,
                :get_details_extended,
                :get_status,
                :get_pdf,
                :get_uploaded_file_details,
                :send_letter,
                :send_letter_and_address,
                :send_postcard_and_address,
                :upload_file

    def initialize(args)
      self.username = args[:username]
      self.password = args[:password]
      self.api_key  = args[:api_key]
    end

    def sign!(data)
      data.merge!({ username: self.username }) unless self.username.blank?
      data.merge!({ password: self.password }) unless self.password.blank?
      data.merge!({ a_p_i_key: self.api_key }) unless self.api_key.blank?

      return data
    end

    def one_or_many_ids(data)
      if data.is_a?(Array)
        data.join(',')
      elsif data.is_a?(Range)
        data.to_s.sub('..','-')
      else
        data.to_s
      end
    end

    def valid_or_default(data, stack)
      (data and stack.include?(data)) ? data : stack.first
    end

    def file_from(data)
      return data if data.is_a?(File)

      raise "Filename is empty" if data.blank?
      raise "File does not exist: #{data}" unless File.exist?(data)
      raise "File is not a regular file: #{data}" unless File.file?(data)

      File.open(data)
    end

    def report_error(code)
      if Error::CODES.keys.include?(code)
        instance_eval("raise APIStatusCode#{code.to_s.strip.sub(/^\-/,'')}Error")
      else
        puts "Unknown result code: #{code}"
      end
    end

    def get_status(ids)
      opts = { i_d: one_or_many_ids(ids) }
      xml = super message: sign!(opts)
      res = xml.body[:get_status_response][:get_status_result]
      code = res[:result_code].to_i

      if code == -3000
        [res[:statuses][:letter_status_and_desc]].flatten
      else
        report_error(code)
      end
    end

    def get_details(ids)
      opts = { i_d: one_or_many_ids(ids) }
      xml = super message: sign!(opts)
      res = xml.body[:get_details_response][:get_details_result]
      code = res[:result_code].to_i

      if code == -3000
        [res[:details][:details]].flatten
      else
        report_error(code)
      end
    end

    def get_details_extended(ids)
      opts = { i_d: one_or_many_ids(ids) }
      xml = super message: sign!(opts)
      res = xml.body[:get_details_extended_response][:get_details_extended_result]
      code = res[:result_code].to_i

      if code == -3000
        [res[:details][:extended_details]].flatten
      else
        report_error(code)
      end
    end

    def get_pdf(id)
      opts = { i_d: id }
      xml = super message: sign!(opts)
      res = xml.body[:get_pdf_response][:get_pdf_result]
      code = res[:result_code].to_i

      if code == -3000
        true
      else
        report_error(code)
      end
    end

    def get_uploaded_file_details
      opts = { }
      xml = super message: sign!(opts)
      res = xml.body[:get_uploaded_file_details_response][:get_uploaded_file_details_result]
      code = res[:result_code].to_i

      if code == -3000
        [res[:uploaded_files][:file_details]].flatten
      else
        report_error(code)
      end
    end

    def upload_file(args = {})
      file = file_from(args[:file])
      description = args[:description]
      permissions = valid_or_default(args[:permissions], API_VALID_PERMISSIONS)
      overwrite = valid_or_default(args[:overwrite], API_VALID_OVERWRITE)

      opts = {
        my_file_name: File.basename(file.path),
        file_binary_data: Base64.encode64(file.read),
        description: description,
        permissions: permissions,
        overwrite: overwrite,
      }
      xml = super message: sign!(opts)
      res = xml.body[:upload_file_response][:upload_file_result]
      code = res.to_i

      if code == -3000
        true
      else
        report_error(code)
      end
    end

    def delete_uploaded_file(filename)
      opts = { my_file_name: filename }
      xml = super message: sign!(opts)
      res = xml.body[:delete_uploaded_file_response][:delete_uploaded_file_result]
      code = res.to_i

      if code > 0
        true
      else
        report_error(code)
      end
    end

    def send_letter(args = {})
      description = args[:description].to_s
      mode = valid_or_default(args[:mode], API_VALID_WORK_MODE)
      file = file_from(args[:file])

      opts = {
        my_description: description,
        file_extension: File.extname(file.path),
        file_binary_Data: Base64.encode64(file.read),
        work_mode: mode
      }
      xml = super message: sign!(opts)
      res = xml.body[:send_letter_response][:send_letter_result]
      code = res.to_i

      if code > 0
        code
      else
        report_error(code)
      end
    end

    def send_letter_and_address(args = {})
      description = args[:description].to_s
      mode = valid_or_default(args[:mode], API_VALID_WORK_MODE)
      file = file_from(args[:file])

      opts = {
        my_description: description,
        file_extension: File.extname(file.path),
        file_binary_Data: Base64.encode64(file.read),
        work_mode: mode
      }
      opts.merge!(args[:address])
      xml = super message: sign!(opts)
      res = xml.body[:send_letter_and_address_response][:send_letter_and_address_result]
      code = res.to_i

      if code > 0
        code
      else
        report_error(code)
      end
    end

    def send_postcard_and_address(args = {})
      description = args[:description].to_s
      front = args[:front].to_s
      back = args[:back].to_s
      size = valid_or_default(args[:size], API_VALID_POSTCARD_SIZE)
      scaling = valid_or_default(args[:scaling], API_VALID_IMAGE_SIDE_SCALING)
      color = valid_or_default(args[:color], API_VALID_PRINT_COLOR)
      priority = valid_or_default(args[:priority], API_VALID_MAILING_PRIORITY)
      mode = valid_or_default(args[:mode], API_VALID_WORK_MODE)
      address = parse_address(args[:address])

      opts = {
        my_description: description,
        image_side_scaling: scaling,
        print_color: color,
        postcard_size: size,
        mailling_priority: priority,
        work_mode: mode,
      }
      opts.merge!(address)

      if front.is_a?(String) and front.start_with?('MyFile:','MyTemplate:')
        opts.merge!({
          image_side_file_type: File.basename(front),
        })
      else
        file = file_from(front)
        opts.merge!({
          image_side_file_type: File.extname(file.path),
          image_side_binary_data: Base64.encode64(file.read),
        })
      end

      if back.is_a?(String) and back.start_with?('MyFile:','MyTemplate:')
        opts.merge!({
          address_side_file_type: File.basename(back),
        })
      else
        file = file_from(back)
        opts.merge!({
          address_side_file_type: File.extname(file.path),
          address_side_binary_data: Base64.encode64(file.read),
        })
      end

      xml = super message: sign!(opts)
      res = xml.body[:send_postcard_and_address_response][:send_postcard_and_address_result]
      code = res.to_i

      if code > 0
        code
      else
        report_error(code)
      end
    end

    def cancel_delivery(id)
      opts = { i_d: id }
      xml = super message: sign!(opts)
      res = xml.body[:cancel_delivery_response][:cancel_delivery_result]
      code = res.to_i

      if code == -3000
        return true
      else
        report_error(code)
      end
    end
  end
end
