Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:29517 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3A3Rn4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:43:56 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHG00KPC9959400@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:43:54 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHG00AV798RSVC0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:43:54 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Add missing line breaks
Date: Wed, 30 Jan 2013 18:43:37 +0100
Message-id: <1359567817-32231-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing line breaks in the debug traces.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-core.c    |    4 ++--
 drivers/media/platform/s5p-fimc/fimc-lite.c    |   12 ++++++------
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 92d477c..6d5b03a 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -257,14 +257,14 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 		ty = d_frame->height;
 	}
 	if (tx <= 0 || ty <= 0) {
-		dev_err(dev, "Invalid target size: %dx%d", tx, ty);
+		dev_err(dev, "Invalid target size: %dx%d\n", tx, ty);
 		return -EINVAL;
 	}
 
 	sx = s_frame->width;
 	sy = s_frame->height;
 	if (sx <= 0 || sy <= 0) {
-		dev_err(dev, "Invalid source size: %dx%d", sx, sy);
+		dev_err(dev, "Invalid source size: %dx%d\n", sx, sy);
 		return -EINVAL;
 	}
 	sc->real_width = sx;
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index ef3989f..e18babf 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -611,7 +611,7 @@ static void fimc_lite_try_crop(struct fimc_lite *fimc, struct v4l2_rect *r)
 	r->left = round_down(r->left, fimc->variant->win_hor_offs_align);
 	r->top  = clamp_t(u32, r->top, 0, frame->f_height - r->height);
 
-	v4l2_dbg(1, debug, &fimc->subdev, "(%d,%d)/%dx%d, sink fmt: %dx%d",
+	v4l2_dbg(1, debug, &fimc->subdev, "(%d,%d)/%dx%d, sink fmt: %dx%d\n",
 		 r->left, r->top, r->width, r->height,
 		 frame->f_width, frame->f_height);
 }
@@ -631,7 +631,7 @@ static void fimc_lite_try_compose(struct fimc_lite *fimc, struct v4l2_rect *r)
 	r->left = round_down(r->left, fimc->variant->out_hor_offs_align);
 	r->top  = clamp_t(u32, r->top, 0, fimc->out_frame.f_height - r->height);
 
-	v4l2_dbg(1, debug, &fimc->subdev, "(%d,%d)/%dx%d, source fmt: %dx%d",
+	v4l2_dbg(1, debug, &fimc->subdev, "(%d,%d)/%dx%d, source fmt: %dx%d\n",
 		 r->left, r->top, r->width, r->height,
 		 frame->f_width, frame->f_height);
 }
@@ -1011,7 +1011,7 @@ static int fimc_lite_link_setup(struct media_entity *entity,
 	if (WARN_ON(fimc == NULL))
 		return 0;
 
-	v4l2_dbg(1, debug, sd, "%s: %s --> %s, flags: 0x%x. source_id: 0x%x",
+	v4l2_dbg(1, debug, sd, "%s: %s --> %s, flags: 0x%x. source_id: 0x%x\n",
 		 __func__, remote->entity->name, local->entity->name,
 		 flags, fimc->source_subdev_grp_id);
 
@@ -1120,7 +1120,7 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 	struct flite_frame *source = &fimc->out_frame;
 	const struct fimc_fmt *ffmt;
 
-	v4l2_dbg(1, debug, sd, "pad%d: code: 0x%x, %dx%d",
+	v4l2_dbg(1, debug, sd, "pad%d: code: 0x%x, %dx%d\n",
 		 fmt->pad, mf->code, mf->width, mf->height);
 
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
@@ -1196,7 +1196,7 @@ static int fimc_lite_subdev_get_selection(struct v4l2_subdev *sd,
 	}
 	mutex_unlock(&fimc->lock);
 
-	v4l2_dbg(1, debug, sd, "%s: (%d,%d) %dx%d, f_w: %d, f_h: %d",
+	v4l2_dbg(1, debug, sd, "%s: (%d,%d) %dx%d, f_w: %d, f_h: %d\n",
 		 __func__, f->rect.left, f->rect.top, f->rect.width,
 		 f->rect.height, f->f_width, f->f_height);
 
@@ -1230,7 +1230,7 @@ static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
 	}
 	mutex_unlock(&fimc->lock);
 
-	v4l2_dbg(1, debug, sd, "%s: (%d,%d) %dx%d, f_w: %d, f_h: %d",
+	v4l2_dbg(1, debug, sd, "%s: (%d,%d) %dx%d, f_w: %d, f_h: %d\n",
 		 __func__, f->rect.left, f->rect.top, f->rect.width,
 		 f->rect.height, f->f_width, f->f_height);
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 27d3461..52e1aa3 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -556,7 +556,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 		if (ret)
 			break;
 
-		v4l2_info(&fmd->v4l2_dev, "created link [%s] %c> [%s]",
+		v4l2_info(&fmd->v4l2_dev, "created link [%s] %c> [%s]\n",
 			  source->name, flags ? '=' : '-', sink->name);
 	}
 	return 0;
@@ -640,7 +640,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 			if (ret)
 				return ret;
 
-			v4l2_info(&fmd->v4l2_dev, "created link [%s] => [%s]",
+			v4l2_info(&fmd->v4l2_dev, "created link [%s] => [%s]\n",
 				  sensor->entity.name, csis->entity.name);
 
 			source = NULL;
-- 
1.7.9.5

