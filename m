Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639Ab1CaRqh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 13:46:37 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2VHkbaa022729
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 31 Mar 2011 13:46:37 -0400
Received: from [10.3.230.198] (vpn-230-198.phx2.redhat.com [10.3.230.198])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p2VHkZZG030954
	for <linux-media@vger.kernel.org>; Thu, 31 Mar 2011 13:46:36 -0400
Message-ID: <4D94BDFB.50605@redhat.com>
Date: Thu, 31 Mar 2011 14:46:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 dvb-apps] Fix scan handling for EN 300468 charsets
References: <4D93D4F9.3060305@redhat.com>
In-Reply-To: <4D93D4F9.3060305@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It always bothered me that scan tables produced in Brazil
were full of "reverse interrogation" pseudo-chars, displayed
when some code violates UTF-8 charset.

This is due to the lack of properly interpreting the service provider
and service name charsets. There's a FIXME suggesting to use glibc
standard iconv functions in order to handle them.

According with EN 300 468, the first char (or the first 3 chars) may
specify the code to be used if they are different than code table 00
(Latin, ISO-6937 variant), and if the first character is < 0x20.

Unfortunately, not all DVB operators hounor it, so an extra parameter
were added to allow overriding.

However, at least here, the DVB-C operator doesn't honour the
charset table selection.

Due to that, a new option were added to scan, allowing to override
the charset default. So, in the case of Brazil, using a:
	-C ISO-8859-1
parameter, will properly produce the right channel description.

The specs allow the usage of certain control character sequences.
This is honoured by the descriptorcpy() function, for 1-byte char
tables (iso-8859 and iso-6937 tables).

Since I don't have access to dual-byte charset signals, I wouldn't
be able to test the conversions for iso-10646 table. So, I opted to
not handle 2-byte control chars (just like the previous code), but
it should be easy to do it, if someone is interested on doing it.

The code will output data by default in UTF-8 format, as this is
the charset used by modern distros, but user can use the -D option
to change the output to any other charset supported by iconv.
The supported charsets are given by:
	$ iconv -l

One interesting usage would be to force the output to ASCII, like:
	-D ASCII

As iconv is part of glibc, it should be available on any glibc-based
distribution. The iconv library is also present on other xNIX flavors.

As a future suggestion, someone could use LANG and LC_MESSAGES environment
vars to set the default for the output format.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

v2: Properly handle 1-char control codes and EN 300 468 iso-6937 variant,
and allow controlling the output charset.

 scan.c |  487 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 444 insertions(+), 43 deletions(-)

diff --git a/util/scan/scan.c b/util/scan/scan.c
--- a/util/scan/scan.c
+++ b/util/scan/scan.c
@@ -33,6 +33,7 @@
 #include <assert.h>
 #include <glob.h>
 #include <ctype.h>
+#include <iconv.h>
 
 #include <linux/dvb/frontend.h>
 #include <linux/dvb/dmx.h>
@@ -67,6 +68,10 @@ static int vdr_version = 3;
 static struct lnb_types_st lnb_type;
 static int unique_anon_services;
 
+char *default_charset = "ISO-6937";
+char *output_charset = "UTF-8";
+#define CS_OPTIONS "//TRANSLIT"
+
 static enum fe_spectral_inversion spectral_inversion = INVERSION_AUTO;
 
 enum table_type {
@@ -543,60 +548,447 @@ static void parse_frequency_list_descrip
 	}
 }
 
