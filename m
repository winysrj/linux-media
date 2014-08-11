Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.194]:56405 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbaHKT62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 15:58:28 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: olli@cabbala.net
Cc: Olli Salonen <olli.salonen@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/6] cx23855: add support for DVBSky T9580 DVB-C/T2/S2 tuner
Date: Mon, 11 Aug 2014 22:58:15 +0300
Message-Id: <1407787095-2167-6-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
References: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBSky T9580 is a dual tuner card with one DVB-T2/C tuner and one DVB-S2 tuner. It contains the following components:

- PCIe bridge: Conexant CX23885
- Demod for terrestrial/cable: Silicon Labs Si2168-A30
- Tuner for terrestrial/cable: Silicon Labs Si2158-A20
- Demod for sat: Montage DS3103
- Tuner for sat: Montage TS2022

This patch depends on Max Nibble's patch for m88ds3103 (see patchwork 25312: https://patchwork.linuxtv.org/patch/25312/ ).

3 firmwares are needed:
- Si2168-A30 demod and Si2158-A20 tuner: same as TechnoTrend CT2-4400, https://www.mail-archive.com/linux-media@vger.kernel.org/msg76944.html
- Montage DS3103 demod: same as PCTV 461e, Antti has it on his LinuxTV project page: http://palosaari.fi/linux/v4l-dvb/firmware/M88DS3103/

IR receiver is not supported.

Values in cx23885_gpio_setup, cx23885_card_setup and dvbsky_t9580_set_voltage as well as the EEPROM read function are taken from the manufacturer provided semi-open source driver. The drivers in question are Linux GPL'd media tree drivers for cx23885 modified by Max Nibble (nibble.max@gmail.com) with proprietary tuner/demod drivers. Max is aware of this patch and has approved my use of the values in this patch.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/Kconfig         |   4 +
 drivers/media/pci/cx23885/cx23885-cards.c |  26 +++++
 drivers/media/pci/cx23885/cx23885-dvb.c   | 160 ++++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885.h       |   1 +
 4 files changed, 191 insertions(+)

diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index e12c006..413587e 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -32,12 +32,16 @@ config VIDEO_CX23885
 	select DVB_A8293 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SI2165 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2063 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2131 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for Conexant 23885 based
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index c2b6080..c1b02bb 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -679,6 +679,11 @@ struct cx23885_board cx23885_boards[] = {
 			.amux   = CX25840_AUDIO7,
 		} },
 	},
+	[CX23885_BOARD_DVBSKY_T9580] = {
+		.name		= "DVBSky T9580",
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -934,6 +939,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb98,
 		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2,
+	}, {
+		.subvendor = 0x4254,
+		.subdevice = 0x9580,
+		.card      = CX23885_BOARD_DVBSKY_T9580,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1528,6 +1537,14 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		cx_set(GP0_IO, 0x00040004);
 		mdelay(60);
 		break;
+	case CX23885_BOARD_DVBSKY_T9580:
+		/* enable GPIO3-18 pins */
+		cx_write(MC417_CTL, 0x00000037);
+		cx23885_gpio_enable(dev, GPIO_2 | GPIO_11, 1);
+		cx23885_gpio_clear(dev, GPIO_2 | GPIO_11);
+		mdelay(100);
+		cx23885_gpio_set(dev, GPIO_2 | GPIO_11);
+		break;
 	}
 }
 
@@ -1851,6 +1868,14 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
+	case CX23885_BOARD_DVBSKY_T9580:
+		ts1->gen_ctrl_val  = 0x5; /* Parallel */
+		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		ts2->gen_ctrl_val  = 0x8; /* Serial bus */
+		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
@@ -1913,6 +1938,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_AVERMEDIA_HC81R:
 	case CX23885_BOARD_TBS_6980:
 	case CX23885_BOARD_TBS_6981:
+	case CX23885_BOARD_DVBSKY_T9580:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 2608155..1e9e041 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -73,6 +73,10 @@
 #include "a8293.h"
 #include "mb86a20s.h"
 #include "si2165.h"
+#include "si2168.h"
+#include "si2157.h"
+#include "m88ds3103.h"
+#include "m88ts2022.h"
 
 static unsigned int debug;
 
@@ -551,6 +555,35 @@ static int p8000_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 	return 0;
 }
 
+static int dvbsky_t9580_set_voltage(struct dvb_frontend *fe,
+					fe_sec_voltage_t voltage)
+{
+	struct cx23885_tsport *port = fe->dvb->priv;
+	struct cx23885_dev *dev = port->dev;
+
+	cx23885_gpio_enable(dev, GPIO_0 | GPIO_1, 1);
+
+	switch (voltage) {
+	case SEC_VOLTAGE_13:
+		cx23885_gpio_set(dev, GPIO_1);
+		cx23885_gpio_clear(dev, GPIO_0);
+		break;
+	case SEC_VOLTAGE_18:
+		cx23885_gpio_set(dev, GPIO_1);
+		cx23885_gpio_set(dev, GPIO_0);
+		break;
+	case SEC_VOLTAGE_OFF:
+		cx23885_gpio_clear(dev, GPIO_1);
+		cx23885_gpio_clear(dev, GPIO_0);
+		break;
+	}
+
+	/* call the frontend set_voltage function */
+	port->fe_set_voltage(fe, voltage);
+
+	return 0;
+}
+
 static int cx23885_dvb_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -715,6 +748,19 @@ static const struct si2165_config hauppauge_hvr4400_si2165_config = {
 	.ref_freq_Hz	= 16000000,
 };
 
