Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751964AbeACUde (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 15:33:34 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC/RFT PATCH 4/6] uvcvideo: queue: Simplify spin-lock usage
Date: Wed,  3 Jan 2018 20:32:54 +0000
Message-Id: <2c5bcf7e4b2885071504cf61a99206aba9cb82b6.1515010476.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

Both uvc_start_streaming(), and uvc_stop_streaming() are called from
userspace context. As such, they do not need to save the IRQ state, and
can use spin_lock_irq() and spin_unlock_irq() respectively.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 0711e3d9ff76..28dbdf8bb533 100644
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
