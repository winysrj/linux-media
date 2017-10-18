Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:19410 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754696AbdJRD4N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 23:56:13 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com, arnd@arndb.de,
        hch@lst.de, robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        Yong Zhi <yong.zhi@intel.com>, Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH v4 12/12] intel-ipu3: imgu top level pci device
Date: Tue, 17 Oct 2017 22:55:59 -0500
Message-Id: <1508298959-26148-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the Intel IPU v3 as found
on Skylake and Kaby Lake SoCs. The driver has a dependency
on the firmware binary to function properly.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/pci/intel/ipu3/Kconfig  |  17 +
 drivers/media/pci/intel/ipu3/Makefile |   6 +
 drivers/media/pci/intel/ipu3/ipu3.c   | 882 ++++++++++++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3.h   | 186 +++++++
 4 files changed, 1091 insertions(+)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3.h

diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index d7dab52dc881..344b57df2179 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -33,3 +33,20 @@ config INTEL_IPU3_DMAMAP
 	select IOMMU_IOVA
 	---help---
 	  This is IPU3 IOMMU domain specific DMA driver.
+
+config VIDEO_IPU3_IMGU
+	tristate "Intel ipu3-imgu driver"
+	depends on PCI && VIDEO_V4L2 && IOMMU_SUPPORT
+	depends on MEDIA_CONTROLLER && VIDEO_V4L2_SUBDEV_API
+	depends on X86 || COMPILE_TEST
+	select INTEL_IPU3_MMU
+	select INTEL_IPU3_DMAMAP
+	select VIDEOBUF2_DMA_SG
+
+	---help---
+	This is the video4linux2 driver for Intel IPU3 image processing unit,
+	found in Intel Skylake and Kaby Lake SoCs and used for processing
+	images and video.
+
+	Say Y or M here if you have a Skylake/Kaby Lake SoC with a MIPI
+	camera.	The module will be called ipu3-imgu.
diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
index 651773231496..c613f508ffe4 100644
--- a/drivers/media/pci/intel/ipu3/Makefile
+++ b/drivers/media/pci/intel/ipu3/Makefile
@@ -14,3 +14,9 @@
 obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
 obj-$(CONFIG_INTEL_IPU3_MMU) += ipu3-mmu.o
 obj-$(CONFIG_INTEL_IPU3_DMAMAP) += ipu3-dmamap.o
