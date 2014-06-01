Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59654 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbaFADjc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 May 2014 23:39:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 17/18] v4l: vsp1: bru: Support non-premultiplied colors at the BRU output
Date: Sun,  1 Jun 2014 05:39:36 +0200
Message-Id: <1401593977-30660-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The BRU outputs premultiplied colors, enable color data normalization
when the format configured at the output of the pipeline isn't
premultiplied.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index d8d49fb..86b32bc 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -43,8 +43,10 @@ static inline void vsp1_bru_write(struct vsp1_bru *bru, u32 reg, u32 data)
 
 static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 {
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&subdev->entity);
 	struct vsp1_bru *bru = to_bru(subdev);
 	struct v4l2_mbus_framefmt *format;
+	unsigned int flags;
 	unsigned int i;
 
 	if (!enable)
@@ -58,8 +60,13 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 	 * to sane default values for now.
 	 */
 
-	/* Disable both color data normalization and dithering. */
-	vsp1_bru_write(bru, VI6_BRU_INCTRL, 0);
+	/* Disable dithering and enable color data normalization unless the
+	 * format at the pipeline output is premultiplied.
+	 */
+	flags = pipe->output ? pipe->output->video.format.flags : 0;
+	vsp1_bru_write(bru, VI6_BRU_INCTRL,
+		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
+		       0 : VI6_BRU_INCTRL_NRM);
 
 	/* Set the background position to cover the whole output image and
 	 * set its color to opaque black.
-- 
1.8.5.5

