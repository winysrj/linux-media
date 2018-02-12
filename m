Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44322 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753908AbeBLVHe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 16:07:34 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 2/4] cx23885: Add support for Hauppauge PCIe HVR1265 K4
Date: Mon, 12 Feb 2018 15:07:27 -0600
Message-Id: <1518469647-24070-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515199702-16083-3-git-send-email-brad@nextdimension.cc>
References: <1515199702-16083-3-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new PCIe board to driver list and board register/configure functions

cx23885 + lgdt3306a + si2157 digital/analog
and
composite/s-video + stereo audio capture

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- add tuner_type
- add missing composite/s-video analog inputs

 drivers/media/pci/cx23885/cx23885-cards.c | 43 +++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-dvb.c   | 46 +++++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-input.c |  3 ++
 drivers/media/pci/cx23885/cx23885-video.c |  5 +++-
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 5 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 3622521..2cc6390 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -776,6 +776,27 @@ struct cx23885_board cx23885_boards[] = {
 		.portb        = CX23885_MPEG_DVB,
 		.portc        = CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_HAUPPAUGE_HVR1265_K4] = {
+		.name		= "Hauppauge WinTV-HVR-1265(161111)",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.portc		= CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_ABSENT,
+		.force_bff	= 1,
+		.input          = {{
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
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -1087,6 +1108,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x0070,
 		.subdevice = 0x6b18,
 		.card      = CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC, /* Tuner Pair 2 */
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0x2a18,
+		.card      = CX23885_BOARD_HAUPPAUGE_HVR1265_K4, /* Hauppauge WinTV HVR-1265 (Model 161xx1, Hybrid ATSC/QAM-B) */
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1287,6 +1312,9 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 	case 150329:
 		/* WinTV-HVR5525 (PCIe, DVB-S/S2, DVB-T/T2/C) */
 		break;
+	case 161111:
+		/* WinTV-HVR-1265 K4 (PCIe, Analog/ATSC/QAM-B) */
+		break;
 	case 166100:
 		/* WinTV-QuadHD (DVB) Tuner Pair 1 (PCIe, IR, half height,
 		   DVB-T/T2/C, DVB-T/T2/C */
@@ -1809,6 +1837,18 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		 * card does not have any GPIO's connected to subcomponents.
 		 */
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+		/*
+		 * GPIO-08 TER1_RESN
+		 * GPIO-09 TER2_RESN
+		 */
+		/* Put the parts into reset and back */
+		cx23885_gpio_enable(dev, GPIO_8 | GPIO_9, 1);
+		cx23885_gpio_clear(dev, GPIO_8 | GPIO_9);
+		msleep(100);
+		cx23885_gpio_set(dev, GPIO_8 | GPIO_9);
+		msleep(100);
+		break;
 	}
 }
 
@@ -2054,6 +2094,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_STARBURST:
 	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
 	case CX23885_BOARD_HAUPPAUGE_HVR5525:
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
 		if (dev->i2c_bus[0].i2c_rc == 0)
@@ -2201,6 +2242,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
 		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
@@ -2259,6 +2301,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_MYGICA_X8506:
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 700422b..2b23636 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -930,6 +930,18 @@ static const struct m88ds3103_config hauppauge_hvr5525_m88ds3103_config = {
 	.agc = 0x99,
 };
 
+static struct lgdt3306a_config hauppauge_hvr1265k4_config = {
+	.i2c_addr               = 0x59,
+	.qam_if_khz             = 4000,
+	.vsb_if_khz             = 3250,
+	.deny_i2c_rptr          = 1, /* Disabled */
+	.spectral_inversion     = 0, /* Disabled */
+	.mpeg_mode              = LGDT3306A_MPEG_SERIAL,
+	.tpclk_edge             = LGDT3306A_TPCLK_RISING_EDGE,
+	.tpvalid_polarity       = LGDT3306A_TP_VALID_HIGH,
+	.xtalMHz                = 25, /* 24 or 25 */
+};
+
 static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 {
 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
@@ -2490,7 +2502,41 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		}
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+		switch (port->nr) {
+		/* port c - Terrestrial/cable */
+		case 2:
+			/* attach frontend */
+			i2c_bus = &dev->i2c_bus[0];
+			fe0->dvb.frontend = dvb_attach(lgdt3306a_attach,
+					&hauppauge_hvr1265k4_config,
+					&i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend == NULL)
+				break;
 
+			/* attach tuner */
+			memset(&si2157_config, 0, sizeof(si2157_config));
+			si2157_config.fe = fe0->dvb.frontend;
+			si2157_config.if_port = 1;
+			si2157_config.inversion = 1;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			info.addr = 0x60;
+			info.platform_data = &si2157_config;
+			request_module("%s", info.type);
+			client_tuner = i2c_new_device(&dev->i2c_bus[1].i2c_adap, &info);
+			if (!client_tuner || !client_tuner->dev.driver)
+				goto frontend_detach;
+
+			if (!try_module_get(client_tuner->dev.driver->owner)) {
+				i2c_unregister_device(client_tuner);
+				client_tuner = NULL;
+				goto frontend_detach;
+			}
+			port->i2c_client_tuner = client_tuner;
+			break;
+		}
+		break;
 	default:
 		pr_info("%s: The frontend of your DVB/ATSC card  isn't supported yet\n",
 			dev->name);
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 0f4e542..be49589 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -94,6 +94,7 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
 	case CX23885_BOARD_DVBSKY_T982:
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 		/*
 		 * The only boards we handle right now.  However other boards
 		 * using the CX2388x integrated IR controller should be similar
@@ -153,6 +154,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
 	case CX23885_BOARD_DVBSKY_T982:
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 		/*
 		 * The IR controller on this board only returns pulse widths.
 		 * Any other mode setting will fail to set up the device.
@@ -283,6 +285,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 		/* Integrated CX2388[58] IR controller */
 		allowed_protos = RC_PROTO_BIT_ALL_IR_DECODER;
 		/* The grey Hauppauge RC-5 remote */
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index a03dcb6..f8a3dea 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -263,6 +263,7 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
 		(dev->board == CX23885_BOARD_HAUPPAUGE_IMPACTVCBE) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
+		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1265_K4) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
 		(dev->board == CX23885_BOARD_MYGICA_X8507) ||
 		(dev->board == CX23885_BOARD_AVERMEDIA_HC81R) ||
@@ -993,7 +994,8 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 
 	if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
 	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
-	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111))
+	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
+	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1265_K4))
 		fe = &dev->ts1.analog_fe;
 
 	if (fe && fe->ops.tuner_ops.set_analog_params) {
@@ -1022,6 +1024,7 @@ int cx23885_set_frequency(struct file *file, void *priv,
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 		ret = cx23885_set_freq_via_ops(dev, f);
 		break;
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 2a17209..7c7a103 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -107,6 +107,7 @@
 #define CX23885_BOARD_VIEWCAST_460E            55
 #define CX23885_BOARD_HAUPPAUGE_QUADHD_DVB     56
 #define CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC    57
+#define CX23885_BOARD_HAUPPAUGE_HVR1265_K4     58
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
2.7.4
