Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56786 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbaBEWPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 17:15:30 -0500
Received: by mail-wi0-f179.google.com with SMTP id hn9so1028015wib.6
        for <linux-media@vger.kernel.org>; Wed, 05 Feb 2014 14:15:28 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] rc: ir-raw: Load ir-sharp-decoder module at init
Date: Wed,  5 Feb 2014 22:15:16 +0000
Message-Id: <1391638516-23952-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 1d184b0bc13d ([media] media: rc: add raw decoder for Sharp
protocol) added a new raw IR decoder for the sharp protocol, but didn't
add the code to load the module at init as is done for other raw
decoders, so add that code now.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
I'm not sure if the media tree gets rebased, but if so this could
happily be squashed into the sharp decoder commit.
---
 drivers/media/rc/ir-raw.c       | 1 +
 drivers/media/rc/rc-core-priv.h | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 5c42750..79a9cb6 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -352,6 +352,7 @@ void ir_raw_init(void)
 	load_jvc_decode();
 	load_sony_decode();
 	load_sanyo_decode();
+	load_sharp_decode();
 	load_mce_kbd_decode();
 	load_lirc_codec();
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index c40d666..dc3b0b7 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -210,6 +210,13 @@ static inline void load_sony_decode(void) { }
 static inline void load_sanyo_decode(void) { }
 #endif
 
+/* from ir-sharp-decoder.c */
+#ifdef CONFIG_IR_SHARP_DECODER_MODULE
+#define load_sharp_decode()	request_module_nowait("ir-sharp-decoder")
+#else
+static inline void load_sharp_decode(void) { }
+#endif
+
 /* from ir-mce_kbd-decoder.c */
 #ifdef CONFIG_IR_MCE_KBD_DECODER_MODULE
 #define load_mce_kbd_decode()	request_module_nowait("ir-mce_kbd-decoder")
-- 
1.8.3.2

