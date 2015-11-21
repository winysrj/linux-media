Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37240 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760545AbbKUPcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2015 10:32:36 -0500
Received: by wmww144 with SMTP id w144so55015413wmw.0
        for <linux-media@vger.kernel.org>; Sat, 21 Nov 2015 07:32:34 -0800 (PST)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/2] media: rc: remove unneeded code
Message-ID: <565085C7.2020208@gmail.com>
Date: Sat, 21 Nov 2015 15:55:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that that the decoder modules are loaded on-demand we can move
loading the lirc module to rc_register_device directly and remove
unneeded functions and comments.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-core-priv.h |  7 -------
 drivers/media/rc/rc-ir-raw.c    | 10 ----------
 drivers/media/rc/rc-main.c      |  4 +---
 3 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 071651a..7359f3d 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -167,11 +167,4 @@ void ir_raw_init(void);
  * loads the compiled decoders for their usage with IR raw events
  */
 
-/* from ir-lirc-codec.c */
-#ifdef CONFIG_IR_LIRC_CODEC_MODULE
-#define load_lirc_codec()	request_module_nowait("ir-lirc-codec")
-#else
-static inline void load_lirc_codec(void) { }
-#endif
-
 #endif /* _RC_CORE_PRIV */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index c6433e8..c69807f 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -360,13 +360,3 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 	mutex_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
-
-void ir_raw_init(void)
-{
-	/* Load the decoder modules */
-	load_lirc_codec();
-
-	/* If needed, we may later add some init code. In this case,
-	   it is needed to change the CONFIG_MODULE test at rc-core.h
-	 */
-}
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 9d05d03..1042fa3 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1471,10 +1471,8 @@ int rc_register_device(struct rc_dev *dev)
 	kfree(path);
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
-		/* Load raw decoders, if they aren't already */
 		if (!raw_init) {
-			IR_dprintk(1, "Loading raw decoders\n");
-			ir_raw_init();
+			request_module_nowait("ir-lirc-codec");
 			raw_init = true;
 		}
 		/* calls ir_register_device so unlock mutex here*/
-- 
2.6.2

