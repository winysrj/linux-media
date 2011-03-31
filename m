Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:21430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933641Ab1CaBM2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 21:12:28 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2V1CSek021823
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 30 Mar 2011 21:12:28 -0400
Received: from [10.3.230.187] (vpn-230-187.phx2.redhat.com [10.3.230.187])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p2V1CQpr004363
	for <linux-media@vger.kernel.org>; Wed, 30 Mar 2011 21:12:27 -0400
Message-ID: <4D93D4F9.3060305@redhat.com>
Date: Wed, 30 Mar 2011 22:12:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH dvb-apps] Fix scan handling for EN 300468 charsets
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It always bothered me that scan tables produced in Brazil
were full of "reverse interrogation" character, due to
accents, like:
	R�dio
instead of:
	Rádio

This is due to the lack of properly interpreting the charset
and calling iconv to handle it.

If, for any reason, the iconv can't convert the charset, it falls
back to the old behavior.

Yet, according with the EN 300 468 Annex A, if the first character
is >= 0x20 (space), the parser should assume character set
ISO-6937-2 (in fact, the standard defines a variant, with an 
extra euro character).

However, at least here, the DVB-C operator doesn't honour the
charset table selection.

Due to that, a new option were added to scan, allowing to override
the charset default. So, in the case of Brazil, using a:
	-C ISO-8859-1
parameter, will properly produce the right channel descriptions, like:

Mosaico Informação:651000000:INVERSION_AUTO:5217000:FEC_3_4:QAM_256:3664:3665:401

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff -r f4e015ebdac7 util/scan/scan.c
--- a/util/scan/scan.c	Thu Mar 17 14:46:30 2011 +0100
+++ b/util/scan/scan.c	Wed Mar 30 21:58:29 2011 -0300
@@ -33,6 +33,7 @@
 #include <assert.h>
 #include <glob.h>
 #include <ctype.h>
+#include <iconv.h>
 
 #include <linux/dvb/frontend.h>
 #include <linux/dvb/dmx.h>
@@ -66,6 +67,7 @@
 static int vdr_version = 3;
 static struct lnb_types_st lnb_type;
 static int unique_anon_services;
+char *default_charset = "ISO-6937-2";
 
 static enum fe_spectral_inversion spectral_inversion = INVERSION_AUTO;
 
@@ -543,60 +545,113 @@
 	}
 }
 
