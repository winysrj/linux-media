Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:35159 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbcDAWip (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2016 18:38:45 -0400
Received: by mail-qg0-f41.google.com with SMTP id y89so108328171qge.2
        for <linux-media@vger.kernel.org>; Fri, 01 Apr 2016 15:38:44 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 2/7] tw686x: Introduce an interface to support multiple DMA modes
Date: Fri,  1 Apr 2016 19:38:22 -0300
Message-Id: <1459550307-688-3-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
References: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's set the corner stone to support all the DMA modes
available on this device.

For stability reasons, the driver is currently setting DMA frame
mode, and using single DMA buffers to get the P and B buffers.
Each frame is then memcpy'ed into the user buffer.

However, other platforms might be interested in avoiding this
memcpy, or in taking advantage of the chip's DMA scatter-gather
capabilities.

To achieve this, this commit introduces a "dma_mode" module parameter,
and a tw686x_dma_ops struct. This will allow to define functions to
alloc/free DMA buffers, and to return the frames to userspace.

The memcpy-based method described above is named as dma_mode="memcpy".
Current alloc/free functions are renamed as tw686x_memcpy_xxx,
and are now used through a memcpy_dma_ops.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/pci/tw686x/tw686x-core.c  |  48 +++++-
 drivers/media/pci/tw686x/tw686x-regs.h  |   5 +
 drivers/media/pci/tw686x/tw686x-video.c | 254 ++++++++++++++++++--------------
 drivers/media/pci/tw686x/tw686x.h       |  20 ++-
 4 files changed, 206 insertions(+), 121 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index cf53b0e97be2..01c06bb59e78 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -21,12 +21,14 @@
  * under stress testings it has been found that the machine can
  * freeze completely if DMA registers are programmed while streaming
  * is active.
- * This driver tries to access hardware registers as infrequently
- * as possible by:
- *   i.  allocating fixed DMA buffers and memcpy'ing into
- *       vmalloc'ed buffers
- *   ii. using a timer to mitigate the rate of DMA reset operations,
- *       on DMA channels error.
+ *
+ * Therefore, driver implements a dma_mode called 'memcpy' which
+ * avoids cycling the DMA buffers, and insteads allocates extra DMA buffers
+ * and then copies into vmalloc'ed user buffers.
+ *
+ * In addition to this, when streaming is on, the driver tries to access
+ * hardware registers as infrequently as possible. This is done by using
+ * a timer to limit the rate at which DMA is reset on DMA channels error.
  */
 
 #include <linux/init.h>
@@ -55,6 +57,34 @@ static u32 dma_interval = 0x00098968;
 module_param(dma_interval, int, 0444);
 MODULE_PARM_DESC(dma_interval, "Minimum time span for DMA interrupting host");
 
