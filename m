Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:55936
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636Ab2CHJgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Mar 2012 04:36:43 -0500
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>,
	<uclinux-dist-devel@blackfin.uclinux.org>
CC: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 3/3 v3] [FOR 3.3] v4l2: add blackfin capture bridge driver
Date: Thu, 8 Mar 2012 16:44:17 -0500
Message-ID: <1331243057-15763-3-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1331243057-15763-1-git-send-email-scott.jiang.linux@gmail.com>
References: <1331243057-15763-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a v4l2 bridge driver for Blackfin video capture device, support ppi and eppi interface.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/video/Kconfig                 |    2 +
 drivers/media/video/Makefile                |    2 +
 drivers/media/video/blackfin/Kconfig        |   10 +
 drivers/media/video/blackfin/Makefile       |    2 +
 drivers/media/video/blackfin/bfin_capture.c | 1059 +++++++++++++++++++++++++++
 drivers/media/video/blackfin/ppi.c          |  271 +++++++
 include/media/blackfin/bfin_capture.h       |   37 +
 include/media/blackfin/ppi.h                |   74 ++
 8 files changed, 1457 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/blackfin/Kconfig
 create mode 100644 drivers/media/video/blackfin/Makefile
 create mode 100644 drivers/media/video/blackfin/bfin_capture.c
 create mode 100644 drivers/media/video/blackfin/ppi.c
 create mode 100644 include/media/blackfin/bfin_capture.h
 create mode 100644 include/media/blackfin/ppi.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 88eb68f..c2c9507 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -871,6 +871,8 @@ source "drivers/media/video/davinci/Kconfig"
 
 source "drivers/media/video/omap/Kconfig"
 
