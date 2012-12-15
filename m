Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:36370 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061Ab2LOJ7t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:49 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH V3 01/15] [media] marvell-ccic: use internal variable replace global frame stats variable
Date: Sat, 15 Dec 2012 17:57:50 +0800
Message-Id: <1355565484-15791-2-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch replaces the global frame stats variables by using
internal variables in mcam_camera structure.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   30 ++++++++++-------------
 drivers/media/platform/marvell-ccic/mcam-core.h |    9 +++++++
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index ce2b7b4..7012913f 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -30,13 +30,6 @@
 
 #include "mcam-core.h"
 
-/*
- * Basic frame stats - to be deleted shortly
- */
-static int frames;
-static int singles;
-static int delivered;
-
 #ifdef MCAM_MODE_VMALLOC
 /*
  * Internal DMA buffer management.  Since the controller cannot do S/G I/O,
@@ -367,10 +360,10 @@ static void mcam_frame_tasklet(unsigned long data)
 		if (!test_bit(bufno, &cam->flags))
 			continue;
 		if (list_empty(&cam->buffers)) {
-			singles++;
+			cam->frame_state.singles++;
 			break;  /* Leave it valid, hope for better later */
 		}
-		delivered++;
+		cam->frame_state.delivered++;
 		clear_bit(bufno, &cam->flags);
 		buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer,
 				queue);
@@ -452,7 +445,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 		mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
 				vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
 		set_bit(CF_SINGLE_BUFFER, &cam->flags);
-		singles++;
+		cam->frame_state.singles++;
 		return;
 	}
 	/*
@@ -485,7 +478,7 @@ static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
 	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
 
 	if (!test_bit(CF_SINGLE_BUFFER, &cam->flags)) {
-		delivered++;
+		cam->frame_state.delivered++;
 		mcam_buffer_done(cam, frame, &buf->vb_buf);
 	}
 	mcam_set_contig_buffer(cam, frame);
@@ -578,13 +571,13 @@ static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
 	 */
 	} else {
 		set_bit(CF_SG_RESTART, &cam->flags);
-		singles++;
+		cam->frame_state.singles++;
 		cam->vb_bufs[0] = NULL;
 	}
 	/*
 	 * Now we can give the completed frame back to user space.
 	 */
-	delivered++;
+	cam->frame_state.delivered++;
 	mcam_buffer_done(cam, frame, &buf->vb_buf);
 }
 
@@ -1545,7 +1538,9 @@ static int mcam_v4l_open(struct file *filp)
 
 	filp->private_data = cam;
 
-	frames = singles = delivered = 0;
+	cam->frame_state.frames = 0;
+	cam->frame_state.singles = 0;
+	cam->frame_state.delivered = 0;
 	mutex_lock(&cam->s_mutex);
 	if (cam->users == 0) {
 		ret = mcam_setup_vb2(cam);
@@ -1566,8 +1561,9 @@ static int mcam_v4l_release(struct file *filp)
 {
 	struct mcam_camera *cam = filp->private_data;
 
-	cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n", frames,
-			singles, delivered);
+	cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n",
+			cam->frame_state.frames, cam->frame_state.singles,
+			cam->frame_state.delivered);
 	mutex_lock(&cam->s_mutex);
 	(cam->users)--;
 	if (cam->users == 0) {
@@ -1660,7 +1656,7 @@ static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 	clear_bit(CF_DMA_ACTIVE, &cam->flags);
 	cam->next_buf = frame;
 	cam->buf_seq[frame] = ++(cam->sequence);
-	frames++;
+	cam->frame_state.frames++;
 	/*
 	 * "This should never happen"
 	 */
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index bd6acba..5e802c6 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -73,6 +73,14 @@ static inline int mcam_buffer_mode_supported(enum mcam_buffer_mode mode)
 	}
 }
 
+/*
+ * Basic frame states
+ */
+struct mcam_frame_state {
+	unsigned int frames;
+	unsigned int singles;
+	unsigned int delivered;
+};
 
 /*
  * A description of one of our devices.
@@ -108,6 +116,7 @@ struct mcam_camera {
 	unsigned long flags;		/* Buffer status, mainly (dev_lock) */
 	int users;			/* How many open FDs */
 
+	struct mcam_frame_state frame_state;	/* Frame state counter */
 	/*
 	 * Subsystem structures.
 	 */
-- 
1.7.9.5

