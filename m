Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44911 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753101AbeBVJwR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:52:17 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH] media: stm32-dcmi: add JPEG support
Date: Thu, 22 Feb 2018 10:51:50 +0100
Message-ID: <1519293110-20059-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DCMI JPEG support.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 195 +++++++++++++++++++++++-------
 1 file changed, 148 insertions(+), 47 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 269e963..7eaaf7c 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -93,6 +93,11 @@ enum state {
 #define MIN_HEIGHT	16U
 #define MAX_HEIGHT	2048U
 
+#define MIN_JPEG_WIDTH	16U
+#define MAX_JPEG_WIDTH	2592U
+#define MIN_JPEG_HEIGHT	16U
+#define MAX_JPEG_HEIGHT	2592U
+
 #define TIMEOUT_MS	1000
 
 struct dcmi_graph_entity {
@@ -191,14 +196,67 @@ static inline void reg_clear(void __iomem *base, u32 reg, u32 mask)
 
 static int dcmi_start_capture(struct stm32_dcmi *dcmi);
 
+static void dcmi_buffer_done(struct stm32_dcmi *dcmi,
+			     struct dcmi_buf *buf,
+			     size_t bytesused,
+			     int err)
+{
+	struct vb2_v4l2_buffer *vbuf;
+
+	if (!buf)
+		return;
+
+	vbuf = &buf->vb;
+
+	vbuf->sequence = dcmi->sequence++;
+	vbuf->field = V4L2_FIELD_NONE;
+	vbuf->vb2_buf.timestamp = ktime_get_ns();
+	vb2_set_plane_payload(&vbuf->vb2_buf, 0, bytesused);
+	vb2_buffer_done(&vbuf->vb2_buf,
+			err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	dev_dbg(dcmi->dev, "buffer[%d] done seq=%d, bytesused=%zu\n",
+		vbuf->vb2_buf.index, vbuf->sequence, bytesused);
+
+	dcmi->buffers_count++;
+	dcmi->active = NULL;
+}
+
+static int dcmi_restart_capture(struct stm32_dcmi *dcmi)
+{
+	spin_lock_irq(&dcmi->irqlock);
+
+	if (dcmi->state != RUNNING) {
+		spin_unlock_irq(&dcmi->irqlock);
+		return -EINVAL;
+	}
+
+	/* Restart a new DMA transfer with next buffer */
+	if (list_empty(&dcmi->buffers)) {
+		dev_err(dcmi->dev, "%s: No more buffer queued, cannot capture buffer\n",
+			__func__);
+		dcmi->errors_count++;
+		dcmi->active = NULL;
+
+		spin_unlock_irq(&dcmi->irqlock);
+		return -EINVAL;
+	}
+
+	dcmi->active = list_entry(dcmi->buffers.next,
+				  struct dcmi_buf, list);
+	list_del_init(&dcmi->active->list);
+
+	spin_unlock_irq(&dcmi->irqlock);
+
+	return dcmi_start_capture(dcmi);
+}
+
 static void dcmi_dma_callback(void *param)
 {
 	struct stm32_dcmi *dcmi = (struct stm32_dcmi *)param;
 	struct dma_chan *chan = dcmi->dma_chan;
 	struct dma_tx_state state;
 	enum dma_status status;
-
-	spin_lock_irq(&dcmi->irqlock);
+	struct dcmi_buf *buf = dcmi->active;
 
 	/* Check DMA status */
 	status = dmaengine_tx_status(chan, dcmi->dma_cookie, &state);
@@ -216,53 +274,18 @@ static void dcmi_dma_callback(void *param)
 	case DMA_COMPLETE:
 		dev_dbg(dcmi->dev, "%s: Received DMA_COMPLETE\n", __func__);
 
-		if (dcmi->active) {
-			struct dcmi_buf *buf = dcmi->active;
-			struct vb2_v4l2_buffer *vbuf = &dcmi->active->vb;
-
-			vbuf->sequence = dcmi->sequence++;
-			vbuf->field = V4L2_FIELD_NONE;
-			vbuf->vb2_buf.timestamp = ktime_get_ns();
-			vb2_set_plane_payload(&vbuf->vb2_buf, 0, buf->size);
-			vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
-			dev_dbg(dcmi->dev, "buffer[%d] done seq=%d\n",
-				vbuf->vb2_buf.index, vbuf->sequence);
-
-			dcmi->buffers_count++;
-			dcmi->active = NULL;
-		}
-
-		/* Restart a new DMA transfer with next buffer */
-		if (dcmi->state == RUNNING) {
-			if (list_empty(&dcmi->buffers)) {
-				dev_err(dcmi->dev, "%s: No more buffer queued, cannot capture buffer\n",
-					__func__);
-				dcmi->errors_count++;
-				dcmi->active = NULL;
-
-				spin_unlock_irq(&dcmi->irqlock);
-				return;
-			}
-
-			dcmi->active = list_entry(dcmi->buffers.next,
-						  struct dcmi_buf, list);
-
-			list_del_init(&dcmi->active->list);
-
-			spin_unlock_irq(&dcmi->irqlock);
-			if (dcmi_start_capture(dcmi))
-				dev_err(dcmi->dev, "%s: Cannot restart capture on DMA complete\n",
-					__func__);
-			return;
-		}
+		/* Return buffer to V4L2 */
+		dcmi_buffer_done(dcmi, buf, buf->size, 0);
 
+		/* Restart capture */
+		if (dcmi_restart_capture(dcmi))
+			dev_err(dcmi->dev, "%s: Cannot restart capture on DMA complete\n",
+				__func__);
 		break;
 	default:
 		dev_err(dcmi->dev, "%s: Received unknown status\n", __func__);
 		break;
 	}
-
-	spin_unlock_irq(&dcmi->irqlock);
 }
 
 static int dcmi_start_dma(struct stm32_dcmi *dcmi,
@@ -355,6 +378,52 @@ static void dcmi_set_crop(struct stm32_dcmi *dcmi)
 	reg_set(dcmi->regs, DCMI_CR, CR_CROP);
 }
 
+static void dcmi_process_jpeg(struct stm32_dcmi *dcmi)
+{
+	struct dma_tx_state state;
+	enum dma_status status;
+	struct dma_chan *chan = dcmi->dma_chan;
+	struct dcmi_buf *buf = dcmi->active;
+
+	if (!buf)
+		return;
+
+	/*
+	 * Because of variable JPEG buffer size sent by sensor,
+	 * DMA transfer never completes due to transfer size
+	 * never reached.
+	 * In order to ensure that all the JPEG data are transferred
+	 * in active buffer memory, DMA is drained.
+	 * Then DMA tx status gives the amount of data transferred
+	 * to memory, which is then returned to V4L2 through the active
+	 * buffer payload.
+	 */
+
+	/* Drain DMA */
+	dmaengine_synchronize(chan);
+
+	/* Get DMA residue to get JPEG size */
+	status = dmaengine_tx_status(chan, dcmi->dma_cookie, &state);
+	if (status != DMA_ERROR && state.residue < buf->size) {
+		/* Return JPEG buffer to V4L2 with received JPEG buffer size */
+		dcmi_buffer_done(dcmi, buf, buf->size - state.residue, 0);
+	} else {
+		dcmi->errors_count++;
+		dev_err(dcmi->dev, "%s: Cannot get JPEG size from DMA\n",
+			__func__);
+		/* Return JPEG buffer to V4L2 in ERROR state */
+		dcmi_buffer_done(dcmi, buf, 0, -EIO);
+	}
+
+	/* Abort DMA operation */
+	dmaengine_terminate_all(dcmi->dma_chan);
+
+	/* Restart capture */
+	if (dcmi_restart_capture(dcmi))
+		dev_err(dcmi->dev, "%s: Cannot restart capture on JPEG received\n",
+			__func__);
+}
+
 static irqreturn_t dcmi_irq_thread(int irq, void *arg)
 {
 	struct stm32_dcmi *dcmi = arg;
@@ -379,6 +448,14 @@ static irqreturn_t dcmi_irq_thread(int irq, void *arg)
 			dcmi->overrun_count++;
 	}
 
+	if (dcmi->sd_format->fourcc == V4L2_PIX_FMT_JPEG &&
+	    dcmi->misr & IT_FRAME) {
+		/* JPEG received */
+		spin_unlock_irq(&dcmi->irqlock);
+		dcmi_process_jpeg(dcmi);
+		return IRQ_HANDLED;
+	}
+
 	spin_unlock_irq(&dcmi->irqlock);
 	return IRQ_HANDLED;
 }
@@ -552,6 +629,10 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (dcmi->do_crop)
 		dcmi_set_crop(dcmi);
 
+	/* Enable jpeg capture */
+	if (dcmi->sd_format->fourcc == V4L2_PIX_FMT_JPEG)
+		reg_set(dcmi->regs, DCMI_CR, CR_CM);/* Snapshot mode */
+
 	/* Enable dcmi */
 	reg_set(dcmi->regs, DCMI_CR, CR_ENABLE);
 
@@ -752,6 +833,7 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_TRY,
 	};
