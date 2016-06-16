Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35266 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbcFPRWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 13:22:35 -0400
From: Janusz Krzysztofik <jmkrzyszt@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-omap@vger.kernel.org,
	Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [RFC] [PATCH 3/3] staging: media: omap1: use dmaengine
Date: Thu, 16 Jun 2016 19:21:34 +0200
Message-Id: <1466097694-8660-4-git-send-email-jmkrzyszt@gmail.com>
In-Reply-To: <1466097694-8660-1-git-send-email-jmkrzyszt@gmail.com>
References: <1466097694-8660-1-git-send-email-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Created and tested on Amstrad Delta on top of Linux-4.7-rc3 with
"staging: media: omap1: convert to videobuf2" applied.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
---
 drivers/staging/media/omap1/Kconfig        |   2 +-
 drivers/staging/media/omap1/omap1_camera.c | 432 +++++++++--------------------
 2 files changed, 135 insertions(+), 299 deletions(-)

diff --git a/drivers/staging/media/omap1/Kconfig b/drivers/staging/media/omap1/Kconfig
index 12f1d7a..0b8456d 100644
--- a/drivers/staging/media/omap1/Kconfig
+++ b/drivers/staging/media/omap1/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_OMAP1
 	tristate "OMAP1 Camera Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA
-	depends on ARCH_OMAP1
+	depends on ARCH_OMAP1 && DMA_OMAP
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
diff --git a/drivers/staging/media/omap1/omap1_camera.c b/drivers/staging/media/omap1/omap1_camera.c
index 3761660..e22ba8a 100644
--- a/drivers/staging/media/omap1/omap1_camera.c
+++ b/drivers/staging/media/omap1/omap1_camera.c
@@ -33,11 +33,12 @@
 #include <media/drv-intf/soc_mediabus.h>
 #include <media/videobuf2-dma-contig.h>
 
-#include <linux/omap-dma.h>
+#include <linux/dmaengine.h>
+#include <linux/omap-dmaengine.h>
 
 
 #define DRIVER_NAME		"omap1-camera"
-#define DRIVER_VERSION		"0.0.4"
+#define DRIVER_VERSION		"0.0.5"
 
 #define OMAP_DMA_CAMERA_IF_RX		20
 
@@ -115,8 +116,8 @@
 #define DMA_BURST_SHIFT		(1 + OMAP_DMA_DATA_BURST_4)
 #define DMA_BURST_SIZE		BIT(DMA_BURST_SHIFT)
 
-#define DMA_ELEMENT_SHIFT	OMAP_DMA_DATA_TYPE_S32
-#define DMA_ELEMENT_SIZE	BIT(DMA_ELEMENT_SHIFT)
+#define DMA_ELEMENT_SIZE	DMA_SLAVE_BUSWIDTH_4_BYTES
+#define DMA_ELEMENT_SHIFT	__fls(DMA_ELEMENT_SIZE)
 
 #define DMA_FRAME_SHIFT		(FIFO_SHIFT - 1)
 #define DMA_FRAME_SIZE		BIT(DMA_FRAME_SHIFT)
@@ -124,7 +125,7 @@
 #define THRESHOLD_LEVEL		DMA_FRAME_SIZE
 
 #define OMAP1_CAMERA_MIN_BUF_COUNT \
-				3
+				2
 #define MAX_VIDEO_MEM		4	/* arbitrary video memory limit in MB */
 
 
