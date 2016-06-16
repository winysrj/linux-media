Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33480 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbcFPRWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 13:22:18 -0400
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
Subject: [RFC] [PATCH 1/3] staging: media: omap1: drop videobuf-dma-sg mode
Date: Thu, 16 Jun 2016 19:21:32 +0200
Message-Id: <1466097694-8660-2-git-send-email-jmkrzyszt@gmail.com>
In-Reply-To: <1466097694-8660-1-git-send-email-jmkrzyszt@gmail.com>
References: <1466097694-8660-1-git-send-email-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For over 20 last kernel versions the driver has been able to allocate
DMA buffers in videobuf-dma-contig mode without any issues. Drop the
no longer needed sg mode in preparation for conversion to videobuf2.

Created and tested on Amstrad Delta against Linux-4.7-rc3 with
omap1_camera and ov6650 fixes applied.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
---
 drivers/staging/media/omap1/Kconfig              |   1 -
 drivers/staging/media/omap1/omap1_camera.c       | 445 ++++-------------------
 include/linux/platform_data/media/omap1_camera.h |   9 -
 3 files changed, 77 insertions(+), 378 deletions(-)

diff --git a/drivers/staging/media/omap1/Kconfig b/drivers/staging/media/omap1/Kconfig
index 6cfab3a..e2a39f5 100644
--- a/drivers/staging/media/omap1/Kconfig
+++ b/drivers/staging/media/omap1/Kconfig
@@ -4,7 +4,6 @@ config VIDEO_OMAP1
 	depends on ARCH_OMAP1
 	depends on HAS_DMA
 	select VIDEOBUF_DMA_CONTIG
-	select VIDEOBUF_DMA_SG
 	---help---
 	  This is a v4l2 driver for the TI OMAP1 camera interface
 
diff --git a/drivers/staging/media/omap1/omap1_camera.c b/drivers/staging/media/omap1/omap1_camera.c
index 9b6140a..37ef4da 100644
--- a/drivers/staging/media/omap1/omap1_camera.c
+++ b/drivers/staging/media/omap1/omap1_camera.c
@@ -32,13 +32,12 @@
 #include <media/soc_camera.h>
 #include <media/drv-intf/soc_mediabus.h>
 #include <media/videobuf-dma-contig.h>
-#include <media/videobuf-dma-sg.h>
 
 #include <linux/omap-dma.h>
 
 
 #define DRIVER_NAME		"omap1-camera"
-#define DRIVER_VERSION		"0.0.2"
+#define DRIVER_VERSION		"0.0.3"
 
 #define OMAP_DMA_CAMERA_IF_RX		20
 
@@ -114,22 +113,18 @@
 #define FIFO_SHIFT		__fls(FIFO_SIZE)
 
 #define DMA_BURST_SHIFT		(1 + OMAP_DMA_DATA_BURST_4)
-#define DMA_BURST_SIZE		(1 << DMA_BURST_SHIFT)
+#define DMA_BURST_SIZE		BIT(DMA_BURST_SHIFT)
 
 #define DMA_ELEMENT_SHIFT	OMAP_DMA_DATA_TYPE_S32
-#define DMA_ELEMENT_SIZE	(1 << DMA_ELEMENT_SHIFT)
+#define DMA_ELEMENT_SIZE	BIT(DMA_ELEMENT_SHIFT)
 
-#define DMA_FRAME_SHIFT_CONTIG	(FIFO_SHIFT - 1)
-#define DMA_FRAME_SHIFT_SG	DMA_BURST_SHIFT
-
-#define DMA_FRAME_SHIFT(x)	((x) == OMAP1_CAM_DMA_CONTIG ? \
-						DMA_FRAME_SHIFT_CONTIG : \
-						DMA_FRAME_SHIFT_SG)
-#define DMA_FRAME_SIZE(x)	(1 << DMA_FRAME_SHIFT(x))
+#define DMA_FRAME_SHIFT		(FIFO_SHIFT - 1)
+#define DMA_FRAME_SIZE		BIT(DMA_FRAME_SHIFT)
 #define DMA_SYNC		OMAP_DMA_SYNC_FRAME
 #define THRESHOLD_LEVEL		DMA_FRAME_SIZE
 
