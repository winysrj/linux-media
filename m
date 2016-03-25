Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbcCYKo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:56 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 31/54] v4l: vsp1: Store active selection rectangles in a pad config structure
Date: Fri, 25 Mar 2016 12:44:05 +0200
Message-Id: <1458902668-1141-32-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the pad config structure part of the vsp1_entity to store all active
pad selection rectangles. This generalizes the code to operate on pad
config structures.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 24 +++++++++++-------------
 drivers/media/platform/vsp1/vsp1_bru.h    |  1 -
 drivers/media/platform/vsp1/vsp1_drm.c    |  5 ++---
 drivers/media/platform/vsp1/vsp1_entity.c |  8 ++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |  4 ++++
 drivers/media/platform/vsp1/vsp1_rpf.c    | 20 +++++++++++++++++---
 drivers/media/platform/vsp1/vsp1_rwpf.c   | 22 +++++++---------------
 drivers/media/platform/vsp1/vsp1_rwpf.h   |  8 +++-----
 drivers/media/platform/vsp1/vsp1_video.c  | 13 +++----------
 drivers/media/platform/vsp1/vsp1_wpf.c    |  4 +++-
 10 files changed, 58 insertions(+), 51 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 1691d13131a9..d3b63056450a 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -231,17 +231,9 @@ static int bru_enum_frame_size(struct v4l2_subdev *subdev,
 
 static struct v4l2_rect *bru_get_compose(struct vsp1_bru *bru,
 					 struct v4l2_subdev_pad_config *cfg,
-					 unsigned int pad, u32 which)
+					 unsigned int pad)
 {
-	switch (which) {
-	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_compose(&bru->entity.subdev, cfg,
-						   pad);
-	case V4L2_SUBDEV_FORMAT_ACTIVE:
-		return &bru->inputs[pad].compose;
-	default:
-		return NULL;
-	}
+	return v4l2_subdev_get_try_compose(&bru->entity.subdev, cfg, pad);
 }
 
 static int bru_get_format(struct v4l2_subdev *subdev,
@@ -310,7 +302,7 @@ static int bru_set_format(struct v4l2_subdev *subdev,
 	if (fmt->pad != bru->entity.source_pad) {
 		struct v4l2_rect *compose;
 
-		compose = bru_get_compose(bru, cfg, fmt->pad, fmt->which);
+		compose = bru_get_compose(bru, config, fmt->pad);
 		compose->left = 0;
 		compose->top = 0;
 		compose->width = format->width;
@@ -336,6 +328,7 @@ static int bru_get_selection(struct v4l2_subdev *subdev,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
+	struct v4l2_subdev_pad_config *config;
 
 	if (sel->pad == bru->entity.source_pad)
 		return -EINVAL;
@@ -349,7 +342,12 @@ static int bru_get_selection(struct v4l2_subdev *subdev,
 		return 0;
 
 	case V4L2_SEL_TGT_COMPOSE:
-		sel->r = *bru_get_compose(bru, cfg, sel->pad, sel->which);
+		config = vsp1_entity_get_pad_config(&bru->entity, cfg,
+						    sel->which);
+		if (!config)
+			return -EINVAL;
+
+		sel->r = *bru_get_compose(bru, config, sel->pad);
 		return 0;
 
 	default:
@@ -391,7 +389,7 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	sel->r.width = format->width;
 	sel->r.height = format->height;
 
-	compose = bru_get_compose(bru, cfg, sel->pad, sel->which);
+	compose = bru_get_compose(bru, config, sel->pad);
 	*compose = sel->r;
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_bru.h b/drivers/media/platform/vsp1/vsp1_bru.h
index 4e7d2e79b940..828a3fcadea8 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.h
+++ b/drivers/media/platform/vsp1/vsp1_bru.h
@@ -31,7 +31,6 @@ struct vsp1_bru {
 
 	struct {
 		struct vsp1_rwpf *rpf;
-		struct v4l2_rect compose;
 	} inputs[VSP1_MAX_RPF];
 
 	u32 bgcolor;
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index a73018c9e8b5..acbf36d315b9 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -410,9 +410,8 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
 		sel.pad);
 
-	/* Store the compose rectangle coordinates in the RPF. */
-	rpf->location.left = dst->left;
-	rpf->location.top = dst->top;
+	/* Store the BRU input pad number in the RPF. */
+	rpf->bru_input = rpf->entity.index;
 
 	/* Cache the memory buffer address but don't apply the values to the
 	 * hardware as the crop offsets haven't been computed yet.
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 57b746f81bc7..37519acd1691 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -88,6 +88,14 @@ vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 	return v4l2_subdev_get_try_format(&entity->subdev, cfg, pad);
 }
 
+struct v4l2_rect *
+vsp1_entity_get_pad_compose(struct vsp1_entity *entity,
+			    struct v4l2_subdev_pad_config *cfg,
+			    unsigned int pad)
+{
+	return v4l2_subdev_get_try_compose(&entity->subdev, cfg, pad);
+}
+
 /*
  * vsp1_entity_init_cfg - Initialize formats on all pads
  * @subdev: V4L2 subdevice
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 6fd53bc80aa2..1935ae9289ba 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -111,6 +111,10 @@ struct v4l2_mbus_framefmt *
 vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 			   struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad);
+struct v4l2_rect *
+vsp1_entity_get_pad_compose(struct vsp1_entity *entity,
+			    struct v4l2_subdev_pad_config *cfg,
+			    unsigned int pad);
 int vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 			 struct v4l2_subdev_pad_config *cfg);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 3485ad0f61ed..198487952418 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -44,7 +44,9 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	const struct v4l2_pix_format_mplane *format = &rpf->format;
 	const struct v4l2_mbus_framefmt *source_format;
 	const struct v4l2_mbus_framefmt *sink_format;
-	const struct v4l2_rect *crop = &rpf->crop;
+	const struct v4l2_rect *crop;
+	unsigned int left = 0;
+	unsigned int top = 0;
 	u32 pstride;
 	u32 infmt;
 
@@ -57,6 +59,8 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	 * left corner in the plane buffer. Only two offsets are needed, as
 	 * planes 2 and 3 always have identical strides.
 	 */
+	crop = vsp1_rwpf_get_crop(rpf, rpf->entity.config);
+
 	vsp1_rpf_write(rpf, VI6_RPF_SRC_BSIZE,
 		       (crop->width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
 		       (crop->height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
@@ -103,9 +107,19 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	vsp1_rpf_write(rpf, VI6_RPF_DSWAP, fmtinfo->swap);
 
 	/* Output location */
+	if (pipe->bru) {
+		const struct v4l2_rect *compose;
+
+		compose = vsp1_entity_get_pad_compose(pipe->bru,
+						      pipe->bru->config,
+						      rpf->bru_input);
+		left = compose->left;
+		top = compose->top;
+	}
+
 	vsp1_rpf_write(rpf, VI6_RPF_LOC,
-		       (rpf->location.left << VI6_RPF_LOC_HCOORD_SHIFT) |
-		       (rpf->location.top << VI6_RPF_LOC_VCOORD_SHIFT));
+		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
+		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
 
 	/* Use the alpha channel (extended to 8 bits) when available or an
 	 * alpha value set through the V4L2_CID_ALPHA_COMPONENT control
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index e5216d39723e..0c5ad023adfb 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -76,19 +76,11 @@ int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static struct v4l2_rect *
-vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf, struct v4l2_subdev_pad_config *cfg,
-		   u32 which)
+struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
+				     struct v4l2_subdev_pad_config *config)
 {
-	switch (which) {
-	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_crop(&rwpf->entity.subdev, cfg,
-						RWPF_PAD_SINK);
-	case V4L2_SUBDEV_FORMAT_ACTIVE:
-		return &rwpf->crop;
-	default:
-		return NULL;
-	}
+	return v4l2_subdev_get_try_crop(&rwpf->entity.subdev, config,
+					RWPF_PAD_SINK);
 }
 
 int vsp1_rwpf_get_format(struct v4l2_subdev *subdev,
@@ -148,7 +140,7 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 	fmt->format = *format;
 
 	/* Update the sink crop rectangle. */
-	crop = vsp1_rwpf_get_crop(rwpf, cfg, fmt->which);
+	crop = vsp1_rwpf_get_crop(rwpf, config);
 	crop->left = 0;
 	crop->top = 0;
 	crop->width = fmt->format.width;
@@ -180,7 +172,7 @@ int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		sel->r = *vsp1_rwpf_get_crop(rwpf, cfg, sel->which);
+		sel->r = *vsp1_rwpf_get_crop(rwpf, config);
 		break;
 
 	case V4L2_SEL_TGT_CROP_BOUNDS:
@@ -246,7 +238,7 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	sel->r.height = min_t(unsigned int, sel->r.height,
 			      format->height - sel->r.top);
 
-	crop = vsp1_rwpf_get_crop(rwpf, cfg, sel->which);
+	crop = vsp1_rwpf_get_crop(rwpf, config);
 	*crop = sel->r;
 
 	/* Propagate the format to the source pad. */
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index e8ca9b6ee689..4ebfab61e0ef 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -43,11 +43,7 @@ struct vsp1_rwpf {
 
 	struct v4l2_pix_format_mplane format;
 	const struct vsp1_format_info *fmtinfo;
-	struct {
-		unsigned int left;
-		unsigned int top;
-	} location;
-	struct v4l2_rect crop;
+	unsigned int bru_input;
 
 	unsigned int alpha;
 
@@ -91,6 +87,8 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 			    struct v4l2_subdev_pad_config *cfg,
 			    struct v4l2_subdev_selection *sel);
 
+struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
+				     struct v4l2_subdev_pad_config *config);
 /**
  * vsp1_rwpf_set_memory - Configure DMA addresses for a [RW]PF
  * @rwpf: the [RW]PF instance
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 102977ae1daa..d4a092c8ece3 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -182,9 +182,6 @@ static int vsp1_video_pipeline_validate_branch(struct vsp1_pipeline *pipe,
 	bool bru_found = false;
 	int ret;
 
-	input->location.left = 0;
-	input->location.top = 0;
-
 	ret = media_entity_enum_init(&ent_enum, &input->entity.vsp1->media_dev);
 	if (ret < 0)
 		return ret;
@@ -206,18 +203,14 @@ static int vsp1_video_pipeline_validate_branch(struct vsp1_pipeline *pipe,
 		entity = to_vsp1_entity(
 			media_entity_to_v4l2_subdev(pad->entity));
 
-		/* A BRU is present in the pipeline, store the compose rectangle
-		 * location in the input RPF for use when configuring the RPF.
+		/* A BRU is present in the pipeline, store the BRU input pad
+		 * number in the input RPF for use when configuring the RPF.
 		 */
 		if (entity->type == VSP1_ENTITY_BRU) {
 			struct vsp1_bru *bru = to_bru(&entity->subdev);
-			struct v4l2_rect *rect =
-				&bru->inputs[pad->index].compose;
 
 			bru->inputs[pad->index].rpf = input;
-
-			input->location.left = rect->left;
-			input->location.top = rect->top;
+			input->bru_input = pad->index;
 
 			bru_found = true;
 		}
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 254f90a85162..962b43b7f99e 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -44,7 +44,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
 	const struct v4l2_mbus_framefmt *source_format;
 	const struct v4l2_mbus_framefmt *sink_format;
-	const struct v4l2_rect *crop = &wpf->crop;
+	const struct v4l2_rect *crop;
 	unsigned int i;
 	u32 srcrpf = 0;
 	u32 outfmt = 0;
@@ -88,6 +88,8 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 				       format->plane_fmt[1].bytesperline);
 	}
 
+	crop = vsp1_rwpf_get_crop(wpf, wpf->entity.config);
+
 	vsp1_wpf_write(wpf, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 		       (crop->left << VI6_WPF_SZCLIP_OFST_SHIFT) |
 		       (crop->width << VI6_WPF_SZCLIP_SIZE_SHIFT));
-- 
2.7.3

