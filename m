Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:53919 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbaJ3Usj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:48:39 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so543604lam.14
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 13:48:37 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] cx23885: add support for TechnoTrend CT2-4500 CI
Date: Thu, 30 Oct 2014 22:48:27 +0200
Message-Id: <1414702107-24963-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TechnoTrend CT2-4500 CI is a PCIe device with DVB-T2/C tuner. It is similar to DVBSky T980C, just with different PCI ID and remote controller.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 14 ++++++++++++++
 drivers/media/pci/cx23885/cx23885-dvb.c   |  8 +++++---
 drivers/media/pci/cx23885/cx23885-input.c |  8 ++++++++
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index d9ba48c..9c7e8ac 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -688,6 +688,10 @@ struct cx23885_board cx23885_boards[] = {
 		.name		= "DVBSky S950C",
 		.portb		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_TT_CT2_4500_CI] = {
+		.name		= "Technotrend TT-budget CT2-4500 CI",
+		.portb		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -955,6 +959,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x4254,
 		.subdevice = 0x950c,
 		.card      = CX23885_BOARD_DVBSKY_S950C,
+	}, {
+		.subvendor = 0x13c2,
+		.subdevice = 0x3013,
+		.card      = CX23885_BOARD_TT_CT2_4500_CI,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1559,6 +1567,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_DVBSKY_T980C:
 	case CX23885_BOARD_DVBSKY_S950C:
+	case CX23885_BOARD_TT_CT2_4500_CI:
 		/*
 		 * GPIO-0 INTA from CiMax, input
 		 * GPIO-1 reset CiMax, output, high active
@@ -1671,6 +1680,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_T9580:
 	case CX23885_BOARD_DVBSKY_T980C:
 	case CX23885_BOARD_DVBSKY_S950C:
+	case CX23885_BOARD_TT_CT2_4500_CI:
 		if (!enable_885_ir)
 			break;
 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
@@ -1720,6 +1730,7 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_T9580:
 	case CX23885_BOARD_DVBSKY_T980C:
 	case CX23885_BOARD_DVBSKY_S950C:
+	case CX23885_BOARD_TT_CT2_4500_CI:
 		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
 		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
 		dev->sd_ir = NULL;
@@ -1770,6 +1781,7 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_T9580:
 	case CX23885_BOARD_DVBSKY_T980C:
 	case CX23885_BOARD_DVBSKY_S950C:
+	case CX23885_BOARD_TT_CT2_4500_CI:
 		if (dev->sd_ir)
 			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
 		break;
@@ -1875,6 +1887,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_PROF_8000:
 	case CX23885_BOARD_DVBSKY_T980C:
 	case CX23885_BOARD_DVBSKY_S950C:
+	case CX23885_BOARD_TT_CT2_4500_CI:
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
@@ -1995,6 +2008,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_T9580:
 	case CX23885_BOARD_DVBSKY_T980C:
 	case CX23885_BOARD_DVBSKY_S950C:
+	case CX23885_BOARD_TT_CT2_4500_CI:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index f82eb18..5e6caed 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1766,6 +1766,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		break;
 	case CX23885_BOARD_DVBSKY_T980C:
+	case CX23885_BOARD_TT_CT2_4500_CI:
 		i2c_bus = &dev->i2c_bus[1];
 		i2c_bus2 = &dev->i2c_bus[0];
 
@@ -1938,7 +1939,8 @@ static int dvb_register(struct cx23885_tsport *port)
 		break;
 		}
 	case CX23885_BOARD_DVBSKY_S950C:
-	case CX23885_BOARD_DVBSKY_T980C: {
+	case CX23885_BOARD_DVBSKY_T980C:
+	case CX23885_BOARD_TT_CT2_4500_CI: {
 		u8 eeprom[256]; /* 24C02 i2c eeprom */
 
 		/* attach CI */
@@ -1985,8 +1987,8 @@ static int dvb_register(struct cx23885_tsport *port)
 		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
 				sizeof(eeprom));
-		printk(KERN_INFO "DVBSky T980C/S950C MAC address: %pM\n",
-			eeprom + 0xc0);
+		printk(KERN_INFO "%s MAC address: %pM\n",
+			cx23885_boards[dev->board].name, eeprom + 0xc0);
 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0, 6);
 		break;
 		}
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 0bf6839..12d8a3d 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -90,6 +90,7 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 	case CX23885_BOARD_DVBSKY_T9580:
 	case CX23885_BOARD_DVBSKY_T980C:
 	case CX23885_BOARD_DVBSKY_S950C:
+	case CX23885_BOARD_TT_CT2_4500_CI:
 		/*
 		 * The only boards we handle right now.  However other boards
 		 * using the CX2388x integrated IR controller should be similar
@@ -145,6 +146,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_T9580:
 	case CX23885_BOARD_DVBSKY_T980C:
 	case CX23885_BOARD_DVBSKY_S950C:
+	case CX23885_BOARD_TT_CT2_4500_CI:
 		/*
 		 * The IR controller on this board only returns pulse widths.
 		 * Any other mode setting will fail to set up the device.
@@ -319,6 +321,12 @@ int cx23885_input_init(struct cx23885_dev *dev)
 		allowed_protos = RC_BIT_ALL;
 		rc_map = RC_MAP_DVBSKY;
 		break;
+	case CX23885_BOARD_TT_CT2_4500_CI:
+		/* Integrated CX23885 IR controller */
+		driver_type = RC_DRIVER_IR_RAW;
+		allowed_protos = RC_BIT_ALL;
+		rc_map = RC_MAP_TT_1500;
+		break;
 	default:
 		return -ENODEV;
 	}
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index f6f6974..7eee2ea 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -95,6 +95,7 @@
 #define CX23885_BOARD_DVBSKY_T9580             45
 #define CX23885_BOARD_DVBSKY_T980C             46
 #define CX23885_BOARD_DVBSKY_S950C             47
+#define CX23885_BOARD_TT_CT2_4500_CI           48
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.9.1

