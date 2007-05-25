#Copyright (c) 2007, McClain Looney
#
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#Neither the name of the author, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
#CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
#EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
#LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
#NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'net/http'
require 'net/https'
module ReCaptcha
  module ViewHelper
    def get_captcha()
      k = ReCaptcha::Client.new(RCC_PUB, RCC_PRIV)
      r = k.get_challenge(session[:rcc_err] || '' )
      session[:rcc_err]=''
      r
    end
  end
  module  AppHelper
    private
    def validate_recap(p, errors)
      rcc=ReCaptcha::Client.new(RCC_PUB, RCC_PRIV)
      res = rcc.validate(request.remote_ip, p[:recaptcha_challenge_field], p[:recaptcha_response_field], errors)
      session[:rcc_err]=rcc.last_error

      res
    end
  end
  class Client

    def initialize(pubkey, privkey, ssl=false)
      @pubkey = pubkey
      @privkey=privkey
      @host = ssl ? 'api-secure.recaptcha.net':'api.recaptcha.net'
      @vhost = 'api-verify.recaptcha.net'
      @proto = ssl ? 'https' : 'http'
      @ssl = ssl
    end

    def get_challenge(error='')
      s=<<-EOF
      <script type="text/javascript" src="#{@proto}://#{@host}/challenge?k=#{CGI.escape(@pubkey)}&error=#{CGI.escape(error)}"> </script>
      <noscript>
      <iframe src="#{@proto}://#{@host}/noscript?k=#{CGI.escape(@pubkey)}"
      height="300" width="500" frameborder="0"></iframe><br>
      <textarea name="recaptcha_challenge_field" rows="3" cols="40">
      </textarea>
      <input type="hidden" name="recaptcha_response_field" 
      value="manual_challenge">
      </noscript>
      EOF
    end

    def last_error
      @last_error
    end
    def validate(remoteip, challenge, response, errors)
      msg = "Captcha failed."
      return true if remoteip == '0.0.0.0'
      if not response
        errors.add_to_base(msg)
        return false
      end
      http = Net::HTTP.new(@vhost, 80)
      path='/verify'
      data = "privatekey=#{CGI.escape(@privkey)}&remoteip=#{CGI.escape(remoteip)}&challenge=#{CGI.escape(challenge)}&response=#{CGI.escape(response)}"
      resp, data = http.post(path, data, {'Content-Type'=>'application/x-www-form-urlencoded'})
      response = data.split
      result = response[0].chomp
      @last_error=response[1].chomp
      errors.add_to_base(msg) if  result != 'true'
      result == 'true' 
    end
  end
end