-
+#define OMAP1_CAMERA_MIN_BUF_COUNT \
+				3
 #define MAX_VIDEO_MEM		4	/* arbitrary video memory limit in MB */
 
 
@@ -140,12 +135,8 @@
 /* buffer for one video frame */
 struct omap1_cam_buf {
 	struct videobuf_buffer		vb;
-	u32	code;
+	u32				code;
 	int				inwork;
-	struct scatterlist		*sgbuf;
-	int				sgcount;
-	int				bytes_left;
-	enum videobuf_state		result;
 };
 
 struct omap1_cam_dev {
@@ -170,11 +161,6 @@ struct omap1_cam_dev {
 	struct omap1_cam_buf		*active;
 	struct omap1_cam_buf		*ready;
 
-	enum omap1_cam_vb_mode		vb_mode;
-	int				(*mmap_mapper)(struct videobuf_queue *q,
-						struct videobuf_buffer *buf,
-						struct vm_area_struct *vma);
-
 	u32				reg_cache[0];
 };
 
@@ -205,13 +191,11 @@ static int omap1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 		unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct omap1_cam_dev *pcdev = ici->priv;
 
 	*size = icd->sizeimage;
 
-	if (!*count || *count < OMAP1_CAMERA_MIN_BUF_COUNT(pcdev->vb_mode))
-		*count = OMAP1_CAMERA_MIN_BUF_COUNT(pcdev->vb_mode);
+	if (!*count || *count < OMAP1_CAMERA_MIN_BUF_COUNT)
+		*count = OMAP1_CAMERA_MIN_BUF_COUNT;
 
 	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
 		*count = (MAX_VIDEO_MEM * 1024 * 1024) / *size;
@@ -222,8 +206,7 @@ static int omap1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	return 0;
 }
 
