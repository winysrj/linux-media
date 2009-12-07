Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43307 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbZLGCAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 21:00:04 -0500
Received: by bwz27 with SMTP id 27so3176765bwz.21
        for <linux-media@vger.kernel.org>; Sun, 06 Dec 2009 18:00:09 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>
Subject: Success for Compro E650F analog television and alsa sound.
Date: Mon, 7 Dec 2009 04:00:03 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912070400.03469.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve

I'm able to watch now analog television with Compro E650F.
I rich this by merging your cx23885-alsa tree and adding some modifications
for Compro card definition.
Actually, I take it from Mygica definition, only tuner type and DVB port is different.
Tested with Tvtime.

tvtime | arecord -D hw:2,0 -r 32000 -c 2 -f S16_LE | aplay -

My tv card is third for alsa, so parameter -D for arecord is hw:2,0.
SECAM works well also.
I didn't test component input, though it present in my card.

diff -r 121066e283e5 linux/drivers/media/video/cx23885/Kconfig
--- a/linux/drivers/media/video/cx23885/Kconfig	Sun Dec 06 09:32:49 2009 -0200
+++ b/linux/drivers/media/video/cx23885/Kconfig	Mon Dec 07 03:48:12 2009 +0200
@@ -1,6 +1,7 @@
 config VIDEO_CX23885
 	tristate "Conexant cx23885 (2388x successor) support"
-	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && SND
+	select SND_PCM
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TUNER
diff -r 121066e283e5 linux/drivers/media/video/cx23885/cx23885-cards.c
--- a/linux/drivers/media/video/cx23885/cx23885-cards.c	Sun Dec 06 09:32:49 2009 -0200
+++ b/linux/drivers/media/video/cx23885/cx23885-cards.c	Mon Dec 07 03:48:12 2009 +0200
@@ -163,7 +163,29 @@
 	},
 	[CX23885_BOARD_COMPRO_VIDEOMATE_E650F] = {
 		.name		= "Compro VideoMate E650F",
+		.porta		= CX23885_ANALOG_VIDEO,
 		.portc		= CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_XC2028,
+		.tuner_addr	= 0x61,
+		.input		= {
+			{
+				.type   = CX23885_VMUX_TELEVISION,
+				.vmux   = CX25840_COMPOSITE2,
+			}, {
+				.type   = CX23885_VMUX_COMPOSITE1,
+				.vmux   = CX25840_COMPOSITE8,
+			}, {
+				.type   = CX23885_VMUX_SVIDEO,
+				.vmux   = CX25840_SVIDEO_LUMA3 |
+					CX25840_SVIDEO_CHROMA4,
+			}, {
+				.type   = CX23885_VMUX_COMPONENT,
+				.vmux   = CX25840_COMPONENT_ON |
+					CX25840_VIN1_CH1 |
+					CX25840_VIN6_CH2 |
+					CX25840_VIN7_CH3,
+			},
+		},
 	},
 	[CX23885_BOARD_TBS_6920] = {
 		.name		= "TurboSight TBS 6920",

