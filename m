Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56662 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758383Ab0J1VMJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 17:12:09 -0400
Received: by ewy7 with SMTP id 7so1946550ewy.19
        for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 14:12:07 -0700 (PDT)
From: Alexey Chernov <4ernov@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Patch for cx18 module with added support of GoTView PCI DVD3 Hybrid tuner
Date: Fri, 29 Oct 2010 01:12:02 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010290112.02949.4ernov@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,
I've got code which adds support of GoTView PCI DVD3 Hybrid tuner in cx18 module and Andy Walls in ivtv mailing-list gave me some advice on making a patch and sending it here. So here's the patch against staging/2.6.37-rc1 branch (the tutorial recommends to include it as plain text but if it's 
the case I can surely send as an attachment):

diff -uprB v4l-dvb.orig/drivers/media/video/cx18/cx18-cards.c v4l-dvb/drivers/media/video/cx18/cx18-cards.c
--- v4l-dvb.orig/drivers/media/video/cx18/cx18-cards.c	2010-10-28 22:04:11.000000000 +0400
+++ v4l-dvb/drivers/media/video/cx18/cx18-cards.c	2010-10-29 00:31:53.000000000 +0400
@@ -251,6 +251,66 @@ static const struct cx18_card cx18_card_
 
 /* ------------------------------------------------------------------------- */
 
+/* GoTView PCI */
+
+static const struct cx18_card_pci_info cx18_pci_gotview_dvd3[] = {
+	{ PCI_DEVICE_ID_CX23418, CX18_PCI_ID_GOTVIEW, 0x3343 },
+	{ 0, 0, 0 }
+};
+
+static const struct cx18_card cx18_card_gotview_dvd3 = {
+	.type = CX18_CARD_GOTVIEW_PCI_DVD3,
+	.name = "GoTView PCI DVD3 Hybrid",
+	.comment = "Experimenters needed for device to work well.\n"
+		  "\tTo help, mail the ivtv-devel list (www.ivtvdriver.org).\n",
+	.v4l2_capabilities = CX18_CAP_ENCODER,
+	.hw_audio_ctrl = CX18_HW_418_AV,
+	.hw_muxer = CX18_HW_GPIO_MUX,
+	.hw_all = CX18_HW_TVEEPROM | CX18_HW_418_AV | CX18_HW_TUNER |
+		  CX18_HW_GPIO_MUX | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL,
+	.video_inputs = {
+		{ CX18_CARD_INPUT_VID_TUNER,  0, CX18_AV_COMPOSITE2 },
+		{ CX18_CARD_INPUT_SVIDEO1,    1,
+				CX18_AV_SVIDEO_LUMA3 | CX18_AV_SVIDEO_CHROMA4 },
+		{ CX18_CARD_INPUT_COMPOSITE1, 1, CX18_AV_COMPOSITE1 },
+		{ CX18_CARD_INPUT_SVIDEO2,    2,
+				CX18_AV_SVIDEO_LUMA7 | CX18_AV_SVIDEO_CHROMA8 },
+		{ CX18_CARD_INPUT_COMPOSITE2, 2, CX18_AV_COMPOSITE6 },
+	},
+	.audio_inputs = {
+		{ CX18_CARD_INPUT_AUD_TUNER, CX18_AV_AUDIO5,        0 },
+		{ CX18_CARD_INPUT_LINE_IN1,  CX18_AV_AUDIO_SERIAL1, 1 },
+		{ CX18_CARD_INPUT_LINE_IN2,  CX18_AV_AUDIO_SERIAL2, 1 },
+	},
+	.tuners = {
+		/* XC3028 tuner */
+		{ .std = V4L2_STD_ALL, .tuner = TUNER_XC2028 },
+	},
+	/* FIXME - the FM radio is just a guess and driver doesn't use SIF */
+	.radio_input = { CX18_CARD_INPUT_AUD_TUNER, CX18_AV_AUDIO5, 2 },
+	.ddr = {
+		/* Hynix HY5DU283222B DDR RAM */
+		.chip_config = 0x303,
+		.refresh = 0x3bd,
+		.timing1 = 0x36320966,
+		.timing2 = 0x1f,
+		.tune_lane = 0,
+		.initial_emrs = 2,
+	},
+	.gpio_init.initial_value = 0x1,
+	.gpio_init.direction = 0x3,
+	
+	.gpio_audio_input = { .mask   = 0x3,
+			      .tuner  = 0x1,
+			      .linein = 0x2,
+			      .radio  = 0x1 },
+	.xceive_pin = 0,
+	.pci_list = cx18_pci_gotview_dvd3,
+	.i2c = &cx18_i2c_std,
+};
+
+/* ------------------------------------------------------------------------- */
+
 /* Conexant Raptor PAL/SECAM: note that this card is analog only! */
 
 static const struct cx18_card_pci_info cx18_pci_cnxt_raptor_pal[] = {
@@ -463,6 +523,7 @@ static const struct cx18_card *cx18_card
 	&cx18_card_toshiba_qosmio_dvbt,
 	&cx18_card_leadtek_pvr2100,
 	&cx18_card_leadtek_dvr3100h,
+	&cx18_card_gotview_dvd3
 };
 
 const struct cx18_card *cx18_get_card(u16 index)
