Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32708.mail.mud.yahoo.com ([68.142.207.252]:25193 "HELO
	web32708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750799Ab0BMFhS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 00:37:18 -0500
Message-ID: <937956.58819.qm@web32708.mail.mud.yahoo.com>
Date: Fri, 12 Feb 2010 21:37:15 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: [Patch] Kworld 315U remote support part2
To: Douglas Schilling <dougsland@gmail.com>,
	maillist <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is the rest of the patch for the Kworld remote support.

Hopefully I got all the formatting correct this time.   

Signed-off-by: Franklin Meng <fmeng2002@yahoo.com>

diff -r 14021dfc00f3 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Thu Feb 11 23:11:30 2010 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Fri Feb 12 21:31:41 2010 -0800
@@ -1329,6 +1329,7 @@
 		.decoder	= EM28XX_SAA711X,
 		.has_dvb	= 1,
 		.dvb_gpio	= em2882_kworld_315u_digital,
+		.ir_codes	= &ir_codes_kworld_315u_table,
 		.xclk		= EM28XX_XCLK_FREQUENCY_12MHZ,
 		.i2c_speed	= EM28XX_I2C_CLK_WAIT_ENABLE,
 		/* Analog mode - still not ready */
diff -r 14021dfc00f3 linux/include/media/ir-common.h
--- a/linux/include/media/ir-common.h	Thu Feb 11 23:11:30 2010 -0200
+++ b/linux/include/media/ir-common.h	Fri Feb 12 21:31:41 2010 -0800
@@ -163,4 +163,5 @@
 extern struct ir_scancode_table ir_codes_gadmei_rm008z_table;
 extern struct ir_scancode_table ir_codes_nec_terratec_cinergy_xs_table;
 extern struct ir_scancode_table ir_codes_winfast_usbii_deluxe_table;
+extern struct ir_scancode_table ir_codes_kworld_315u_table;
 #endif



      
