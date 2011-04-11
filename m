Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:58244 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754720Ab1DKRsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 13:48:46 -0400
Content-Type: text/plain; charset="utf-8"
Date: Mon, 11 Apr 2011 19:48:41 +0200
From: handygewinnspiel@gmx.de
In-Reply-To: <4D9C5C4D.4040709@redhat.com>
Message-ID: <20110411174841.268990@gmx.net>
MIME-Version: 1.0
References: <4D9C5C4D.4040709@redhat.com>
Subject: Re: dvb-apps: charset support
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,
 
> I added some patches to dvb-apps/util/scan.c in order to properly support
> EN 300 468 charsets.
> Before the patch, scan were producing invalid UTF-8 codes here, for
> ISO-8859-15 charsets, as
> scan were simply filling service/provider name with whatever non-control
> characters that were
> there. So, if your computer uses the same character as your service
> provider, you're lucky.
> Otherwise, invalid characters will appear at the scan tables.
> 
> After the changes, scan gets the locale environment charset, and use it as
> the output charset
> on the output files.

This implementation in scan expects the environment settings to be 'language_country.encoding', but i think the more general way is 'language_country.encoding@variant'.

i get the following error from scan, because iconv doesnt know 'ISO-8859-15@euro'.

<snip>
WARNING: Conversion from ISO-8859-9 to ISO-8859-15@euro not supported
WARNING: Conversion from ISO-8859-9 to ISO-8859-15@euro not supported
...
WARNING: Conversion from ISO-8859-15 to ISO-8859-15@euro not supported
WARNING: Conversion from ISO-8859-15 to ISO-8859-15@euro not supported
</snap>

I suggest to change scan.c as follows:

--- dvb-apps-5e68946b0e0d_orig/util/scan/scan.c 2011-04-10 20:22:52.000000000 +0200
+++ dvb-apps-5e68946b0e0d/util/scan/scan.c      2011-04-11 19:41:21.460000060 +0200
@@ -2570,14 +2570,14 @@
        if ((charset = getenv("LC_ALL")) ||
            (charset = getenv("LC_CTYPE")) ||
            (charset = getenv ("LANG"))) {
-               while (*charset != '.' && *charset)
-                       charset++;
-               if (*charset == '.')
-                       charset++;
-               if (*charset)
-                       output_charset = charset;
-               else
-                       output_charset = nl_langinfo(CODESET);
+               // assuming 'language_country.encoding@variant'
+               char * p;
+
+               if ((p = strchr(charset, '.')))
+                       charset = p + 1;
+               if ((p = strchr(charset, '@')))
+                       *p = 0;
+               output_charset = charset;
        } else
                output_charset = nl_langinfo(CODESET);


This cuts the '@variant' part from charset, so that iconv will find its way.

cheers,
Winfried


-- 
NEU: FreePhone - kostenlos mobil telefonieren und surfen!			
Jetzt informieren: http://www.gmx.net/de/go/freephone
