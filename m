Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:28719 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3A3RXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:23:42 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHG00KEG8B49400@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:42 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHG00A7W8B4SV70@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:41 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/5] s5p-fimc: Fix FIMC.n subdev set_selection ioctl handler
Date: Wed, 30 Jan 2013 18:23:23 +0100
Message-id: <1359566606-31394-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
References: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_SEL_TGT_CROP_BOUNDS, V4L2_SEL_TGT_COMPOSE_BOUNDS selection
targets are not supposed to be handled in the set_selection ioctl.
Remove the code that doesn't do anything sensible now and make sure
ctx->state is modified with the spinlock held.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 35998a3..f822b8e 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1688,16 +1688,6 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 	fimc_capture_try_selection(ctx, r, V4L2_SEL_TGT_CROP);
 
 	switch (sel->target) {
-	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
-		f = &ctx->d_frame;
-	case V4L2_SEL_TGT_CROP_BOUNDS:
-		r->width = f->o_width;
-		r->height = f->o_height;
-		r->left = 0;
-		r->top = 0;
-		mutex_unlock(&fimc->lock);
-		return 0;
-
 	case V4L2_SEL_TGT_CROP:
 		try_sel = v4l2_subdev_get_try_crop(fh, sel->pad);
 		break;
@@ -1716,9 +1706,9 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 		spin_lock_irqsave(&fimc->slock, flags);
 		set_frame_crop(f, r->left, r->top, r->width, r->height);
 		set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
-		spin_unlock_irqrestore(&fimc->slock, flags);
 		if (sel->target == V4L2_SEL_TGT_COMPOSE)
 			ctx->state |= FIMC_COMPOSE;
+		spin_unlock_irqrestore(&fimc->slock, flags);
 	}
 
 	dbg("target %#x: (%d,%d)/%dx%d", sel->target, r->left, r->top,
-- 
1.7.9.5

