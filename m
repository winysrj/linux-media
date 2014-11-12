Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:52463 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbaKLEXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:23:17 -0500
Received: by mail-pd0-f179.google.com with SMTP id g10so11481593pdj.38
        for <linux-media@vger.kernel.org>; Tue, 11 Nov 2014 20:23:17 -0800 (PST)
Date: Wed, 12 Nov 2014 12:23:12 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Antti Palosaari" <crope@iki.fi>
Subject: [PATCH 1/1] cx23885: add DVBSky T982(Dual DVB-T2/T/C) support
Message-ID: <201411121223097349719@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBSky T982 DVB-T2/T/C dual PCIe card:
1>dvb frontend: SI2158A20(tuner),SI2168A30(demod)
2>PCIe bridge: CX23885(port b: parallel mode, port c: serial mode)
3>rc: cx23885 integrated.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 15 ++++++++
 drivers/media/pci/cx23885/cx23885-dvb.c   | 60 ++++++++++++++++++++++++++++++-
 drivers/media/pci/cx23885/cx23885-input.c |  3 ++
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 4 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 4bad27d..db99ca2 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -701,6 +701,11 @@ struct cx23885_board cx23885_boards[] = {
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_DVBSKY_T982] = {
+		.name		= "DVBSky T982",
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -980,6 +985,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x4254,
 		.subdevice = 0x0952,
 		.card      = CX23885_BOARD_DVBSKY_S952,
+	}, {
+		.subvendor = 0x4254,
+		.subdevice = 0x0982,
+		.card      = CX23885_BOARD_DVBSKY_T982,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1576,6 +1585,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_DVBSKY_T9580:
 	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982:
 		/* enable GPIO3-18 pins */
 		cx_write(MC417_CTL, 0x00000037);
 		cx23885_gpio_enable(dev, GPIO_2 | GPIO_11, 1);
@@ -1708,6 +1718,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_TT_CT2_4500_CI:
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982:
 		if (!enable_885_ir)
 			break;
 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
@@ -1760,6 +1771,7 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
 	case CX23885_BOARD_TT_CT2_4500_CI:
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982:
 		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
 		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
 		dev->sd_ir = NULL;
@@ -1813,6 +1825,7 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
 	case CX23885_BOARD_TT_CT2_4500_CI:
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982:
 		if (dev->sd_ir)
 			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
 		break;
@@ -1968,6 +1981,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
 	case CX23885_BOARD_DVBSKY_T9580:
+	case CX23885_BOARD_DVBSKY_T982:
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
@@ -2051,6 +2065,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_TT_CT2_4500_CI:
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 2457b64..1ed92ee 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1945,6 +1945,63 @@ static int dvb_register(struct cx23885_tsport *port)
 
 		port->i2c_client_tuner = client_tuner;
 		break;
+	case CX23885_BOARD_DVBSKY_T982:
+		memset(&si2168_config, 0, sizeof(si2168_config));
+		switch (port->nr) {
+		/* port b */
+		case 1:
+			i2c_bus = &dev->i2c_bus[1];
+			si2168_config.ts_mode = SI2168_TS_PARALLEL;
+			break;
+		/* port c */
+		case 2:
+			i2c_bus = &dev->i2c_bus[0];
+			si2168_config.ts_mode = SI2168_TS_SERIAL;
+			break;
+		}
+
+		/* attach frontend */
+		si2168_config.i2c_adapter = &adapter;
+		si2168_config.fe = &fe0->dvb.frontend;
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
+			port->i2c_client_demod = NULL;
+			goto frontend_detach;
+		}
+		port->i2c_client_tuner = client_tuner;
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
@@ -2021,7 +2078,8 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 	case CX23885_BOARD_DVBSKY_T9580:
 	case CX23885_BOARD_DVBSKY_S950:
-	case CX23885_BOARD_DVBSKY_S952: {
+	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982: {
 		u8 eeprom[256]; /* 24C02 i2c eeprom */
 
 		if (port->nr > 2)
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index a1f4894..088799c 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -93,6 +93,7 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 	case CX23885_BOARD_TT_CT2_4500_CI:
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982:
 		/*
 		 * The only boards we handle right now.  However other boards
 		 * using the CX2388x integrated IR controller should be similar
@@ -151,6 +152,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 	case CX23885_BOARD_TT_CT2_4500_CI:
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982:
 		/*
 		 * The IR controller on this board only returns pulse widths.
 		 * Any other mode setting will fail to set up the device.
@@ -322,6 +324,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_S950C:
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
 		allowed_protos = RC_BIT_ALL;
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 58c5038..cf4efa4 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -98,6 +98,7 @@
 #define CX23885_BOARD_TT_CT2_4500_CI           48
 #define CX23885_BOARD_DVBSKY_S950              49
 #define CX23885_BOARD_DVBSKY_S952              50
+#define CX23885_BOARD_DVBSKY_T982              51
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002

-- 
1.9.1

