Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:57328 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1FGQO7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 12:14:59 -0400
Received: from [94.248.227.150] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QTyve-0006IO-5a
	for linux-media@vger.kernel.org; Tue, 07 Jun 2011 18:14:58 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] cx88: added support for Leadtek WinFast DTV2000 H Plus
MIME-Version: 1.0
Date: Tue, 7 Jun 2011 18:14:53 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071814.53704.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch implements support for the Leadtek WinFast DTV2000 H Plus card
with XC4000 tuner (107d:6f42).

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-cards.c xc4000/drivers/media/video/cx88/cx88-cards.c
--- xc4000_orig/drivers/media/video/cx88/cx88-cards.c	2011-06-07 15:34:32.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-cards.c	2011-06-07 17:37:32.000000000 +0200
@@ -2120,6 +2120,58 @@
 		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_WINFAST_DTV2000H_PLUS] = {
+		.name		= "Leadtek WinFast DTV2000 H PLUS",
+		.tuner_type	= TUNER_XC4000,
+		.radio_type	= TUNER_XC4000,
+		.tuner_addr	= 0x61,
+		.radio_addr	= 0x61,
+		/*
+		 * GPIO
+		 *   2: 1: mute audio
+		 *  12: 0: reset XC4000
+		 *  13: 1: audio input is line in (0: tuner)
+		 *  14: 0: FM radio
+		 *  16: 0: RF input is cable
+		 */
+		.input		= {{
+			.type	= CX88_VMUX_TELEVISION,
+			.vmux	= 0,
+			.gpio0	= 0x0403,
+			.gpio1	= 0xF0D7,
+			.gpio2	= 0x0101,
+			.gpio3	= 0x0000,
+		}, {
+			.type	= CX88_VMUX_CABLE,
+			.vmux	= 0,
+			.gpio0	= 0x0403,
+			.gpio1	= 0xF0D7,
+			.gpio2	= 0x0100,
+			.gpio3	= 0x0000,
+		}, {
+			.type	= CX88_VMUX_COMPOSITE1,
+			.vmux	= 1,
+			.gpio0	= 0x0403,	/* was 0x0407 */
+			.gpio1	= 0xF0F7,
+			.gpio2	= 0x0101,
+			.gpio3	= 0x0000,
+		}, {
+			.type	= CX88_VMUX_SVIDEO,
+			.vmux	= 2,
+			.gpio0	= 0x0403,	/* was 0x0407 */
+			.gpio1	= 0xF0F7,
+			.gpio2	= 0x0101,
+			.gpio3	= 0x0000,
+		}},
+		.radio = {
+			.type	= CX88_RADIO,
+			.gpio0	= 0x0403,
+			.gpio1	= 0xF097,
+			.gpio2	= 0x0100,
+			.gpio3	= 0x0000,
+		},
+		.mpeg		= CX88_MPEG_DVB,
+	},
 	[CX88_BOARD_PROF_7301] = {
 		.name           = "Prof 7301 DVB-S/S2",
 		.tuner_type     = UNSET,
@@ -2582,6 +2634,10 @@
 		.subdevice = 0x6654,
 		.card      = CX88_BOARD_WINFAST_DTV1800H,
 	}, {
+		.subvendor = 0x107d,
+		.subdevice = 0x6f42,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_PLUS,
+	}, {
 		/* PVR2000 PAL Model [107d:6630] */
 		.subvendor = 0x107d,
 		.subdevice = 0x6630,
@@ -2847,6 +2903,23 @@
 	return -EINVAL;
 }
 
