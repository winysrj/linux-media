Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:46009 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab2LOKAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 05:00:07 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH V3 15/15] [media] marvell-ccic: add 3 frame buffers support in DMA_CONTIG mode
Date: Sat, 15 Dec 2012 17:58:04 +0800
Message-Id: <1355565484-15791-16-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
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
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   59 +++++++++++++++++------
 drivers/media/platform/marvell-ccic/mcam-core.h |   11 +++++
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 2a4d481..d7f124d 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -400,13 +400,32 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
 	struct mcam_vb_buffer *buf;
 	struct v4l2_pix_format *fmt = &cam->pix_format;
 
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
+		if (cam->frame_state.usebufs == 0)
+			cam->frame_state.usebufs++;
+		else {
+			set_bit(CF_SINGLE_BUFFER, &cam->flags);
+			cam->frame_state.singles++;
+			if (cam->frame_state.usebufs < 2)
+				cam->frame_state.usebufs++;
+		}
 	} else {
 		/*
 		 * OK, we have a buffer we can use.
@@ -415,15 +434,15 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
 					queue);
 		list_del_init(&buf->queue);
 		clear_bit(CF_SINGLE_BUFFER, &cam->flags);
+		if (cam->frame_state.usebufs != (3 - MAX_FRAME_BUFS))
+			cam->frame_state.usebufs--;
 	}
 
 	cam->vb_bufs[frame] = buf;
-	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR, buf->yuv_p.y);
+	mcam_reg_write(cam, REG_Y0BAR + (frame << 2), buf->yuv_p.y);
 	if (mcam_fmt_is_planar(fmt->pixelformat)) {
-		mcam_reg_write(cam, frame == 0 ?
-					REG_U0BAR : REG_U1BAR, buf->yuv_p.u);
-		mcam_reg_write(cam, frame == 0 ?
-					REG_V0BAR : REG_V1BAR, buf->yuv_p.v);
+		mcam_reg_write(cam, REG_U0BAR + (frame << 2), buf->yuv_p.u);
+		mcam_reg_write(cam, REG_V0BAR + (frame << 2), buf->yuv_p.v);
 	}
 }
 
@@ -432,10 +451,14 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
  */
 void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 {
-	mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
-	cam->nbufs = 2;
-	mcam_set_contig_buffer(cam, 0);
-	mcam_set_contig_buffer(cam, 1);
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
@@ -978,6 +1001,12 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 	for (frame = 0; frame < cam->nbufs; frame++)
 		clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
 
+	/*
+	 *  If CCIC use Two Buffers mode, init usebufs == 1
+	 *  If CCIC use Three Buffers mode, init usebufs == 0
+	 */
+	cam->frame_state.usebufs = 3 - MAX_FRAME_BUFS;
+
 	return mcam_read_setup(cam);
 }
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 765d47c..9bf31c8 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -62,6 +62,13 @@ enum mcam_state {
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
@@ -99,6 +106,10 @@ struct mcam_frame_state {
 	unsigned int frames;
 	unsigned int singles;
 	unsigned int delivered;
+	/*
+	 * Only usebufs == 2 can enter single buffer mode
+	 */
+	unsigned int usebufs;
 };
 
 /*
-- 
1.7.9.5

