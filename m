Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:60943 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362Ab2KWNej (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:34:39 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH 10/15] [media] marvell-ccic: split mcam core into 2 parts for soc_camera support
Date: Fri, 23 Nov 2012 21:34:12 +0800
Message-Id: <1353677652-24288-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch splits mcam core into 2 parts to prepare for soc_camera support.

The first part remains in mcam-core. This part includes the HW operations
and vb2 callback functions.

The second part is moved to mcam-core-standard.c. This part is relevant with
the implementation of using v4l2.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/marvell-ccic/Makefile       |    4 +-
 .../platform/marvell-ccic/mcam-core-standard.c     |  767 +++++++++++++++++
 .../platform/marvell-ccic/mcam-core-standard.h     |   28 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |  873 +-------------------
 drivers/media/platform/marvell-ccic/mcam-core.h    |   45 +
 5 files changed, 883 insertions(+), 834 deletions(-)
 create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-standard.c
 create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-standard.h

diff --git a/drivers/media/platform/marvell-ccic/Makefile b/drivers/media/platform/marvell-ccic/Makefile
index 05a792c..595ebdf 100755
--- a/drivers/media/platform/marvell-ccic/Makefile
+++ b/drivers/media/platform/marvell-ccic/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
 cafe_ccic-y := cafe-driver.o mcam-core.o
 