+static int cx88_xc4000_winfast2000h_plus_callback(struct cx88_core *core,
+						  int command, int arg)
+{
+	switch (command) {
+	case XC4000_TUNER_RESET:
+		/* GPIO 12 (xc4000 tuner reset) */
+		cx_set(MO_GP1_IO, 0x1010);
+		mdelay(50);
+		cx_clear(MO_GP1_IO, 0x10);
+		mdelay(75);
+		cx_set(MO_GP1_IO, 0x10);
+		mdelay(75);
+		return 0;
+	}
+	return -EINVAL;
+}
+
 /* ------------------------------------------------------------------- */
 /* some Divco specific stuff                                           */
 static int cx88_pv_8000gt_callback(struct cx88_core *core,
@@ -2954,6 +3027,9 @@
 {
 	/* Board-specific callbacks */
 	switch (core->boardnr) {
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+		return cx88_xc4000_winfast2000h_plus_callback(core,
+							      command, arg);
 	}
 	return -EINVAL;
 }
@@ -3131,6 +3207,11 @@
 		mdelay(50);
 		break;
 
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+		cx88_xc4000_winfast2000h_plus_callback(core,
+						       XC4000_TUNER_RESET, 0);
+		break;
+
 	case CX88_BOARD_TWINHAN_VP1027_DVBS:
 		cx_write(MO_GP0_IO, 0x00003230);
 		cx_write(MO_GP0_IO, 0x00003210);
diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-dvb.c xc4000/drivers/media/video/cx88/cx88-dvb.c
--- xc4000_orig/drivers/media/video/cx88/cx88-dvb.c	2011-06-07 15:34:32.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-dvb.c	2011-06-07 17:41:57.000000000 +0200
@@ -1328,7 +1328,24 @@
 				goto frontend_detach;
 		}
 		break;
-	 case CX88_BOARD_GENIATECH_X8000_MT:
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
+					       &cx88_pinnacle_hybrid_pctv,
+					       &core->i2c_adap);
+		if (fe0->dvb.frontend) {
+			struct xc4000_config cfg = {
+				.i2c_address	  = 0x61,
+				.default_pm	  = 0,
+				.dvb_amplitude	  = 134,
+				.set_smoothedcvbs = 1,
+				.if_khz		  = 4560
+			};
+			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
+			if (attach_xc4000(dev, &cfg) < 0)
+				goto frontend_detach;
+		}
+		break;
+	case CX88_BOARD_GENIATECH_X8000_MT:
 		dev->ts_gen_cntrl = 0x00;
 
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
@@ -1611,6 +1628,11 @@
 		udelay(1000);
 		break;
 
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+		/* set RF input to AIR for DVB-T (GPIO 16) */
+		cx_write(MO_GP2_IO, 0x0101);
+		break;
+
 	default:
 		err = -ENODEV;
 	}
diff -uNr xc4000_orig/drivers/media/video/cx88/cx88.h xc4000/drivers/media/video/cx88/cx88.h
--- xc4000_orig/drivers/media/video/cx88/cx88.h	2011-06-07 14:33:39.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88.h	2011-06-07 16:18:23.000000000 +0200
@@ -242,6 +242,7 @@
 #define CX88_BOARD_SAMSUNG_SMT_7020        84
 #define CX88_BOARD_TWINHAN_VP1027_DVBS     85
 #define CX88_BOARD_TEVII_S464              86
+#define CX88_BOARD_WINFAST_DTV2000H_PLUS   87
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-input.c xc4000/drivers/media/video/cx88/cx88-input.c
--- xc4000_orig/drivers/media/video/cx88/cx88-input.c	2011-06-07 14:33:39.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-input.c	2011-06-07 16:17:54.000000000 +0200
@@ -100,6 +100,7 @@
 		break;
 	case CX88_BOARD_WINFAST_DTV1000:
 	case CX88_BOARD_WINFAST_DTV1800H:
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 		gpio = (gpio & 0x6ff) | ((cx_read(MO_GP1_IO) << 8) & 0x900);
 		auxgpio = gpio;
@@ -289,6 +290,7 @@
 	case CX88_BOARD_WINFAST_DTV2000H:
 	case CX88_BOARD_WINFAST_DTV2000H_J:
 	case CX88_BOARD_WINFAST_DTV1800H:
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 		ir_codes = RC_MAP_WINFAST;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
