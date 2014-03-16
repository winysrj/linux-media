Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63362 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaCPKdu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 06:33:50 -0400
Received: from minime.bse ([77.20.176.42]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MTSmp-1WX06U0Tvb-00SLbM for
 <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 11:33:49 +0100
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] bttv: Add support for PCI-8604PW
Date: Sun, 16 Mar 2014 11:33:48 +0100
Message-Id: <1394966028-1277-1-git-send-email-daniel-gl@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the PCI-8604PW card equipped with four 878A.
It is unknown who the manufacturer of this card is and no drivers were
available during development of the patch. According to images found
online, the card is originally sold with Linux DVR software.

A CPLD on the card prevents the 878A from requesting access to the
bus until an initialization sequence has been issued via GPIOs. The
implemented sequence uses the minimum number of GPIOs needed to
successfully unlock bus access. As there are many more GPIOs connected
to the CPLD, it is very likely that some of the others have an influence
on the bus arbitration scheduling. This should be investigated further
in case of performance issues.

The tested card contains an EEPROM on one of the 878A, but it is
completely empty (i.e. contains only 0xff), so it is not possible
to detect the card.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
Tested-by: Robert Longbottom <rongblor@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-cards.c | 102 +++++++++++++++++++++++++++++++++++
 drivers/media/pci/bt8xx/bttv.h       |   1 +
 2 files changed, 103 insertions(+)

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 6662b49..d9c3853 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -52,6 +52,7 @@ static void osprey_eeprom(struct bttv *btv, const u8 ee[256]);
 static void modtec_eeprom(struct bttv *btv);
 static void init_PXC200(struct bttv *btv);
 static void init_RTV24(struct bttv *btv);
+static void init_PCI8604PW(struct bttv *btv);
 
 static void rv605_muxsel(struct bttv *btv, unsigned int input);
 static void eagle_muxsel(struct bttv *btv, unsigned int input);
@@ -2856,6 +2857,22 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_addr	= ADDR_UNSET,
 	},
 
+	/* ---- card 0xa5---------------------------------- */
+	[BTTV_BOARD_PCI_8604PW] = {
+		/* PCI-8604PW with special unlock sequence */
+		.name           = "PCI-8604PW",
+		.video_inputs   = 2,
+		/* .audio_inputs= 0, */
+		.svhs           = NO_SVHS,
+		/* The second input is available on CN4, if populated.
+		 * The other 5x2 header (CN2?) connects to the same inputs
+		 * as the on-board BNCs */
+		.muxsel         = MUXSEL(2, 3),
+		.tuner_type     = TUNER_ABSENT,
+		.no_msp34xx	= 1,
+		.no_tda7432	= 1,
+		.pll            = PLL_35,
+	},
 };
 
 static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
@@ -3290,6 +3307,9 @@ void bttv_init_card1(struct bttv *btv)
 	case BTTV_BOARD_ADLINK_RTV24:
 		init_RTV24( btv );
 		break;
+	case BTTV_BOARD_PCI_8604PW:
+		init_PCI8604PW(btv);
+		break;
 
 	}
 	if (!bttv_tvcards[btv->c.type].has_dvb)
@@ -4170,6 +4190,88 @@ init_RTV24 (struct bttv *btv)
 
 
 /* ----------------------------------------------------------------------- */
+/*
+ *  The PCI-8604PW contains a CPLD, probably an ispMACH 4A, that filters
+ *  the PCI REQ signals comming from the four BT878 chips. After power
+ *  up, the CPLD does not forward requests to the bus, which prevents
+ *  the BT878 from fetching RISC instructions from memory. While the
+ *  CPLD is connected to most of the GPIOs of PCI device 0xD, only
+ *  five appear to play a role in unlocking the REQ signal. The following
+ *  sequence has been determined by trial and error without access to the
+ *  original driver.
+ *
+ *  Eight GPIOs of device 0xC are provided on connector CN4 (4 in, 4 out).
+ *  Devices 0xE and 0xF do not appear to have anything connected to their
+ *  GPIOs.
+ *
+ *  The correct GPIO_OUT_EN value might have some more bits set. It should
+ *  be possible to derive it from a boundary scan of the CPLD. Its JTAG
+ *  pins are routed to test points.
+ *
+ */
+/* ----------------------------------------------------------------------- */
+static void
+init_PCI8604PW(struct bttv *btv)
+{
+	int state;
+
+	if ((PCI_SLOT(btv->c.pci->devfn) & ~3) != 0xC) {
+		pr_warn("This is not a PCI-8604PW\n");
+		return;
+	}
+
+	if (PCI_SLOT(btv->c.pci->devfn) != 0xD)
+		return;
+
+	btwrite(0x080002, BT848_GPIO_OUT_EN);
+
+	state = (btread(BT848_GPIO_DATA) >> 21) & 7;
+
+	for (;;) {
+		switch (state) {
+		case 1:
+		case 5:
+		case 6:
+		case 4:
+			pr_debug("PCI-8604PW in state %i, toggling pin\n",
+				 state);
+			btwrite(0x080000, BT848_GPIO_DATA);
+			msleep(1);
+			btwrite(0x000000, BT848_GPIO_DATA);
+			msleep(1);
+			break;
+		case 7:
+			pr_info("PCI-8604PW unlocked\n");
+			return;
+		case 0: /* FIXME */
+			pr_err("PCI-8604PW locked until reset\n");
+			return;
+		default:
+			pr_err("PCI-8604PW in unknown state %i\n", state);
+			return;
+		}
+
+		state = (state << 4) | ((btread(BT848_GPIO_DATA) >> 21) & 7);
+
+		switch (state) {
+		case 0x15:
+		case 0x56:
+		case 0x64:
+		case 0x47:
+/*		case 0x70: */
+			break;
+		default:
+			pr_err("PCI-8604PW invalid transition %i -> %i\n",
+			       state >> 4, state & 7);
+			return;
+		}
+		state &= 7;
+	}
+}
+
+
+
+/* ----------------------------------------------------------------------- */
 /* Miro Pro radio stuff -- the tea5757 is connected to some GPIO ports     */
 /*
  * Copyright (c) 1999 Csaba Halasz <qgehali@uni-miskolc.hu>
diff --git a/drivers/media/pci/bt8xx/bttv.h b/drivers/media/pci/bt8xx/bttv.h
index df578ef..c0a4c93 100644
--- a/drivers/media/pci/bt8xx/bttv.h
+++ b/drivers/media/pci/bt8xx/bttv.h
@@ -188,6 +188,7 @@
 #define BTTV_BOARD_ADLINK_MPG24            0xa2
 #define BTTV_BOARD_BT848_CAP_14            0xa3
 #define BTTV_BOARD_CYBERVISION_CV06        0xa4
+#define BTTV_BOARD_PCI_8604PW              0xa5
 
 /* more card-specific defines */
 #define PT2254_L_CHANNEL 0x10
-- 
1.8.3.4

