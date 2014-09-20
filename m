Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2294 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaITMmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 14/16] cx88: consistently use UNSET for absent tuner
Date: Sat, 20 Sep 2014 14:41:49 +0200
Message-Id: <1411216911-7950-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't mix UNSET and TUNER_ABSENT: you have to pick one or the other. For
this driver selecting UNSET to represent an absent tuner resulting in
the fewest changes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-cards.c | 66 ++++++++++++++++++-------------------
 drivers/media/pci/cx88/cx88-video.c |  2 +-
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index eb72185..6bace43 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -347,7 +347,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_IODATA_GVVCP3PCI] = {
 		.name		= "IODATA GV-VCP3/PCI",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -436,7 +436,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_KWORLD_DVB_T] = {
 		.name           = "KWorld/VStream XPert DVB-T",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -455,7 +455,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_DVICO_FUSIONHDTV_DVB_T1] = {
 		.name           = "DViCO FusionHDTV DVB-T1",
-		.tuner_type     = TUNER_ABSENT, /* No analog tuner */
+		.tuner_type     = UNSET, /* No analog tuner */
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -542,7 +542,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_HAUPPAUGE_DVB_T1] = {
 		.name           = "Hauppauge Nova-T DVB-T",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -554,7 +554,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_CONEXANT_DVB_T1] = {
 		.name           = "Conexant DVB-T reference design",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -579,7 +579,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PLUS] = {
 		.name           = "DViCO FusionHDTV DVB-T Plus",
-		.tuner_type     = TUNER_ABSENT, /* No analog tuner */
+		.tuner_type     = UNSET, /* No analog tuner */
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -596,7 +596,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_DNTV_LIVE_DVB_T] = {
 		.name		= "digitalnow DNTV Live! DVB-T",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -787,7 +787,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_ADSTECH_DVB_T_PCI] = {
 		.name           = "ADS Tech Instant TV DVB-T PCI",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -806,7 +806,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1] = {
 		.name           = "TerraTec Cinergy 1400 DVB-T",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.input          = {{
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
@@ -924,7 +924,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_WINFAST_DTV1000] = {
 		.name           = "WinFast DTV1000-T",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -972,7 +972,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1] = {
 		.name		= "Hauppauge Nova-S-Plus DVB-S",
-		.tuner_type	= TUNER_ABSENT,
+		.tuner_type	= UNSET,
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -998,7 +998,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_HAUPPAUGE_NOVASE2_S1] = {
 		.name		= "Hauppauge Nova-SE2 DVB-S",
-		.tuner_type	= TUNER_ABSENT,
+		.tuner_type	= UNSET,
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -1010,7 +1010,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_KWORLD_DVBS_100] = {
 		.name		= "KWorld DVB-S 100",
-		.tuner_type	= TUNER_ABSENT,
+		.tuner_type	= UNSET,
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -1102,7 +1102,7 @@ static const struct cx88_board cx88_boards[] = {
 		/* DTT 7579 Conexant CX22702-19 Conexant CX2388x  */
 		/* Manenti Marco <marco_manenti@colman.it> */
 		.name           = "KWorld/VStream XPert DVB-T with cx22702",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -1121,7 +1121,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL] = {
 		.name           = "DViCO FusionHDTV DVB-T Dual Digital",
-		.tuner_type     = TUNER_ABSENT, /* No analog tuner */
+		.tuner_type     = UNSET, /* No analog tuner */
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -1356,7 +1356,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_GENIATECH_DVBS] = {
 		.name          = "Geniatech DVB-S",
-		.tuner_type    = TUNER_ABSENT,
+		.tuner_type    = UNSET,
 		.radio_type    = UNSET,
 		.tuner_addr    = ADDR_UNSET,
 		.radio_addr    = ADDR_UNSET,
@@ -1494,7 +1494,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_SAMSUNG_SMT_7020] = {
 		.name		= "Samsung SMT 7020 DVB-S",
-		.tuner_type	= TUNER_ABSENT,
+		.tuner_type	= UNSET,
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -1506,7 +1506,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_ADSTECH_PTV_390] = {
 		.name           = "ADS Tech Instant Video PCI",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -1553,7 +1553,7 @@ static const struct cx88_board cx88_boards[] = {
 	[CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO] = {
 		.name           = "DViCO FusionHDTV 5 PCI nano",
 		/* xc3008 tuner, digital only for now */
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
@@ -2069,7 +2069,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_TBS_8920] = {
 		.name           = "TBS 8920 DVB-S/S2",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -2304,7 +2304,7 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_TWINHAN_VP1027_DVBS] = {
 		.name		= "Twinhan VP-1027 DVB-S",
-		.tuner_type     = TUNER_ABSENT,
+		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -2921,33 +2921,33 @@ static const struct {
 	int  fm;
 	const char *name;
 } gdi_tuner[] = {
-	[ 0x01 ] = { .id   = TUNER_ABSENT,
+	[ 0x01 ] = { .id   = UNSET,
 		     .name = "NTSC_M" },
-	[ 0x02 ] = { .id   = TUNER_ABSENT,
+	[ 0x02 ] = { .id   = UNSET,
 		     .name = "PAL_B" },
-	[ 0x03 ] = { .id   = TUNER_ABSENT,
+	[ 0x03 ] = { .id   = UNSET,
 		     .name = "PAL_I" },
-	[ 0x04 ] = { .id   = TUNER_ABSENT,
+	[ 0x04 ] = { .id   = UNSET,
 		     .name = "PAL_D" },
-	[ 0x05 ] = { .id   = TUNER_ABSENT,
+	[ 0x05 ] = { .id   = UNSET,
 		     .name = "SECAM" },
 
-	[ 0x10 ] = { .id   = TUNER_ABSENT,
+	[ 0x10 ] = { .id   = UNSET,
 		     .fm   = 1,
 		     .name = "TEMIC_4049" },
 	[ 0x11 ] = { .id   = TUNER_TEMIC_4136FY5,
 		     .name = "TEMIC_4136" },
-	[ 0x12 ] = { .id   = TUNER_ABSENT,
+	[ 0x12 ] = { .id   = UNSET,
 		     .name = "TEMIC_4146" },
 
 	[ 0x20 ] = { .id   = TUNER_PHILIPS_FQ1216ME,
 		     .fm   = 1,
 		     .name = "PHILIPS_FQ1216_MK3" },
-	[ 0x21 ] = { .id   = TUNER_ABSENT, .fm = 1,
+	[ 0x21 ] = { .id   = UNSET, .fm = 1,
 		     .name = "PHILIPS_FQ1236_MK3" },
-	[ 0x22 ] = { .id   = TUNER_ABSENT,
+	[ 0x22 ] = { .id   = UNSET,
 		     .name = "PHILIPS_FI1236_MK3" },
-	[ 0x23 ] = { .id   = TUNER_ABSENT,
+	[ 0x23 ] = { .id   = UNSET,
 		     .name = "PHILIPS_FI1216_MK3" },
 };
 
@@ -3564,7 +3564,7 @@ static void cx88_card_setup(struct cx88_core *core)
 		mode_mask &= ~T_RADIO;
 	}
 
-	if (core->board.tuner_type != TUNER_ABSENT) {
+	if (core->board.tuner_type != UNSET) {
 		tun_setup.mode_mask      = mode_mask;
 		tun_setup.type           = core->board.tuner_type;
 		tun_setup.addr           = core->board.tuner_addr;
@@ -3777,7 +3777,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	cx88_i2c_init(core, pci);
 
 	/* load tuner module, if needed */
-	if (TUNER_ABSENT != core->board.tuner_type) {
+	if (UNSET != core->board.tuner_type) {
 		/* Ignore 0x6b and 0x6f on cx88 boards.
 		 * FusionHDTV5 RT Gold has an ir receiver at 0x6b
 		 * and an RTC at 0x6f which can get corrupted if probed. */
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 64d6a72..d8a86cd 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1532,7 +1532,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	}
 
 	/* start tvaudio thread */
-	if (core->board.tuner_type != TUNER_ABSENT) {
+	if (core->board.tuner_type != UNSET) {
 		core->kthread = kthread_run(cx88_audio_thread, core, "cx88 tvaudio");
 		if (IS_ERR(core->kthread)) {
 			err = PTR_ERR(core->kthread);
-- 
2.1.0

