Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:47627 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab3DNQjm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 12:39:42 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] bttv: Add noname Bt848 capture card with 14MHz xtal
Date: Sun, 14 Apr 2013 18:39:09 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201304141839.10168.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for noname Bt848 capture-only card (3x composite, 1x S-VHS)
with 14MHz crystal: 
http://www.rainbow-software.org/images/hardware/bt848_.jpg

14MHz PLL was not supported by bttv driver until now.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index b7dc921..8bcf638 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -131,7 +131,7 @@ MODULE_PARM_DESC(vsfx,"set VSFX pci config bit "
 		 "[yet another chipset flaw workaround]");
 MODULE_PARM_DESC(latency,"pci latency timer");
 MODULE_PARM_DESC(card,"specify TV/grabber card model, see CARDLIST file for a list");
-MODULE_PARM_DESC(pll,"specify installed crystal (0=none, 28=28 MHz, 35=35 MHz)");
+MODULE_PARM_DESC(pll,"specify installed crystal (0=none, 28=28 MHz, 35=35 MHz, 14=14 MHz)");
 MODULE_PARM_DESC(tuner,"specify installed tuner type");
 MODULE_PARM_DESC(autoload, "obsolete option, please do not use anymore");
 MODULE_PARM_DESC(audiodev, "specify audio device:\n"
@@ -2825,6 +2825,14 @@ struct tvcard bttv_tvcards[] = {
 		.muxsel         = MUXSEL(2, 3, 1, 0),
 		.tuner_type     = TUNER_ABSENT,
 	},
+	[BTTV_BOARD_BT848_CAP_14] = {
+		.name		= "Bt848 Capture 14MHz",
+		.video_inputs	= 4,
+		.svhs		= 2,
+		.muxsel		= MUXSEL(2, 3, 1, 0),
+		.pll		= PLL_14,
+		.tuner_type	= TUNER_ABSENT,
+	},
 
 };
 
@@ -3390,6 +3398,10 @@ void bttv_init_card2(struct bttv *btv)
 			btv->pll.pll_ifreq=35468950;
 			btv->pll.pll_crystal=BT848_IFORM_XT1;
 		}
+		if (PLL_14 == bttv_tvcards[btv->c.type].pll) {
+			btv->pll.pll_ifreq=14318181;
+			btv->pll.pll_crystal=BT848_IFORM_XT0;
+		}
 		/* insmod options can override */
 		switch (pll[btv->c.nr]) {
 		case 0: /* none */
@@ -3409,6 +3421,12 @@ void bttv_init_card2(struct bttv *btv)
 			btv->pll.pll_ofreq   = 0;
 			btv->pll.pll_crystal = BT848_IFORM_XT1;
 			break;
+		case 3: /* 14 MHz */
+		case 14:
+			btv->pll.pll_ifreq   = 14318181;
+			btv->pll.pll_ofreq   = 0;
+			btv->pll.pll_crystal = BT848_IFORM_XT0;
+			break;
 		}
 	}
 	btv->pll.pll_current = -1;
diff --git a/drivers/media/pci/bt8xx/bttv.h b/drivers/media/pci/bt8xx/bttv.h
index 6139ce2..2d4b466 100644
--- a/drivers/media/pci/bt8xx/bttv.h
+++ b/drivers/media/pci/bt8xx/bttv.h
@@ -185,6 +185,7 @@
 #define BTTV_BOARD_PV183                   0x9f
 #define BTTV_BOARD_TVT_TD3116		   0xa0
 #define BTTV_BOARD_APOSONIC_WDVR           0xa1
+#define BTTV_BOARD_BT848_CAP_14            0xa2
 
 /* more card-specific defines */
 #define PT2254_L_CHANNEL 0x10
@@ -232,6 +233,7 @@ struct tvcard {
 #define PLL_NONE 0
 #define PLL_28   1
 #define PLL_35   2
+#define PLL_14   3
 
 	/* i2c audio flags */
 	unsigned int no_msp34xx:1;


-- 
Ondrej Zary