-static void free_buffer(struct videobuf_queue *vq, struct omap1_cam_buf *buf,
-		enum omap1_cam_vb_mode vb_mode)
+static void free_buffer(struct videobuf_queue *vq, struct omap1_cam_buf *buf)
 {
 	struct videobuf_buffer *vb = &buf->vb;
 
@@ -231,16 +214,7 @@ static void free_buffer(struct videobuf_queue *vq, struct omap1_cam_buf *buf,
 
 	videobuf_waiton(vq, vb, 0, 0);
 
-	if (vb_mode == OMAP1_CAM_DMA_CONTIG) {
-		videobuf_dma_contig_free(vq, vb);
-	} else {
-		struct soc_camera_device *icd = vq->priv_data;
-		struct device *dev = icd->parent;
-		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-
-		videobuf_dma_unmap(dev, dma);
-		videobuf_dma_free(dma);
-	}
+	videobuf_dma_contig_free(vq, vb);
 
 	vb->state = VIDEOBUF_NEEDS_INIT;
 }
@@ -250,8 +224,6 @@ static int omap1_videobuf_prepare(struct videobuf_queue *vq,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct omap1_cam_buf *buf = container_of(vb, struct omap1_cam_buf, vb);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct omap1_cam_dev *pcdev = ici->priv;
 	int ret;
 
 	WARN_ON(!list_empty(&vb->queue));
@@ -288,56 +260,25 @@ static int omap1_videobuf_prepare(struct videobuf_queue *vq,
 
 	return 0;
 fail:
-	free_buffer(vq, buf, pcdev->vb_mode);
+	free_buffer(vq, buf);
 out:
 	buf->inwork = 0;
 	return ret;
 }
 
-static void set_dma_dest_params(int dma_ch, struct omap1_cam_buf *buf,
-		enum omap1_cam_vb_mode vb_mode)
+static void set_dma_dest_params(int dma_ch, struct omap1_cam_buf *buf)
 {
 	dma_addr_t dma_addr;
 	unsigned int block_size;
 
-	if (vb_mode == OMAP1_CAM_DMA_CONTIG) {
-		dma_addr = videobuf_to_dma_contig(&buf->vb);
-		block_size = buf->vb.size;
-	} else {
-		if (WARN_ON(!buf->sgbuf)) {
-			buf->result = VIDEOBUF_ERROR;
-			return;
-		}
-		dma_addr = sg_dma_address(buf->sgbuf);
-		if (WARN_ON(!dma_addr)) {
-			buf->sgbuf = NULL;
-			buf->result = VIDEOBUF_ERROR;
-			return;
-		}
-		block_size = sg_dma_len(buf->sgbuf);
-		if (WARN_ON(!block_size)) {
-			buf->sgbuf = NULL;
-			buf->result = VIDEOBUF_ERROR;
-			return;
-		}
-		if (unlikely(buf->bytes_left < block_size))
-			block_size = buf->bytes_left;
-		if (WARN_ON(dma_addr & (DMA_FRAME_SIZE(vb_mode) *
-				DMA_ELEMENT_SIZE - 1))) {
-			dma_addr = ALIGN(dma_addr, DMA_FRAME_SIZE(vb_mode) *
-					DMA_ELEMENT_SIZE);
-			block_size &= ~(DMA_FRAME_SIZE(vb_mode) *
-					DMA_ELEMENT_SIZE - 1);
-		}
-		buf->bytes_left -= block_size;
-		buf->sgcount++;
-	}
+	dma_addr = videobuf_to_dma_contig(&buf->vb);
+	block_size = buf->vb.size;
 
 	omap_set_dma_dest_params(dma_ch,
 		OMAP_DMA_PORT_EMIFF, OMAP_DMA_AMODE_POST_INC, dma_addr, 0, 0);
 	omap_set_dma_transfer_params(dma_ch,
-		OMAP_DMA_DATA_TYPE_S32, DMA_FRAME_SIZE(vb_mode),
-		block_size >> (DMA_FRAME_SHIFT(vb_mode) + DMA_ELEMENT_SHIFT),
+		OMAP_DMA_DATA_TYPE_S32, DMA_FRAME_SIZE,
+		block_size >> (DMA_FRAME_SHIFT + DMA_ELEMENT_SHIFT),
 		DMA_SYNC, 0, 0);
 }
 
@@ -360,68 +301,16 @@ static struct omap1_cam_buf *prepare_next_vb(struct omap1_cam_dev *pcdev)
 		list_del_init(&buf->vb.queue);
 	}
 
-	if (pcdev->vb_mode == OMAP1_CAM_DMA_CONTIG) {
-		/*
-		 * In CONTIG mode, we can safely enter next buffer parameters
-		 * into the DMA programming register set after the DMA
-		 * has already been activated on the previous buffer
-		 */
-		set_dma_dest_params(pcdev->dma_ch, buf, pcdev->vb_mode);
-	} else {
-		/*
-		 * In SG mode, the above is not safe since there are probably
-		 * a bunch of sgbufs from previous sglist still pending.
-		 * Instead, mark the sglist fresh for the upcoming
-		 * try_next_sgbuf().
-		 */
-		buf->sgbuf = NULL;
-	}
+	/*
+	 * In CONTIG mode, we can safely enter next buffer parameters
+	 * into the DMA programming register set after the DMA
+	 * has already been activated on the previous buffer
+	 */
+	set_dma_dest_params(pcdev->dma_ch, buf);
 
 	return buf;
 }
 