@@ -145,7 +146,8 @@ struct omap1_cam_dev {
 	unsigned int			irq;
 	void __iomem			*base;
 
-	int				dma_ch;
+	struct dma_chan			*dma_chan;
+	unsigned int			dma_rq;
 
 	struct omap1_cam_platform_data	*pdata;
 	unsigned long			pflags;
@@ -156,10 +158,6 @@ struct omap1_cam_dev {
 	/* lock used to protect videobuf */
 	spinlock_t			lock;
 
-	/* Pointers to DMA buffers */
-	struct omap1_cam_buf		*active;
-	struct omap1_cam_buf		*ready;
-
 	struct vb2_alloc_ctx		*alloc_ctx;
 	int				sequence;
 
@@ -222,6 +220,16 @@ static int omap1_videobuf_setup(struct vb2_queue *vq, unsigned int *count,
 	return 0;
 }
 
+static int omap1_videobuf_init(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct omap1_cam_buf *buf = vb2_to_omap1_cam_buf(vbuf);
+
+	INIT_LIST_HEAD(&buf->queue);
+
+	return 0;
+}
+
 static int omap1_videobuf_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -236,96 +244,27 @@ static int omap1_videobuf_prepare(struct vb2_buffer *vb)
 			vb2_plane_size(vb, 0), size);
 		return -ENOBUFS;
 	}
-
 	vb2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
 
-static void set_dma_dest_params(int dma_ch, struct omap1_cam_buf *buf)
-{
-	dma_addr_t dma_addr =
-			vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
-	unsigned int block_size = vb2_plane_size(&buf->vb.vb2_buf, 0);
-
-	omap_set_dma_dest_params(dma_ch,
-		OMAP_DMA_PORT_EMIFF, OMAP_DMA_AMODE_POST_INC, dma_addr, 0, 0);
-	omap_set_dma_transfer_params(dma_ch,
-		OMAP_DMA_DATA_TYPE_S32, DMA_FRAME_SIZE,
-		block_size >> (DMA_FRAME_SHIFT + DMA_ELEMENT_SHIFT),
-		DMA_SYNC, 0, 0);
-}
-
-static struct omap1_cam_buf *prepare_next_vb(struct omap1_cam_dev *pcdev)
-{
-	struct omap1_cam_buf *buf;
-
-	/*
-	 * If there is already a buffer pointed out by the pcdev->ready,
-	 * (re)use it, otherwise try to fetch and configure a new one.
-	 */
-	buf = pcdev->ready;
-	if (!buf) {
-		if (list_empty(&pcdev->capture))
-			return buf;
-		buf = list_entry(pcdev->capture.next,
-				struct omap1_cam_buf, queue);
-		pcdev->ready = buf;
-		list_del_init(&buf->queue);
-	}
-
-	/*
-	 * In CONTIG mode, we can safely enter next buffer parameters
-	 * into the DMA programming register set after the DMA
-	 * has already been activated on the previous buffer
-	 */
-	set_dma_dest_params(pcdev->dma_ch, buf);
-
-	return buf;
-}
-
-static void start_capture(struct omap1_cam_dev *pcdev)
+static void omap1_dma_complete(void *data)
 {
-	struct omap1_cam_buf *buf = pcdev->active;
-	u32 ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
-	u32 mode = CAM_READ_CACHE(pcdev, MODE) & ~EN_V_DOWN;
-
-	if (WARN_ON(!buf))
-		return;
-
-	/*
-	 * Enable start of frame interrupt, which we will use for activating
-	 * our end of frame watchdog when capture actually starts.
-	 */
-	mode |= EN_V_UP;
-
-	if (unlikely(ctrlclock & LCLK_EN))
-		/* stop pixel clock before FIFO reset */
-		CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
-	/* reset FIFO */
-	CAM_WRITE(pcdev, MODE, mode | RAZ_FIFO);
-
-	omap_start_dma(pcdev->dma_ch);
-
-	/* (re)enable pixel clock */
-	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock | LCLK_EN);
-	/* release FIFO reset */
-	CAM_WRITE(pcdev, MODE, mode);
-}
-
-static void suspend_capture(struct omap1_cam_dev *pcdev)
-{
-	u32 ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
-
-	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
-	omap_stop_dma(pcdev->dma_ch);
-}
+	struct omap1_cam_buf *buf = data;
+	struct soc_camera_device *icd =
+			soc_camera_from_vb2q(buf->vb.vb2_buf.vb2_queue);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
 
