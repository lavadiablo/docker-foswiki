import re
import os
file = open("xwikiDownloadPage.html","r")

latest = ""
packageList = []
for line in file:
    latest = re.search('xwiki-enterprise-web-([0-9].)+war',line)
    if latest != None:
        latest = re.search('xwiki-enterprise-web-([0-9].)+war',line).group(0)
        latest = re.sub('.war', '', latest)
        packageList.append(latest)

packageList.sort()
latest = packageList[-1] + '.war'

print 'wget "http://download.forge.ow2.org/xwiki/'+ latest + '" -P /'
print 'unzip "/' + latest + '" -d /var/lib/tomcat7/webapps/xwiki'