-static struct scatterlist *try_next_sgbuf(int dma_ch, struct omap1_cam_buf *buf)
-{
-	struct scatterlist *sgbuf;
-
-	if (likely(buf->sgbuf)) {
-		/* current sglist is active */
-		if (unlikely(!buf->bytes_left)) {
-			/* indicate sglist complete */
-			sgbuf = NULL;
-		} else {
-			/* process next sgbuf */
-			sgbuf = sg_next(buf->sgbuf);
-			if (WARN_ON(!sgbuf)) {
-				buf->result = VIDEOBUF_ERROR;
-			} else if (WARN_ON(!sg_dma_len(sgbuf))) {
-				sgbuf = NULL;
-				buf->result = VIDEOBUF_ERROR;
-			}
-		}
-		buf->sgbuf = sgbuf;
-	} else {
-		/* sglist is fresh, initialize it before using */
-		struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
-
-		sgbuf = dma->sglist;
-		if (!(WARN_ON(!sgbuf))) {
-			buf->sgbuf = sgbuf;
-			buf->sgcount = 0;
-			buf->bytes_left = buf->vb.size;
-			buf->result = VIDEOBUF_DONE;
-		}
-	}
-	if (sgbuf)
-		/*
-		 * Put our next sgbuf parameters (address, size)
-		 * into the DMA programming register set.
-		 */
-		set_dma_dest_params(dma_ch, buf, OMAP1_CAM_DMA_SG);
-
-	return sgbuf;
-}
-
 static void start_capture(struct omap1_cam_dev *pcdev)
 {
 	struct omap1_cam_buf *buf = pcdev->active;
@@ -445,15 +334,6 @@ static void start_capture(struct omap1_cam_dev *pcdev)
 
 	omap_start_dma(pcdev->dma_ch);
 
-	if (pcdev->vb_mode == OMAP1_CAM_DMA_SG) {
-		/*
-		 * In SG mode, it's a good moment for fetching next sgbuf
-		 * from the current sglist and, if available, already putting
-		 * its parameters into the DMA programming register set.
-		 */
-		try_next_sgbuf(pcdev->dma_ch, buf);
-	}
-
 	/* (re)enable pixel clock */
 	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock | LCLK_EN);
 	/* release FIFO reset */
@@ -511,18 +391,9 @@ static void omap1_videobuf_queue(struct videobuf_queue *vq,
 	dev_dbg(icd->parent,
 		"%s: capture not active, setup FIFO, start DMA\n", __func__);
 	mode = CAM_READ_CACHE(pcdev, MODE) & ~THRESHOLD_MASK;
-	mode |= THRESHOLD_LEVEL(pcdev->vb_mode) << THRESHOLD_SHIFT;
+	mode |= THRESHOLD_LEVEL << THRESHOLD_SHIFT;
 	CAM_WRITE(pcdev, MODE, mode | EN_FIFO_FULL | DMA);
 
-	if (pcdev->vb_mode == OMAP1_CAM_DMA_SG) {
-		/*
-		 * In SG mode, the above prepare_next_vb() didn't actually
-		 * put anything into the DMA programming register set,
-		 * so we have to do it now, before activating DMA.
-		 */
-		try_next_sgbuf(pcdev->dma_ch, buf);
-	}
-
 	start_capture(pcdev);
 }
 
@@ -533,8 +404,6 @@ static void omap1_videobuf_release(struct videobuf_queue *vq,
 			container_of(vb, struct omap1_cam_buf, vb);
 	struct soc_camera_device *icd = vq->priv_data;
 	struct device *dev = icd->parent;
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct omap1_cam_dev *pcdev = ici->priv;
 
 	switch (vb->state) {
 	case VIDEOBUF_DONE:
@@ -554,7 +423,7 @@ static void omap1_videobuf_release(struct videobuf_queue *vq,
 		break;
 	}
 
-	free_buffer(vq, buf, pcdev->vb_mode);
+	free_buffer(vq, buf);
 }
 
 static void videobuf_done(struct omap1_cam_dev *pcdev,
@@ -580,8 +449,7 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 			 * No next buffer has been entered into the DMA
 			 * programming register set on time (could be done only
 			 * while the previous DMA interurpt was processed, not
-			 * later), so the last DMA block, be it a whole buffer
-			 * if in CONTIG or its last sgbuf if in SG mode, is
+			 * later), so the last DMA block (whole buffer) is
 			 * about to be reused by the just autoreinitialized DMA
 			 * engine, and overwritten with next frame data. Best we
 			 * can do is stopping the capture as soon as possible,
@@ -615,7 +483,7 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 		}
 	} else if (pcdev->ready) {
 		/*
-		 * In both CONTIG and SG mode, the DMA engine has possibly
+		 * The DMA engine has possibly
 		 * been already autoreinitialized with the preprogrammed
 		 * pcdev->ready buffer.  We can either accept this fact
 		 * and just swap the buffers, or provoke an error condition
@@ -625,14 +493,6 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 				__func__);
 		pcdev->active = pcdev->ready;
 
-		if (pcdev->vb_mode == OMAP1_CAM_DMA_SG) {
-			/*
-			 * In SG mode, we have to make sure that the buffer we
-			 * are putting back into the pcdev->ready is marked
-			 * fresh.
-			 */
-			buf->sgbuf = NULL;
-		}
 		pcdev->ready = buf;
 
 		buf = pcdev->active;
