Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:45084 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755624AbdCGOns (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 09:43:48 -0500
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: CARLOS.PALMINHA@synopsys.com,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Benoit Parrot <bparrot@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Peter Griffin <peter.griffin@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH 4/4] media: platform: dwc: Support for CSI-2 Host video platform
Date: Tue,  7 Mar 2017 14:37:51 +0000
Message-Id: <047a03b285b2b75aec01b82b3cffb58fb47e8339.1488885081.git.roliveir@synopsys.com>
In-Reply-To: <cover.1488885081.git.roliveir@synopsys.com>
References: <cover.1488885081.git.roliveir@synopsys.com>
In-Reply-To: <cover.1488885081.git.roliveir@synopsys.com>
References: <cover.1488885081.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the CSI-2 Host video platform. This platform exists only
 to support the Synopsys DW CSI-2 Host bring-up and debug efforts.

Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
---
 drivers/media/platform/dwc/Kconfig            |  40 ++
 drivers/media/platform/dwc/Makefile           |   2 +
 drivers/media/platform/dwc/csi_video_device.c | 721 +++++++++++++++++++++++
 drivers/media/platform/dwc/csi_video_device.h |  83 +++
 drivers/media/platform/dwc/csi_video_plat.c   | 818 ++++++++++++++++++++++++++
 drivers/media/platform/dwc/csi_video_plat.h   | 101 ++++
 6 files changed, 1765 insertions(+)
 create mode 100644 drivers/media/platform/dwc/csi_video_device.c
 create mode 100644 drivers/media/platform/dwc/csi_video_device.h
 create mode 100644 drivers/media/platform/dwc/csi_video_plat.c
 create mode 100644 drivers/media/platform/dwc/csi_video_plat.h

diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
index 2cd13d23f897..057208ec3e7b 100644
--- a/drivers/media/platform/dwc/Kconfig
+++ b/drivers/media/platform/dwc/Kconfig
@@ -1,5 +1,45 @@
+config CSI_VIDEO_PLATFORM
+	tristate "Designware Cores CSI-2 VIDEO PLATFORM"
+	select DWC_MIPI_CSI2_HOST
+	select CSI_VIDEO_DEVICE
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
+	help
+	  This a V4L2 driver to support the DesignWare Cores CSI-2 Host Video
+	  Platform.
+
+	  To compile this driver as a module, choose M here
+
+if CSI_VIDEO_PLATFORM
+
 config DWC_MIPI_CSI2_HOST
 	tristate "SNPS DWC MIPI CSI2 Host"
 	select GENERIC_PHY
 	help
 	  This is a V4L2 driver for Synopsys Designware MIPI CSI-2 Host.
+
+config CSI_VIDEO_DEVICE
+	tristate "DWC VIDEO DEVICE"
+	depends on CSI_VIDEO_PLATFORM
+	help
+	  This is a V4L2 driver for the CSI-2 Video platform video device
+
+choice
+	prompt "Video Device Videobuf2 mode"
+	depends on CSI_VIDEO_DEVICE
+	default VIDEO_DWC_DMA_CONTIG
+
+config VIDEO_DWC_DMA_CONTIG
+	bool "Support Videobuf2 DMA CONTIG"
+	select VIDEOBUF2_DMA_CONTIG
+	help
+	  Use DMA CONTIG in CSI Video Device
+
+config VIDEO_DWC_VMALLOC
+	bool "Support Videobuf2 VMALLOC"
+	select VIDEOBUF2_VMALLOC
+	help
+	  Use VMALLOC in CSI Video Device
+
+endchoice
+
+endif # CSI2_VIDEO_PLATFORM
diff --git a/drivers/media/platform/dwc/Makefile b/drivers/media/platform/dwc/Makefile
index 5eb076a55123..ab6f76296b34 100644
--- a/drivers/media/platform/dwc/Makefile
+++ b/drivers/media/platform/dwc/Makefile
@@ -1 +1,3 @@
+obj-$(CONFIG_CSI_VIDEO_PLATFORM)	+= csi_video_plat.o
 obj-$(CONFIG_DWC_MIPI_CSI2_HOST)	+= dw_mipi_csi.o
