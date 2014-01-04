Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:49388 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaADRIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:08:41 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so7258616eaj.12
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 09:08:40 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 01/11] libdvbv5: fix dvb_parse_descriptors and make dvb_desc_init private
Date: Sat,  4 Jan 2014 18:07:51 +0100
Message-Id: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/descriptors.h |    2 --
 lib/libdvbv5/descriptors.c         |   44 ++++++++++++++++++------------------
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index 6f89aeb..36bcc61 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -78,8 +78,6 @@ void dvb_desc_default_print  (struct dvb_v5_fe_parms *parms, const struct dvb_de
 	for( _struct *_desc = (_struct *) _tbl->descriptor; _desc; _desc = (_struct *) _desc->next ) \
 		if(_desc->type == _type) \
 
-ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc);
-
 uint32_t bcd(uint32_t bcd);
 
 void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len);
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index a2176b4..626f81d 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -56,12 +56,11 @@
 #include <libdvbv5/desc_partial_reception.h>
 #include <libdvbv5/desc_extension.h>
 
-ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc)
+static void dvb_desc_init(uint8_t type, uint8_t length, struct dvb_desc *desc)
 {
-	desc->type   = buf[0];
-	desc->length = buf[1];
+	desc->type   = type;
+	desc->length = length;
 	desc->next   = NULL;
-	return 2;
 }
 
 void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
@@ -94,16 +93,27 @@ char *default_charset = "iso-8859-1";
 char *output_charset = "utf-8";
 
 void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			   uint16_t section_length, struct dvb_desc **head_desc)
+			   uint16_t buflen, struct dvb_desc **head_desc)
 {
-	const uint8_t *ptr = buf;
+	const uint8_t *ptr = buf, *endbuf = buf + buflen;
 	struct dvb_desc *current = NULL;
 	struct dvb_desc *last = NULL;
-	while (ptr < buf + section_length) {
-		unsigned desc_type = ptr[0];
-		int desc_len  = ptr[1];
+
+	*head_desc = NULL;
+
+	while (ptr + 2 <= endbuf ) {
+		uint8_t desc_type = ptr[0];
+		uint8_t desc_len  = ptr[1];
 		size_t size;
 
+		ptr += 2; /* skip type and length */
+
+		if (ptr + desc_len > endbuf) {
+			dvb_logerr("short read of %zd/%d bytes parsing descriptor %#02x",
+				   endbuf - ptr, desc_len, desc_type);
+			return;
+		}
+
 		switch (parms->verbose) {
 		case 0:
 		case 1:
@@ -119,11 +129,6 @@ void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			hexdump(parms, "content: ", ptr + 2, desc_len);
 		}
 
-		if (desc_len > section_length - 2) {
-			dvb_logwarn("descriptor type %0x02x is too big",
-				   desc_type);
-			return;
-		}
 
 		dvb_desc_init_func init = dvb_descriptors[desc_type].init;
 		if (!init) {
@@ -133,21 +138,16 @@ void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			size = dvb_descriptors[desc_type].size;
 		}
 		if (!size) {
-			dvb_logwarn("descriptor type 0x%02x has no size defined", desc_type);
-			size = 4096;
-		}
-		if (ptr + 2 >=  buf + section_length) {
-			dvb_logwarn("descriptor type 0x%02x is truncated: desc len %d, section len %zd",
-				   desc_type, desc_len, section_length - (ptr - buf));
+			dvb_logerr("descriptor type 0x%02x has no size defined", desc_type);
 			return;
 		}
 
-		current = calloc(1, size);
+		current = malloc(size);
 		if (!current) {
 			dvb_perror("Out of memory");
 			return;
 		}
-		ptr += dvb_desc_init(ptr, current); /* the standard header was read */
+		dvb_desc_init(desc_type, desc_len, current); /* initialize the standard header */
 		init(parms, ptr, current);
 		if (!*head_desc)
 			*head_desc = current;
-- 
1.7.10.4