+static unsigned int dma_mode = TW686X_DMA_MODE_MEMCPY;
+static const char *dma_mode_name(unsigned int mode)
+{
+	switch (mode) {
+	case TW686X_DMA_MODE_MEMCPY:
+		return "memcpy";
+	default:
+		return "unknown";
+	}
+}
+
+static int tw686x_dma_mode_get(char *buffer, struct kernel_param *kp)
+{
+	return sprintf(buffer, dma_mode_name(dma_mode));
+}
+
+static int tw686x_dma_mode_set(const char *val, struct kernel_param *kp)
+{
+	if (!strcasecmp(val, dma_mode_name(TW686X_DMA_MODE_MEMCPY)))
+		dma_mode = TW686X_DMA_MODE_MEMCPY;
+	else
+		return -EINVAL;
+	return 0;
+}
+module_param_call(dma_mode, tw686x_dma_mode_set, tw686x_dma_mode_get,
+		  &dma_mode, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(dma_mode, "DMA operation mode");
+
 void tw686x_disable_channel(struct tw686x_dev *dev, unsigned int channel)
 {
 	u32 dma_en = reg_read(dev, DMA_CHANNEL_ENABLE);
@@ -212,6 +242,7 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 	if (!dev)
 		return -ENOMEM;
 	dev->type = pci_id->driver_data;
+	dev->dma_mode = dma_mode;
 	sprintf(dev->name, "tw%04X", pci_dev->device);
 
 	dev->video_channels = kcalloc(max_channels(dev),
@@ -228,9 +259,10 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 		goto free_video;
 	}
 
-	pr_info("%s: PCI %s, IRQ %d, MMIO 0x%lx\n", dev->name,
+	pr_info("%s: PCI %s, IRQ %d, MMIO 0x%lx (%s mode)\n", dev->name,
 		pci_name(pci_dev), pci_dev->irq,
-		(unsigned long)pci_resource_start(pci_dev, 0));
+		(unsigned long)pci_resource_start(pci_dev, 0),
+		dma_mode_name(dma_mode));
 
 	dev->pci_dev = pci_dev;
 	if (pci_enable_device(pci_dev)) {
diff --git a/drivers/media/pci/tw686x/tw686x-regs.h b/drivers/media/pci/tw686x/tw686x-regs.h
index fcef586a4c8c..37c39bcd7572 100644
--- a/drivers/media/pci/tw686x/tw686x-regs.h
+++ b/drivers/media/pci/tw686x/tw686x-regs.h
@@ -119,4 +119,9 @@
 #define TW686X_STD_PAL_CN	5
 #define TW686X_STD_PAL_60	6
 
+#define TW686X_FIELD_MODE	0x3
+#define TW686X_FRAME_MODE	0x2
+/* 0x1 is reserved */
+#define TW686X_SG_MODE		0x0
+
 #define TW686X_FIFO_ERROR(x)	(x & ~(0xff))
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 19a348fe04e3..82ae607b1d01 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -43,6 +43,111 @@ static const struct tw686x_format formats[] = {
 	}
 };
 
+static void tw686x_buf_done(struct tw686x_video_channel *vc,
+			    unsigned int pb)
+{
+	struct tw686x_dma_desc *desc = &vc->dma_descs[pb];
+	struct tw686x_dev *dev = vc->dev;
+	struct vb2_v4l2_buffer *vb;
+	struct vb2_buffer *vb2_buf;
+
+	if (vc->curr_bufs[pb]) {
+		vb = &vc->curr_bufs[pb]->vb;
+
+		vb->field = dev->dma_ops->field;
+		vb->sequence = vc->sequence++;
+		vb2_buf = &vb->vb2_buf;
+
+		if (dev->dma_mode == TW686X_DMA_MODE_MEMCPY)
+			memcpy(vb2_plane_vaddr(vb2_buf, 0), desc->virt,
+			       desc->size);
+		vb2_buf->timestamp = ktime_get_ns();
+		vb2_buffer_done(vb2_buf, VB2_BUF_STATE_DONE);
+	}
+
+	vc->pb = !pb;
+}
+
+/*
+ * We can call this even when alloc_dma failed for the given channel
+ */
+static void tw686x_memcpy_dma_free(struct tw686x_video_channel *vc,
+				   unsigned int pb)
+{
+	struct tw686x_dma_desc *desc = &vc->dma_descs[pb];
+	struct tw686x_dev *dev = vc->dev;
+	struct pci_dev *pci_dev;
+	unsigned long flags;
+
+	/* Check device presence. Shouldn't really happen! */
+	spin_lock_irqsave(&dev->lock, flags);
+	pci_dev = dev->pci_dev;
+	spin_unlock_irqrestore(&dev->lock, flags);
+	if (!pci_dev) {
+		WARN(1, "trying to deallocate on missing device\n");
+		return;
+	}
+
+	if (desc->virt) {
+		pci_free_consistent(dev->pci_dev, desc->size,
+				    desc->virt, desc->phys);
+		desc->virt = NULL;
+	}
+}
+
+static int tw686x_memcpy_dma_alloc(struct tw686x_video_channel *vc,
+				   unsigned int pb)
+{
+	struct tw686x_dev *dev = vc->dev;
+	u32 reg = pb ? VDMA_B_ADDR[vc->ch] : VDMA_P_ADDR[vc->ch];
+	unsigned int len;
+	void *virt;
+
+	WARN(vc->dma_descs[pb].virt,
+	     "Allocating buffer but previous still here\n");
+
+	len = (vc->width * vc->height * vc->format->depth) >> 3;
+	virt = pci_alloc_consistent(dev->pci_dev, len,
+				    &vc->dma_descs[pb].phys);
+	if (!virt) {
+		v4l2_err(&dev->v4l2_dev,
+			 "dma%d: unable to allocate %s-buffer\n",
+			 vc->ch, pb ? "B" : "P");
+		return -ENOMEM;
+	}
+	vc->dma_descs[pb].size = len;
+	vc->dma_descs[pb].virt = virt;
+	reg_write(dev, reg, vc->dma_descs[pb].phys);
+
+	return 0;
+}
+
+static void tw686x_memcpy_buf_refill(struct tw686x_video_channel *vc,
+				     unsigned int pb)
+{
+	struct tw686x_v4l2_buf *buf;
+
+	while (!list_empty(&vc->vidq_queued)) {
+
+		buf = list_first_entry(&vc->vidq_queued,
+			struct tw686x_v4l2_buf, list);
+		list_del(&buf->list);
+
+		vc->curr_bufs[pb] = buf;
+		return;
+	}
+	vc->curr_bufs[pb] = NULL;
+}
+
+const struct tw686x_dma_ops memcpy_dma_ops = {
+	.alloc		= tw686x_memcpy_dma_alloc,
+	.free		= tw686x_memcpy_dma_free,
+	.buf_refill	= tw686x_memcpy_buf_refill,
+	.mem_ops	= &vb2_vmalloc_memops,
+	.hw_dma_mode	= TW686X_FRAME_MODE,
+	.field		= V4L2_FIELD_INTERLACED,
+};
+
 static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
 {
 	static const unsigned int map[15] = {
@@ -114,6 +219,7 @@ static int tw686x_queue_setup(struct vb2_queue *vq,
 		return 0;
 	}
 
+	alloc_ctxs[0] = vc->dev->alloc_ctx;
 	sizes[0] = szimage;
 	*nplanes = 1;
 	return 0;
@@ -143,75 +249,6 @@ static void tw686x_buf_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&vc->qlock, flags);
 }
 
-/*
- * We can call this even when alloc_dma failed for the given channel
- */
-static void tw686x_free_dma(struct tw686x_video_channel *vc, unsigned int pb)
-{
-	struct tw686x_dma_desc *desc = &vc->dma_descs[pb];
-	struct tw686x_dev *dev = vc->dev;
-	struct pci_dev *pci_dev;
-	unsigned long flags;
-
-	/* Check device presence. Shouldn't really happen! */
-	spin_lock_irqsave(&dev->lock, flags);
-	pci_dev = dev->pci_dev;
-	spin_unlock_irqrestore(&dev->lock, flags);
-	if (!pci_dev) {
-		WARN(1, "trying to deallocate on missing device\n");
-		return;
-	}
-
-	if (desc->virt) {
-		pci_free_consistent(dev->pci_dev, desc->size,
-				    desc->virt, desc->phys);
-		desc->virt = NULL;
-	}
-}
-
-static int tw686x_alloc_dma(struct tw686x_video_channel *vc, unsigned int pb)
-{
-	struct tw686x_dev *dev = vc->dev;
-	u32 reg = pb ? VDMA_B_ADDR[vc->ch] : VDMA_P_ADDR[vc->ch];
-	unsigned int len;
-	void *virt;
-
-	WARN(vc->dma_descs[pb].virt,
-	     "Allocating buffer but previous still here\n");
-
-	len = (vc->width * vc->height * vc->format->depth) >> 3;
-	virt = pci_alloc_consistent(dev->pci_dev, len,
-				    &vc->dma_descs[pb].phys);
-	if (!virt) {
-		v4l2_err(&dev->v4l2_dev,
-			 "dma%d: unable to allocate %s-buffer\n",
-			 vc->ch, pb ? "B" : "P");
-		return -ENOMEM;
-	}
-	vc->dma_descs[pb].size = len;
-	vc->dma_descs[pb].virt = virt;
-	reg_write(dev, reg, vc->dma_descs[pb].phys);
-
-	return 0;
-}
-
-static void tw686x_buffer_refill(struct tw686x_video_channel *vc,
-				 unsigned int pb)
-{
-	struct tw686x_v4l2_buf *buf;
-
-	while (!list_empty(&vc->vidq_queued)) {
-
-		buf = list_first_entry(&vc->vidq_queued,
-			struct tw686x_v4l2_buf, list);
-		list_del(&buf->list);
-
-		vc->curr_bufs[pb] = buf;
-		return;
-	}
-	vc->curr_bufs[pb] = NULL;
-}
-
 static void tw686x_clear_queue(struct tw686x_video_channel *vc,
 			       enum vb2_buffer_state state)
 {
@@ -253,7 +290,8 @@ static int tw686x_start_streaming(struct vb2_queue *vq, unsigned int count)
 	spin_lock_irqsave(&vc->qlock, flags);
 
 	/* Sanity check */
-	if (!vc->dma_descs[0].virt || !vc->dma_descs[1].virt) {
+	if (dev->dma_mode == TW686X_DMA_MODE_MEMCPY &&
+	    (!vc->dma_descs[0].virt || !vc->dma_descs[1].virt)) {
 		spin_unlock_irqrestore(&vc->qlock, flags);
 		v4l2_err(&dev->v4l2_dev,
 			 "video%d: refusing to start without DMA buffers\n",
@@ -263,7 +301,7 @@ static int tw686x_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	for (pb = 0; pb < 2; pb++)
-		tw686x_buffer_refill(vc, pb);
+		dev->dma_ops->buf_refill(vc, pb);
 	spin_unlock_irqrestore(&vc->qlock, flags);
 
 	vc->sequence = 0;
@@ -366,10 +404,11 @@ static int tw686x_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct tw686x_video_channel *vc = video_drvdata(file);
+	struct tw686x_dev *dev = vc->dev;
 
 	f->fmt.pix.width = vc->width;
 	f->fmt.pix.height = vc->height;
-	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.field = dev->dma_ops->field;
 	f->fmt.pix.pixelformat = vc->format->fourcc;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * vc->format->depth) / 8;
@@ -381,6 +420,7 @@ static int tw686x_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct tw686x_video_channel *vc = video_drvdata(file);
+	struct tw686x_dev *dev = vc->dev;
 	unsigned int video_height = TW686X_VIDEO_HEIGHT(vc->video_standard);
 	const struct tw686x_format *format;
 
@@ -403,7 +443,7 @@ static int tw686x_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * format->depth) / 8;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.field = dev->dma_ops->field;
 
 	return 0;
 }
@@ -412,6 +452,7 @@ static int tw686x_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct tw686x_video_channel *vc = video_drvdata(file);
+	struct tw686x_dev *dev = vc->dev;
 	u32 val, width, line_width, height;
 	unsigned long bitsperframe;
 	int err, pb;
@@ -429,15 +470,16 @@ static int tw686x_s_fmt_vid_cap(struct file *file, void *priv,
 	vc->height = f->fmt.pix.height;
 
 	/* We need new DMA buffers if the framesize has changed */
-	if (bitsperframe != vc->width * vc->height * vc->format->depth) {
+	if (dev->dma_ops->alloc &&
+	    bitsperframe != vc->width * vc->height * vc->format->depth) {
 		for (pb = 0; pb < 2; pb++)
-			tw686x_free_dma(vc, pb);
+			dev->dma_ops->free(vc, pb);
 
 		for (pb = 0; pb < 2; pb++) {
-			err = tw686x_alloc_dma(vc, pb);
+			err = dev->dma_ops->alloc(vc, pb);
 			if (err) {
 				if (pb > 0)
-					tw686x_free_dma(vc, 0);
+					dev->dma_ops->free(vc, 0);
 				return err;
 			}
 		}
@@ -704,26 +746,11 @@ const struct v4l2_ioctl_ops tw686x_video_ioctl_ops = {
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
-static void tw686x_buffer_copy(struct tw686x_video_channel *vc,
-			       unsigned int pb, struct vb2_v4l2_buffer *vb)
-{
-	struct tw686x_dma_desc *desc = &vc->dma_descs[pb];
-	struct vb2_buffer *vb2_buf = &vb->vb2_buf;
-
-	vb->field = V4L2_FIELD_INTERLACED;
-	vb->sequence = vc->sequence++;
-
-	memcpy(vb2_plane_vaddr(vb2_buf, 0), desc->virt, desc->size);
-	vb2_buf->timestamp = ktime_get_ns();
-	vb2_buffer_done(vb2_buf, VB2_BUF_STATE_DONE);
-}
-
 void tw686x_video_irq(struct tw686x_dev *dev, unsigned long requests,
 		      unsigned int pb_status, unsigned int fifo_status,
 		      unsigned int *reset_ch)
 {
 	struct tw686x_video_channel *vc;
-	struct vb2_v4l2_buffer *vb;
 	unsigned long flags;
 	unsigned int ch, pb;
 
@@ -772,14 +799,9 @@ void tw686x_video_irq(struct tw686x_dev *dev, unsigned long requests,
 			continue;
 		}
 
-		/* handle video stream */
 		spin_lock_irqsave(&vc->qlock, flags);
-		if (vc->curr_bufs[pb]) {
-			vb = &vc->curr_bufs[pb]->vb;
-			tw686x_buffer_copy(vc, pb, vb);
-		}
-		vc->pb = !pb;
-		tw686x_buffer_refill(vc, pb);
+		tw686x_buf_done(vc, pb);
+		dev->dma_ops->buf_refill(vc, pb);
 		spin_unlock_irqrestore(&vc->qlock, flags);
 	}
 }
@@ -794,9 +816,13 @@ void tw686x_video_free(struct tw686x_dev *dev)
 		if (vc->device)
 			video_unregister_device(vc->device);
 
-		for (pb = 0; pb < 2; pb++)
-			tw686x_free_dma(vc, pb);
+		if (dev->dma_ops->free)
+			for (pb = 0; pb < 2; pb++)
+				dev->dma_ops->free(vc, pb);
 	}
+
+	if (dev->dma_ops->cleanup)
+		dev->dma_ops->cleanup(dev);
 }
 
 int tw686x_video_init(struct tw686x_dev *dev)
@@ -804,10 +830,21 @@ int tw686x_video_init(struct tw686x_dev *dev)
 	unsigned int ch, val, pb;
 	int err;
 
+	if (dev->dma_mode == TW686X_DMA_MODE_MEMCPY)
+		dev->dma_ops = &memcpy_dma_ops;
+	else
+		return -EINVAL;
+
 	err = v4l2_device_register(&dev->pci_dev->dev, &dev->v4l2_dev);
 	if (err)
 		return err;
 
+	if (dev->dma_ops->setup) {
+		err = dev->dma_ops->setup(dev);
+		if (err)
+			return err;
+	}
+
 	for (ch = 0; ch < max_channels(dev); ch++) {
 		struct tw686x_video_channel *vc = &dev->video_channels[ch];
 		struct video_device *vdev;
@@ -833,10 +870,12 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		reg_write(dev, HACTIVE_LO[ch], 0xd0);
 		reg_write(dev, VIDEO_SIZE[ch], 0);
 
-		for (pb = 0; pb < 2; pb++) {
-			err = tw686x_alloc_dma(vc, pb);
-			if (err)
-				goto error;
+		if (dev->dma_ops->alloc) {
+			for (pb = 0; pb < 2; pb++) {
+				err = dev->dma_ops->alloc(vc, pb);
+				if (err)
+					goto error;
+			}
 		}
 
 		vc->vidq.io_modes = VB2_READ | VB2_MMAP | VB2_DMABUF;
@@ -844,7 +883,7 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		vc->vidq.drv_priv = vc;
 		vc->vidq.buf_struct_size = sizeof(struct tw686x_v4l2_buf);
 		vc->vidq.ops = &tw686x_video_qops;
-		vc->vidq.mem_ops = &vb2_vmalloc_memops;
+		vc->vidq.mem_ops = dev->dma_ops->mem_ops;
 		vc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		vc->vidq.min_buffers_needed = 2;
 		vc->vidq.lock = &vc->vb_mutex;
@@ -906,10 +945,9 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		vc->num = vdev->num;
 	}
 
-	/* Set DMA frame mode on all channels. Only supported mode for now. */
 	val = TW686X_DEF_PHASE_REF;
 	for (ch = 0; ch < max_channels(dev); ch++)
-		val |= TW686X_FRAME_MODE << (16 + ch * 2);
+		val |= dev->dma_ops->hw_dma_mode << (16 + ch * 2);
 	reg_write(dev, PHASE_REF, val);
 
 	reg_write(dev, MISC2[0], 0xe7);
diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
index 103dd4a0d951..2b9884b709e0 100644
--- a/drivers/media/pci/tw686x/tw686x.h
+++ b/drivers/media/pci/tw686x/tw686x.h
@@ -27,16 +27,13 @@
 #define TYPE_SECOND_GEN		0x10
 #define TW686X_DEF_PHASE_REF	0x1518
 
-#define TW686X_FIELD_MODE	0x3
-#define TW686X_FRAME_MODE	0x2
-/* 0x1 is reserved */
-#define TW686X_SG_MODE		0x0
-
 #define TW686X_AUDIO_PAGE_SZ		4096
 #define TW686X_AUDIO_PAGE_MAX		16
 #define TW686X_AUDIO_PERIODS_MIN	2
 #define TW686X_AUDIO_PERIODS_MAX	TW686X_AUDIO_PAGE_MAX
 
+#define TW686X_DMA_MODE_MEMCPY		0
+
 struct tw686x_format {
 	char *name;
 	unsigned fourcc;
@@ -99,6 +96,17 @@ struct tw686x_video_channel {
 	bool no_signal;
 };
 
+struct tw686x_dma_ops {
+	int (*setup)(struct tw686x_dev *dev);
+	void (*cleanup)(struct tw686x_dev *dev);
+	int (*alloc)(struct tw686x_video_channel *vc, unsigned int pb);
+	void (*free)(struct tw686x_video_channel *vc, unsigned int pb);
+	void (*buf_refill)(struct tw686x_video_channel *vc, unsigned int pb);
+	const struct vb2_mem_ops *mem_ops;
+	enum v4l2_field field;
+	u32 hw_dma_mode;
+};
+
 /**
  * struct tw686x_dev - global device status
  * @lock: spinlock controlling access to the
@@ -112,11 +120,13 @@ struct tw686x_dev {
 
 	char name[32];
 	unsigned int type;
+	unsigned int dma_mode;
 	struct pci_dev *pci_dev;
 	__u32 __iomem *mmio;
 
 	void *alloc_ctx;
 
+	const struct tw686x_dma_ops *dma_ops;
 	struct tw686x_video_channel *video_channels;
 	struct tw686x_audio_channel *audio_channels;
 
-- 
2.7.0

