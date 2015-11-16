Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37022 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbKPTyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 14:54:07 -0500
Received: by wmww144 with SMTP id w144so135108721wmw.0
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 11:54:06 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 4/8] media: rc: load decoder modules on-demand
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <564A33FA.5050407@gmail.com>
Date: Mon, 16 Nov 2015 20:52:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove code for unconditional decoder module loading (except lirc).

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-core-priv.h | 64 -----------------------------------------
 drivers/media/rc/rc-ir-raw.c    | 10 -------
 2 files changed, 74 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index b68d4f7..071651a 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -167,62 +167,6 @@ void ir_raw_init(void);
  * loads the compiled decoders for their usage with IR raw events
  */
 
-/* from ir-nec-decoder.c */
-#ifdef CONFIG_IR_NEC_DECODER_MODULE
-#define load_nec_decode()	request_module_nowait("ir-nec-decoder")
-#else
-static inline void load_nec_decode(void) { }
-#endif
-
-/* from ir-rc5-decoder.c */
-#ifdef CONFIG_IR_RC5_DECODER_MODULE
-#define load_rc5_decode()	request_module_nowait("ir-rc5-decoder")
-#else
-static inline void load_rc5_decode(void) { }
-#endif
-
-/* from ir-rc6-decoder.c */
-#ifdef CONFIG_IR_RC6_DECODER_MODULE
-#define load_rc6_decode()	request_module_nowait("ir-rc6-decoder")
-#else
-static inline void load_rc6_decode(void) { }
-#endif
-
-/* from ir-jvc-decoder.c */
-#ifdef CONFIG_IR_JVC_DECODER_MODULE
-#define load_jvc_decode()	request_module_nowait("ir-jvc-decoder")
-#else
-static inline void load_jvc_decode(void) { }
-#endif
-
-/* from ir-sony-decoder.c */
-#ifdef CONFIG_IR_SONY_DECODER_MODULE
-#define load_sony_decode()	request_module_nowait("ir-sony-decoder")
-#else
-static inline void load_sony_decode(void) { }
-#endif
-
-/* from ir-sanyo-decoder.c */
-#ifdef CONFIG_IR_SANYO_DECODER_MODULE
-#define load_sanyo_decode()	request_module_nowait("ir-sanyo-decoder")
-#else
-static inline void load_sanyo_decode(void) { }
-#endif
-
-/* from ir-sharp-decoder.c */
-#ifdef CONFIG_IR_SHARP_DECODER_MODULE
-#define load_sharp_decode()	request_module_nowait("ir-sharp-decoder")
-#else
-static inline void load_sharp_decode(void) { }
-#endif
-
-/* from ir-mce_kbd-decoder.c */
-#ifdef CONFIG_IR_MCE_KBD_DECODER_MODULE
-#define load_mce_kbd_decode()	request_module_nowait("ir-mce_kbd-decoder")
-#else
-static inline void load_mce_kbd_decode(void) { }
-#endif
-
 /* from ir-lirc-codec.c */
 #ifdef CONFIG_IR_LIRC_CODEC_MODULE
 #define load_lirc_codec()	request_module_nowait("ir-lirc-codec")
@@ -230,12 +174,4 @@ static inline void load_mce_kbd_decode(void) { }
 static inline void load_lirc_codec(void) { }
 #endif
 
-/* from ir-xmp-decoder.c */
-#ifdef CONFIG_IR_XMP_DECODER_MODULE
-#define load_xmp_decode()      request_module_nowait("ir-xmp-decoder")
-#else
-static inline void load_xmp_decode(void) { }
-#endif
-
-
 #endif /* _RC_CORE_PRIV */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 5cfb61f..763f8a8 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -362,17 +362,7 @@ EXPORT_SYMBOL(ir_raw_handler_unregister);
 void ir_raw_init(void)
 {
 	/* Load the decoder modules */
-
-	load_nec_decode();
-	load_rc5_decode();
-	load_rc6_decode();
-	load_jvc_decode();
-	load_sony_decode();
-	load_sanyo_decode();
-	load_sharp_decode();
-	load_mce_kbd_decode();
 	load_lirc_codec();
-	load_xmp_decode();
 
 	/* If needed, we may later add some init code. In this case,
 	   it is needed to change the CONFIG_MODULE test at rc-core.h
-- 
2.6.2

