Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:50995 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbcGAL03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 07:26:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cec: add missing inline stubs
Date: Fri,  1 Jul 2016 13:19:56 +0200
Message-Id: <20160701112027.102024-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The linux/cec.h header file contains empty inline definitions for
a subset of the API for the case in which CEC is not enabled,
however we have driver that call other functions as well:

drivers/media/i2c/adv7604.c: In function 'adv76xx_cec_tx_raw_status':
drivers/media/i2c/adv7604.c:1956:3: error: implicit declaration of function 'cec_transmit_done' [-Werror=implicit-function-declaration]
drivers/media/i2c/adv7604.c: In function 'adv76xx_cec_isr':
drivers/media/i2c/adv7604.c:2012:4: error: implicit declaration of function 'cec_received_msg' [-Werror=implicit-function-declaration]
drivers/media/i2c/adv7604.c: In function 'adv76xx_probe':
drivers/media/i2c/adv7604.c:3482:20: error: implicit declaration of function 'cec_allocate_adapter' [-Werror=implicit-function-declaration]

This adds stubs for the remaining interfaces as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/media/cec.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/media/cec.h b/include/media/cec.h
index 9a791c08a789..c462f9b44074 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -208,6 +208,12 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
 
 #else
+static inline struct cec_adapter *cec_allocate_adapter(
+		const struct cec_adap_ops *ops, void *priv, const char *name,
+		u32 caps, u8 available_las, struct device *parent)
+{
+	return NULL;
+}
 
 static inline int cec_register_adapter(struct cec_adapter *adap)
 {
@@ -227,6 +233,25 @@ static inline void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
 {
 }
 
+static inline int cec_transmit_msg(struct cec_adapter *adap,
+				   struct cec_msg *msg, bool block)
+{
+	return 0;
+}
+
+/* Called by the adapter */
+static inline void cec_transmit_done(struct cec_adapter *adap, u8 status,
+				     u8 arb_lost_cnt, u8 nack_cnt,
+				     u8 low_drive_cnt, u8 error_cnt)
+{
+}
+
+static inline void cec_received_msg(struct cec_adapter *adap,
+				    struct cec_msg *msg)
+{
+}
+
+
 #endif
 
 #endif /* _MEDIA_CEC_H */
-- 
2.9.0

