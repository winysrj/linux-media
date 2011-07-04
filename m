Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17598 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab1GDRzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 13:55:44 -0400
Date: Mon, 04 Jul 2011 19:54:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 07/19] s5p-fimc: Remove v4l2_device from video capture and
 m2m driver
In-reply-to: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1309802110-16682-8-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently there is a v4l2_device instance being registered per each
(capture and memory-to-memory) video node created per FIMC H/W instance.
This patch is a prerequisite for using the top level v4l2_device
instantiated by the media device driver.
To retain current debug trace semantic (so it's possible to distinguish
between the capture and m2m FIMC) the video_device is used in place
of v4l2_device where appropriate.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   43 ++++++----------
 drivers/media/video/s5p-fimc/fimc-core.c    |   70 ++++++++++----------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   15 +++---
 drivers/media/video/s5p-fimc/fimc-reg.c     |    7 ++-
 4 files changed, 55 insertions(+), 80 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index e7aa61e..70892e4 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -130,7 +130,6 @@ static int start_streaming(struct vb2_queue *q)
 	fimc->vid_cap.buf_index = 0;
 
 	set_bit(ST_CAPT_PEND, &fimc->state);
-
 	return 0;
 }
 
@@ -177,7 +176,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct fimc_ctx *ctx = vq->drv_priv;
-	struct v4l2_device *v4l2_dev = &ctx->fimc_dev->m2m.v4l2_dev;
 	int i;
 
 	if (!ctx->d_frame.fmt || vq->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
@@ -187,7 +185,8 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		unsigned long size = get_plane_size(&ctx->d_frame, i);
 
 		if (vb2_plane_size(vb, i) < size) {
-			v4l2_err(v4l2_dev, "User buffer too small (%ld < %ld)\n",
+			v4l2_err(ctx->fimc_dev->vid_cap.vfd,
+				 "User buffer too small (%ld < %ld)\n",
 				 vb2_plane_size(vb, i), size);
 			return -EINVAL;
 		}
@@ -398,7 +397,8 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	pix = &f->fmt.pix_mp;
 	frame->fmt = find_format(f, FMT_FLAGS_M2M | FMT_FLAGS_CAM);
 	if (!frame->fmt) {
-		err("fimc target format not found\n");
+		v4l2_err(fimc->vid_cap.vfd,
+			 "Not supported capture (FIMC target) color format\n");
 		return -EINVAL;
 	}
 
@@ -458,7 +458,7 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 		return -EBUSY;
 
 	if (!(ctx->state & FIMC_DST_FMT)) {
-		v4l2_err(&fimc->vid_cap.v4l2_dev, "Format is not set\n");
+		v4l2_err(fimc->vid_cap.vfd, "Format is not set\n");
 		return -EINVAL;
 	}
 
@@ -588,9 +588,8 @@ static int fimc_cap_s_crop(struct file *file, void *fh,
 		return ret;
 
 	if (!(ctx->state & FIMC_DST_FMT)) {
-		v4l2_err(&fimc->vid_cap.v4l2_dev,
-			 "Capture color format not set\n");
-		return -EINVAL; /* TODO: make sure this is the right value */
+		v4l2_err(fimc->vid_cap.vfd, "Capture format is not set\n");
+		return -EINVAL;
 	}
 
 	f = &ctx->s_frame;
@@ -599,7 +598,7 @@ static int fimc_cap_s_crop(struct file *file, void *fh,
 				      ctx->d_frame.width, ctx->d_frame.height,
 				      ctx->rotation);
 	if (ret) {
-		v4l2_err(&fimc->vid_cap.v4l2_dev, "Out of the scaler range\n");
+		v4l2_err(fimc->vid_cap.vfd, "Out of the scaler range\n");
 		return ret;
 	}
 
@@ -643,16 +642,16 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 };
 
 /* fimc->lock must be already initialized */
-int fimc_register_capture_device(struct fimc_dev *fimc)
+int fimc_register_capture_device(struct fimc_dev *fimc,
+				 struct v4l2_device *v4l2_dev)
 {
-	struct v4l2_device *v4l2_dev = &fimc->vid_cap.v4l2_dev;
 	struct video_device *vfd;
 	struct fimc_vid_cap *vid_cap;
 	struct fimc_ctx *ctx;
 	struct v4l2_format f;
 	struct fimc_frame *fr;
 	struct vb2_queue *q;
-	int ret;
+	int ret = -ENOMEM;
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
@@ -670,20 +669,14 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	fr->width = fr->f_width = fr->o_width = 640;
 	fr->height = fr->f_height = fr->o_height = 480;
 
-	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
-		 "%s.capture", dev_name(&fimc->pdev->dev));
-
-	ret = v4l2_device_register(NULL, v4l2_dev);
-	if (ret)
-		goto err_info;
-
 	vfd = video_device_alloc();
 	if (!vfd) {
 		v4l2_err(v4l2_dev, "Failed to allocate video device\n");
-		goto err_v4l2_reg;
+		goto err_vd_alloc;
 	}
 
-	strlcpy(vfd->name, v4l2_dev->name, sizeof(vfd->name));
+	snprintf(vfd->name, sizeof(vfd->name), "%s.capture",
+		 dev_name(&fimc->pdev->dev));
 
 	vfd->fops	= &fimc_capture_fops;
 	vfd->ioctl_ops	= &fimc_capture_ioctl_ops;
@@ -728,8 +721,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 		goto err_vd_reg;
 	}
 
-	v4l2_info(v4l2_dev,
-		  "FIMC capture driver registered as /dev/video%d\n",
+	v4l2_info(vfd, "FIMC capture driver registered as /dev/video%d\n",
 		  vfd->num);
 	return 0;
 
@@ -737,11 +729,8 @@ err_vd_reg:
 	media_entity_cleanup(&vfd->entity);
 err_ent:
 	video_device_release(vfd);
-err_v4l2_reg:
-	v4l2_device_unregister(v4l2_dev);
-err_info:
+err_vd_alloc:
 	kfree(ctx);
-	dev_err(&fimc->pdev->dev, "failed to install\n");
 	return ret;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index fd6a308..8e2f2ee 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -236,10 +236,11 @@ static int fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
 
 int fimc_set_scaler_info(struct fimc_ctx *ctx)
 {
+	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	struct device *dev = &ctx->fimc_dev->pdev->dev;
 	struct fimc_scaler *sc = &ctx->scaler;
 	struct fimc_frame *s_frame = &ctx->s_frame;
 	struct fimc_frame *d_frame = &ctx->d_frame;
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	int tx, ty, sx, sy;
 	int ret;
 
@@ -251,15 +252,14 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 		ty = d_frame->height;
 	}
 	if (tx <= 0 || ty <= 0) {
-		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
-			"invalid target size: %d x %d", tx, ty);
+		dev_err(dev, "Invalid target size: %dx%d", tx, ty);
 		return -EINVAL;
 	}
 
 	sx = s_frame->width;
 	sy = s_frame->height;
 	if (sx <= 0 || sy <= 0) {
-		err("invalid source size: %d x %d", sx, sy);
+		dev_err(dev, "Invalid source size: %dx%d", sx, sy);
 		return -EINVAL;
 	}
 	sc->real_width = sx;
@@ -898,7 +898,7 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 	mask = is_output ? FMT_FLAGS_M2M : FMT_FLAGS_M2M | FMT_FLAGS_CAM;
 	fmt = find_format(f, mask);
 	if (!fmt) {
-		v4l2_err(&fimc->m2m.v4l2_dev, "Fourcc format (0x%X) invalid.\n",
+		v4l2_err(fimc->v4l2_dev, "Fourcc format (0x%X) invalid.\n",
 			 pix->pixelformat);
 		return -EINVAL;
 	}
@@ -973,7 +973,7 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
 
 	if (vb2_is_busy(vq)) {
-		v4l2_err(&fimc->m2m.v4l2_dev, "queue (%d) busy\n", f->type);
+		v4l2_err(fimc->m2m.vfd, "queue (%d) busy\n", f->type);
 		return -EBUSY;
 	}
 
@@ -982,7 +982,7 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		frame = &ctx->d_frame;
 	} else {
-		v4l2_err(&fimc->m2m.v4l2_dev,
+		v4l2_err(fimc->m2m.vfd,
 			 "Wrong buffer/video queue type (%d)\n", f->type);
 		return -EINVAL;
 	}
@@ -1110,7 +1110,7 @@ int fimc_vidioc_g_ctrl(struct file *file, void *priv,
 			return v4l2_subdev_call(fimc->vid_cap.sd, core,
 						g_ctrl, ctrl);
 		} else {
-			v4l2_err(&fimc->m2m.v4l2_dev, "Invalid control\n");
+			v4l2_err(fimc->m2m.vfd, "Invalid control\n");
 			return -EINVAL;
 		}
 	}
@@ -1128,8 +1128,7 @@ int check_ctrl_val(struct fimc_ctx *ctx,  struct v4l2_control *ctrl)
 
 	if (ctrl->value < c->minimum || ctrl->value > c->maximum
 		|| (c->step != 0 && ctrl->value % c->step != 0)) {
-		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
-		"Invalid control value\n");
+		v4l2_err(ctx->fimc_dev->m2m.vfd, "Invalid control value\n");
 		return -ERANGE;
 	}
 
