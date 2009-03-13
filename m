Return-path: <linux-media-owner@vger.kernel.org>
Received: from 203-109-246-148.static.bliink.ihug.co.nz ([203.109.246.148]:20581
	"EHLO mail.reveal.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756140AbZCMArD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 20:47:03 -0400
Date: Fri, 13 Mar 2009 13:43:34 +1300
From: Alan McIvor <alan.mcivor@reveal.co.nz>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add support for ProVideo PV-183 to bttv (take 2 - changed
 spaces to tabs)
Message-Id: <20090313134334.d4b9c198.alan.mcivor@reveal.co.nz>
In-Reply-To: <Pine.LNX.4.58.0903121711370.28292@shell2.speakeasy.net>
References: <20090313114649.e774c9be.alan.mcivor@reveal.co.nz>
	<Pine.LNX.4.58.0903121711370.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for ProVideo PV-183 to bttv

From: Alan McIvor <alan.mcivor@reveal.co.nz>

This patch adds support for the ProVideo PV-183 card to the bttv
device driver. The PV-183 is a PCI card with 8 BT878 devices plus a Hint
Corp HiNT HB4 PCI-PCI Bridge. Each BT878 has two composite input channels
available. There are no tuners on this card.

This patch was generated against the V4L-DVB mercurial tree as of 12
March 2009.

Priority: normal

Signed-off-by: Alan McIvor <alan.mcivor@reveal.co.nz>

--- linux/drivers/media/video/bt8xx/bttv.h.orig	2009-03-13 10:12:09.000000000 +1300
+++ linux/drivers/media/video/bt8xx/bttv.h	2009-03-13 10:18:46.000000000 +1300
@@ -184,6 +184,7 @@
 #define BTTV_BOARD_IVCE8784		   0x9c
 #define BTTV_BOARD_GEOVISION_GV800S	   0x9d
 #define BTTV_BOARD_GEOVISION_GV800S_SL	   0x9e
+#define BTTV_BOARD_PV183                   0x9f
 
 
 /* more card-specific defines */
--- linux/drivers/media/video/bt8xx/bttv-cards.c.orig	2009-03-13 10:12:19.000000000 +1300
+++ linux/drivers/media/video/bt8xx/bttv-cards.c	2009-03-13 13:19:50.000000000 +1300
@@ -321,6 +321,16 @@ static struct CARD {
 	{ 0x763d800b, BTTV_BOARD_GEOVISION_GV800S_SL,	"GeoVision GV-800(S) (slave)" },
 	{ 0x763d800c, BTTV_BOARD_GEOVISION_GV800S_SL,	"GeoVision GV-800(S) (slave)" },
 	{ 0x763d800d, BTTV_BOARD_GEOVISION_GV800S_SL,	"GeoVision GV-800(S) (slave)" },
+
+	{ 0x15401830, BTTV_BOARD_PV183,         "Provideo PV183-1" },
+	{ 0x15401831, BTTV_BOARD_PV183,         "Provideo PV183-2" },
+	{ 0x15401832, BTTV_BOARD_PV183,         "Provideo PV183-3" },
+	{ 0x15401833, BTTV_BOARD_PV183,         "Provideo PV183-4" },
+	{ 0x15401834, BTTV_BOARD_PV183,         "Provideo PV183-5" },
+	{ 0x15401835, BTTV_BOARD_PV183,         "Provideo PV183-6" },
+	{ 0x15401836, BTTV_BOARD_PV183,         "Provideo PV183-7" },
+	{ 0x15401837, BTTV_BOARD_PV183,         "Provideo PV183-8" },
+
 	{ 0, -1, NULL }
 };
 
@@ -2910,6 +2920,20 @@ struct tvcard bttv_tvcards[] = {
 		.no_tda9875	= 1,
 		.muxsel_hook    = gv800s_muxsel,
 	},
+	[BTTV_BOARD_PV183] = {
+		.name           = "ProVideo PV183", /* 0x9f */
+		.video_inputs   = 2,
+		/* .audio_inputs= 0, */
+		.svhs           = NO_SVHS,
+		.gpiomask       = 0,
+		.muxsel         = MUXSEL(2, 3),
+		.gpiomux        = { 0 },
+		.needs_tvaudio  = 0,
+		.no_msp34xx     = 1,
+		.pll            = PLL_28,
+		.tuner_type     = TUNER_ABSENT,
+		.tuner_addr	= ADDR_UNSET,
+	},
 };
 
 static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
--- linux/Documentation/video4linux/CARDLIST.bttv.orig	2009-03-13 13:39:03.000000000 +1300
+++ linux/Documentation/video4linux/CARDLIST.bttv	2009-03-13 13:28:03.000000000 +1300
@@ -157,3 +157,4 @@
 156 -> IVCE-8784                                           [0000:f050,0001:f050,0002:f050,0003:f050]
 157 -> Geovision GV-800(S) (master)                        [800a:763d]
 158 -> Geovision GV-800(S) (slave)                         [800b:763d,800c:763d,800d:763d]
+159 -> ProVideo PV183                                      [1830:1540,1831:1540,1832:1540,1833:1540,1834:1540,1835:1540,1836:1540,1837:1540]

