require("apache2")
local http = require("socket.http")
local ltn12 = require("ltn12")

function auth_handler(r)
    local auth_header_value = r.headers_in["Authorization"]
    if auth_header_value == nil then
        r:warn("No header provided")
        r.content_type = "application/json"
        return apache2.AUTHZ_DENIED
    end
    r:info("Authorization header encoded: "..auth_header_value)
    local auth_decoded = r:base64_decode(auth_header_value)
    r:info("Authorization header decoded: "..auth_decoded)
    local auth_chunks = split(auth_decoded,":")
    local auth_user = auth_chunks[1]
    local auth_password = auth_chunks[2]
    status,message = authorize(r,auth_user,auth_password)
    if status then
        r:info("Authorized: ".. auth_header_value)
        r.content_type = "application/json"
        return apache2.AUTHZ_GRANTED
    else
        r:warn("Not authorized: ".. auth_header_value)
        r.content_type = "application/json"
        return apache2.AUTHZ_DENIED
    end
end

function authorize(r,u,p)
    r:info("User: '"..u.."' - password: '".. p.."'")
    local path = "http://api:3000/auth"
    local payload = string.format("{\"user\":\"%s\",\"password\":\"%s\"}",u,p)
    local response_body = { }
  
    local response, code, response_headers, status = http.request
    {
      url = path,
      method = "POST",
      headers =
      {
        ["Content-Type"] = "application/json",
        ["Content-Length"] = payload:len()
      },
      source = ltn12.source.string(payload),
      sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        return true, "Authorized"
    else
        return false, status
    end
end

function build_response(message)
    return string.format("{\"message\":\"%s\"}",message)
end

function split(s,d)
    chunks = {}
    for substring in (s..d):gmatch("(.-)"..d) do
        table.insert(chunks, substring)
    end
    return chunks
end