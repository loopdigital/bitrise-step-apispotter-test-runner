#
#   APISpotter Test Group Runner For Bitrise
#
#   @author:    Furkan Enes Apaydın (@feapaydin)
#   @company:   Loop Digital Inc
#   @date:      2018
#
#


require 'json'
require 'net/http'

require_relative 'lib/api'
require_relative 'lib/helpers'


# Generate Config
#   Any data under config.json will be loaded
#   Also we will retrieve bitrise variables inside CONFIG
CONFIG=JSON.parse(File.read(__dir__+"/config.json"))
CONFIG["API_TOKEN"]=ARGV[0]
CONFIG["GROUP_ID"]=ARGV[1]
CONFIG["ABORT_BUILD"]=ARGV[2]


data=as_get(
    "RunTestGroup",
    {
        api_token: CONFIG["API_TOKEN"],
        test_group_id: CONFIG["GROUP_ID"]
    }
)


#Kill if any error occur
unless data["status"]
    p "FATAL: #{data["error_message"]} (Cannot run test group.)"

    %x"envman add --key AS_RUN_RESULT --value false "
    %x"envman add --key AS_ERROR_MESSAGE --value '#{data["error_message"]}. (Cannot run test group.)' "

    return data["error_code"]
end


#Get the result
result=data["data"]["result"]

#Run status
status=result["is_success"]

#Add status to output
%x"envman add --key AS_RUN_RESULT --value #{status} "


if status
    #No error
    %x"envman add --key AS_ERROR_MESSAGE --value 'NO ERROR' "
else
    #Runned but run result is fail

    msg="Test group runned successfully, but the result has some errors. Check it at ApiSpotter.com"
    
    %x"envman add --key AS_ERROR_MESSAGE --value '#{msg}' "

    if is_yes?(CONFIG["ABORT_BUILD"])
        msg+=" - ABORTED"
        p msg 
    end

end




#All done
p 0