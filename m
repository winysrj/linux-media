Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:33016 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab0A3Pul (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 10:50:41 -0500
Received: from [192.168.1.2] (02-147.155.popsite.net [66.217.132.147])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id o0UFodkB028890
	for <linux-media@vger.kernel.org>; Sat, 30 Jan 2010 10:50:39 -0500 (EST)
Subject: [PATCH 2/2] cx18: Add a component video input to the PVR2100 and
 DVR3200H card entries
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 30 Jan 2010 10:50:23 -0500
Message-Id: <1264866623.4748.49.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx18: Add a component video input to the PVR2100 and DVR3200H card entries

From: Andy Walls <awalls@radix.net>

This is a guess at the proper configuration for component video on the Leadtek
PVR2100 and DVR3100 H.

Priority: normal

Signed-off-by: Andy Walls <awalls@radix.net>

diff -r 9d3394f49a90 -r 477109669a0c linux/drivers/media/video/cx18/cx18-cards.c
--- a/linux/drivers/media/video/cx18/cx18-cards.c	Fri Jan 08 23:01:47 2010 -0500
+++ b/linux/drivers/media/video/cx18/cx18-cards.c	Fri Jan 08 23:09:45 2010 -0500
@@ -381,6 +381,7 @@
 		{ CX18_CARD_INPUT_SVIDEO1,    1,
 			CX18_AV_SVIDEO_LUMA3 | CX18_AV_SVIDEO_CHROMA4 },
 		{ CX18_CARD_INPUT_COMPOSITE1, 1, CX18_AV_COMPOSITE7 },
+		{ CX18_CARD_INPUT_COMPONENT1, 1, CX18_AV_COMPONENT1 },
 	},
 	.audio_inputs = {
 		{ CX18_CARD_INPUT_AUD_TUNER, CX18_AV_AUDIO5, 	    0 },
@@ -433,6 +434,7 @@
 		{ CX18_CARD_INPUT_SVIDEO1,    1,
 			CX18_AV_SVIDEO_LUMA3 | CX18_AV_SVIDEO_CHROMA4 },
 		{ CX18_CARD_INPUT_COMPOSITE1, 1, CX18_AV_COMPOSITE7 },
+		{ CX18_CARD_INPUT_COMPONENT1, 1, CX18_AV_COMPONENT1 },
 	},
 	.audio_inputs = {
 		{ CX18_CARD_INPUT_AUD_TUNER, CX18_AV_AUDIO5, 	    0 },