@@ -640,29 +500,13 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 		/*
 		 * No next buffer has been entered into
 		 * the DMA programming register set on time.
+		 * the DMA engine has already been reinitialized
+		 * with the current buffer. Best we can do
+		 * is not touching it.
 		 */
-		if (pcdev->vb_mode == OMAP1_CAM_DMA_CONTIG) {
-			/*
-			 * In CONTIG mode, the DMA engine has already been
-			 * reinitialized with the current buffer. Best we can do
-			 * is not touching it.
-			 */
-			dev_dbg(dev,
-				"%s: nobody waiting on videobuf, reuse it\n",
-				__func__);
-		} else {
-			/*
-			 * In SG mode, the DMA engine has just been
-			 * autoreinitialized with the last sgbuf from the
-			 * current list. Restart capture in order to transfer
-			 * next frame start into the first sgbuf, not the last
-			 * one.
-			 */
-			if (result != VIDEOBUF_ERROR) {
-				suspend_capture(pcdev);
-				result = VIDEOBUF_ERROR;
-			}
-		}
+		dev_dbg(dev,
+			"%s: nobody waiting on videobuf, reuse it\n",
+			__func__);
 	}
 
 	if (!buf) {
@@ -671,43 +515,23 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 		return;
 	}
 
-	if (pcdev->vb_mode == OMAP1_CAM_DMA_CONTIG) {
-		/*
-		 * In CONTIG mode, the current buffer parameters had already
-		 * been entered into the DMA programming register set while the
-		 * buffer was fetched with prepare_next_vb(), they may have also
-		 * been transferred into the runtime set and already active if
-		 * the DMA still running.
-		 */
-	} else {
-		/* In SG mode, extra steps are required */
-		if (result == VIDEOBUF_ERROR)
-			/* make sure we (re)use sglist from start on error */
-			buf->sgbuf = NULL;
-
-		/*
-		 * In any case, enter the next sgbuf parameters into the DMA
-		 * programming register set.  They will be used either during
-		 * nearest DMA autoreinitialization or, in case of an error,
-		 * on DMA startup below.
-		 */
-		try_next_sgbuf(pcdev->dma_ch, buf);
-	}
+	/*
+	 * the current buffer parameters had already
+	 * been entered into the DMA programming register set while the
+	 * buffer was fetched with prepare_next_vb(), they may have also
+	 * been transferred into the runtime set and already active if
+	 * the DMA still running.
+	 */
 
 	if (result == VIDEOBUF_ERROR) {
 		dev_dbg(dev, "%s: videobuf error; reset FIFO, restart DMA\n",
 				__func__);
 		start_capture(pcdev);
-		/*
-		 * In SG mode, the above also resulted in the next sgbuf
-		 * parameters being entered into the DMA programming register
-		 * set, making them ready for next DMA autoreinitialization.
-		 */
 	}
 
 	/*
 	 * Finally, try fetching next buffer.
-	 * In CONTIG mode, it will also enter it into the DMA programming
+	 * That will also enter it into the DMA programming
 	 * register set, making it ready for next DMA autoreinitialization.
 	 */
 	prepare_next_vb(pcdev);
