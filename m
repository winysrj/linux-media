Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54268 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2GAUP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2012 16:15:59 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so2600569qcr.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jul 2012 13:15:59 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 6/6] cx23885: add support for HVR-1255 analog (cx23888 variant)
Date: Sun,  1 Jul 2012 16:15:14 -0400
Message-Id: <1341173714-23627-7-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
References: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get the HVR-1255 analog support working for all supported inputs.  This
includes introduction of a new board profile for an OEM variant which doesn't
have all the same inputs as the retail version of the board.

Validated with the following boards:

HVR-1255 (0070:2259)

Thanks to Steven Toth and Hauppauge for	loaning	me various boards to
regression test	with.

Thanks-to: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Devin Heitmueler <dheitmueller@kernellabs.com>
---
 drivers/media/video/cx23885/cx23885-cards.c |   56 ++++++++++++++++++++++++++-
 drivers/media/video/cx23885/cx23885-dvb.c   |    6 +++
 drivers/media/video/cx23885/cx23885-video.c |    8 +++-
 drivers/media/video/cx23885/cx23885.h       |    1 +
 4 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 1af9108..5103735 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -282,7 +282,55 @@ struct cx23885_board cx23885_boards[] = {
 	},
 	[CX23885_BOARD_HAUPPAUGE_HVR1255] = {
 		.name		= "Hauppauge WinTV-HVR1255",
+		.porta		= CX23885_ANALOG_VIDEO,
 		.portc		= CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_ABSENT,
+		.tuner_addr	= 0x42, /* 0x84 >> 1 */
+		.force_bff	= 1,
+		.input          = {{
+			.type   = CX23885_VMUX_TELEVISION,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN5_CH2 |
+					CX25840_VIN2_CH1 |
+					CX25840_DIF_ON,
+			.amux   = CX25840_AUDIO8,
+		}, {
+			.type   = CX23885_VMUX_COMPOSITE1,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN4_CH2 |
+					CX25840_VIN6_CH1,
+			.amux   = CX25840_AUDIO7,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN4_CH2 |
+					CX25840_VIN8_CH1 |
+					CX25840_SVIDEO_ON,
+			.amux   = CX25840_AUDIO7,
+		} },
+	},
+	[CX23885_BOARD_HAUPPAUGE_HVR1255_22111] = {
+		.name		= "Hauppauge WinTV-HVR1255",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.portc		= CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_ABSENT,
+		.tuner_addr	= 0x42, /* 0x84 >> 1 */
+		.force_bff	= 1,
+		.input          = {{
+			.type   = CX23885_VMUX_TELEVISION,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN5_CH2 |
+					CX25840_VIN2_CH1 |
+					CX25840_DIF_ON,
+			.amux   = CX25840_AUDIO8,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN4_CH2 |
+					CX25840_VIN8_CH1 |
+					CX25840_SVIDEO_ON,
+			.amux   = CX25840_AUDIO7,
+		} },
 	},
 	[CX23885_BOARD_HAUPPAUGE_HVR1210] = {
 		.name		= "Hauppauge WinTV-HVR1210",
@@ -635,7 +683,7 @@ struct cx23885_subid cx23885_subids[] = {
 	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x2259,
-		.card      = CX23885_BOARD_HAUPPAUGE_HVR1255,
+		.card      = CX23885_BOARD_HAUPPAUGE_HVR1255_22111,
 	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x2291,
@@ -1137,6 +1185,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1275:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
+	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
 		/* GPIO-5 RF Control: 0 = RF1 Terrestrial, 1 = RF2 Cable */
 		/* GPIO-6 I2C Gate which can isolate the demod from the bus */
@@ -1274,6 +1323,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 	case CX23885_BOARD_HAUPPAUGE_HVR1275:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
+	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
 		/* FIXME: Implement me */
 		break;
@@ -1431,6 +1481,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1275:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
+	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
@@ -1517,6 +1568,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1275:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
+	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
@@ -1545,6 +1597,8 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
+	case CX23885_BOARD_HAUPPAUGE_HVR1255:
+	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_MYGICA_X8506:
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 6835eb1..316bf95 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -712,6 +712,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
+	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
 		i2c_bus = &dev->i2c_bus[0];
 		fe0->dvb.frontend = dvb_attach(s5h1411_attach,
 					       &hcw_s5h1411_config,
@@ -721,6 +722,11 @@ static int dvb_register(struct cx23885_tsport *port)
 				   0x60, &dev->i2c_bus[1].i2c_adap,
 				   &hauppauge_tda18271_config);
 		}
+
+		tda18271_attach(&dev->ts1.analog_fe,
+			0x60, &dev->i2c_bus[1].i2c_adap,
+			&hauppauge_tda18271_config);
+
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1800:
 		i2c_bus = &dev->i2c_bus[0];
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 4d05689..22f8e7f 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -506,6 +506,8 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
 	if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1800) ||
 		(dev->board == CX23885_BOARD_MPX885) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1250) ||
+		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
+		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850)) {
 		/* Configure audio routing */
 		v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
@@ -1579,7 +1581,9 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 
 	fe = vfe->dvb.frontend;
 
-	if (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850)
+	if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
+	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
+	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111))
 		fe = &dev->ts1.analog_fe;
 
 	if (fe && fe->ops.tuner_ops.set_analog_params) {
@@ -1609,6 +1613,8 @@ int cx23885_set_frequency(struct file *file, void *priv,
 	int ret;
 
 	switch (dev->board) {
+	case CX23885_BOARD_HAUPPAUGE_HVR1255:
+	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 		ret = cx23885_set_freq_via_ops(dev, f);
 		break;
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index f020f05..1f45d3f 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -89,6 +89,7 @@
 #define CX23885_BOARD_MPX885                   32
 #define CX23885_BOARD_MYGICA_X8507             33
 #define CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL 34
+#define CX23885_BOARD_HAUPPAUGE_HVR1255_22111  35
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.7.1

