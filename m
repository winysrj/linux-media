Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46920 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758819AbcIMXQh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:37 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 06/13] v4l: vsp1: Disable cropping on WPF sink pad
Date: Wed, 14 Sep 2016 02:16:59 +0300
Message-Id: <1473808626-19488-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cropping on the WPF sink pad restricts the left and top coordinates to
0-255. The same result can be obtained by cropping on the RPF without
any such restriction, this feature isn't useful. Disable it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rwpf.c | 37 +++++++++++++++++----------------
 drivers/media/platform/vsp1/vsp1_wpf.c  | 18 +++++++---------
 2 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 8cb87e96b78b..a3ace8df7f4d 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -66,7 +66,6 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect *crop;
 	int ret = 0;
 
 	mutex_lock(&rwpf->entity.lock);
@@ -103,12 +102,16 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 
 	fmt->format = *format;
 
-	/* Update the sink crop rectangle. */
-	crop = vsp1_rwpf_get_crop(rwpf, config);
-	crop->left = 0;
-	crop->top = 0;
-	crop->width = fmt->format.width;
-	crop->height = fmt->format.height;
+	if (rwpf->entity.type == VSP1_ENTITY_RPF) {
+		struct v4l2_rect *crop;
+
+		/* Update the sink crop rectangle. */
+		crop = vsp1_rwpf_get_crop(rwpf, config);
+		crop->left = 0;
+		crop->top = 0;
+		crop->width = fmt->format.width;
+		crop->height = fmt->format.height;
+	}
 
 	/* Propagate the format to the source pad. */
 	format = vsp1_entity_get_pad_format(&rwpf->entity, config,
@@ -129,8 +132,10 @@ static int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
 	struct v4l2_mbus_framefmt *format;
 	int ret = 0;
 
-	/* Cropping is implemented on the sink pad. */
-	if (sel->pad != RWPF_PAD_SINK)
+	/* Cropping is only supported on the RPF and is implemented on the sink
+	 * pad.
+	 */
+	if (rwpf->entity.type == VSP1_ENTITY_WPF || sel->pad != RWPF_PAD_SINK)
 		return -EINVAL;
 
 	mutex_lock(&rwpf->entity.lock);
@@ -175,8 +180,10 @@ static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	struct v4l2_rect *crop;
 	int ret = 0;
 
-	/* Cropping is implemented on the sink pad. */
-	if (sel->pad != RWPF_PAD_SINK)
+	/* Cropping is only supported on the RPF and is implemented on the sink
+	 * pad.
+	 */
+	if (rwpf->entity.type == VSP1_ENTITY_WPF || sel->pad != RWPF_PAD_SINK)
 		return -EINVAL;
 
 	if (sel->target != V4L2_SEL_TGT_CROP)
@@ -190,9 +197,7 @@ static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 		goto done;
 	}
 
-	/* Make sure the crop rectangle is entirely contained in the image. The
-	 * WPF top and left offsets are limited to 255.
-	 */
+	/* Make sure the crop rectangle is entirely contained in the image. */
 	format = vsp1_entity_get_pad_format(&rwpf->entity, config,
 					    RWPF_PAD_SINK);
 
@@ -208,10 +213,6 @@ static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 
 	sel->r.left = min_t(unsigned int, sel->r.left, format->width - 2);
 	sel->r.top = min_t(unsigned int, sel->r.top, format->height - 2);
-	if (rwpf->entity.type == VSP1_ENTITY_WPF) {
-		sel->r.left = min_t(unsigned int, sel->r.left, 255);
-		sel->r.top = min_t(unsigned int, sel->r.top, 255);
-	}
 	sel->r.width = min_t(unsigned int, sel->r.width,
 			     format->width - sel->r.left);
 	sel->r.height = min_t(unsigned int, sel->r.height,
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 748f5af90b7e..f3a593196282 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -212,7 +212,6 @@ static void wpf_configure(struct vsp1_entity *entity,
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
 	const struct v4l2_mbus_framefmt *source_format;
 	const struct v4l2_mbus_framefmt *sink_format;
-	const struct v4l2_rect *crop;
 	unsigned int i;
 	u32 outfmt = 0;
 	u32 srcrpf = 0;
@@ -237,16 +236,6 @@ static void wpf_configure(struct vsp1_entity *entity,
 		return;
 	}
 
-	/* Cropping */
-	crop = vsp1_rwpf_get_crop(wpf, wpf->entity.config);
-
-	vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
-		       (crop->left << VI6_WPF_SZCLIP_OFST_SHIFT) |
-		       (crop->width << VI6_WPF_SZCLIP_SIZE_SHIFT));
-	vsp1_wpf_write(wpf, dl, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
-		       (crop->top << VI6_WPF_SZCLIP_OFST_SHIFT) |
-		       (crop->height << VI6_WPF_SZCLIP_SIZE_SHIFT));
-
 	/* Format */
 	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
 						 wpf->entity.config,
@@ -255,6 +244,13 @@ static void wpf_configure(struct vsp1_entity *entity,
 						   wpf->entity.config,
 						   RWPF_PAD_SOURCE);
 
+	vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
+		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
+		       (source_format->width << VI6_WPF_SZCLIP_SIZE_SHIFT));
+	vsp1_wpf_write(wpf, dl, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
+		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
+		       (source_format->height << VI6_WPF_SZCLIP_SIZE_SHIFT));
+
 	if (!pipe->lif) {
 		const struct v4l2_pix_format_mplane *format = &wpf->format;
 		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
-- 
Regards,

Laurent Pinchart

