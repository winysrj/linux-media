Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:64487 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbdFEUjq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Jun 2017 16:39:46 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH 12/12] intel-ipu3: imgu top level pci device
Date: Mon,  5 Jun 2017 15:39:17 -0500
Message-Id: <1496695157-19926-13-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/Kconfig  |  15 +
 drivers/media/pci/intel/ipu3/Makefile |   6 +
 drivers/media/pci/intel/ipu3/ipu3.c   | 712 ++++++++++++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3.h   | 184 +++++++++
 4 files changed, 917 insertions(+)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3.h

diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index 2030be7..1ba64e6 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -32,3 +32,18 @@ config INTEL_IPU3_DMAMAP
 	select IOMMU_IOVA
 	---help---
 	  This is IPU3 IOMMU domain specific DMA driver.
+
+config VIDEO_IPU3_IMGU
+	tristate "Intel ipu3-imgu driver"
+	depends on PCI && VIDEO_V4L2 && IOMMU_SUPPORT
+	depends on MEDIA_CONTROLLER && VIDEO_V4L2_SUBDEV_API
+	select IOMMU_API
+	select IOMMU_IOVA
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  This is the video4linux2 driver for Intel IPU3 image processing unit,
+	  found in Intel Skylake and Kaby Lake SoCs and used for processing
+	  images and video.
+
+	  Say Y or M here if you have a Skylake/Kaby Lake SoC with a MIPI
+	  camera.	The module will be called ipu3-imgu.
diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
index 2c2a035..e740877 100644
--- a/drivers/media/pci/intel/ipu3/Makefile
+++ b/drivers/media/pci/intel/ipu3/Makefile
@@ -1,3 +1,9 @@
 obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
 obj-$(CONFIG_INTEL_IPU3_MMU) += ipu3-mmu.o
 obj-$(CONFIG_INTEL_IPU3_DMAMAP) += ipu3-dmamap.o