-obj-$(CONFIG_VIDEO_MMP_CAMERA) += mmp_camera.o
-mmp_camera-y := mmp-driver.o mcam-core.o
+obj-$(CONFIG_VIDEO_MMP_CAMERA) += mmp_camera_standard.o
+mmp_camera_standard-y := mmp-driver.o mcam-core.o mcam-core-standard.o
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core-standard.c b/drivers/media/platform/marvell-ccic/mcam-core-standard.c
new file mode 100644
index 0000000..bff9ed0
--- /dev/null
+++ b/drivers/media/platform/marvell-ccic/mcam-core-standard.c
@@ -0,0 +1,767 @@
+/*
+ * The Marvell camera core.	 This device appears in a number of settings,
+ * so it needs platform-specific support outside of the core.
+ *
+ * Copyright 2011 Jonathan Corbet corbet@lwn.net
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+#include <linux/io.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/ov7670.h>
+#include <media/videobuf2-vmalloc.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include "mcam-core.h"
+#include "mcam-core-standard.h"
+
+static const enum v4l2_mbus_pixelcode mcam_def_mbus_code =
+					V4L2_MBUS_FMT_YUYV8_2X8;
+
+static struct mcam_format_struct {
+	__u8 *desc;
+	__u32 pixelformat;
+	int bpp;   /* Bytes per pixel */
+	enum v4l2_mbus_pixelcode mbus_code;
+} mcam_formats[] = {
+	{
+		.desc		= "YUYV 4:2:2",
+		.pixelformat	= V4L2_PIX_FMT_YUYV,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "UYVY 4:2:2",
+		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "YUV 4:2:2 PLANAR",
+		.pixelformat	= V4L2_PIX_FMT_YUV422P,
+		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "YUV 4:2:0 PLANAR",
+		.pixelformat	= V4L2_PIX_FMT_YUV420,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_1_5X8,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "YVU 4:2:0 PLANAR",
+		.pixelformat	= V4L2_PIX_FMT_YVU420,
+		.mbus_code	= V4L2_MBUS_FMT_YVYU8_1_5X8,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "RGB 444",
+		.pixelformat	= V4L2_PIX_FMT_RGB444,
+		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "RGB 565",
+		.pixelformat	= V4L2_PIX_FMT_RGB565,
+		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "Raw RGB Bayer",
+		.pixelformat	= V4L2_PIX_FMT_SBGGR8,
+		.mbus_code	= V4L2_MBUS_FMT_SBGGR8_1X8,
+		.bpp		= 1
+	},
+};
+#define N_MCAM_FMTS ARRAY_SIZE(mcam_formats)
+
+/*
+ * The default format we use until somebody says otherwise.
+ */
+static const struct v4l2_pix_format mcam_def_pix_format = {
+	.width		= VGA_WIDTH,
+	.height		= VGA_HEIGHT,
+	.pixelformat	= V4L2_PIX_FMT_YUYV,
+	.field		= V4L2_FIELD_NONE,
+	.bytesperline	= VGA_WIDTH*2,
+	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
+};
+
+static struct mcam_format_struct *mcam_find_format(u32 pixelformat)
+{
+	unsigned i;
+
+	for (i = 0; i < N_MCAM_FMTS; i++)
+		if (mcam_formats[i].pixelformat == pixelformat)
+			return mcam_formats + i;
+	/* Not found? Then return the first format. */
+	return mcam_formats;
+}
+
+static int mcam_setup_vb2(struct mcam_camera *cam)
+{
+	struct vb2_queue *vq = &cam->vb_queue;
+
+	memset(vq, 0, sizeof(*vq));
+	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->drv_priv = cam;
+	INIT_LIST_HEAD(&cam->buffers);
+	switch (cam->buffer_mode) {
+	case B_DMA_contig:
+#ifdef MCAM_MODE_DMA_CONTIG
+		vq->ops = &mcam_vb2_ops;
+		vq->mem_ops = &vb2_dma_contig_memops;
+		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
+		vq->io_modes = VB2_MMAP | VB2_USERPTR;
+		cam->dma_setup = mcam_ctlr_dma_contig;
+		cam->frame_complete = mcam_dma_contig_done;
+#endif
+		break;
+	case B_DMA_sg:
+#ifdef MCAM_MODE_DMA_SG
+		vq->ops = &mcam_vb2_sg_ops;
+		vq->mem_ops = &vb2_dma_sg_memops;
+		vq->io_modes = VB2_MMAP | VB2_USERPTR;
+		cam->dma_setup = mcam_ctlr_dma_sg;
+		cam->frame_complete = mcam_dma_sg_done;
+#endif
+		break;
+	case B_vmalloc:
+#ifdef MCAM_MODE_VMALLOC
+		tasklet_init(&cam->s_tasklet, mcam_frame_tasklet,
+				(unsigned long) cam);
+		vq->ops = &mcam_vb2_ops;
+		vq->mem_ops = &vb2_vmalloc_memops;
+		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
+		vq->io_modes = VB2_MMAP;
+		cam->dma_setup = mcam_ctlr_dma_vmalloc;
+		cam->frame_complete = mcam_vmalloc_done;
+#endif
+		break;
+	}
+	return vb2_queue_init(vq);
+}
+
+static void mcam_cleanup_vb2(struct mcam_camera *cam)
+{
+	vb2_queue_release(&cam->vb_queue);
+#ifdef MCAM_MODE_DMA_CONTIG
+	if (cam->buffer_mode == B_DMA_contig)
+		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
+#endif
+}
+
+/* ---------------------------------------------------------------------- */
+/*
+ * The long list of V4L2 ioctl() operations.
+ */
+static int mcam_vidioc_streamon(struct file *filp, void *priv,
+		enum v4l2_buf_type type)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_streamon(&cam->vb_queue, type);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_streamoff(struct file *filp, void *priv,
+		enum v4l2_buf_type type)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_streamoff(&cam->vb_queue, type);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
+		struct v4l2_requestbuffers *req)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_reqbufs(&cam->vb_queue, req);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_querybuf(struct file *filp, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_querybuf(&cam->vb_queue, buf);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_qbuf(struct file *filp, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_qbuf(&cam->vb_queue, buf);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_dqbuf(&cam->vb_queue, buf, filp->f_flags & O_NONBLOCK);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_queryctrl(struct file *filp, void *priv,
+		struct v4l2_queryctrl *qc)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, core, queryctrl, qc);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_g_ctrl(struct file *filp, void *priv,
+		struct v4l2_control *ctrl)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, core, g_ctrl, ctrl);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_s_ctrl(struct file *filp, void *priv,
+		struct v4l2_control *ctrl)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, core, s_ctrl, ctrl);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_querycap(struct file *file, void *priv,
+		struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, "marvell_ccic");
+	strcpy(cap->card, "marvell_ccic");
+	cap->version = 1;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	return 0;
+}
+
+static int mcam_vidioc_enum_fmt_vid_cap(struct file *filp,
+		void *priv, struct v4l2_fmtdesc *fmt)
+{
+	if (fmt->index >= N_MCAM_FMTS)
+		return -EINVAL;
+	strlcpy(fmt->description, mcam_formats[fmt->index].desc,
+			sizeof(fmt->description));
+	fmt->pixelformat = mcam_formats[fmt->index].pixelformat;
+	return 0;
+}
+
+static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
+		struct v4l2_format *fmt)
+{
+	struct mcam_camera *cam = priv;
+	struct mcam_format_struct *f;
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+	struct v4l2_mbus_framefmt mbus_fmt;
+	int ret;
+
+	f = mcam_find_format(pix->pixelformat);
+	pix->pixelformat = f->pixelformat;
+	v4l2_fill_mbus_format(&mbus_fmt, pix, f->mbus_code);
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
+	mutex_unlock(&cam->s_mutex);
+	v4l2_fill_pix_format(pix, &mbus_fmt);
+	pix->bytesperline = pix->width * f->bpp;
+	pix->sizeimage = pix->height * pix->bytesperline;
+	return ret;
+}
+
+static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
+		struct v4l2_format *fmt)
+{
+	struct mcam_camera *cam = priv;
+	struct mcam_format_struct *f;
+	int ret;
+
+	/*
+	 * Can't do anything if the device is not idle
+	 * Also can't if there are streaming buffers in place.
+	 */
+	if (cam->state != S_IDLE || cam->vb_queue.num_buffers > 0)
+		return -EBUSY;
+
+	f = mcam_find_format(fmt->fmt.pix.pixelformat);
+
+	/*
+	 * See if the formatting works in principle.
+	 */
+	ret = mcam_vidioc_try_fmt_vid_cap(filp, priv, fmt);
+	if (ret)
+		return ret;
+	/*
+	 * Now we start to change things for real, so let's do it
+	 * under lock.
+	 */
+	mutex_lock(&cam->s_mutex);
+	cam->pix_format = fmt->fmt.pix;
+	cam->mbus_code = f->mbus_code;
+
+	/*
+	 * Make sure we have appropriate DMA buffers.
+	 */
+	if (cam->buffer_mode == B_vmalloc) {
+		ret = mcam_check_dma_buffers(cam);
+		if (ret)
+			goto out;
+	}
+	mcam_set_config_needed(cam, 1);
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+/*
+ * Return our stored notion of how the camera is/should be configured.
+ * The V4l2 spec wants us to be smarter, and actually get this from
+ * the camera (and not mess with it at open time).	Someday.
+ */
+static int mcam_vidioc_g_fmt_vid_cap(struct file *filp, void *priv,
+		struct v4l2_format *f)
+{
+	struct mcam_camera *cam = priv;
+
+	f->fmt.pix = cam->pix_format;
+	return 0;
+}
+
+/*
+ * We only have one input - the sensor - so minimize the nonsense here.
+ */
+static int mcam_vidioc_enum_input(struct file *filp, void *priv,
+		struct v4l2_input *input)
+{
+	if (input->index != 0)
+		return -EINVAL;
+
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+	input->std = V4L2_STD_ALL; /* Not sure what should go here */
+	strcpy(input->name, "Camera");
+	return 0;
+}
+
+static int mcam_vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
+{
+	if (i != 0)
+		return -EINVAL;
+	return 0;
+}
+
+/* from vivi.c */
+static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id *a)
+{
+	return 0;
+}
+
+/*
+ * G/S_PARM.  Most of this is done by the sensor, but we are
+ * the level which controls the number of read buffers.
+ */
+static int mcam_vidioc_g_parm(struct file *filp, void *priv,
+		struct v4l2_streamparm *parms)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, g_parm, parms);
+	mutex_unlock(&cam->s_mutex);
+	parms->parm.capture.readbuffers = n_dma_bufs;
+	return ret;
+}
+
+static int mcam_vidioc_s_parm(struct file *filp, void *priv,
+		struct v4l2_streamparm *parms)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, s_parm, parms);
+	mutex_unlock(&cam->s_mutex);
+	parms->parm.capture.readbuffers = n_dma_bufs;
+	return ret;
+}
+
+static int mcam_vidioc_g_chip_ident(struct file *file, void *priv,
+		struct v4l2_dbg_chip_ident *chip)
+{
+	struct mcam_camera *cam = priv;
+
+	chip->ident = V4L2_IDENT_NONE;
+	chip->revision = 0;
+	if (v4l2_chip_match_host(&chip->match)) {
+		chip->ident = cam->chip_id;
+		return 0;
+	}
+	return sensor_call(cam, core, g_chip_ident, chip);
+}
+
+static int mcam_vidioc_enum_framesizes(struct file *filp, void *priv,
+		struct v4l2_frmsizeenum *sizes)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, enum_framesizes, sizes);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_enum_frameintervals(struct file *filp, void *priv,
+		struct v4l2_frmivalenum *interval)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, enum_frameintervals, interval);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int mcam_vidioc_g_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg)
+{
+	struct mcam_camera *cam = priv;
+
+	if (v4l2_chip_match_host(&reg->match)) {
+		reg->val = mcam_reg_read(cam, reg->reg);
+		reg->size = 4;
+		return 0;
+	}
+	return sensor_call(cam, core, g_register, reg);
+}
+
+static int mcam_vidioc_s_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg)
+{
+	struct mcam_camera *cam = priv;
+
+	if (v4l2_chip_match_host(&reg->match)) {
+		mcam_reg_write(cam, reg->reg, reg->val);
+		return 0;
+	}
+	return sensor_call(cam, core, s_register, reg);
+}
+#endif
+
+static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
+	.vidioc_querycap	= mcam_vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = mcam_vidioc_enum_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	= mcam_vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	= mcam_vidioc_s_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	= mcam_vidioc_g_fmt_vid_cap,
+	.vidioc_enum_input	= mcam_vidioc_enum_input,
+	.vidioc_g_input		= mcam_vidioc_g_input,
+	.vidioc_s_input		= mcam_vidioc_s_input,
+	.vidioc_s_std		= mcam_vidioc_s_std,
+	.vidioc_reqbufs		= mcam_vidioc_reqbufs,
+	.vidioc_querybuf	= mcam_vidioc_querybuf,
+	.vidioc_qbuf		= mcam_vidioc_qbuf,
+	.vidioc_dqbuf		= mcam_vidioc_dqbuf,
+	.vidioc_streamon	= mcam_vidioc_streamon,
+	.vidioc_streamoff	= mcam_vidioc_streamoff,
+	.vidioc_queryctrl	= mcam_vidioc_queryctrl,
+	.vidioc_g_ctrl		= mcam_vidioc_g_ctrl,
+	.vidioc_s_ctrl		= mcam_vidioc_s_ctrl,
+	.vidioc_g_parm		= mcam_vidioc_g_parm,
+	.vidioc_s_parm		= mcam_vidioc_s_parm,
+	.vidioc_enum_framesizes = mcam_vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals = mcam_vidioc_enum_frameintervals,
+	.vidioc_g_chip_ident	= mcam_vidioc_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register	= mcam_vidioc_g_register,
+	.vidioc_s_register	= mcam_vidioc_s_register,
+#endif
+};
+
+/* ---------------------------------------------------------------------- */
+/*
+ * Our various file operations.
+ */
+static int mcam_v4l_open(struct file *filp)
+{
+	struct mcam_camera *cam = video_drvdata(filp);
+	int ret = 0;
+
+	filp->private_data = cam;
+
+	cam->frame_state.frames = 0;
+	cam->frame_state.singles = 0;
+	cam->frame_state.delivered = 0;
+	mutex_lock(&cam->s_mutex);
+	if (cam->users == 0) {
+		ret = mcam_setup_vb2(cam);
+		if (ret)
+			goto out;
+		mcam_ctlr_power_up(cam);
+		__mcam_cam_reset(cam);
+		mcam_set_config_needed(cam, 1);
+	}
+	(cam->users)++;
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_v4l_release(struct file *filp)
+{
+	struct mcam_camera *cam = filp->private_data;
+
+	cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n",
+			cam->frame_state.frames, cam->frame_state.singles,
+			cam->frame_state.delivered);
+	mutex_lock(&cam->s_mutex);
+	(cam->users)--;
+	if (cam->users == 0) {
+		mcam_ctlr_stop_dma(cam);
+		mcam_cleanup_vb2(cam);
+		mcam_config_mipi(cam, 0);
+		mcam_ctlr_power_down(cam);
+		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
+			mcam_free_dma_bufs(cam);
+	}
+	mutex_unlock(&cam->s_mutex);
+	return 0;
+}
+
+static ssize_t mcam_v4l_read(struct file *filp,
+		char __user *buffer, size_t len, loff_t *pos)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_read(&cam->vb_queue, buffer, len, pos,
+			filp->f_flags & O_NONBLOCK);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static unsigned int mcam_v4l_poll(struct file *filp,
+		struct poll_table_struct *pt)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_poll(&cam->vb_queue, filp, pt);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = vb2_mmap(&cam->vb_queue, vma);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static const struct v4l2_file_operations mcam_v4l_fops = {
+	.owner = THIS_MODULE,
+	.open = mcam_v4l_open,
+	.release = mcam_v4l_release,
+	.read = mcam_v4l_read,
+	.poll = mcam_v4l_poll,
+	.mmap = mcam_v4l_mmap,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+/*
+ * This template device holds all of those v4l2 methods; we
+ * clone it for specific real devices.
+ */
+static struct video_device mcam_v4l_template = {
+	.name = "mcam",
+	.tvnorms = V4L2_STD_NTSC_M,
+	.current_norm = V4L2_STD_NTSC_M,  /* make mplayer happy */
+
+	.fops = &mcam_v4l_fops,
+	.ioctl_ops = &mcam_v4l_ioctl_ops,
+	.release = video_device_release_empty,
+};
+
+/* ---------------------------------------------------------------------- */
+/*
+ * Registration and such.
+ */
+static struct ov7670_config sensor_cfg = {
+	/*
+	 * Exclude QCIF mode, because it only captures a tiny portion
+	 * of the sensor FOV
+	 */
+	.min_width = 320,
+	.min_height = 240,
+};
+
+int mccic_register(struct mcam_camera *cam)
+{
+	struct i2c_board_info ov7670_info = {
+		.type = "ov7670",
+		.addr = 0x42 >> 1,
+		.platform_data = &sensor_cfg,
+	};
+	int ret;
+
+	/*
+	 * Validate the requested buffer mode.
+	 */
+	if (buffer_mode >= 0)
+		cam->buffer_mode = buffer_mode;
+	if (cam->buffer_mode == B_DMA_sg &&
+			cam->chip_id == V4L2_IDENT_CAFE) {
+		cam_err(cam, "marvell-cam: Cafe can't do S/G I/O," \
+			"attempting vmalloc mode instead\n");
+		cam->buffer_mode = B_vmalloc;
+	}
+	if (!mcam_buffer_mode_supported(cam->buffer_mode)) {
+		cam_err(cam, "marvell-cam: buffer mode %d unsupported\n",
+				cam->buffer_mode);
+		return -EINVAL;
+	}
+	/*
+	 * Register with V4L
+	 */
+	ret = v4l2_device_register(cam->dev, &cam->v4l2_dev);
+	if (ret)
+		return ret;
+
+	mutex_init(&cam->s_mutex);
+	cam->state = S_NOTREADY;
+	mcam_set_config_needed(cam, 1);
+	cam->pix_format = mcam_def_pix_format;
+	cam->mbus_code = mcam_def_mbus_code;
+	INIT_LIST_HEAD(&cam->buffers);
+	mcam_ctlr_init(cam);
+
+	/*
+	 * Try to find the sensor.
+	 */
+	sensor_cfg.clock_speed = cam->clock_speed;
+	sensor_cfg.use_smbus = cam->use_smbus;
+	cam->sensor_addr = ov7670_info.addr;
+	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
+			cam->i2c_adapter, &ov7670_info, NULL);
+	if (cam->sensor == NULL) {
+		ret = -ENODEV;
+		goto out_unregister;
+	}
+
+	ret = mcam_cam_init(cam);
+	if (ret)
+		goto out_unregister;
+	/*
+	 * Get the v4l2 setup done.
+	 */
+	mutex_lock(&cam->s_mutex);
+	cam->vdev = mcam_v4l_template;
+	cam->vdev.debug = 0;
+	cam->vdev.v4l2_dev = &cam->v4l2_dev;
+	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto out;
+	video_set_drvdata(&cam->vdev, cam);
+
+	/*
+	 * If so requested, try to get our DMA buffers now.
+	 */
+	if (cam->buffer_mode == B_vmalloc && !alloc_bufs_at_read) {
+		if (mcam_alloc_dma_bufs(cam, 1))
+			cam_warn(cam, "Unable to alloc DMA buffers at load" \
+					"will try again later\n");
+	}
+
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+out_unregister:
+	v4l2_device_unregister(&cam->v4l2_dev);
+	return ret;
+}
+
+void mccic_shutdown(struct mcam_camera *cam)
+{
+	/*
+	 * If we have no users (and we really, really should have no
+	 * users) the device will already be powered down.  Trying to
+	 * take it down again will wedge the machine, which is frowned
+	 * upon.
+	 */
+	if (cam->users > 0) {
+		cam_warn(cam, "Removing a device with users!\n");
+		mcam_ctlr_power_down(cam);
+	}
+	vb2_queue_release(&cam->vb_queue);
+	if (cam->buffer_mode == B_vmalloc)
+		mcam_free_dma_bufs(cam);
+	video_unregister_device(&cam->vdev);
+	v4l2_device_unregister(&cam->v4l2_dev);
+}
diff --git a/drivers/media/platform/marvell-ccic/mcam-core-standard.h b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
new file mode 100644
index 0000000..148a1a1
--- /dev/null
+++ b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
@@ -0,0 +1,28 @@
+/*
+ * Marvell camera core structures.
+ *
+ * Copyright 2011 Jonathan Corbet corbet@lwn.net
+ */
+extern bool alloc_bufs_at_read;
+extern int n_dma_bufs;
+extern int buffer_mode;
+extern const struct vb2_ops mcam_vb2_sg_ops;
+extern const struct vb2_ops mcam_vb2_ops;
+
+extern void mcam_ctlr_stop_dma(struct mcam_camera *cam);
+extern int mcam_config_mipi(struct mcam_camera *mcam, int enable);
+extern void mcam_ctlr_power_up(struct mcam_camera *cam);
+extern void mcam_ctlr_power_down(struct mcam_camera *cam);
+extern void mcam_ctlr_init(struct mcam_camera *cam);
+extern int mcam_cam_init(struct mcam_camera *cam);
+extern void mcam_free_dma_bufs(struct mcam_camera *cam);
+extern void mcam_ctlr_dma_sg(struct mcam_camera *cam);
+extern void mcam_dma_sg_done(struct mcam_camera *cam, int frame);
+extern int mcam_check_dma_buffers(struct mcam_camera *cam);
+extern void mcam_set_config_needed(struct mcam_camera *cam, int needed);
+extern int __mcam_cam_reset(struct mcam_camera *cam);
+extern int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime);
+extern void mcam_ctlr_dma_contig(struct mcam_camera *cam);
+extern void mcam_dma_contig_done(struct mcam_camera *cam, int frame);
+extern void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam);
+extern void mcam_vmalloc_done(struct mcam_camera *cam, int frame);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 9a935a2..189463c 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -44,7 +44,7 @@
  * sense.
  */
 
