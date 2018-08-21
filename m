Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54410 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbeHUOe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 10:34:59 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH] media: vsp1: Remove artificial pixel limitation
Date: Tue, 21 Aug 2018 12:15:10 +0100
Message-Id: <20180821111510.14620-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSP1 has a minimum width and height of a single pixel, with the
exception of pixel formats with sub-sampling.

Remove the artificial minimum width and minimum height limitation, and
instead clamp the minimum dimensions based upon the sub-sampling
parameter of that dimension.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 81d47a09d7bc..e78eadd0295b 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -38,9 +38,7 @@
 #define VSP1_VIDEO_DEF_WIDTH		1024
 #define VSP1_VIDEO_DEF_HEIGHT		768
 
-#define VSP1_VIDEO_MIN_WIDTH		2U
 #define VSP1_VIDEO_MAX_WIDTH		8190U
-#define VSP1_VIDEO_MIN_HEIGHT		2U
 #define VSP1_VIDEO_MAX_HEIGHT		8190U
 
 /* -----------------------------------------------------------------------------
@@ -136,9 +134,8 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 	height = round_down(height, info->vsub);
 
 	/* Clamp the width and height. */
-	pix->width = clamp(width, VSP1_VIDEO_MIN_WIDTH, VSP1_VIDEO_MAX_WIDTH);
-	pix->height = clamp(height, VSP1_VIDEO_MIN_HEIGHT,
-			    VSP1_VIDEO_MAX_HEIGHT);
+	pix->width = clamp(width, info->hsub, VSP1_VIDEO_MAX_WIDTH);
+	pix->height = clamp(height, info->vsub, VSP1_VIDEO_MAX_HEIGHT);
 
 	/*
 	 * Compute and clamp the stride and image size. While not documented in
-- 
2.17.1
