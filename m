Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63269 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaC3QVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 12:21:54 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so5862208eei.0
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 09:21:52 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/8] libdvbv5: make dvb_desc_default_init and dvb_desc_default_print private
Date: Sun, 30 Mar 2014 18:21:13 +0200
Message-Id: <1396196478-996-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1396196478-996-1-git-send-email-neolynx@gmail.com>
References: <1396196478-996-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_desc_default_init and dvb_desc_default_print are used
internaly only, remove them from the header file.
add extern "C" to the parser functions, so they can be used
from C++ directly.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/descriptors.h | 16 ++++++++--------
 lib/libdvbv5/descriptors.c         |  4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index b869a14..1ea0957 100644
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
index 4694b98..86bc7af 100644
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
1.8.3.2

