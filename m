Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52300 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2EKPpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 11:45:32 -0400
Received: by bkcji2 with SMTP id ji2so2357178bkc.19
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 08:45:30 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] cx23885: TeVii s471 card support
Date: Fri, 11 May 2012 18:45:42 +0300
Message-ID: <7076158.oZb9Cn2ZhT@useri>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart5415348.2nEYmCqYpm"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart5415348.2nEYmCqYpm
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

The card is similar to TeVii s470, but has different LNB power control.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
--nextPart5415348.2nEYmCqYpm
Content-Disposition: inline; filename="s471.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="s471.patch"

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 6769fc4..668a1ef 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -935,7 +935,10 @@ static int ds3000_set_frontend(struct dvb_frontend *fe)
 			ds3000_writereg(state,
 				ds3000_dvbs2_init_tab[i],
 				ds3000_dvbs2_init_tab[i + 1]);
-		ds3000_writereg(state, 0xfe, 0x98);
+		if (c->symbol_rate >= 30000000)
+			ds3000_writereg(state, 0xfe, 0x54);
+		else
+			ds3000_writereg(state, 0xfe, 0x98);
 		break;
 	default:
 		return 1;
diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 19b5499..13739e0 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -497,6 +497,10 @@ struct cx23885_board cx23885_boards[] = {
 		.name		= "TerraTec Cinergy T PCIe Dual",
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
+	},
+	[CX23885_BOARD_TEVII_S471] = {
+		.name		= "TeVii S471",
+		.portb		= CX23885_MPEG_DVB,
 	}
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
@@ -705,6 +709,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x153b,
 		.subdevice = 0x117e,
 		.card      = CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL,
+	}, {
+		.subvendor = 0xd471,
+		.subdevice = 0x9022,
+		.card      = CX23885_BOARD_TEVII_S471,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1460,6 +1468,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
 	case CX23885_BOARD_TEVII_S470:
+	case CX23885_BOARD_TEVII_S471:
 	case CX23885_BOARD_DVBWORLD_2005:
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 6ad2270..697728f 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1046,6 +1046,13 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	if (cx23885_boards[dev->board].ci_type > 0)
 		cx_clear(RDR_RDRCTL1, 1 << 8);
 
+	switch (dev->board) {
+	case CX23885_BOARD_TEVII_S470:
+	case CX23885_BOARD_TEVII_S471:
+		cx_clear(RDR_RDRCTL1, 1 << 8);
+		break;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 54a2781..67140be 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -1185,6 +1185,13 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		}
 		break;
+	case CX23885_BOARD_TEVII_S471:
+		i2c_bus = &dev->i2c_bus[1];
+
+		fe0->dvb.frontend = dvb_attach(ds3000_attach,
+					&tevii_ds3000_config,
+					&i2c_bus->i2c_adap);
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index f020f05..d884784 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -89,6 +89,7 @@
 #define CX23885_BOARD_MPX885                   32
 #define CX23885_BOARD_MYGICA_X8507             33
 #define CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL 34
+#define CX23885_BOARD_TEVII_S471               35
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
--nextPart5415348.2nEYmCqYpm--

