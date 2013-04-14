Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:54794 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab3DNV0s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 17:26:48 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] bttv: Add CyberVision CV06
Cc: linux-media@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Sun, 14 Apr 2013 23:26:21 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304142326.22042.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CyberVision CV06 4-camera card (from CyberVision SV card kit):
http://www.cybervision.com.tw/products-swcard_kits-sv.html
    
There are some interesting things on the card but they're not supported:
4 LEDs, a connector with 4 IN and 4 OUT pins, RESET IN and RESET OUT
connectors, a relay and CyberVision CV8088-SV16 chip

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 8bcf638..7bce09f 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -2833,6 +2833,16 @@ struct tvcard bttv_tvcards[] = {
 		.pll		= PLL_14,
 		.tuner_type	= TUNER_ABSENT,
 	},
+	[BTTV_BOARD_CYBERVISION_CV06] = {
+		.name		= "CyberVision CV06 (SV)",
+		.video_inputs	= 4,
+		/* .audio_inputs= 0, */
+		.svhs		= NO_SVHS,
+		.muxsel		= MUXSEL(2, 3, 1, 0),
+		.pll		= PLL_28,
+		.tuner_type	= TUNER_ABSENT,
+		.tuner_addr	= ADDR_UNSET,
+	},
 
 };
 
diff --git a/drivers/media/pci/bt8xx/bttv.h b/drivers/media/pci/bt8xx/bttv.h
index 2d4b466..bd35114 100644
--- a/drivers/media/pci/bt8xx/bttv.h
+++ b/drivers/media/pci/bt8xx/bttv.h
@@ -186,6 +186,7 @@
 #define BTTV_BOARD_TVT_TD3116		   0xa0
 #define BTTV_BOARD_APOSONIC_WDVR           0xa1
 #define BTTV_BOARD_BT848_14                0xa2
+#define BTTV_BOARD_CYBERVISION_CV06        0xa3
 
 /* more card-specific defines */
 #define PT2254_L_CHANNEL 0x10


-- 
Ondrej Zary