@@ -1165,7 +1164,7 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 		}
 
 		if (ret) {
-			v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range\n");
+			v4l2_err(fimc->m2m.vfd, "Out of scaler range\n");
 			return -EINVAL;
 		}
 
@@ -1177,7 +1176,7 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 		break;
 
 	default:
-		v4l2_err(&fimc->m2m.v4l2_dev, "Invalid control\n");
+		v4l2_err(fimc->v4l2_dev, "Invalid control\n");
 		return -EINVAL;
 	}
 
@@ -1245,7 +1244,7 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 	int i;
 
 	if (cr->c.top < 0 || cr->c.left < 0) {
-		v4l2_err(&fimc->m2m.v4l2_dev,
+		v4l2_err(fimc->m2m.vfd,
 			"doesn't support negative values for top & left\n");
 		return -EINVAL;
 	}
@@ -1326,7 +1325,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 						      ctx->rotation);
 		}
 		if (ret) {
-			v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range\n");
+			v4l2_err(fimc->m2m.vfd, "Out of scaler range\n");
 			return -EINVAL;
 		}
 	}
@@ -1494,30 +1493,23 @@ static struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= fimc_job_abort,
 };
 
-int fimc_register_m2m_device(struct fimc_dev *fimc)
+int fimc_register_m2m_device(struct fimc_dev *fimc,
+			     struct v4l2_device *v4l2_dev)
 {
 	struct video_device *vfd;
 	struct platform_device *pdev;
-	struct v4l2_device *v4l2_dev;
 	int ret = 0;
 
 	if (!fimc)
 		return -ENODEV;
 
 	pdev = fimc->pdev;
-	v4l2_dev = &fimc->m2m.v4l2_dev;
-
-	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
-		 "%s.m2m", dev_name(&pdev->dev));
-
-	ret = v4l2_device_register(&pdev->dev, v4l2_dev);
-	if (ret)
-		goto err_m2m_r1;
+	fimc->v4l2_dev = v4l2_dev;
 
 	vfd = video_device_alloc();
 	if (!vfd) {
 		v4l2_err(v4l2_dev, "Failed to allocate video device\n");
-		goto err_m2m_r1;
+		return -ENOMEM;
 	}
 
 	vfd->fops	= &fimc_m2m_fops;
