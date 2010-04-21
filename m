Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11588 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab0DUQKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 12:10:41 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L18003JUI9PCW@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 17:10:37 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1800IRMI9PW6@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 17:10:37 +0100 (BST)
Date: Wed, 21 Apr 2010 18:10:35 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v1 2/2] v4l: vivi: adapt to out-of-order buffer dequeuing in
 videobuf.
In-reply-to: <1271866235-14370-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1271866235-14370-3-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1271866235-14370-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make vivi use new videobuf helpers for finishing processing a buffer and
checking for consumers.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/vivi.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index cdbe703..4a91761 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -630,13 +630,13 @@ static void vivi_thread_tick(struct vivi_fh *fh)
 		goto unlock;
 	}
 
-	buf = list_entry(dma_q->active.next,
-			 struct vivi_buffer, vb.queue);
-
-	/* Nobody is waiting on this buffer, return */
-	if (!waitqueue_active(&buf->vb.done))
+	if (!videobuf_has_consumers(&fh->vb_vidq)) {
+		dprintk(dev, 1, "No consumers\n");
 		goto unlock;
+	}
 
+	buf = list_entry(dma_q->active.next,
+			 struct vivi_buffer, vb.queue);
 	list_del(&buf->vb.queue);
 
 	do_gettimeofday(&buf->vb.ts);
@@ -645,11 +645,12 @@ static void vivi_thread_tick(struct vivi_fh *fh)
 	vivi_fillbuff(fh, buf);
 	dprintk(dev, 1, "filled buffer %p\n", buf);
 
-	wake_up(&buf->vb.done);
-	dprintk(dev, 2, "[%p/%d] wakeup\n", buf, buf->vb. i);
-unlock:
 	spin_unlock_irqrestore(&dev->slock, flags);
+	videobuf_buf_finish(&fh->vb_vidq, &buf->vb);
 	return;
+
+unlock:
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
 #define frames_to_ms(frames)					\
-- 
1.7.1.rc1.12.ga601

