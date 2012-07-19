Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45590 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2GSNgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 09:36:49 -0400
Message-ID: <50080D61.5070606@bytesex.org>
Date: Thu, 19 Jul 2012 15:36:33 +0200
From: Gerd Hoffmann <kraxel@bytesex.org>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Tony Gentile <tony@squid-vision.com>
Subject: Fwd: bttv kernel patch
References: <5007E837.1000805@squid-vision.com>
In-Reply-To: <5007E837.1000805@squid-vision.com>
Content-Type: multipart/mixed;
 boundary="------------080004080607040604040106"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080004080607040604040106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



-------- Original Message --------
Subject: bttv kernel patch
Date: Thu, 19 Jul 2012 04:57:59 -0600
From: Tony Gentile <tony@squid-vision.com>
To: kraxel@bytesex.org

Hello Gerd,

Attached is a patch to add the Aposonic W-DVR card to the bttv driver.
This card is a basic 4 composite + 1 audio in. (I have no way to check
the audio on the card as that connector has been removed from my
board.)  This is my first submission.  I hope it is helpful.

Thank you for your time.

Sincerely,

Tony Gentile


--------------080004080607040604040106
Content-Type: text/x-patch;
 name="linux-3.4.5-Aposonic_W-DVR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linux-3.4.5-Aposonic_W-DVR.patch"

diff -uNr linux-3.4.5/Documentation/video4linux/CARDLIST.bttv linux-3.4.5-modded/Documentation/video4linux/CARDLIST.bttv
--- linux-3.4.5/Documentation/video4linux/CARDLIST.bttv	2012-07-16 12:20:09.000000000 -0600
+++ linux-3.4.5-modded/Documentation/video4linux/CARDLIST.bttv	2012-07-19 05:04:38.000000000 -0600
@@ -159,3 +159,4 @@
 158 -> Geovision GV-800(S) (slave)                         [800b:763d,800c:763d,800d:763d]
 159 -> ProVideo PV183                                      [1830:1540,1831:1540,1832:1540,1833:1540,1834:1540,1835:1540,1836:1540,1837:1540]
 160 -> Tongwei Video Technology TD-3116                    [f200:3116]
+161 -> Aposonic W-DVR                                      [0279:0228]
diff -uNr linux-3.4.5/drivers/media/video/bt8xx/bttv-cards.c linux-3.4.5-modded/drivers/media/video/bt8xx/bttv-cards.c
--- linux-3.4.5/drivers/media/video/bt8xx/bttv-cards.c	2012-07-16 12:20:09.000000000 -0600
+++ linux-3.4.5-modded/drivers/media/video/bt8xx/bttv-cards.c	2012-07-19 04:48:52.000000000 -0600
@@ -345,7 +345,7 @@
 	{ 0x15401836, BTTV_BOARD_PV183,         "Provideo PV183-7" },
 	{ 0x15401837, BTTV_BOARD_PV183,         "Provideo PV183-8" },
 	{ 0x3116f200, BTTV_BOARD_TVT_TD3116,	"Tongwei Video Technology TD-3116" },
-
+	{ 0x02280279, BTTV_BOARD_APOSONIC_WDVR, "Aposonic W-DVR" },
 	{ 0, -1, NULL }
 };
 
@@ -2893,6 +2893,14 @@
 		.pll		= PLL_28,
 		.tuner_type     = TUNER_ABSENT,
 	},
+	[BTTV_BOARD_APOSONIC_WDVR] = {
+		.name           = "Aposonic W-DVR",
+		.video_inputs   = 4,
+		.svhs           = NO_SVHS,
+		.muxsel         = MUXSEL(2, 3, 1, 0),
+		.tuner_type     = TUNER_ABSENT,
+	},
+
 };
 
 static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
diff -uNr linux-3.4.5/drivers/media/video/bt8xx/bttv.h linux-3.4.5-modded/drivers/media/video/bt8xx/bttv.h
--- linux-3.4.5/drivers/media/video/bt8xx/bttv.h	2012-07-16 12:20:09.000000000 -0600
+++ linux-3.4.5-modded/drivers/media/video/bt8xx/bttv.h	2012-07-19 04:48:52.000000000 -0600
@@ -184,7 +184,7 @@
 #define BTTV_BOARD_GEOVISION_GV800S_SL	   0x9e
 #define BTTV_BOARD_PV183                   0x9f
 #define BTTV_BOARD_TVT_TD3116		   0xa0
-
+#define BTTV_BOARD_APOSONIC_WDVR           0xa1
 
 /* more card-specific defines */
 #define PT2254_L_CHANNEL 0x10


--------------080004080607040604040106--