diff -uprB v4l-dvb.orig/drivers/media/video/cx18/cx18-driver.c v4l-dvb/drivers/media/video/cx18/cx18-driver.c
--- v4l-dvb.orig/drivers/media/video/cx18/cx18-driver.c	2010-10-28 22:04:11.000000000 +0400
+++ v4l-dvb/drivers/media/video/cx18/cx18-driver.c	2010-10-28 22:19:09.000000000 +0400
@@ -156,6 +156,7 @@ MODULE_PARM_DESC(cardtype,
 		 "\t\t\t 6 = Toshiba Qosmio DVB-T/Analog\n"
 		 "\t\t\t 7 = Leadtek WinFast PVR2100\n"
 		 "\t\t\t 8 = Leadtek WinFast DVR3100 H\n"
+		 "\t\t\t 9 = GoTView PCI DVD3 Hybrid\n"
 		 "\t\t\t 0 = Autodetect (default)\n"
 		 "\t\t\t-1 = Ignore this card\n\t\t");
 MODULE_PARM_DESC(pal, "Set PAL standard: B, G, H, D, K, I, M, N, Nc, 60");
@@ -333,6 +334,7 @@ void cx18_read_eeprom(struct cx18 *cx, s
 		tveeprom_hauppauge_analog(&c, tv, eedata);
 		break;
 	case CX18_CARD_YUAN_MPC718:
+	case CX18_CARD_GOTVIEW_PCI_DVD3:
 		tv->model = 0x718;
 		cx18_eeprom_dump(cx, eedata, sizeof(eedata));
 		CX18_INFO("eeprom PCI ID: %02x%02x:%02x%02x\n",
diff -uprB v4l-dvb.orig/drivers/media/video/cx18/cx18-driver.h v4l-dvb/drivers/media/video/cx18/cx18-driver.h
--- v4l-dvb.orig/drivers/media/video/cx18/cx18-driver.h	2010-10-28 22:04:11.000000000 +0400
+++ v4l-dvb/drivers/media/video/cx18/cx18-driver.h	2010-10-28 22:33:49.000000000 +0400
@@ -84,7 +84,8 @@
 #define CX18_CARD_TOSHIBA_QOSMIO_DVBT 5 /* Toshiba Qosmio Interal DVB-T/Analog*/
 #define CX18_CARD_LEADTEK_PVR2100     6 /* Leadtek WinFast PVR2100 */
 #define CX18_CARD_LEADTEK_DVR3100H    7 /* Leadtek WinFast DVR3100 H */
-#define CX18_CARD_LAST 		      7
+#define CX18_CARD_GOTVIEW_PCI_DVD3    8 /* GoTView PCI DVD3 Hybrid */
+#define CX18_CARD_LAST 		      8
 
 #define CX18_ENC_STREAM_TYPE_MPG  0
 #define CX18_ENC_STREAM_TYPE_TS   1
@@ -106,6 +107,7 @@
 #define CX18_PCI_ID_CONEXANT		0x14f1
 #define CX18_PCI_ID_TOSHIBA		0x1179
 #define CX18_PCI_ID_LEADTEK		0x107D
+#define CX18_PCI_ID_GOTVIEW 		0x5854
 
 /* ======================================================================== */
 /* ========================== START USER SETTABLE DMA VARIABLES =========== */
diff -uprB v4l-dvb.orig/drivers/media/video/cx18/cx18-dvb.c v4l-dvb/drivers/media/video/cx18/cx18-dvb.c
--- v4l-dvb.orig/drivers/media/video/cx18/cx18-dvb.c	2010-10-28 22:04:11.000000000 +0400
+++ v4l-dvb/drivers/media/video/cx18/cx18-dvb.c	2010-10-28 22:20:08.000000000 +0400
@@ -203,6 +203,14 @@ static struct zl10353_config yuan_mpc718
 	.disable_i2c_gate_ctrl = 1,         /* Disable the I2C gate */
 };
 
+static struct zl10353_config gotview_dvd3_zl10353_demod = {
+	.demod_address         = 0x1e >> 1, /* Datasheet suggested straps */
+	.if2                   = 45600,     /* 4.560 MHz IF from the XC3028 */
+	.parallel_ts           = 1,         /* Not a serial TS */
+	.no_tuner              = 1,         /* XC3028 is not behind the gate */
+	.disable_i2c_gate_ctrl = 1,         /* Disable the I2C gate */
+};
+
 static int dvb_register(struct cx18_stream *stream);
 
 /* Kernel DVB framework calls this when the feed needs to start.
@@ -247,6 +255,7 @@ static int cx18_dvb_start_feed(struct dv
 
 	case CX18_CARD_LEADTEK_DVR3100H:
 	case CX18_CARD_YUAN_MPC718:
+	case CX18_CARD_GOTVIEW_PCI_DVD3:
 	default:
 		/* Assumption - Parallel transport - Signalling
 		 * undefined or default.
@@ -495,6 +504,29 @@ static int dvb_register(struct cx18_stre
 				fe->ops.tuner_ops.set_config(fe, &ctrl);
 		}
 		break;
+	case CX18_CARD_GOTVIEW_PCI_DVD3:
+			dvb->fe = dvb_attach(zl10353_attach,
+					     &gotview_dvd3_zl10353_demod,
+					     &cx->i2c_adap[1]);
+		if (dvb->fe != NULL) {
+			struct dvb_frontend *fe;
+			struct xc2028_config cfg = {
+				.i2c_adap = &cx->i2c_adap[1],
+				.i2c_addr = 0xc2 >> 1,
+				.ctrl = NULL,
+			};
+			static struct xc2028_ctrl ctrl = {
+				.fname   = XC2028_DEFAULT_FIRMWARE,
+				.max_len = 64,
+				.demod   = XC3028_FE_ZARLINK456,
+				.type    = XC2028_AUTO,
+			};
+
+			fe = dvb_attach(xc2028_attach, dvb->fe, &cfg);
+			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
+				fe->ops.tuner_ops.set_config(fe, &ctrl);
+		}
+		break;
 	default:
 		/* No Digital Tv Support */
 		break;

Several comments on the patch:
1. Both users on the official Gotview forum and support said that PCI DVD3 is very similar to Yuan MPC718 card so the main part of code is taken from Yuan configuration. Some users reported it to work properly.
2. Everything is being initialized correctly including analog, dvb, radio and alsa parts. Analogue part and alsa virtual card is tested by myself using original Gotview card.

I'm completely newbie in making and sending patches for the kernel so I'm very sorry if I did something wrong.

Thank you very much in advance!

Signed-off-by: Alexey Chernov <4ernov@gmail.com>
