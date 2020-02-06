FROM httpd:alpine

RUN apk update && \
apk add lua5.1 lua5.1-socket && \
sed -i -r "s/\#(LoadModule.lua_module.modules\/mod_lua\.so)/\1/g" conf/httpd.conf && \
sed -i -r "s/\#(LoadModule.proxy.*\.so)/\1/g" conf/httpd.conf && \
sed -i -r "s/\#(LoadModule.xml2enc.*\.so)/\1/g" conf/httpd.conf && \
sed -i -r "s/\#(LoadModule.rewrite.*\.so)/\1/g" conf/httpd.conf && \
sed -i -r "s/\#(LoadModule.deflate.*\.so)/\1/g" conf/httpd.conf && \
sed -i -r "s/\#(LoadModule.headers.*\.so)/\1/g" conf/httpd.conf && \
sed -i -r "s/\#(LoadModule.slotmem.*\.so)/\1/g" conf/httpd.conf && \
sed -i -r "s/\#(LoadModule.watchdog.*\.so)/\1/g" conf/httpd.conf && \
echo "# Include chilquinta virtual host configuration" >> /usr/local/apache2/conf/httpd.conf && \
echo "Include conf/extra/chilquinta.conf" >> /usr/local/apache2/conf/httpd.conf

CMD [ "/usr/local/bin/httpd-foreground" ]