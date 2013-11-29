Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43067 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3K2Wu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 17:50:58 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 2/6] v4l: vsp1: Add cropping support
Date: Fri, 29 Nov 2013 23:50:48 +0100
Message-Id: <1385765452-25754-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement the get and set selection operations on the RPF and WPF
entities. Only the crop targets are currently available.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c  | 34 ++++++++----
 drivers/media/platform/vsp1/vsp1_rwpf.c | 96 +++++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_rwpf.h | 10 ++++
 drivers/media/platform/vsp1/vsp1_wpf.c  | 17 +++---
 4 files changed, 141 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 254871d..bce2be5 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -47,25 +47,36 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	struct vsp1_rwpf *rpf = to_rwpf(subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->video.fmtinfo;
 	const struct v4l2_pix_format_mplane *format = &rpf->video.format;
+	const struct v4l2_rect *crop = &rpf->crop;
 	u32 pstride;
 	u32 infmt;
 
 	if (!enable)
 		return 0;
 
-	/* Source size and stride. Cropping isn't supported yet. */
+	/* Source size, stride and crop offsets.
+	 *
+	 * The crop offsets correspond to the location of the crop rectangle top
+	 * left corner in the plane buffer. Only two offsets are needed, as
+	 * planes 2 and 3 always have identical strides.
+	 */
 	vsp1_rpf_write(rpf, VI6_RPF_SRC_BSIZE,
-		       (format->width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
-		       (format->height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
+		       (crop->width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
+		       (crop->height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
 	vsp1_rpf_write(rpf, VI6_RPF_SRC_ESIZE,
-		       (format->width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
-		       (format->height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
+		       (crop->width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
+		       (crop->height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
 
+	rpf->offsets[0] = crop->top * format->plane_fmt[0].bytesperline
+			+ crop->left * fmtinfo->bpp[0] / 8;
 	pstride = format->plane_fmt[0].bytesperline
 		<< VI6_RPF_SRCM_PSTRIDE_Y_SHIFT;
-	if (format->num_planes > 1)
+	if (format->num_planes > 1) {
+		rpf->offsets[1] = crop->top * format->plane_fmt[1].bytesperline
+				+ crop->left * fmtinfo->bpp[1] / 8;
 		pstride |= format->plane_fmt[1].bytesperline
 			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
+	}
 
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_PSTRIDE, pstride);
 
@@ -113,6 +124,8 @@ static struct v4l2_subdev_pad_ops rpf_pad_ops = {
 	.enum_frame_size = vsp1_rwpf_enum_frame_size,
 	.get_fmt = vsp1_rwpf_get_format,
 	.set_fmt = vsp1_rwpf_set_format,
+	.get_selection = vsp1_rwpf_get_selection,
+	.set_selection = vsp1_rwpf_set_selection,
 };
 
 static struct v4l2_subdev_ops rpf_ops = {
@@ -129,11 +142,14 @@ static void rpf_vdev_queue(struct vsp1_video *video,
 {
 	struct vsp1_rwpf *rpf = container_of(video, struct vsp1_rwpf, video);
 
-	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y, buf->addr[0]);
+	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
+		       buf->addr[0] + rpf->offsets[0]);
 	if (buf->buf.num_planes > 1)
-		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0, buf->addr[1]);
+		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
+			       buf->addr[1] + rpf->offsets[1]);
 	if (buf->buf.num_planes > 2)
-		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1, buf->addr[2]);
+		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
+			       buf->addr[2] + rpf->offsets[1]);
 }
 
 static const struct vsp1_video_operations rpf_vdev_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 9752d55..782f770 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -71,6 +71,19 @@ int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
+static struct v4l2_rect *
+vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf, struct v4l2_subdev_fh *fh, u32 which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_crop(fh, RWPF_PAD_SINK);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &rwpf->crop;
+	default:
+		return NULL;
+	}
+}
+
 int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 			 struct v4l2_subdev_format *fmt)
 {
@@ -87,6 +100,7 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
 
 	/* Default to YUV if the requested format is not supported. */
 	if (fmt->format.code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
@@ -115,6 +129,13 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 
 	fmt->format = *format;
 
+	/* Update the sink crop rectangle. */
+	crop = vsp1_rwpf_get_crop(rwpf, fh, fmt->which);
+	crop->left = 0;
+	crop->top = 0;
+	crop->width = fmt->format.width;
+	crop->height = fmt->format.height;
+
 	/* Propagate the format to the source pad. */
 	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, RWPF_PAD_SOURCE,
 					    fmt->which);
@@ -122,3 +143,78 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 
 	return 0;
 }
+
+int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	/* Cropping is implemented on the sink pad. */
+	if (sel->pad != RWPF_PAD_SINK)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		sel->r = *vsp1_rwpf_get_crop(rwpf, fh, sel->which);
+		break;
+
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		format = vsp1_entity_get_pad_format(&rwpf->entity, fh,
+						    RWPF_PAD_SINK, sel->which);
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = format->width;
+		sel->r.height = format->height;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
+
+	/* Cropping is implemented on the sink pad. */
+	if (sel->pad != RWPF_PAD_SINK)
+		return -EINVAL;
+
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	/* Make sure the crop rectangle is entirely contained in the image. The
+	 * WPF top and left offsets are limited to 255.
+	 */
+	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, RWPF_PAD_SINK,
+					    sel->which);
+	sel->r.left = min_t(unsigned int, sel->r.left, format->width - 2);
+	sel->r.top = min_t(unsigned int, sel->r.top, format->height - 2);
+	if (rwpf->entity.type == VSP1_ENTITY_WPF) {
+		sel->r.left = min_t(unsigned int, sel->r.left, 255);
+		sel->r.top = min_t(unsigned int, sel->r.top, 255);
+	}
+	sel->r.width = min_t(unsigned int, sel->r.width,
+			     format->width - sel->r.left);
+	sel->r.height = min_t(unsigned int, sel->r.height,
+			      format->height - sel->r.top);
+
+	crop = vsp1_rwpf_get_crop(rwpf, fh, sel->which);
+	*crop = sel->r;
+
+	/* Propagate the format to the source pad. */
+	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, RWPF_PAD_SOURCE,
+					    sel->which);
+	format->width = crop->width;
+	format->height = crop->height;
+
+	return 0;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index c182d85..6cbdb54 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -29,6 +29,10 @@ struct vsp1_rwpf {
 
 	unsigned int max_width;
 	unsigned int max_height;
+
+	struct v4l2_rect crop;
+
+	unsigned int offsets[2];
 };
 
 static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)