@@ -727,59 +551,15 @@ static void dma_isr(int channel, unsigned short status, void *data)
 		goto out;
 	}
 
-	if (pcdev->vb_mode == OMAP1_CAM_DMA_CONTIG) {
-		/*
-		 * In CONTIG mode, assume we have just managed to collect the
-		 * whole frame, hopefully before our end of frame watchdog is
-		 * triggered. Then, all we have to do is disabling the watchdog
-		 * for this frame, and calling videobuf_done() with success
-		 * indicated.
-		 */
-		CAM_WRITE(pcdev, MODE,
-				CAM_READ_CACHE(pcdev, MODE) & ~EN_V_DOWN);
-		videobuf_done(pcdev, VIDEOBUF_DONE);
-	} else {
-		/*
-		 * In SG mode, we have to process every sgbuf from the current
-		 * sglist, one after another.
-		 */
-		if (buf->sgbuf) {
-			/*
-			 * Current sglist not completed yet, try fetching next
-			 * sgbuf, hopefully putting it into the DMA programming
-			 * register set, making it ready for next DMA
-			 * autoreinitialization.
-			 */
-			try_next_sgbuf(pcdev->dma_ch, buf);
-			if (buf->sgbuf)
-				goto out;
-
-			/*
-			 * No more sgbufs left in the current sglist. This
-			 * doesn't mean that the whole videobuffer is already
-			 * complete, but only that the last sgbuf from the
-			 * current sglist is about to be filled. It will be
-			 * ready on next DMA interrupt, signalled with the
-			 * buf->sgbuf set back to NULL.
-			 */
-			if (buf->result != VIDEOBUF_ERROR) {
-				/*
-				 * Video frame collected without errors so far,
-				 * we can prepare for collecting a next one
-				 * as soon as DMA gets autoreinitialized
-				 * after the current (last) sgbuf is completed.
-				 */
-				buf = prepare_next_vb(pcdev);
-				if (!buf)
-					goto out;
-
-				try_next_sgbuf(pcdev->dma_ch, buf);
-				goto out;
-			}
-		}
-		/* end of videobuf */
-		videobuf_done(pcdev, buf->result);
-	}
+	/*
+	 * Assume we have just managed to collect the
+	 * whole frame, hopefully before our end of frame watchdog is
+	 * triggered. Then, all we have to do is disabling the watchdog
+	 * for this frame, and calling videobuf_done() with success
+	 * indicated.
+	 */
+	CAM_WRITE(pcdev, MODE, CAM_READ_CACHE(pcdev, MODE) & ~EN_V_DOWN);
+	videobuf_done(pcdev, VIDEOBUF_DONE);
 
 out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