-static bool alloc_bufs_at_read;
+bool alloc_bufs_at_read;
 module_param(alloc_bufs_at_read, bool, 0444);
 MODULE_PARM_DESC(alloc_bufs_at_read,
 		"Non-zero value causes DMA buffers to be allocated when the "
@@ -53,21 +53,21 @@ MODULE_PARM_DESC(alloc_bufs_at_read,
 		"successfully getting those buffers.  This parameter is "
 		"only used in the vmalloc buffer mode");
 
-static int n_dma_bufs = 3;
+unsigned int n_dma_bufs = 3;
 module_param(n_dma_bufs, uint, 0644);
 MODULE_PARM_DESC(n_dma_bufs,
 		"The number of DMA buffers to allocate.  Can be either two "
 		"(saves memory, makes timing tighter) or three.");
 
-static int dma_buf_size = VGA_WIDTH * VGA_HEIGHT * 2;  /* Worst case */
+static unsigned int dma_buf_size = VGA_WIDTH * VGA_HEIGHT * 2;  /* Worst case */
 module_param(dma_buf_size, uint, 0444);
 MODULE_PARM_DESC(dma_buf_size,
 		"The size of the allocated DMA buffers.  If actual operating "
 		"parameters require larger buffers, an attempt to reallocate "
 		"will be made.");
 #else /* MCAM_MODE_VMALLOC */
-static const bool alloc_bufs_at_read = 0;
-static const int n_dma_bufs = 3;  /* Used by S/G_PARM */
+const bool alloc_bufs_at_read;
+const unsigned int n_dma_bufs = 3;  /* Used by S/G_PARM */
 #endif /* MCAM_MODE_VMALLOC */
 
 static bool flip;
@@ -76,7 +76,7 @@ MODULE_PARM_DESC(flip,
 		"If set, the sensor will be instructed to flip the image "
 		"vertically.");
 
-static int buffer_mode = -1;
+int buffer_mode = -1;
 module_param(buffer_mode, int, 0444);
 MODULE_PARM_DESC(buffer_mode,
 		"Set the buffer mode to be used; default is to go with what "
@@ -97,125 +97,6 @@ MODULE_PARM_DESC(buffer_mode,
 #define CF_FRAME_SOF1	 8
 #define CF_FRAME_SOF2	 9
 
-#define sensor_call(cam, o, f, args...) \
-	v4l2_subdev_call(cam->sensor, o, f, ##args)
-
-static struct mcam_format_struct {
-	__u8 *desc;
-	__u32 pixelformat;
-	int bpp;   /* Bytes per pixel */
-	enum v4l2_mbus_pixelcode mbus_code;
-} mcam_formats[] = {
-	{
-		.desc		= "YUYV 4:2:2",
-		.pixelformat	= V4L2_PIX_FMT_YUYV,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "UYVY 4:2:2",
-		.pixelformat	= V4L2_PIX_FMT_UYVY,
-		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "YUV 4:2:2 PLANAR",
-		.pixelformat	= V4L2_PIX_FMT_YUV422P,
-		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "YUV 4:2:0 PLANAR",
-		.pixelformat	= V4L2_PIX_FMT_YUV420,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_1_5X8,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "YVU 4:2:0 PLANAR",
-		.pixelformat	= V4L2_PIX_FMT_YVU420,
-		.mbus_code	= V4L2_MBUS_FMT_YVYU8_1_5X8,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "RGB 444",
-		.pixelformat	= V4L2_PIX_FMT_RGB444,
-		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "RGB 565",
-		.pixelformat	= V4L2_PIX_FMT_RGB565,
-		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_LE,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "Raw RGB Bayer",
-		.pixelformat	= V4L2_PIX_FMT_SBGGR8,
-		.mbus_code	= V4L2_MBUS_FMT_SBGGR8_1X8,
-		.bpp		= 1
-	},
-};
-#define N_MCAM_FMTS ARRAY_SIZE(mcam_formats)
-
-static struct mcam_format_struct *mcam_find_format(u32 pixelformat)
-{
-	unsigned i;
-
-	for (i = 0; i < N_MCAM_FMTS; i++)
-		if (mcam_formats[i].pixelformat == pixelformat)
-			return mcam_formats + i;
-	/* Not found? Then return the first format. */
-	return mcam_formats;
-}
-
-/*
- * The default format we use until somebody says otherwise.
- */
-static const struct v4l2_pix_format mcam_def_pix_format = {
-	.width		= VGA_WIDTH,
-	.height		= VGA_HEIGHT,
-	.pixelformat	= V4L2_PIX_FMT_YUYV,
-	.field		= V4L2_FIELD_NONE,
-	.bytesperline	= VGA_WIDTH*2,
-	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
-};
-
-static const enum v4l2_mbus_pixelcode mcam_def_mbus_code =
-					V4L2_MBUS_FMT_YUYV8_2X8;
-
-
-/*
- * The two-word DMA descriptor format used by the Armada 610 and like.  There
- * Is a three-word format as well (set C1_DESC_3WORD) where the third
- * word is a pointer to the next descriptor, but we don't use it.  Two-word
- * descriptors have to be contiguous in memory.
- */
-struct mcam_dma_desc {
-	u32 dma_addr;
-	u32 segment_len;
-};
-
-struct yuv_pointer_t {
-	dma_addr_t y;
-	dma_addr_t u;
-	dma_addr_t v;
-};
-
-/*
- * Our buffer type for working with videobuf2.  Note that the vb2
- * developers have decreed that struct vb2_buffer must be at the
- * beginning of this structure.
- */
-struct mcam_vb_buffer {
-	struct vb2_buffer vb_buf;
-	struct list_head queue;
-	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
-	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
-	int dma_desc_nent;		/* Number of mapped descriptors */
-	struct yuv_pointer_t yuv_p;
-	int list_init_flag;
-};
-
 static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
 {
 	return container_of(vb, struct mcam_vb_buffer, vb_buf);
@@ -233,19 +114,6 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
 	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
 }
 
-
-
-/*
- * Debugging and related.
- */
-#define cam_err(cam, fmt, arg...) \
-	dev_err((cam)->dev, fmt, ##arg);
-#define cam_warn(cam, fmt, arg...) \
-	dev_warn((cam)->dev, fmt, ##arg);
-#define cam_dbg(cam, fmt, arg...) \
-	dev_dbg((cam)->dev, fmt, ##arg);
-
-
 /*
  * Flag manipulation helpers
  */
@@ -265,7 +133,7 @@ static inline int mcam_needs_config(struct mcam_camera *cam)
 	return test_bit(CF_CONFIG_NEEDED, &cam->flags);
 }
 
-static void mcam_set_config_needed(struct mcam_camera *cam, int needed)
+void mcam_set_config_needed(struct mcam_camera *cam, int needed)
 {
 	if (needed)
 		set_bit(CF_CONFIG_NEEDED, &cam->flags);
@@ -285,12 +153,12 @@ static void mcam_ctlr_start(struct mcam_camera *cam)
 	mcam_reg_set_bit(cam, REG_CTRL0, C0_ENABLE);
 }
 
-static void mcam_ctlr_stop(struct mcam_camera *cam)
+void mcam_ctlr_stop(struct mcam_camera *cam)
 {
 	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
 }
 
-static int mcam_config_mipi(struct mcam_camera *mcam, int enable)
+int mcam_config_mipi(struct mcam_camera *mcam, int enable)
 {
 	if (mcam->bus_type == V4L2_MBUS_CSI2_LANES && enable) {
 		/* Using MIPI mode and enable MIPI */
@@ -340,7 +208,7 @@ static int mcam_config_mipi(struct mcam_camera *mcam, int enable)
 /*
  * Allocate in-kernel DMA buffers for vmalloc mode.
  */
-static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
+int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 {
 	int i;
 
@@ -381,7 +249,7 @@ static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 	return 0;
 }
 
-static void mcam_free_dma_bufs(struct mcam_camera *cam)
+void mcam_free_dma_bufs(struct mcam_camera *cam)
 {
 	int i;
 
@@ -397,7 +265,7 @@ static void mcam_free_dma_bufs(struct mcam_camera *cam)
 /*
  * Set up DMA buffers when operating in vmalloc mode
  */
-static void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
+void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
 {
 	/*
 	 * Store the first two Y buffers (we aren't supporting
@@ -461,7 +329,7 @@ static void mcam_frame_tasklet(unsigned long data)
 /*
  * Make sure our allocated buffers are up to the task.
  */
-static int mcam_check_dma_buffers(struct mcam_camera *cam)
+int mcam_check_dma_buffers(struct mcam_camera *cam)
 {
 	if (cam->nbufs > 0 && cam->dma_buf_size < cam->pix_format.sizeimage)
 			mcam_free_dma_bufs(cam);
@@ -470,24 +338,24 @@ static int mcam_check_dma_buffers(struct mcam_camera *cam)
 	return 0;
 }
 
-static void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
+void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
 {
 	tasklet_schedule(&cam->s_tasklet);
 }
 
 #else /* MCAM_MODE_VMALLOC */
 
-static inline int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
+inline int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 {
 	return 0;
 }
 
-static inline void mcam_free_dma_bufs(struct mcam_camera *cam)
+inline void mcam_free_dma_bufs(struct mcam_camera *cam)
 {
 	return;
 }
 
-static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
+inline int mcam_check_dma_buffers(struct mcam_camera *cam)
 {
 	return 0;
 }
@@ -557,7 +425,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 /*
  * Initial B_DMA_contig setup.
  */
-static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
+void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 {
 	mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
 	cam->nbufs = 2;
@@ -568,7 +436,7 @@ static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 /*
  * Frame completion handling.
  */
-static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
+void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
 
@@ -614,7 +482,7 @@ static void mcam_sg_next_buffer(struct mcam_camera *cam)
 /*
  * Initial B_DMA_sg setup
  */
-static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
+void mcam_ctlr_dma_sg(struct mcam_camera *cam)
 {
 	/*
 	 * The list-empty condition can hit us at resume time
@@ -644,7 +512,7 @@ static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
  * safely change the DMA descriptor array here and restart things
  * (assuming there's another buffer waiting to go).
  */
-static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
+void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf = cam->vb_bufs[0];
 
@@ -707,7 +575,7 @@ static inline void mcam_sg_restart(struct mcam_camera *cam)
 /*
  * Image format setup
  */
-static void mcam_ctlr_image(struct mcam_camera *cam)
+void mcam_ctlr_image(struct mcam_camera *cam)
 {
 	struct v4l2_pix_format *fmt = &cam->pix_format;
 	u32 widthy = 0, widthuv = 0, imgsz_h, imgsz_w;
@@ -838,7 +706,7 @@ static void mcam_ctlr_irq_disable(struct mcam_camera *cam)
 
 
 
-static void mcam_ctlr_init(struct mcam_camera *cam)
+void mcam_ctlr_init(struct mcam_camera *cam)
 {
 	unsigned long flags;
 
@@ -865,7 +733,7 @@ static void mcam_ctlr_init(struct mcam_camera *cam)
  * Stop the controller, and don't return until we're really sure that no
  * further DMA is going on.
  */
-static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
+void mcam_ctlr_stop_dma(struct mcam_camera *cam)
 {
 	unsigned long flags;
 
@@ -898,7 +766,7 @@ static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
 /*
  * Power up and down.
  */
-static void mcam_ctlr_power_up(struct mcam_camera *cam)
+void mcam_ctlr_power_up(struct mcam_camera *cam)
 {
 	unsigned long flags;
 
@@ -909,7 +777,7 @@ static void mcam_ctlr_power_up(struct mcam_camera *cam)
 	msleep(5); /* Just to be sure */
 }
 
-static void mcam_ctlr_power_down(struct mcam_camera *cam)
+void mcam_ctlr_power_down(struct mcam_camera *cam)
 {
 	unsigned long flags;
 
@@ -929,7 +797,7 @@ static void mcam_ctlr_power_down(struct mcam_camera *cam)
  * Communications with the sensor.
  */
 
-static int __mcam_cam_reset(struct mcam_camera *cam)
+int __mcam_cam_reset(struct mcam_camera *cam)
 {
 	return sensor_call(cam, core, reset, 0);
 }
@@ -938,7 +806,7 @@ static int __mcam_cam_reset(struct mcam_camera *cam)
  * We have found the sensor on the i2c.  Let's try to have a
  * conversation.
  */
-static int mcam_cam_init(struct mcam_camera *cam)
+int mcam_cam_init(struct mcam_camera *cam)
 {
 	struct v4l2_dbg_chip_ident chip;
 	int ret;
@@ -1226,7 +1094,7 @@ static int mcam_videobuf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static const struct vb2_ops mcam_vb2_ops = {
+const struct vb2_ops mcam_vb2_ops = {
 	.queue_setup		= mcam_vb_queue_setup,
 	.buf_queue		= mcam_vb_buf_queue,
 	.buf_cleanup		= mcam_videobuf_cleanup,
@@ -1300,7 +1168,7 @@ static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
 }
 
 
-static const struct vb2_ops mcam_vb2_sg_ops = {
+const struct vb2_ops mcam_vb2_sg_ops = {
 	.queue_setup		= mcam_vb_queue_setup,
 	.buf_init		= mcam_vb_sg_buf_init,
 	.buf_prepare		= mcam_vb_sg_buf_prepare,
@@ -1315,558 +1183,18 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 
 #endif /* MCAM_MODE_DMA_SG */
 
-static int mcam_setup_vb2(struct mcam_camera *cam)
-{
-	struct vb2_queue *vq = &cam->vb_queue;
-
-	memset(vq, 0, sizeof(*vq));
-	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	vq->drv_priv = cam;
-	INIT_LIST_HEAD(&cam->buffers);
-	switch (cam->buffer_mode) {
-	case B_DMA_contig:
-#ifdef MCAM_MODE_DMA_CONTIG
-		vq->ops = &mcam_vb2_ops;
-		vq->mem_ops = &vb2_dma_contig_memops;
-		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
-		vq->io_modes = VB2_MMAP | VB2_USERPTR;
-		cam->dma_setup = mcam_ctlr_dma_contig;
-		cam->frame_complete = mcam_dma_contig_done;
-#endif
-		break;
-	case B_DMA_sg:
-#ifdef MCAM_MODE_DMA_SG
-		vq->ops = &mcam_vb2_sg_ops;
-		vq->mem_ops = &vb2_dma_sg_memops;
-		vq->io_modes = VB2_MMAP | VB2_USERPTR;
-		cam->dma_setup = mcam_ctlr_dma_sg;
-		cam->frame_complete = mcam_dma_sg_done;
-#endif
-		break;
-	case B_vmalloc:
-#ifdef MCAM_MODE_VMALLOC
-		tasklet_init(&cam->s_tasklet, mcam_frame_tasklet,
-				(unsigned long) cam);
-		vq->ops = &mcam_vb2_ops;
-		vq->mem_ops = &vb2_vmalloc_memops;
-		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
-		vq->io_modes = VB2_MMAP;
-		cam->dma_setup = mcam_ctlr_dma_vmalloc;
-		cam->frame_complete = mcam_vmalloc_done;
-#endif
-		break;
-	}
-	return vb2_queue_init(vq);
-}
-
-static void mcam_cleanup_vb2(struct mcam_camera *cam)
-{
-	vb2_queue_release(&cam->vb_queue);
-#ifdef MCAM_MODE_DMA_CONTIG
-	if (cam->buffer_mode == B_DMA_contig)
-		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
-#endif
-}
-
-
-/* ---------------------------------------------------------------------- */
-/*
- * The long list of V4L2 ioctl() operations.
- */
-
-static int mcam_vidioc_streamon(struct file *filp, void *priv,
-		enum v4l2_buf_type type)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_streamon(&cam->vb_queue, type);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_streamoff(struct file *filp, void *priv,
-		enum v4l2_buf_type type)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_streamoff(&cam->vb_queue, type);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
-		struct v4l2_requestbuffers *req)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_reqbufs(&cam->vb_queue, req);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_querybuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_querybuf(&cam->vb_queue, buf);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int mcam_vidioc_qbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_qbuf(&cam->vb_queue, buf);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_dqbuf(&cam->vb_queue, buf, filp->f_flags & O_NONBLOCK);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-static int mcam_vidioc_queryctrl(struct file *filp, void *priv,
-		struct v4l2_queryctrl *qc)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, queryctrl, qc);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_g_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, g_ctrl, ctrl);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_s_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, s_ctrl, ctrl);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_querycap(struct file *file, void *priv,
-		struct v4l2_capability *cap)
-{
-	strcpy(cap->driver, "marvell_ccic");
-	strcpy(cap->card, "marvell_ccic");
-	cap->version = 1;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
-	return 0;
-}
-
-
-static int mcam_vidioc_enum_fmt_vid_cap(struct file *filp,
-		void *priv, struct v4l2_fmtdesc *fmt)
-{
-	if (fmt->index >= N_MCAM_FMTS)
-		return -EINVAL;
-	strlcpy(fmt->description, mcam_formats[fmt->index].desc,
-			sizeof(fmt->description));
-	fmt->pixelformat = mcam_formats[fmt->index].pixelformat;
-	return 0;
-}
-
-static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
-		struct v4l2_format *fmt)
-{
-	struct mcam_camera *cam = priv;
-	struct mcam_format_struct *f;
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-	struct v4l2_mbus_framefmt mbus_fmt;
-	int ret;
-
-	f = mcam_find_format(pix->pixelformat);
-	pix->pixelformat = f->pixelformat;
-	v4l2_fill_mbus_format(&mbus_fmt, pix, f->mbus_code);
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
-	mutex_unlock(&cam->s_mutex);
-	v4l2_fill_pix_format(pix, &mbus_fmt);
-	pix->bytesperline = pix->width * f->bpp;
-	pix->sizeimage = pix->height * pix->bytesperline;
-	return ret;
-}
-
-static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
-		struct v4l2_format *fmt)
-{
-	struct mcam_camera *cam = priv;
-	struct mcam_format_struct *f;
-	int ret;
-
-	/*
-	 * Can't do anything if the device is not idle
-	 * Also can't if there are streaming buffers in place.
-	 */
-	if (cam->state != S_IDLE || cam->vb_queue.num_buffers > 0)
-		return -EBUSY;
-
-	f = mcam_find_format(fmt->fmt.pix.pixelformat);
-
-	/*
-	 * See if the formatting works in principle.
-	 */
-	ret = mcam_vidioc_try_fmt_vid_cap(filp, priv, fmt);
-	if (ret)
-		return ret;
-	/*
-	 * Now we start to change things for real, so let's do it
-	 * under lock.
-	 */
-	mutex_lock(&cam->s_mutex);
-	cam->pix_format = fmt->fmt.pix;
-	cam->mbus_code = f->mbus_code;
-
-	/*
-	 * Make sure we have appropriate DMA buffers.
-	 */
-	if (cam->buffer_mode == B_vmalloc) {
-		ret = mcam_check_dma_buffers(cam);
-		if (ret)
-			goto out;
-	}
-	mcam_set_config_needed(cam, 1);
-out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-/*
- * Return our stored notion of how the camera is/should be configured.
- * The V4l2 spec wants us to be smarter, and actually get this from
- * the camera (and not mess with it at open time).  Someday.
- */
-static int mcam_vidioc_g_fmt_vid_cap(struct file *filp, void *priv,
-		struct v4l2_format *f)
-{
-	struct mcam_camera *cam = priv;
-
-	f->fmt.pix = cam->pix_format;
-	return 0;
-}
-
-/*
- * We only have one input - the sensor - so minimize the nonsense here.
- */
-static int mcam_vidioc_enum_input(struct file *filp, void *priv,
-		struct v4l2_input *input)
-{
-	if (input->index != 0)
-		return -EINVAL;
-
-	input->type = V4L2_INPUT_TYPE_CAMERA;
-	input->std = V4L2_STD_ALL; /* Not sure what should go here */
-	strcpy(input->name, "Camera");
-	return 0;
-}
-
-static int mcam_vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	if (i != 0)
-		return -EINVAL;
-	return 0;
-}
-
-/* from vivi.c */
-static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id *a)
-{
-	return 0;
-}
-
-/*
- * G/S_PARM.  Most of this is done by the sensor, but we are
- * the level which controls the number of read buffers.
- */
-static int mcam_vidioc_g_parm(struct file *filp, void *priv,
-		struct v4l2_streamparm *parms)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, g_parm, parms);
-	mutex_unlock(&cam->s_mutex);
-	parms->parm.capture.readbuffers = n_dma_bufs;
-	return ret;
-}
-
-static int mcam_vidioc_s_parm(struct file *filp, void *priv,
-		struct v4l2_streamparm *parms)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, s_parm, parms);
-	mutex_unlock(&cam->s_mutex);
-	parms->parm.capture.readbuffers = n_dma_bufs;
-	return ret;
-}
-
-static int mcam_vidioc_g_chip_ident(struct file *file, void *priv,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	struct mcam_camera *cam = priv;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (v4l2_chip_match_host(&chip->match)) {
-		chip->ident = cam->chip_id;
-		return 0;
-	}
-	return sensor_call(cam, core, g_chip_ident, chip);
-}
-
-static int mcam_vidioc_enum_framesizes(struct file *filp, void *priv,
-		struct v4l2_frmsizeenum *sizes)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, enum_framesizes, sizes);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int mcam_vidioc_enum_frameintervals(struct file *filp, void *priv,
-		struct v4l2_frmivalenum *interval)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, enum_frameintervals, interval);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int mcam_vidioc_g_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg)
-{
-	struct mcam_camera *cam = priv;
-
-	if (v4l2_chip_match_host(&reg->match)) {
-		reg->val = mcam_reg_read(cam, reg->reg);
-		reg->size = 4;
-		return 0;
-	}
-	return sensor_call(cam, core, g_register, reg);
-}
-
-static int mcam_vidioc_s_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg)
-{
-	struct mcam_camera *cam = priv;
-
-	if (v4l2_chip_match_host(&reg->match)) {
-		mcam_reg_write(cam, reg->reg, reg->val);
-		return 0;
-	}
-	return sensor_call(cam, core, s_register, reg);
-}
-#endif
-
-static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
-	.vidioc_querycap	= mcam_vidioc_querycap,
-	.vidioc_enum_fmt_vid_cap = mcam_vidioc_enum_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap	= mcam_vidioc_try_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	= mcam_vidioc_s_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap	= mcam_vidioc_g_fmt_vid_cap,
-	.vidioc_enum_input	= mcam_vidioc_enum_input,
-	.vidioc_g_input		= mcam_vidioc_g_input,
-	.vidioc_s_input		= mcam_vidioc_s_input,
-	.vidioc_s_std		= mcam_vidioc_s_std,
-	.vidioc_reqbufs		= mcam_vidioc_reqbufs,
-	.vidioc_querybuf	= mcam_vidioc_querybuf,
-	.vidioc_qbuf		= mcam_vidioc_qbuf,
-	.vidioc_dqbuf		= mcam_vidioc_dqbuf,
-	.vidioc_streamon	= mcam_vidioc_streamon,
-	.vidioc_streamoff	= mcam_vidioc_streamoff,
-	.vidioc_queryctrl	= mcam_vidioc_queryctrl,
-	.vidioc_g_ctrl		= mcam_vidioc_g_ctrl,
-	.vidioc_s_ctrl		= mcam_vidioc_s_ctrl,
-	.vidioc_g_parm		= mcam_vidioc_g_parm,
-	.vidioc_s_parm		= mcam_vidioc_s_parm,
-	.vidioc_enum_framesizes = mcam_vidioc_enum_framesizes,
-	.vidioc_enum_frameintervals = mcam_vidioc_enum_frameintervals,
-	.vidioc_g_chip_ident	= mcam_vidioc_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register	= mcam_vidioc_g_register,
-	.vidioc_s_register	= mcam_vidioc_s_register,
-#endif
-};
-
-/* ---------------------------------------------------------------------- */
-/*
- * Our various file operations.
- */
-static int mcam_v4l_open(struct file *filp)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret = 0;
-
-	filp->private_data = cam;
-
-	cam->frame_state.frames = 0;
-	cam->frame_state.singles = 0;
-	cam->frame_state.delivered = 0;
-	mutex_lock(&cam->s_mutex);
-	if (cam->users == 0) {
-		ret = mcam_setup_vb2(cam);
-		if (ret)
-			goto out;
-		mcam_ctlr_power_up(cam);
-		__mcam_cam_reset(cam);
-		mcam_set_config_needed(cam, 1);
-	}
-	(cam->users)++;
-out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_v4l_release(struct file *filp)
-{
-	struct mcam_camera *cam = filp->private_data;
-
-	cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n",
-			cam->frame_state.frames, cam->frame_state.singles,
-			cam->frame_state.delivered);
-	mutex_lock(&cam->s_mutex);
-	(cam->users)--;
-	if (cam->users == 0) {
-		mcam_ctlr_stop_dma(cam);
-		mcam_cleanup_vb2(cam);
-		mcam_config_mipi(cam, 0);
-		mcam_ctlr_power_down(cam);
-		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
-			mcam_free_dma_bufs(cam);
-	}
-	mutex_unlock(&cam->s_mutex);
-	return 0;
-}
-
-static ssize_t mcam_v4l_read(struct file *filp,
-		char __user *buffer, size_t len, loff_t *pos)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_read(&cam->vb_queue, buffer, len, pos,
-			filp->f_flags & O_NONBLOCK);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-static unsigned int mcam_v4l_poll(struct file *filp,
-		struct poll_table_struct *pt)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_poll(&cam->vb_queue, filp, pt);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_mmap(&cam->vb_queue, vma);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-static const struct v4l2_file_operations mcam_v4l_fops = {
-	.owner = THIS_MODULE,
-	.open = mcam_v4l_open,
-	.release = mcam_v4l_release,
-	.read = mcam_v4l_read,
-	.poll = mcam_v4l_poll,
-	.mmap = mcam_v4l_mmap,
-	.unlocked_ioctl = video_ioctl2,
-};
-
-
-/*
- * This template device holds all of those v4l2 methods; we
- * clone it for specific real devices.
- */
-static struct video_device mcam_v4l_template = {
-	.name = "mcam",
-	.tvnorms = V4L2_STD_NTSC_M,
-	.current_norm = V4L2_STD_NTSC_M,  /* make mplayer happy */
-
-	.fops = &mcam_v4l_fops,
-	.ioctl_ops = &mcam_v4l_ioctl_ops,
-	.release = video_device_release_empty,
+#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
+const struct vb2_ops mcam_soc_vb2_ops = {
+	.queue_setup		= mcam_vb_queue_setup,
+	.buf_queue		= mcam_vb_buf_queue,
+	.buf_cleanup		= mcam_videobuf_cleanup,
+	.buf_init		= mcam_videobuf_init,
+	.start_streaming	= mcam_vb_start_streaming,
+	.stop_streaming		= mcam_vb_stop_streaming,
+	.wait_prepare		= soc_camera_unlock,
+	.wait_finish		= soc_camera_lock,
 };
+#endif
 
 /* ---------------------------------------------------------------------- */
 /*
@@ -1939,125 +1267,6 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 	return handled;
 }
 
-/* ---------------------------------------------------------------------- */
-/*
- * Registration and such.
- */
-static struct ov7670_config sensor_cfg = {
-	/*
-	 * Exclude QCIF mode, because it only captures a tiny portion
-	 * of the sensor FOV
-	 */
-	.min_width = 320,
-	.min_height = 240,
-};
-
-
-int mccic_register(struct mcam_camera *cam)
-{
-	struct i2c_board_info ov7670_info = {
-		.type = "ov7670",
-		.addr = 0x42 >> 1,
-		.platform_data = &sensor_cfg,
-	};
-	int ret;
-
-	/*
-	 * Validate the requested buffer mode.
-	 */
-	if (buffer_mode >= 0)
-		cam->buffer_mode = buffer_mode;
-	if (cam->buffer_mode == B_DMA_sg &&
-			cam->chip_id == V4L2_IDENT_CAFE) {
-		printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O, "
-			"attempting vmalloc mode instead\n");
-		cam->buffer_mode = B_vmalloc;
-	}
-	if (!mcam_buffer_mode_supported(cam->buffer_mode)) {
-		printk(KERN_ERR "marvell-cam: buffer mode %d unsupported\n",
-				cam->buffer_mode);
-		return -EINVAL;
-	}
-	/*
-	 * Register with V4L
-	 */
-	ret = v4l2_device_register(cam->dev, &cam->v4l2_dev);
-	if (ret)
-		return ret;
-
-	mutex_init(&cam->s_mutex);
-	cam->state = S_NOTREADY;
-	mcam_set_config_needed(cam, 1);
-	cam->pix_format = mcam_def_pix_format;
-	cam->mbus_code = mcam_def_mbus_code;
-	INIT_LIST_HEAD(&cam->buffers);
-	mcam_ctlr_init(cam);
-
-	/*
-	 * Try to find the sensor.
-	 */
-	sensor_cfg.clock_speed = cam->clock_speed;
-	sensor_cfg.use_smbus = cam->use_smbus;
-	cam->sensor_addr = ov7670_info.addr;
-	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
-			cam->i2c_adapter, &ov7670_info, NULL);
-	if (cam->sensor == NULL) {
-		ret = -ENODEV;
-		goto out_unregister;
-	}
-
-	ret = mcam_cam_init(cam);
-	if (ret)
-		goto out_unregister;
-	/*
-	 * Get the v4l2 setup done.
-	 */
-	mutex_lock(&cam->s_mutex);
-	cam->vdev = mcam_v4l_template;
-	cam->vdev.debug = 0;
-	cam->vdev.v4l2_dev = &cam->v4l2_dev;
-	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
-	if (ret)
-		goto out;
-	video_set_drvdata(&cam->vdev, cam);
-
-	/*
-	 * If so requested, try to get our DMA buffers now.
-	 */
-	if (cam->buffer_mode == B_vmalloc && !alloc_bufs_at_read) {
-		if (mcam_alloc_dma_bufs(cam, 1))
-			cam_warn(cam, "Unable to alloc DMA buffers at load"
-					" will try again later.");
-	}
-
-out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-out_unregister:
-	v4l2_device_unregister(&cam->v4l2_dev);
-	return ret;
-}
-
-
-void mccic_shutdown(struct mcam_camera *cam)
-{
-	/*
-	 * If we have no users (and we really, really should have no
-	 * users) the device will already be powered down.  Trying to
-	 * take it down again will wedge the machine, which is frowned
-	 * upon.
-	 */
-	if (cam->users > 0) {
-		cam_warn(cam, "Removing a device with users!\n");
-		mcam_ctlr_power_down(cam);
-	}
-	vb2_queue_release(&cam->vb_queue);
-	if (cam->buffer_mode == B_vmalloc)
-		mcam_free_dma_bufs(cam);
-	video_unregister_device(&cam->vdev);
-	v4l2_device_unregister(&cam->v4l2_dev);
-}
-
 /*
  * Power management
  */
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 47392f6..bba8aa0 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -32,6 +32,18 @@
 #error One of the videobuf buffer modes must be selected in the config
 #endif
 
+#define sensor_call(cam, o, f, args...) \
+	v4l2_subdev_call(cam->sensor, o, f, ##args)
+
+/*
+ * Debugging and related.
+ */
+#define cam_err(cam, fmt, arg...) \
+	dev_err((cam)->dev, fmt, ##arg);
+#define cam_warn(cam, fmt, arg...) \
+	dev_warn((cam)->dev, fmt, ##arg);
+#define cam_dbg(cam, fmt, arg...) \
+	dev_dbg((cam)->dev, fmt, ##arg);
 
 enum mcam_state {
 	S_NOTREADY,	/* Not yet initialized */
@@ -175,6 +187,39 @@ struct mcam_camera {
 
 
 /*
+ * The two-word DMA descriptor format used by the Armada 610 and like.  There
+ * Is a three-word format as well (set C1_DESC_3WORD) where the third
+ * word is a pointer to the next descriptor, but we don't use it.  Two-word
+ * descriptors have to be contiguous in memory.
+ */
+struct mcam_dma_desc {
+	u32 dma_addr;
+	u32 segment_len;
+};
+
+struct yuv_pointer_t {
+	dma_addr_t y;
+	dma_addr_t u;
+	dma_addr_t v;
+};
+
+/*
+ * Our buffer type for working with videobuf2.  Note that the vb2
+ * developers have decreed that struct vb2_buffer must be at the
+ * beginning of this structure.
+ */
+struct mcam_vb_buffer {
+	struct vb2_buffer vb_buf;
+	struct list_head queue;
+	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
+	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
+	int dma_desc_nent;		/* Number of mapped descriptors */
+	struct yuv_pointer_t yuv_p;
+	int list_init_flag;
+};
+
+
+/*
  * Register I/O functions.  These are here because the platform code
  * may legitimately need to mess with the register space.
  */
-- 
1.7.9.5

