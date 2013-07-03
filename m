Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60665 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830Ab3GCF4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jul 2013 01:56:17 -0400
From: Libin Yang <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>,
	Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH v3 6/7] marvell-ccic: add SOF / EOF pair check for marvell-ccic driver
Date: Wed, 3 Jul 2013 13:56:03 +0800
Message-ID: <1372830964-22323-7-git-send-email-lbyang@marvell.com>
In-Reply-To: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
References: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the SOFx/EOFx pair check for marvell-ccic.

When switching format, the last EOF may not arrive when stop streamning.
And the EOF will be detected in the next start streaming.

Must ensure clear the left over frame flags before every really start streaming.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   30 ++++++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 5b838c0..f3a260c 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -95,6 +95,9 @@ MODULE_PARM_DESC(buffer_mode,
 #define CF_CONFIG_NEEDED 4	/* Must configure hardware */
 #define CF_SINGLE_BUFFER 5	/* Running with a single buffer */
 #define CF_SG_RESTART	 6	/* SG restart needed */
+#define CF_FRAME_SOF0	 7	/* Frame 0 started */
+#define CF_FRAME_SOF1	 8
+#define CF_FRAME_SOF2	 9
 
 #define sensor_call(cam, o, f, args...) \
 	v4l2_subdev_call(cam->sensor, o, f, ##args)
@@ -261,8 +264,10 @@ static void mcam_reset_buffers(struct mcam_camera *cam)
 	int i;
 
 	cam->next_buf = -1;
-	for (i = 0; i < cam->nbufs; i++)
+	for (i = 0; i < cam->nbufs; i++) {
 		clear_bit(i, &cam->flags);
+		clear_bit(CF_FRAME_SOF0 + i, &cam->flags);
+	}
 }
 
 static inline int mcam_needs_config(struct mcam_camera *cam)
@@ -1140,6 +1145,7 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
 static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	unsigned int frame;
 
 	if (cam->state != S_IDLE) {
 		INIT_LIST_HEAD(&cam->buffers);
@@ -1157,6 +1163,14 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 		cam->state = S_BUFWAIT;
 		return 0;
 	}
+
+	/*
+	 * Ensure clear the left over frame flags
+	 * before every really start streaming
+	 */
+	for (frame = 0; frame < cam->nbufs; frame++)
+		clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
+
 	return mcam_read_setup(cam);
 }
 
@@ -1845,9 +1859,11 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
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
@@ -1856,9 +1872,15 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
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