+/*
+ * handle character set correctly (e.g. via iconv)
+ *   c.f. EN 300 468 annex A 
+ */
+static void descriptorcpy(char **dest, const unsigned char *src, size_t len)
+{
+	size_t destlen, i;
+	char *p, *type = NULL;
+
+	if (*dest) {
+		free (*dest);
+		*dest = NULL;
+	}
+	if (!len)
+		return;
+
+	if (*src < 0x20) {
+		switch (*src) {
+		case 0x00:	type = "ISO-6937-2";		break;
+		case 0x01:	type = "ISO-8859-5";		break;
+		case 0x02:	type = "ISO-8859-6";		break;
+		case 0x03:	type = "ISO-8859-7";		break;
+		case 0x04:	type = "ISO-8859-8";		break;
+		case 0x05:	type = "ISO-8859-9";		break;
+		case 0x06:	type = "ISO-8859-10";		break;
+		case 0x07:	type = "ISO-8859-11";		break;
+		case 0x09:	type = "ISO-8859-13";		break;
+		case 0x0a:	type = "ISO-8859-14";		break;
+		case 0x0b:	type = "ISO-8859-15";		break;
+		case 0x11:	type = "ISO-10646";		break;
+		case 0x12:	type = "ISO-2022-KR";		break;
+		case 0x13:	type = "GB2312";		break;
+		case 0x14:	type = "BIG5";			break;
+		case 0x15:	type = "ISO-10646/UTF-8";	break;
+		case 0x10: /* ISO8859 */
+			if ((*(src + 1) != 0) || *(src + 2) > 0x0f)
+				break;
+			src+=2;
+			len-=2;
+			switch(*src) {
+			case 0x01:	type = "ISO-8859-1";		break;
+			case 0x02:	type = "ISO-8859-2";		break;
+			case 0x03:	type = "ISO-8859-3";		break;
+			case 0x04:	type = "ISO-8859-4";		break;
+			case 0x05:	type = "ISO-8859-5";		break;
+			case 0x06:	type = "ISO-8859-6";		break;
+			case 0x07:	type = "ISO-8859-7";		break;
+			case 0x08:	type = "ISO-8859-8";		break;
+			case 0x09:	type = "ISO-8859-9";		break;
+			case 0x0a:	type = "ISO-8859-10";		break;
+			case 0x0b:	type = "ISO-8859-11";		break;
+			case 0x0d:	type = "ISO-8859-13";		break;
+			case 0x0e:	type = "ISO-8859-14";		break;
+			case 0x0f:	type = "ISO-8859-15";		break;
+			}
+		}
+		src++;
+		len--;
+	} else {
+		type = default_charset;
+	}
+
+	/* Destin length should be bigger, to allow 2 char sequences */
+	destlen = len * 2;
+	*dest = malloc(destlen + 1);
+	p = *dest;
+
+	if (type) {
+		iconv_t cd = iconv_open("UTF-8//IGNORE", type);
+		if (cd == (iconv_t)(-1)) {
+			type = NULL;
+		} else {
+			iconv(cd, (char **)&src, &len, &p, &destlen);
+			iconv_close(cd);
+			*p = '\0';
+
+			return;
+		}
+	}
+
+	/* Fallback method: just output whatever non-control char */
+	p = *dest;
+	if (!type) {
+		for (i = 0; i < len; i++, src++) {
+			if (*src >= 0x20 && (*src < 0x80 || *src > 0x9f))
+				*p++ = *src;
+
+		}
+	}
+	*p = '\0';
+}
+
 static void parse_service_descriptor (const unsigned char *buf, struct service *s)
 {
 	unsigned char len;
-	unsigned char *src, *dest;
 
 	s->type = buf[2];
 
 	buf += 3;
 	len = *buf;
 	buf++;
-
-	if (s->provider_name)
-		free (s->provider_name);
-
-	s->provider_name = malloc (len + 1);
-	memcpy (s->provider_name, buf, len);
-	s->provider_name[len] = '\0';
-
-	/* remove control characters (FIXME: handle short/long name) */
-	/* FIXME: handle character set correctly (e.g. via iconv)
-	 * c.f. EN 300 468 annex A */
-	for (src = dest = (unsigned char *) s->provider_name; *src; src++)
-		if (*src >= 0x20 && (*src < 0x80 || *src > 0x9f))
-			*dest++ = *src;
-	*dest = '\0';
-	if (!s->provider_name[0]) {
-		/* zap zero length names */
-		free (s->provider_name);
-		s->provider_name = 0;
-	}
-
-	if (s->service_name)
-		free (s->service_name);
+	descriptorcpy(&s->provider_name, buf, len);
 
 	buf += len;
 	len = *buf;
 	buf++;
-
-	s->service_name = malloc (len + 1);
-	memcpy (s->service_name, buf, len);
-	s->service_name[len] = '\0';
-
-	/* remove control characters (FIXME: handle short/long name) */
-	/* FIXME: handle character set correctly (e.g. via iconv)
-	 * c.f. EN 300 468 annex A */
-	for (src = dest = (unsigned char *) s->service_name; *src; src++)
-		if (*src >= 0x20 && (*src < 0x80 || *src > 0x9f))
-			*dest++ = *src;
-	*dest = '\0';
-	if (!s->service_name[0]) {
-		/* zap zero length names */
-		free (s->service_name);
-		s->service_name = 0;
-	}
+	descriptorcpy(&s->service_name, buf, len);
 
 	info("0x%04x 0x%04x: pmt_pid 0x%04x %s -- %s (%s%s)\n",
 	    s->transport_stream_id,
@@ -2118,7 +2173,8 @@
 	"	-P do not use ATSC PSIP tables for scanning\n"
 	"	    (but only PAT and PMT) (applies for ATSC only)\n"
 	"	-A N	check for ATSC 1=Terrestrial [default], 2=Cable or 3=both\n"
-	"	-U	Uniquely name unknown services\n";
+	"	-U	Uniquely name unknown services\n"
+	"	-C cs	Override default charset (default = ISO-6937-2)\n";
 
 void
 bad_usage(char *pname, int problem)
@@ -2166,7 +2222,7 @@
 
 	/* start with default lnb type */
 	lnb_type = *lnb_enum(0);
-	while ((opt = getopt(argc, argv, "5cnpa:f:d:s:o:x:e:t:i:l:vquPA:U")) != -1) {
+	while ((opt = getopt(argc, argv, "5cnpa:f:d:s:o:x:e:t:i:l:vquPA:UC:")) != -1) {
 		switch (opt) {
 		case 'a':
 			adapter = strtoul(optarg, NULL, 0);
@@ -2246,6 +2302,9 @@
 		case 'U':
 			unique_anon_services = 1;
 			break;
+		case 'C':
+			default_charset = optarg;
+			break;
 		default:
 			bad_usage(argv[0], 0);
 			return -1;
