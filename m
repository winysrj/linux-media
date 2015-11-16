Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37112 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbKPTyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 14:54:13 -0500
Received: by wmww144 with SMTP id w144so135112132wmw.0
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 11:54:12 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 8/8] media: rc: define RC_BIT_ALL as ~0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <564A3450.4040800@gmail.com>
Date: Mon, 16 Nov 2015 20:53:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RC_BIT_ALL explicitely lists each single currently defined protocol bit.
To simplify the code and make adding a protocol easier set each bit
no matter whether the respective protocol is defined yet.

RC_BIT_ALL is only used in checks whether a particular protocol is allowed
therefore it has no impact if bits for not (yet) defined protocols
are set.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-main.c |  1 -
 include/media/rc-map.h     | 10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index d1611f1..d7055e1 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1447,7 +1447,6 @@ int rc_register_device(struct rc_dev *dev)
 	kfree(path);
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
-		dev->allowed_protocols |= RC_BIT_LIRC;
 		/* calls ir_register_device so unlock mutex here*/
 		mutex_unlock(&dev->lock);
 		rc = ir_raw_event_register(dev);
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 7844e98..27aaf6b 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -54,15 +54,7 @@ enum rc_type {
 #define RC_BIT_SHARP		(1ULL << RC_TYPE_SHARP)
 #define RC_BIT_XMP		(1ULL << RC_TYPE_XMP)
 
-#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | \
-			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
-			 RC_BIT_JVC | \
-			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
-			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
-			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
-			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
-			 RC_BIT_XMP)
-
+#define RC_BIT_ALL		~RC_BIT_NONE
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
 #define RC_SCANCODE_OTHER(x)			(x)
-- 
2.6.2

