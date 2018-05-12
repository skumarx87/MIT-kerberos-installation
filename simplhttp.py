import time
import BaseHTTPServer
import kerberos


HOST_NAME = 'krbcn1.tanu.com' # !!!REMEMBER TO CHANGE THIS!!!
PORT_NUMBER = 80 # Maybe set this to 9000.


class MyHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def validate_user(s,data):
        try:
		rc, state = kerberos.authGSSServerInit('HTTP')
		if rc != kerberos.AUTH_GSS_COMPLETE:
			return None 
		rc = kerberos.authGSSServerStep(state, data)
		if rc == kerberos.AUTH_GSS_COMPLETE:
			user = kerberos.authGSSServerUserName(state)
			print(user)

	except kerberos.GSSError as err:
		print(err)
		return None

    def do_HEAD(s):
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()
    def do_GET(s):
        """Respond to a GET request."""
	header=s.headers.get('Authorization')
	if header:
		token = ''.join(header.split()[1:])
		char=token[0:3]
		print(char)
		if(char == "TlR" ):
			s.send_response(401)
			s.send_header('WWW-Authenticate','Negotiate')
		else:
			s.validate_user(token)
			print(header)
        		s.send_response(200)
        		s.send_header("Content-type", "text/html")
        		s.end_headers()
        		s.wfile.write("<html><head><title>Title goes here.</title></head>")
        		s.wfile.write("<body><p>This is a test.</p>")
        		s.wfile.write("</body></html>")
	else:
		s.send_response(401)
		s.send_header('WWW-Authenticate','Negotiate')

if __name__ == '__main__':
    server_class = BaseHTTPServer.HTTPServer
    httpd = server_class((HOST_NAME, PORT_NUMBER), MyHandler)
    print time.asctime(), "Server Starts - %s:%s" % (HOST_NAME, PORT_NUMBER)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    print time.asctime(), "Server Stops - %s:%s" % (HOST_NAME, PORT_NUMBER)
