Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47897 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaHWQnJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Aug 2014 12:43:09 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so868666wib.14
        for <linux-media@vger.kernel.org>; Sat, 23 Aug 2014 09:43:08 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 4/5] libdvbv5: Make dvb_xxx_charset const strings
Date: Sat, 23 Aug 2014 18:42:42 +0200
Message-Id: <1408812163-18309-5-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
References: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/libdvbv5/parse_string.c | 13 +++++++------
 lib/libdvbv5/parse_string.h |  8 ++++----
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/lib/libdvbv5/parse_string.c b/lib/libdvbv5/parse_string.c
index db47c3a..081b2f8 100644
--- a/lib/libdvbv5/parse_string.c
+++ b/lib/libdvbv5/parse_string.c
@@ -35,8 +35,8 @@
 
 #define CS_OPTIONS "//TRANSLIT"
 
-char *dvb_default_charset = "iso-8859-1";
-char *dvb_output_charset = "utf-8";
+const char *dvb_default_charset = "iso-8859-1";
+const char *dvb_output_charset = "utf-8";
 
 struct charset_conv {
 	unsigned len;
@@ -308,7 +308,7 @@ void iconv_to_charset(struct dvb_v5_fe_parms *parms,
 		      size_t destlen,
 		      const unsigned char *src,
 		      size_t len,
-		      char *type, char *output_charset)
+		      const char *type, const char *output_charset)
 {
 	char out_cs[strlen(output_charset) + 1 + sizeof(CS_OPTIONS)];
 	char *p = dest;
@@ -331,7 +331,7 @@ void iconv_to_charset(struct dvb_v5_fe_parms *parms,
 
 static void charset_conversion(struct dvb_v5_fe_parms *parms, char **dest, const unsigned char *s,
 			       size_t len,
-			       char *type, char *output_charset)
+			       const char *type, const char *output_charset)
 {
 	size_t destlen = len * 3;
 	int need_conversion = 1;
@@ -371,10 +371,11 @@ static void charset_conversion(struct dvb_v5_fe_parms *parms, char **dest, const
 
 void parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 		  const unsigned char *src, size_t len,
-		  char *default_charset, char *output_charset)
+		  const char *default_charset, const char *output_charset)
 {
 	size_t destlen, i, len2 = 0;
-	char *p, *p2, *type = default_charset;
+	char *p, *p2;
+	const char *type = default_charset;
 	unsigned char *tmp1 = NULL, *tmp2 = NULL;
 	const unsigned char *s;
 	int emphasis = 0;
diff --git a/lib/libdvbv5/parse_string.h b/lib/libdvbv5/parse_string.h
index e269ff3..48ae6ec 100644
--- a/lib/libdvbv5/parse_string.h
+++ b/lib/libdvbv5/parse_string.h
@@ -28,14 +28,14 @@ void iconv_to_charset(struct dvb_v5_fe_parms *parms,
 		      size_t destlen,
 		      const unsigned char *src,
 		      size_t len,
-		      char *type, char *output_charset);
+		      const char *type, const char *output_charset);
 
 void parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 		  const unsigned char *src, size_t len,
-		  char *default_charset, char *output_charset);
+		  const char *default_charset, const char *output_charset);
 
-extern char *dvb_default_charset;
-extern char *dvb_output_charset;
+extern const char *dvb_default_charset;
+extern const char *dvb_output_charset;
 
 #if HAVE_VISIBILITY
 #pragma GCC visibility pop
-- 
2.1.0

