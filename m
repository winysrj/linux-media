Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44359 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753908AbeBLVIQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 16:08:16 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 3/4] cx23885: Add support for Hauppauge PCIe Starburst2
Date: Mon, 12 Feb 2018 15:08:10 -0600
Message-Id: <1518469690-24213-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515199702-16083-4-git-send-email-brad@nextdimension.cc>
References: <1515199702-16083-4-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new PCIe DVB-S/S2.
A single port Hauppauge HVR-5525

cx23885 + a8293 + m88rs6000t

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- regen for dependency

 drivers/media/pci/cx23885/cx23885-cards.c | 11 +++++++++++
 drivers/media/pci/cx23885/cx23885-dvb.c   | 18 ++++++++++--------
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 2cc6390..4474d1b 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -797,6 +797,10 @@ struct cx23885_board cx23885_boards[] = {
 			.amux   = CX25840_AUDIO7,
 		} },
 	},
+	[CX23885_BOARD_HAUPPAUGE_STARBURST2] = {
+		.name		= "Hauppauge WinTV-Starburst2",
+		.portb		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -1112,6 +1116,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x0070,
 		.subdevice = 0x2a18,
 		.card      = CX23885_BOARD_HAUPPAUGE_HVR1265_K4, /* Hauppauge WinTV HVR-1265 (Model 161xx1, Hybrid ATSC/QAM-B) */
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0xf02a,
+		.card      = CX23885_BOARD_HAUPPAUGE_STARBURST2,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1808,6 +1816,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR5525:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
+	case CX23885_BOARD_HAUPPAUGE_STARBURST2:
 		/*
 		 * HVR5525 GPIO Details:
 		 *  GPIO-00 IR_WIDE
@@ -2095,6 +2104,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
 	case CX23885_BOARD_HAUPPAUGE_HVR5525:
 	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+	case CX23885_BOARD_HAUPPAUGE_STARBURST2:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
 		if (dev->i2c_bus[0].i2c_rc == 0)
@@ -2235,6 +2245,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR5525:
+	case CX23885_BOARD_HAUPPAUGE_STARBURST2:
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 2b23636..260d843 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1206,6 +1206,8 @@ static int dvb_register(struct cx23885_tsport *port)
 	struct si2157_config si2157_config;
 	struct ts2020_config ts2020_config;
 	struct m88ds3103_platform_data m88ds3103_pdata;
+	struct m88rs6000t_config m88rs6000t_config = {};
+	struct a8293_platform_data a8293_pdata = {};
 	struct i2c_board_info info;
 	struct i2c_adapter *adapter;
 	struct i2c_client *client_demod = NULL, *client_tuner = NULL;
@@ -2229,9 +2231,10 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		port->i2c_client_tuner = client_tuner;
 		break;
-	case CX23885_BOARD_HAUPPAUGE_HVR5525: {
-		struct m88rs6000t_config m88rs6000t_config;
-		struct a8293_platform_data a8293_pdata = {};
+	case CX23885_BOARD_HAUPPAUGE_STARBURST2:
+	case CX23885_BOARD_HAUPPAUGE_HVR5525:
+		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus2 = &dev->i2c_bus[1];
 
 		switch (port->nr) {
 
@@ -2240,7 +2243,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			/* attach frontend */
 			fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
 					&hauppauge_hvr5525_m88ds3103_config,
-					&dev->i2c_bus[0].i2c_adap, &adapter);
+					&i2c_bus->i2c_adap, &adapter);
 			if (fe0->dvb.frontend == NULL)
 				break;
 
@@ -2251,7 +2254,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			info.addr = 0x0b;
 			info.platform_data = &a8293_pdata;
 			request_module("a8293");
-			client_sec = i2c_new_device(&dev->i2c_bus[0].i2c_adap, &info);
+			client_sec = i2c_new_device(&i2c_bus->i2c_adap, &info);
 			if (!client_sec || !client_sec->dev.driver)
 				goto frontend_detach;
 			if (!try_module_get(client_sec->dev.driver->owner)) {
@@ -2293,7 +2296,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			info.addr = 0x64;
 			info.platform_data = &si2168_config;
 			request_module("%s", info.type);
-			client_demod = i2c_new_device(&dev->i2c_bus[0].i2c_adap, &info);
+			client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
 			if (!client_demod || !client_demod->dev.driver)
 				goto frontend_detach;
 			if (!try_module_get(client_demod->dev.driver->owner)) {
@@ -2311,7 +2314,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			info.addr = 0x60;
 			info.platform_data = &si2157_config;
 			request_module("%s", info.type);
-			client_tuner = i2c_new_device(&dev->i2c_bus[1].i2c_adap, &info);
+			client_tuner = i2c_new_device(&i2c_bus2->i2c_adap, &info);
 			if (!client_tuner || !client_tuner->dev.driver) {
 				module_put(client_demod->dev.driver->owner);
 				i2c_unregister_device(client_demod);
@@ -2329,7 +2332,6 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		}
 		break;
-	}
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
 		switch (port->nr) {
 		/* port b - Terrestrial/cable */
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 7c7a103..197fe64 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -108,6 +108,7 @@
 #define CX23885_BOARD_HAUPPAUGE_QUADHD_DVB     56
 #define CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC    57
 #define CX23885_BOARD_HAUPPAUGE_HVR1265_K4     58
+#define CX23885_BOARD_HAUPPAUGE_STARBURST2     59
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
2.7.4