+/*
+ * handle character set correctly (e.g. via iconv)
+ *   c.f. EN 300 468 annex A
+ */
+
+struct charset_conv {
+	unsigned len;
+	unsigned char  data[3];
+};
+
+/* This table is the Latin 00 table. Basically ISO-6937 + Euro sign */
+struct charset_conv en300468_latin_00_to_utf8[256] = {
+	[0x00] = { 1, {0x00, } },
+	[0x01] = { 1, {0x01, } },
+	[0x02] = { 1, {0x02, } },
+	[0x03] = { 1, {0x03, } },
+	[0x04] = { 1, {0x04, } },
+	[0x05] = { 1, {0x05, } },
+	[0x06] = { 1, {0x06, } },
+	[0x07] = { 1, {0x07, } },
+	[0x08] = { 1, {0x08, } },
+	[0x09] = { 1, {0x09, } },
+	[0x0a] = { 1, {0x0a, } },
+	[0x0b] = { 1, {0x0b, } },
+	[0x0c] = { 1, {0x0c, } },
+	[0x0d] = { 1, {0x0d, } },
+	[0x0e] = { 1, {0x0e, } },
+	[0x0f] = { 1, {0x0f, } },
+	[0x10] = { 1, {0x10, } },
+	[0x11] = { 1, {0x11, } },
+	[0x12] = { 1, {0x12, } },
+	[0x13] = { 1, {0x13, } },
+	[0x14] = { 1, {0x14, } },
+	[0x15] = { 1, {0x15, } },
+	[0x16] = { 1, {0x16, } },
+	[0x17] = { 1, {0x17, } },
+	[0x18] = { 1, {0x18, } },
+	[0x19] = { 1, {0x19, } },
+	[0x1a] = { 1, {0x1a, } },
+	[0x1b] = { 1, {0x1b, } },
+	[0x1c] = { 1, {0x1c, } },
+	[0x1d] = { 1, {0x1d, } },
+	[0x1e] = { 1, {0x1e, } },
+	[0x1f] = { 1, {0x1f, } },
+	[0x20] = { 1, {0x20, } },
+	[0x21] = { 1, {0x21, } },
+	[0x22] = { 1, {0x22, } },
+	[0x23] = { 1, {0x23, } },
+	[0x24] = { 1, {0x24, } },
+	[0x25] = { 1, {0x25, } },
+	[0x26] = { 1, {0x26, } },
+	[0x27] = { 1, {0x27, } },
+	[0x28] = { 1, {0x28, } },
+	[0x29] = { 1, {0x29, } },
+	[0x2a] = { 1, {0x2a, } },
+	[0x2b] = { 1, {0x2b, } },
+	[0x2c] = { 1, {0x2c, } },
+	[0x2d] = { 1, {0x2d, } },
+	[0x2e] = { 1, {0x2e, } },
+	[0x2f] = { 1, {0x2f, } },
+	[0x30] = { 1, {0x30, } },
+	[0x31] = { 1, {0x31, } },
+	[0x32] = { 1, {0x32, } },
+	[0x33] = { 1, {0x33, } },
+	[0x34] = { 1, {0x34, } },
+	[0x35] = { 1, {0x35, } },
+	[0x36] = { 1, {0x36, } },
+	[0x37] = { 1, {0x37, } },
+	[0x38] = { 1, {0x38, } },
+	[0x39] = { 1, {0x39, } },
+	[0x3a] = { 1, {0x3a, } },
+	[0x3b] = { 1, {0x3b, } },
+	[0x3c] = { 1, {0x3c, } },
+	[0x3d] = { 1, {0x3d, } },
+	[0x3e] = { 1, {0x3e, } },
+	[0x3f] = { 1, {0x3f, } },
+	[0x40] = { 1, {0x40, } },
+	[0x41] = { 1, {0x41, } },
+	[0x42] = { 1, {0x42, } },
+	[0x43] = { 1, {0x43, } },
+	[0x44] = { 1, {0x44, } },
+	[0x45] = { 1, {0x45, } },
+	[0x46] = { 1, {0x46, } },
+	[0x47] = { 1, {0x47, } },
+	[0x48] = { 1, {0x48, } },
+	[0x49] = { 1, {0x49, } },
+	[0x4a] = { 1, {0x4a, } },
+	[0x4b] = { 1, {0x4b, } },
+	[0x4c] = { 1, {0x4c, } },
+	[0x4d] = { 1, {0x4d, } },
+	[0x4e] = { 1, {0x4e, } },
+	[0x4f] = { 1, {0x4f, } },
+	[0x50] = { 1, {0x50, } },
+	[0x51] = { 1, {0x51, } },
+	[0x52] = { 1, {0x52, } },
+	[0x53] = { 1, {0x53, } },
+	[0x54] = { 1, {0x54, } },
+	[0x55] = { 1, {0x55, } },
+	[0x56] = { 1, {0x56, } },
+	[0x57] = { 1, {0x57, } },
+	[0x58] = { 1, {0x58, } },
+	[0x59] = { 1, {0x59, } },
+	[0x5a] = { 1, {0x5a, } },
+	[0x5b] = { 1, {0x5b, } },
+	[0x5c] = { 1, {0x5c, } },
+	[0x5d] = { 1, {0x5d, } },
+	[0x5e] = { 1, {0x5e, } },
+	[0x5f] = { 1, {0x5f, } },
+	[0x60] = { 1, {0x60, } },
+	[0x61] = { 1, {0x61, } },
+	[0x62] = { 1, {0x62, } },
+	[0x63] = { 1, {0x63, } },
+	[0x64] = { 1, {0x64, } },
+	[0x65] = { 1, {0x65, } },
+	[0x66] = { 1, {0x66, } },
+	[0x67] = { 1, {0x67, } },
+	[0x68] = { 1, {0x68, } },
+	[0x69] = { 1, {0x69, } },
+	[0x6a] = { 1, {0x6a, } },
+	[0x6b] = { 1, {0x6b, } },
+	[0x6c] = { 1, {0x6c, } },
+	[0x6d] = { 1, {0x6d, } },
+	[0x6e] = { 1, {0x6e, } },
+	[0x6f] = { 1, {0x6f, } },
+	[0x70] = { 1, {0x70, } },
+	[0x71] = { 1, {0x71, } },
+	[0x72] = { 1, {0x72, } },
+	[0x73] = { 1, {0x73, } },
+	[0x74] = { 1, {0x74, } },
+	[0x75] = { 1, {0x75, } },
+	[0x76] = { 1, {0x76, } },
+	[0x77] = { 1, {0x77, } },
+	[0x78] = { 1, {0x78, } },
+	[0x79] = { 1, {0x79, } },
+	[0x7a] = { 1, {0x7a, } },
+	[0x7b] = { 1, {0x7b, } },
+	[0x7c] = { 1, {0x7c, } },
+	[0x7d] = { 1, {0x7d, } },
+	[0x7e] = { 1, {0x7e, } },
+	[0x7f] = { 1, {0x7f, } },
+	[0x80] = { 2, {0xc2, 0x80, } },
+	[0x81] = { 2, {0xc2, 0x81, } },
+	[0x82] = { 2, {0xc2, 0x82, } },
+	[0x83] = { 2, {0xc2, 0x83, } },
+	[0x84] = { 2, {0xc2, 0x84, } },
+	[0x85] = { 2, {0xc2, 0x85, } },
+	[0x86] = { 2, {0xc2, 0x86, } },
+	[0x87] = { 2, {0xc2, 0x87, } },
+	[0x88] = { 2, {0xc2, 0x88, } },
+	[0x89] = { 2, {0xc2, 0x89, } },
+	[0x8a] = { 2, {0xc2, 0x8a, } },
+	[0x8b] = { 2, {0xc2, 0x8b, } },
+	[0x8c] = { 2, {0xc2, 0x8c, } },
+	[0x8d] = { 2, {0xc2, 0x8d, } },
+	[0x8e] = { 2, {0xc2, 0x8e, } },
+	[0x8f] = { 2, {0xc2, 0x8f, } },
+	[0x90] = { 2, {0xc2, 0x90, } },
+	[0x91] = { 2, {0xc2, 0x91, } },
+	[0x92] = { 2, {0xc2, 0x92, } },
+	[0x93] = { 2, {0xc2, 0x93, } },
+	[0x94] = { 2, {0xc2, 0x94, } },
+	[0x95] = { 2, {0xc2, 0x95, } },
+	[0x96] = { 2, {0xc2, 0x96, } },
+	[0x97] = { 2, {0xc2, 0x97, } },
+	[0x98] = { 2, {0xc2, 0x98, } },
+	[0x99] = { 2, {0xc2, 0x99, } },
+	[0x9a] = { 2, {0xc2, 0x9a, } },
+	[0x9b] = { 2, {0xc2, 0x9b, } },
+	[0x9c] = { 2, {0xc2, 0x9c, } },
+	[0x9d] = { 2, {0xc2, 0x9d, } },
+	[0x9e] = { 2, {0xc2, 0x9e, } },
+	[0x9f] = { 2, {0xc2, 0x9f, } },
+	[0xa0] = { 2, {0xc2, 0xa0, } },
+	[0xa1] = { 2, {0xc2, 0xa1, } },
+	[0xa2] = { 2, {0xc2, 0xa2, } },
+	[0xa3] = { 2, {0xc2, 0xa3, } },
+	[0xa4] = { 3, { 0xe2, 0x82, 0xac,} },		/* Euro sign. Addition over the ISO-6937 standard */
+	[0xa5] = { 2, {0xc2, 0xa5, } },
+	[0xa6] = { 0, {} },
+	[0xa7] = { 2, {0xc2, 0xa7, } },
+	[0xa8] = { 2, {0xc2, 0xa4, } },
+	[0xa9] = { 3, {0xe2, 0x80, 0x98, } },
+	[0xaa] = { 3, {0xe2, 0x80, 0x9c, } },
+	[0xab] = { 2, {0xc2, 0xab, } },
+	[0xac] = { 3, {0xe2, 0x86, 0x90, } },
+	[0xad] = { 3, {0xe2, 0x86, 0x91, } },
+	[0xae] = { 3, {0xe2, 0x86, 0x92, } },
+	[0xaf] = { 3, {0xe2, 0x86, 0x93, } },
+	[0xb0] = { 2, {0xc2, 0xb0, } },
+	[0xb1] = { 2, {0xc2, 0xb1, } },
+	[0xb2] = { 2, {0xc2, 0xb2, } },
+	[0xb3] = { 2, {0xc2, 0xb3, } },
+	[0xb4] = { 2, {0xc3, 0x97, } },
+	[0xb5] = { 2, {0xc2, 0xb5, } },
+	[0xb6] = { 2, {0xc2, 0xb6, } },
+	[0xb7] = { 2, {0xc2, 0xb7, } },
+	[0xb8] = { 2, {0xc3, 0xb7, } },
+	[0xb9] = { 3, {0xe2, 0x80, 0x99, } },
+	[0xba] = { 3, {0xe2, 0x80, 0x9d, } },
+	[0xbb] = { 2, {0xc2, 0xbb, } },
+	[0xbc] = { 2, {0xc2, 0xbc, } },
+	[0xbd] = { 2, {0xc2, 0xbd, } },
+	[0xbe] = { 2, {0xc2, 0xbe, } },
+	[0xbf] = { 2, {0xc2, 0xbf, } },
+	[0xc0] = { 0, {} },
+	[0xc1] = { 0, {} },
+	[0xc2] = { 0, {} },
+	[0xc3] = { 0, {} },
+	[0xc4] = { 0, {} },
+	[0xc5] = { 0, {} },
+	[0xc6] = { 0, {} },
+	[0xc7] = { 0, {} },
+	[0xc8] = { 0, {} },
+	[0xc9] = { 0, {} },
+	[0xca] = { 0, {} },
+	[0xcb] = { 0, {} },
+	[0xcc] = { 0, {} },
+	[0xcd] = { 0, {} },
+	[0xce] = { 0, {} },
+	[0xcf] = { 0, {} },
+	[0xd0] = { 3, {0xe2, 0x80, 0x94, } },
+	[0xd1] = { 2, {0xc2, 0xb9, } },
+	[0xd2] = { 2, {0xc2, 0xae, } },
+	[0xd3] = { 2, {0xc2, 0xa9, } },
+	[0xd4] = { 3, {0xe2, 0x84, 0xa2, } },
+	[0xd5] = { 3, {0xe2, 0x99, 0xaa, } },
+	[0xd6] = { 2, {0xc2, 0xac, } },
+	[0xd7] = { 2, {0xc2, 0xa6, } },
+	[0xd8] = { 0, {} },
+	[0xd9] = { 0, {} },
+	[0xda] = { 0, {} },
+	[0xdb] = { 0, {} },
+	[0xdc] = { 3, {0xe2, 0x85, 0x9b, } },
+	[0xdd] = { 3, {0xe2, 0x85, 0x9c, } },
+	[0xde] = { 3, {0xe2, 0x85, 0x9d, } },
+	[0xdf] = { 3, {0xe2, 0x85, 0x9e, } },
+	[0xe0] = { 3, {0xe2, 0x84, 0xa6, } },
+	[0xe1] = { 2, {0xc3, 0x86, } },
+	[0xe2] = { 2, {0xc3, 0x90, } },
+	[0xe3] = { 2, {0xc2, 0xaa, } },
+	[0xe4] = { 2, {0xc4, 0xa6, } },
+	[0xe5] = { 0, {} },
+	[0xe6] = { 2, {0xc4, 0xb2, } },
+	[0xe7] = { 2, {0xc4, 0xbf, } },
+	[0xe8] = { 2, {0xc5, 0x81, } },
+	[0xe9] = { 2, {0xc3, 0x98, } },
+	[0xea] = { 2, {0xc5, 0x92, } },
+	[0xeb] = { 2, {0xc2, 0xba, } },
+	[0xec] = { 2, {0xc3, 0x9e, } },
+	[0xed] = { 2, {0xc5, 0xa6, } },
+	[0xee] = { 2, {0xc5, 0x8a, } },
+	[0xef] = { 2, {0xc5, 0x89, } },
+	[0xf0] = { 2, {0xc4, 0xb8, } },
+	[0xf1] = { 2, {0xc3, 0xa6, } },
+	[0xf2] = { 2, {0xc4, 0x91, } },
+	[0xf3] = { 2, {0xc3, 0xb0, } },
+	[0xf4] = { 2, {0xc4, 0xa7, } },
+	[0xf5] = { 2, {0xc4, 0xb1, } },
+	[0xf6] = { 2, {0xc4, 0xb3, } },
+	[0xf7] = { 2, {0xc5, 0x80, } },
+	[0xf8] = { 2, {0xc5, 0x82, } },
+	[0xf9] = { 2, {0xc3, 0xb8, } },
+	[0xfa] = { 2, {0xc5, 0x93, } },
+	[0xfb] = { 2, {0xc3, 0x9f, } },
+	[0xfc] = { 2, {0xc3, 0xbe, } },
+	[0xfd] = { 2, {0xc5, 0xa7, } },
+	[0xfe] = { 2, {0xc5, 0x8b, } },
+	[0xff] = { 2, {0xc2, 0xad, } },
+};
+
+static void descriptorcpy(char **dest, const unsigned char *src, size_t len)
+{
+	size_t destlen, i;
+	char *p, *type = NULL;
+	unsigned char *tmp = NULL;
+	const unsigned char *s;
+	int emphasis = 0, need_conversion = 1;
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
+		case 0x00:	type = "ISO-6937";		break;
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
+	/*
+	 * Destination length should be bigger. As the worse case seems to
+	 * use 3 chars for one code, use it for destlen
+	 */
+	destlen = len * 3;
+	*dest = malloc(destlen + 1);
+
+	/* Remove special chars */
+	if (!strncasecmp(type, "ISO-8859", 8) || !strcasecmp(type, "ISO-6937")) {
+		/*
+		 * Handles the ISO/IEC 10646 1-byte control codes
+		 * (EN 300 468 v1.11.1 Table A.1)
+		 * Emphasis will be represented as: *emphased*
+		 */
+		tmp = malloc(len + 2);
+		p = (char *)tmp;
+		s = src;
+		for (i = 0; i < len; i++, s++) {
+			if (*s >= 0x20 && (*s < 0x80 || *s > 0x9f))
+				*p++ = *s;
+			else if (*s == 0x86) {
+				*p++ = '*';
+				emphasis = 1;
+			} else if (*s == 0x87 && emphasis) {
+				*p++ = '*';
+				emphasis = 0;
+			}
+		}
+		if (emphasis)
+			*p++ = '*';
+		*p = '\0';
+	} else {
+		/*
+		 * FIXME: need to handle the ISO/IEC 10646 2-byte control codes
+		 * (EN 300 468 v1.11.1 Table A.2)
+		 */
+	}
+
+	if (tmp)
+		s = tmp;
+	else
+		s = src;
+
+	p = *dest;
+	if (!strcasecmp(type, "ISO-6937")) {
+		unsigned char *p1, *p2;
+
+		/* Convert charset to UTF-8 using Code table 00 - Latin */
+		for (p1 = (unsigned char *)s; p1 < s + len; p1++)
+			for (p2 = en300468_latin_00_to_utf8[*p1].data;
+			     p2 < en300468_latin_00_to_utf8[*p1].data + en300468_latin_00_to_utf8[*p1].len;
+			     p2++)
+				*p++ = *p2;
+		*p = '\0';
+
+		/* If desired charset is not UTF-8, prepare for conversion */
+		if (strcasecmp(output_charset, "UTF-8")) {
+			if (tmp)
+				free(tmp);
+			tmp = (unsigned char *)*dest;
+			len = p - *dest;
+
+			*dest = malloc(destlen + 1);
+			type = "UTF-8";
+			s = tmp;
+		} else
+			need_conversion = 0;
+
+	}
+
+	/* Convert from original charset to the desired one */
+	if (need_conversion) {
+		char out_cs[strlen(output_charset) + 1 + sizeof(CS_OPTIONS)];
+
+		p = *dest;
+		strcpy(out_cs, output_charset);
+		strcat(out_cs, CS_OPTIONS);
+
+		iconv_t cd = iconv_open(out_cs, type);
+		if (cd == (iconv_t)(-1)) {
+			memcpy(p, s, len);
+			p[len] = '\0';
+			warning("Conversion from %s to %s not supported\n",
+				 type, output_charset);
+		} else {
+			iconv(cd, (char **)&s, &len, &p, &destlen);
+			iconv_close(cd);
+			*p = '\0';
+		}
+	}
+
+	if (tmp)
+		free(tmp);
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
@@ -2118,7 +2510,10 @@ static const char *usage = "\n"
 	"	-P do not use ATSC PSIP tables for scanning\n"
 	"	    (but only PAT and PMT) (applies for ATSC only)\n"
 	"	-A N	check for ATSC 1=Terrestrial [default], 2=Cable or 3=both\n"
-	"	-U	Uniquely name unknown services\n";
+	"	-U	Uniquely name unknown services\n"
+	"	-C cs	Override default charset for service name/provider (default = ISO-6937)\n"
+	"	-D cs	Output charset (default = UTF-8//IGNORE)\n"
+	"Supported charsets by -C/-D parameters can be obtained via 'iconv -l' command\n";
 
 void
 bad_usage(char *pname, int problem)
@@ -2166,7 +2561,7 @@ int main (int argc, char **argv)
 
 	/* start with default lnb type */
 	lnb_type = *lnb_enum(0);
-	while ((opt = getopt(argc, argv, "5cnpa:f:d:s:o:x:e:t:i:l:vquPA:U")) != -1) {
+	while ((opt = getopt(argc, argv, "5cnpa:f:d:s:o:x:e:t:i:l:vquPA:UC:D:")) != -1) {
 		switch (opt) {
 		case 'a':
 			adapter = strtoul(optarg, NULL, 0);
@@ -2246,6 +2641,12 @@ int main (int argc, char **argv)
 		case 'U':
 			unique_anon_services = 1;
 			break;
+		case 'C':
+			default_charset = optarg;
+			break;
+		case 'D':
+			output_charset = optarg;
+			break;
 		default:
 			bad_usage(argv[0], 0);
 			return -1;
