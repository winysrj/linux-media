Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:22078 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1LQU57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 15:57:59 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 3/3] cx23885: add Terratec Cinergy T pcie dual
Date: Sat, 17 Dec 2011 21:57:17 +0100
Message-Id: <1324155437-15834-3-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de>
References: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/video/cx23885/cx23885-cards.c |   13 +++++
 drivers/media/video/cx23885/cx23885-dvb.c   |   66 +++++++++++++++++++++++++++
 drivers/media/video/cx23885/cx23885.h       |    1 +
 3 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index ac03c26..4704289 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -467,6 +467,13 @@ struct cx23885_board cx23885_boards[] = {
 					CX25840_VIN7_CH3,
 			},
 		},
+	[CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL] = {
+		.name		= "TerraTec Cinergy T PCIe Dual",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MOEG_DVB,
+		.num_fds_portc	= 2,
+		},
 	}
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
@@ -671,6 +678,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x14f1,
 		.subdevice = 0x8502,
 		.card      = CX23885_BOARD_MYGICA_X8507,
+	}, {
+		.subvendor = 0x153b,
+		.subdevice = 0x117e,
+		.card	   = CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1431,6 +1442,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
@@ -1504,6 +1516,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_MPX885:
 	case CX23885_BOARD_MYGICA_X8507:
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index bcb45be..c3b8285 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -61,6 +61,8 @@
 #include "cx23885-f300.h"
 #include "altera-ci.h"
 #include "stv0367.h"
+#include "drxk.h"
+#include "mt2063.h"
 
 static unsigned int debug;
 
@@ -617,6 +619,24 @@ static struct xc5000_config netup_xc5000_config[] = {
 	},
 };
 
+struct static drxk_config terratec_drxk_config[] = {
+	{
+		.adr = 0x29,
+		.no_i2c_bridge = 1,
+	}, {
+		.adr = 0x2a,
+		.no_i2c_bridge = 1,
+	},
+}
+
+struct static mt2063_config terratec_mt2063_config[] = {
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
@@ -1118,6 +1138,52 @@ static int dvb_register(struct cx23885_tsport *port)
 				goto frontend_detach;
 		}
 		break;
+	case CX23885_BOARD_TERRATREC_CINERGY_T_PCIE_DUAL:
+		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus2 = &dev->i2c_bus[1];
+		mfe_shared = 1;
+		fe1 = videobuf_dvb_get_frontend(&port->frontend, 2);
+
+		switch (port->nr) {
+		/* port B */
+		case 1:
+			/* fe0 dvb-t */
+			fe0->dvb.frontend = dvb_attach(drxk_attach,
+				&terratec_drxk_config[0],
+				&i2c_bus->i2c_adap, NULL);
+
+			if (fe0->dvb.frontend != NULL) {
+				if (!dvb_attach(mt2063_attach,
+						fe0->dvb.frontend,
+						&terratec_mt2063_config[0],
+						&i2c_bus2->i2c_adap))
+					goto frontend_deatch;
+			}
+			break;
+		/* port C */
+		case 2:
+			/* fe0 dvb-t, fe1 dvb-c */
+			fe0->dvb.frontend = dvb_attach(drxk_attach,
+				&terratec_drxk_config[1],
+				&i2c_bus->i2c_adap, &fe1->dvb.frontend);
+
+			if (fe0->dvb.frontend != NULL) {
+				if (!dvb_attach(mt2063_attach,
+						fe0->dvb.frontend,
+						&terratec_mt2063_config[1],
+						&i2c_bus2->i2c_adap))
+					goto frontend_deatch;
+			}
+
+			if (fe1->dvb.frontend != NULL) {
+				if (!dvb_attach(mt2063_attach,
+						fe1->dvb.frontend,
+						&terratec_mt2063_config[1],
+						&i2c_bus2->i2c_adap))
+					goto frontend_deatch;
+			}
+		}
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 519f40d..066f181 100644
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

