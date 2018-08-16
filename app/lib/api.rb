#
#   API Controller
#
#   @author:    Furkan Enes Apaydın (@feapaydin)
#   @company:   Loop Digital
#   @date:      2018
#


# GET Method
def as_get(_endpoint, _params=nil)

    
    #Prepare final url
    url=CONFIG["API_BASE"] + _endpoint

    uri=URI(url)
    uri.query = URI.encode_www_form(_params) unless _params.nil?

    response=Net::HTTP.get_response(uri)
    
    if response.is_a?(Net::HTTPSuccess)
        
        #All done here
        return JSON.parse(response.body)

    else
        #if anything goes wrong with api response, 
        #   we return a custom response     
        return {status: false, error_code: :api_error, error_message: "Could not retrieve data from ApiSpotter API."}
    end


    # In case of any error
    rescue => e
        return {status: false, error_code: :exception, error_message: "A local exception happened: #{e}"}
 


end
#end GET





