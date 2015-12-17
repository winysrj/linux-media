Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793AbbLQIl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:27 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 46/48] v4l: vsp1: Support video device formats stored in requests
Date: Thu, 17 Dec 2015 10:40:24 +0200
Message-Id: <1450341626-6695-47-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the video device format stored in the request object when
configuring modules if the request isn't NULL.

As the request object doesn't support storage of driver-specific data
format information needs to be looked up on the fly and can't be cached
anymore.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c   |  2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c   |  7 +++++--
 drivers/media/platform/vsp1/vsp1_rwpf.c  | 33 ++++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_rwpf.h  |  5 ++++-
 drivers/media/platform/vsp1/vsp1_video.c | 25 ++++++++++++------------
 drivers/media/platform/vsp1/vsp1_wpf.c   | 25 ++++++++++++------------
 6 files changed, 68 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 5ac7e84b9a62..a27a74bbb8f8 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -320,7 +320,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 		return -EINVAL;
 	}
 
-	rpf->fmtinfo = fmtinfo;
+	rpf->format.pixelformat = pixelformat;
 	rpf->format.num_planes = fmtinfo->planes;
 	rpf->format.plane_fmt[0].bytesperline = pitch;
 	rpf->format.plane_fmt[1].bytesperline = pitch;
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index a1cff6feec30..80038f30ba53 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -62,8 +62,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	struct v4l2_subdev_pad_config *config;
-	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
-	const struct v4l2_pix_format_mplane *format = &rpf->format;
+	const struct vsp1_format_info *fmtinfo;
+	const struct v4l2_pix_format_mplane *format;
 	const struct v4l2_mbus_framefmt *source_format;
 	const struct v4l2_mbus_framefmt *sink_format;
 	const struct v4l2_rect *crop;