@@ -1527,42 +1519,35 @@ int fimc_register_m2m_device(struct fimc_dev *fimc)
 	vfd->release	= video_device_release;
 	vfd->lock	= &fimc->lock;
 
-	snprintf(vfd->name, sizeof(vfd->name), "%s:m2m", dev_name(&pdev->dev));
-
+	snprintf(vfd->name, sizeof(vfd->name), "%s.m2m", dev_name(&pdev->dev));
 	video_set_drvdata(vfd, fimc);
-	platform_set_drvdata(pdev, fimc);
 
 	fimc->m2m.vfd = vfd;
 	fimc->m2m.m2m_dev = v4l2_m2m_init(&m2m_ops);
 	if (IS_ERR(fimc->m2m.m2m_dev)) {
 		v4l2_err(v4l2_dev, "failed to initialize v4l2-m2m device\n");
 		ret = PTR_ERR(fimc->m2m.m2m_dev);
-		goto err_m2m_r2;
+		goto err_init;
 	}
 
 	ret = media_entity_init(&vfd->entity, 0, NULL, 0);
 	if (ret)
-		goto err_m2m_r3;
+		goto err_me;
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret) {
-		v4l2_err(v4l2_dev,
-			 "%s(): failed to register video device\n", __func__);
-		goto err_m2m_r4;
+		v4l2_err(vfd, "Failed to register video device\n");
+		goto err_vd;
 	}
-	v4l2_info(v4l2_dev,
-		  "FIMC m2m driver registered as /dev/video%d\n", vfd->num);
-
+	v4l2_info(vfd, "FIMC m2m driver registered as /dev/video%d\n", vfd->num);
 	return 0;
-err_m2m_r4:
+
+err_vd:
 	media_entity_cleanup(&vfd->entity);
-err_m2m_r3:
+err_me:
 	v4l2_m2m_release(fimc->m2m.m2m_dev);
-err_m2m_r2:
+err_init:
 	video_device_release(fimc->m2m.vfd);
-err_m2m_r1:
-	v4l2_device_unregister(v4l2_dev);
-
 	return ret;
 }
 
