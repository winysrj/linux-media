Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1682455182.outbound-mail.sendgrid.net ([168.245.5.182]:2196
        "EHLO o1682455182.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754570AbeALJT1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 04:19:27 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [RFT PATCH v3 4/6] uvcvideo: queue: Simplify spin-lock usage
Date: Fri, 12 Jan 2018 09:19:26 +0000 (UTC)
Message-Id: <9f83cda1d54615e068c20fcadf69a1f09ae50ec1.1515748369.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both uvc_start_streaming(), and uvc_stop_streaming() are called from
userspace context. As such, they do not need to save the IRQ state, and
can use spin_lock_irq() and spin_unlock_irq() respectively.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 4a581d631525..ddac4d89a291 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -158,7 +158,6 @@ static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
-	unsigned long flags;
 	int ret;
 
 	queue->buf_used = 0;
@@ -167,9 +166,9 @@ static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret == 0)
 		return 0;
 
-	spin_lock_irqsave(&queue->irqlock, flags);
+	spin_lock_irq(&queue->irqlock);
 	uvc_queue_return_buffers(queue, UVC_BUF_STATE_QUEUED);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
+	spin_unlock_irq(&queue->irqlock);
 
 	return ret;
 }
@@ -178,13 +177,12 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
-	unsigned long flags;
 
 	uvc_video_enable(stream, 0);
 
-	spin_lock_irqsave(&queue->irqlock, flags);
+	spin_lock_irq(&queue->irqlock);
 	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
+	spin_unlock_irq(&queue->irqlock);
 }
 
 static const struct vb2_ops uvc_queue_qops = {
-- 
git-series 0.9.1