@@ -811,46 +591,23 @@ static irqreturn_t cam_isr(int irq, void *data)
 		dev_warn(dev, "%s: FIFO overflow\n", __func__);
 
 	} else if (it_status & V_DOWN) {
-		/* end of video frame watchdog */
-		if (pcdev->vb_mode == OMAP1_CAM_DMA_CONTIG) {
-			/*
-			 * In CONTIG mode, the watchdog is disabled with
-			 * successful DMA end of block interrupt, and reenabled
-			 * on next frame start. If we get here, there is nothing
-			 * to check, we must be out of sync.
-			 */
-		} else {
-			if (buf->sgcount == 2) {
-				/*
-				 * If exactly 2 sgbufs from the next sglist have
-				 * been programmed into the DMA engine (the
-				 * first one already transferred into the DMA
-				 * runtime register set, the second one still
-				 * in the programming set), then we are in sync.
-				 */
-				goto out;
-			}
-		}
+		/* End of video frame watchdog
+		 * the watchdog is disabled with
+		 * successful DMA end of block interrupt, and reenabled
+		 * on next frame start. If we get here, there is nothing
+		 * to check, we must be out of sync.
+		 */
 		dev_notice(dev, "%s: unexpected end of video frame\n",
 				__func__);
 
 	} else if (it_status & V_UP) {
 		u32 mode;
 
-		if (pcdev->vb_mode == OMAP1_CAM_DMA_CONTIG) {
-			/*
-			 * In CONTIG mode, we need this interrupt every frame
-			 * in oredr to reenable our end of frame watchdog.
-			 */
-			mode = CAM_READ_CACHE(pcdev, MODE);
-		} else {
-			/*
-			 * In SG mode, the below enabled end of frame watchdog
-			 * is kept on permanently, so we can turn this one shot
-			 * setup off.
-			 */
-			mode = CAM_READ_CACHE(pcdev, MODE) & ~EN_V_UP;
-		}
+		/*
+		 * In CONTIG mode, we need this interrupt every frame
+		 * in oredr to reenable our end of frame watchdog.
+		 */
+		mode = CAM_READ_CACHE(pcdev, MODE);
 
 		if (!(mode & EN_V_DOWN)) {
 			/* (re)enable end of frame watchdog interrupt */
@@ -1125,28 +882,26 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 	return formats;
 }
 
-static bool is_dma_aligned(s32 bytes_per_line, unsigned int height,
-		enum omap1_cam_vb_mode vb_mode)
+static bool is_dma_aligned(s32 bytes_per_line, unsigned int height)
 {
 	int size = bytes_per_line * height;
 
 	return IS_ALIGNED(bytes_per_line, DMA_ELEMENT_SIZE) &&
-		IS_ALIGNED(size, DMA_FRAME_SIZE(vb_mode) * DMA_ELEMENT_SIZE);
+		IS_ALIGNED(size, DMA_FRAME_SIZE * DMA_ELEMENT_SIZE);
 }
 
 static int dma_align(int *width, int *height,
-		const struct soc_mbus_pixelfmt *fmt,
-		enum omap1_cam_vb_mode vb_mode, bool enlarge)
+		const struct soc_mbus_pixelfmt *fmt, bool enlarge)
 {
 	s32 bytes_per_line = soc_mbus_bytes_per_line(*width, fmt);
 
 	if (bytes_per_line < 0)
 		return bytes_per_line;
 
-	if (!is_dma_aligned(bytes_per_line, *height, vb_mode)) {
+	if (!is_dma_aligned(bytes_per_line, *height)) {
 		unsigned int pxalign = __fls(bytes_per_line / *width);
-		unsigned int salign  = DMA_FRAME_SHIFT(vb_mode) +
-				DMA_ELEMENT_SHIFT - pxalign;
+		unsigned int salign  = DMA_FRAME_SHIFT + DMA_ELEMENT_SHIFT
+						- pxalign;
 		unsigned int incr    = enlarge << salign;
 
 		v4l_bound_align_image(width, 1, *width + incr, 0,
@@ -1207,7 +962,7 @@ static int set_format(struct omap1_cam_dev *pcdev, struct device *dev,
 		return bytes_per_line;
 	}
 
-	if (!is_dma_aligned(bytes_per_line, mf->height, pcdev->vb_mode)) {
+	if (!is_dma_aligned(bytes_per_line, mf->height)) {
 		dev_err(dev, "%s: resulting geometry %ux%u not DMA aligned\n",
 				__func__, mf->width, mf->height);
 		return -EINVAL;
@@ -1243,8 +998,7 @@ static int omap1_cam_set_crop(struct soc_camera_device *icd,
 		return ret;
 	}
 
-	ret = dma_align(&mf->width, &mf->height, xlate->host_fmt, pcdev->vb_mode,
-			false);
+	ret = dma_align(&mf->width, &mf->height, xlate->host_fmt, false);
 	if (ret < 0) {
 		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
 				__func__, mf->width, mf->height,
@@ -1295,8 +1049,7 @@ static int omap1_cam_set_fmt(struct soc_camera_device *icd,
 	mf->colorspace	= pix->colorspace;
 	mf->code	= xlate->code;
 
-	ret = dma_align(&mf->width, &mf->height, xlate->host_fmt, pcdev->vb_mode,
-			true);
+	ret = dma_align(&mf->width, &mf->height, xlate->host_fmt, true);
 	if (ret < 0) {
 		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
 				__func__, pix->width, pix->height,
@@ -1359,59 +1112,18 @@ static int omap1_cam_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static bool sg_mode;
-
-/*
- * Local mmap_mapper wrapper,
- * used for detecting videobuf-dma-contig buffer allocation failures
- * and switching to videobuf-dma-sg automatically for future attempts.
- */
-static int omap1_cam_mmap_mapper(struct videobuf_queue *q,
-				  struct videobuf_buffer *buf,
-				  struct vm_area_struct *vma)
-{
-	struct soc_camera_device *icd = q->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct omap1_cam_dev *pcdev = ici->priv;
-	int ret;
-
-	ret = pcdev->mmap_mapper(q, buf, vma);
-
-	if (ret == -ENOMEM)
-		sg_mode = true;
-
-	return ret;
-}
-
 static void omap1_cam_init_videobuf(struct videobuf_queue *q,
 				     struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 
-	if (!sg_mode)
-		videobuf_queue_dma_contig_init(q, &omap1_videobuf_ops,
-				icd->parent, &pcdev->lock,
-				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd, &ici->host_lock);
-	else
-		videobuf_queue_sg_init(q, &omap1_videobuf_ops,
-				icd->parent, &pcdev->lock,
-				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd, &ici->host_lock);
-
-	/* use videobuf mode (auto)selected with the module parameter */
-	pcdev->vb_mode = sg_mode ? OMAP1_CAM_DMA_SG : OMAP1_CAM_DMA_CONTIG;
-
-	/*
-	 * Ensure we substitute the videobuf-dma-contig version of the
-	 * mmap_mapper() callback with our own wrapper, used for switching
-	 * automatically to videobuf-dma-sg on buffer allocation failure.
-	 */
-	if (!sg_mode && q->int_ops->mmap_mapper != omap1_cam_mmap_mapper) {
-		pcdev->mmap_mapper = q->int_ops->mmap_mapper;
-		q->int_ops->mmap_mapper = omap1_cam_mmap_mapper;
-	}
+	videobuf_queue_dma_contig_init(q, &omap1_videobuf_ops,
+				       icd->parent, &pcdev->lock,
+				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				       V4L2_FIELD_NONE,
+				       sizeof(struct omap1_cam_buf),
+				       icd, &ici->host_lock);
 }
 
 static int omap1_cam_reqbufs(struct soc_camera_device *icd,
@@ -1692,9 +1404,6 @@ static struct platform_driver omap1_cam_driver = {
 
 module_platform_driver(omap1_cam_driver);
 
-module_param(sg_mode, bool, 0644);
-MODULE_PARM_DESC(sg_mode, "videobuf mode, 0: dma-contig (default), 1: dma-sg");
-
 MODULE_DESCRIPTION("OMAP1 Camera Interface driver");
 MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/media/omap1_camera.h b/include/linux/platform_data/media/omap1_camera.h
index 819767c..f059328 100644
--- a/include/linux/platform_data/media/omap1_camera.h
+++ b/include/linux/platform_data/media/omap1_camera.h
@@ -13,15 +13,6 @@
 
 #include <linux/bitops.h>
 
-#define OMAP1_CAMERA_IOSIZE		0x1c
-
-enum omap1_cam_vb_mode {
-	OMAP1_CAM_DMA_CONTIG = 0,
-	OMAP1_CAM_DMA_SG,
-};
-
-#define OMAP1_CAMERA_MIN_BUF_COUNT(x)	((x) == OMAP1_CAM_DMA_CONTIG ? 3 : 2)
-
 struct omap1_cam_platform_data {
 	unsigned long	camexclk_khz;
 	unsigned long	lclk_khz_max;
-- 
2.7.3

