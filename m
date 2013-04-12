Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2131 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab3DLNag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 09:30:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [REVIEW PATCH] bttv: Add Adlink MPG24 entry to the bttv cardlist
Date: Fri, 12 Apr 2013 15:30:29 +0200
Cc: Volokh Konstantin <volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304121530.29714.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a proper card entry for this device, rather than abusing entries that are
not-quite-right.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/CARDLIST.bttv |    1 +
 drivers/media/pci/bt8xx/bttv-cards.c    |   22 +++++++++++++++++-----
 drivers/media/pci/bt8xx/bttv.h          |    1 +
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.bttv b/Documentation/video4linux/CARDLIST.bttv
index 581f666..407ab46 100644
--- a/Documentation/video4linux/CARDLIST.bttv
+++ b/Documentation/video4linux/CARDLIST.bttv
@@ -160,3 +160,4 @@
 159 -> ProVideo PV183                                      [1830:1540,1831:1540,1832:1540,1833:1540,1834:1540,1835:1540,1836:1540,1837:1540]
 160 -> Tongwei Video Technology TD-3116                    [f200:3116]
 161 -> Aposonic W-DVR                                      [0279:0228]
+162 -> Adlink MPG24
diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index b7dc921..8d327ff 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -2705,7 +2705,7 @@ struct tvcard bttv_tvcards[] = {
 		.has_radio      = 1,
 		.has_remote     = 1,
 	},
-		[BTTV_BOARD_VD012] = {
+	[BTTV_BOARD_VD012] = {
 		/* D.Heer@Phytec.de */
 		.name           = "PHYTEC VD-012 (bt878)",
 		.video_inputs   = 4,
@@ -2718,7 +2718,7 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_type     = TUNER_ABSENT,
 		.tuner_addr	= ADDR_UNSET,
 	},
-		[BTTV_BOARD_VD012_X1] = {
+	[BTTV_BOARD_VD012_X1] = {
 		/* D.Heer@Phytec.de */
 		.name           = "PHYTEC VD-012-X1 (bt878)",
 		.video_inputs   = 4,
@@ -2731,7 +2731,7 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_type     = TUNER_ABSENT,
 		.tuner_addr	= ADDR_UNSET,
 	},
-		[BTTV_BOARD_VD012_X2] = {
+	[BTTV_BOARD_VD012_X2] = {
 		/* D.Heer@Phytec.de */
 		.name           = "PHYTEC VD-012-X2 (bt878)",
 		.video_inputs   = 4,
@@ -2744,7 +2744,7 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_type     = TUNER_ABSENT,
 		.tuner_addr	= ADDR_UNSET,
 	},
-		[BTTV_BOARD_GEOVISION_GV800S] = {
+	[BTTV_BOARD_GEOVISION_GV800S] = {
 		/* Bruno Christo <bchristo@inf.ufsm.br>
 		 *
 		 * GeoVision GV-800(S) has 4 Conexant Fusion 878A:
@@ -2771,7 +2771,7 @@ struct tvcard bttv_tvcards[] = {
 		.no_tda7432	= 1,
 		.muxsel_hook    = gv800s_muxsel,
 	},
-		[BTTV_BOARD_GEOVISION_GV800S_SL] = {
+	[BTTV_BOARD_GEOVISION_GV800S_SL] = {
 		/* Bruno Christo <bchristo@inf.ufsm.br>
 		 *
 		 * GeoVision GV-800(S) has 4 Conexant Fusion 878A:
@@ -2808,6 +2808,7 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_type     = TUNER_ABSENT,
 		.tuner_addr	= ADDR_UNSET,
 	},
+	/* ---- card 0xa0---------------------------------- */
 	[BTTV_BOARD_TVT_TD3116] = {
 		.name           = "Tongwei Video Technology TD-3116",
 		.video_inputs   = 16,
@@ -2825,6 +2826,17 @@ struct tvcard bttv_tvcards[] = {
 		.muxsel         = MUXSEL(2, 3, 1, 0),
 		.tuner_type     = TUNER_ABSENT,
 	},
+	[BTTV_BOARD_ADLINK_MPG24] = {
+		/* Adlink MPG24 */
+		.name           = "Adlink MPG24",
+		.video_inputs   = 1,
+		/* .audio_inputs= 1, */
+		.svhs           = NO_SVHS,
+		.muxsel         = MUXSEL(2, 2, 2, 2),
+		.tuner_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.pll            = PLL_28,
+	},
 
 };
 
diff --git a/drivers/media/pci/bt8xx/bttv.h b/drivers/media/pci/bt8xx/bttv.h
index 6139ce2..f01c9d4 100644
--- a/drivers/media/pci/bt8xx/bttv.h
+++ b/drivers/media/pci/bt8xx/bttv.h
@@ -185,6 +185,7 @@
 #define BTTV_BOARD_PV183                   0x9f
 #define BTTV_BOARD_TVT_TD3116		   0xa0
 #define BTTV_BOARD_APOSONIC_WDVR           0xa1
+#define BTTV_BOARD_ADLINK_MPG24            0xa2
 
 /* more card-specific defines */
 #define PT2254_L_CHANNEL 0x10
-- 
1.7.10.4

