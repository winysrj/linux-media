Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab1DLXto (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 19:49:44 -0400
Message-ID: <4DA4E513.4090301@redhat.com>
Date: Tue, 12 Apr 2011 20:49:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: wk <handygewinnspiel@gmx.de>
Subject: [PATCH dvb-apps] Allow LANG/LC_TYPE with @ symbol
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

According to IEEE Std 1003.1[1], the common way to specify LANG/LC_TYPE
is:
	language[_territory][.codeset]

However, a variant may also be used, like:
	[language[_territory][.codeset][@modifier]]

Change the logic to allow getting the charset also with the extended
syntax.

[1] http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap08.html

Thanks to Winfield <handygewinnspiel@gmx.de> for pointing it to me.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/util/scan/scan.c b/util/scan/scan.c
--- a/util/scan/scan.c
+++ b/util/scan/scan.c
@@ -2565,12 +2565,13 @@ int main (int argc, char **argv)
 	if ((charset = getenv("LC_ALL")) ||
 	    (charset = getenv("LC_CTYPE")) ||
 	    (charset = getenv ("LANG"))) {
-		while (*charset != '.' && *charset)
-			charset++;
-		if (*charset == '.')
-			charset++;
-		if (*charset)
-			output_charset = charset;
+		char *p = strchr(charset, '.');
+		if (p) {
+			p++;
+			p = strtok(p, "@");
+		}
+		if (p)
+			output_charset = p;
 		else
 			output_charset = nl_langinfo(CODESET);
 	} else
