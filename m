Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36200 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaLSI5o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 03:57:44 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] cx23885: Hauppauge WinTV-HVR5525
Date: Fri, 19 Dec 2014 10:56:43 +0200
Message-Id: <1418979403-28225-4-git-send-email-crope@iki.fi>
In-Reply-To: <1418979403-28225-1-git-send-email-crope@iki.fi>
References: <1418979403-28225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add board profile for Hauppauge WinTV-HVR5525.

Device is build upon following main components:
Conexant CX23888
Montage M88RS6000
Allegro A8293
Silicon Labs Si2168-B40
Silicon Labs Si2157-A30

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/cx23885/Kconfig         |  1 +
 drivers/media/pci/cx23885/cx23885-cards.c | 43 ++++++++++++++
 drivers/media/pci/cx23885/cx23885-dvb.c   | 98 +++++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 4 files changed, 143 insertions(+)

diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index f613314..74d774e 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -41,6 +41,7 @@ config VIDEO_CX23885
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for Conexant 23885 based
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index db99ca2..2a92bcd 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -706,6 +706,11 @@ struct cx23885_board cx23885_boards[] = {
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_HAUPPAUGE_HVR5525] = {
+		.name		= "Hauppauge WinTV-HVR5525",
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -989,6 +994,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x4254,
 		.subdevice = 0x0982,
 		.card      = CX23885_BOARD_DVBSKY_T982,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0xf038,
+		.card      = CX23885_BOARD_HAUPPAUGE_HVR5525,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1161,6 +1170,8 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 	case 85721:
 		/* WinTV-HVR1290 (PCIe, OEM, RCA in, IR,
 			Dual channel ATSC and Basic analog */
+	case 150329:
+		/* WinTV-HVR5525 (PCIe, DVB-S/S2, DVB-T/T2/C) */
 		break;
 	default:
 		printk(KERN_WARNING "%s: warning: "
@@ -1632,6 +1643,29 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		msleep(100);
 		cx23885_gpio_set(dev, GPIO_2);
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR5525:
+		/*
+		 * GPIO-00 IR_WIDE
+		 * GPIO-02 wake#
+		 * GPIO-03 VAUX Pres.
+		 * GPIO-07 PROG#
+		 * GPIO-08 SAT_RESN
+		 * GPIO-09 TER_RESN
+		 * GPIO-10 B2_SENSE
+		 * GPIO-11 B1_SENSE
+		 * GPIO-15 IR_LED_STATUS
+		 * GPIO-19 IR_NARROW
+		 * GPIO-20 Blauster1
+		 * ALTGPIO VAUX_SWITCH
+		 * AUX_PLL_CLK : Blaster2
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
 
@@ -1873,6 +1907,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_HAUPPAUGE_HVR4400:
 	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
+	case CX23885_BOARD_HAUPPAUGE_HVR5525:
 		if (dev->i2c_bus[0].i2c_rc == 0)
 			hauppauge_eeprom(dev, eeprom+0xc0);
 		break;
@@ -1997,6 +2032,14 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR5525:
+		ts1->gen_ctrl_val  = 0x5; /* Parallel */
+		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
+		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 0f60bc4..63c0de3 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -74,6 +74,7 @@
 #include "sp2.h"
 #include "m88ds3103.h"
 #include "m88ts2022.h"
+#include "m88rs6000t.h"
 
 static unsigned int debug;
 
@@ -915,6 +916,16 @@ static const struct m88ds3103_config dvbsky_s952_portc_m88ds3103_config = {
 	.agc = 0x99,
 };
 
+static const struct m88ds3103_config hauppauge_hvr5525_m88ds3103_config = {
+	.i2c_addr = 0x69,
+	.clock = 27000000,
+	.i2c_wr_max = 33,
+	.ts_mode = M88DS3103_TS_PARALLEL,
+	.ts_clk = 16000,
+	.ts_clk_pol = 1,
+	.agc = 0x99,
+};
+
 static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 {
 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
@@ -1999,6 +2010,93 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		port->i2c_client_tuner = client_tuner;
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR5525:
+		switch (port->nr) {
+		struct m88rs6000t_config m88rs6000t_config;
+
+		/* port b - satellite */
+		case 1:
+			/* attach frontend */
+			fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
+					&hauppauge_hvr5525_m88ds3103_config,
+					&dev->i2c_bus[0].i2c_adap, &adapter);
+			if (fe0->dvb.frontend == NULL)
+				break;
+
+			/* attach SEC */
+			if (!dvb_attach(a8293_attach, fe0->dvb.frontend,
+					&dev->i2c_bus[0].i2c_adap,
+					&hauppauge_a8293_config))
+				goto frontend_detach;
+
+			/* attach tuner */
+			memset(&m88rs6000t_config, 0, sizeof(m88rs6000t_config));
+			m88rs6000t_config.fe = fe0->dvb.frontend;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "m88rs6000t", I2C_NAME_SIZE);
+			info.addr = 0x21;
+			info.platform_data = &m88rs6000t_config;
+			request_module("%s", info.type);
+			client_tuner = i2c_new_device(adapter, &info);
+			if (!client_tuner || !client_tuner->dev.driver)
+				goto frontend_detach;
+			if (!try_module_get(client_tuner->dev.driver->owner)) {
+				i2c_unregister_device(client_tuner);
+				goto frontend_detach;
+			}
+			port->i2c_client_tuner = client_tuner;
+
+			/* delegate signal strength measurement to tuner */
+			fe0->dvb.frontend->ops.read_signal_strength =
+				fe0->dvb.frontend->ops.tuner_ops.get_rf_strength;
+			break;
+		/* port c - terrestrial/cable */
+		case 2:
+			/* attach frontend */
+			memset(&si2168_config, 0, sizeof(si2168_config));
+			si2168_config.i2c_adapter = &adapter;
+			si2168_config.fe = &fe0->dvb.frontend;
+			si2168_config.ts_mode = SI2168_TS_SERIAL;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			info.addr = 0x64;
+			info.platform_data = &si2168_config;
+			request_module("%s", info.type);
+			client_demod = i2c_new_device(&dev->i2c_bus[0].i2c_adap, &info);
+			if (!client_demod || !client_demod->dev.driver)
+				goto frontend_detach;
+			if (!try_module_get(client_demod->dev.driver->owner)) {
+				i2c_unregister_device(client_demod);
+				goto frontend_detach;
+			}
+			port->i2c_client_demod = client_demod;
+
+			/* attach tuner */
+			memset(&si2157_config, 0, sizeof(si2157_config));
+			si2157_config.fe = fe0->dvb.frontend;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			info.addr = 0x60;
+			info.platform_data = &si2157_config;
+			request_module("%s", info.type);
+			client_tuner = i2c_new_device(&dev->i2c_bus[1].i2c_adap, &info);
+			if (!client_tuner || !client_tuner->dev.driver) {
+				module_put(client_demod->dev.driver->owner);
+				i2c_unregister_device(client_demod);
+				port->i2c_client_demod = NULL;
+				goto frontend_detach;
+			}
+			if (!try_module_get(client_tuner->dev.driver->owner)) {
+				i2c_unregister_device(client_tuner);
+				module_put(client_demod->dev.driver->owner);
+				i2c_unregister_device(client_demod);
+				port->i2c_client_demod = NULL;
+				goto frontend_detach;
+			}
+			port->i2c_client_tuner = client_tuner;
+			break;
+		}
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index f55cd12..4f358eb 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -99,6 +99,7 @@
 #define CX23885_BOARD_DVBSKY_S950              49
 #define CX23885_BOARD_DVBSKY_S952              50
 #define CX23885_BOARD_DVBSKY_T982              51
+#define CX23885_BOARD_HAUPPAUGE_HVR5525        52
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
http://palosaari.fi/

