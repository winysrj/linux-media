Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36111 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbbC0L5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 07:57:43 -0400
Received: by lbbug6 with SMTP id ug6so61768233lbb.3
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 04:57:41 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 5/5] saa7164: Hauppauge HVR-2205 and HVR-2215 DVB-C/T/T2 tuners
Date: Fri, 27 Mar 2015 13:57:19 +0200
Message-Id: <1427457439-1493-5-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
References: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge HVR-2205 and HVR-2215 are PCIe dual tuner cards that support
DVB-C, DVB-T and DVB-T2.

PCIe bridge: SAA7164
Demodulator: Si2168-B40
Tuner: SI2157-A20

I know there's parallel activity ongoing regarding these devices, but I 
thought I'll submit my own version here as well. The maintainers of each 
module can then make the call what to merge.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/saa7164/Kconfig         |   2 +
 drivers/media/pci/saa7164/saa7164-cards.c | 101 ++++++++++++++++++++++++++++++
 drivers/media/pci/saa7164/saa7164-dvb.c   |  67 ++++++++++++++++++++
 drivers/media/pci/saa7164/saa7164.h       |   2 +
 4 files changed, 172 insertions(+)

diff --git a/drivers/media/pci/saa7164/Kconfig b/drivers/media/pci/saa7164/Kconfig
index a53db7d..5ebe930 100644
--- a/drivers/media/pci/saa7164/Kconfig
+++ b/drivers/media/pci/saa7164/Kconfig
@@ -8,7 +8,9 @@ config VIDEO_SAA7164
 	select VIDEOBUF_DVB
 	select DVB_TDA10048 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for NXP SAA7164 based
 	  TV cards.
diff --git a/drivers/media/pci/saa7164/saa7164-cards.c b/drivers/media/pci/saa7164/saa7164-cards.c
index 5b72da5..5ebd312 100644
--- a/drivers/media/pci/saa7164/saa7164-cards.c
+++ b/drivers/media/pci/saa7164/saa7164-cards.c
@@ -499,6 +499,90 @@ struct saa7164_board saa7164_boards[] = {
 			.i2c_reg_len	= REGLEN_8bit,
 		} },
 	},
+	[SAA7164_BOARD_HAUPPAUGE_HVR2205] = {
+		.name		= "Hauppauge WinTV-HVR2205",
+		.porta		= SAA7164_MPEG_DVB,
+		.portb		= SAA7164_MPEG_DVB,
+		.chiprev	= SAA7164_CHIP_REV3,
+		.unit = {{
+			.id = 0x28,
+			.type = SAA7164_UNIT_EEPROM,
+			.name = "4K EEPROM",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_0,
+			.i2c_bus_addr	= 0xa0 >> 1,
+			.i2c_reg_len	= REGLEN_8bit,
+		}, {
+			.id		= 0x04,
+			.type		= SAA7164_UNIT_TUNER,
+			.name		= "SI2157-1",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
+			.i2c_bus_addr	= 0xc0 >> 1,
+			.i2c_reg_len	= 0,
+		}, {
+			.id		= 0x05,
+			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
+			.name		= "SI2168-1",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
+			.i2c_bus_addr	= 0xc8 >> 1,
+			.i2c_reg_len	= 0,
+		}, {
+			.id		= 0x25,
+			.type		= SAA7164_UNIT_TUNER,
+			.name		= "SI2157-2",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
+			.i2c_bus_addr	= 0xc0 >> 1,
+			.i2c_reg_len	= 0,
+		}, {
+			.id		= 0x26,
+			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
+			.name		= "SI2168-2",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
+			.i2c_bus_addr	= 0xcc >> 1,
+			.i2c_reg_len	= 0,
+		} },
+	},
+	[SAA7164_BOARD_HAUPPAUGE_HVR2215] = {
+		.name		= "Hauppauge WinTV-HVR2215",
+		.porta		= SAA7164_MPEG_DVB,
+		.portb		= SAA7164_MPEG_DVB,
+		.chiprev	= SAA7164_CHIP_REV3,
+		.unit = {{
+			.id = 0x28,
+			.type = SAA7164_UNIT_EEPROM,
+			.name = "4K EEPROM",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_0,
+			.i2c_bus_addr	= 0xa0 >> 1,
+			.i2c_reg_len	= REGLEN_8bit,
+		}, {
+			.id		= 0x04,
+			.type		= SAA7164_UNIT_TUNER,
+			.name		= "SI2157-1",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
+			.i2c_bus_addr	= 0xc0 >> 1,
+			.i2c_reg_len	= 0,
+		}, {
+			.id		= 0x05,
+			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
+			.name		= "SI2168-1",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
+			.i2c_bus_addr	= 0xc8 >> 1,
+			.i2c_reg_len	= 0,
+		}, {
+			.id		= 0x25,
+			.type		= SAA7164_UNIT_TUNER,
+			.name		= "SI2157-2",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
+			.i2c_bus_addr	= 0xc0 >> 1,
+			.i2c_reg_len	= 0,
+		}, {
+			.id		= 0x26,
+			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
+			.name		= "SI2168-2",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
+			.i2c_bus_addr	= 0xcc >> 1,
+			.i2c_reg_len	= 0,
+		} },
+	},
 };
 const unsigned int saa7164_bcount = ARRAY_SIZE(saa7164_boards);
 
