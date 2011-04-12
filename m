Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:21886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab1DLXrv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 19:47:51 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3CNlpWA020665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 19:47:51 -0400
Received: from [10.11.8.34] (vpn-8-34.rdu.redhat.com [10.11.8.34])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p3CNloAB030248
	for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 19:47:50 -0400
Message-ID: <4DA4E4A5.1020804@redhat.com>
Date: Tue, 12 Apr 2011 20:47:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH dvb-utils] Use ISO6937 instead of ISO-6937
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Altrough iconv seems to recognize also ISO-6937, and scan uses its own table
for it, as "iconv --list" shows it as ISO6937, use the name provided by
iconv. Thanks to Winfried <handygewinnspiel@gmx.de> to point this issue to
me.

While here, improve the help message for the -C parameter, and show the
default charset at the help message.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/util/scan/scan.c b/util/scan/scan.c
--- a/util/scan/scan.c
+++ b/util/scan/scan.c
@@ -69,7 +69,7 @@ static int vdr_version = 3;
 static struct lnb_types_st lnb_type;
 static int unique_anon_services;
 
-char *default_charset = "ISO-6937";
+char *default_charset = "ISO6937";
 char *output_charset;
 #define CS_OPTIONS "//TRANSLIT"
 
@@ -559,7 +559,7 @@ struct charset_conv {
 	unsigned char  data[3];
 };
 
-/* This table is the Latin 00 table. Basically ISO-6937 + Euro sign */
+/* This table is the Latin 00 table. Basically ISO6937 + Euro sign */
 struct charset_conv en300468_latin_00_to_utf8[256] = {
 	[0x00] = { 1, {0x00, } },
 	[0x01] = { 1, {0x01, } },
@@ -725,7 +725,7 @@ struct charset_conv en300468_latin_00_to
 	[0xa1] = { 2, {0xc2, 0xa1, } },
 	[0xa2] = { 2, {0xc2, 0xa2, } },
 	[0xa3] = { 2, {0xc2, 0xa3, } },
-	[0xa4] = { 3, { 0xe2, 0x82, 0xac,} },		/* Euro sign. Addition over the ISO-6937 standard */
+	[0xa4] = { 3, { 0xe2, 0x82, 0xac,} },		/* Euro sign. Addition over the ISO6937 standard */
 	[0xa5] = { 2, {0xc2, 0xa5, } },
 	[0xa6] = { 0, {} },
 	[0xa7] = { 2, {0xc2, 0xa7, } },
@@ -836,7 +836,6 @@ static void descriptorcpy(char **dest, c
 
 	if (*src < 0x20) {
 		switch (*src) {
-		case 0x00:	type = "ISO-6937";		break;
 		case 0x01:	type = "ISO-8859-5";		break;
 		case 0x02:	type = "ISO-8859-6";		break;
 		case 0x03:	type = "ISO-8859-7";		break;
@@ -888,7 +887,7 @@ static void descriptorcpy(char **dest, c
 	*dest = malloc(destlen + 1);
 
 	/* Remove special chars */
-	if (!strncasecmp(type, "ISO-8859", 8) || !strcasecmp(type, "ISO-6937")) {
+	if (!strncasecmp(type, "ISO-8859", 8) || !strcasecmp(type, "ISO6937")) {
 		/*
 		 * Handles the ISO/IEC 10646 1-byte control codes
 		 * (EN 300 468 v1.11.1 Table A.1)
@@ -924,7 +923,7 @@ static void descriptorcpy(char **dest, c
 		s = src;
 
 	p = *dest;
-	if (!strcasecmp(type, "ISO-6937")) {
+	if (!strcasecmp(type, "ISO6937")) {
 		unsigned char *p1, *p2;
 
 		/* Convert charset to UTF-8 using Code table 00 - Latin */
@@ -2512,7 +2511,8 @@ static const char *usage = "\n"
 	"	    (but only PAT and PMT) (applies for ATSC only)\n"
 	"	-A N	check for ATSC 1=Terrestrial [default], 2=Cable or 3=both\n"
 	"	-U	Uniquely name unknown services\n"
-	"	-C cs	Override default charset for service name/provider (default = ISO-6937)\n"
+	"	-C cs	Override default charset for service name/provider\n"
+	"               when no charset is provided (default = %s)\n"
 	"	-D cs	Output charset (default = %s)\n"
 	"Supported charsets by -C/-D parameters can be obtained via 'iconv -l' command\n";
 
@@ -2526,7 +2526,7 @@ bad_usage(char *pname, int problem)
 	switch (problem) {
 	default:
 	case 0:
-		fprintf (stderr, usage, pname, output_charset);
+		fprintf (stderr, usage, pname, default_charset, output_charset);
 		break;
 	case 1:
 		i = 0;
@@ -2542,7 +2542,7 @@ bad_usage(char *pname, int problem)
 		break;
 	case 2:
 		show_existing_tuning_data_files();
-		fprintf (stderr, usage, pname);
+		fprintf (stderr, usage, pname, default_charset, output_charset);
 	}
 }
 
@@ -2556,11 +2556,6 @@ int main (int argc, char **argv)
 	const char *initial = NULL;
 	char *charset;
 
-	if (argc <= 1) {
-	    bad_usage(argv[0], 2);
-	    return -1;
-	}
-
 	/*
 	 * Get the environment charset, and use it as the default
 	 * output charset. In thesis, using nl_langinfo should be
@@ -2581,6 +2576,11 @@ int main (int argc, char **argv)
 	} else
 		output_charset = nl_langinfo(CODESET);
 
+	if (argc <= 1) {
+	    bad_usage(argv[0], 2);
+	    return -1;
+	}
+
 	/* start with default lnb type */
 	lnb_type = *lnb_enum(0);
 	while ((opt = getopt(argc, argv, "5cnpa:f:d:s:o:x:e:t:i:l:vquPA:UC:D:")) != -1) {
