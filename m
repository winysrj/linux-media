Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:35256 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1FGQRF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 12:17:05 -0400
Received: from [94.248.227.150] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QTyxd-0006Ur-BJ
	for linux-media@vger.kernel.org; Tue, 07 Jun 2011 18:17:03 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] cx88: added support for Leadtek WinFast DTV1800 H with XC4000 tuner
MIME-Version: 1.0
Date: Tue, 7 Jun 2011 18:16:56 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071816.56902.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch implements support for the Leadtek WinFast DTV1800 H card with
XC4000 tuner (107d:6f38).

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-cards.c xc4000/drivers/media/video/cx88/cx88-cards.c
--- xc4000_orig/drivers/media/video/cx88/cx88-cards.c	2011-06-07 17:42:58.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-cards.c	2011-06-07 18:01:53.000000000 +0200
@@ -2120,6 +2120,47 @@
 		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_WINFAST_DTV1800H_XC4000] = {
+		.name		= "Leadtek WinFast DTV1800 H (XC4000)",
+		.tuner_type	= TUNER_XC4000,
+		.radio_type	= TUNER_XC4000,
+		.tuner_addr	= 0x61,
+		.radio_addr	= 0x61,
+		/*
+		 * GPIO setting
+		 *
+		 *  2: mute (0=off,1=on)
+		 * 12: tuner reset pin
+		 * 13: audio source (0=tuner audio,1=line in)
+		 * 14: FM (0=on,1=off ???)
+		 */
+		.input		= {{
+			.type	= CX88_VMUX_TELEVISION,
+			.vmux	= 0,
+			.gpio0	= 0x0400,	/* pin 2 = 0 */
+			.gpio1	= 0x6040,	/* pin 13 = 0, pin 14 = 1 */
+			.gpio2	= 0x0000,
+		}, {
+			.type	= CX88_VMUX_COMPOSITE1,
+			.vmux	= 1,
+			.gpio0	= 0x0400,	/* pin 2 = 0 */
+			.gpio1	= 0x6060,	/* pin 13 = 1, pin 14 = 1 */
+			.gpio2	= 0x0000,
+		}, {
+			.type	= CX88_VMUX_SVIDEO,
+			.vmux	= 2,
+			.gpio0	= 0x0400,	/* pin 2 = 0 */
+			.gpio1	= 0x6060,	/* pin 13 = 1, pin 14 = 1 */
+			.gpio2	= 0x0000,
+		}},
+		.radio = {
+			.type	= CX88_RADIO,
+			.gpio0	= 0x0400,	/* pin 2 = 0 */
+			.gpio1	= 0x6000,	/* pin 13 = 0, pin 14 = 0 */
+			.gpio2	= 0x0000,
+		},
+		.mpeg		= CX88_MPEG_DVB,
+	},
 	[CX88_BOARD_WINFAST_DTV2000H_PLUS] = {
 		.name		= "Leadtek WinFast DTV2000 H PLUS",
 		.tuner_type	= TUNER_XC4000,
@@ -2634,6 +2675,11 @@
 		.subdevice = 0x6654,
 		.card      = CX88_BOARD_WINFAST_DTV1800H,
 	}, {
+		/* WinFast DTV1800 H with XC4000 tuner */
+		.subvendor = 0x107d,
+		.subdevice = 0x6f38,
+		.card      = CX88_BOARD_WINFAST_DTV1800H_XC4000,
+	}, {
 		.subvendor = 0x107d,
 		.subdevice = 0x6f42,
 		.card      = CX88_BOARD_WINFAST_DTV2000H_PLUS,
@@ -3027,6 +3073,7 @@
 {
 	/* Board-specific callbacks */
 	switch (core->boardnr) {
+	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
 	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 		return cx88_xc4000_winfast2000h_plus_callback(core,
 							      command, arg);
@@ -3207,6 +3254,7 @@
 		mdelay(50);
 		break;
 
+	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
 	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 		cx88_xc4000_winfast2000h_plus_callback(core,
 						       XC4000_TUNER_RESET, 0);
diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-dvb.c xc4000/drivers/media/video/cx88/cx88-dvb.c
--- xc4000_orig/drivers/media/video/cx88/cx88-dvb.c	2011-06-07 17:42:58.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-dvb.c	2011-06-07 17:56:07.000000000 +0200
@@ -1328,6 +1328,7 @@
 				goto frontend_detach;
 		}
 		break;
+	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
 	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &cx88_pinnacle_hybrid_pctv,
diff -uNr xc4000_orig/drivers/media/video/cx88/cx88.h xc4000/drivers/media/video/cx88/cx88.h
--- xc4000_orig/drivers/media/video/cx88/cx88.h	2011-06-07 17:42:58.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88.h	2011-06-07 17:56:39.000000000 +0200
@@ -243,6 +243,7 @@
 #define CX88_BOARD_TWINHAN_VP1027_DVBS     85
 #define CX88_BOARD_TEVII_S464              86
 #define CX88_BOARD_WINFAST_DTV2000H_PLUS   87
+#define CX88_BOARD_WINFAST_DTV1800H_XC4000 88
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-input.c xc4000/drivers/media/video/cx88/cx88-input.c
--- xc4000_orig/drivers/media/video/cx88/cx88-input.c	2011-06-07 17:42:58.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-input.c	2011-06-07 17:57:30.000000000 +0200
@@ -100,6 +100,7 @@
 		break;
 	case CX88_BOARD_WINFAST_DTV1000:
 	case CX88_BOARD_WINFAST_DTV1800H:
+	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
 	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 		gpio = (gpio & 0x6ff) | ((cx_read(MO_GP1_IO) << 8) & 0x900);
@@ -290,6 +291,7 @@
 	case CX88_BOARD_WINFAST_DTV2000H:
 	case CX88_BOARD_WINFAST_DTV2000H_J:
 	case CX88_BOARD_WINFAST_DTV1800H:
+	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
 	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 		ir_codes = RC_MAP_WINFAST;
 		ir->gpio_addr = MO_GP0_IO;