+obj-$(CONFIG_CSI_VIDEO_DEVICE)		+= csi_video_device.o
diff --git a/drivers/media/platform/dwc/csi_video_device.c b/drivers/media/platform/dwc/csi_video_device.c
new file mode 100644
index 000000000000..c319ea6591f3
--- /dev/null
+++ b/drivers/media/platform/dwc/csi_video_device.c
@@ -0,0 +1,721 @@
+/*
+ * CSI-2 Video platform video device device driver
+ *
+ * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
+ * Author: Ramiro Oliveira <ramiro.oliveira@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include "csi_video_device.h"
+
+static const struct plat_csi_fmt vid_dev_formats[] = {
+	{
+		.name = "BGR888",
+		.fourcc = V4L2_PIX_FMT_BGR24,
+		.depth = 24,
+		.mbus_code = MEDIA_BUS_FMT_RGB888_2X12_LE,
+	}, {
+		.name = "RGB565",
+		.fourcc = V4L2_PIX_FMT_RGB565,
+		.depth = 16,
+		.mbus_code = MEDIA_BUS_FMT_RGB565_2X8_BE,
+	},
+};
+
+static const struct plat_csi_fmt *vid_dev_find_format(struct v4l2_format *f)
+{
+	const struct plat_csi_fmt *fmt = NULL;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vid_dev_formats); ++i) {
+		fmt = &vid_dev_formats[i];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			return fmt;
+	}
+	return NULL;
+}
+
+/*
+ * Video node ioctl operations
+ */
+static int
+vidioc_querycap(struct file *file, void *priv, struct v4l2_capability *cap)
+{
+	struct video_device_dev *vid_dev = video_drvdata(file);
+
+	strlcpy(cap->driver, VIDEO_DEVICE_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, VIDEO_DEVICE_NAME, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(&vid_dev->pdev->dev));
+	return 0;
+}
+
+static int
+vidioc_enum_fmt_vid_cap(struct file *file, void *priv, struct v4l2_fmtdesc *f)
+{
+	const struct plat_csi_fmt *p_fmt;
+
+	if (f->index >= ARRAY_SIZE(vid_dev_formats))
+		return -EINVAL;
+
+	p_fmt = &vid_dev_formats[f->index];
+
+	f->pixelformat = p_fmt->fourcc;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct video_device_dev *dev = video_drvdata(file);
+
+	f->fmt.pix = dev->format.fmt.pix;
+
+	return 0;
+}
+
+static int
+vidioc_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f)
+{
+	const struct plat_csi_fmt *fmt;
+
+	fmt = vid_dev_find_format(f);
+	if (!fmt) {
+		f->fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565;
+		fmt = vid_dev_find_format(f);
+	}
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	v4l_bound_align_image(&f->fmt.pix.width, 48, MAX_WIDTH, 2,
+			      &f->fmt.pix.height, 32, MAX_HEIGHT, 0, 0);
+
+	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct video_device_dev *dev = video_drvdata(file);
+	int ret;
+	struct v4l2_subdev_format fmt;
+	struct v4l2_pix_format *dev_fmt_pix = &dev->format.fmt.pix;
+
+	if (vb2_is_busy(&dev->vb_queue))
+		return -EBUSY;
+
+	ret = vidioc_try_fmt_vid_cap(file, dev, f);
+	if (ret)
+		return ret;
+
+	dev->fmt = vid_dev_find_format(f);
+	dev_fmt_pix->pixelformat = f->fmt.pix.pixelformat;
+	dev_fmt_pix->width = f->fmt.pix.width;
+	dev_fmt_pix->height  = f->fmt.pix.height;
+	dev_fmt_pix->bytesperline = dev_fmt_pix->width * (dev->fmt->depth / 8);
+	dev_fmt_pix->sizeimage =
+			dev_fmt_pix->height * dev_fmt_pix->bytesperline;
+
+	fmt.format.colorspace = V4L2_COLORSPACE_SRGB;
+	fmt.format.code = dev->fmt->mbus_code;
+
+	fmt.format.width = dev_fmt_pix->width;
+	fmt.format.height = dev_fmt_pix->height;
+
+	ret = plat_csi_pipeline_call(&dev->ve, set_format, &fmt);
+
+	return 0;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *fh,
+		       struct v4l2_frmsizeenum *fsize)
+{
+	static const struct v4l2_frmsize_stepwise sizes = {
+		48, MAX_WIDTH, 4,
+		32, MAX_HEIGHT, 1
+	};
+	int i;
+
+	if (fsize->index)
+		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(vid_dev_formats); i++)
+		if (vid_dev_formats[i].fourcc == fsize->pixel_format)
+			break;
+	if (i == ARRAY_SIZE(vid_dev_formats))
+		return -EINVAL;
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise = sizes;
+	return 0;
+}
+
+static int vidioc_enum_input(struct file *file, void *priv,
+			struct v4l2_input *input)
+{
+	if (input->index != 0)
+		return -EINVAL;
+
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+	input->std = 0;
+	strcpy(input->name, "Camera");
+
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i != 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int
+vid_dev_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
+{
+	struct video_device_dev *vid_dev = video_drvdata(file);
+	struct media_entity *entity = &vid_dev->ve.vdev.entity;
+	int ret;
+
+	ret = media_pipeline_start(entity, &vid_dev->ve.pipe->mp);
+	if (ret < 0)
+		return ret;
+
+	vb2_ioctl_streamon(file, priv, type);
+	if (!ret)
+		return ret;
+
+	media_pipeline_stop(entity);
+	return 0;
+}
+
+static int
+vid_dev_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
+{
+	struct video_device_dev *vid_dev = video_drvdata(file);
+	int ret;
+
+	ret = vb2_ioctl_streamoff(file, priv, type);
+	if (ret < 0)
+		return ret;
+
+	media_pipeline_stop(&vid_dev->ve.vdev.entity);
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops vid_dev_ioctl_ops = {
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
+	.vidioc_enum_input = vidioc_enum_input,
+	.vidioc_g_input = vidioc_g_input,
+	.vidioc_s_input = vidioc_s_input,
+
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_streamon = vid_dev_streamon,
+	.vidioc_streamoff = vid_dev_streamoff,
+};
+
+static int
+vid_dev_open(struct file *file)
+{
+	struct video_device_dev *vid_dev = video_drvdata(file);
+	struct media_entity *me = &vid_dev->ve.vdev.entity;
+	int ret;
+
+	mutex_lock(&vid_dev->lock);
+
+	ret = v4l2_fh_open(file);
+	if (ret < 0)
+		goto unlock;
+
+	if (!v4l2_fh_is_singular_file(file))
+		goto unlock;
+
+	mutex_lock(&me->graph_obj.mdev->graph_mutex);
+
+	ret = plat_csi_pipeline_call(&vid_dev->ve, open, me, true);
+	if (ret == 0)
+		me->use_count++;
+
+	mutex_unlock(&me->graph_obj.mdev->graph_mutex);
+
+	if (!ret)
+		goto unlock;
+
+	v4l2_fh_release(file);
+unlock:
+	mutex_unlock(&vid_dev->lock);
+	return ret;
+}
+
+static int
+vid_dev_release(struct file *file)
+{
+	struct video_device_dev *vid_dev = video_drvdata(file);
+	struct media_entity *entity = &vid_dev->ve.vdev.entity;
+
+	mutex_lock(&vid_dev->lock);
+
+	if (v4l2_fh_is_singular_file(file)) {
+		plat_csi_pipeline_call(&vid_dev->ve, close);
+		mutex_lock(&entity->graph_obj.mdev->graph_mutex);
+		entity->use_count--;
+		mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
+	}
+
+	_vb2_fop_release(file, NULL);
+
+	mutex_unlock(&vid_dev->lock);
+	return 0;
+}
+
+static const struct v4l2_file_operations vid_dev_fops = {
+	.owner = THIS_MODULE,
+	.open = vid_dev_open,
+	.release = vid_dev_release,
+	.write = vb2_fop_write,
+	.read = vb2_fop_read,
+	.poll = vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = vb2_fop_mmap,
+};
+
+/*
+ * VideoBuffer2 operations
+ */
+#ifdef CONFIG_VIDEO_DWC_DMA_CONTIG
+void fill_buffer(struct video_device_dev *dev, struct rx_buffer *buf,
+			int buf_num, unsigned long flags)
+{
+	buf->vb.field = dev->format.fmt.pix.field;
+	buf->vb.sequence++;
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0,
+		dev->format.fmt.pix.bytesperline*dev->format.fmt.pix.height);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
+}
+#endif
+
+#ifdef CONFIG_VIDEO_DWC_VMALLOC
+static void fill_buffer(struct video_device_dev *dev, struct rx_buffer *buf,
+			int buf_num, unsigned long flags)
+{
+	int size = 0;
+	void *vbuf = NULL;
+
+	if (&buf->vb == NULL)
+		return;
+
+	size = vb2_plane_size(&buf->vb.vb2_buf, 0);
+	vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
+
+	if (vbuf) {
+		spin_unlock_irqrestore(&dev->slock, flags);
+
+		memcpy(vbuf, dev->dma_buf[buf_num].cpu_addr, size);
+
+		spin_lock_irqsave(&dev->slock, flags);
+
+		buf->vb.field = dev->format.fmt.pix.field;
+		buf->vb.sequence++;
+		buf->vb.vb2_buf.timestamp = ktime_get_ns();
+	}
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
+}
+#endif
+
+static void buffer_copy_process(void *param)
+{
+	struct video_device_dev *dev = (struct video_device_dev *) param;
+	unsigned long flags;
+	struct dmaqueue *dma_q = &dev->vidq;
+	struct rx_buffer *buf = NULL;
+
+	spin_lock_irqsave(&dev->slock, flags);
+
+	if (!list_empty(&dma_q->active)) {
+		buf = list_entry(dma_q->active.next, struct rx_buffer, list);
+		list_del(&buf->list);
+		fill_buffer(dev, buf, dev->last_idx, flags);
+	}
+
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+static inline struct rx_buffer *to_rx_buffer(struct vb2_v4l2_buffer *vb2)
+{
+	return container_of(vb2, struct rx_buffer, vb);
+}
+
+static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
+			unsigned int *nplanes, unsigned int sizes[],
+			struct device *alloc_devs[])
+{
+	struct video_device_dev *dev = vb2_get_drv_priv(vq);
+	unsigned long size = 0;
+	int i;
+
+	size = dev->format.fmt.pix.sizeimage;
+	if (size == 0)
+		return -EINVAL;
+
+	*nbuffers = N_BUFFERS;
+#ifdef CONFIG_VIDEO_DWC_VMALLOC
+	for (i = 0; i < N_BUFFERS; i++) {
+		dev->dma_buf[i].cpu_addr = dma_alloc_coherent(&dev->pdev->dev,
+						dev->format.fmt.pix.sizeimage,
+						&dev->dma_buf[i].dma_addr,
+						GFP_KERNEL);
+	}
+#endif
+	*nplanes = 1;
+	sizes[0] = size;
+
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct rx_buffer *buf = to_rx_buffer(vbuf);
+#ifdef CONFIG_VIDEO_DWC_VMALLOC
+	int size = 0;
+
+	if (vb == NULL) {
+		pr_warn("%s:vb2_buffer is null\n", FUNC_NAME);
+		return 0;
+	}
+
+	buf = to_rx_buffer(vbuf);
+
+	size = vb2_plane_size(&buf->vb.vb2_buf, 0);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
+#endif
+	INIT_LIST_HEAD(&buf->list);
+	return 0;
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct video_device_dev *dev = NULL;
+	struct rx_buffer *buf = NULL;
+	struct dmaqueue *vidq = NULL;
+	struct dma_async_tx_descriptor *desc;
+	u32 flags;
+
+	if (vb == NULL) {
+		pr_warn("%s:vb2_buffer is null\n", FUNC_NAME);
+		return;
+	}
+
+	dev = vb2_get_drv_priv(vb->vb2_queue);
+	buf = to_rx_buffer(vbuf);
+	vidq = &dev->vidq;
+
+	flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
+	dev->xt.dir = DMA_DEV_TO_MEM;
+	dev->xt.src_sgl = false;
+	dev->xt.dst_inc = false;
+	dev->xt.dst_sgl = true;
+#ifdef CONFIG_VIDEO_DWC_DMA_CONTIG
+	dev->xt.dst_start = vb2_dma_contig_plane_dma_addr(vb, 0);
+#else
+	dev->xt.dst_start = dev->dma_buf[dev->idx].dma_addr;
+#endif
+	dev->last_idx = dev->idx;
+	dev->idx++;
+	if (dev->idx >= N_BUFFERS)
+		dev->idx = 0;
+
+	dev->xt.frame_size = 1;
+	dev->sgl[0].size = dev->format.fmt.pix.bytesperline;
+	dev->sgl[0].icg = 0;
+	dev->xt.numf = dev->format.fmt.pix.height;
+
+	desc = dmaengine_prep_interleaved_dma(dev->dma, &dev->xt, flags);
+	if (!desc) {
+		pr_err("Failed to prepare DMA transfer\n");
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		return;
+	}
+
+	desc->callback = buffer_copy_process;
+	desc->callback_param = dev;
+
+	spin_lock(&dev->slock);
+	list_add_tail(&buf->list, &vidq->active);
+	spin_unlock(&dev->slock);
+
+	dmaengine_submit(desc);
+
+	if (vb2_is_streaming(&dev->vb_queue))
+		dma_async_issue_pending(dev->dma);
+}
+
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct video_device_dev *dev = vb2_get_drv_priv(vq);
+
+	dma_async_issue_pending(dev->dma);
+
+	return 0;
+}
+
+static void stop_streaming(struct vb2_queue *vq)
+{
+	struct video_device_dev *dev = vb2_get_drv_priv(vq);
+	struct dmaqueue *dma_q = &dev->vidq;
+
+	/* Stop and reset the DMA engine. */
+	dmaengine_terminate_all(dev->dma);
+
+	while (!list_empty(&dma_q->active)) {
+		struct rx_buffer *buf;
+
+		buf = list_entry(dma_q->active.next, struct rx_buffer, list);
+		if (buf) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		}
+	}
+	list_del_init(&dev->vidq.active);
+}
+
+static const struct vb2_ops vb2_video_qops = {
+	.queue_setup = queue_setup,
+	.buf_prepare = buffer_prepare,
+	.buf_queue = buffer_queue,
+	.start_streaming = start_streaming,
+	.stop_streaming = stop_streaming,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+};
+
+static int vid_dev_subdev_registered(struct v4l2_subdev *sd)
+{
+	struct video_device_dev *vid_dev = v4l2_get_subdevdata(sd);
+	struct vb2_queue *q = &vid_dev->vb_queue;
+	struct video_device *vfd = &vid_dev->ve.vdev;
+	int ret;
+
+	memset(vfd, 0, sizeof(*vfd));
+
+	strlcpy(vfd->name, VIDEO_DEVICE_NAME, sizeof(vfd->name));
+
+	vfd->fops = &vid_dev_fops;
+	vfd->ioctl_ops = &vid_dev_ioctl_ops;
+	vfd->v4l2_dev = sd->v4l2_dev;
+	vfd->minor = -1;
+	vfd->release = video_device_release_empty;
+	vfd->queue = q;
+	vfd->device_caps	= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
+
+
+	INIT_LIST_HEAD(&vid_dev->vidq.active);
+	init_waitqueue_head(&vid_dev->vidq.wq);
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+
+	q->ops = &vb2_video_qops;
+#ifdef CONFIG_VIDEO_DWC_DMA_CONTIG
+	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
+	q->mem_ops = &vb2_dma_contig_memops;
+#else
+	q->mem_ops = &vb2_vmalloc_memops;
+	q->io_modes = VB2_MMAP | VB2_USERPTR |  VB2_READ;
+#endif
+	q->buf_struct_size = sizeof(struct rx_buffer);
+	q->drv_priv = vid_dev;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &vid_dev->lock;
+	q->dev = &vid_dev->pdev->dev;
+
+	ret = vb2_queue_init(q);
+	if (ret < 0)
+		return ret;
+
+	vid_dev->vd_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_pads_init(&vfd->entity, 1, &vid_dev->vd_pad);
+	if (ret < 0)
+		return ret;
+
+	video_set_drvdata(vfd, vid_dev);
+	vid_dev->ve.pipe = v4l2_get_subdev_hostdata(sd);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		media_entity_cleanup(&vfd->entity);
+		vid_dev->ve.pipe = NULL;
+		return ret;
+	}
+
+	v4l2_info(sd->v4l2_dev, "Registered %s as /dev/%s\n",
+		  vfd->name, video_device_node_name(vfd));
+	return 0;
+}
+
+static void vid_dev_subdev_unregistered(struct v4l2_subdev *sd)
+{
+	struct video_device_dev *vid_dev = v4l2_get_subdevdata(sd);
+
+	if (vid_dev == NULL)
+		return;
+
+	mutex_lock(&vid_dev->lock);
+
+	if (video_is_registered(&vid_dev->ve.vdev)) {
+		video_unregister_device(&vid_dev->ve.vdev);
+		media_entity_cleanup(&vid_dev->ve.vdev.entity);
+		vid_dev->ve.pipe = NULL;
+	}
+
+	mutex_unlock(&vid_dev->lock);
+}
+
+static const struct v4l2_subdev_internal_ops vid_dev_subdev_internal_ops = {
+	.registered = vid_dev_subdev_registered,
+	.unregistered = vid_dev_subdev_unregistered,
+};
+
+static struct v4l2_subdev_ops vid_dev_subdev_ops;
+
+static int vid_dev_create_capture_subdev(struct video_device_dev *vid_dev)
+{
+	struct v4l2_subdev *sd = &vid_dev->subdev;
+	int ret;
+
+	v4l2_subdev_init(sd, &vid_dev_subdev_ops);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), "Capture device");
+
+	vid_dev->subdev_pads[VIDEO_DEV_SD_PAD_SINK_CSI].flags =
+		MEDIA_PAD_FL_SOURCE;
+	vid_dev->subdev_pads[VIDEO_DEV_SD_PAD_SOURCE_DMA].flags =
+		MEDIA_PAD_FL_SINK;
+	ret = media_entity_pads_init(&sd->entity, VIDEO_DEV_SD_PADS_NUM,
+				   vid_dev->subdev_pads);
+	if (ret)
+		return ret;
+
+	sd->internal_ops = &vid_dev_subdev_internal_ops;
+	sd->owner = THIS_MODULE;
+	v4l2_set_subdevdata(sd, vid_dev);
+
+	return 0;
+}
+
+static void vid_dev_unregister_subdev(struct video_device_dev *vid_dev)
+{
+	struct v4l2_subdev *sd = &vid_dev->subdev;
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_set_subdevdata(sd, NULL);
+}
+
+static const struct of_device_id vid_dev_of_match[];
+
+static int vid_dev_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *of_id;
+	int ret = 0;
+	struct video_device_dev *vid_dev;
+
+	dev_dbg(dev, "Installing CSI Video Platform Video Device module\n");
+
+	if (!dev->of_node)
+		return -ENODEV;
+
+	vid_dev = devm_kzalloc(dev, sizeof(*vid_dev), GFP_KERNEL);
+	if (!vid_dev)
+		return -ENOMEM;
+
+	of_id = of_match_node(vid_dev_of_match, dev->of_node);
+	if (WARN_ON(of_id == NULL))
+		return -EINVAL;
+
+	vid_dev->pdev = pdev;
+
+	spin_lock_init(&vid_dev->slock);
+	mutex_init(&vid_dev->lock);
+
+	dev_dbg(&pdev->dev, "Requesting DMA\n");
+	vid_dev->dma = dma_request_slave_channel(&pdev->dev, "vdma0");
+	if (vid_dev->dma == NULL) {
+		dev_err(&pdev->dev, "no VDMA channel found\n");
+		ret = -ENODEV;
+		goto end;
+	}
+
+	ret = vid_dev_create_capture_subdev(vid_dev);
+	if (ret)
+		goto end;
+
+	platform_set_drvdata(pdev, vid_dev);
+#ifdef CONFIG_VIDEO_DWC_DMA_CONTIG
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
+	dev_info(dev, "VIDEOBUF2 DMA CONTIG\n");
+#else
+	dev_info(dev, "VIDEOBUF2 VMALLOC\n");
+#endif
+	dev_info(dev, "Video Device registered successfully\n");
+	return 0;
+end:
+	dev_err(dev, "Video Device not registered!!\n");
+	return ret;
+}
+
+static int vid_dev_remove(struct platform_device *pdev)
+{
+	struct video_device_dev *dev = platform_get_drvdata(pdev);
+
+	vid_dev_unregister_subdev(dev);
+	dev_info(&pdev->dev, "Driver removed\n");
+
+	return 0;
+}
+
+static const struct of_device_id vid_dev_of_match[] = {
+	{.compatible = "snps,video-device"},
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, vid_dev_of_match);
+
+static struct platform_driver __refdata vid_dev_pdrv = {
+	.remove = vid_dev_remove,
+	.probe = vid_dev_probe,
+	.driver = {
+		   .name = VIDEO_DEVICE_NAME,
+		   .owner = THIS_MODULE,
+		   .of_match_table = vid_dev_of_match,
+		   },
+};
+
+module_platform_driver(vid_dev_pdrv);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
+MODULE_DESCRIPTION("Driver for configuring DMA and Video Device");
diff --git a/drivers/media/platform/dwc/csi_video_device.h b/drivers/media/platform/dwc/csi_video_device.h
new file mode 100644
index 000000000000..c924b106ef7b
--- /dev/null
+++ b/drivers/media/platform/dwc/csi_video_device.h
@@ -0,0 +1,83 @@
+/*
+ * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef VIDEO_DEVICE_H_
+#define VIDEO_DEVICE_H_
+
+#include <linux/delay.h>
+#include <linux/dma/xilinx_dma.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/wait.h>
+#include <media/dwc/csi_host_platform.h>
+#include <media/media-entity.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-vmalloc.h>
+#include <media/videobuf2-dma-contig.h>
+
+#define N_BUFFERS 3
+
+#define VIDEO_DEVICE_NAME	"video-device"
+
+#define FUNC_NAME __func__
+
+struct rx_buffer {
+	/** @short Buffer for video frames */
+	struct vb2_v4l2_buffer vb;
+	struct list_head list;
+
+	dma_addr_t dma_addr;
+	void *cpu_addr;
+};
+
+struct dmaqueue {
+	struct list_head active;
+	wait_queue_head_t wq;
+};
+
+/**
+ * @short Structure to embed device driver information
+ */
+struct video_device_dev {
+	struct platform_device *pdev;
+	struct v4l2_device *v4l2_dev;
+	struct v4l2_subdev subdev;
+	struct media_pad vd_pad;
+	struct media_pad subdev_pads[VIDEO_DEV_SD_PADS_NUM];
+	struct mutex lock;
+	spinlock_t slock;
+	struct plat_csi_video_entity ve;
+	struct v4l2_format format;
+	struct v4l2_pix_format pix_format;
+	const struct plat_csi_fmt *fmt;
+	unsigned long *alloc_ctx;
+
+	/* Buffer and DMA */
+	struct vb2_queue vb_queue;
+	int idx;
+	int last_idx;
+	struct dmaqueue vidq;
+	struct rx_buffer dma_buf[N_BUFFERS];
+	struct dma_chan *dma;
+	struct dma_interleaved_template xt;
+	struct data_chunk sgl[1];
+};
+
+#endif				/* VIDEO_DEVICE_H_ */
diff --git a/drivers/media/platform/dwc/csi_video_plat.c b/drivers/media/platform/dwc/csi_video_plat.c
new file mode 100644
index 000000000000..5bbab1a7c8bc
--- /dev/null
+++ b/drivers/media/platform/dwc/csi_video_plat.c
@@ -0,0 +1,818 @@
+/**
+ * DWC MIPI CSI-2 Host Video Platform device driver
+ *
+ * Based on S5P/EXYNOS4 SoC series camera host interface media device Driver
+ * Copyright (C) 2011 - 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
+ * Author: Ramiro Oliveira <ramiro.oliveira@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include "csi_video_plat.h"
+
+static int
+__plat_csi_pipeline_s_format(struct plat_csi_media_pipeline *ep,
+			     struct v4l2_subdev_format *fmt)
+{
+
+	struct plat_csi_pipeline *p = to_plat_csi_pipeline(ep);
+	static const u8 seq[IDX_MAX] = {IDX_SENSOR, IDX_CSI, IDX_VDEV};
+
+	fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	v4l2_subdev_call(p->subdevs[seq[IDX_CSI]], pad, set_fmt, NULL, fmt);
+
+	return 0;
+}
+
+static void
+plat_csi_pipeline_prepare(struct plat_csi_pipeline *p, struct media_entity *me)
+{
+	struct v4l2_subdev *sd;
+	unsigned int i = 0;
+
+	for (i = 0; i < IDX_MAX; i++)
+		p->subdevs[i] = NULL;
+
+	while (1) {
+		struct media_pad *pad = NULL;
+
+		for (i = 0; i < me->num_pads; i++) {
+			struct media_pad *spad = &me->pads[i];
+
+			if (!(spad->flags & MEDIA_PAD_FL_SINK))
+				continue;
+
+			pad = media_entity_remote_pad(spad);
+			if (pad)
+				break;
+		}
+		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+			break;
+
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+
+		switch (sd->grp_id) {
+		case GRP_ID_SENSOR:
+			p->subdevs[IDX_SENSOR] = sd;
+			break;
+		case GRP_ID_CSI:
+			p->subdevs[IDX_CSI] = sd;
+			break;
+		case GRP_ID_VIDEODEV:
+			p->subdevs[IDX_VDEV] = sd;
+			break;
+		default:
+			break;
+		}
+		me = &sd->entity;
+		if (me->num_pads == 1)
+			break;
+	}
+}
+
+static int __subdev_set_power(struct v4l2_subdev *sd, int on)
+{
+	int *use_count;
+	int ret;
+
+	if (sd == NULL) {
+		pr_err("null subdev\n");
+		return -ENXIO;
+	}
+	use_count = &sd->entity.use_count;
+	if (on && (*use_count)++ > 0)
+		return 0;
+	else if (!on && (*use_count == 0 || --(*use_count) > 0))
+		return 0;
+
+	ret = v4l2_subdev_call(sd, core, s_power, on);
+
+	return ret != -ENOIOCTLCMD ? ret : 0;
+}
+
+static int plat_csi_pipeline_s_power(struct plat_csi_pipeline *p, bool on)
+{
+	static const u8 seq[IDX_MAX] = {IDX_CSI, IDX_SENSOR, IDX_VDEV};
+	int i, ret = 0;
+
+	for (i = 0; i < IDX_MAX; i++) {
+		unsigned int idx = seq[i];
+
+		if (p->subdevs[idx] == NULL)
+			pr_info("No device registered on %d\n", idx);
+		else {
+			ret = __subdev_set_power(p->subdevs[idx], on);
+			if (ret < 0 && ret != -ENXIO)
+				goto error;
+		}
+	}
+	return 0;
+error:
+	for (; i >= 0; i--) {
+		unsigned int idx = seq[i];
+
+		__subdev_set_power(p->subdevs[idx], !on);
+	}
+	return ret;
+}
+
+static int
+__plat_csi_pipeline_open(struct plat_csi_media_pipeline *ep,
+			 struct media_entity *me, bool prepare)
+{
+	struct plat_csi_pipeline *p = to_plat_csi_pipeline(ep);
+	int ret;
+
+	if (WARN_ON(p == NULL || me == NULL))
+		return -EINVAL;
+
+	if (prepare)
+		plat_csi_pipeline_prepare(p, me);
+
+	ret = plat_csi_pipeline_s_power(p, 1);
+	if (!ret)
+		return 0;
+
+	return ret;
+}
+
+static int __plat_csi_pipeline_close(struct plat_csi_media_pipeline *ep)
+{
+	struct plat_csi_pipeline *p = to_plat_csi_pipeline(ep);
+	int ret;
+
+	ret = plat_csi_pipeline_s_power(p, 0);
+
+	return ret == -ENXIO ? 0 : ret;
+}
+
+static int
+__plat_csi_pipeline_s_stream(struct plat_csi_media_pipeline *ep, bool on)
+{
+	static const u8 seq[IDX_MAX] = {IDX_SENSOR, IDX_CSI, IDX_VDEV};
+	struct plat_csi_pipeline *p = to_plat_csi_pipeline(ep);
+	int i, ret = 0;
+
+	for (i = 0; i < IDX_MAX; i++) {
+		unsigned int idx = seq[i];
+
+		if (p->subdevs[idx] == NULL)
+			pr_debug("No device registered on %d\n", idx);
+		else {
+			ret =
+			    v4l2_subdev_call(p->subdevs[idx], video, s_stream,
+					     on);
+
+			if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+				goto error;
+		}
+	}
+	return 0;
+error:
+	for (; i >= 0; i--) {
+		unsigned int idx = seq[i];
+
+		v4l2_subdev_call(p->subdevs[idx], video, s_stream, !on);
+	}
+	return ret;
+}
+
+static const struct plat_csi_media_pipeline_ops plat_csi_pipeline_ops = {
+	.open = __plat_csi_pipeline_open,
+	.close = __plat_csi_pipeline_close,
+	.set_format = __plat_csi_pipeline_s_format,
+	.set_stream = __plat_csi_pipeline_s_stream,
+};
+
+static struct plat_csi_media_pipeline *
+plat_csi_pipeline_create(struct plat_csi_dev *plat_csi)
+{
+	struct plat_csi_pipeline *p;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return NULL;
+
+	list_add_tail(&p->list, &plat_csi->pipelines);
+
+	p->ep.ops = &plat_csi_pipeline_ops;
+	return &p->ep;
+}
+
+static void
+plat_csi_pipelines_free(struct plat_csi_dev *plat_csi)
+{
+	while (!list_empty(&plat_csi->pipelines)) {
+		struct plat_csi_pipeline *p;
+
+		p = list_entry(plat_csi->pipelines.next, typeof(*p), list);
+		list_del(&p->list);
+		kfree(p);
+	}
+}
+
+static int
+plat_csi_parse_port_node(struct plat_csi_dev *plat_csi,
+			 struct device_node *port, unsigned int index)
+{
+	struct device_node *rem, *ep;
+	struct v4l2_of_endpoint endpoint;
+	struct plat_csi_source_info *pd = &plat_csi->sensor[index].pdata;
+
+	/* Assume here a port node can have only one endpoint node. */
+	ep = of_get_next_child(port, NULL);
+	if (!ep)
+		return 0;
+
+	v4l2_of_parse_endpoint(ep, &endpoint);
+	if (WARN_ON(endpoint.base.port == 0) || index >= PLAT_MAX_SENSORS)
+		return -EINVAL;
+
+	pd->mux_id = endpoint.base.port - 1;
+
+	rem = of_graph_get_remote_port_parent(ep);
+	of_node_put(ep);
+	if (rem == NULL) {
+		dev_info(plat_csi->dev,
+			  "Remote device at %s not found\n", ep->full_name);
+		return 0;
+	}
+
+	if (WARN_ON(index >= ARRAY_SIZE(plat_csi->sensor)))
+		return -EINVAL;
+
+	plat_csi->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_OF;
+	plat_csi->sensor[index].asd.match.of.node = rem;
+	plat_csi->async_subdevs[index] = &plat_csi->sensor[index].asd;
+
+	plat_csi->num_sensors++;
+
+	of_node_put(rem);
+	return 0;
+}
+
+
+static int plat_csi_register_sensor_entities(struct plat_csi_dev *plat_csi)
+{
+	struct device_node *parent = plat_csi->pdev->dev.of_node;
+	struct device_node *node;
+	int index = 0;
+	int ret;
+
+	plat_csi->num_sensors = 0;
+
+	for_each_available_child_of_node(parent, node) {
+		struct device_node *port;
+
+		if (of_node_cmp(node->name, "csi2"))
+			continue;
+		port = of_get_next_child(node, NULL);
+		if (!port)
+			continue;
+
+		ret = plat_csi_parse_port_node(plat_csi, port, index);
+		if (ret < 0)
+			return ret;
+		index++;
+	}
+	return 0;
+}
+
+static int
+__of_get_port_id(struct device_node *np)
+{
+	u32 reg = 0;
+
+	np = of_get_child_by_name(np, "port");
+	if (!np)
+		return -EINVAL;
+	of_property_read_u32(np, "reg", &reg);
+
+	return reg - 1;
+}
+
+static int register_videodev_entity(struct plat_csi_dev *plat_csi,
+			 struct video_device_dev *vid_dev)
+{
+	struct v4l2_subdev *sd;
+	struct plat_csi_media_pipeline *ep;
+	int ret;
+
+	sd = &vid_dev->subdev;
+	sd->grp_id = GRP_ID_VIDEODEV;
+
+	ep = plat_csi_pipeline_create(plat_csi);
+	if (!ep)
+		return -ENOMEM;
+
+	v4l2_set_subdev_hostdata(sd, ep);
+
+	ret = v4l2_device_register_subdev(&plat_csi->v4l2_dev, sd);
+	if (!ret)
+		plat_csi->vid_dev = vid_dev;
+	else
+		v4l2_err(&plat_csi->v4l2_dev,
+			 "Failed to register Video Device\n");
+	return ret;
+}
+
+static int register_mipi_csi_entity(struct plat_csi_dev *plat_csi,
+			 struct platform_device *pdev, struct v4l2_subdev *sd)
+{
+	struct device_node *node = pdev->dev.of_node;
+	int id, ret;
+
+	id = node ? __of_get_port_id(node) : max(0, pdev->id);
+
+	if (WARN_ON(id < 0 || id >= CSI_MAX_ENTITIES))
+		return -ENOENT;
+
+	if (WARN_ON(plat_csi->mipi_csi[id].sd))
+		return -EBUSY;
+
+	sd->grp_id = GRP_ID_CSI;
+	ret = v4l2_device_register_subdev(&plat_csi->v4l2_dev, sd);
+
+	if (!ret)
+		plat_csi->mipi_csi[id].sd = sd;
+	else
+		v4l2_err(&plat_csi->v4l2_dev,
+			 "Failed to register MIPI-CSI.%d (%d)\n", id, ret);
+	return ret;
+}
+
+static int plat_csi_register_platform_entity(struct plat_csi_dev *plat_csi,
+				struct platform_device *pdev, int plat_entity)
+{
+	struct device *dev = &pdev->dev;
+	int ret = -EPROBE_DEFER;
+	void *drvdata;
+
+	device_lock(dev);
+	if (!dev->driver || !try_module_get(dev->driver->owner))
+		goto dev_unlock;
+
+	drvdata = dev_get_drvdata(dev);
+
+	if (drvdata) {
+		switch (plat_entity) {
+		case IDX_VDEV:
+			ret = register_videodev_entity(plat_csi, drvdata);
+			break;
+		case IDX_CSI:
+			ret = register_mipi_csi_entity(plat_csi, pdev, drvdata);
+			break;
+		default:
+			ret = -ENODEV;
+		}
+	} else
+		dev_err(plat_csi->dev, "%s no drvdata\n", dev_name(dev));
+	module_put(dev->driver->owner);
+dev_unlock:
+	device_unlock(dev);
+	if (ret == -EPROBE_DEFER)
+		dev_info(plat_csi->dev,
+			 "deferring %s device registration\n", dev_name(dev));
+	else if (ret < 0)
+		dev_err(plat_csi->dev,
+			"%s device registration failed (%d)\n", dev_name(dev),
+			ret);
+	return ret;
+}
+
+static int
+plat_csi_register_platform_entities(struct plat_csi_dev *plat_csi,
+				    struct device_node *parent)
+{
+	struct device_node *node;
+	int ret = 0;
+
+	for_each_available_child_of_node(parent, node) {
+		struct platform_device *pdev;
+		int plat_entity = -1;
+
+		pdev = of_find_device_by_node(node);
+		if (!pdev)
+			continue;
+
+		if (!strcmp(node->name, VIDEODEV_OF_NODE_NAME))
+			plat_entity = IDX_VDEV;
+		else if (!strcmp(node->name, CSI_OF_NODE_NAME))
+			plat_entity = IDX_CSI;
+
+		if (plat_entity >= 0)
+			ret = plat_csi_register_platform_entity(plat_csi, pdev,
+								plat_entity);
+		put_device(&pdev->dev);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+static void
+plat_csi_unregister_entities(struct plat_csi_dev *plat_csi)
+{
+	int i;
+	struct video_device_dev *dev = plat_csi->vid_dev;
+
+	if (dev == NULL)
+		return;
+	v4l2_device_unregister_subdev(&dev->subdev);
+	dev->ve.pipe = NULL;
+	plat_csi->vid_dev = NULL;
+
+	for (i = 0; i < CSI_MAX_ENTITIES; i++) {
+		if (plat_csi->mipi_csi[i].sd == NULL)
+			continue;
+		v4l2_device_unregister_subdev(plat_csi->mipi_csi[i].sd);
+		plat_csi->mipi_csi[i].sd = NULL;
+	}
+
+	dev_info(plat_csi->dev, "Unregistered all entities\n");
+}
+
+static int
+__plat_csi_create_videodev_sink_links(struct plat_csi_dev *plat_csi,
+				      struct media_entity *source,
+				      int pad)
+{
+	struct media_entity *sink;
+	int ret = 0;
+
+	if (!plat_csi->vid_dev)
+		return 0;
+
+	sink = &plat_csi->vid_dev->subdev.entity;
+	ret = media_create_pad_link(source, pad, sink,
+				    CSI_PAD_SOURCE, MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		return ret;
+
+	dev_dbg(plat_csi->dev, "created link [%s] -> [%s]\n",
+		  source->name, sink->name);
+
+	return 0;
+}
+
+
+static int
+__plat_csi_create_videodev_source_links(struct plat_csi_dev *plat_csi)
+{
+	struct media_entity *source, *sink;
+	int ret = 0;
+
+	struct video_device_dev *vid_dev = plat_csi->vid_dev;
+
+	if (vid_dev == NULL)
+		return -ENODEV;
+
+	source = &vid_dev->subdev.entity;
+	sink = &vid_dev->ve.vdev.entity;
+
+	ret = media_create_pad_link(source, VIDEO_DEV_SD_PAD_SOURCE_DMA,
+				    sink, 0, MEDIA_LNK_FL_ENABLED);
+
+	dev_dbg(plat_csi->dev, "created link [%s] -> [%s]\n",
+		  source->name, sink->name);
+	return ret;
+}
+
+static int
+plat_csi_create_links(struct plat_csi_dev *plat_csi)
+{
+	struct v4l2_subdev *csi_sensor[CSI_MAX_ENTITIES] = { NULL };
+	struct v4l2_subdev *sensor, *csi;
+	struct media_entity *source;
+	struct plat_csi_source_info *pdata;
+	int i, pad, ret = 0;
+
+	for (i = 0; i < plat_csi->num_sensors; i++) {
+		if (plat_csi->sensor[i].subdev == NULL)
+			continue;
+
+		sensor = plat_csi->sensor[i].subdev;
+		pdata = v4l2_get_subdev_hostdata(sensor);
+		if (!pdata)
+			continue;
+
+		source = NULL;
+
+		csi = plat_csi->mipi_csi[pdata->mux_id].sd;
+		if (WARN(csi == NULL, "dw-mipi-csi module is not loaded!\n"))
+			return -EINVAL;
+
+		pad = sensor->entity.num_pads - 1;
+		ret = media_create_pad_link(&sensor->entity, pad,
+					    &csi->entity, CSI_PAD_SINK,
+					    MEDIA_LNK_FL_IMMUTABLE |
+					    MEDIA_LNK_FL_ENABLED);
+
+		if (ret)
+			return ret;
+		dev_dbg(plat_csi->dev, "created link [%s] -> [%s]\n",
+			  sensor->entity.name, csi->entity.name);
+
+		csi_sensor[pdata->mux_id] = sensor;
+	}
+
+	for (i = 0; i < CSI_MAX_ENTITIES; i++) {
+		if (plat_csi->mipi_csi[i].sd == NULL) {
+			dev_info(plat_csi->dev, "no link\n");
+			continue;
+		}
+
+		source = &plat_csi->mipi_csi[i].sd->entity;
+		pad = VIDEO_DEV_SD_PAD_SINK_CSI;
+
+		ret = __plat_csi_create_videodev_sink_links(plat_csi, source,
+								pad);
+	}
+
+	ret = __plat_csi_create_videodev_source_links(plat_csi);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
+static int __plat_csi_modify_pipeline(struct media_entity *entity, bool enable)
+{
+	struct plat_csi_video_entity *ve;
+	struct plat_csi_pipeline *p;
+	struct video_device *vdev;
+	int ret;
+
+	vdev = media_entity_to_video_device(entity);
+
+	if (vdev->entity.use_count == 0)
+		return 0;
+
+	ve = vdev_to_plat_csi_video_entity(vdev);
+	p = to_plat_csi_pipeline(ve->pipe);
+
+	if (enable)
+		ret = __plat_csi_pipeline_open(ve->pipe, entity, true);
+	else
+		ret = __plat_csi_pipeline_close(ve->pipe);
+
+	if (ret == 0 && !enable)
+		memset(p->subdevs, 0, sizeof(p->subdevs));
+
+	return ret;
+}
+
+
+static int
+__plat_csi_modify_pipelines(struct media_entity *entity, bool enable,
+			    struct media_graph *graph)
+{
+	struct media_entity *entity_err = entity;
+	int ret;
+
+	media_graph_walk_start(graph, entity);
+
+	while ((entity = media_graph_walk_next(graph))) {
+		if (!is_media_entity_v4l2_video_device(entity))
+			continue;
+
+		ret = __plat_csi_modify_pipeline(entity, enable);
+
+		if (ret < 0)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	media_graph_walk_start(graph, entity_err);
+
+	while ((entity_err = media_graph_walk_next(graph))) {
+		if (!is_media_entity_v4l2_video_device(entity_err))
+			continue;
+
+		__plat_csi_modify_pipeline(entity_err, !enable);
+
+		if (entity_err == entity)
+			break;
+	}
+
+	return ret;
+}
+
+static int
+plat_csi_link_notify(struct media_link *link, unsigned int flags,
+		     unsigned int notification)
+{
+	struct media_graph *graph =
+	    &container_of(link->graph_obj.mdev, struct plat_csi_dev,
+			  media_dev)->link_setup_graph;
+	struct media_entity *sink = link->sink->entity;
+	int ret = 0;
+
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
+		ret = media_graph_walk_init(graph, link->graph_obj.mdev);
+		if (ret)
+			return ret;
+		if (!(flags & MEDIA_LNK_FL_ENABLED))
+			ret = __plat_csi_modify_pipelines(sink, false, graph);
+
+	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH) {
+		if (link->flags & MEDIA_LNK_FL_ENABLED)
+			ret = __plat_csi_modify_pipelines(sink, true, graph);
+		media_graph_walk_cleanup(graph);
+	}
+
+	return ret ? -EPIPE : 0;
+}
+
+static const struct media_device_ops plat_csi_media_ops = {
+	.link_notify = plat_csi_link_notify,
+};
+
+
+static int
+subdev_notifier_bound(struct v4l2_async_notifier *notifier,
+		      struct v4l2_subdev *subdev, struct v4l2_async_subdev *asd)
+{
+	struct plat_csi_dev *plat_csi = notifier_to_plat_csi(notifier);
+	struct plat_csi_sensor_info *si = NULL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(plat_csi->sensor); i++)
+		if (plat_csi->sensor[i].asd.match.of.node ==
+		    subdev->dev->of_node)
+			si = &plat_csi->sensor[i];
+
+	if (si == NULL)
+		return -EINVAL;
+
+	v4l2_set_subdev_hostdata(subdev, &si->pdata);
+
+	subdev->grp_id = GRP_ID_SENSOR;
+
+	si->subdev = subdev;
+
+	dev_dbg(&plat_csi->pdev->dev, "Registered sensor subdevice: %s (%d)\n",
+		  subdev->name, plat_csi->num_sensors);
+
+	plat_csi->num_sensors++;
+
+	return 0;
+}
+
+static int
+subdev_notifier_complete(struct v4l2_async_notifier *notifier)
+{
+	struct plat_csi_dev *plat_csi = notifier_to_plat_csi(notifier);
+	int ret;
+
+	mutex_lock(&plat_csi->media_dev.graph_mutex);
+
+	ret = plat_csi_create_links(plat_csi);
+	if (ret < 0)
+		goto unlock;
+
+	ret = v4l2_device_register_subdev_nodes(&plat_csi->v4l2_dev);
+unlock:
+	mutex_unlock(&plat_csi->media_dev.graph_mutex);
+	if (ret < 0)
+		return ret;
+
+	return media_device_register(&plat_csi->media_dev);
+}
+
+static int plat_csi_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct v4l2_device *v4l2_dev;
+	struct plat_csi_dev *plat_csi;
+	int ret;
+
+	dev_dbg(dev, "Installing CSI Video Platform module\n");
+
+	plat_csi = devm_kzalloc(dev, sizeof(*plat_csi), GFP_KERNEL);
+	if (!plat_csi)
+		return -ENOMEM;
+
+	spin_lock_init(&plat_csi->slock);
+	INIT_LIST_HEAD(&plat_csi->pipelines);
+	plat_csi->pdev = pdev;
+
+	strlcpy(plat_csi->media_dev.model, "CSI Video Platform",
+		sizeof(plat_csi->media_dev.model));
+	plat_csi->media_dev.ops = &plat_csi_media_ops;
+	plat_csi->media_dev.dev = dev;
+
+	v4l2_dev = &plat_csi->v4l2_dev;
+	v4l2_dev->mdev = &plat_csi->media_dev;
+	strlcpy(v4l2_dev->name, "plat-csi", sizeof(v4l2_dev->name));
+
+	media_device_init(&plat_csi->media_dev);
+
+	ret = v4l2_device_register(dev, &plat_csi->v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, plat_csi);
+
+	ret = plat_csi_register_platform_entities(plat_csi, dev->of_node);
+	if (ret)
+		goto err_m_ent;
+
+	ret = plat_csi_register_sensor_entities(plat_csi);
+	if (ret)
+		goto err_m_ent;
+
+	if (plat_csi->num_sensors > 0) {
+		plat_csi->subdev_notifier.subdevs = plat_csi->async_subdevs;
+		plat_csi->subdev_notifier.num_subdevs = plat_csi->num_sensors;
+		plat_csi->subdev_notifier.bound = subdev_notifier_bound;
+		plat_csi->subdev_notifier.complete = subdev_notifier_complete;
+		plat_csi->num_sensors = 0;
+
+		ret = v4l2_async_notifier_register(&plat_csi->v4l2_dev,
+						   &plat_csi->subdev_notifier);
+		if (ret)
+			goto err_m_ent;
+	}
+
+	return 0;
+
+err_m_ent:
+	plat_csi_unregister_entities(plat_csi);
+	media_device_unregister(&plat_csi->media_dev);
+	media_device_cleanup(&plat_csi->media_dev);
+	v4l2_device_unregister(&plat_csi->v4l2_dev);
+	return ret;
+}
+
+static int plat_csi_remove(struct platform_device *pdev)
+{
+	struct plat_csi_dev *dev = platform_get_drvdata(pdev);
+
+	v4l2_async_notifier_unregister(&dev->subdev_notifier);
+
+	v4l2_device_unregister(&dev->v4l2_dev);
+	plat_csi_unregister_entities(dev);
+	plat_csi_pipelines_free(dev);
+	media_device_unregister(&dev->media_dev);
+	media_device_cleanup(&dev->media_dev);
+
+	dev_info(&pdev->dev, "Driver removed\n");
+
+	return 0;
+}
+
+/**
+ * @short of_device_id structure
+ */
+static const struct of_device_id plat_csi_of_match[] = {
+	{.compatible = "snps,plat-csi"},
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, plat_csi_of_match);
+
+/**
+ * @short Platform driver structure
+ */
+static struct platform_driver plat_csi_pdrv = {
+	.remove = plat_csi_remove,
+	.probe = plat_csi_probe,
+	.driver = {
+		   .name = "snps,plat-csi",
+		   .owner = THIS_MODULE,
+		   .of_match_table = plat_csi_of_match,
+		   },
+};
+
+static int __init
+plat_csi_init(void)
+{
+	request_module("dw-mipi-csi");
+
+	return platform_driver_register(&plat_csi_pdrv);
+}
+
+static void __exit
+plat_csi_exit(void)
+{
+	platform_driver_unregister(&plat_csi_pdrv);
+}
+
+module_init(plat_csi_init);
+module_exit(plat_csi_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
+MODULE_DESCRIPTION("Video Platform driver for MIPI CSI-2 Host");
diff --git a/drivers/media/platform/dwc/csi_video_plat.h b/drivers/media/platform/dwc/csi_video_plat.h
new file mode 100644
index 000000000000..9f462113b284
--- /dev/null
+++ b/drivers/media/platform/dwc/csi_video_plat.h
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef PLAT_CSI_H_
+#define PLAT_CSI_H_
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <media/dwc/csi_host_platform.h>
+#include <media/media-entity.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-subdev.h>
+
+#include "dw_mipi_csi.h"
+#include "csi_video_device.h"
+
+#define VIDEODEV_OF_NODE_NAME	"video-device"
+#define CSI_OF_NODE_NAME	"csi2"
+
+enum plat_csi_subdev_index {
+	IDX_SENSOR,
+	IDX_CSI,
+	IDX_VDEV,
+	IDX_MAX,
+};
+
+struct plat_csi_sensor_info {
+	struct plat_csi_source_info pdata;
+	struct v4l2_async_subdev asd;
+	struct v4l2_subdev *subdev;
+	struct mipi_csi_dev *host;
+};
+
+struct plat_csi_pipeline {
+	struct plat_csi_media_pipeline ep;
+	struct list_head list;
+	struct media_entity *vdev_entity;
+	struct v4l2_subdev *subdevs[IDX_MAX];
+};
+
+#define to_plat_csi_pipeline(_ep)\
+	 container_of(_ep, struct plat_csi_pipeline, ep)
+
+struct mipi_csi_info {
+	struct v4l2_subdev *sd;
+	int id;
+};
+
+/**
+ * @short Structure to embed device driver information
+ */
+struct plat_csi_dev {
+	struct mipi_csi_info		mipi_csi[CSI_MAX_ENTITIES];
+	struct video_device_dev		*vid_dev;
+	struct device			*dev;
+	struct media_device		media_dev;
+	struct v4l2_device		v4l2_dev;
+	struct platform_device		*pdev;
+	struct plat_csi_sensor_info	sensor[PLAT_MAX_SENSORS];
+	struct v4l2_async_notifier	subdev_notifier;
+	struct v4l2_async_subdev	*async_subdevs[PLAT_MAX_SENSORS];
+	spinlock_t			slock;
+	struct list_head		pipelines;
+	int				num_sensors;
+	struct media_graph	link_setup_graph;
+};
+
+static inline struct plat_csi_dev *
+entity_to_plat_csi_mdev(struct media_entity *me)
+{
+	return me->graph_obj.mdev == NULL ? NULL :
+	    container_of(me->graph_obj.mdev, struct plat_csi_dev, media_dev);
+}
+
+static inline struct plat_csi_dev *
+notifier_to_plat_csi(struct v4l2_async_notifier *n)
+{
+	return container_of(n, struct plat_csi_dev, subdev_notifier);
+}
+
+static inline void
+plat_csi_graph_unlock(struct plat_csi_video_entity *ve)
+{
+	mutex_unlock(&ve->vdev.entity.graph_obj.mdev->graph_mutex);
+}
+
+#endif				/* PLAT_CSI_H_ */
-- 
2.11.0
