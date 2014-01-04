Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:32938 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbaADRIq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:08:46 -0500
Received: by mail-ea0-f182.google.com with SMTP id a15so7263511eae.27
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 09:08:45 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 08/11] libdvbv5: make dvb_desc_default_init and dvb_desc_default_print private
Date: Sat,  4 Jan 2014 18:07:58 +0100
Message-Id: <1388855282-19295-8-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
References: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/descriptors.h |   16 ++++++++--------
 lib/libdvbv5/descriptors.c         |    4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index ae33fda..d5feb4f 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -65,14 +65,6 @@ struct dvb_desc {
 	uint8_t data[];
 } __attribute__((packed));
 
-void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-#ifdef __cplusplus
-extern "C" {
-#endif
-void dvb_desc_default_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
-#ifdef __cplusplus
-}
-#endif
 
 #define dvb_desc_foreach( _desc, _tbl ) \
 	for( struct dvb_desc *_desc = _tbl->descriptor; _desc; _desc = _desc->next ) \
@@ -81,6 +73,10 @@ void dvb_desc_default_print  (struct dvb_v5_fe_parms *parms, const struct dvb_de
 	for( _struct *_desc = (_struct *) _tbl->descriptor; _desc; _desc = (_struct *) _desc->next ) \
 		if(_desc->type == _type) \
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 uint32_t bcd(uint32_t bcd);
 
 void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len);
@@ -89,6 +85,10 @@ void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ui
 void dvb_free_descriptors(struct dvb_desc **list);
 void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc);
 
+#ifdef __cplusplus
+}
+#endif
+
 struct dvb_v5_fe_parms;
 
 typedef void (*dvb_desc_init_func) (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 4bf9d59..48f3fe7 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -66,12 +66,12 @@ static void dvb_desc_init(uint8_t type, uint8_t length, struct dvb_desc *desc)
 	desc->next   = NULL;
 }
 
-void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+static void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	memcpy(desc->data, buf, desc->length);
 }
 
-void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+static void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	if (!parms)
 		parms = dvb_fe_dummy();
-- 
1.7.10.4