-static void disable_capture(struct omap1_cam_dev *pcdev)
-{
-	u32 mode = CAM_READ_CACHE(pcdev, MODE);
+	spin_lock_irq(&pcdev->lock);
+	list_del_init(&buf->queue);
+	spin_unlock_irq(&pcdev->lock);
 
-	CAM_WRITE(pcdev, MODE, mode & ~(IRQ_MASK | DMA));
+	buf->vb.field = V4L2_FIELD_NONE;
+	buf->vb.sequence = pcdev->sequence++;
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 static void omap1_videobuf_queue(struct vb2_buffer *vb)
@@ -335,214 +274,87 @@ static void omap1_videobuf_queue(struct vb2_buffer *vb)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	struct omap1_cam_buf *buf = vb2_to_omap1_cam_buf(vbuf);
-	u32 mode;
-
-	list_add_tail(&buf->queue, &pcdev->capture);
-
-	if (pcdev->active) {
-		/*
-		 * Capture in progress, so don't touch pcdev->ready even if
-		 * empty. Since the transfer of the DMA programming register set
-		 * content to the DMA working register set is done automatically
-		 * by the DMA hardware, this can pretty well happen while we
-		 * are keeping the lock here. Leave fetching it from the queue
-		 * to be done when a next DMA interrupt occures instead.
-		 */
-		return;
-	}
-
-	WARN_ON(pcdev->ready);
-
-	buf = prepare_next_vb(pcdev);
-	if (WARN_ON(!buf))
-		return;
-
-	pcdev->active = buf;
-	pcdev->ready = NULL;
-
-	dev_dbg(icd->parent,
-		"%s: capture not active, setup FIFO, start DMA\n", __func__);
-	mode = CAM_READ_CACHE(pcdev, MODE) & ~THRESHOLD_MASK;
-	mode |= THRESHOLD_LEVEL << THRESHOLD_SHIFT;
-	CAM_WRITE(pcdev, MODE, mode | EN_FIFO_FULL | DMA);
-
-	start_capture(pcdev);
-}
-
-static void omap1_videobuf_release(struct vb2_buffer *vb)
-{
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct omap1_cam_buf *buf = vb2_to_omap1_cam_buf(vbuf);
-
-	list_del_init(&buf->queue);
-}
-
-static int omap1_videobuf_init(struct vb2_buffer *vb)
-{
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct omap1_cam_buf *buf = vb2_to_omap1_cam_buf(vbuf);
-
-	INIT_LIST_HEAD(&buf->queue);
-	return 0;
-}
-
-static void videobuf_done(struct omap1_cam_dev *pcdev,
-		enum vb2_buffer_state result)
-{
-	struct omap1_cam_buf *buf = pcdev->active;
-	struct vb2_v4l2_buffer *vb;
-	struct device *dev = pcdev->soc_host.icd->parent;
-
-	if (WARN_ON(!buf)) {
-		suspend_capture(pcdev);
-		disable_capture(pcdev);
-		return;
+	dma_addr_t dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	unsigned int size = vb2_plane_size(vb, 0);
+	struct dma_async_tx_descriptor *dma_desc;
+
+	dma_desc = dmaengine_prep_slave_single(pcdev->dma_chan, dma_addr, size,
+					       DMA_DEV_TO_MEM, DMA_CTRL_ACK);
+	if (!dma_desc) {
+		dev_err(icd->parent, "Failed to prepare DMA transfer\n");
+		goto err;
 	}
 
-	if (result == VB2_BUF_STATE_ERROR)
-		suspend_capture(pcdev);
-
-	vb = &buf->vb;
-	if (!pcdev->ready && result != VB2_BUF_STATE_ERROR) {
-		/*
-		 * No next buffer has been entered into the DMA
-		 * programming register set on time (could be done only
-		 * while the previous DMA interurpt was processed, not
-		 * later), so the last DMA block (whole buffer) is
-		 * about to be reused by the just autoreinitialized DMA
-		 * engine, and overwritten with next frame data. Best we
-		 * can do is stopping the capture as soon as possible,
-		 * hopefully before the next frame start.
-		 */
-		suspend_capture(pcdev);
+	dma_desc->callback = omap1_dma_complete;
+	dma_desc->callback_param = (void *)buf;
+	if (dma_submit_error(dmaengine_submit(dma_desc))) {
+		dev_err(icd->parent, "DMA submission failed\n");
+		goto err;
 	}
-	vb->vb2_buf.timestamp = ktime_get_ns();
-	if (result != VB2_BUF_STATE_ERROR)
-		vb->sequence = pcdev->sequence++;
-	vb2_buffer_done(&vb->vb2_buf, result);
 
-	/* shift in next buffer */
-	buf = pcdev->ready;
-	pcdev->active = buf;
-	pcdev->ready = NULL;
-
-	if (!buf) {
-		/*
-		 * No next buffer was ready on time (see above), so
-		 * indicate error condition to force capture restart or
-		 * stop, depending on next buffer already queued or not.
-		 */
-		result = VB2_BUF_STATE_ERROR;
-		prepare_next_vb(pcdev);
-
-		buf = pcdev->ready;
-		pcdev->active = buf;
-		pcdev->ready = NULL;
-	}
-
-	if (!buf) {
-		dev_dbg(dev, "%s: no more videobufs, stop capture\n", __func__);
-		disable_capture(pcdev);
-		return;
-	}
+	spin_lock_irq(&pcdev->lock);
+	list_add_tail(&buf->queue, &pcdev->capture);
+	spin_unlock_irq(&pcdev->lock);
 
-	/*
-	 * the current buffer parameters had already
-	 * been entered into the DMA programming register set while the
-	 * buffer was fetched with prepare_next_vb(), they may have also
-	 * been transferred into the runtime set and already active if
-	 * the DMA still running.
-	 */
+	if (vb2_is_streaming(vb->vb2_queue))
+		dma_async_issue_pending(pcdev->dma_chan);
 
-	if (result == VB2_BUF_STATE_ERROR) {
-		dev_dbg(dev, "%s: videobuf error; reset FIFO, restart DMA\n",
-				__func__);
-		start_capture(pcdev);
-	}
+	return;
 
-	/*
-	 * Finally, try fetching next buffer.
-	 * That will also enter it into the DMA programming
-	 * register set, making it ready for next DMA autoreinitialization.
-	 */
-	prepare_next_vb(pcdev);
+err:
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 }
 
-static void omap1_stop_streaming(struct vb2_queue *vq)
+static int omap1_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
-	struct omap1_cam_buf *buf, *tmp;
-
-	spin_lock_irq(&pcdev->lock);
-
-	list_for_each_entry_safe(buf, tmp, &pcdev->capture, queue) {
-		list_del_init(&buf->queue);
-		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
-	}
-
-	if (pcdev->ready)
-		videobuf_done(pcdev, VB2_BUF_STATE_ERROR);
-	if (pcdev->active)
-		videobuf_done(pcdev, VB2_BUF_STATE_ERROR);
-
-	spin_unlock_irq(&pcdev->lock);
-}
+	u32 ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
+	u32 mode = CAM_READ_CACHE(pcdev, MODE);
 
-static void dma_isr(int channel, unsigned short status, void *data)
-{
-	struct omap1_cam_dev *pcdev = data;
-	struct omap1_cam_buf *buf = pcdev->active;
-	unsigned long flags;
+	mode &= ~THRESHOLD_MASK;
+	mode |= (THRESHOLD_LEVEL << THRESHOLD_SHIFT) | EN_FIFO_FULL | DMA;
+	CAM_WRITE(pcdev, MODE, mode);
 
-	spin_lock_irqsave(&pcdev->lock, flags);
+	if (unlikely(ctrlclock & LCLK_EN))
+		/* stop pixel clock before FIFO reset */
+		CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
+	/* reset FIFO */
+	CAM_WRITE(pcdev, MODE, mode | RAZ_FIFO);
 
-	if (WARN_ON(!buf)) {
-		suspend_capture(pcdev);
-		disable_capture(pcdev);
-		goto out;
-	}
+	dma_async_issue_pending(pcdev->dma_chan);
 
-	/*
-	 * Assume we have just managed to collect the
-	 * whole frame, hopefully before our end of frame watchdog is
-	 * triggered. Then, all we have to do is disabling the watchdog
-	 * for this frame, and calling videobuf_done() with success
-	 * indicated.
-	 */
-	CAM_WRITE(pcdev, MODE, CAM_READ_CACHE(pcdev, MODE) & ~EN_V_DOWN);
-	videobuf_done(pcdev, VB2_BUF_STATE_DONE);
+	/* (re)enable pixel clock */
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock | LCLK_EN);
+	/* release FIFO reset */
+	CAM_WRITE(pcdev, MODE, mode);
 
-out:
-	spin_unlock_irqrestore(&pcdev->lock, flags);
+	return 0;
 }
 