+static const struct m88ds3103_config dvbsky_t9580_m88ds3103_config = {
+	.i2c_addr = 0x68,
+	.clock = 27000000,
+	.i2c_wr_max = 33,
+	.clock_out = 0,
+	.ts_mode = M88DS3103_TS_PARALLEL,
+	.ts_clk = 16000,
+	.ts_clk_pol = 1,
+	.lnb_en_pol = 1,
+	.lnb_hv_pol = 0,
+	.agc = 0x99,
+};
+
 static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 {
 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
@@ -864,6 +910,13 @@ static int dvb_register(struct cx23885_tsport *port)
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_i2c *i2c_bus = NULL, *i2c_bus2 = NULL;
 	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
+	struct si2168_config si2168_config;
+	struct si2157_config si2157_config;
+	struct m88ts2022_config m88ts2022_config;
+	struct i2c_board_info info;
+	struct i2c_adapter *adapter;
+	struct i2c_client *client_demod;
+	struct i2c_client *client_tuner;
 	int mfe_shared = 0; /* bus not shared by default */
 	int ret;
 
@@ -1501,6 +1554,97 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		}
 		break;
+	case CX23885_BOARD_DVBSKY_T9580:
+		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus2 = &dev->i2c_bus[1];
+		switch (port->nr) {
+		/* port b - satellite */
+		case 1:
+			/* attach frontend */
+			fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
+					&dvbsky_t9580_m88ds3103_config,
+					&i2c_bus2->i2c_adap, &adapter);
+			if (fe0->dvb.frontend == NULL)
+				break;
+
+			/* attach tuner */
+			m88ts2022_config.fe = fe0->dvb.frontend;
+			m88ts2022_config.clock = 27000000;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+			info.addr = 0x60;
+			info.platform_data = &m88ts2022_config;
+			request_module(info.type);
+			client_tuner = i2c_new_device(adapter, &info);
+			if (client_tuner == NULL ||
+					client_tuner->dev.driver == NULL)
+				goto frontend_detach;
+			if (!try_module_get(client_tuner->dev.driver->owner)) {
+				i2c_unregister_device(client_tuner);
+				goto frontend_detach;
+			}
+
+			/* delegate signal strength measurement to tuner */
+			fe0->dvb.frontend->ops.read_signal_strength =
+				fe0->dvb.frontend->ops.tuner_ops.get_rf_strength;
+
+			/*
+			 * for setting the voltage we need to set GPIOs on
+			 * the card.
+			 */
+			port->fe_set_voltage =
+				fe0->dvb.frontend->ops.set_voltage;
+			fe0->dvb.frontend->ops.set_voltage =
+				dvbsky_t9580_set_voltage;
+
+			port->i2c_client_tuner = client_tuner;
+
+			break;
+		/* port c - terrestrial/cable */
+		case 2:
+			/* attach frontend */
+			si2168_config.i2c_adapter = &adapter;
+			si2168_config.fe = &fe0->dvb.frontend;
+			si2168_config.ts_mode = SI2168_TS_SERIAL;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			info.addr = 0x64;
+			info.platform_data = &si2168_config;
+			request_module(info.type);
+			client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
+			if (client_demod == NULL ||
+					client_demod->dev.driver == NULL)
+				goto frontend_detach;
+			if (!try_module_get(client_demod->dev.driver->owner)) {
+				i2c_unregister_device(client_demod);
+				goto frontend_detach;
+			}
+			port->i2c_client_demod = client_demod;
+
+			/* attach tuner */
+			si2157_config.fe = fe0->dvb.frontend;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			info.addr = 0x60;
+			info.platform_data = &si2157_config;
+			request_module(info.type);
+			client_tuner = i2c_new_device(adapter, &info);
+			if (client_tuner == NULL ||
+					client_tuner->dev.driver == NULL) {
+				module_put(client_demod->dev.driver->owner);
+				i2c_unregister_device(client_demod);
+				goto frontend_detach;
+			}
+			if (!try_module_get(client_tuner->dev.driver->owner)) {
+				i2c_unregister_device(client_tuner);
+				module_put(client_demod->dev.driver->owner);
+				i2c_unregister_device(client_demod);
+				goto frontend_detach;
+			}
+			port->i2c_client_tuner = client_tuner;
+			break;
+		}
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
@@ -1575,6 +1719,22 @@ static int dvb_register(struct cx23885_tsport *port)
 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
 		break;
 		}
+	case CX23885_BOARD_DVBSKY_T9580: {
+		u8 eeprom[256]; /* 24C02 i2c eeprom */
+
+		if (port->nr > 2)
+			break;
+
+		/* Read entire EEPROM */
+		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
+		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
+				sizeof(eeprom));
+		printk(KERN_INFO "DVBSky T9580 port %d MAC address: %pM\n",
+			port->nr, eeprom + 0xc0 + (port->nr-1) * 8);
+		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0 +
+			(port->nr-1) * 8, 6);
+		break;
+		}
 	}
 
 	return ret;
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index e60ff7f..f9a23b6 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -98,6 +98,7 @@
 #define CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200 42
 #define CX23885_BOARD_HAUPPAUGE_IMPACTVCBE     43
 #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2 44
+#define CX23885_BOARD_DVBSKY_T9580             45
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.9.1

