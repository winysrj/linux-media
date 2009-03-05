Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:43946 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbZCETqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 14:46:08 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, mike@compulab.co.il
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 4/4] pxa_camera: Fix overrun condition on last buffer
Date: Thu,  5 Mar 2009 20:45:51 +0100
Message-Id: <1236282351-28471-5-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1236282351-28471-4-git-send-email-robert.jarzmik@free.fr>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-4-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The last buffer queued will often overrun, as the DMA chain
is finished, and the time the dma irq handler is activated,
the QIF fifos are filled by the sensor.

The fix is to ignore the overrun condition on the last
queued buffer, and restart the capture only on intermediate
buffers of the chain.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 16bf0a3..dd56c35 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -734,14 +734,18 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
 
 	if (status & DCSR_ENDINTR) {
-		if (camera_status & overrun) {
+		/*
+		 * It's normal if the last frame creates an overrun, as there
+		 * are no more DMA descriptors to fetch from QIF fifos
+		 */
+		if (camera_status & overrun
+		    && !list_is_last(pcdev->capture.next, &pcdev->capture)) {
 			dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n",
 				camera_status);
 			pxa_camera_stop_capture(pcdev);
 			pxa_camera_start_capture(pcdev);
 			goto out;
 		}
-
 		buf->active_dma &= ~act_dma;
 		if (!buf->active_dma)
 			pxa_camera_wakeup(pcdev, vb, buf);
-- 
1.5.6.5

