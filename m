Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbcCXX2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:05 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 14/51] v4l: vsp1: bru: Don't program background color in control set handler
Date: Fri, 25 Mar 2016 01:27:10 +0200
Message-Id: <1458862067-19525-15-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The datasheet clearly states that all but a few registers can't be
modified when the device is running. Programming the background color
in the control set handler is thus prohibited. Program it when starting
the module instead.

This requires storing the background color value internally as the
module can be started from the frame completion interrupt handler, and
accessing control values requires taking a mutex.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c | 15 +++++++++------
 drivers/media/platform/vsp1/vsp1_bru.h |  2 ++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 565c8b2edf19..16345ec66870 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -42,13 +42,9 @@ static int bru_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct vsp1_bru *bru =
 		container_of(ctrl->handler, struct vsp1_bru, ctrls);
 
-	if (!vsp1_entity_is_streaming(&bru->entity))
-		return 0;
-
 	switch (ctrl->id) {
 	case V4L2_CID_BG_COLOR:
-		vsp1_bru_write(bru, VI6_BRU_VIRRPF_COL, ctrl->val |
-			       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
+		bru->bgcolor = ctrl->val;
 		break;
 	}
 
@@ -95,12 +91,17 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
 		       0 : VI6_BRU_INCTRL_NRM);
 
-	/* Set the background position to cover the whole output image. */
+	/* Set the background position to cover the whole output image and
+	 * configure its color.
+	 */
 	vsp1_bru_write(bru, VI6_BRU_VIRRPF_SIZE,
 		       (format->width << VI6_BRU_VIRRPF_SIZE_HSIZE_SHIFT) |
 		       (format->height << VI6_BRU_VIRRPF_SIZE_VSIZE_SHIFT));
 	vsp1_bru_write(bru, VI6_BRU_VIRRPF_LOC, 0);
 
+	vsp1_bru_write(bru, VI6_BRU_VIRRPF_COL, bru->bgcolor |
+		       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
+
 	/* Route BRU input 1 as SRC input to the ROP unit and configure the ROP
 	 * unit with a NOP operation to make BRU input 1 available as the
 	 * Blend/ROP unit B SRC input.
@@ -440,6 +441,8 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 	v4l2_ctrl_new_std(&bru->ctrls, &bru_ctrl_ops, V4L2_CID_BG_COLOR,
 			  0, 0xffffff, 1, 0);
 
+	bru->bgcolor = 0;
+
 	bru->entity.subdev.ctrl_handler = &bru->ctrls;
 
 	if (bru->ctrls.error) {
diff --git a/drivers/media/platform/vsp1/vsp1_bru.h b/drivers/media/platform/vsp1/vsp1_bru.h
index dbac9686ea69..4e7d2e79b940 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.h
+++ b/drivers/media/platform/vsp1/vsp1_bru.h
@@ -33,6 +33,8 @@ struct vsp1_bru {
 		struct vsp1_rwpf *rpf;
 		struct v4l2_rect compose;
 	} inputs[VSP1_MAX_RPF];
+
+	u32 bgcolor;
 };
 
 static inline struct vsp1_bru *to_bru(struct v4l2_subdev *subdev)
-- 
2.7.3