@@ -1573,7 +1558,6 @@ void fimc_unregister_m2m_device(struct fimc_dev *fimc)
 
 	if (fimc->m2m.m2m_dev)
 		v4l2_m2m_release(fimc->m2m.m2m_dev);
-	v4l2_device_unregister(&fimc->m2m.v4l2_dev);
 	if (fimc->m2m.vfd) {
 		media_entity_cleanup(&fimc->m2m.vfd->entity);
 		video_unregister_device(fimc->m2m.vfd);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 210301e..fe82bf7 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -281,14 +281,12 @@ struct fimc_frame {
 /**
  * struct fimc_m2m_device - v4l2 memory-to-memory device data
  * @vfd: the video device node for v4l2 m2m mode
- * @v4l2_dev: v4l2 device for m2m mode
  * @m2m_dev: v4l2 memory-to-memory device data
  * @ctx: hardware context data
  * @refcnt: the reference counter
  */
 struct fimc_m2m_device {
 	struct video_device	*vfd;
-	struct v4l2_device	v4l2_dev;
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct fimc_ctx		*ctx;
 	int			refcnt;
@@ -298,7 +296,6 @@ struct fimc_m2m_device {
  * struct fimc_vid_cap - camera capture device information
  * @ctx: hardware context data
  * @vfd: video device node for camera capture mode
- * @v4l2_dev: v4l2_device struct to manage subdevs
  * @sd: pointer to camera sensor subdevice currently in use
  * @vd_pad: fimc video capture node pad
  * @fmt: Media Bus format configured at selected image sensor
@@ -316,7 +313,6 @@ struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		*vfd;
-	struct v4l2_device		v4l2_dev;
 	struct v4l2_subdev		*sd;;
 	struct media_pad		vd_pad;
 	struct v4l2_mbus_framefmt	fmt;
@@ -407,6 +403,7 @@ struct fimc_ctx;
  * @regs_res:	the resource claimed for IO registers
  * @irq:	FIMC interrupt number
  * @irq_queue:	interrupt handler waitqueue
+ * @v4l2_dev:	root v4l2_device
  * @m2m:	memory-to-memory V4L2 device information
  * @vid_cap:	camera capture device information
  * @state:	flags used to synchronize m2m and capture mode operation
@@ -425,6 +422,7 @@ struct fimc_dev {
 	struct resource			*regs_res;
 	int				irq;
 	wait_queue_head_t		irq_queue;
+	struct v4l2_device		*v4l2_dev;
 	struct fimc_m2m_device		m2m;
 	struct fimc_vid_cap		vid_cap;
 	unsigned long			state;
@@ -569,7 +567,7 @@ static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE == type) {
 		frame = &ctx->d_frame;
 	} else {
-		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
+		v4l2_err(ctx->fimc_dev->v4l2_dev,
 			"Wrong buffer/video queue type (%d)\n", type);
 		return ERR_PTR(-EINVAL);
 	}
@@ -644,11 +642,14 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx);
 int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
 int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr);
-int fimc_register_m2m_device(struct fimc_dev *fimc);
+int fimc_register_m2m_device(struct fimc_dev *fimc,
+			     struct v4l2_device *v4l2_dev);
+void fimc_unregister_m2m_device(struct fimc_dev *fimc);
 
 /* -----------------------------------------------------*/
 /* fimc-capture.c					*/
-int fimc_register_capture_device(struct fimc_dev *fimc);
+int fimc_register_capture_device(struct fimc_dev *fimc,
+				 struct v4l2_device *v4l2_dev);
 void fimc_unregister_capture_device(struct fimc_dev *fimc);
 int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
 			     struct fimc_vid_buffer *fimc_vb);
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 938dadf..c688263 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -596,7 +596,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 		}
 
 		if (i == ARRAY_SIZE(pix_desc)) {
-			v4l2_err(&fimc->vid_cap.v4l2_dev,
+			v4l2_err(fimc->vid_cap.vfd,
 				 "Camera color format not supported: %d\n",
 				 fimc->vid_cap.fmt.code);
 			return -EINVAL;
@@ -661,8 +661,9 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 		if (vid_cap->fmt.code == V4L2_MBUS_FMT_VYUY8_2X8) {
 			tmp = S5P_CSIIMGFMT_YCBCR422_8BIT;
 		} else {
-			err("camera image format not supported: %d",
-			    vid_cap->fmt.code);
+			v4l2_err(fimc->vid_cap.vfd,
+				 "Not supported camera pixel format: %d",
+				 vid_cap->fmt.code);
 			return -EINVAL;
 		}
 		tmp |= (cam->csi_data_align == 32) << 8;
-- 
1.7.5.4

