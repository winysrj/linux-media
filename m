Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32708.mail.mud.yahoo.com ([68.142.207.252]:34236 "HELO
	web32708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750943Ab0BKFu6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 00:50:58 -0500
Message-ID: <251005.1068.qm@web32708.mail.mud.yahoo.com>
Date: Wed, 10 Feb 2010 21:50:56 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: [Patch/Resend] Kworld 315U remote support
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Douglas Schilling <dougsland@gmail.com>,
	maillist <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds remote support for the Kworld 315U device

I have added the change for the IR_TYPE_NEC that Mauro suggested.  

Note: I believe I got most of the mappings correct.  Though the
source and shutdown button probably could be mapped to something
better. 

To be done: Still need to get the Kworld analog patch resubmitted.
There are still some stuff I want to test with the analog patch before
I resubmit it.  Hopefully this patch will work ok.

Please let me know if there are any issues applying the patch


Signed-off-by: Franklin Meng <fmeng2002@yahoo.com>

diff -r 28f5eca12bb0 linux/drivers/media/IR/ir-keymaps.c
--- a/linux/drivers/media/IR/ir-keymaps.c    Sat Feb 06 23:49:31 2010 -0200
+++ b/linux/drivers/media/IR/ir-keymaps.c    Wed Feb 10 21:43:49 2010 -0800
@@ -3501,3 +3501,53 @@
     .size = ARRAY_SIZE(ir_codes_winfast_usbii_deluxe),
 };
 EXPORT_SYMBOL_GPL(ir_codes_winfast_usbii_deluxe_table);
+
+/* Kworld 315U
+*/
+static struct ir_scancode ir_codes_kworld_315u[] = {
+    { 0x6143, KEY_POWER },
+    { 0x6101, KEY_TUNER },    /* source */
+    { 0x610b, KEY_ZOOM },
+    { 0x6103, KEY_POWER2 },    /* shutdown */
+
+    { 0x6104, KEY_1 },
+    { 0x6108, KEY_2 },
+    { 0x6102, KEY_3 },
+    { 0x6109, KEY_CHANNELUP },
+
+    { 0x610f, KEY_4 },
+    { 0x6105, KEY_5 },
+    { 0x6106, KEY_6 },
+    { 0x6107, KEY_CHANNELDOWN },
+
+    { 0x610c, KEY_7 },
+    { 0x610d, KEY_8 },
+    { 0x610a, KEY_9 },
+    { 0x610e, KEY_VOLUMEUP },
+
+    { 0x6110, KEY_LAST },
+    { 0x6111, KEY_0 },
+    { 0x6112, KEY_ENTER },
+    { 0x6113, KEY_VOLUMEDOWN },
+
+    { 0x6114, KEY_RECORD },
+    { 0x6115, KEY_STOP },
+    { 0x6116, KEY_PLAY },
+    { 0x6117, KEY_MUTE },
+
+    { 0x6118, KEY_UP },
+    { 0x6119, KEY_DOWN },
+    { 0x611a, KEY_LEFT },
+    { 0x611b, KEY_RIGHT },
+
+    { 0x611c, KEY_RED },
+    { 0x611d, KEY_GREEN },
+    { 0x611e, KEY_YELLOW },
+    { 0x611f, KEY_BLUE },
+};
+struct ir_scancode_table ir_codes_kworld_315u_table = {
+    .scan = ir_codes_kworld_315u,
+    .size = ARRAY_SIZE(ir_codes_kworld_315u),
+    .ir_type = IR_TYPE_NEC,
+};
+EXPORT_SYMBOL_GPL(ir_codes_kworld_315u_table);




      
