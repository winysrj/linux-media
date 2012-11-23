Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:45008 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752950Ab2KWNe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:34:29 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH 07/15] [media] marvell-ccic: add SOF / EOF pair check for marvell-ccic driver
Date: Fri, 23 Nov 2012 21:33:48 +0800
Message-Id: <1353677628-24179-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch adds the SOFx/EOFx pair check for marvell-ccic.

When switching format, the last EOF may not arrive when stop streamning.
And the EOF will be detected in the next start streaming.

Must ensure clear the obsolete frame flags before every really start streaming.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   33 ++++++++++++++++++-----
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index c9f7250..16da8ae 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -93,6 +93,9 @@ MODULE_PARM_DESC(buffer_mode,
 #define CF_CONFIG_NEEDED 4	/* Must configure hardware */
 #define CF_SINGLE_BUFFER 5	/* Running with a single buffer */
 #define CF_SG_RESTART	 6	/* SG restart needed */
+#define CF_FRAME_SOF0	 7	/* Frame 0 started */
+#define CF_FRAME_SOF1	 8
+#define CF_FRAME_SOF2	 9
 
 #define sensor_call(cam, o, f, args...) \
 	v4l2_subdev_call(cam->sensor, o, f, ##args)
@@ -250,8 +253,10 @@ static void mcam_reset_buffers(struct mcam_camera *cam)
 	int i;
 
 	cam->next_buf = -1;
-	for (i = 0; i < cam->nbufs; i++)
+	for (i = 0; i < cam->nbufs; i++) {
 		clear_bit(i, &cam->flags);
+		clear_bit(CF_FRAME_SOF0 + i, &cam->flags);
+	}
 }
 
 static inline int mcam_needs_config(struct mcam_camera *cam)
@@ -1130,6 +1135,7 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
 static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	unsigned int frame;
 
 	if (cam->state != S_IDLE) {
 		INIT_LIST_HEAD(&cam->buffers);
@@ -1147,6 +1153,14 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 		cam->state = S_BUFWAIT;
 		return 0;
 	}
+
+	/*
+	 * Ensure clear the obsolete frame flags
+	 * before every really start streaming
+	 */
+	for (frame = 0; frame < cam->nbufs; frame++)
+		clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
+
 	return mcam_read_setup(cam);
 }
 
@@ -1865,9 +1879,11 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 	 * each time.
 	 */
 	for (frame = 0; frame < cam->nbufs; frame++)
-		if (irqs & (IRQ_EOF0 << frame)) {
+		if (irqs & (IRQ_EOF0 << frame) &&
+			test_bit(CF_FRAME_SOF0 + frame, &cam->flags)) {
 			mcam_frame_complete(cam, frame);
 			handled = 1;
+			clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
 			if (cam->buffer_mode == B_DMA_sg)
 				break;
 		}
@@ -1876,11 +1892,14 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 	 * code assumes that we won't get multiple frame interrupts
 	 * at once; may want to rethink that.
 	 */
-	if (irqs & (IRQ_SOF0 | IRQ_SOF1 | IRQ_SOF2)) {
-		set_bit(CF_DMA_ACTIVE, &cam->flags);
-		handled = 1;
-		if (cam->buffer_mode == B_DMA_sg)
-			mcam_ctlr_stop(cam);
+	for (frame = 0; frame < cam->nbufs; frame++) {
+		if (irqs & (IRQ_SOF0 << frame)) {
+			set_bit(CF_DMA_ACTIVE, &cam->flags);
+			set_bit(CF_FRAME_SOF0 + frame, &cam->flags);
+			handled = IRQ_HANDLED;
+			if (cam->buffer_mode == B_DMA_sg)
+				mcam_ctlr_stop(cam);
+		}
 	}
 	return handled;
 }
-- 
1.7.9.5