-static irqreturn_t cam_isr(int irq, void *data)
+static irqreturn_t omap1_cam_isr(int irq, void *data)
 {
 	struct omap1_cam_dev *pcdev = data;
-	struct device *dev = pcdev->soc_host.icd->parent;
-	struct omap1_cam_buf *buf = pcdev->active;
+	struct device *dev;
 	u32 it_status;
 	unsigned long flags;
-
-	it_status = CAM_READ(pcdev, IT_STATUS);
-	if (!it_status)
-		return IRQ_NONE;
+	irqreturn_t ret;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
-	if (WARN_ON(!buf)) {
-		dev_warn(dev, "%s: unhandled camera interrupt, status == %#x\n",
-			 __func__, it_status);
-		suspend_capture(pcdev);
-		disable_capture(pcdev);
+	ret = IRQ_HANDLED;
+
+	it_status = CAM_READ(pcdev, IT_STATUS);
+	if (!it_status) {
+		ret = IRQ_NONE;
 		goto out;
 	}
 
+	dev = pcdev->soc_host.icd->parent;
+
 	if (unlikely(it_status & FIFO_FULL)) {
 		dev_warn(dev, "%s: FIFO overflow\n", __func__);
-
 	} else if (it_status & V_DOWN) {
 		/* End of video frame watchdog
 		 * the watchdog is disabled with
@@ -552,7 +364,6 @@ static irqreturn_t cam_isr(int irq, void *data)
 		 */
 		dev_notice(dev, "%s: unexpected end of video frame\n",
 				__func__);
-
 	} else if (it_status & V_UP) {
 		u32 mode;
 
@@ -568,28 +379,47 @@ static irqreturn_t cam_isr(int irq, void *data)
 		}
 		CAM_WRITE(pcdev, MODE, mode);
 		goto out;
-
 	} else {
 		dev_warn(dev, "%s: unhandled camera interrupt, status == %#x\n",
 				__func__, it_status);
 		goto out;
 	}
 
-	videobuf_done(pcdev, VB2_BUF_STATE_ERROR);
 out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
-	return IRQ_HANDLED;
+	return ret;
+}
+
+static void omap1_stop_streaming(struct vb2_queue *vq)
+{
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	struct omap1_cam_buf *buf, *tmp;
+	u32 ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
+	u32 mode = CAM_READ_CACHE(pcdev, MODE);
+
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
+	dmaengine_terminate_sync(pcdev->dma_chan);
+	CAM_WRITE(pcdev, MODE, mode & ~(IRQ_MASK | DMA));
+
+	spin_lock_irq(&pcdev->lock);
+	list_for_each_entry_safe(buf, tmp, &pcdev->capture, queue) {
+		list_del_init(&buf->queue);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irq(&pcdev->lock);
 }
 
 static struct vb2_ops omap1_videobuf_ops = {
-	.queue_setup	= omap1_videobuf_setup,
-	.buf_prepare	= omap1_videobuf_prepare,
-	.buf_queue	= omap1_videobuf_queue,
-	.buf_cleanup	= omap1_videobuf_release,
-	.buf_init	= omap1_videobuf_init,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
-	.stop_streaming	= omap1_stop_streaming,
+	.queue_setup		= omap1_videobuf_setup,
+	.buf_init		= omap1_videobuf_init,
+	.buf_prepare		= omap1_videobuf_prepare,
+	.buf_queue		= omap1_videobuf_queue,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+	.start_streaming	= omap1_start_streaming,
+	.stop_streaming		= omap1_stop_streaming,
 };
 
 
@@ -671,9 +501,6 @@ static void omap1_cam_clock_stop(struct soc_camera_host *ici)
 	struct omap1_cam_dev *pcdev = ici->priv;
 	u32 ctrlclock;
 
-	suspend_capture(pcdev);
-	disable_capture(pcdev);
-
 	sensor_reset(pcdev, true);
 
 	/* disable and release system clocks */
@@ -1206,6 +1033,8 @@ static int omap1_cam_probe(struct platform_device *pdev)
 	void __iomem *base;
 	unsigned int irq;
 	int err = 0;
+	dma_cap_mask_t mask;
+	struct dma_slave_config dma_cfg;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
@@ -1260,24 +1089,31 @@ static int omap1_cam_probe(struct platform_device *pdev)
 
 	sensor_reset(pcdev, true);
 
-	err = omap_request_dma(OMAP_DMA_CAMERA_IF_RX, DRIVER_NAME,
-			dma_isr, (void *)pcdev, &pcdev->dma_ch);
-	if (err < 0) {
+	pcdev->dma_rq = OMAP_DMA_CAMERA_IF_RX;
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	pcdev->dma_chan = __dma_request_channel(&mask, omap_dma_filter_fn,
+			(void *)&pcdev->dma_rq);
+	if (!pcdev->dma_chan) {
 		dev_err(&pdev->dev, "Can't request DMA for OMAP1 Camera\n");
 		return -EBUSY;
 	}
-	dev_dbg(&pdev->dev, "got DMA channel %d\n", pcdev->dma_ch);
+	dev_dbg(&pdev->dev, "got DMA channel %d\n", pcdev->dma_chan->chan_id);
 
 	/* preconfigure DMA */
-	omap_set_dma_src_params(pcdev->dma_ch, OMAP_DMA_PORT_TIPB,
-			OMAP_DMA_AMODE_CONSTANT, res->start + REG_CAMDATA,
-			0, 0);
-	omap_set_dma_dest_burst_mode(pcdev->dma_ch, OMAP_DMA_DATA_BURST_4);
-	/* setup DMA autoinitialization */
-	omap_dma_link_lch(pcdev->dma_ch, pcdev->dma_ch);
-
-	err = devm_request_irq(&pdev->dev, pcdev->irq, cam_isr, 0, DRIVER_NAME,
-			       pcdev);
+	memset(&dma_cfg, 0, sizeof(dma_cfg));
+	dma_cfg.direction = DMA_DEV_TO_MEM;
+	dma_cfg.src_addr = res->start + REG_CAMDATA;
+	dma_cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dma_cfg.src_maxburst = DMA_FRAME_SIZE;
+	err = dmaengine_slave_config(pcdev->dma_chan, &dma_cfg);
+	if (err) {
+		dev_err(&pdev->dev, "DMA slave configuration failed\n");
+		goto exit_free_dma;
+	}
+
+	err = devm_request_irq(&pdev->dev, pcdev->irq, omap1_cam_isr, 0,
+			       DRIVER_NAME, pcdev);
 	if (err) {
 		dev_err(&pdev->dev, "Camera interrupt register failed\n");
 		goto exit_free_dma;
@@ -1310,7 +1146,7 @@ static int omap1_cam_probe(struct platform_device *pdev)
 exit_free_ctx:
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 exit_free_dma:
-	omap_free_dma(pcdev->dma_ch);
+	dma_release_channel(pcdev->dma_chan);
 	return err;
 }
 
@@ -1320,7 +1156,7 @@ static int omap1_cam_remove(struct platform_device *pdev)
 	struct omap1_cam_dev *pcdev = container_of(soc_host,
 					struct omap1_cam_dev, soc_host);
 
-	omap_free_dma(pcdev->dma_ch);
+	dma_release_channel(pcdev->dma_chan);
 
 	soc_camera_host_unregister(soc_host);
 
-- 
2.7.3

