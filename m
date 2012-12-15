Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:42296 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454Ab2LOJ74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:56 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH V3 07/15] [media] marvell-ccic: add SOF / EOF pair check for marvell-ccic driver
Date: Sat, 15 Dec 2012 17:57:56 +0800
Message-Id: <1355565484-15791-8-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
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
 drivers/media/platform/marvell-ccic/mcam-core.c |   30 ++++++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index a679917..c3c8873 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -94,6 +94,9 @@ MODULE_PARM_DESC(buffer_mode,
 #define CF_CONFIG_NEEDED 4	/* Must configure hardware */
 #define CF_SINGLE_BUFFER 5	/* Running with a single buffer */
 #define CF_SG_RESTART	 6	/* SG restart needed */
+#define CF_FRAME_SOF0	 7	/* Frame 0 started */
+#define CF_FRAME_SOF1	 8
+#define CF_FRAME_SOF2	 9
 
 #define sensor_call(cam, o, f, args...) \
 	v4l2_subdev_call(cam->sensor, o, f, ##args)
@@ -251,8 +254,10 @@ static void mcam_reset_buffers(struct mcam_camera *cam)
 	int i;
 
 	cam->next_buf = -1;
-	for (i = 0; i < cam->nbufs; i++)
+	for (i = 0; i < cam->nbufs; i++) {
 		clear_bit(i, &cam->flags);
+		clear_bit(CF_FRAME_SOF0 + i, &cam->flags);
+	}
 }
 
 static inline int mcam_needs_config(struct mcam_camera *cam)
@@ -1134,6 +1139,7 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
 static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	unsigned int frame;
 
 	if (cam->state != S_IDLE) {
 		INIT_LIST_HEAD(&cam->buffers);
@@ -1151,6 +1157,14 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
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
 
@@ -1875,9 +1889,11 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
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
@@ -1886,9 +1902,15 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 	 * code assumes that we won't get multiple frame interrupts
 	 * at once; may want to rethink that.
 	 */
-	if (irqs & (IRQ_SOF0 | IRQ_SOF1 | IRQ_SOF2)) {
+	for (frame = 0; frame < cam->nbufs; frame++) {
+		if (irqs & (IRQ_SOF0 << frame)) {
+			set_bit(CF_FRAME_SOF0 + frame, &cam->flags);
+			handled = IRQ_HANDLED;
+		}
+	}
+
+	if (handled == IRQ_HANDLED) {
 		set_bit(CF_DMA_ACTIVE, &cam->flags);
-		handled = 1;
 		if (cam->buffer_mode == B_DMA_sg)
 			mcam_ctlr_stop(cam);
 	}
-- 
1.7.9.5