@@ -89,6 +89,9 @@ static void rpf_configure(struct vsp1_entity *entity,
 		       (crop->width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
 		       (crop->height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
 
+	format = vsp1_rwpf_get_pixformat(rpf, req);
+	fmtinfo = vsp1_get_format_info(format->pixelformat);
+
 	rpf->offsets[0] = crop->top * format->plane_fmt[0].bytesperline
 			+ crop->left * fmtinfo->bpp[0] / 8;
 	pstride = format->plane_fmt[0].bytesperline
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 4d302f5cccb2..1252d45d6aca 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -27,6 +27,39 @@ struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
 					RWPF_PAD_SINK);
 }
 
+/**
+ * vsp1_rwpf_get_pixformat - Get a pixel format from a request
+ * @entity: the [RW]PF
+ * @req: the request
+ *
+ * Return the pixel format stored in the request for the given [RW]PF. If
+ * the request argument is NULL or doesn't contain pad configuration for the
+ * entity the function will instead return the ACTIVE pixel format stored in the
+ * [RW]PF.
+ */
+const struct v4l2_pix_format_mplane *
+vsp1_rwpf_get_pixformat(struct vsp1_rwpf *rwpf,
+			struct media_device_request *req)
+{
+	struct media_entity_request_data *data;
+	struct video_device_request_data *vdata;
+
+	/* If there's no request or if the request doesn't contain video device
+	 * data return the rwpf active format.
+	 */
+	if (!req)
+		return &rwpf->format;
+
+	data = media_device_request_get_entity_data(req,
+					&rwpf->entity.subdev.entity);
+	if (!data)
+		return &rwpf->format;
+
+	/* Otherwise return the format stored in the request. */
+	vdata = to_video_device_request_data(data);
+	return &vdata->format;
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2 Subdevice Pad Operations
  */
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 9502710977e8..64f101e35232 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -42,7 +42,6 @@ struct vsp1_rwpf {
 	unsigned int max_height;
 
 	struct v4l2_pix_format_mplane format;
-	const struct vsp1_format_info *fmtinfo;
 	unsigned int bru_input;
 
 	unsigned int alpha;
@@ -72,6 +71,10 @@ extern const struct v4l2_subdev_pad_ops vsp1_rwpf_pad_ops;
 
 struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
 				     struct v4l2_subdev_pad_config *config);
+const struct v4l2_pix_format_mplane *
+vsp1_rwpf_get_pixformat(struct vsp1_rwpf *rwpf,
+			struct media_device_request *req);
+
 /**
  * vsp1_rwpf_set_memory - Configure DMA addresses for a [RW]PF
  * @rwpf: the [RW]PF instance
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index a1527d622734..33a1a142002c 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -67,6 +67,7 @@ vsp1_video_remote_subdev(struct media_pad *local, u32 *pad)
 
 static int vsp1_video_verify_format(struct vsp1_video *video)
 {
+	const struct vsp1_format_info *info;
 	struct v4l2_subdev_format fmt;
 	struct v4l2_subdev *subdev;
 	int ret;
@@ -80,7 +81,9 @@ static int vsp1_video_verify_format(struct vsp1_video *video)
 	if (ret < 0)
 		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
 
-	if (video->rwpf->fmtinfo->mbus != fmt.format.code ||
+	info = vsp1_get_format_info(video->rwpf->format.pixelformat);
+
+	if (info->mbus != fmt.format.code ||
 	    video->rwpf->format.height != fmt.format.height ||
 	    video->rwpf->format.width != fmt.format.width)
 		return -EINVAL;
@@ -89,8 +92,7 @@ static int vsp1_video_verify_format(struct vsp1_video *video)
 }
 
 static int __vsp1_video_try_format(struct vsp1_video *video,
-				   struct v4l2_pix_format_mplane *pix,
-				   const struct vsp1_format_info **fmtinfo)
+				   struct v4l2_pix_format_mplane *pix)
 {
 	static const u32 xrgb_formats[][2] = {
 		{ V4L2_PIX_FMT_RGB444, V4L2_PIX_FMT_XRGB444 },
@@ -163,9 +165,6 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 
 	pix->num_planes = info->planes;
 
-	if (fmtinfo)
-		*fmtinfo = info;
-
 	return 0;
 }
 
@@ -177,7 +176,7 @@ vsp1_video_format_adjust(struct vsp1_video *video,
 	unsigned int i;
 
 	*adjust = *format;
-	__vsp1_video_try_format(video, adjust, NULL);
+	__vsp1_video_try_format(video, adjust);
 
 	if (format->width != adjust->width ||
 	    format->height != adjust->height ||
@@ -616,10 +615,12 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 		if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
 			uds->scale_alpha = false;
 		} else {
+			const struct vsp1_format_info *info;
 			struct vsp1_rwpf *rpf =
 				to_rwpf(&pipe->uds_input->subdev);
 
-			uds->scale_alpha = rpf->fmtinfo->alpha;
+			info = vsp1_get_format_info(rpf->format.pixelformat);
+			uds->scale_alpha = info->alpha;
 		}
 	}
 
@@ -758,7 +759,7 @@ vsp1_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
 	if (format->type != video->queue.type)
 		return -EINVAL;
 
-	return __vsp1_video_try_format(video, &format->fmt.pix_mp, NULL);
+	return __vsp1_video_try_format(video, &format->fmt.pix_mp);
 }
 
 static int
@@ -766,13 +767,12 @@ vsp1_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 {
 	struct v4l2_fh *vfh = file->private_data;
 	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
-	const struct vsp1_format_info *info;
 	int ret;
 
 	if (format->type != video->queue.type)
 		return -EINVAL;
 
-	ret = __vsp1_video_try_format(video, &format->fmt.pix_mp, &info);
+	ret = __vsp1_video_try_format(video, &format->fmt.pix_mp);
 	if (ret < 0)
 		return ret;
 
@@ -784,7 +784,6 @@ vsp1_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 	}
 
 	video->rwpf->format = format->fmt.pix_mp;
-	video->rwpf->fmtinfo = info;
 
 done:
 	mutex_unlock(&video->lock);
@@ -969,7 +968,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	rwpf->format.pixelformat = VSP1_VIDEO_DEF_FORMAT;
 	rwpf->format.width = VSP1_VIDEO_DEF_WIDTH;
 	rwpf->format.height = VSP1_VIDEO_DEF_HEIGHT;
-	__vsp1_video_try_format(video, &rwpf->format, &rwpf->fmtinfo);
+	__vsp1_video_try_format(video, &rwpf->format);
 
 	/* ... and the video node... */
 	video->video.v4l2_dev = &video->vsp1->v4l2_dev;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index bde990e010d4..417067f8aae3 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -130,17 +130,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 
 	config = vsp1_entity_get_req_pad_config(entity, req);
 
-	/* Destination stride. */
-	if (!pipe->lif) {
-		struct v4l2_pix_format_mplane *format = &wpf->format;
-
-		vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_Y,
-			       format->plane_fmt[0].bytesperline);
-		if (format->num_planes > 1)
-			vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_C,
-				       format->plane_fmt[1].bytesperline);
-	}
-
+	/* Cropping */
 	crop = vsp1_rwpf_get_crop(wpf, config);
 
 	vsp1_wpf_write(wpf, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
@@ -157,7 +147,11 @@ static void wpf_configure(struct vsp1_entity *entity,
 						   RWPF_PAD_SOURCE);
 
 	if (!pipe->lif) {
-		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
+		const struct v4l2_pix_format_mplane *format;
+		const struct vsp1_format_info *fmtinfo;
+
+		format = vsp1_rwpf_get_pixformat(wpf, req);
+		fmtinfo = vsp1_get_format_info(format->pixelformat);
 
 		outfmt = fmtinfo->hwfmt << VI6_WPF_OUTFMT_WRFMT_SHIFT;
 
@@ -168,6 +162,13 @@ static void wpf_configure(struct vsp1_entity *entity,
 		if (fmtinfo->swap_uv)
 			outfmt |= VI6_WPF_OUTFMT_SPUVS;
 
+		/* Destination stride and byte swapping. */
+		vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_Y,
+			       format->plane_fmt[0].bytesperline);
+		if (format->num_planes > 1)
+			vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_C,
+				       format->plane_fmt[1].bytesperline);
+
 		vsp1_wpf_write(wpf, VI6_WPF_DSWAP, fmtinfo->swap);
 	}
 
-- 
2.4.10

