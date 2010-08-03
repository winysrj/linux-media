Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail179.messagelabs.com ([85.158.139.35]:22003 "HELO
	mail179.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754710Ab0HCITB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 04:19:01 -0400
From: mats.randgaard@tandberg.com
To: linux-media@vger.kernel.org
Cc: sudhakar.raj@ti.com, Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [PATCH 1/2] TVP7002: Return V4L2_DV_INVALID if any of the errors occur.
Date: Tue,  3 Aug 2010 10:18:03 +0200
Message-Id: <1280823484-21664-2-git-send-email-mats.randgaard@tandberg.com>
In-Reply-To: <1280823484-21664-1-git-send-email-mats.randgaard@tandberg.com>
References: <1280823484-21664-1-git-send-email-mats.randgaard@tandberg.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <mats.randgaard@tandberg.com>

Signed-off-by: Mats Randgaard <mats.randgaard@tandberg.com>
---
 drivers/media/video/tvp7002.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
index 48f5c76..8116cd4 100644
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -796,6 +796,9 @@ static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
 	u8 cpl_msb;
 	int index;
 
+	/* Return invalid preset if no active input is detected */
+	qpreset->preset = V4L2_DV_INVALID;
+
 	device = to_tvp7002(sd);
 
 	/* Read standards from device registers */
@@ -829,8 +832,6 @@ static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
 	if (index == NUM_PRESETS) {
 		v4l2_dbg(1, debug, sd, "detection failed: lpf = %x, cpl = %x\n",
 								lpfr, cpln);
-		/* Could not detect a signal, so return the 'invalid' preset */
-		qpreset->preset = V4L2_DV_INVALID;
 		return 0;
 	}
 
-- 
1.6.4.2