+ipu3-imgu-objs += \
+		ipu3-tables.o ipu3-css-pool.o \
+		ipu3-css-fw.o ipu3-css-params.o \
+		ipu3-css.o ipu3-v4l2.o ipu3.o
+
+obj-$(CONFIG_VIDEO_IPU3_IMGU) += ipu3-imgu.o
diff --git a/drivers/media/pci/intel/ipu3/ipu3.c b/drivers/media/pci/intel/ipu3/ipu3.c
new file mode 100644
index 000000000000..5492af263ca0
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3.c
@@ -0,0 +1,882 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ * Copyright (C) 2017 Google, Inc.
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
+#include <media/videobuf2-dma-sg.h>
+
+#include "ipu3.h"
+#include "ipu3-mmu.h"
+#include "ipu3-dmamap.h"
+
+#define IMGU_NAME			"ipu3-imgu"
+#define IMGU_PCI_ID			0x1919
+#define IMGU_PCI_BAR			0
+#define IMGU_DMA_MASK			DMA_BIT_MASK(39)
+#define IMGU_MAX_QUEUE_DEPTH		(2 + 2)
+
+static const struct imgu_node_mapping imgu_node_map[IMGU_NODE_NUM] = {
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
+/**************** Dummy buffers ****************/
+
+static void imgu_dummybufs_cleanup(struct imgu_device *imgu)
+{
+	unsigned int i;
+
+	for (i = 0; i < IPU3_CSS_QUEUES; i++)
+		ipu3_dmamap_free(imgu, &imgu->queues[i].dmap);
+}
+
+static int imgu_dummybufs_init(struct imgu_device *imgu)
+{
+	const struct v4l2_pix_format_mplane *mpix;
+	const struct v4l2_meta_format	*meta;
+	size_t size;
+	unsigned int i, j;
+	int node;
+
+	/* Allocate a dummy buffer for each queue where buffer is optional */
+	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
+		node = imgu_map_node(imgu, i);
+		if (!imgu->queue_enabled[node] || i == IMGU_QUEUE_MASTER) {
+			/*
+			 * Do not enable dummy buffers for master queue,
+			 * always require that real buffers from user are
+			 * available.
+			 */
+			imgu->queues[i].dmap.vaddr = NULL;
+			continue;
+		}
+
+		if (!imgu->mem2mem2.nodes[IMGU_NODE_VF].enabled &&
+		    !imgu->mem2mem2.nodes[IMGU_NODE_PV].enabled &&
+		    i == IPU3_CSS_QUEUE_VF) {
+			/*
+			 * Do not enable dummy buffers for VF/PV if it is not
+			 * requested by the user.
+			 */
+			imgu->queues[i].dmap.vaddr = NULL;
+			continue;
+		}
+
+		meta = &imgu->mem2mem2.nodes[node].vdev_fmt.fmt.meta;
+		mpix = &imgu->mem2mem2.nodes[node].vdev_fmt.fmt.pix_mp;
+		if (node == IMGU_NODE_STAT_3A || node == IMGU_NODE_STAT_DVS ||
+		    node == IMGU_NODE_STAT_LACE || node == IMGU_NODE_PARAMS)
+			size = meta->buffersize;
+		else
+			size = mpix->plane_fmt[0].sizeimage;
+
+		if (!ipu3_dmamap_alloc(imgu, &imgu->queues[i].dmap, size)) {
+			imgu_dummybufs_cleanup(imgu);
+			return -ENOMEM;
+		}
+
+		for (j = 0; j < IMGU_MAX_QUEUE_DEPTH; j++)
+			ipu3_css_buf_init(&imgu->queues[i].dummybufs[j], i,
+					  imgu->queues[i].dmap.daddr);
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
+	if (WARN_ON(!imgu->queues[queue].dmap.vaddr))
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
+			  imgu->queues[queue].dmap.daddr);
+
+	return &imgu->queues[queue].dummybufs[b];
+}
+
+/* Check if given buffer is a dummy buffer */
+static bool imgu_dummybufs_check(struct imgu_device *imgu,
+				 struct ipu3_css_buffer *buf)
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
+static void imgu_buffer_done(struct imgu_device *imgu, struct vb2_buffer *vb,
+			     enum vb2_buffer_state state)
+{
+	mutex_lock(&imgu->lock);
+	ipu3_v4l2_buffer_done(vb, state);
+	mutex_unlock(&imgu->lock);
+}
+
+static struct ipu3_css_buffer *imgu_queue_getbuf(struct imgu_device *imgu,
+						 int node)
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
+			    m2m2_buf.list) {
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
+	unsigned int node;
+	int r = 0;
+	struct imgu_buffer *ibuf;
+
+	if (!ipu3_css_is_streaming(&imgu->css))
+		return 0;
+
+	mutex_lock(&imgu->lock);
+
+	/* Buffer set is queued to FW only when input buffer is ready */
+	if (!imgu_queue_getbuf(imgu, IMGU_NODE_IN)) {
+		mutex_unlock(&imgu->lock);
+		return 0;
+	}
+	for (node = IMGU_NODE_IN + 1; 1; node = (node + 1) % IMGU_NODE_NUM) {
+		if (node == IMGU_NODE_VF &&
+		    (imgu->css.pipe_id == IPU3_CSS_PIPE_ID_CAPTURE ||
+		    !imgu->mem2mem2.nodes[IMGU_NODE_VF].enabled)) {
+			continue;
+		} else if (node == IMGU_NODE_PV &&
+			(imgu->css.pipe_id == IPU3_CSS_PIPE_ID_VIDEO ||
+			!imgu->mem2mem2.nodes[IMGU_NODE_PV].enabled)) {
+			continue;
+		} else if (imgu->queue_enabled[node]) {
+			struct ipu3_css_buffer *buf =
+				imgu_queue_getbuf(imgu, node);
+			int dummy;
+
+			if (!buf)
+				break;
+
+			r = ipu3_css_buf_queue(&imgu->css, buf);
+			if (r)
+				break;
+			dummy = imgu_dummybufs_check(imgu, buf);
+			if (!dummy)
+				ibuf = container_of(buf, struct imgu_buffer,
+						    css_buf);
+			dev_dbg(&imgu->pci_dev->dev,
+				"queue %s %s buffer %d to css da: 0x%08x\n",
+				dummy ? "dummy" : "user",
+				imgu_node_map[node].name,
+				dummy ? 0 : ibuf->m2m2_buf.vbb.vb2_buf.index,
+				(u32)buf->daddr);
+		}
+		if (node == IMGU_NODE_IN &&
+		    !imgu_queue_getbuf(imgu, IMGU_NODE_IN))
+			break;
+	}
+	mutex_unlock(&imgu->lock);
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
+		node, r);
+
+	if (initial)
+		/* If we were called from streamon(), no need to finish bufs */
+		return r;
+
+	for (node = 0; node < IMGU_NODE_NUM; node++) {
+		struct imgu_buffer *buf, *buf0;
+
+		if (!imgu->queue_enabled[node])
+			continue;	/* Skip disabled queues */
+
+		mutex_lock(&imgu->lock);
+		list_for_each_entry_safe(buf, buf0,
+					 &imgu->mem2mem2.nodes[node].buffers,
+					 m2m2_buf.list) {
+			if (ipu3_css_buf_state(&buf->css_buf) ==
+				IPU3_CSS_BUFFER_QUEUED)
+				continue;	/* Was already queued, skip */
+
+			ipu3_v4l2_buffer_done(&buf->m2m2_buf.vbb.vb2_buf,
+					      VB2_BUF_STATE_ERROR);
+		}
+		mutex_unlock(&imgu->lock);
+	}
+
+	return r;
+}
+
+static bool imgu_buffer_drain(struct imgu_device *imgu)
+{
+	bool drain;
+
+	mutex_lock(&imgu->lock);
+	drain = ipu3_css_queue_empty(&imgu->css);
+	mutex_unlock(&imgu->lock);
+
+	return drain;
+}
+
+static int imgu_powerup(struct imgu_device *imgu)
+{
+	int r;
+
+	r = ipu3_css_set_powerup(&imgu->pci_dev->dev, imgu->base);
+	if (r)
+		return r;
+
+	ipu3_mmu_resume(imgu->mmu);
+	return 0;
+}
+
+static int imgu_powerdown(struct imgu_device *imgu)
+{
+	ipu3_mmu_suspend(imgu->mmu);
+	return ipu3_css_set_powerdown(&imgu->pci_dev->dev, imgu->base);
+}
+
+static int imgu_mem2mem2_s_stream(struct ipu3_mem2mem2_device *m2m2_dev,
+				  int enable)
+{
+	struct imgu_device *imgu =
+	    container_of(m2m2_dev, struct imgu_device, mem2mem2);
+	struct device *dev = &imgu->pci_dev->dev;
+	struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES] = { NULL };
+	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
+	int i, r, node;
+
+	if (!enable) {
+		/* Stop streaming */
+		dev_dbg(dev, "stream off\n");
+		/* Block new buffers to be queued to CSS. */
+		mutex_lock(&imgu->qbuf_lock);
+		ipu3_css_stop_streaming(&imgu->css);
+		synchronize_irq(imgu->pci_dev->irq);
+		mutex_unlock(&imgu->qbuf_lock);
+		imgu_dummybufs_cleanup(imgu);
+		imgu_powerdown(imgu);
+		pm_runtime_put(&imgu->pci_dev->dev);
+
+		return 0;
+	}
+
+	/* Start streaming */
+
+	dev_dbg(dev, "stream on\n");
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
+	imgu->queue_enabled[IMGU_NODE_VF] = true;
+	imgu->queue_enabled[IMGU_NODE_PV] = true;
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
+		/* No need to reconfig meta nodes */
+		if (node < 0 || node == IMGU_NODE_STAT_3A ||
+		    node == IMGU_NODE_STAT_DVS ||
+		    node == IMGU_NODE_STAT_LACE ||
+		    node == IMGU_NODE_PARAMS)
+			continue;
+		fmts[i] = imgu->queue_enabled[node] ?
+			&m2m2_dev->nodes[node].vdev_fmt.fmt.pix_mp : NULL;
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
+	rects[IPU3_CSS_RECT_GDC] = &imgu->rect.gdc;
+
+	r = ipu3_css_fmt_set(&imgu->css, fmts, rects);
+	if (r) {
+		dev_err(dev, "failed to set initial formats (%d)", r);
+		return r;
+	}
+
+	/* Set Power */
+	r = pm_runtime_get_sync(dev);
+	if (r < 0) {
+		dev_err(dev, "failed to set imgu power\n");
+		pm_runtime_put(dev);
+		return r;
+	}
+
+	r = imgu_powerup(imgu);
+	if (r) {
+		dev_err(dev, "failed to power up imgu\n");
+		pm_runtime_put(dev);
+		return r;
+	}
+
+	/* Start CSS streaming */
+	r = ipu3_css_start_streaming(&imgu->css);
+	if (r) {
+		dev_err(dev, "failed to start css streaming (%d)", r);
+		goto fail_start_streaming;
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
+fail_start_streaming:
+	pm_runtime_put(dev);
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
+	struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES] = { NULL };
+	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
+
+	int r, i;
+
+	imgu->mem2mem2.name = IMGU_NAME ":0";
+	imgu->mem2mem2.model = IMGU_NAME;
+	imgu->mem2mem2.num_nodes = IMGU_NODE_NUM;
+	imgu->mem2mem2.vb2_alloc_dev = &imgu->pci_dev->dev;
+	imgu->mem2mem2.vb2_mem_ops = &vb2_dma_sg_memops;
+	imgu->mem2mem2.ops = &imgu_mem2mem2_ops;
+	imgu->mem2mem2.buf_struct_size = sizeof(struct imgu_buffer);
+	imgu->mem2mem2.nodes = imgu->mem2mem2_nodes;
+	imgu->mem2mem2.dev = &imgu->pci_dev->dev;
+
+	for (i = 0; i < IMGU_NODE_NUM; i++) {
+		imgu->mem2mem2.nodes[i].name = imgu_node_map[i].name;
+		imgu->mem2mem2.nodes[i].output = i < IMGU_QUEUE_FIRST_INPUT;
+		imgu->mem2mem2.nodes[i].immutable = false;
+		imgu->mem2mem2.nodes[i].enabled = false;
+
+		if (i != IMGU_NODE_PARAMS && i != IMGU_NODE_STAT_3A &&
+		    i != IMGU_NODE_STAT_DVS && i != IMGU_NODE_STAT_LACE)
+			fmts[imgu_node_map[i].css_queue] =
+				&imgu->mem2mem2.nodes[i].vdev_fmt.fmt.pix_mp;
+		atomic_set(&imgu->mem2mem2.nodes[i].sequence, 0);
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
+		u64 ns = ktime_get_ns();
+		struct ipu3_css_buffer *b;
+		struct imgu_buffer *buf;
+		int q, node;
+		bool dummy;
+
+		do {
+			mutex_lock(&imgu->lock);
+			b = ipu3_css_buf_dequeue(&imgu->css);
+			mutex_unlock(&imgu->lock);
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
+		q = b->queue;
+		node = imgu_map_node(imgu, q);
+		if (node < 0) {
+			dev_err(&imgu->pci_dev->dev, "Invalid css queue.\n");
+			break;
+		}
+
+		dummy = imgu_dummybufs_check(imgu, b);
+		if (!dummy)
+			buf = container_of(b, struct imgu_buffer, css_buf);
+		dev_dbg(&imgu->pci_dev->dev,
+			"dequeue %s %s buffer %d from css\n",
+			dummy ? "dummy" : "user",
+			imgu_node_map[node].name,
+			dummy ? 0 : buf->m2m2_buf.vbb.vb2_buf.index);
+
+		if (dummy)
+			/* It was a dummy buffer, skip it */
+			continue;
+
+		/* Fill vb2 buffer entries and tell it's ready */
+		if (!imgu->mem2mem2.nodes[node].output) {
+			struct v4l2_format *fmt;
+			unsigned int bytes;
+
+			fmt = &imgu->mem2mem2.nodes[node].vdev_fmt;
+			if (buf->m2m2_buf.vbb.vb2_buf.type ==
+				 V4L2_BUF_TYPE_META_CAPTURE)
+				bytes = fmt->fmt.meta.buffersize;
+			else
+				bytes = fmt->fmt.pix_mp.plane_fmt[0].sizeimage;
+
+			vb2_set_plane_payload(&buf->m2m2_buf.vbb.vb2_buf, 0,
+					      bytes);
+			buf->m2m2_buf.vbb.vb2_buf.timestamp = ns;
+			buf->m2m2_buf.vbb.field = V4L2_FIELD_NONE;
+			memset(&buf->m2m2_buf.vbb.timecode, 0,
+			       sizeof(buf->m2m2_buf.vbb.timecode));
+			buf->m2m2_buf.vbb.sequence =
+				atomic_inc_return(
+				&imgu->mem2mem2.nodes[node].sequence);
+		}
+		imgu_buffer_done(imgu, &buf->m2m2_buf.vbb.vb2_buf,
+				 ipu3_css_buf_state(&buf->css_buf) ==
+				 IPU3_CSS_BUFFER_DONE ?
+				 VB2_BUF_STATE_DONE : VB2_BUF_STATE_ERROR);
+		mutex_lock(&imgu->lock);
+		if (ipu3_css_queue_empty(&imgu->css))
+			wake_up_all(&imgu->buf_drain_wq);
+		mutex_unlock(&imgu->lock);
+	} while (1);
+
+	/*
+	 * Try to queue more buffers for CSS.
+	 * qbuf_lock is used to disable new buffers
+	 * to be queued to CSS. mutex_trylock is used
+	 * to avoid blocking irq thread processing
+	 * remaining buffers.
+	 */
+	if (mutex_trylock(&imgu->qbuf_lock)) {
+		imgu_queue_buffers(imgu, false);
+		mutex_unlock(&imgu->qbuf_lock);
+	}
+
+	return IRQ_NONE;
+}
+
+static irqreturn_t imgu_isr(int irq, void *imgu_ptr)
+{
+	struct imgu_device *imgu = imgu_ptr;
+
+	/* acknowledge interruption */
+	ipu3_css_irq_ack(&imgu->css);
+
+	if (!imgu->mem2mem2.streaming)
+		return IRQ_HANDLED;
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
+			  const struct pci_device_id *id)
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
+		 phys, phys_len);
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
+	r = dma_coerce_mask_and_coherent(&pci_dev->dev, IMGU_DMA_MASK);
+	if (r) {
+		dev_err(&pci_dev->dev, "failed to set DMA mask (%d)\n", r);
+		return -ENODEV;
+	}
+
+	r = imgu_pci_config_setup(pci_dev);
+	if (r)
+		return r;
+
+	mutex_init(&imgu->lock);
+	mutex_init(&imgu->qbuf_lock);
+	init_waitqueue_head(&imgu->buf_drain_wq);
+
+	r = ipu3_css_set_powerup(&pci_dev->dev, imgu->base);
+	if (r) {
+		dev_err(&pci_dev->dev,
+			"failed to power up CSS (%d)\n", r);
+		goto failed_powerup;
+	}
+
+	imgu->mmu = ipu3_mmu_init(&pci_dev->dev, imgu->base);
+	if (IS_ERR(imgu->mmu)) {
+		r = PTR_ERR(imgu->mmu);
+		dev_err(&pci_dev->dev, "failed to initialize MMU (%d)\n", r);
+		goto failed_mmu;
+	}
+
+	r = ipu3_dmamap_init(imgu);
+	if (r) {
+		dev_err(&pci_dev->dev, "failed to init DMA mapping (%d)\n", r);
+		goto failed_dmamap;
+	}
+
+	/* ISP programming */
+	r = ipu3_css_init(&pci_dev->dev, &imgu->css, imgu->base, phys_len);
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
+				      imgu_isr, imgu_isr_threaded,
+				      IRQF_SHARED, IMGU_NAME, imgu);
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
+	ipu3_dmamap_exit(imgu);
+failed_dmamap:
+	ipu3_mmu_exit(imgu->mmu);
+failed_mmu:
+	ipu3_css_set_powerdown(&pci_dev->dev, imgu->base);
+failed_powerup:
+	mutex_destroy(&imgu->lock);
+	return r;
+}
+
+static void imgu_pci_remove(struct pci_dev *pci_dev)
+{
+	struct imgu_device *imgu = pci_get_drvdata(pci_dev);
+
+	pm_runtime_forbid(&pci_dev->dev);
+	pm_runtime_get_noresume(&pci_dev->dev);
+
+	imgu_mem2mem2_exit(imgu);
+	ipu3_css_cleanup(&imgu->css);
+	ipu3_css_set_powerdown(&pci_dev->dev, imgu->base);
+	ipu3_dmamap_exit(imgu);
+	ipu3_mmu_exit(imgu->mmu);
+	mutex_destroy(&imgu->lock);
+	mutex_destroy(&imgu->qbuf_lock);
+}
+
+static int __maybe_unused imgu_suspend(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct imgu_device *imgu = pci_get_drvdata(pci_dev);
+
+	dev_dbg(dev, "enter %s\n", __func__);
+	imgu->suspend_in_stream = ipu3_css_is_streaming(&imgu->css);
+	if (!imgu->suspend_in_stream)
+		goto out;
+	/* Block new buffers to be queued to CSS. */
+	mutex_lock(&imgu->qbuf_lock);
+	/* Wait until all buffers in CSS are done. */
+	if (!wait_event_timeout(imgu->buf_drain_wq, imgu_buffer_drain(imgu),
+				msecs_to_jiffies(1000)))
+		dev_err(dev, "wait buffer drain timeout.\n");
+
+	ipu3_css_stop_streaming(&imgu->css);
+	synchronize_irq(pci_dev->irq);
+	mutex_unlock(&imgu->qbuf_lock);
+	imgu_powerdown(imgu);
+	pm_runtime_force_suspend(dev);
+out:
+	dev_dbg(dev, "leave %s\n", __func__);
+	return 0;
+}
+
+static int __maybe_unused imgu_resume(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct imgu_device *imgu = pci_get_drvdata(pci_dev);
+	int r = 0;
+
+	dev_dbg(dev, "enter %s\n\n", __func__);
+
+	if (!imgu->suspend_in_stream)
+		goto out;
+
+	pm_runtime_force_resume(dev);
+
+	r = imgu_powerup(imgu);
+	if (r) {
+		dev_err(dev, "failed to power up imgu\n");
+		goto out;
+	}
+
+	/* Start CSS streaming */
+	r = ipu3_css_start_streaming(&imgu->css);
+	if (r) {
+		dev_err(dev, "failed to resume css streaming (%d)", r);
+		goto out;
+	}
+
+	r = imgu_queue_buffers(imgu, true);
+	if (r)
+		dev_err(dev, "failed to queue buffers (%d)", r);
+out:
+	dev_dbg(dev, "leave %s\n", __func__);
+
+	return r;
+}
+
+/*
+ * PCI rpm framework checks the existence of driver rpm callbacks.
+ * Place a dummy callback here to avoid rpm going into error state.
+ */
+static int imgu_rpm_dummy_cb(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops imgu_pm_ops = {
+	SET_RUNTIME_PM_OPS(&imgu_rpm_dummy_cb, &imgu_rpm_dummy_cb, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(&imgu_suspend, &imgu_resume)
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
index 000000000000..34fddac40606
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3.h
@@ -0,0 +1,186 @@
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
+#include <linux/iova.h>
+#include <linux/pci.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
+#include "ipu3-css.h"
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
+	struct ipu3_css_map map;
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
+	atomic_t sequence;
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
+		struct ipu3_css_map dmap;
+		struct ipu3_css_buffer dummybufs[IMGU_MAX_QUEUE_DEPTH];
+	} queues[IPU3_CSS_QUEUES];
+	struct imgu_video_device mem2mem2_nodes[IMGU_NODE_NUM];
+	bool queue_enabled[IMGU_NODE_NUM];
+
+	/* Delegate v4l2 support */
+	struct ipu3_mem2mem2_device mem2mem2;
+	/* MMU driver for css */
+	struct device *mmu;
+	struct iommu_domain *domain;
+	struct iova_domain iova_domain;
+	/* css - Camera Sub-System */
+	struct ipu3_css css;
+
+	/*
+	 * Coarse-grained lock to protect
+	 * m2m2_buf.list and css->queue
+	 */
+	struct mutex lock;
+	/* Forbit streaming and buffer queuing during system suspend. */
+	struct mutex qbuf_lock;
+	struct {
+		struct v4l2_rect eff; /* effective resolution */
+		struct v4l2_rect bds; /* bayer-domain scaled resolution*/
+		struct v4l2_rect gdc; /* gdc output resolution */
+	} rect;
+	/* Indicate if system suspend take place while imgu is streaming. */
+	bool suspend_in_stream;
+	/* Used to wait for FW buffer queue drain. */
+	wait_queue_head_t buf_drain_wq;
+};
+
+int imgu_node_to_queue(int node);
+int imgu_map_node(struct imgu_device *imgu, int css_queue);
+int imgu_queue_buffers(struct imgu_device *imgu, bool initial);
+
+int ipu3_v4l2_register(struct imgu_device *dev);
+int ipu3_v4l2_unregister(struct imgu_device *dev);
+void ipu3_v4l2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+
+#endif
-- 
2.7.4
