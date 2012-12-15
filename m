Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:51793 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684Ab2LOJ77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:59 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2 parts for soc_camera support
Date: Sat, 15 Dec 2012 17:57:59 +0800
Message-Id: <1355565484-15791-11-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch splits mcam-core into 2 parts to prepare for soc_camera support.

The first part remains in mcam-core.c. This part includes the HW operations
and vb2 callback functions.

The second part is moved to mcam-core-standard.c. This part is relevant with
the implementation of using V4L2.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/marvell-ccic/Makefile       |    4 +-
 .../platform/marvell-ccic/mcam-core-standard.c     |  820 +++++++++++++++++
 .../platform/marvell-ccic/mcam-core-standard.h     |   26 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |  944 +-------------------
 drivers/media/platform/marvell-ccic/mcam-core.h    |   54 ++
 5 files changed, 939 insertions(+), 909 deletions(-)
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
index 0000000..5e0d8f1
--- /dev/null
+++ b/drivers/media/platform/marvell-ccic/mcam-core-standard.c
@@ -0,0 +1,820 @@
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
+#include <linux/clk.h>
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
+static void mcam_ctlr_init(struct mcam_camera *cam)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	/*
+	 * Make sure it's not powered down.
+	 */
+	mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
+	/*
+	 * Turn off the enable bit.  It sure should be off anyway,
+	 * but it's good to be sure.
+	 */
+	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
+	/*
+	 * Clock the sensor appropriately.  Controller clock should
+	 * be 48MHz, sensor "typical" value is half that.
+	 */
+	mcam_reg_write_mask(cam, REG_CLKCTRL, 2, CLK_DIV_MASK);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
+/*
+ * We have found the sensor on the i2c.  Let's try to have a
+ * conversation.
+ */
+static int mcam_cam_init(struct mcam_camera *cam)
+{
+	struct v4l2_dbg_chip_ident chip;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	if (cam->state != S_NOTREADY)
+		cam_warn(cam, "Cam init with device in funky state %d",
+				cam->state);
+	ret = __mcam_cam_reset(cam);
+	if (ret)
+		goto out;
+	chip.ident = V4L2_IDENT_NONE;
+	chip.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
+	chip.match.addr = cam->sensor_addr;
+	ret = sensor_call(cam, core, g_chip_ident, &chip);
+	if (ret)
+		goto out;
+	cam->sensor_type = chip.ident;
+	if (cam->sensor_type != V4L2_IDENT_OV7670) {
+		cam_err(cam, "Unsupported sensor type 0x%x", cam->sensor_type);
+		ret = -EINVAL;
+		goto out;
+	}
+/* Get/set parameters? */
+	ret = 0;
+	cam->state = S_IDLE;
+out:
+	mcam_ctlr_power_down(cam);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
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
+	parms->parm.capture.readbuffers = mcam_n_dma_bufs;
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
+	parms->parm.capture.readbuffers = mcam_n_dma_bufs;
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
+	cam->pll1 = devm_clk_get(cam->dev, "pll1");
+	if (IS_ERR(cam->pll1)) {
+		cam_err(cam, "Could not get pll1 clock\n");
+		ret = PTR_ERR(cam->pll1);
+	}
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
+		if (cam->buffer_mode == B_vmalloc && mcam_alloc_bufs_at_read)
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
+	if (mcam_buffer_mode >= 0)
+		cam->buffer_mode = mcam_buffer_mode;
+	if (cam->buffer_mode == B_DMA_sg &&
+			cam->chip_id == V4L2_IDENT_CAFE) {
+		cam_err(cam, "marvell-cam: Cafe can't do S/G I/O, "
+				"attempting vmalloc mode instead\n");
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
+	if (cam->buffer_mode == B_vmalloc && !mcam_alloc_bufs_at_read) {
+		if (mcam_alloc_dma_bufs(cam, 1))
+			cam_warn(cam, "Unable to alloc DMA buffers at load"
+					 " will try again later\n");
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
index 0000000..154ea4f
--- /dev/null
+++ b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
@@ -0,0 +1,26 @@
+/*
+ * Marvell camera core structures.
+ *
+ * Copyright 2011 Jonathan Corbet corbet@lwn.net
+ */
+extern bool mcam_alloc_bufs_at_read;
+extern int mcam_n_dma_bufs;
+extern int mcam_buffer_mode;
+extern const struct vb2_ops mcam_vb2_sg_ops;
+extern const struct vb2_ops mcam_vb2_ops;
+
+void mcam_ctlr_stop_dma(struct mcam_camera *cam);
+int mcam_config_mipi(struct mcam_camera *mcam, int enable);
+void mcam_ctlr_power_up(struct mcam_camera *cam);
+void mcam_ctlr_power_down(struct mcam_camera *cam);
+void mcam_free_dma_bufs(struct mcam_camera *cam);
+void mcam_ctlr_dma_sg(struct mcam_camera *cam);
+void mcam_dma_sg_done(struct mcam_camera *cam, int frame);
+int mcam_check_dma_buffers(struct mcam_camera *cam);
+void mcam_set_config_needed(struct mcam_camera *cam, int needed);
+int __mcam_cam_reset(struct mcam_camera *cam);
+int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime);
+void mcam_ctlr_dma_contig(struct mcam_camera *cam);
+void mcam_dma_contig_done(struct mcam_camera *cam, int frame);
+void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam);
+void mcam_vmalloc_done(struct mcam_camera *cam, int frame);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 9b5a5e9..dccc573 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -45,30 +45,30 @@
  * sense.
  */
 
-static bool alloc_bufs_at_read;
-module_param(alloc_bufs_at_read, bool, 0444);
-MODULE_PARM_DESC(alloc_bufs_at_read,
+bool mcam_alloc_bufs_at_read;
+module_param(mcam_alloc_bufs_at_read, bool, 0444);
+MODULE_PARM_DESC(mcam_alloc_bufs_at_read,
 		"Non-zero value causes DMA buffers to be allocated when the "
 		"video capture device is read, rather than at module load "
 		"time.  This saves memory, but decreases the chances of "
 		"successfully getting those buffers.  This parameter is "
 		"only used in the vmalloc buffer mode");
 
-static int n_dma_bufs = 3;
-module_param(n_dma_bufs, uint, 0644);
-MODULE_PARM_DESC(n_dma_bufs,
+unsigned int mcam_n_dma_bufs = 3;
+module_param(mcam_n_dma_bufs, uint, 0644);
+MODULE_PARM_DESC(mcam_n_dma_bufs,
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
+const bool mcam_alloc_bufs_at_read;
+const unsigned int mcam_n_dma_bufs = 3;  /* Used by S/G_PARM */
 #endif /* MCAM_MODE_VMALLOC */
 
 static bool flip;
@@ -77,9 +77,9 @@ MODULE_PARM_DESC(flip,
 		"If set, the sensor will be instructed to flip the image "
 		"vertically.");
 
-static int buffer_mode = -1;
-module_param(buffer_mode, int, 0444);
-MODULE_PARM_DESC(buffer_mode,
+int mcam_buffer_mode = -1;
+module_param(mcam_buffer_mode, int, 0444);
+MODULE_PARM_DESC(mcam_buffer_mode,
 		"Set the buffer mode to be used; default is to go with what "
 		"the platform driver asks for.  Set to 0 for vmalloc, 1 for "
 		"DMA contiguous.");
@@ -98,124 +98,6 @@ MODULE_PARM_DESC(buffer_mode,
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
-};
-
 static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
 {
 	return container_of(vb, struct mcam_vb_buffer, vb_buf);
@@ -233,19 +115,6 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
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
@@ -265,7 +134,7 @@ static inline int mcam_needs_config(struct mcam_camera *cam)
 	return test_bit(CF_CONFIG_NEEDED, &cam->flags);
 }
 
-static void mcam_set_config_needed(struct mcam_camera *cam, int needed)
+void mcam_set_config_needed(struct mcam_camera *cam, int needed)
 {
 	if (needed)
 		set_bit(CF_CONFIG_NEEDED, &cam->flags);
@@ -290,7 +159,7 @@ static void mcam_ctlr_stop(struct mcam_camera *cam)
 	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
 }
 
-static int mcam_config_mipi(struct mcam_camera *mcam, int enable)
+int mcam_config_mipi(struct mcam_camera *mcam, int enable)
 {
 	if (mcam->bus_type == V4L2_MBUS_CSI2 && enable) {
 		/* Using MIPI mode and enable MIPI */
@@ -344,7 +213,7 @@ static int mcam_config_mipi(struct mcam_camera *mcam, int enable)
 /*
  * Allocate in-kernel DMA buffers for vmalloc mode.
  */
-static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
+int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 {
 	int i;
 
@@ -353,11 +222,11 @@ static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 		cam->dma_buf_size = dma_buf_size;
 	else
 		cam->dma_buf_size = cam->pix_format.sizeimage;
-	if (n_dma_bufs > 3)
-		n_dma_bufs = 3;
+	if (mcam_n_dma_bufs > 3)
+		mcam_n_dma_bufs = 3;
 
 	cam->nbufs = 0;
-	for (i = 0; i < n_dma_bufs; i++) {
+	for (i = 0; i < mcam_n_dma_bufs; i++) {
 		cam->dma_bufs[i] = dma_alloc_coherent(cam->dev,
 				cam->dma_buf_size, cam->dma_handles + i,
 				GFP_KERNEL);
@@ -378,14 +247,14 @@ static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 		return -ENOMEM;
 
 	case 2:
-		if (n_dma_bufs > 2)
+		if (mcam_n_dma_bufs > 2)
 			cam_warn(cam, "Will limp along with only 2 buffers\n");
 		break;
 	}
 	return 0;
 }
 
-static void mcam_free_dma_bufs(struct mcam_camera *cam)
+void mcam_free_dma_bufs(struct mcam_camera *cam)
 {
 	int i;
 
@@ -401,7 +270,7 @@ static void mcam_free_dma_bufs(struct mcam_camera *cam)
 /*
  * Set up DMA buffers when operating in vmalloc mode
  */
-static void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
+void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
 {
 	/*
 	 * Store the first two Y buffers (we aren't supporting
@@ -465,7 +334,7 @@ static void mcam_frame_tasklet(unsigned long data)
 /*
  * Make sure our allocated buffers are up to the task.
  */
-static int mcam_check_dma_buffers(struct mcam_camera *cam)
+int mcam_check_dma_buffers(struct mcam_camera *cam)
 {
 	if (cam->nbufs > 0 && cam->dma_buf_size < cam->pix_format.sizeimage)
 			mcam_free_dma_bufs(cam);
@@ -474,24 +343,24 @@ static int mcam_check_dma_buffers(struct mcam_camera *cam)
 	return 0;
 }
 
-static void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
+void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
 {
 	tasklet_schedule(&cam->s_tasklet);
 }
 
 #else /* MCAM_MODE_VMALLOC */
 
-static inline int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
+int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 {
 	return 0;
 }
 
-static inline void mcam_free_dma_bufs(struct mcam_camera *cam)
+void mcam_free_dma_bufs(struct mcam_camera *cam)
 {
 	return;
 }
 
-static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
+int mcam_check_dma_buffers(struct mcam_camera *cam)
 {
 	return 0;
 }
@@ -561,7 +430,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 /*
  * Initial B_DMA_contig setup.
  */
-static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
+void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 {
 	mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
 	cam->nbufs = 2;
@@ -572,7 +441,7 @@ static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 /*
  * Frame completion handling.
  */
-static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
+void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
 
@@ -618,7 +487,7 @@ static void mcam_sg_next_buffer(struct mcam_camera *cam)
 /*
  * Initial B_DMA_sg setup
  */
-static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
+void mcam_ctlr_dma_sg(struct mcam_camera *cam)
 {
 	/*
 	 * The list-empty condition can hit us at resume time
@@ -648,7 +517,7 @@ static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
  * safely change the DMA descriptor array here and restart things
  * (assuming there's another buffer waiting to go).
  */
-static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
+void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf = cam->vb_bufs[0];
 
@@ -711,7 +580,7 @@ static inline void mcam_sg_restart(struct mcam_camera *cam)
 /*
  * Image format setup
  */
-static void mcam_ctlr_image(struct mcam_camera *cam)
+void mcam_ctlr_image(struct mcam_camera *cam)
 {
 	struct v4l2_pix_format *fmt = &cam->pix_format;
 	u32 widthy = 0, widthuv = 0, imgsz_h, imgsz_w;
@@ -834,36 +703,11 @@ static void mcam_ctlr_irq_disable(struct mcam_camera *cam)
 	mcam_reg_clear_bit(cam, REG_IRQMASK, FRAMEIRQS);
 }
 
-
-
-static void mcam_ctlr_init(struct mcam_camera *cam)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	/*
-	 * Make sure it's not powered down.
-	 */
-	mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
-	/*
-	 * Turn off the enable bit.  It sure should be off anyway,
-	 * but it's good to be sure.
-	 */
-	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
-	/*
-	 * Clock the sensor appropriately.  Controller clock should
-	 * be 48MHz, sensor "typical" value is half that.
-	 */
-	mcam_reg_write_mask(cam, REG_CLKCTRL, 2, CLK_DIV_MASK);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-}
-
-
 /*
  * Stop the controller, and don't return until we're really sure that no
  * further DMA is going on.
  */
-static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
+void mcam_ctlr_stop_dma(struct mcam_camera *cam)
 {
 	unsigned long flags;
 
@@ -896,7 +740,7 @@ static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
 /*
  * Power up and down.
  */
-static void mcam_ctlr_power_up(struct mcam_camera *cam)
+void mcam_ctlr_power_up(struct mcam_camera *cam)
 {
 	unsigned long flags;
 
@@ -907,7 +751,7 @@ static void mcam_ctlr_power_up(struct mcam_camera *cam)
 	msleep(5); /* Just to be sure */
 }
 
-static void mcam_ctlr_power_down(struct mcam_camera *cam)
+void mcam_ctlr_power_down(struct mcam_camera *cam)
 {
 	unsigned long flags;
 
@@ -927,49 +771,12 @@ static void mcam_ctlr_power_down(struct mcam_camera *cam)
  * Communications with the sensor.
  */
 
-static int __mcam_cam_reset(struct mcam_camera *cam)
+int __mcam_cam_reset(struct mcam_camera *cam)
 {
 	return sensor_call(cam, core, reset, 0);
 }
 
 /*
- * We have found the sensor on the i2c.  Let's try to have a
- * conversation.
- */
-static int mcam_cam_init(struct mcam_camera *cam)
-{
-	struct v4l2_dbg_chip_ident chip;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	if (cam->state != S_NOTREADY)
-		cam_warn(cam, "Cam init with device in funky state %d",
-				cam->state);
-	ret = __mcam_cam_reset(cam);
-	if (ret)
-		goto out;
-	chip.ident = V4L2_IDENT_NONE;
-	chip.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
-	chip.match.addr = cam->sensor_addr;
-	ret = sensor_call(cam, core, g_chip_ident, &chip);
-	if (ret)
-		goto out;
-	cam->sensor_type = chip.ident;
-	if (cam->sensor_type != V4L2_IDENT_OV7670) {
-		cam_err(cam, "Unsupported sensor type 0x%x", cam->sensor_type);
-		ret = -EINVAL;
-		goto out;
-	}
-/* Get/set parameters? */
-	ret = 0;
-	cam->state = S_IDLE;
-out:
-	mcam_ctlr_power_down(cam);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-/*
  * Configure the sensor to match the parameters we have.  Caller should
  * hold s_mutex
  */
@@ -1205,7 +1012,7 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 }
 
 
-static const struct vb2_ops mcam_vb2_ops = {
+const struct vb2_ops mcam_vb2_ops = {
 	.queue_setup		= mcam_vb_queue_setup,
 	.buf_queue		= mcam_vb_buf_queue,
 	.start_streaming	= mcam_vb_start_streaming,
@@ -1277,7 +1084,7 @@ static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
 }
 
 
-static const struct vb2_ops mcam_vb2_sg_ops = {
+const struct vb2_ops mcam_vb2_sg_ops = {
 	.queue_setup		= mcam_vb_queue_setup,
 	.buf_init		= mcam_vb_sg_buf_init,
 	.buf_prepare		= mcam_vb_sg_buf_prepare,
@@ -1292,564 +1099,6 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 
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
-	cam->pll1 = devm_clk_get(cam->dev, "pll1");
-	if (IS_ERR(cam->pll1)) {
-		cam_err(cam, "Could not get pll1 clock\n");
-		ret = PTR_ERR(cam->pll1);
-	}
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
-};
-
 /* ---------------------------------------------------------------------- */
 /*
  * Interrupt handler stuff
@@ -1924,125 +1173,6 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
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
index 3ea25ed..4670c49 100755
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
@@ -174,6 +186,36 @@ struct mcam_camera {
 	struct mutex s_mutex; /* Access to this structure */
 };
 
+/*
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
+};
 
 /*
  * Register I/O functions.  These are here because the platform code
@@ -367,4 +409,16 @@ int mccic_resume(struct mcam_camera *cam);
 #define VGA_WIDTH	640
 #define VGA_HEIGHT	480
 
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
 #endif /* _MCAM_CORE_H */
-- 
1.7.9.5

