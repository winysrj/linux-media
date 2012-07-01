Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51555 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2GAUP6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2012 16:15:58 -0400
Received: by mail-qa0-f53.google.com with SMTP id s11so1561997qaa.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jul 2012 13:15:58 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 5/6] cx23885: make analog support work for HVR_1250 (cx23885 variant)
Date: Sun,  1 Jul 2012 16:15:13 -0400
Message-Id: <1341173714-23627-6-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
References: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The analog support in the cx23885 driver was completely broken for the
HVR-1250.  Add the necessary code.

Note that this only implements analog for the composite and s-video inputs.
The tuner input continues to be non-functional due to a lack of analog support
in the mt2131 driver.

Validated with the following boards:

HVR-1250 (0070:7911)

Thanks to Steven Toth and Hauppauge for	loaning	me various boards to
regression test	with.

Thanks-to: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Devin Heitmueler <dheitmueller@kernellabs.com>
---
 drivers/media/video/cx23885/cx23885-cards.c |   31 ++++++++++++++++++++-------
 drivers/media/video/cx23885/cx23885-video.c |    1 +
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 19b5499..1af9108 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -127,22 +127,37 @@ struct cx23885_board cx23885_boards[] = {
 	},
 	[CX23885_BOARD_HAUPPAUGE_HVR1250] = {
 		.name		= "Hauppauge WinTV-HVR1250",
+		.porta		= CX23885_ANALOG_VIDEO,
 		.portc		= CX23885_MPEG_DVB,
+#ifdef MT2131_NO_ANALOG_SUPPORT_YET
+		.tuner_type	= TUNER_PHILIPS_TDA8290,
+		.tuner_addr	= 0x42, /* 0x84 >> 1 */
+		.tuner_bus	= 1,
+#endif
+		.force_bff	= 1,
 		.input          = {{
+#ifdef MT2131_NO_ANALOG_SUPPORT_YET
 			.type   = CX23885_VMUX_TELEVISION,
-			.vmux   = 0,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN5_CH2 |
+					CX25840_VIN2_CH1,
+			.amux   = CX25840_AUDIO8,
 			.gpio0  = 0xff00,
 		}, {
-			.type   = CX23885_VMUX_DEBUG,
-			.vmux   = 0,
-			.gpio0  = 0xff01,
-		}, {
+#endif
 			.type   = CX23885_VMUX_COMPOSITE1,
-			.vmux   = 1,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN4_CH2 |
+					CX25840_VIN6_CH1,
+			.amux   = CX25840_AUDIO7,
 			.gpio0  = 0xff02,
 		}, {
 			.type   = CX23885_VMUX_SVIDEO,
-			.vmux   = 2,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN4_CH2 |
+					CX25840_VIN8_CH1 |
+					CX25840_SVIDEO_ON,
+			.amux   = CX25840_AUDIO7,
 			.gpio0  = 0xff02,
 		} },
 	},
@@ -1517,10 +1532,10 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	 */
 	switch (dev->board) {
 	case CX23885_BOARD_TEVII_S470:
-	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/* Currently only enabled for the integrated IR controller */
 		if (!enable_885_ir)
 			break;
+	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index c654bdc..4d05689 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -505,6 +505,7 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
 
 	if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1800) ||
 		(dev->board == CX23885_BOARD_MPX885) ||
+		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1250) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850)) {
 		/* Configure audio routing */
 		v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
-- 
1.7.1

