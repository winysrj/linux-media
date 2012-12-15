Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:60396 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183Ab2LOKAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 05:00:07 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH V3 14/15] [media] marvell-ccic: use unsigned int type replace int type
Date: Sat, 15 Dec 2012 17:58:03 +0800
Message-Id: <1355565484-15791-15-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch use unsigned int type replace int type in marvell-ccic.

These variables: frame number, buf number, irq... should be unsigned.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 .../media/platform/marvell-ccic/mcam-core-soc.h    |    2 +-
 .../platform/marvell-ccic/mcam-core-standard.h     |   10 ++++-----
 drivers/media/platform/marvell-ccic/mcam-core.c    |   22 ++++++++++----------
 drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |    2 +-
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core-soc.h b/drivers/media/platform/marvell-ccic/mcam-core-soc.h
index fbdaa5d..cb1504a 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core-soc.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core-soc.h
@@ -11,7 +11,7 @@ extern const struct vb2_ops mcam_vb2_ops;
 
 void mcam_ctlr_power_up(struct mcam_camera *cam);
 void mcam_ctlr_power_down(struct mcam_camera *cam);
-void mcam_dma_contig_done(struct mcam_camera *cam, int frame);
+void mcam_dma_contig_done(struct mcam_camera *cam, unsigned int frame);
 void mcam_ctlr_stop(struct mcam_camera *cam);
 int mcam_config_mipi(struct mcam_camera *mcam, int enable);
 void mcam_ctlr_image(struct mcam_camera *cam);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core-standard.h b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
index 154ea4f..363ae43 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core-standard.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
@@ -4,8 +4,8 @@
  * Copyright 2011 Jonathan Corbet corbet@lwn.net
  */
 extern bool mcam_alloc_bufs_at_read;
-extern int mcam_n_dma_bufs;
-extern int mcam_buffer_mode;
+extern unsigned int mcam_n_dma_bufs;
+extern unsigned int mcam_buffer_mode;
 extern const struct vb2_ops mcam_vb2_sg_ops;
 extern const struct vb2_ops mcam_vb2_ops;
 
@@ -15,12 +15,12 @@ void mcam_ctlr_power_up(struct mcam_camera *cam);
 void mcam_ctlr_power_down(struct mcam_camera *cam);
 void mcam_free_dma_bufs(struct mcam_camera *cam);
 void mcam_ctlr_dma_sg(struct mcam_camera *cam);
-void mcam_dma_sg_done(struct mcam_camera *cam, int frame);
+void mcam_dma_sg_done(struct mcam_camera *cam, unsigned int frame);
 int mcam_check_dma_buffers(struct mcam_camera *cam);
 void mcam_set_config_needed(struct mcam_camera *cam, int needed);
 int __mcam_cam_reset(struct mcam_camera *cam);
 int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime);
 void mcam_ctlr_dma_contig(struct mcam_camera *cam);
-void mcam_dma_contig_done(struct mcam_camera *cam, int frame);
+void mcam_dma_contig_done(struct mcam_camera *cam, unsigned int frame);
 void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam);
-void mcam_vmalloc_done(struct mcam_camera *cam, int frame);
+void mcam_vmalloc_done(struct mcam_camera *cam, unsigned int frame);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 97b40db..2a4d481 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -106,7 +106,7 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
 /*
  * Hand a completed buffer back to user space.
  */
-static void mcam_buffer_done(struct mcam_camera *cam, int frame,
+static void mcam_buffer_done(struct mcam_camera *cam, unsigned int frame,
 		struct vb2_buffer *vbuf)
 {
 	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
@@ -120,7 +120,7 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
  */
 static void mcam_reset_buffers(struct mcam_camera *cam)
 {
-	int i;
+	unsigned int i;
 
 	cam->next_buf = -1;
 	for (i = 0; i < cam->nbufs; i++) {
@@ -215,7 +215,7 @@ int mcam_config_mipi(struct mcam_camera *mcam, int enable)
  */
 int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 {
-	int i;
+	unsigned int i;
 
 	mcam_set_config_needed(cam, 1);
 	if (loadtime)
@@ -256,7 +256,7 @@ int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 
 void mcam_free_dma_bufs(struct mcam_camera *cam)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < cam->nbufs; i++) {
 		dma_free_coherent(cam->dev, cam->dma_buf_size,
@@ -295,7 +295,7 @@ void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
 static void mcam_frame_tasklet(unsigned long data)
 {
 	struct mcam_camera *cam = (struct mcam_camera *) data;
-	int i;
+	unsigned int i;
 	unsigned long flags;
 	struct mcam_vb_buffer *buf;
 
@@ -343,7 +343,7 @@ int mcam_check_dma_buffers(struct mcam_camera *cam)
 	return 0;
 }
 
-void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
+void mcam_vmalloc_done(struct mcam_camera *cam, unsigned int frame)
 {
 	tasklet_schedule(&cam->s_tasklet);
 }
@@ -395,7 +395,7 @@ static bool mcam_fmt_is_planar(__u32 pfmt)
  * space.  In this way, we always have a buffer to DMA to and don't
  * have to try to play games stopping and restarting the controller.
  */
-static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
+static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
 {
 	struct mcam_vb_buffer *buf;
 	struct v4l2_pix_format *fmt = &cam->pix_format;
@@ -441,7 +441,7 @@ void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 /*
  * Frame completion handling.
  */
-void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
+void mcam_dma_contig_done(struct mcam_camera *cam, unsigned int frame)
 {
 	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
 
@@ -517,7 +517,7 @@ void mcam_ctlr_dma_sg(struct mcam_camera *cam)
  * safely change the DMA descriptor array here and restart things
  * (assuming there's another buffer waiting to go).
  */
-void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
+void mcam_dma_sg_done(struct mcam_camera *cam, unsigned int frame)
 {
 	struct mcam_vb_buffer *buf = cam->vb_bufs[0];
 
@@ -865,7 +865,7 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 		void *alloc_ctxs[])
 {
 	struct mcam_camera *cam = get_mcam(vq);
-	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
+	unsigned int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
 
 	sizes[0] = cam->pix_format.sizeimage;
 	*num_planes = 1; /* Someday we have to support planar formats... */
@@ -1103,7 +1103,7 @@ const struct vb2_ops mcam_vb2_sg_ops = {
 /*
  * Interrupt handler stuff
  */
-static void mcam_frame_complete(struct mcam_camera *cam, int frame)
+static void mcam_frame_complete(struct mcam_camera *cam, unsigned int frame)
 {
 	/*
 	 * Basic frame housekeeping.
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index e1025f2..765d47c 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -192,7 +192,7 @@ struct mcam_camera {
 
 	/* Mode-specific ops, set at open time */
 	void (*dma_setup)(struct mcam_camera *cam);
-	void (*frame_complete)(struct mcam_camera *cam, int frame);
+	void (*frame_complete)(struct mcam_camera *cam, unsigned int frame);
 
 	/* Current operating parameters */
 	u32 sensor_type;		/* Currently ov7670 only */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 3469f02..8a87e3e 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -46,7 +46,7 @@ struct mmp_camera {
 	struct list_head devlist;
 	/* will change here */
 	struct clk *clk[3];	/* CCIC_GATE, CCIC_RST, CCIC_DBG clocks */
-	int irq;
+	unsigned int irq;
 };
 
 static inline struct mmp_camera *mcam_to_cam(struct mcam_camera *mcam)
-- 
1.7.9.5