+ipu3-imgu-objs += \
+		ipu3-tables.o ipu3-css-pool.o \
+		ipu3-css-fw.o ipu3-css-params.o \
+		ipu3-css.o ipu3-v4l2.o  ipu3.o
+
+obj-$(CONFIG_VIDEO_IPU3_IMGU) += ipu3-imgu.o
diff --git a/drivers/media/pci/intel/ipu3/ipu3.c b/drivers/media/pci/intel/ipu3/ipu3.c
new file mode 100644
index 0000000..ab0b0ce
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3.c
@@ -0,0 +1,712 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Based on Intel IPU4 driver.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "ipu3.h"
+
+#define IMGU_NAME			"ipu3-imgu"
+#define IMGU_PCI_ID			0x1919
+#define IMGU_PCI_BAR			0
+#define IMGU_DMA_MASK			DMA_BIT_MASK(39)
+#define IMGU_MAX_QUEUE_DEPTH		(2 + 2)
+
+/**************** Dummy buffers ****************/
+
+void imgu_dummybufs_cleanup(struct imgu_device *imgu)
+{
+	unsigned int i;
+
+	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
+		if (imgu->queues[i].dummybuf_vaddr)
+			dma_free_coherent(imgu->mmu.dev,
+					imgu->queues[i].dummybuf_size,
+					imgu->queues[i].dummybuf_vaddr,
+					imgu->queues[i].dummybuf_daddr);
+		imgu->queues[i].dummybuf_vaddr = NULL;
+	}
+}
+
+int imgu_dummybufs_init(struct imgu_device *imgu)
+{
+	unsigned int i, j;
+
+	/* Allocate a dummy buffer for each queue where buffer is optional */
+	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
+		if (!imgu->queue_enabled[i] || i == IMGU_QUEUE_MASTER) {
+			/*
+			 * Do not enable dummy buffers for master queue,
+			 * always require that real buffers from user are
+			 * available.
+			 */
+			imgu->queues[i].dummybuf_vaddr = NULL;
+			continue;
+		}
+
+		if (!imgu->mem2mem2.nodes[IMGU_NODE_VF].enabled &&
+			!imgu->mem2mem2.nodes[IMGU_NODE_PV].enabled &&
+			i == IPU3_CSS_QUEUE_VF) {
+			/*
+			 * Do not enable dummy buffers for VF/PV if it is not
+			 * requested by the user.
+			 */
+			imgu->queues[i].dummybuf_vaddr = NULL;
+			continue;
+		}
+
+		imgu->queues[i].dummybuf_size =
+			imgu->mem2mem2.nodes[i].vdev_fmt.fmt.pix.sizeimage;
+		imgu->queues[i].dummybuf_vaddr =
+			dma_alloc_coherent(imgu->mmu.dev,
+				imgu->queues[i].dummybuf_size,
+				&imgu->queues[i].dummybuf_daddr,
+				GFP_KERNEL);
+		if (!imgu->queues[i].dummybuf_vaddr) {
+			imgu_dummybufs_cleanup(imgu);
+			return -ENOMEM;
+		}
+
+		for (j = 0; j < IMGU_MAX_QUEUE_DEPTH; j++)
+			ipu3_css_buf_init(&imgu->queues[i].dummybufs[j], i,
+					imgu->queues[i].dummybuf_daddr);
+	}
+
+	return 0;
+}
+
+/* May be called from atomic context */
+static struct ipu3_css_buffer *imgu_dummybufs_get(
+			struct imgu_device *imgu, int queue)
+{
+	int b;
+
+	/* dummybufs are not allocated for master q */
+	if (queue == IPU3_CSS_QUEUE_IN)
+		return NULL;
+
+	if (WARN_ON(!imgu->queues[queue].dummybuf_vaddr))
+		/* Buffer should not be allocated here */
+		return NULL;
+
+	for (b = 0; b < IMGU_MAX_QUEUE_DEPTH; b++)
+		if (ipu3_css_buf_state(&imgu->queues[queue].dummybufs[b]) !=
+			IPU3_CSS_BUFFER_QUEUED)
+			break;
+
+	if (b >= IMGU_MAX_QUEUE_DEPTH)
+		return NULL;
+
+	ipu3_css_buf_init(&imgu->queues[queue].dummybufs[b], queue,
+			imgu->queues[queue].dummybuf_daddr);
+
+	return &imgu->queues[queue].dummybufs[b];
+}
+
+/* Check if given buffer is a dummy buffer */
+static bool imgu_dummybufs_check(struct imgu_device *imgu,
+				struct ipu3_css_buffer *buf)
+{
+	int q = buf->queue;
+	int b;
+
+	for (b = 0; b < IMGU_MAX_QUEUE_DEPTH; b++)
+		if (buf == &imgu->queues[q].dummybufs[b])
+			break;
+
+	return b < IMGU_MAX_QUEUE_DEPTH;
+}
+
+/**************** ipu3_mem2mem2_ops ****************/
+
+static struct imgu_node_mapping const imgu_node_map[IMGU_NODE_NUM] = {
+	[IMGU_NODE_IN] = {IPU3_CSS_QUEUE_IN, "input"},
+	[IMGU_NODE_PARAMS] = {IPU3_CSS_QUEUE_PARAMS, "parameters"},
+	[IMGU_NODE_OUT] = {IPU3_CSS_QUEUE_OUT, "output"},
+	[IMGU_NODE_VF] = {IPU3_CSS_QUEUE_VF, "viewfinder"},
+	[IMGU_NODE_PV] = {IPU3_CSS_QUEUE_VF, "postview"},
+	[IMGU_NODE_STAT_3A] = {IPU3_CSS_QUEUE_STAT_3A, "3a stat"},
+	[IMGU_NODE_STAT_DVS] = {IPU3_CSS_QUEUE_STAT_DVS, "dvs stat"},
+	[IMGU_NODE_STAT_LACE] = {IPU3_CSS_QUEUE_STAT_LACE, "lace stat"},
+};
+
+int imgu_node_to_queue(int node)
+{
+	return imgu_node_map[node].css_queue;
+}
+
+int imgu_map_node(struct imgu_device *imgu, int css_queue)
+{
+	unsigned int i;
+
+	if (css_queue == IPU3_CSS_QUEUE_VF)
+		return imgu->mem2mem2.nodes[IMGU_NODE_VF].enabled ?
+			IMGU_NODE_VF : IMGU_NODE_PV;
+
+	for (i = 0; i < IMGU_NODE_NUM; i++)
+		if (imgu_node_map[i].css_queue == css_queue)
+			return i;
+
+	return -EINVAL;
+}
+
+void imgu_buffer_done(struct imgu_device *imgu,
+			struct vb2_buffer *vb, enum vb2_buffer_state state)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&imgu->lock, flags);
+	ipu3_v4l2_buffer_done(vb, state);
+	spin_unlock_irqrestore(&imgu->lock, flags);
+}
+
+static struct ipu3_css_buffer *imgu_queue_getbuf(struct imgu_device *imgu,
+						int node)
+{
+	struct imgu_buffer *buf;
+	int queue = imgu_node_map[node].css_queue;
+
+	if (queue < 0) {
+		dev_err(&imgu->pci_dev->dev, "Invalid imgu node.\n");
+		return NULL;
+	}
+
+	/* Find first free buffer from the node */
+	list_for_each_entry(buf, &imgu->mem2mem2.nodes[node].buffers,
+				m2m2_buf.list) {
+		if (ipu3_css_buf_state(&buf->css_buf) == IPU3_CSS_BUFFER_NEW)
+			return &buf->css_buf;
+	}
+
+	/* There were no free buffers, try to return a dummy buffer */
+
+	return imgu_dummybufs_get(imgu, queue);
+}
+
+/*
+ * Queue as many buffers to CSS as possible. If all buffers don't fit into
+ * CSS buffer queues, they remain unqueued and will be queued later.
+ */
+int imgu_queue_buffers(struct imgu_device *imgu, bool initial)
+{
+	unsigned long flags;
+	unsigned int i;
+	int r = 0;
+
+	spin_lock_irqsave(&imgu->lock, flags);
+	do {
+		if (imgu->current_queue >= IMGU_NODE_NUM)
+			imgu->current_queue = 0;
+		if (imgu->current_queue == IMGU_NODE_VF &&
+			(imgu->css.pipe_id == IPU3_CSS_PIPE_ID_CAPTURE ||
+			!imgu->mem2mem2.nodes[IMGU_NODE_VF].enabled)) {
+			continue;
+		} else if (imgu->current_queue == IMGU_NODE_PV &&
+			(imgu->css.pipe_id == IPU3_CSS_PIPE_ID_VIDEO ||
+			!imgu->mem2mem2.nodes[IMGU_NODE_PV].enabled)) {
+			imgu->current_queue++;
+			continue;
+		} else if (imgu->queue_enabled[imgu->current_queue]) {
+			struct ipu3_css_buffer *buf =
+				imgu_queue_getbuf(imgu, imgu->current_queue);
+
+			if (!buf)
+				break;
+
+			r = ipu3_css_buf_queue(&imgu->css, buf);
+			if (r)
+				break;
+		}
+
+		imgu->current_queue++;
+	} while (1);
+	spin_unlock_irqrestore(&imgu->lock, flags);
+
+	if (r && r != -EBUSY)
+		goto failed;
+
+	return 0;
+
+failed:
+	/*
+	 * On error, mark all buffers as failed which are not
+	 * yet queued to CSS
+	 */
+	dev_err(&imgu->pci_dev->dev,
+		"failed to queue buffer to CSS on queue %i (%d)\n",
+		imgu->current_queue, r);
+
+	if (initial)
+		/* If we were called from streamon(), no need to finish bufs */
+		return r;
+
+	for (i = 0; i < IMGU_NODE_NUM; i++) {
+		struct imgu_buffer *buf, *buf0;
+
+		if (!imgu->queue_enabled[i])
+			continue;	/* Skip disabled queues */
+
+		spin_lock_irqsave(&imgu->lock, flags);
+		list_for_each_entry_safe(buf, buf0,
+					&imgu->mem2mem2.nodes[i].buffers,
+					m2m2_buf.list) {
+			if (ipu3_css_buf_state(&buf->css_buf) ==
+				IPU3_CSS_BUFFER_QUEUED)
+				continue;	/* Was already queued, skip */
+
+			ipu3_v4l2_buffer_done(&buf->m2m2_buf.vbb.vb2_buf,
+						VB2_BUF_STATE_ERROR);
+		}
+		spin_unlock_irqrestore(&imgu->lock, flags);
+	}
+
+	return r;
+}
+
+static int imgu_mem2mem2_s_stream(struct ipu3_mem2mem2_device *m2m2_dev,
+				int enable)
+{
+	struct imgu_device *imgu =
+	    container_of(m2m2_dev, struct imgu_device, mem2mem2);
+	struct device *dev = &imgu->pci_dev->dev;
+	struct v4l2_pix_format *fmts[IPU3_CSS_QUEUES];
+	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
+	int i, r, node;
+
+	if (!enable) {
+		/* Stop streaming */
+
+		ipu3_css_stop_streaming(&imgu->css);
+		imgu_dummybufs_cleanup(imgu);
+		pm_runtime_put(&imgu->pci_dev->dev);
+
+		return 0;
+	}
+
+	/* Start streaming */
+
+	imgu->current_queue = IMGU_QUEUE_MASTER;
+
+	for (i = 0; i < IMGU_NODE_NUM; i++)
+		imgu->queue_enabled[i] = m2m2_dev->nodes[i].enabled;
+
+	/*
+	 * CSS library expects that the following queues (except lace) are
+	 * always enabled; if buffers are not provided to some of the
+	 * queues, it stalls due to lack of buffers.
+	 * Force the queues to be enabled and if the user really hasn't
+	 * enabled them, use dummy buffers.
+	 */
+	imgu->queue_enabled[IMGU_NODE_OUT] = true;
+	imgu->queue_enabled[IMGU_NODE_STAT_3A] = true;
+	imgu->queue_enabled[IMGU_NODE_STAT_DVS] = true;
+	imgu->queue_enabled[IMGU_NODE_STAT_LACE] = false;
+
+	/* This is handled specially */
+	imgu->queue_enabled[IPU3_CSS_QUEUE_PARAMS] = false;
+
+	/* Initialize CSS formats */
+	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
+		node = imgu_map_node(imgu, i);
+		if (node < 0)
+			continue;
+		fmts[i] = imgu->queue_enabled[node] ?
+			&m2m2_dev->nodes[node].vdev_fmt.fmt.pix : NULL;
+	}
+
+	/* Enable VF output only when VF or PV queue requested by user */
+	imgu->css.vf_output_en = IPU3_NODE_VF_DISABLED;
+	if (m2m2_dev->nodes[IMGU_NODE_VF].enabled)
+		imgu->css.vf_output_en = IPU3_NODE_VF_ENABLED;
+	else if (m2m2_dev->nodes[IMGU_NODE_PV].enabled)
+		imgu->css.vf_output_en = IPU3_NODE_PV_ENABLED;
+
+	rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu->rect.eff;
+	rects[IPU3_CSS_RECT_BDS] = &imgu->rect.bds;
+
+	r = ipu3_css_fmt_set(&imgu->css, fmts, rects);
+	if (r) {
+		dev_err(dev, "failed to set initial formats (%d)", r);
+		goto fail_fmt_set;
+	}
+
+	/* Set Power */
+	r = pm_runtime_get_sync(dev);
+	if (r < 0) {
+		dev_info(dev, "pm_runtime_get_sync failed\n");
+		pm_runtime_put(dev);
+		return r;
+	}
+
+	/* Start CSS streaming */
+	r = ipu3_css_start_streaming(&imgu->css);
+	if (r) {
+		dev_err(dev, "failed to start css streaming (%d)", r);
+		goto fail_fmt_set;
+	}
+
+	/* Initialize dummy buffers */
+	r = imgu_dummybufs_init(imgu);
+	if (r) {
+		dev_err(dev, "failed to initialize dummy buffers (%d)", r);
+		goto fail_dummybufs;
+	}
+
+	/* Queue as many buffers from queue as possible */
+	r = imgu_queue_buffers(imgu, true);
+	if (r) {
+		dev_err(dev, "failed to queue initial buffers (%d)", r);
+		goto fail_queueing;
+	}
+
+	return 0;
+
+fail_queueing:
+	imgu_dummybufs_cleanup(imgu);
+fail_dummybufs:
+	ipu3_css_stop_streaming(&imgu->css);
+fail_fmt_set:
+
+	return r;
+}
+
+/*
+ * imgu_mem2mem2_ops - used by v4l2 and vb2
+ */
+static const struct ipu3_mem2mem2_ops imgu_mem2mem2_ops = {
+	.s_stream = imgu_mem2mem2_s_stream,
+};
+
+static int imgu_mem2mem2_init(struct imgu_device *imgu)
+{
+	struct v4l2_pix_format *fmts[IPU3_CSS_QUEUES];
+	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
+
+	int r, i;
+
+	imgu->mem2mem2.name = IMGU_NAME ":0";
+	imgu->mem2mem2.model = IMGU_NAME;
+	imgu->mem2mem2.num_nodes = IMGU_NODE_NUM;
+	imgu->mem2mem2.vb2_alloc_dev = imgu->mmu.dev;
+	imgu->mem2mem2.vb2_mem_ops = &vb2_dma_contig_memops;
+	imgu->mem2mem2.ops = &imgu_mem2mem2_ops;
+	imgu->mem2mem2.buf_struct_size = sizeof(struct imgu_buffer);
+	imgu->mem2mem2.ctrl_handler = &imgu->css.ctrls.handler;
+	imgu->mem2mem2.nodes = imgu->mem2mem2_nodes;
+	imgu->mem2mem2.dev = &imgu->pci_dev->dev;
+
+	for (i = 0; i < IMGU_NODE_NUM; i++) {
+		imgu->mem2mem2.nodes[i].name = imgu_node_map[i].name;
+		imgu->mem2mem2.nodes[i].output = i < IMGU_QUEUE_FIRST_INPUT;
+		imgu->mem2mem2.nodes[i].immutable = false;
+		imgu->mem2mem2.nodes[i].enabled = false;
+		fmts[imgu_node_map[i].css_queue] =
+			&imgu->mem2mem2.nodes[i].vdev_fmt.fmt.pix;
+		atomic_set(&imgu->queues[i].sequence, 0);
+	}
+
+	/* Master queue is always enabled */
+	imgu->mem2mem2.nodes[IMGU_QUEUE_MASTER].immutable = true;
+	imgu->mem2mem2.nodes[IMGU_QUEUE_MASTER].enabled = true;
+
+	r = ipu3_v4l2_register(imgu);
+	if (r) {
+		imgu->mem2mem2.vb2_alloc_dev = NULL;
+		return r;
+	}
+
+	/* Set initial formats and initialize formats of video nodes */
+	rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu->rect.eff;
+	rects[IPU3_CSS_RECT_BDS] = &imgu->rect.bds;
+	ipu3_css_fmt_set(&imgu->css, fmts, rects);
+
+	return 0;
+}
+
+static void imgu_mem2mem2_exit(struct imgu_device *imgu)
+{
+	ipu3_v4l2_unregister(imgu);
+	imgu->mem2mem2.vb2_alloc_dev = NULL;
+}
+
+/**************** PCI interface ****************/
+
+static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
+{
+	struct imgu_device *imgu = imgu_ptr;
+
+	/* Dequeue / queue buffers */
+	do {
+		unsigned long flags;
+		u64 ns = ktime_get_ns();
+		struct ipu3_css_buffer *b;
+		struct imgu_buffer *buf;
+		int q, node;
+
+		do {
+			spin_lock_irqsave(&imgu->lock, flags);
+			b = ipu3_css_buf_dequeue(&imgu->css);
+			spin_unlock_irqrestore(&imgu->lock, flags);
+		} while (PTR_ERR(b) == -EAGAIN);
+
+		if (IS_ERR_OR_NULL(b)) {
+			if (!b || PTR_ERR(b) == -EBUSY)	/* All done */
+				break;
+			dev_err(&imgu->pci_dev->dev,
+				"failed to dequeue buffers (%ld)\n",
+				PTR_ERR(b));
+			break;
+		}
+
+		if (imgu_dummybufs_check(imgu, b))
+			/* It was a dummy buffer, skip it */
+			continue;
+
+		q = b->queue;
+		node = imgu_map_node(imgu, q);
+		if (node < 0) {
+			dev_err(&imgu->pci_dev->dev, "Invalid css queue.\n");
+			break;
+		}
+		buf = container_of(b, struct imgu_buffer, css_buf);
+
+		/* Fill vb2 buffer entries and tell it's ready */
+		if (!imgu->mem2mem2.nodes[node].output) {
+			struct v4l2_format vdev_fmt;
+			unsigned int bytes;
+
+			vdev_fmt = imgu->mem2mem2.nodes[node].vdev_fmt;
+			bytes = vdev_fmt.fmt.pix.sizeimage;
+
+			vb2_set_plane_payload(&buf->m2m2_buf.vbb.vb2_buf, 0,
+						bytes);
+			buf->m2m2_buf.vbb.vb2_buf.timestamp = ns;
+			buf->m2m2_buf.vbb.field = V4L2_FIELD_NONE;
+			memset(&buf->m2m2_buf.vbb.timecode, 0,
+				sizeof(buf->m2m2_buf.vbb.timecode));
+			buf->m2m2_buf.vbb.sequence =
+				atomic_inc_return(&imgu->queues[q].sequence);
+		}
+		imgu_buffer_done(imgu, &buf->m2m2_buf.vbb.vb2_buf,
+				ipu3_css_buf_state(&buf->css_buf) ==
+				IPU3_CSS_BUFFER_DONE ?
+				VB2_BUF_STATE_DONE : VB2_BUF_STATE_ERROR);
+	} while (1);
+
+	/* Try to queue more buffers for CSS */
+	imgu_queue_buffers(imgu, false);
+
+	return IRQ_NONE;
+}
+
+irqreturn_t imgu_isr(int irq, void *imgu_ptr)
+{
+	struct imgu_device *imgu = imgu_ptr;
+	irqreturn_t r = IRQ_HANDLED;
+
+	/* acknowledge interruption */
+	if (ipu3_css_irq_ack(&imgu->css) >= 0)
+		r = IRQ_NONE;
+
+	if (!imgu->mem2mem2.streaming)
+		return r;
+
+	return IRQ_WAKE_THREAD;
+}
+
+static int imgu_pci_config_setup(struct pci_dev *dev)
+{
+	u16 pci_command;
+	int r = pci_enable_msi(dev);
+
+	if (r) {
+		dev_err(&dev->dev, "failed to enable MSI (%d)\n", r);
+		return r;
+	}
+
+	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
+	pci_command |= PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER |
+			PCI_COMMAND_INTX_DISABLE;
+	pci_write_config_word(dev, PCI_COMMAND, pci_command);
+
+	return 0;
+}
+
+static int imgu_pci_probe(struct pci_dev *pci_dev,
+			const struct pci_device_id *id)
+{
+	struct imgu_device *imgu;
+	phys_addr_t phys;
+	unsigned long phys_len;
+	void __iomem *const *iomap;
+	int r;
+
+	imgu = devm_kzalloc(&pci_dev->dev, sizeof(*imgu), GFP_KERNEL);
+	if (!imgu)
+		return -ENOMEM;
+
+	spin_lock_init(&imgu->lock);
+	imgu->pci_dev = pci_dev;
+
+	r = pcim_enable_device(pci_dev);
+	if (r) {
+		dev_err(&pci_dev->dev, "failed to enable device (%d)\n", r);
+		return r;
+	}
+
+	dev_info(&pci_dev->dev, "device 0x%x (rev: 0x%x)\n",
+		 pci_dev->device, pci_dev->revision);
+
+	phys = pci_resource_start(pci_dev, IMGU_PCI_BAR);
+	phys_len = pci_resource_len(pci_dev, IMGU_PCI_BAR);
+
+	r = pcim_iomap_regions(pci_dev, 1 << IMGU_PCI_BAR, pci_name(pci_dev));
+	if (r) {
+		dev_err(&pci_dev->dev, "failed to remap I/O memory (%d)\n", r);
+		return r;
+	}
+	dev_info(&pci_dev->dev, "physical base address 0x%llx, %lu bytes\n",
+		phys, phys_len);
+
+	iomap = pcim_iomap_table(pci_dev);
+	if (!iomap) {
+		dev_err(&pci_dev->dev, "failed to iomap table\n");
+		return -ENODEV;
+	}
+
+	imgu->base = iomap[IMGU_PCI_BAR];
+
+	pci_set_drvdata(pci_dev, imgu);
+
+	pci_set_master(pci_dev);
+
+	r = pci_set_dma_mask(pci_dev, IMGU_DMA_MASK);
+	if (!r)
+		r = pci_set_consistent_dma_mask(pci_dev, IMGU_DMA_MASK);
+	if (r) {
+		dev_err(&pci_dev->dev, "failed to set DMA mask (%d)\n", r);
+		return r;
+	}
+
+	r = imgu_pci_config_setup(pci_dev);
+	if (r)
+		return r;
+
+	r = ipu3_mmu_init(&imgu->mmu, imgu->base, &pci_dev->dev);
+	if (r) {
+		dev_err(&pci_dev->dev, "failed to initialize MMU (%d)\n", r);
+		goto failed_mmu;
+	}
+
+	imgu->mmu.dev->dma_ops = &ipu3_dmamap_ops;
+	/* ISP programming */
+	r = ipu3_css_init(imgu->mmu.dev, &imgu->css, imgu->base,
+				imgu->mmu.pgtbl, phys_len);
+	if (r) {
+		dev_err(&pci_dev->dev, "failed to initialize CSS (%d)\n", r);
+		goto failed_css;
+	}
+
+	/* v4l2 sub-device registration */
+	r = imgu_mem2mem2_init(imgu);
+	if (r) {
+		dev_err(&pci_dev->dev, "failed to create V4L2 devices (%d)\n",
+			r);
+		goto failed_mem2mem2;
+	}
+
+	r = devm_request_threaded_irq(&pci_dev->dev, pci_dev->irq,
+				imgu_isr, imgu_isr_threaded,
+				IRQF_SHARED, IMGU_NAME, imgu);
+	if (r) {
+		dev_err(&pci_dev->dev, "failed to request IRQ (%d)\n", r);
+		return r;
+	}
+
+	pm_runtime_put_noidle(&pci_dev->dev);
+	pm_runtime_allow(&pci_dev->dev);
+
+	return 0;
+
+failed_mem2mem2:
+	ipu3_css_cleanup(&imgu->css);
+failed_css:
+	ipu3_mmu_exit(&imgu->mmu);
+failed_mmu:
+	return r;
+}
+
+static void imgu_pci_remove(struct pci_dev *pci_dev)
+{
+	struct imgu_device *imgu = pci_get_drvdata(pci_dev);
+
+	imgu_mem2mem2_exit(imgu);
+	ipu3_css_cleanup(&imgu->css);
+	ipu3_mmu_exit(&imgu->mmu);
+
+	pm_runtime_forbid(&pci_dev->dev);
+	pm_runtime_get_noresume(&pci_dev->dev);
+}
+
+static int imgu_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct imgu_device *imgu = pci_get_drvdata(pci_dev);
+
+	return ipu3_css_set_powerdown(&imgu->css);
+}
+
+static int imgu_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct imgu_device *imgu = pci_get_drvdata(pci_dev);
+
+	return ipu3_css_set_powerup(&imgu->css);
+}
+
+static const struct dev_pm_ops imgu_pm_ops = {
+	SET_RUNTIME_PM_OPS(&imgu_runtime_suspend, &imgu_runtime_resume, NULL)
+};
+
+static const struct pci_device_id imgu_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, IMGU_PCI_ID) },
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, imgu_pci_tbl);
+
+static struct pci_driver imgu_pci_driver = {
+	.name = IMGU_NAME,
+	.id_table = imgu_pci_tbl,
+	.probe = imgu_pci_probe,
+	.remove = imgu_pci_remove,
+	.driver = {
+		.pm = &imgu_pm_ops,
+	},
+};
+
+module_pci_driver(imgu_pci_driver);
+
+MODULE_AUTHOR("Tuukka Toivonen <tuukka.toivonen@intel.com>");
+MODULE_AUTHOR("Tianshu Qiu <tian.shu.qiu@intel.com>");
+MODULE_AUTHOR("Jian Xu Zheng <jian.xu.zheng@intel.com>");
+MODULE_AUTHOR("Yuning Pu <yuning.pu@intel.com>");
+MODULE_AUTHOR("Yong Zhi <yong.zhi@intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Intel ipu3_imgu PCI driver");
diff --git a/drivers/media/pci/intel/ipu3/ipu3.h b/drivers/media/pci/intel/ipu3/ipu3.h
new file mode 100644
index 0000000..66f1cff
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3.h
@@ -0,0 +1,184 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __IPU3_H
+#define __IPU3_H
+
+#include <linux/pci.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
+#include "ipu3-css.h"
+#include "ipu3-dmamap.h"
+#include "ipu3-mmu.h"
+
+/*
+ * The semantics of the driver is that whenever there is a buffer available in
+ * master queue, the driver queues a buffer also to all other active nodes.
+ * If user space hasn't provided a buffer to all other video nodes first,
+ * the driver gets an internal dummy buffer and queues it.
+ */
+#define IMGU_QUEUE_MASTER		IPU3_CSS_QUEUE_IN
+#define IMGU_QUEUE_FIRST_INPUT		IPU3_CSS_QUEUE_OUT
+#define IMGU_MAX_QUEUE_DEPTH		(2 + 2)
+
+#define IMGU_NODE_IN			0 /* Input RAW image */
+#define IMGU_NODE_PARAMS		1 /* Input parameters */
+#define IMGU_NODE_OUT			2 /* Main output for still or video */
+#define IMGU_NODE_VF			3 /* Preview */
+#define IMGU_NODE_PV			4 /* Postview for still capture */
+#define IMGU_NODE_STAT_3A		5 /* 3A statistics */
+#define IMGU_NODE_STAT_DVS		6 /* DVS statistics */
+#define IMGU_NODE_STAT_LACE		7 /* Lace statistics */
+#define IMGU_NODE_NUM			8
+
+#define file_to_intel_ipu3_node(__file) \
+	container_of(video_devdata(__file), struct imgu_video_device, vdev)
+
+#define IPU3_INPUT_MIN_WIDTH		0U
+#define IPU3_INPUT_MIN_HEIGHT		0U
+#define IPU3_INPUT_MAX_WIDTH		5120U
+#define IPU3_INPUT_MAX_HEIGHT		38404U
+#define IPU3_OUTPUT_MIN_WIDTH		2U
+#define IPU3_OUTPUT_MIN_HEIGHT		2U
+#define IPU3_OUTPUT_MAX_WIDTH		4480U
+#define IPU3_OUTPUT_MAX_HEIGHT		34004U
+
+struct ipu3_mem2mem2_buffer {
+	/* Public fields */
+	struct vb2_v4l2_buffer vbb;	/* Must be the first field */
+
+	/* Private fields */
+	struct list_head list;
+};
+
+struct imgu_buffer {
+	struct ipu3_mem2mem2_buffer m2m2_buf;	/* Must be the first field */
+	struct ipu3_css_buffer css_buf;
+};
+
+struct imgu_node_mapping {
+	int css_queue;
+	const char *name;
+};
+
+/**
+ * struct imgu_video_device
+ * each node registers as video device and maintains its
+ * own vb2_queue.
+ */
+struct imgu_video_device {
+	const char *name;
+	bool output;		/* Frames to the driver? */
+	bool immutable;		/* Can not be enabled/disabled */
+	bool enabled;
+	int queued;		/* Buffers already queued */
+	struct v4l2_format vdev_fmt;	/* Currently set format */
+
+	/* Private fields */
+	struct video_device vdev;
+	struct media_pad vdev_pad;
+	struct v4l2_mbus_framefmt pad_fmt;
+	struct vb2_queue vbq;
+	struct list_head buffers;
+	/* Protect vb2_queue and vdev structs*/
+	struct mutex lock;
+};
+
+/**
+ * struct ipu3_mem2mem2_device - mem2mem device
+ * this is the top level helper struct used by parent PCI device
+ * to bind everything together for media operations.
+ */
+struct ipu3_mem2mem2_device {
+	/* Public fields, fill before registering */
+	const char *name;
+	const char *model;
+	struct device *dev;
+	int num_nodes;
+	struct imgu_video_device *nodes;
+	struct device *vb2_alloc_dev;
+	const struct ipu3_mem2mem2_ops *ops;
+	const struct vb2_mem_ops *vb2_mem_ops;
+	unsigned int buf_struct_size;
+	bool streaming;		/* Public read only */
+	struct v4l2_ctrl_handler *ctrl_handler;
+
+	/* Private fields */
+	struct v4l2_device v4l2_dev;
+	struct media_device media_dev;
+	struct media_pipeline pipeline;
+	struct v4l2_subdev subdev;
+	struct media_pad *subdev_pads;
+	struct v4l2_file_operations v4l2_file_ops;
+};
+
+/**
+ * struct ipu3_mem2mem2_ops - mem2mem2 ops
+ * defines driver specific callback APIs like
+ * start stream.
+ */
+struct ipu3_mem2mem2_ops {
+	int (*s_stream)(struct ipu3_mem2mem2_device *m2m2_dev, int enable);
+};
+
+/*
+ * imgu_device -- ImgU (Imaging Unit) driver
+ */
+struct imgu_device {
+	struct pci_dev *pci_dev;
+	void __iomem *base;
+
+	/* Internally enabled queues */
+	struct {
+		atomic_t sequence;
+		size_t dummybuf_size;
+		void *dummybuf_vaddr;
+		dma_addr_t dummybuf_daddr;
+		struct ipu3_css_buffer dummybufs[IMGU_MAX_QUEUE_DEPTH];
+	} queues[IPU3_CSS_QUEUES];
+	unsigned int current_queue;
+	struct imgu_video_device mem2mem2_nodes[IMGU_NODE_NUM];
+	bool queue_enabled[IMGU_NODE_NUM];
+
+	/* Delegate v4l2 support */
+	struct ipu3_mem2mem2_device mem2mem2;
+	/* MMU driver for css */
+	struct ipu3_mmu mmu;
+	/* css - Camera Sub-System */
+	struct ipu3_css css;
+
+	/*
+	 * Coarse-grained lock to protect
+	 * m2m2_buf.list and css->queue
+	 */
+	spinlock_t lock;
+	struct {
+		struct v4l2_rect eff; /* effective resolution */
+		struct v4l2_rect bds; /* bayer-domain scaled resolution*/
+	} rect;
+};
+
+int imgu_node_to_queue(int node);
+int imgu_map_node(struct imgu_device *imgu, int css_queue);
+void imgu_buffer_done(struct imgu_device *imgu, struct vb2_buffer *vb,
+			enum vb2_buffer_state state);
+int imgu_queue_buffers(struct imgu_device *imgu, bool initial);
+void imgu_dummybufs_cleanup(struct imgu_device *imgu);
+int imgu_dummybufs_init(struct imgu_device *imgu);
+
+int ipu3_v4l2_register(struct imgu_device *dev);
+int ipu3_v4l2_unregister(struct imgu_device *dev);
+void ipu3_v4l2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+
+#endif
-- 
2.7.4
