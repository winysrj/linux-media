Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:41514 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0G0MHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 08:07:10 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 4/4] mx2_camera: implement forced termination of active buffer for mx25
Date: Tue, 27 Jul 2010 15:06:10 +0300
Message-Id: <967af81dac1c4c7627b18b5eec23a258ac7d9cd2.1280229966.git.baruch@tkos.co.il>
In-Reply-To: <cover.1280229966.git.baruch@tkos.co.il>
References: <cover.1280229966.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows userspace to terminate a capture without waiting for the current
frame to complete.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/video/mx2_camera.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index d327d11..396542b 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -648,15 +648,27 @@ static void mx2_videobuf_release(struct videobuf_queue *vq,
 	 * Terminate only queued but inactive buffers. Active buffers are
 	 * released when they become inactive after videobuf_waiton().
 	 *
-	 * FIXME: implement forced termination of active buffers, so that the
-	 * user won't get stuck in an uninterruptible state. This requires a
-	 * specific handling for each of the three DMA types that this driver
-	 * supports.
+	 * FIXME: implement forced termination of active buffers for mx27 and 
+	 * mx27 eMMA, so that the user won't get stuck in an uninterruptible
+	 * state. This requires a specific handling for each of the these DMA
+	 * types.
 	 */
 	spin_lock_irqsave(&pcdev->lock, flags);
 	if (vb->state == VIDEOBUF_QUEUED) {
 		list_del(&vb->queue);
 		vb->state = VIDEOBUF_ERROR;
+	} else if (cpu_is_mx25() && vb->state == VIDEOBUF_ACTIVE) {
+		if (pcdev->fb1_active == buf) {
+			pcdev->csicr1 &= ~CSICR1_FB1_DMA_INTEN;
+			writel(0, pcdev->base_csi + CSIDMASA_FB1);
+			pcdev->fb1_active = NULL;
+		} else if (pcdev->fb2_active == buf) {
+			pcdev->csicr1 &= ~CSICR1_FB2_DMA_INTEN;
+			writel(0, pcdev->base_csi + CSIDMASA_FB2);
+			pcdev->fb2_active = NULL;
+		}
+		writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
+		vb->state = VIDEOBUF_ERROR;
 	}
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 
-- 
1.7.1

