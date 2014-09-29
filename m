Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48866 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaI2Hoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 03:44:32 -0400
Received: by mail-lb0-f177.google.com with SMTP id w7so605578lbi.36
        for <linux-media@vger.kernel.org>; Mon, 29 Sep 2014 00:44:30 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/5] cx23855: add support for DVBSky T980C (no CI support)
Date: Mon, 29 Sep 2014 10:44:16 +0300
Message-Id: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds basic support for DVBSky T980C card. CI interface is not supported.

DVBSky T980C is a PCIe card with the following components:
- CX23885 PCIe bridge
- Si2168-A20 demodulator
- Si2158-A20 tuner
- CIMaX SP2 CI chip

The demodulator and tuner need firmware. They're the same as used with TT CT2-4650 CI:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg78033.html

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 40 ++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-dvb.c   | 61 +++++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 3 files changed, 102 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 88c257d..e8965e6 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -680,6 +680,10 @@ struct cx23885_board cx23885_boards[] = {
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_DVBSKY_T980C] = {
+		.name		= "DVBSky T980C",
+		.portb		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -939,6 +943,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x4254,
 		.subdevice = 0x9580,
 		.card      = CX23885_BOARD_DVBSKY_T9580,
+	}, {
+		.subvendor = 0x4254,
+		.subdevice = 0x980c,
+		.card      = CX23885_BOARD_DVBSKY_T980C,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1541,6 +1549,36 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		mdelay(100);
 		cx23885_gpio_set(dev, GPIO_2 | GPIO_11);
 		break;
+	case CX23885_BOARD_DVBSKY_T980C:
+		/*
+		 * GPIO-0 INTA from CiMax, input
+		 * GPIO-1 reset CiMax, output, high active
+		 * GPIO-2 reset demod, output, low active
+		 * GPIO-3 to GPIO-10 data/addr for CAM
+		 * GPIO-11 ~CS0 to CiMax1
+		 * GPIO-12 ~CS1 to CiMax2
+		 * GPIO-13 ADL0 load LSB addr
+		 * GPIO-14 ADL1 load MSB addr
+		 * GPIO-15 ~RDY from CiMax
+		 * GPIO-17 ~RD to CiMax
+		 * GPIO-18 ~WR to CiMax
+		 */
+
+		cx_set(GP0_IO, 0x00060002); /* GPIO 1/2 as output */
+		cx_clear(GP0_IO, 0x00010004); /* GPIO 0 as input */
+		mdelay(100); /* reset delay */
+		cx_set(GP0_IO, 0x00060004); /* GPIO as out, reset high */
+		cx_clear(GP0_IO, 0x00010002);
+		cx_write(MC417_CTL, 0x00000037); /* enable GPIO3-18 pins */
+
+		/* GPIO-15 IN as ~ACK, rest as OUT */
+		cx_write(MC417_OEN, 0x00001000);
+
+		/* ~RD, ~WR high; ADL0, ADL1 low; ~CS0, ~CS1 high */
+		cx_write(MC417_RWD, 0x0000c300);
+
+		/* enable irq */
+		cx_write(GPIO_ISM, 0x00000000); /* INTERRUPTS active low */
 	}
 }
 
@@ -1817,6 +1855,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_TEVII_S471:
 	case CX23885_BOARD_DVBWORLD_2005:
 	case CX23885_BOARD_PROF_8000:
+	case CX23885_BOARD_DVBSKY_T980C:
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
@@ -1935,6 +1974,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_TBS_6980:
 	case CX23885_BOARD_TBS_6981:
 	case CX23885_BOARD_DVBSKY_T9580:
+	case CX23885_BOARD_DVBSKY_T980C:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 2f532c9..d327459 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1681,6 +1681,52 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		}
 		break;
+	case CX23885_BOARD_DVBSKY_T980C:
+		i2c_bus = &dev->i2c_bus[1];
+
+		/* attach frontend */
+		memset(&si2168_config, 0, sizeof(si2168_config));
+		si2168_config.i2c_adapter = &adapter;
+		si2168_config.fe = &fe0->dvb.frontend;
+		si2168_config.ts_mode = SI2168_TS_PARALLEL;
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+		info.addr = 0x64;
+		info.platform_data = &si2168_config;
+		request_module(info.type);
+		client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
+		if (client_demod == NULL ||
+				client_demod->dev.driver == NULL)
+			goto frontend_detach;
+		if (!try_module_get(client_demod->dev.driver->owner)) {
+			i2c_unregister_device(client_demod);
+			goto frontend_detach;
+		}
+		port->i2c_client_demod = client_demod;
+
+		/* attach tuner */
+		memset(&si2157_config, 0, sizeof(si2157_config));
+		si2157_config.fe = fe0->dvb.frontend;
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+		info.addr = 0x60;
+		info.platform_data = &si2157_config;
+		request_module(info.type);
+		client_tuner = i2c_new_device(adapter, &info);
+		if (client_tuner == NULL ||
+				client_tuner->dev.driver == NULL) {
+			module_put(client_demod->dev.driver->owner);
+			i2c_unregister_device(client_demod);
+			goto frontend_detach;
+		}
+		if (!try_module_get(client_tuner->dev.driver->owner)) {
+			i2c_unregister_device(client_tuner);
+			module_put(client_demod->dev.driver->owner);
+			i2c_unregister_device(client_demod);
+			goto frontend_detach;
+		}
+		port->i2c_client_tuner = client_tuner;
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
@@ -1771,6 +1817,21 @@ static int dvb_register(struct cx23885_tsport *port)
 			(port->nr-1) * 8, 6);
 		break;
 		}
+	case CX23885_BOARD_DVBSKY_T980C: {
+		u8 eeprom[256]; /* 24C02 i2c eeprom */
+
+		if (port->nr != 1)
+			break;
+
+		/* Read entire EEPROM */
+		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
+		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
+				sizeof(eeprom));
+		printk(KERN_INFO "DVBSky T980C MAC address: %pM\n",
+			eeprom + 0xc0);
+		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0, 6);
+		break;
+		}
 	}
 
 	return ret;
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 06088a0..1792d1a 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -93,6 +93,7 @@
 #define CX23885_BOARD_HAUPPAUGE_IMPACTVCBE     43
 #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2 44
 #define CX23885_BOARD_DVBSKY_T9580             45
+#define CX23885_BOARD_DVBSKY_T980C             46
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.9.1

