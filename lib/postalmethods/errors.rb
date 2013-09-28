module PostalMethods
  class Error < RuntimeError
    CODES = {
      -1000 => "Completed: successfully delivered to the postal agency",
      -1002 => "Completed: successfully completed in Development work mode",
      -1005 => "Actively canceled by user",
      -1010 => "Failed: no funds available to process the letter",
      -1018 => "Failed: Provided US address cannot be verified",
      -1021 => "Failed: Invalid page size",
      -1025 => "Failed: A document could not be processed",
      -1045 => "Failed: Recipient postal address could not be extracted from the document",
      -1065 => "Failed: Too many sheets of paper",
      -1099 => "Failed: Internal Error",
      -3000 => "OK",
      -3001 => "This user is not authorized to access the specified item",
      -3003 => "Not Authenticated",
      -3004 => "The specified extension is not supported",
      -3010 => "Rejected: no funds available",
      -3020 => "The file specified is unavailable (it may still be being processed, please try later)",
      -3022 => "Cancellation Denied: The letter was physically processed and cannot be cancelled",
      -3113 => "Rejected: the city field contains more than 30 characters",
      -3114 => "Rejected: the state field contains more than 30 characters",
      -3115 => "There was no data returned for your query",
      -3116 => "The specified letter (ID) does not exist in the system",
      -3117 => "Rejected: the company field contains more than 45 characters",
      -3118 => "Rejected: the address1 field contains more than 45 characters",
      -3119 => "Rejected: the address2 field contains more than 45 characters",
      -3120 => "Rejected: the AttentionLine1 field contains more than 45 characters",
      -3121 => "Rejected: the AttentionLine2 field contains more than 45 characters",
      -3122 => "Rejected: the AttentionLine3 field contains more than 45 characters",
      -3123 => "Rejected: the PostalCode/ZIP field contains more than 15 characters",
      -3124 => "Rejected: the Country field contains more than 30 characters",
      -3125 => "Only account administrators are allowed access to this information",
      -3126 => "Invalid file name",
      -3127 => "File name already exists",
      -3128 => "The ImageSideFileType field is empty or missing",
      -3129 => "The AddressSideFileType field is empty or missing",
      -3130 => "Unsupported file extension in ImageSideFileType",
      -3131 => "Unsupported file extension in AddressSideFileType",
      -3132 => "The ImageSideBinaryData field is empty or missing",
      -3133 => "The AddressSideBinaryData field is empty or missing",
      -3134 => "File name provided in ImageSideFileType does not exist for this user",
      -3135 => "File name provided in AddressSideFileType does not exist for this user",
      -3136 => "Image side: One or more of the fields is missing from the template",
      -3137 => "Address side: One or more of the fields is missing from the template",
      -3138 => "Image side: The XML merge data is invalid",
      -3139 => "Address side: The XML merge data is invalid",
      -3142 => "Image side: This file cannot be used as a template",
      -3143 => "Address side: This file cannot be used as a template",
      -3144 => "The XML merge data is invalid",
      -3145 => "One or more of the fields in the XML merge data is missing from the selected template",
      -3146 => "Specified pre-uploaded document does not exist",
      -3147 => "Uploading a file and a template in the same request is not allowed",
      -3150 => "General System Error: Contact technical support",
      -3160 => "File does not exist",
      -3161 => "Insufficient Permissions",
      -3162 => "Too many uploaded files",
      -3163 => "No files for the account",
      -3164 => "Only Administrator can upload file as account",
      -3165 => "User does not have an API key assigned",
      -3209 => "No more users allowed",
      -3210 => "Last administrator for account",
      -3211 => "User does not exist for this account",
      -3212 => "One or more of the parameters are invalid",
      -3213 => "Invalid value: General_Username",
      -3214 => "Invalid value: General_Description",
      -3215 => "Invalid value: General_Timezone",
      -3216 => "Invalid value: General_WordMode",
      -3217 => "Invalid value: Security_Password",
      -3218 => "Invalid value: Security_AdministrativeEmail",
      -3219 => "Invalid value: Security_KeepContentOnServer",
      -3220 => "Invalid value: Letters_PrintColor",
      -3221 => "Invalid value: Letters_PrintSides",
      -3222 => "Invalid value: Postcards_DefaultScaling",
      -3223 => "Invalid value: Feedback_FeedbackType",
      -3224 => "Invalid value: Feedback_Email_WhenToSend_EmailReceived",
      -3225 => "Invalid value: Feedback_Email_WhenToSend_Completed",
      -3226 => "Invalid value: Feedback_Email_WhenToSend_Error",
      -3227 => "Invalid value: Feedback_Email_WhenToSend_BatchErrors",
      -3228 => "Invalid value: Feedback_Email_DefaultFeedbackEmail",
      -3229 => "Invalid value: Feedback_Email_Authentication",
      -3230 => "Invalid value: Feedback_Post_WhenToSend_Completed",
      -3231 => "Invalid value: Feedback_Post_WhenToSend_Error",
      -3232 => "Invalid value: Feedback_Post_WhenToSend_BatchErrors",
      -3233 => "Invalid value: Feedback_Post_FeedbackURL",
      -3234 => "Invalid value: Feedback_Post_Authentication",
      -3235 => "Invalid value: Feedback_Soap_WhenToSend_Completed",
      -3236 => "Invalid value: Feedback_Soap_WhenToSend_Error",
      -3237 => "Invalid value: Feedback_Soap_WhenToSend_BatchErrors",
      -3238 => "Invalid value: Feedback_Soap_FeedbackURL",
      -3239 => "Invalid value: Feedback_Soap_Authentication",
      -3240 => "Invalid parameters array",
      -3500 => "Warning: too many attempts were made for this method",
      -4001 => "The username field is empty or missing",
      -4002 => "The password field is empty or missing",
      -4003 => "The MyDescription field is empty or missing - please contact support",
      -4004 => "The FileExtension field is empty or missing - please contact support",
      -4005 => "The FileBinaryData field is empty or missing - please contact support",
      -4006 => "The Address1 field is empty or missing",
      -4007 => "The city field is empty or missing",
      -4008 => "The Attention1 or Company fields are empty or missing",
      -4009 => "The ID field is empty or missing.",
      -4010 => "The MinID field is empty or missing",
      -4011 => "The MaxID field is empty or missing",
      -4013 => "Invalid ID or IDs",
      -4014 => "The MergeData field is empty or missing",
      -4015 => "Missing field: APIKey"
    }
  end

  class APIError < StandardError
    attr_accessor :code

    def initialize(code, message)
      @code = code
      super(message)
    end
  end

  Error::CODES.to_a.each do |http_status|
    status, message = http_status
    code = status.to_s.strip.sub(/^\-/,'')
    class_eval <<-"end;"
      class APIStatusCode#{code}Error < APIError
        def initialize(message=nil)
          super("#{status}", "#{message}")
        end
      end
    end;
  end
end