@@ -546,6 +630,14 @@ struct saa7164_subid saa7164_subids[] = {
 		.subvendor = 0x0070,
 		.subdevice = 0x8953,
 		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2200_5,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0xf120,
+		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2205,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0xf123,
+		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2215,
 	},
 };
 const unsigned int saa7164_idcount = ARRAY_SIZE(saa7164_subids);
@@ -591,6 +683,8 @@ void saa7164_gpio_setup(struct saa7164_dev *dev)
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_4:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_5:
+	case SAA7164_BOARD_HAUPPAUGE_HVR2205:
+	case SAA7164_BOARD_HAUPPAUGE_HVR2215:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_2:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_3:
@@ -647,6 +741,11 @@ static void hauppauge_eeprom(struct saa7164_dev *dev, u8 *eeprom_data)
 		/* WinTV-HVR2200 (PCIe, Retail, half-height)
 		 * DVB-T (TDA18271/TDA10048) and basic analog, no IR */
 		break;
+	case 151009:
+	case 151609:
+		/* WinTV-HVR2205/HVR2215 (PCIe, Retail, full-height bracket)
+		 * DVB-T2/C (Si2157/Si2168) and basic analog, FM */
+		break;
 	default:
 		printk(KERN_ERR "%s: Warning: Unknown Hauppauge model #%d\n",
 			dev->name, tv.model);
@@ -673,6 +772,8 @@ void saa7164_card_setup(struct saa7164_dev *dev)
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_4:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_5:
+	case SAA7164_BOARD_HAUPPAUGE_HVR2205:
+	case SAA7164_BOARD_HAUPPAUGE_HVR2215:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_2:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_3:
diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
index 6b9e8f6..2242ef5 100644
--- a/drivers/media/pci/saa7164/saa7164-dvb.c
+++ b/drivers/media/pci/saa7164/saa7164-dvb.c
@@ -24,6 +24,8 @@
 #include "tda10048.h"
 #include "tda18271.h"
 #include "s5h1411.h"
+#include "si2168.h"
+#include "si2157.h"
 
 #define DRIVER_NAME "saa7164"
 
@@ -519,6 +521,71 @@ int saa7164_dvb_register(struct saa7164_port *port)
 			break;
 		}
 		break;
+	case SAA7164_BOARD_HAUPPAUGE_HVR2205:
+	case SAA7164_BOARD_HAUPPAUGE_HVR2215:
+		{
+			struct si2168_config si2168_config;
+			struct si2157_config si2157_config;
+			struct i2c_board_info info;
+			struct i2c_adapter *adapter;
+			struct i2c_client *client_demod = NULL;
+			struct i2c_client *client_tuner = NULL;
+
+			i2c_bus = &dev->i2c_bus[port->nr + 1];
+
+			/* attach frontend */
+			memset(&si2168_config, 0, sizeof(si2168_config));
+			si2168_config.i2c_adapter = &adapter;
+			si2168_config.fe = &port->dvb.frontend;
+			si2168_config.ts_mode = SI2168_TS_SERIAL;
+			si2168_config.ts_clock_gapped = true;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			switch (port->nr) {
+			case 0:
+				info.addr = 0xc8 >> 1;
+				break;
+			case 1:
+				info.addr = 0xcc >> 1;
+				break;
+			}
+			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			info.platform_data = &si2168_config;
+			request_module(info.type);
+			client_demod = i2c_new_device(&i2c_bus->i2c_adap,
+						      &info);
+			if (client_demod == NULL ||
+					client_demod->dev.driver == NULL)
+				break;
+			if (!try_module_get(client_demod->dev.driver->owner)) {
+				i2c_unregister_device(client_demod);
+				break;
+			}
+			port->i2c_client_demod = client_demod;
+
+			/* attach tuner */
+			memset(&si2157_config, 0, sizeof(si2157_config));
+			si2157_config.fe = port->dvb.frontend;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			info.addr = 0xc0 >> 1;
+			info.platform_data = &si2157_config;
+			request_module(info.type);
+			client_tuner = i2c_new_device(adapter, &info);
+			if (client_tuner == NULL ||
+					client_tuner->dev.driver == NULL) {
+				module_put(client_demod->dev.driver->owner);
+				i2c_unregister_device(client_demod);
+				break;
+			}
+			if (!try_module_get(client_tuner->dev.driver->owner)) {
+				i2c_unregister_device(client_tuner);
+				module_put(client_demod->dev.driver->owner);
+				i2c_unregister_device(client_demod);
+				break;
+			}
+			port->i2c_client_tuner = client_tuner;
+			break;
+		}
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_2:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_3:
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index 37e450a..1b41849 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -83,6 +83,8 @@
 #define SAA7164_BOARD_HAUPPAUGE_HVR2250_3	8
 #define SAA7164_BOARD_HAUPPAUGE_HVR2200_4	9
 #define SAA7164_BOARD_HAUPPAUGE_HVR2200_5	10
+#define SAA7164_BOARD_HAUPPAUGE_HVR2205		11
+#define SAA7164_BOARD_HAUPPAUGE_HVR2215		12
 
 #define SAA7164_MAX_UNITS		8
 #define SAA7164_TS_NUMBER_OF_LINES	312
-- 
1.9.1

