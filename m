Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway09.websitewelcome.com ([67.18.21.24]:56382 "HELO
	gateway09.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753707Ab1JYXEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 19:04:33 -0400
Date: Tue, 25 Oct 2011 15:54:55 -0700 (PDT)
From: sensoray-dev <linux-dev@sensoray.com>
Subject: [PATCH][media] bttv: adding Sensoray 611 board to driver.
To: linux-media@vger.kernel.org, mchehab@infradead.org
Message-ID: <tkrat.9d996cc744b77c09@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit affebd4db94b459f676a14d9bb696c3c2b73643d
Author: Dean Anderson <linux-dev@sensoray.com>
Date:   Tue Oct 25 15:43:55 2011 -0700

[media] bttv: adding Sensoray 611 board to bttv driver

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

diff --git a/Documentation/video4linux/CARDLIST.bttv b/Documentation/video4linux/CARDLIST.bttv
index 4739d56..8948da4 100644
--- a/Documentation/video4linux/CARDLIST.bttv
+++ b/Documentation/video4linux/CARDLIST.bttv
@@ -71,7 +71,7 @@
  70 -> Prolink Pixelview PV-BT878P+ (Rev.4C,8E)
  71 -> Lifeview FlyVideo 98EZ (capture only) LR51          [1851:1851]
  72 -> Prolink Pixelview PV-BT878P+9B (PlayTV Pro rev.9B FM+NICAM) [1554:4011]
- 73 -> Sensoray 311                                        [6000:0311]
+ 73 -> Sensoray 311/611                                    [6000:0311,6000:0611]
  74 -> RemoteVision MX (RV605)
  75 -> Powercolor MTV878/ MTV878R/ MTV878F
  76 -> Canopus WinDVR PCI (COMPAQ Presario 3524JP, 5112JP) [0e11:0079]
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 5939021..076b7f2 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -284,7 +284,8 @@ static struct CARD {
 	{ 0x10b42636, BTTV_BOARD_HAUPPAUGE878,  "STB ???" },
 	{ 0x217d6606, BTTV_BOARD_WINFAST2000,   "Leadtek WinFast TV 2000" },
 	{ 0xfff6f6ff, BTTV_BOARD_WINFAST2000,   "Leadtek WinFast TV 2000" },
-	{ 0x03116000, BTTV_BOARD_SENSORAY311,   "Sensoray 311" },
+	{ 0x03116000, BTTV_BOARD_SENSORAY311_611, "Sensoray 311" },
+	{ 0x06116000, BTTV_BOARD_SENSORAY311_611, "Sensoray 611" },
 	{ 0x00790e11, BTTV_BOARD_WINDVR,        "Canopus WinDVR PCI" },
 	{ 0xa0fca1a0, BTTV_BOARD_ZOLTRIX,       "Face to Face Tvmax" },
 	{ 0x82b2aa6a, BTTV_BOARD_SIMUS_GVC1100, "SIMUS GVC1100" },
@@ -1526,10 +1527,10 @@ struct tvcard bttv_tvcards[] = {
 			GPIO20,22,23: R30,R29,R28
 		*/
 	},
-	[BTTV_BOARD_SENSORAY311] = {
+	[BTTV_BOARD_SENSORAY311_611] = {
 		/* Clay Kunz <ckunz@mail.arc.nasa.gov> */
-		/* you must jumper JP5 for the card to work */
-		.name           = "Sensoray 311",
+		/* you must jumper JP5 for the 311 card (PC/104+) to work */
+		.name           = "Sensoray 311/611",
 		.video_inputs   = 5,
 		/* .audio_inputs= 0, */
 		.svhs           = 4,
diff --git a/drivers/media/video/bt8xx/bttv.h b/drivers/media/video/bt8xx/bttv.h
index c633359..4db8b7d 100644
--- a/drivers/media/video/bt8xx/bttv.h
+++ b/drivers/media/video/bt8xx/bttv.h
@@ -96,7 +96,7 @@
 #define BTTV_BOARD_PV_BT878P_PLUS          0x46
 #define BTTV_BOARD_FLYVIDEO98EZ            0x47
 #define BTTV_BOARD_PV_BT878P_9B            0x48
-#define BTTV_BOARD_SENSORAY311             0x49
+#define BTTV_BOARD_SENSORAY311_611         0x49
 #define BTTV_BOARD_RV605                   0x4a
 #define BTTV_BOARD_POWERCLR_MTV878         0x4b
 #define BTTV_BOARD_WINDVR                  0x4c