+source "drivers/media/video/blackfin/Kconfig"
+
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on VIDEO_DEV && ARCH_SHMOBILE
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a83d13f..e702533 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -186,6 +186,8 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 
+obj-$(CONFIG_BLACKFIN)                  += blackfin/
+
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
diff --git a/drivers/media/video/blackfin/Kconfig b/drivers/media/video/blackfin/Kconfig
new file mode 100644
index 0000000..ecd5323
--- /dev/null
+++ b/drivers/media/video/blackfin/Kconfig
@@ -0,0 +1,10 @@
+config VIDEO_BLACKFIN_CAPTURE
+	tristate "Blackfin Video Capture Driver"
+	depends on VIDEO_V4L2 && BLACKFIN && I2C
+	select VIDEOBUF2_DMA_CONTIG
+	help
+	  V4L2 bridge driver for Blackfin video capture device.
+	  Choose PPI or EPPI as its interface.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin_video_capture.
diff --git a/drivers/media/video/blackfin/Makefile b/drivers/media/video/blackfin/Makefile
new file mode 100644
index 0000000..aa3a0a2
--- /dev/null
+++ b/drivers/media/video/blackfin/Makefile
@@ -0,0 +1,2 @@
+bfin_video_capture-objs := bfin_capture.o ppi.o
+obj-$(CONFIG_VIDEO_BLACKFIN_CAPTURE) += bfin_video_capture.o
diff --git a/drivers/media/video/blackfin/bfin_capture.c b/drivers/media/video/blackfin/bfin_capture.c
new file mode 100644
index 0000000..514fcf7
--- /dev/null
+++ b/drivers/media/video/blackfin/bfin_capture.c
@@ -0,0 +1,1059 @@
+/*
+ * Analog Devices video capture driver
+ *
+ * Copyright (c) 2011 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/types.h>
+
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include <asm/dma.h>
+
+#include <media/blackfin/bfin_capture.h>
+#include <media/blackfin/ppi.h>
+
+#define CAPTURE_DRV_NAME        "bfin_capture"
+#define BCAP_MIN_NUM_BUF        2
+
+struct bcap_format {
+	char *desc;
+	u32 pixelformat;
+	enum v4l2_mbus_pixelcode mbus_code;
+	int bpp; /* bits per pixel */
+};
+
+struct bcap_buffer {
+	struct vb2_buffer vb;
+	struct list_head list;
+};
+
+struct bcap_device {
+	/* capture device instance */
+	struct v4l2_device v4l2_dev;
+	/* v4l2 control handler */
+	struct v4l2_ctrl_handler ctrl_handler;
+	/* device node data */
+	struct video_device *video_dev;
+	/* sub device instance */
+	struct v4l2_subdev *sd;
+	/* capture config */
+	struct bfin_capture_config *cfg;
+	/* ppi interface */
+	struct ppi_if *ppi;
+	/* current input */
+	unsigned int cur_input;
+	/* current selected standard */
+	v4l2_std_id std;
+	/* used to store pixel format */
+	struct v4l2_pix_format fmt;
+	/* bits per pixel*/
+	int bpp;
+	/* used to store sensor supported format */
+	struct bcap_format *sensor_formats;
+	/* number of sensor formats array */
+	int num_sensor_formats;
+	/* pointing to current video buffer */
+	struct bcap_buffer *cur_frm;
+	/* pointing to next video buffer */
+	struct bcap_buffer *next_frm;
+	/* buffer queue used in videobuf2 */
+	struct vb2_queue buffer_queue;
+	/* allocator-specific contexts for each plane */
+	struct vb2_alloc_ctx *alloc_ctx;
+	/* queue of filled frames */
+	struct list_head dma_queue;
+	/* used in videobuf2 callback */
+	spinlock_t lock;
+	/* used to access capture device */
+	struct mutex mutex;
+	/* used to wait ppi to complete one transfer */
+	struct completion comp;
+	/* prepare to stop */
+	bool stop;
+};
+
+struct bcap_fh {
+	struct v4l2_fh fh;
+	/* indicates whether this file handle is doing IO */
+	bool io_allowed;
+};
+
+static const struct bcap_format bcap_formats[] = {
+	{
+		.desc        = "YCbCr 4:2:2 Interleaved UYVY",
+		.pixelformat = V4L2_PIX_FMT_UYVY,
+		.mbus_code   = V4L2_MBUS_FMT_UYVY8_2X8,
+		.bpp         = 16,
+	},
+	{
+		.desc        = "YCbCr 4:2:2 Interleaved YUYV",
+		.pixelformat = V4L2_PIX_FMT_YUYV,
+		.mbus_code   = V4L2_MBUS_FMT_YUYV8_2X8,
+		.bpp         = 16,
+	},
+	{
+		.desc        = "RGB 565",
+		.pixelformat = V4L2_PIX_FMT_RGB565,
+		.mbus_code   = V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.bpp         = 16,
+	},
+	{
+		.desc        = "RGB 444",
+		.pixelformat = V4L2_PIX_FMT_RGB444,
+		.mbus_code   = V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
+		.bpp         = 16,
+	},
+
+};
+#define BCAP_MAX_FMTS ARRAY_SIZE(bcap_formats)
+
+static irqreturn_t bcap_isr(int irq, void *dev_id);
+
+static struct bcap_buffer *to_bcap_vb(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct bcap_buffer, vb);
+}
+
+static int bcap_init_sensor_formats(struct bcap_device *bcap_dev)
+{
+	enum v4l2_mbus_pixelcode code;
+	struct bcap_format *sf;
+	unsigned int num_formats = 0;
+	int i, j;
+
+	while (!v4l2_subdev_call(bcap_dev->sd, video,
+				enum_mbus_fmt, num_formats, &code))
+		num_formats++;
+	if (!num_formats)
+		return -ENXIO;
+
+	sf = kzalloc(num_formats * sizeof(*sf), GFP_KERNEL);
+	if (!sf)
+		return -ENOMEM;
+
+	for (i = 0; i < num_formats; i++) {
+		v4l2_subdev_call(bcap_dev->sd, video,
+				enum_mbus_fmt, i, &code);
+		for (j = 0; j < BCAP_MAX_FMTS; j++)
+			if (code == bcap_formats[j].mbus_code)
+				break;
+		if (j == BCAP_MAX_FMTS) {
+			/* we don't allow this sensor working with our bridge */
+			kfree(sf);
+			return -EINVAL;
+		}
+		sf[i] = bcap_formats[j];
+	}
+	bcap_dev->sensor_formats = sf;
+	bcap_dev->num_sensor_formats = num_formats;
+	return 0;
+}
+
+static void bcap_free_sensor_formats(struct bcap_device *bcap_dev)
+{
+	bcap_dev->num_sensor_formats = 0;
+	kfree(bcap_dev->sensor_formats);
+	bcap_dev->sensor_formats = NULL;
+}
+
+static int bcap_open(struct file *file)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct video_device *vfd = bcap_dev->video_dev;
+	struct bcap_fh *bcap_fh;
+
+	if (!bcap_dev->sd) {
+		v4l2_err(&bcap_dev->v4l2_dev, "No sub device registered\n");
+		return -ENODEV;
+	}
+
+	bcap_fh = kzalloc(sizeof(*bcap_fh), GFP_KERNEL);
+	if (!bcap_fh) {
+		v4l2_err(&bcap_dev->v4l2_dev,
+			 "unable to allocate memory for file handle object\n");
+		return -ENOMEM;
+	}
+
+	v4l2_fh_init(&bcap_fh->fh, vfd);
+
+	/* store pointer to v4l2_fh in private_data member of file */
+	file->private_data = &bcap_fh->fh;
+	v4l2_fh_add(&bcap_fh->fh);
+	bcap_fh->io_allowed = false;
+	return 0;
+}
+
+static int bcap_release(struct file *file)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_fh *fh = file->private_data;
+	struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
+
+	/* if this instance is doing IO */
+	if (bcap_fh->io_allowed)
+		vb2_queue_release(&bcap_dev->buffer_queue);
+
+	file->private_data = NULL;
+	v4l2_fh_del(&bcap_fh->fh);
+	v4l2_fh_exit(&bcap_fh->fh);
+	kfree(bcap_fh);
+	return 0;
+}
+
+static int bcap_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	return vb2_mmap(&bcap_dev->buffer_queue, vma);
+}
+
+#ifndef CONFIG_MMU
+static unsigned long bcap_get_unmapped_area(struct file *file,
+					    unsigned long addr,
+					    unsigned long len,
+					    unsigned long pgoff,
+					    unsigned long flags)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	return vb2_get_unmapped_area(&bcap_dev->buffer_queue,
+				     addr,
+				     len,
+				     pgoff,
+				     flags);
+}
+#endif
+
+static unsigned int bcap_poll(struct file *file, poll_table *wait)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	return vb2_poll(&bcap_dev->buffer_queue, file, wait);
+}
+
+static int bcap_queue_setup(struct vb2_queue *vq,
+				const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
+
+	if (*nbuffers < BCAP_MIN_NUM_BUF)
+		*nbuffers = BCAP_MIN_NUM_BUF;
+
+	*nplanes = 1;
+	sizes[0] = bcap_dev->fmt.sizeimage;
+	alloc_ctxs[0] = bcap_dev->alloc_ctx;
+
+	return 0;
+}
+
+static int bcap_buffer_init(struct vb2_buffer *vb)
+{
+	struct bcap_buffer *buf = to_bcap_vb(vb);
+
+	INIT_LIST_HEAD(&buf->list);
+	return 0;
+}
+
+static int bcap_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct bcap_buffer *buf = to_bcap_vb(vb);
+	unsigned long size;
+
+	size = bcap_dev->fmt.sizeimage;
+	if (vb2_plane_size(vb, 0) < size) {
+		v4l2_err(&bcap_dev->v4l2_dev, "buffer too small (%lu < %lu)\n",
+				vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+	vb2_set_plane_payload(&buf->vb, 0, size);
+
+	return 0;
+}
+
+static void bcap_buffer_queue(struct vb2_buffer *vb)
+{
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct bcap_buffer *buf = to_bcap_vb(vb);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bcap_dev->lock, flags);
+	list_add_tail(&buf->list, &bcap_dev->dma_queue);
+	spin_unlock_irqrestore(&bcap_dev->lock, flags);
+}
+
+static void bcap_buffer_cleanup(struct vb2_buffer *vb)
+{
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct bcap_buffer *buf = to_bcap_vb(vb);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bcap_dev->lock, flags);
+	list_del_init(&buf->list);
+	spin_unlock_irqrestore(&bcap_dev->lock, flags);
+}
+
+static void bcap_lock(struct vb2_queue *vq)
+{
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
+	mutex_lock(&bcap_dev->mutex);
+}
+
+static void bcap_unlock(struct vb2_queue *vq)
+{
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
+	mutex_unlock(&bcap_dev->mutex);
+}
+
+static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
+	struct ppi_if *ppi = bcap_dev->ppi;
+	struct ppi_params params;
+	int ret;
+
+	/* enable streamon on the sub device */
+	ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 1);
+	if (ret && (ret != -ENOIOCTLCMD)) {
+		v4l2_err(&bcap_dev->v4l2_dev, "stream on failed in subdev\n");
+		return ret;
+	}
+
+	/* set ppi params */
+	params.width = bcap_dev->fmt.width;
+	params.height = bcap_dev->fmt.height;
+	params.bpp = bcap_dev->bpp;
+	params.ppi_control = bcap_dev->cfg->ppi_control;
+	params.int_mask = bcap_dev->cfg->int_mask;
+	params.blank_clocks = bcap_dev->cfg->blank_clocks;
+	ret = ppi->ops->set_params(ppi, &params);
+	if (ret < 0) {
+		v4l2_err(&bcap_dev->v4l2_dev,
+				"Error in setting ppi params\n");
+		return ret;
+	}
+
+	/* attach ppi DMA irq handler */
+	ret = ppi->ops->attach_irq(ppi, bcap_isr);
+	if (ret < 0) {
+		v4l2_err(&bcap_dev->v4l2_dev,
+				"Error in attaching interrupt handler\n");
+		return ret;
+	}
+
+	INIT_COMPLETION(bcap_dev->comp);
+	bcap_dev->stop = false;
+	return 0;
+}
+
+static int bcap_stop_streaming(struct vb2_queue *vq)
+{
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
+	struct ppi_if *ppi = bcap_dev->ppi;
+	int ret;
+
+	if (!vb2_is_streaming(vq))
+		return 0;
+
+	bcap_dev->stop = true;
+	wait_for_completion(&bcap_dev->comp);
+	ppi->ops->stop(ppi);
+	ppi->ops->detach_irq(ppi);
+	ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 0);
+	if (ret && (ret != -ENOIOCTLCMD))
+		v4l2_err(&bcap_dev->v4l2_dev,
+				"stream off failed in subdev\n");
+
+	/* release all active buffers */
+	while (!list_empty(&bcap_dev->dma_queue)) {
+		bcap_dev->next_frm = list_entry(bcap_dev->dma_queue.next,
+						struct bcap_buffer, list);
+		list_del(&bcap_dev->next_frm->list);
+		vb2_buffer_done(&bcap_dev->next_frm->vb, VB2_BUF_STATE_ERROR);
+	}
+	return 0;
+}
+
+static struct vb2_ops bcap_video_qops = {
+	.queue_setup            = bcap_queue_setup,
+	.buf_init               = bcap_buffer_init,
+	.buf_prepare            = bcap_buffer_prepare,
+	.buf_cleanup            = bcap_buffer_cleanup,
+	.buf_queue              = bcap_buffer_queue,
+	.wait_prepare           = bcap_unlock,
+	.wait_finish            = bcap_lock,
+	.start_streaming        = bcap_start_streaming,
+	.stop_streaming         = bcap_stop_streaming,
+};
+
+static int bcap_reqbufs(struct file *file, void *priv,
+			struct v4l2_requestbuffers *req_buf)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct vb2_queue *vq = &bcap_dev->buffer_queue;
+	struct v4l2_fh *fh = file->private_data;
+	struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
+
+	if (vb2_is_busy(vq))
+		return -EBUSY;
+
+	bcap_fh->io_allowed = true;
+
+	return vb2_reqbufs(vq, req_buf);
+}
+
+static int bcap_querybuf(struct file *file, void *priv,
+				struct v4l2_buffer *buf)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	return vb2_querybuf(&bcap_dev->buffer_queue, buf);
+}
+
+static int bcap_qbuf(struct file *file, void *priv,
+			struct v4l2_buffer *buf)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_fh *fh = file->private_data;
+	struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
+
+	if (!bcap_fh->io_allowed)
+		return -EBUSY;
+
+	return vb2_qbuf(&bcap_dev->buffer_queue, buf);
+}
+
+static int bcap_dqbuf(struct file *file, void *priv,
+			struct v4l2_buffer *buf)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_fh *fh = file->private_data;
+	struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
+
+	if (!bcap_fh->io_allowed)
+		return -EBUSY;
+
+	return vb2_dqbuf(&bcap_dev->buffer_queue,
+				buf, file->f_flags & O_NONBLOCK);
+}
+
+static irqreturn_t bcap_isr(int irq, void *dev_id)
+{
+	struct ppi_if *ppi = dev_id;
+	struct bcap_device *bcap_dev = ppi->priv;
+	struct timeval timevalue;
+	struct vb2_buffer *vb = &bcap_dev->cur_frm->vb;
+	dma_addr_t addr;
+
+	spin_lock(&bcap_dev->lock);
+
+	if (bcap_dev->cur_frm != bcap_dev->next_frm) {
+		do_gettimeofday(&timevalue);
+		vb->v4l2_buf.timestamp = timevalue;
+		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		bcap_dev->cur_frm = bcap_dev->next_frm;
+	}
+
+	ppi->ops->stop(ppi);
+
+	if (bcap_dev->stop) {
+		complete(&bcap_dev->comp);
+	} else {
+		if (!list_empty(&bcap_dev->dma_queue)) {
+			bcap_dev->next_frm = list_entry(bcap_dev->dma_queue.next,
+						struct bcap_buffer, list);
+			list_del(&bcap_dev->next_frm->list);
+			addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->next_frm->vb, 0);
+			ppi->ops->update_addr(ppi, (unsigned long)addr);
+		}
+		ppi->ops->start(ppi);
+	}
+
+	spin_unlock(&bcap_dev->lock);
+
+	return IRQ_HANDLED;
+}
+
+static int bcap_streamon(struct file *file, void *priv,
+				enum v4l2_buf_type buf_type)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct bcap_fh *fh = file->private_data;
+	struct ppi_if *ppi = bcap_dev->ppi;
+	dma_addr_t addr;
+	int ret;
+
+	if (!fh->io_allowed)
+		return -EBUSY;
+
+	/* call streamon to start streaming in videobuf */
+	ret = vb2_streamon(&bcap_dev->buffer_queue, buf_type);
+	if (ret)
+		return ret;
+
+	/* if dma queue is empty, return error */
+	if (list_empty(&bcap_dev->dma_queue)) {
+		v4l2_err(&bcap_dev->v4l2_dev, "dma queue is empty\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* get the next frame from the dma queue */
+	bcap_dev->next_frm = list_entry(bcap_dev->dma_queue.next,
+					struct bcap_buffer, list);
+	bcap_dev->cur_frm = bcap_dev->next_frm;
+	/* remove buffer from the dma queue */
+	list_del(&bcap_dev->cur_frm->list);
+	addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
+	/* update DMA address */
+	ppi->ops->update_addr(ppi, (unsigned long)addr);
+	/* enable ppi */
+	ppi->ops->start(ppi);
+
+	return 0;
+err:
+	vb2_streamoff(&bcap_dev->buffer_queue, buf_type);
+	return ret;
+}
+
+static int bcap_streamoff(struct file *file, void *priv,
+				enum v4l2_buf_type buf_type)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct bcap_fh *fh = file->private_data;
+
+	if (!fh->io_allowed)
+		return -EBUSY;
+
+	return vb2_streamoff(&bcap_dev->buffer_queue, buf_type);
+}
+
+static int bcap_querystd(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	return v4l2_subdev_call(bcap_dev->sd, video, querystd, std);
+}
+
+static int bcap_g_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	*std = bcap_dev->std;
+	return 0;
+}
+
+static int bcap_s_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	int ret;
+
+	if (vb2_is_busy(&bcap_dev->buffer_queue))
+		return -EBUSY;
+
+	ret = v4l2_subdev_call(bcap_dev->sd, core, s_std, *std);
+	if (ret < 0)
+		return ret;
+
+	bcap_dev->std = *std;
+	return 0;
+}
+
+static int bcap_enum_input(struct file *file, void *priv,
+				struct v4l2_input *input)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct bfin_capture_config *config = bcap_dev->cfg;
+	int ret;
+	u32 status;
+
+	if (input->index >= config->num_inputs)
+		return -EINVAL;
+
+	*input = config->inputs[input->index];
+	/* get input status */
+	ret = v4l2_subdev_call(bcap_dev->sd, video, g_input_status, &status);
+	if (!ret)
+		input->status = status;
+	return 0;
+}
+
+static int bcap_g_input(struct file *file, void *priv, unsigned int *index)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	*index = bcap_dev->cur_input;
+	return 0;
+}
+
+static int bcap_s_input(struct file *file, void *priv, unsigned int index)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct bfin_capture_config *config = bcap_dev->cfg;
+	struct bcap_route *route;
+	int ret;
+
+	if (vb2_is_busy(&bcap_dev->buffer_queue))
+		return -EBUSY;
+
+	if (index >= config->num_inputs)
+		return -EINVAL;
+
+	route = &config->routes[index];
+	ret = v4l2_subdev_call(bcap_dev->sd, video, s_routing,
+				route->input, route->output, 0);
+	if ((ret < 0) && (ret != -ENOIOCTLCMD)) {
+		v4l2_err(&bcap_dev->v4l2_dev, "Failed to set input\n");
+		return ret;
+	}
+	bcap_dev->cur_input = index;
+	return 0;
+}
+
+static int bcap_try_format(struct bcap_device *bcap,
+				struct v4l2_pix_format *pixfmt,
+				enum v4l2_mbus_pixelcode *mbus_code,
+				int *bpp)
+{
+	struct bcap_format *sf = bcap->sensor_formats;
+	struct bcap_format *fmt = NULL;
+	struct v4l2_mbus_framefmt mbus_fmt;
+	int ret, i;
+
+	for (i = 0; i < bcap->num_sensor_formats; i++) {
+		fmt = &sf[i];
+		if (pixfmt->pixelformat == fmt->pixelformat)
+			break;
+	}
+	if (i == bcap->num_sensor_formats)
+		fmt = &sf[0];
+
+	if (mbus_code)
+		*mbus_code = fmt->mbus_code;
+	if (bpp)
+		*bpp = fmt->bpp;
+	v4l2_fill_mbus_format(&mbus_fmt, pixfmt, fmt->mbus_code);
+	ret = v4l2_subdev_call(bcap->sd, video,
+				try_mbus_fmt, &mbus_fmt);
+	if (ret < 0)
+		return ret;
+	v4l2_fill_pix_format(pixfmt, &mbus_fmt);
+	pixfmt->bytesperline = pixfmt->width * fmt->bpp / 8;
+	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
+	return 0;
+}
+
+static int bcap_enum_fmt_vid_cap(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *fmt)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct bcap_format *sf = bcap_dev->sensor_formats;
+
+	if (fmt->index >= bcap_dev->num_sensor_formats)
+		return -EINVAL;
+
+	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	strlcpy(fmt->description,
+		sf[fmt->index].desc,
+		sizeof(fmt->description));
+	fmt->pixelformat = sf[fmt->index].pixelformat;
+	return 0;
+}
+
+static int bcap_try_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *fmt)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
+
+	return bcap_try_format(bcap_dev, pixfmt, NULL, NULL);
+}
+
+static int bcap_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *fmt)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	fmt->fmt.pix = bcap_dev->fmt;
+	return 0;
+}
+
+static int bcap_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *fmt)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_mbus_framefmt mbus_fmt;
+	enum v4l2_mbus_pixelcode mbus_code;
+	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
+	int ret, bpp;
+
+	if (vb2_is_busy(&bcap_dev->buffer_queue))
+		return -EBUSY;
+
+	/* see if format works */
+	ret = bcap_try_format(bcap_dev, pixfmt, &mbus_code, &bpp);
+	if (ret < 0)
+		return ret;
+
+	v4l2_fill_mbus_format(&mbus_fmt, pixfmt, mbus_code);
+	ret = v4l2_subdev_call(bcap_dev->sd, video, s_mbus_fmt, &mbus_fmt);
+	if (ret < 0)
+		return ret;
+	bcap_dev->fmt = *pixfmt;
+	bcap_dev->bpp = bpp;
+	return 0;
+}
+
+static int bcap_querycap(struct file *file, void  *priv,
+				struct v4l2_capability *cap)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
+	strlcpy(cap->bus_info, "Blackfin Platform", sizeof(cap->bus_info));
+	strlcpy(cap->card, bcap_dev->cfg->card_name, sizeof(cap->card));
+	return 0;
+}
+
+static int bcap_g_parm(struct file *file, void *fh,
+				struct v4l2_streamparm *a)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	return v4l2_subdev_call(bcap_dev->sd, video, g_parm, a);
+}
+
+static int bcap_s_parm(struct file *file, void *fh,
+				struct v4l2_streamparm *a)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	return v4l2_subdev_call(bcap_dev->sd, video, s_parm, a);
+}
+
+static int bcap_g_chip_ident(struct file *file, void *priv,
+		struct v4l2_dbg_chip_ident *chip)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	chip->ident = V4L2_IDENT_NONE;
+	chip->revision = 0;
+	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
+			chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
+		return -EINVAL;
+
+	return v4l2_subdev_call(bcap_dev->sd, core,
+			g_chip_ident, chip);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int bcap_dbg_g_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	return v4l2_subdev_call(bcap_dev->sd, core,
+			g_register, reg);
+}
+
+static int bcap_dbg_s_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	return v4l2_subdev_call(bcap_dev->sd, core,
+			s_register, reg);
+}
+#endif
+
+static int bcap_log_status(struct file *file, void *priv)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	/* status for sub devices */
+	v4l2_device_call_all(&bcap_dev->v4l2_dev, 0, core, log_status);
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
+	.vidioc_querycap         = bcap_querycap,
+	.vidioc_g_fmt_vid_cap    = bcap_g_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap = bcap_enum_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap    = bcap_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap  = bcap_try_fmt_vid_cap,
+	.vidioc_enum_input       = bcap_enum_input,
+	.vidioc_g_input          = bcap_g_input,
+	.vidioc_s_input          = bcap_s_input,
+	.vidioc_querystd         = bcap_querystd,
+	.vidioc_s_std            = bcap_s_std,
+	.vidioc_g_std            = bcap_g_std,
+	.vidioc_reqbufs          = bcap_reqbufs,
+	.vidioc_querybuf         = bcap_querybuf,
+	.vidioc_qbuf             = bcap_qbuf,
+	.vidioc_dqbuf            = bcap_dqbuf,
+	.vidioc_streamon         = bcap_streamon,
+	.vidioc_streamoff        = bcap_streamoff,
+	.vidioc_g_parm           = bcap_g_parm,
+	.vidioc_s_parm           = bcap_s_parm,
+	.vidioc_g_chip_ident     = bcap_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register       = bcap_dbg_g_register,
+	.vidioc_s_register       = bcap_dbg_s_register,
+#endif
+	.vidioc_log_status       = bcap_log_status,
+};
+
+static struct v4l2_file_operations bcap_fops = {
+	.owner = THIS_MODULE,
+	.open = bcap_open,
+	.release = bcap_release,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = bcap_mmap,
+#ifndef CONFIG_MMU
+	.get_unmapped_area = bcap_get_unmapped_area,
+#endif
+	.poll = bcap_poll
+};
+
+static int __devinit bcap_probe(struct platform_device *pdev)
+{
+	struct bcap_device *bcap_dev;
+	struct video_device *vfd;
+	struct i2c_adapter *i2c_adap;
+	struct bfin_capture_config *config;
+	struct vb2_queue *q;
+	int ret;
+
+	config = pdev->dev.platform_data;
+	if (!config) {
+		v4l2_err(pdev->dev.driver, "Unable to get board config\n");
+		return -ENODEV;
+	}
+
+	bcap_dev = kzalloc(sizeof(*bcap_dev), GFP_KERNEL);
+	if (!bcap_dev) {
+		v4l2_err(pdev->dev.driver, "Unable to alloc bcap_dev\n");
+		return -ENOMEM;
+	}
+
+	bcap_dev->cfg = config;
+
+	bcap_dev->ppi = ppi_create_instance(config->ppi_info);
+	if (!bcap_dev->ppi) {
+		v4l2_err(pdev->dev.driver, "Unable to create ppi\n");
+		ret = -ENODEV;
+		goto err_free_dev;
+	}
+	bcap_dev->ppi->priv = bcap_dev;
+
+	bcap_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(bcap_dev->alloc_ctx)) {
+		ret = PTR_ERR(bcap_dev->alloc_ctx);
+		goto err_free_ppi;
+	}
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		ret = -ENOMEM;
+		v4l2_err(pdev->dev.driver, "Unable to alloc video device\n");
+		goto err_cleanup_ctx;
+	}
+
+	/* initialize field of video device */
+	vfd->release            = video_device_release;
+	vfd->fops               = &bcap_fops;
+	vfd->ioctl_ops          = &bcap_ioctl_ops;
+	vfd->tvnorms            = 0;
+	vfd->v4l2_dev           = &bcap_dev->v4l2_dev;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+	strncpy(vfd->name, CAPTURE_DRV_NAME, sizeof(vfd->name));
+	bcap_dev->video_dev     = vfd;
+
+	ret = v4l2_device_register(&pdev->dev, &bcap_dev->v4l2_dev);
+	if (ret) {
+		v4l2_err(pdev->dev.driver,
+				"Unable to register v4l2 device\n");
+		goto err_release_vdev;
+	}
+	v4l2_info(&bcap_dev->v4l2_dev, "v4l2 device registered\n");
+
+	bcap_dev->v4l2_dev.ctrl_handler = &bcap_dev->ctrl_handler;
+	ret = v4l2_ctrl_handler_init(&bcap_dev->ctrl_handler, 0);
+	if (ret) {
+		v4l2_err(&bcap_dev->v4l2_dev,
+				"Unable to init control handler\n");
+		goto err_unreg_v4l2;
+	}
+
+	spin_lock_init(&bcap_dev->lock);
+	/* initialize queue */
+	q = &bcap_dev->buffer_queue;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP;
+	q->drv_priv = bcap_dev;
+	q->buf_struct_size = sizeof(struct bcap_buffer);
+	q->ops = &bcap_video_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+
+	vb2_queue_init(q);
+
+	mutex_init(&bcap_dev->mutex);
+	init_completion(&bcap_dev->comp);
+
+	/* init video dma queues */
+	INIT_LIST_HEAD(&bcap_dev->dma_queue);
+
+	vfd->lock = &bcap_dev->mutex;
+
+	/* register video device */
+	ret = video_register_device(bcap_dev->video_dev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		v4l2_err(&bcap_dev->v4l2_dev,
+				"Unable to register video device\n");
+		goto err_free_handler;
+	}
+	video_set_drvdata(bcap_dev->video_dev, bcap_dev);
+	v4l2_info(&bcap_dev->v4l2_dev, "video device registered as: %s\n",
+			video_device_node_name(vfd));
+
+	/* load up the subdevice */
+	i2c_adap = i2c_get_adapter(config->i2c_adapter_id);
+	if (!i2c_adap) {
+		v4l2_err(&bcap_dev->v4l2_dev,
+				"Unable to find i2c adapter\n");
+		goto err_unreg_vdev;
+
+	}
+	bcap_dev->sd = v4l2_i2c_new_subdev_board(&bcap_dev->v4l2_dev,
+						 i2c_adap,
+						 &config->board_info,
+						 NULL);
+	if (bcap_dev->sd) {
+		int i;
+		/* update tvnorms from the sub devices */
+		for (i = 0; i < config->num_inputs; i++)
+			vfd->tvnorms |= config->inputs[i].std;
+	} else {
+		v4l2_err(&bcap_dev->v4l2_dev,
+				"Unable to register sub device\n");
+		goto err_unreg_vdev;
+	}
+
+	v4l2_info(&bcap_dev->v4l2_dev, "v4l2 sub device registered\n");
+
+	/* now we can probe the default state */
+	if (vfd->tvnorms) {
+		v4l2_std_id std;
+		ret = v4l2_subdev_call(bcap_dev->sd, core, g_std, &std);
+		if (ret) {
+			v4l2_err(&bcap_dev->v4l2_dev,
+					"Unable to get std\n");
+			goto err_unreg_vdev;
+		}
+		bcap_dev->std = std;
+	}
+	ret = bcap_init_sensor_formats(bcap_dev);
+	if (ret) {
+		v4l2_err(&bcap_dev->v4l2_dev,
+				"Unable to create sensor formats table\n");
+		goto err_unreg_vdev;
+	}
+	return 0;
+err_unreg_vdev:
+	video_unregister_device(bcap_dev->video_dev);
+	bcap_dev->video_dev = NULL;
+err_free_handler:
+	v4l2_ctrl_handler_free(&bcap_dev->ctrl_handler);
+err_unreg_v4l2:
+	v4l2_device_unregister(&bcap_dev->v4l2_dev);
+err_release_vdev:
+	if (bcap_dev->video_dev)
+		video_device_release(bcap_dev->video_dev);
+err_cleanup_ctx:
+	vb2_dma_contig_cleanup_ctx(bcap_dev->alloc_ctx);
+err_free_ppi:
+	ppi_delete_instance(bcap_dev->ppi);
+err_free_dev:
+	kfree(bcap_dev);
+	return ret;
+}
+
+static int __devexit bcap_remove(struct platform_device *pdev)
+{
+	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
+	struct bcap_device *bcap_dev = container_of(v4l2_dev,
+						struct bcap_device, v4l2_dev);
+
+	bcap_free_sensor_formats(bcap_dev);
+	video_unregister_device(bcap_dev->video_dev);
+	v4l2_ctrl_handler_free(&bcap_dev->ctrl_handler);
+	v4l2_device_unregister(v4l2_dev);
+	vb2_dma_contig_cleanup_ctx(bcap_dev->alloc_ctx);
+	ppi_delete_instance(bcap_dev->ppi);
+	kfree(bcap_dev);
+	return 0;
+}
+
+static struct platform_driver bcap_driver = {
+	.driver = {
+		.name  = CAPTURE_DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = bcap_probe,
+	.remove = __devexit_p(bcap_remove),
+};
+
+static __init int bcap_init(void)
+{
+	return platform_driver_register(&bcap_driver);
+}
+
+static __exit void bcap_exit(void)
+{
+	platform_driver_unregister(&bcap_driver);
+}
+
+module_init(bcap_init);
+module_exit(bcap_exit);
+
+MODULE_DESCRIPTION("Analog Devices blackfin video capture driver");
+MODULE_AUTHOR("Scott Jiang <Scott.Jiang.Linux@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/video/blackfin/ppi.c b/drivers/media/video/blackfin/ppi.c
new file mode 100644
index 0000000..d295921
--- /dev/null
+++ b/drivers/media/video/blackfin/ppi.c
@@ -0,0 +1,271 @@
+/*
+ * ppi.c Analog Devices Parallel Peripheral Interface driver
+ *
+ * Copyright (c) 2011 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/slab.h>
+
+#include <asm/bfin_ppi.h>
+#include <asm/blackfin.h>
+#include <asm/cacheflush.h>
+#include <asm/dma.h>
+#include <asm/portmux.h>
+
+#include <media/blackfin/ppi.h>
+
+static int ppi_attach_irq(struct ppi_if *ppi, irq_handler_t handler);
+static void ppi_detach_irq(struct ppi_if *ppi);
+static int ppi_start(struct ppi_if *ppi);
+static int ppi_stop(struct ppi_if *ppi);
+static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params);
+static void ppi_update_addr(struct ppi_if *ppi, unsigned long addr);
+
+static const struct ppi_ops ppi_ops = {
+	.attach_irq = ppi_attach_irq,
+	.detach_irq = ppi_detach_irq,
+	.start = ppi_start,
+	.stop = ppi_stop,
+	.set_params = ppi_set_params,
+	.update_addr = ppi_update_addr,
+};
+
+static irqreturn_t ppi_irq_err(int irq, void *dev_id)
+{
+	struct ppi_if *ppi = dev_id;
+	const struct ppi_info *info = ppi->info;
+
+	switch (info->type) {
+	case PPI_TYPE_PPI:
+	{
+		struct bfin_ppi_regs *reg = info->base;
+		unsigned short status;
+
+		/* register on bf561 is cleared when read 
+		 * others are W1C
+		 */
+		status = bfin_read16(&reg->status);
+		bfin_write16(&reg->status, 0xff00);
+		break;
+	}
+	case PPI_TYPE_EPPI:
+	{
+		struct bfin_eppi_regs *reg = info->base;
+		bfin_write16(&reg->status, 0xffff);
+		break;
+	}
+	default:
+		break;
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int ppi_attach_irq(struct ppi_if *ppi, irq_handler_t handler)
+{
+	const struct ppi_info *info = ppi->info;
+	int ret;
+
+	ret = request_dma(info->dma_ch, "PPI_DMA");
+
+	if (ret) {
+		pr_err("Unable to allocate DMA channel for PPI\n");
+		return ret;
+	}
+	set_dma_callback(info->dma_ch, handler, ppi);
+
+	if (ppi->err_int) {
+		ret = request_irq(info->irq_err, ppi_irq_err, 0, "PPI ERROR", ppi);
+		if (ret) {
+			pr_err("Unable to allocate IRQ for PPI\n");
+			free_dma(info->dma_ch);
+		}
+	}
+	return ret;
+}
+
+static void ppi_detach_irq(struct ppi_if *ppi)
+{
+	const struct ppi_info *info = ppi->info;
+
+	if (ppi->err_int)
+		free_irq(info->irq_err, ppi);
+	free_dma(info->dma_ch);
+}
+
+static int ppi_start(struct ppi_if *ppi)
+{
+	const struct ppi_info *info = ppi->info;
+
+	/* enable DMA */
+	enable_dma(info->dma_ch);
+
+	/* enable PPI */
+	ppi->ppi_control |= PORT_EN;
+	switch (info->type) {
+	case PPI_TYPE_PPI:
+	{
+		struct bfin_ppi_regs *reg = info->base;
+		bfin_write16(&reg->control, ppi->ppi_control);
+		break;
+	}
+	case PPI_TYPE_EPPI:
+	{
+		struct bfin_eppi_regs *reg = info->base;
+		bfin_write32(&reg->control, ppi->ppi_control);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	SSYNC();
+	return 0;
+}
+
+static int ppi_stop(struct ppi_if *ppi)
+{
+	const struct ppi_info *info = ppi->info;
+
+	/* disable PPI */
+	ppi->ppi_control &= ~PORT_EN;
+	switch (info->type) {
+	case PPI_TYPE_PPI:
+	{
+		struct bfin_ppi_regs *reg = info->base;
+		bfin_write16(&reg->control, ppi->ppi_control);
+		break;
+	}
+	case PPI_TYPE_EPPI:
+	{
+		struct bfin_eppi_regs *reg = info->base;
+		bfin_write32(&reg->control, ppi->ppi_control);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	/* disable DMA */
+	clear_dma_irqstat(info->dma_ch);
+	disable_dma(info->dma_ch);
+
+	SSYNC();
+	return 0;
+}
+
+static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
+{
+	const struct ppi_info *info = ppi->info;
+	int dma32 = 0;
+	int dma_config, bytes_per_line, lines_per_frame;
+
+	bytes_per_line = params->width * params->bpp / 8;
+	lines_per_frame = params->height;
+	if (params->int_mask == 0xFFFFFFFF)
+		ppi->err_int = false;
+	else
+		ppi->err_int = true;
+
+	dma_config = (DMA_FLOW_STOP | WNR | RESTART | DMA2D | DI_EN);
+	ppi->ppi_control = params->ppi_control & ~PORT_EN;
+	switch (info->type) {
+	case PPI_TYPE_PPI:
+	{
+		struct bfin_ppi_regs *reg = info->base;
+
+		if (params->ppi_control & DMA32)
+			dma32 = 1;
+
+		bfin_write16(&reg->control, ppi->ppi_control);
+		bfin_write16(&reg->count, bytes_per_line - 1);
+		bfin_write16(&reg->frame, lines_per_frame);
+		break;
+	}
+	case PPI_TYPE_EPPI:
+	{
+		struct bfin_eppi_regs *reg = info->base;
+
+		if ((params->ppi_control & PACK_EN)
+			|| (params->ppi_control & 0x38000) > DLEN_16)
+			dma32 = 1;
+
+		bfin_write32(&reg->control, ppi->ppi_control);
+		bfin_write16(&reg->line, bytes_per_line + params->blank_clocks);
+		bfin_write16(&reg->frame, lines_per_frame);
+		bfin_write16(&reg->hdelay, 0);
+		bfin_write16(&reg->vdelay, 0);
+		bfin_write16(&reg->hcount, bytes_per_line);
+		bfin_write16(&reg->vcount, lines_per_frame);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	if (dma32) {
+		dma_config |= WDSIZE_32;
+		set_dma_x_count(info->dma_ch, bytes_per_line >> 2);
+		set_dma_x_modify(info->dma_ch, 4);
+		set_dma_y_modify(info->dma_ch, 4);
+	} else {
+		dma_config |= WDSIZE_16;
+		set_dma_x_count(info->dma_ch, bytes_per_line >> 1);
+		set_dma_x_modify(info->dma_ch, 2);
+		set_dma_y_modify(info->dma_ch, 2);
+	}
+	set_dma_y_count(info->dma_ch, lines_per_frame);
+	set_dma_config(info->dma_ch, dma_config);
+
+	SSYNC();
+	return 0;
+}
+
+static void ppi_update_addr(struct ppi_if *ppi, unsigned long addr)
+{
+	set_dma_start_addr(ppi->info->dma_ch, addr);
+}
+
+struct ppi_if *ppi_create_instance(const struct ppi_info *info)
+{
+	struct ppi_if *ppi;
+
+	if (!info || !info->pin_req)
+		return NULL;
+
+	if (peripheral_request_list(info->pin_req, KBUILD_MODNAME)) {
+		pr_err("request peripheral failed\n");
+		return NULL;
+	}
+
+	ppi = kzalloc(sizeof(*ppi), GFP_KERNEL);
+	if (!ppi) {
+		peripheral_free_list(info->pin_req);
+		pr_err("unable to allocate memory for ppi handle\n");
+		return NULL;
+	}
+	ppi->ops = &ppi_ops;
+	ppi->info = info;
+
+	pr_info("ppi probe success\n");
+	return ppi;
+}
+
+void ppi_delete_instance(struct ppi_if *ppi)
+{
+	peripheral_free_list(ppi->info->pin_req);
+	kfree(ppi);
+}
diff --git a/include/media/blackfin/bfin_capture.h b/include/media/blackfin/bfin_capture.h
new file mode 100644
index 0000000..2038a8a
--- /dev/null
+++ b/include/media/blackfin/bfin_capture.h
@@ -0,0 +1,37 @@
+#ifndef _BFIN_CAPTURE_H_
+#define _BFIN_CAPTURE_H_
+
+#include <linux/i2c.h>
+
+struct v4l2_input;
+struct ppi_info;
+
+struct bcap_route {
+	u32 input;
+	u32 output;
+};
+
+struct bfin_capture_config {
+	/* card name */
+	char *card_name;
+	/* inputs available at the sub device */
+	struct v4l2_input *inputs;
+	/* number of inputs supported */
+	int num_inputs;
+	/* routing information for each input */
+	struct bcap_route *routes;
+	/* i2c bus adapter no */
+	int i2c_adapter_id;
+	/* i2c subdevice board info */
+	struct i2c_board_info board_info;
+	/* ppi board info */
+	const struct ppi_info *ppi_info;
+	/* ppi control */
+	unsigned long ppi_control;
+	/* ppi interrupt mask */
+	u32 int_mask;
+	/* horizontal blanking clocks */
+	int blank_clocks;
+};
+
+#endif
diff --git a/include/media/blackfin/ppi.h b/include/media/blackfin/ppi.h
new file mode 100644
index 0000000..8f72f8a
--- /dev/null
+++ b/include/media/blackfin/ppi.h
@@ -0,0 +1,74 @@
+/*
+ * Analog Devices PPI header file
+ *
+ * Copyright (c) 2011 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _PPI_H_
+#define _PPI_H_
+
+#include <linux/interrupt.h>
+
+#ifdef EPPI_EN
+#define PORT_EN EPPI_EN
+#define DMA32 0
+#define PACK_EN PACKEN
+#endif
+
+struct ppi_if;
+
+struct ppi_params {
+	int width;
+	int height;
+	int bpp;
+	unsigned long ppi_control;
+	u32 int_mask;
+	int blank_clocks;
+};
+
+struct ppi_ops {
+	int (*attach_irq)(struct ppi_if *ppi, irq_handler_t handler);
+	void (*detach_irq)(struct ppi_if *ppi);
+	int (*start)(struct ppi_if *ppi);
+	int (*stop)(struct ppi_if *ppi);
+	int (*set_params)(struct ppi_if *ppi, struct ppi_params *params);
+	void (*update_addr)(struct ppi_if *ppi, unsigned long addr);
+};
+
+enum ppi_type {
+	PPI_TYPE_PPI,
+	PPI_TYPE_EPPI,
+};
+
+struct ppi_info {
+	enum ppi_type type;
+	int dma_ch;
+	int irq_err;
+	void __iomem *base;
+	const unsigned short *pin_req;
+};
+
+struct ppi_if {
+	unsigned long ppi_control;
+	const struct ppi_ops *ops;
+	const struct ppi_info *info;
+	bool err_int;
+	void *priv;
+};
+
+struct ppi_if *ppi_create_instance(const struct ppi_info *info);
+void ppi_delete_instance(struct ppi_if *ppi);
+#endif
-- 
1.7.0.4


