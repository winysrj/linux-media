Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:59334 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2AGNVN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 08:21:13 -0500
From: linxutv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH v3] cx23885: add Terratec Cinergy T PCIe dual
Date: Sat,  7 Jan 2012 14:20:48 +0100
Message-Id: <1325942448-13428-1-git-send-email-linxutv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/video/cx23885/cx23885-cards.c |   11 ++++++
 drivers/media/video/cx23885/cx23885-dvb.c   |   53 +++++++++++++++++++++++++++
 drivers/media/video/cx23885/cx23885.h       |    1 +
 3 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index dc7864e..3c01be9 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -492,6 +492,11 @@ struct cx23885_board cx23885_boards[] = {
 					CX25840_VIN7_CH3,
 			},
 		},
+	},
+	[CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL] = {
+		.name		= "TerraTec Cinergy T PCIe Dual",
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
 	}
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
@@ -696,6 +701,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x14f1,
 		.subdevice = 0x8502,
 		.card      = CX23885_BOARD_MYGICA_X8507,
+	}, {
+		.subvendor = 0x153b,
+		.subdevice = 0x117e,
+		.card      = CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1458,6 +1467,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
@@ -1530,6 +1540,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_MPX885:
 	case CX23885_BOARD_MYGICA_X8507:
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index a390622..af8a225 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -61,6 +61,8 @@
 #include "cx23885-f300.h"
 #include "altera-ci.h"
 #include "stv0367.h"
+#include "drxk.h"
+#include "mt2063.h"
 
 static unsigned int debug;
 
@@ -600,6 +602,24 @@ static struct xc5000_config netup_xc5000_config[] = {
 	},
 };
 
+static struct drxk_config terratec_drxk_config[] = {
+	{
+		.adr = 0x29,
+		.no_i2c_bridge = 1,
+	}, {
+		.adr = 0x2a,
+		.no_i2c_bridge = 1,
+	},
+};
+
+static struct mt2063_config terratec_mt2063_config[] = {
+	{
+		.tuner_address = 0x60,
+	}, {
+		.tuner_address = 0x67,
+	},
+};
+
 int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 {
 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
@@ -1115,6 +1135,39 @@ static int dvb_register(struct cx23885_tsport *port)
 				goto frontend_detach;
 		}
 		break;
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
+		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus2 = &dev->i2c_bus[1];
+
+		switch (port->nr) {
+		/* port b */
+		case 1:
+			fe0->dvb.frontend = dvb_attach(drxk_attach,
+					&terratec_drxk_config[0],
+					&i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend != NULL) {
+				if (!dvb_attach(mt2063_attach,
+						fe0->dvb.frontend,
+						&terratec_mt2063_config[0],
+						&i2c_bus2->i2c_adap))
+					goto frontend_detach;
+			}
+			break;
+		/* port c */
+		case 2:
+			fe0->dvb.frontend = dvb_attach(drxk_attach,
+					&terratec_drxk_config[1],
+					&i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend != NULL) {
+				if (!dvb_attach(mt2063_attach,
+						fe0->dvb.frontend,
+						&terratec_mt2063_config[1],
+						&i2c_bus2->i2c_adap))
+					goto frontend_detach;
+			}
+			break;
+		}
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 78fdb84..f020f05 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -88,6 +88,7 @@
 #define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000 31
 #define CX23885_BOARD_MPX885                   32
 #define CX23885_BOARD_MYGICA_X8507             33
+#define CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL 34
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.7.7

