Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55676 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbeKGGyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 01:54:43 -0500
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v5 4/9] media: uvcvideo: queue: Simplify spin-lock usage
Date: Tue,  6 Nov 2018 21:27:15 +0000
Message-Id: <210be9b2f38af75b3747415d0372f4f12b2bee19.1541534872.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

Both uvc_start_streaming(), and uvc_stop_streaming() are called from
userspace context, with interrupts enabled. As such, they do not need to
save the IRQ state, and can use spin_lock_irq() and spin_unlock_irq()
respectively.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---

v4:
 - Rebase to v4.16 (linux-media/master)

v5:
 - Provide lockdep validation

 drivers/media/usb/uvc/uvc_queue.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 74f9483911d0..bebf2415d9de 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -169,18 +169,19 @@ static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
-	unsigned long flags;
 	int ret;
 
+	lockdep_assert_irqs_enabled();
+
 	queue->buf_used = 0;
 
 	ret = uvc_video_enable(stream, 1);
 	if (ret == 0)
 		return 0;
 
-	spin_lock_irqsave(&queue->irqlock, flags);
+	spin_lock_irq(&queue->irqlock);
 	uvc_queue_return_buffers(queue, UVC_BUF_STATE_QUEUED);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
+	spin_unlock_irq(&queue->irqlock);
 
 	return ret;
 }
@@ -188,14 +189,15 @@ static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
 static void uvc_stop_streaming(struct vb2_queue *vq)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
-	unsigned long flags;
+
+	lockdep_assert_irqs_enabled();
 
 	if (vq->type != V4L2_BUF_TYPE_META_CAPTURE)
 		uvc_video_enable(uvc_queue_to_stream(queue), 0);
 
-	spin_lock_irqsave(&queue->irqlock, flags);
+	spin_lock_irq(&queue->irqlock);
 	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
+	spin_unlock_irq(&queue->irqlock);
 }
 
 static const struct vb2_ops uvc_queue_qops = {
-- 
git-series 0.9.1
