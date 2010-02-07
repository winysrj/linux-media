Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32702.mail.mud.yahoo.com ([68.142.207.246]:43573 "HELO
	web32702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750764Ab0BGTxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 14:53:16 -0500
Message-ID: <19431.32442.qm@web32702.mail.mud.yahoo.com>
Date: Sun, 7 Feb 2010 11:53:15 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: [Patch] Kworld 315U remote support
To: Douglas Schilling <dougsland@gmail.com>,
	maillist <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds remote support for the Kworld 315U device

Note: I believe I got most of the mappings correct.  Though the
source and shutdown button probably could be mapped to something
better.  

To be done: Still need to get the Kworld analog patch resubmitted.
There are still some stuff I want to test with the analog patch before
I resubmit it.  Hopefully this patch will work ok.

Please let me know if there are any issues applying the patch

Signed-off-by: Franklin Meng <fmeng2002@yahoo.com>

diff -r 28f5eca12bb0 linux/drivers/media/IR/ir-keymaps.c
--- a/linux/drivers/media/IR/ir-keymaps.c	Sat Feb 06 23:49:31 2010 -0200
+++ b/linux/drivers/media/IR/ir-keymaps.c	Sun Feb 07 11:35:39 2010 -0800
@@ -3501,3 +3501,52 @@
 	.size = ARRAY_SIZE(ir_codes_winfast_usbii_deluxe),
 };
 EXPORT_SYMBOL_GPL(ir_codes_winfast_usbii_deluxe_table);
+
+/* Kworld 315U
+*/
+static struct ir_scancode ir_codes_kworld_315u[] = {
+	{ 0x43, KEY_POWER },
+	{ 0x01, KEY_TUNER },	/* source */
+	{ 0x0b, KEY_ZOOM },
+	{ 0x03, KEY_POWER2 },	/* shutdown */
+
+	{ 0x04, KEY_1 },
+	{ 0x08, KEY_2 },
+	{ 0x02, KEY_3 },
+	{ 0x09, KEY_CHANNELUP },
+
+	{ 0x0f, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_CHANNELDOWN },
+
+	{ 0x0c, KEY_7 },
+	{ 0x0d, KEY_8 },
+	{ 0x0a, KEY_9 },
+	{ 0x0e, KEY_VOLUMEUP },
+
+	{ 0x10, KEY_LAST },
+	{ 0x11, KEY_0 },
+	{ 0x12, KEY_ENTER },
+	{ 0x13, KEY_VOLUMEDOWN },
+
+	{ 0x14, KEY_RECORD },
+	{ 0x15, KEY_STOP },
+	{ 0x16, KEY_PLAY },
+	{ 0x17, KEY_MUTE },
+
+	{ 0x18, KEY_UP },
+	{ 0x19, KEY_DOWN },
+	{ 0x1a, KEY_LEFT },
+	{ 0x1b, KEY_RIGHT },
+
+	{ 0x1c, KEY_RED },
+	{ 0x1d, KEY_GREEN },
+	{ 0x1e, KEY_YELLOW },
+	{ 0x1f, KEY_BLUE },
+};
+struct ir_scancode_table ir_codes_kworld_315u_table = {
+	.scan = ir_codes_kworld_315u,
+	.size = ARRAY_SIZE(ir_codes_kworld_315u),
+};
+EXPORT_SYMBOL_GPL(ir_codes_kworld_315u_table);
diff -r 28f5eca12bb0 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Feb 06 23:49:31 2010 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sun Feb 07 11:35:39 2010 -0800
@@ -1322,6 +1322,7 @@
 		.tda9887_conf	= TDA9887_PRESENT,
 		.decoder	= EM28XX_SAA711X,
 		.has_dvb	= 1,
+		.ir_codes	= &ir_codes_kworld_315u_table,
 		.dvb_gpio	= em2882_kworld_315u_digital,
 		.xclk		= EM28XX_XCLK_FREQUENCY_12MHZ,
 		.i2c_speed	= EM28XX_I2C_CLK_WAIT_ENABLE,
diff -r 28f5eca12bb0 linux/include/media/ir-common.h
--- a/linux/include/media/ir-common.h	Sat Feb 06 23:49:31 2010 -0200
+++ b/linux/include/media/ir-common.h	Sun Feb 07 11:35:39 2010 -0800
@@ -163,4 +163,5 @@
 extern struct ir_scancode_table ir_codes_gadmei_rm008z_table;
 extern struct ir_scancode_table ir_codes_nec_terratec_cinergy_xs_table;
 extern struct ir_scancode_table ir_codes_winfast_usbii_deluxe_table;
+extern struct ir_scancode_table ir_codes_kworld_315u_table;
 #endif




      
