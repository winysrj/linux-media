Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44385 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753859AbeBLVJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 16:09:03 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 4/4] cx23885: Add support for new Hauppauge QuadHD (885)
Date: Mon, 12 Feb 2018 15:08:56 -0600
Message-Id: <1518469736-24342-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515199702-16083-5-git-send-email-brad@nextdimension.cc>
References: <1515199702-16083-5-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new QuadHD digital only PCIe boards to driver list.
Differentiate them from 888 digital/analog QuadHD models.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- regen for dependency

 drivers/media/pci/cx23885/cx23885-cards.c | 42 ++++++++++++++++++++++---------
 drivers/media/pci/cx23885/cx23885-core.c  |  8 ++++++
 drivers/media/pci/cx23885/cx23885-dvb.c   |  6 +++++
 drivers/media/pci/cx23885/cx23885.h       |  2 ++
 4 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 4474d1b..7c64880 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -771,11 +771,21 @@ struct cx23885_board cx23885_boards[] = {
 		.portb        = CX23885_MPEG_DVB,
 		.portc        = CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885] = {
+		.name       = "Hauppauge WinTV-QuadHD-DVB(885)",
+		.portb        = CX23885_MPEG_DVB,
+		.portc        = CX23885_MPEG_DVB,
+	},
 	[CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC] = {
 		.name        = "Hauppauge WinTV-QuadHD-ATSC",
 		.portb        = CX23885_MPEG_DVB,
 		.portc        = CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885] = {
+		.name       = "Hauppauge WinTV-QuadHD-ATSC(885)",
+		.portb        = CX23885_MPEG_DVB,
+		.portc        = CX23885_MPEG_DVB,
+	},
 	[CX23885_BOARD_HAUPPAUGE_HVR1265_K4] = {
 		.name		= "Hauppauge WinTV-HVR-1265(161111)",
 		.porta		= CX23885_ANALOG_VIDEO,
@@ -1323,25 +1333,25 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 	case 161111:
 		/* WinTV-HVR-1265 K4 (PCIe, Analog/ATSC/QAM-B) */
 		break;
-	case 166100:
+	case 166100: /* 888 version, hybrid */
+	case 166200: /* 885 version, DVB only */
 		/* WinTV-QuadHD (DVB) Tuner Pair 1 (PCIe, IR, half height,
 		   DVB-T/T2/C, DVB-T/T2/C */
 		break;
-	case 166101:
+	case 166101: /* 888 version, hybrid */
+	case 166201: /* 885 version, DVB only */
 		/* WinTV-QuadHD (DVB) Tuner Pair 2 (PCIe, IR, half height,
 		   DVB-T/T2/C, DVB-T/T2/C */
 		break;
-	case 165100:
-		/*
-		 * WinTV-QuadHD (ATSC) Tuner Pair 1 (PCIe, IR, half height,
-		 * ATSC, ATSC
-		 */
+	case 165100: /* 888 version, hybrid */
+	case 165200: /* 885 version, digital only */
+		/* WinTV-QuadHD (ATSC) Tuner Pair 1 (PCIe, IR, half height,
+		 * ATSC/QAM-B, ATSC/QAM-B */
 		break;
-	case 165101:
-		/*
-		 * WinTV-QuadHD (DVB) Tuner Pair 2 (PCIe, IR, half height,
-		 * ATSC, ATSC
-		 */
+	case 165101: /* 888 version, hybrid */
+	case 165201: /* 885 version, digital only */
+		/* WinTV-QuadHD (ATSC) Tuner Pair 2 (PCIe, IR, half height,
+		 * ATSC/QAM-B, ATSC/QAM-B */
 		break;
 	default:
 		pr_warn("%s: warning: unknown hauppauge model #%d\n",
@@ -1847,6 +1857,8 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		 */
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885:
 		/*
 		 * GPIO-08 TER1_RESN
 		 * GPIO-09 TER2_RESN
@@ -2106,7 +2118,9 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 	case CX23885_BOARD_HAUPPAUGE_STARBURST2:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885:
 		if (dev->i2c_bus[0].i2c_rc == 0)
 			hauppauge_eeprom(dev, eeprom+0xc0);
 		break;
@@ -2255,7 +2269,9 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885:
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885:
 		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
@@ -2313,6 +2329,8 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
 	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_MYGICA_X8506:
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 8f63df1..8afddd6 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -869,6 +869,14 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 		cx23885_card_list(dev);
 	}
 
+	if (dev->pci->device == 0x8852) {
+		/* no DIF on cx23885, so no analog tuner support possible */
+		if (dev->board == CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC)
+			dev->board = CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885;
+		else if (dev->board == CX23885_BOARD_HAUPPAUGE_QUADHD_DVB)
+			dev->board = CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885;
+	}
+
 	/* If the user specific a clk freq override, apply it */
 	if (cx23885_boards[dev->board].clk_freq > 0)
 		dev->clk_freq = cx23885_boards[dev->board].clk_freq;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 260d843..2bd45ad 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -2333,6 +2333,9 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		break;
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885:
+		pr_info("%s(): board=%d port=%d\n", __func__,
+			dev->board, port->nr);
 		switch (port->nr) {
 		/* port b - Terrestrial/cable */
 		case 1:
@@ -2430,6 +2433,9 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		break;
 	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885:
+		pr_info("%s(): board=%d port=%d\n", __func__,
+			dev->board, port->nr);
 		switch (port->nr) {
 		/* port b - Terrestrial/cable */
 		case 1:
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 197fe64..d54c7ee 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -109,6 +109,8 @@
 #define CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC    57
 #define CX23885_BOARD_HAUPPAUGE_HVR1265_K4     58
 #define CX23885_BOARD_HAUPPAUGE_STARBURST2     59
+#define CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885 60
+#define CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885 61
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
2.7.4
