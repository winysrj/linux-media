Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52433 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaDCWiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 25/25] omap3isp: Rename isp_buffer isp_addr field to dma
Date: Fri,  4 Apr 2014 00:39:55 +0200
Message-Id: <1396564795-27192-26-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c    | 4 ++--
 drivers/media/platform/omap3isp/ispccp2.c    | 4 ++--
 drivers/media/platform/omap3isp/ispcsi2.c    | 4 ++--
 drivers/media/platform/omap3isp/isppreview.c | 8 ++++----
 drivers/media/platform/omap3isp/ispresizer.c | 8 ++++----
 drivers/media/platform/omap3isp/ispvideo.c   | 2 +-
 drivers/media/platform/omap3isp/ispvideo.h   | 4 ++--
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 004a4f5..9f727d2 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1521,7 +1521,7 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 
 	buffer = omap3isp_video_buffer_next(&ccdc->video_out);
 	if (buffer != NULL) {
-		ccdc_set_outaddr(ccdc, buffer->isp_addr);
+		ccdc_set_outaddr(ccdc, buffer->dma);
 		restart = 1;
 	}
 
@@ -1660,7 +1660,7 @@ static int ccdc_video_queue(struct isp_video *video, struct isp_buffer *buffer)
 	if (!(ccdc->output & CCDC_OUTPUT_MEMORY))
 		return -ENODEV;
 
-	ccdc_set_outaddr(ccdc, buffer->isp_addr);
+	ccdc_set_outaddr(ccdc, buffer->dma);
 
 	/* We now have a buffer queued on the output, restart the pipeline
 	 * on the next CCDC interrupt if running in continuous mode (or when
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index b30b67d..f3801db 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -549,7 +549,7 @@ static void ccp2_isr_buffer(struct isp_ccp2_device *ccp2)
 
 	buffer = omap3isp_video_buffer_next(&ccp2->video_in);
 	if (buffer != NULL)
-		ccp2_set_inaddr(ccp2, buffer->isp_addr);
+		ccp2_set_inaddr(ccp2, buffer->dma);
 
 	pipe->state |= ISP_PIPELINE_IDLE_INPUT;
 
@@ -940,7 +940,7 @@ static int ccp2_video_queue(struct isp_video *video, struct isp_buffer *buffer)
 {
 	struct isp_ccp2_device *ccp2 = &video->isp->isp_ccp2;
 
-	ccp2_set_inaddr(ccp2, buffer->isp_addr);
+	ccp2_set_inaddr(ccp2, buffer->dma);
 	return 0;
 }
 
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 6205608..5a2e47e 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -695,7 +695,7 @@ static void csi2_isr_buffer(struct isp_csi2_device *csi2)
 	if (buffer == NULL)
 		return;
 
-	csi2_set_outaddr(csi2, buffer->isp_addr);
+	csi2_set_outaddr(csi2, buffer->dma);
 	csi2_ctx_enable(isp, csi2, 0, 1);
 }
 
@@ -812,7 +812,7 @@ static int csi2_queue(struct isp_video *video, struct isp_buffer *buffer)
 	struct isp_device *isp = video->isp;
 	struct isp_csi2_device *csi2 = &isp->isp_csi2a;
 
-	csi2_set_outaddr(csi2, buffer->isp_addr);
+	csi2_set_outaddr(csi2, buffer->dma);
 
 	/*
 	 * If streaming was enabled before there was a buffer queued
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 395b2b0..720809b 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -1499,14 +1499,14 @@ static void preview_isr_buffer(struct isp_prev_device *prev)
 	if (prev->input == PREVIEW_INPUT_MEMORY) {
 		buffer = omap3isp_video_buffer_next(&prev->video_in);
 		if (buffer != NULL)
-			preview_set_inaddr(prev, buffer->isp_addr);
+			preview_set_inaddr(prev, buffer->dma);
 		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
 	}
 
 	if (prev->output & PREVIEW_OUTPUT_MEMORY) {
 		buffer = omap3isp_video_buffer_next(&prev->video_out);
 		if (buffer != NULL) {
-			preview_set_outaddr(prev, buffer->isp_addr);
+			preview_set_outaddr(prev, buffer->dma);
 			restart = 1;
 		}
 		pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
@@ -1577,10 +1577,10 @@ static int preview_video_queue(struct isp_video *video,
 	struct isp_prev_device *prev = &video->isp->isp_prev;
 
 	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		preview_set_inaddr(prev, buffer->isp_addr);
+		preview_set_inaddr(prev, buffer->dma);
 
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		preview_set_outaddr(prev, buffer->isp_addr);
+		preview_set_outaddr(prev, buffer->dma);
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 86369df..6f077c2 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1040,7 +1040,7 @@ static void resizer_isr_buffer(struct isp_res_device *res)
 	 */
 	buffer = omap3isp_video_buffer_next(&res->video_out);
 	if (buffer != NULL) {
-		resizer_set_outaddr(res, buffer->isp_addr);
+		resizer_set_outaddr(res, buffer->dma);
 		restart = 1;
 	}
 
@@ -1049,7 +1049,7 @@ static void resizer_isr_buffer(struct isp_res_device *res)
 	if (res->input == RESIZER_INPUT_MEMORY) {
 		buffer = omap3isp_video_buffer_next(&res->video_in);
 		if (buffer != NULL)
-			resizer_set_inaddr(res, buffer->isp_addr);
+			resizer_set_inaddr(res, buffer->dma);
 		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
 	}
 
@@ -1101,7 +1101,7 @@ static int resizer_video_queue(struct isp_video *video,
 	struct isp_res_device *res = &video->isp->isp_res;
 
 	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		resizer_set_inaddr(res, buffer->isp_addr);
+		resizer_set_inaddr(res, buffer->dma);
 
 	/*
 	 * We now have a buffer queued on the output. Despite what the
@@ -1116,7 +1116,7 @@ static int resizer_video_queue(struct isp_video *video,
 	 * continuous mode or when starting the stream.
 	 */
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		resizer_set_outaddr(res, buffer->isp_addr);
+		resizer_set_outaddr(res, buffer->dma);
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index be07f96..d9d8432 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -374,7 +374,7 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
 	}
 
 	vb2_set_plane_payload(&buffer->vb, 0, vfh->format.fmt.pix.sizeimage);
-	buffer->isp_addr = addr;
+	buffer->dma = addr;
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 1015505..7d2e821 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -127,12 +127,12 @@ static inline int isp_pipeline_ready(struct isp_pipeline *pipe)
  * struct isp_buffer - ISP video buffer
  * @vb: videobuf2 buffer
  * @irqlist: List head for insertion into IRQ queue
- * @isp_addr: DMA address
+ * @dma: DMA address
  */
 struct isp_buffer {
 	struct vb2_buffer vb;
 	struct list_head irqlist;
-	dma_addr_t isp_addr;
+	dma_addr_t dma;
 };
 
 #define to_isp_buffer(buf)	container_of(buf, struct isp_buffer, vb)
-- 
1.8.3.2

