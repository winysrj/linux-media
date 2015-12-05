Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55018 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbbLECNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:13:01 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 02/32] v4l: vsp1: Store the memory format in struct vsp1_rwpf
Date: Sat,  5 Dec 2015 04:12:36 +0200
Message-Id: <1449281586-25726-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the format from struct vsp1_video to struct vsp1_rwpf to prepare
for VSPD KMS support that will not instantiate V4L2 video device nodes.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c   |  4 ++--
 drivers/media/platform/vsp1/vsp1_rpf.c   |  4 ++--
 drivers/media/platform/vsp1/vsp1_rwpf.h  |  2 ++
 drivers/media/platform/vsp1/vsp1_video.c | 40 ++++++++++++++++----------------
 drivers/media/platform/vsp1/vsp1_video.h |  2 --
 drivers/media/platform/vsp1/vsp1_wpf.c   |  4 ++--
 6 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 7dd763311c0f..1308dfef0f92 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -94,7 +94,7 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 	/* Disable dithering and enable color data normalization unless the
 	 * format at the pipeline output is premultiplied.
 	 */
-	flags = pipe->output ? pipe->output->video.format.flags : 0;
+	flags = pipe->output ? pipe->output->format.flags : 0;
 	vsp1_bru_write(bru, VI6_BRU_INCTRL,
 		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
 		       0 : VI6_BRU_INCTRL_NRM);
@@ -125,7 +125,7 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 		if (bru->inputs[i].rpf) {
 			ctrl |= VI6_BRU_CTRL_RBC;
 
-			premultiplied = bru->inputs[i].rpf->video.format.flags
+			premultiplied = bru->inputs[i].rpf->format.flags
 				      & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA;
 		} else {
 			ctrl |= VI6_BRU_CTRL_CROP(VI6_ROP_NOP)
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index b57373a57dc6..ae63dce38b0c 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -75,8 +75,8 @@ static const struct v4l2_ctrl_ops rpf_ctrl_ops = {
 static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(subdev);
-	const struct vsp1_format_info *fmtinfo = rpf->video.fmtinfo;
-	const struct v4l2_pix_format_mplane *format = &rpf->video.format;
+	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
+	const struct v4l2_pix_format_mplane *format = &rpf->format;
 	const struct v4l2_rect *crop = &rpf->crop;
 	u32 pstride;
 	u32 infmt;
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index f452dce1a931..8609c3d02679 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -32,6 +32,8 @@ struct vsp1_rwpf {
 	unsigned int max_width;
 	unsigned int max_height;
 
+	struct v4l2_pix_format_mplane format;
+	const struct vsp1_format_info *fmtinfo;
 	struct {
 		unsigned int left;
 		unsigned int top;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 698cc8aecfbe..3eaf06903495 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -185,9 +185,9 @@ static int vsp1_video_verify_format(struct vsp1_video *video)
 	if (ret < 0)
 		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
 
-	if (video->fmtinfo->mbus != fmt.format.code ||
-	    video->format.height != fmt.format.height ||
-	    video->format.width != fmt.format.width)
+	if (video->rwpf->fmtinfo->mbus != fmt.format.code ||
+	    video->rwpf->format.height != fmt.format.height ||
+	    video->rwpf->format.width != fmt.format.width)
 		return -EINVAL;
 
 	return 0;
@@ -806,7 +806,7 @@ vsp1_video_queue_setup(struct vb2_queue *vq, const void *parg,
 
 		format = &pix_mp;
 	} else {
-		format = &video->format;
+		format = &video->rwpf->format;
 	}
 
 	*nplanes = format->num_planes;
@@ -824,7 +824,7 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
 	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vbuf);
-	const struct v4l2_pix_format_mplane *format = &video->format;
+	const struct v4l2_pix_format_mplane *format = &video->rwpf->format;
 	unsigned int i;
 
 	if (vb->num_planes < format->num_planes)
@@ -907,7 +907,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 				struct vsp1_rwpf *rpf =
 					to_rwpf(&pipe->uds_input->subdev);
 
-				uds->scale_alpha = rpf->video.fmtinfo->alpha;
+				uds->scale_alpha = rpf->fmtinfo->alpha;
 			}
 		}
 
@@ -1011,7 +1011,7 @@ vsp1_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
 		return -EINVAL;
 
 	mutex_lock(&video->lock);
-	format->fmt.pix_mp = video->format;
+	format->fmt.pix_mp = video->rwpf->format;
 	mutex_unlock(&video->lock);
 
 	return 0;
@@ -1051,8 +1051,8 @@ vsp1_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 		goto done;
 	}
 
-	video->format = format->fmt.pix_mp;
-	video->fmtinfo = info;
+	video->rwpf->format = format->fmt.pix_mp;
+	video->rwpf->fmtinfo = info;
 
 done:
 	mutex_unlock(&video->lock);
@@ -1229,17 +1229,17 @@ int vsp1_video_init(struct vsp1_video *video, struct vsp1_rwpf *rwpf)
 		return ret;
 
 	/* ... and the format ... */
-	video->fmtinfo = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
-	video->format.pixelformat = video->fmtinfo->fourcc;
-	video->format.colorspace = V4L2_COLORSPACE_SRGB;
-	video->format.field = V4L2_FIELD_NONE;
-	video->format.width = VSP1_VIDEO_DEF_WIDTH;
-	video->format.height = VSP1_VIDEO_DEF_HEIGHT;
-	video->format.num_planes = 1;
-	video->format.plane_fmt[0].bytesperline =
-		video->format.width * video->fmtinfo->bpp[0] / 8;
-	video->format.plane_fmt[0].sizeimage =
-		video->format.plane_fmt[0].bytesperline * video->format.height;
+	rwpf->fmtinfo = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
+	rwpf->format.pixelformat = rwpf->fmtinfo->fourcc;
+	rwpf->format.colorspace = V4L2_COLORSPACE_SRGB;
+	rwpf->format.field = V4L2_FIELD_NONE;
+	rwpf->format.width = VSP1_VIDEO_DEF_WIDTH;
+	rwpf->format.height = VSP1_VIDEO_DEF_HEIGHT;
+	rwpf->format.num_planes = 1;
+	rwpf->format.plane_fmt[0].bytesperline =
+		rwpf->format.width * rwpf->fmtinfo->bpp[0] / 8;
+	rwpf->format.plane_fmt[0].sizeimage =
+		rwpf->format.plane_fmt[0].bytesperline * rwpf->format.height;
 
 	/* ... and the video node... */
 	video->video.v4l2_dev = &video->vsp1->v4l2_dev;
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index c1d9771c55ed..56d0e7bd4327 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -123,8 +123,6 @@ struct vsp1_video {
 	struct media_pad pad;
 
 	struct mutex lock;
-	struct v4l2_pix_format_mplane format;
-	const struct vsp1_format_info *fmtinfo;
 
 	struct vsp1_pipeline pipe;
 	unsigned int pipe_index;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 9ba5feee50de..e2afd9797e25 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -112,7 +112,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	/* Destination stride. */
 	if (!pipe->lif) {
-		struct v4l2_pix_format_mplane *format = &wpf->video.format;
+		struct v4l2_pix_format_mplane *format = &wpf->format;
 
 		vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_Y,
 			       format->plane_fmt[0].bytesperline);
@@ -130,7 +130,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	/* Format */
 	if (!pipe->lif) {
-		const struct vsp1_format_info *fmtinfo = wpf->video.fmtinfo;
+		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 
 		outfmt = fmtinfo->hwfmt << VI6_WPF_OUTFMT_WRFMT_SHIFT;
 
-- 
2.4.10