+	bool do_crop;
 	int ret;
 
 	sd_fmt = find_format_by_fourcc(dcmi, pix->pixelformat);
@@ -761,10 +843,19 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
 	}
 
 	/* Limit to hardware capabilities */
-	pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH);
-	pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT);
+	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+		pix->width = clamp(pix->width, MIN_JPEG_WIDTH, MAX_JPEG_WIDTH);
+		pix->height =
+			clamp(pix->height, MIN_JPEG_HEIGHT, MAX_JPEG_HEIGHT);
+	} else {
+		pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH);
+		pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT);
+	}
+
+	/* No crop if JPEG is requested */
+	do_crop = dcmi->do_crop && (pix->pixelformat != V4L2_PIX_FMT_JPEG);
 
-	if (dcmi->do_crop && dcmi->num_of_sd_framesizes) {
+	if (do_crop && dcmi->num_of_sd_framesizes) {
 		struct dcmi_framesize outer_sd_fsize;
 		/*
 		 * If crop is requested and sensor have discrete frame sizes,
@@ -788,7 +879,7 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
 	sd_fsize.width = pix->width;
 	sd_fsize.height = pix->height;
 
-	if (dcmi->do_crop) {
+	if (do_crop) {
 		struct v4l2_rect c = dcmi->crop;
 		struct v4l2_rect max_rect;
 
@@ -843,6 +934,10 @@ static int dcmi_set_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f)
 	if (ret)
 		return ret;
 
+	/* Disable crop if JPEG is requested */
+	if (pix->pixelformat == V4L2_PIX_FMT_JPEG)
+		dcmi->do_crop = false;
+
 	/* pix to mbus format */
 	v4l2_fill_mbus_format(mf, pix,
 			      sd_format->mbus_code);
@@ -895,6 +990,8 @@ static int dcmi_enum_fmt_vid_cap(struct file *file, void  *priv,
 		return -EINVAL;
 
 	f->pixelformat = dcmi->sd_formats[f->index]->fourcc;
+	if (f->pixelformat == V4L2_PIX_FMT_JPEG)
+		f->flags |= V4L2_FMT_FLAG_COMPRESSED;
 	return 0;
 }
 
@@ -1315,6 +1412,10 @@ static int dcmi_set_default_fmt(struct stm32_dcmi *dcmi)
 		.fourcc = V4L2_PIX_FMT_UYVY,
 		.mbus_code = MEDIA_BUS_FMT_UYVY8_2X8,
 		.bpp = 2,
+	}, {
+		.fourcc = V4L2_PIX_FMT_JPEG,
+		.mbus_code = MEDIA_BUS_FMT_JPEG_1X8,
+		.bpp = 1,
 	},
 };
 
-- 
1.9.1
