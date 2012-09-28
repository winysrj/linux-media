Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:60740 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758063Ab2I1Nug (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 09:50:36 -0400
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>
Subject: [PATCH 4/4] [media] marvell-ccic: core: add 3 frame buffers support in DMA_CONTIG mode
Date: Fri, 28 Sep 2012 21:47:39 +0800
Message-Id: <1348840059-21456-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support of 3 frame buffers in DMA-contiguous mode.

In current DMA_CONTIG mode, only 2 frame buffers can be supported.
Actually, Marvell CCIC can support at most 3 frame buffers.

Currently 2 frame buffers mode will be used by default.
To use 3 frame buffers mode, can do:
  define MAX_FRAME_BUFS 3
in mcam-core.h

Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   87 ++++++++++++++++++--------
 drivers/media/platform/marvell-ccic/mcam-core.h |   15 ++++-
 2 files changed, 74 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 4adb1ca..a805246 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -228,7 +228,7 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
 /*
  * Hand a completed buffer back to user space.
  */
-static void mcam_buffer_done(struct mcam_camera *cam, int frame,
+static void mcam_buffer_done(struct mcam_camera *cam, unsigned int frame,
 		struct vb2_buffer *vbuf)
 {
 	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
@@ -255,7 +255,7 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
  */
 static void mcam_reset_buffers(struct mcam_camera *cam)
 {
-	int i;
+	unsigned int i;
 
 	cam->next_buf = -1;
 	for (i = 0; i < cam->nbufs; i++) {
@@ -306,7 +306,7 @@ static void mcam_ctlr_stop(struct mcam_camera *cam)
  */
 static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 {
-	int i;
+	unsigned int i;
 
 	mcam_set_config_needed(cam, 1);
 	if (loadtime)
@@ -347,7 +347,7 @@ static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 
 static void mcam_free_dma_bufs(struct mcam_camera *cam)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < cam->nbufs; i++) {
 		dma_free_coherent(cam->dev, cam->dma_buf_size,
@@ -386,7 +386,7 @@ static void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
 static void mcam_frame_tasklet(unsigned long data)
 {
 	struct mcam_camera *cam = (struct mcam_camera *) data;
-	int i;
+	unsigned int i;
 	unsigned long flags;
 	struct mcam_vb_buffer *buf;
 
@@ -434,7 +434,7 @@ static int mcam_check_dma_buffers(struct mcam_camera *cam)
 	return 0;
 }
 
-static void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
+static void mcam_vmalloc_done(struct mcam_camera *cam, unsigned int frame)
 {
 	tasklet_schedule(&cam->s_tasklet);
 }
@@ -471,20 +471,39 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
  * space.  In this way, we always have a buffer to DMA to and don't
  * have to try to play games stopping and restarting the controller.
  */
-static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
+static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
 {
 	struct mcam_vb_buffer *buf;
 	struct v4l2_pix_format *fmt = &cam->pix_format;
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(&cam->list_lock, flags);
-	/*
-	 * If there are no available buffers, go into single mode
-	 */
 	if (list_empty(&cam->buffers)) {
-		buf = cam->vb_bufs[frame ^ 0x1];
-		set_bit(CF_SINGLE_BUFFER, &cam->flags);
-		cam->frame_state.singles++;
+		/*
+		 * If there are no available buffers
+		 * go into single buffer mode
+		 *
+		 * If CCIC use Two Buffers mode
+		 * will use another remaining frame buffer
+		 * frame 0 -> buf 1
+		 * frame 1 -> buf 0
+		 *
+		 * If CCIC use Three Buffers mode
+		 * will use the 2rd remaining frame buffer
+		 * frame 0 -> buf 2
+		 * frame 1 -> buf 0
+		 * frame 2 -> buf 1
+		 */
+		buf = cam->vb_bufs[(frame + (MAX_FRAME_BUFS - 1))
+						% MAX_FRAME_BUFS];
+		if (cam->frame_state.tribufs == 0)
+			cam->frame_state.tribufs++;
+		else {
+			set_bit(CF_SINGLE_BUFFER, &cam->flags);
+			cam->frame_state.singles++;
+			if (cam->frame_state.tribufs < 2)
+				cam->frame_state.tribufs++;
+		}
 	} else {
 		/*
 		 * OK, we have a buffer we can use.
@@ -493,17 +512,16 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 					queue);
 		list_del_init(&buf->queue);
 		clear_bit(CF_SINGLE_BUFFER, &cam->flags);
+		if (cam->frame_state.tribufs != (3 - MAX_FRAME_BUFS))
+			cam->frame_state.tribufs--;
 	}
 	cam->vb_bufs[frame] = buf;
-	mcam_reg_write(cam, frame == 0 ?
-			REG_Y0BAR : REG_Y1BAR, buf->yuv_p.y);
+	mcam_reg_write(cam, REG_Y0BAR + (frame << 2), buf->yuv_p.y);
 	if (fmt->pixelformat == V4L2_PIX_FMT_YUV422P
 			|| fmt->pixelformat == V4L2_PIX_FMT_YUV420
 			|| fmt->pixelformat == V4L2_PIX_FMT_YVU420) {
-		mcam_reg_write(cam, frame == 0 ?
-				REG_U0BAR : REG_U1BAR, buf->yuv_p.u);
-		mcam_reg_write(cam, frame == 0 ?
-				REG_V0BAR : REG_V1BAR, buf->yuv_p.v);
+		mcam_reg_write(cam, REG_U0BAR + (frame << 2), buf->yuv_p.u);
+		mcam_reg_write(cam, REG_V0BAR + (frame << 2), buf->yuv_p.v);
 	}
 	spin_unlock_irqrestore(&cam->list_lock, flags);
 }
@@ -513,16 +531,20 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
  */
 static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 {
-	cam->nbufs = 2;
-	mcam_set_contig_buffer(cam, 0);
-	mcam_set_contig_buffer(cam, 1);
-	mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
+	unsigned int frame;
+
+	cam->nbufs = MAX_FRAME_BUFS;
+	for (frame = 0; frame < cam->nbufs; frame++)
+		mcam_set_contig_buffer(cam, frame);
+
+	if (cam->nbufs == 2)
+		mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
 }
 
 /*
  * Frame completion handling.
  */
-static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
+static void mcam_dma_contig_done(struct mcam_camera *cam, unsigned int frame)
 {
 	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
 	unsigned long flags = 0;
@@ -600,7 +622,7 @@ static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
  * safely change the DMA descriptor array here and restart things
  * (assuming there's another buffer waiting to go).
  */
-static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
+static void mcam_dma_sg_done(struct mcam_camera *cam, unsigned int frame)
 {
 	struct mcam_vb_buffer *buf = cam->vb_bufs[0];
 
@@ -1077,6 +1099,13 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 		cam->state = S_BUFWAIT;
 		return 0;
 	}
+
+	/*
+	 *  If CCIC use Two Buffers mode, init tribufs == 1
+	 *  If CCIC use Three Buffers mode, init tribufs == 0
+	 */
+	cam->frame_state.tribufs = 3 - MAX_FRAME_BUFS;
+
 	return mcam_read_setup(cam);
 }
 
@@ -1977,6 +2006,12 @@ static int mcam_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 	spin_unlock_irqrestore(&mcam->list_lock, flags);
 
+	/*
+	 *  If CCIC use Two Buffers mode, init tribufs == 1
+	 *  If CCIC use Three Buffers mode, init tribufs == 0
+	 */
+	mcam->frame_state.tribufs = 3 - MAX_FRAME_BUFS;
+
 	ret = mcam_read_setup(mcam);
 out_unlock:
 	mutex_unlock(&mcam->s_mutex);
@@ -2393,7 +2428,7 @@ int mcam_soc_camera_host_register(struct mcam_camera *mcam)
 /*
  * Interrupt handler stuff
  */
-static void mcam_frame_complete(struct mcam_camera *cam, int frame)
+static void mcam_frame_complete(struct mcam_camera *cam, unsigned int frame)
 {
 	/*
 	 * Basic frame housekeeping.
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index b7d8b17..f15d10d 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -48,6 +48,13 @@ enum mcam_state {
 #define MAX_DMA_BUFS 3
 
 /*
+ * CCIC can support at most 3 frame buffers in DMA_CONTIG buffer mode
+ * 2 - Use Two Buffers mode
+ * 3 - Use Three Buffers mode
+ */
+#define MAX_FRAME_BUFS 2 /* Current marvell-ccic used Two Buffers mode */
+
+/*
  * Different platforms work best with different buffer modes, so we
  * let the platform pick.
  */
@@ -106,6 +113,10 @@ struct mmp_frame_state {
 	unsigned int frames;
 	unsigned int singles;
 	unsigned int delivered;
+	/*
+	 * Only tribufs == 2 can enter single buffer mode
+	 */
+	unsigned int tribufs;
 };
 
 /*
@@ -153,7 +164,7 @@ struct mcam_camera {
 	unsigned long flags;		/* Buffer status, mainly (dev_lock) */
 	int users;			/* How many open FDs */
 
-	int frame_rate;
+	unsigned int frame_rate;
 	struct mmp_frame_state frame_state;	/* Frame state counter */
 #ifndef CONFIG_VIDEO_MRVL_SOC_CAMERA
 	/*
@@ -195,7 +206,7 @@ struct mcam_camera {
 
 	/* Mode-specific ops, set at open time */
 	void (*dma_setup)(struct mcam_camera *cam);
-	void (*frame_complete)(struct mcam_camera *cam, int frame);
+	void (*frame_complete)(struct mcam_camera *cam, unsigned int frame);
 
 	/* Current operating parameters */
 	struct v4l2_pix_format pix_format;
-- 
1.7.0.4