@@ -49,5 +53,11 @@ int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 			 struct v4l2_subdev_format *fmt);
 int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 			 struct v4l2_subdev_format *fmt);
+int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_selection *sel);
+int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_selection *sel);
 
 #endif /* __VSP1_RWPF_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index db4b85e..7baed81 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -48,8 +48,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	struct vsp1_pipeline *pipe =
 		to_vsp1_pipeline(&wpf->entity.subdev.entity);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
-	const struct v4l2_mbus_framefmt *format =
-		&wpf->entity.formats[RWPF_PAD_SOURCE];
+	const struct v4l2_rect *crop = &wpf->crop;
 	unsigned int i;
 	u32 srcrpf = 0;
 	u32 outfmt = 0;
@@ -68,7 +67,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, srcrpf);
 
-	/* Destination stride. Cropping isn't supported yet. */
+	/* Destination stride. */
 	if (!pipe->lif) {
 		struct v4l2_pix_format_mplane *format = &wpf->video.format;
 
@@ -79,10 +78,12 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 				       format->plane_fmt[1].bytesperline);
 	}
 
-	vsp1_wpf_write(wpf, VI6_WPF_HSZCLIP,
-		       format->width << VI6_WPF_SZCLIP_SIZE_SHIFT);
-	vsp1_wpf_write(wpf, VI6_WPF_VSZCLIP,
-		       format->height << VI6_WPF_SZCLIP_SIZE_SHIFT);
+	vsp1_wpf_write(wpf, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
+		       (crop->left << VI6_WPF_SZCLIP_OFST_SHIFT) |
+		       (crop->width << VI6_WPF_SZCLIP_SIZE_SHIFT));
+	vsp1_wpf_write(wpf, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
+		       (crop->top << VI6_WPF_SZCLIP_OFST_SHIFT) |
+		       (crop->height << VI6_WPF_SZCLIP_SIZE_SHIFT));
 
 	/* Format */
 	if (!pipe->lif) {
@@ -130,6 +131,8 @@ static struct v4l2_subdev_pad_ops wpf_pad_ops = {
 	.enum_frame_size = vsp1_rwpf_enum_frame_size,
 	.get_fmt = vsp1_rwpf_get_format,
 	.set_fmt = vsp1_rwpf_set_format,
+	.get_selection = vsp1_rwpf_get_selection,
+	.set_selection = vsp1_rwpf_set_selection,
 };
 
 static struct v4l2_subdev_ops wpf_ops = {
-- 
1.8.3.2

