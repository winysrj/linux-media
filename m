Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34174 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0ASP3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 10:29:05 -0500
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KWI0030Q30DCQ@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2010 15:29:01 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KWI00DW730D0U@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2010 15:29:01 +0000 (GMT)
Date: Tue, 19 Jan 2010 16:28:49 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v1 1/1] V4L: Add sync before a hardware operation to videobuf.
In-reply-to: <1263914929-28211-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1263914929-28211-2-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1263914929-28211-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Architectures with non-coherent CPU cache (e.g. ARM) may require a cache
flush or invalidation before starting a hardware operation if the data in
a video buffer being queued has been touched by the CPU.

This patch adds calls to sync before a hardware operation that are expected
to be interpreted and handled by each memory type-specific module.

Whether it is a sync before or after the operation can be determined from
the current buffer state: VIDEOBUF_DONE and VIDEOBUF_ERROR indicate a sync
called after an operation.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf-core.c   |    9 +++++++++
 drivers/media/video/videobuf-dma-sg.c |    6 ++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index bb0a1c8..e56c67a 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -561,6 +561,8 @@ int videobuf_qbuf(struct videobuf_queue *q,
 		goto done;
 	}
 
+	CALL(q, sync, q, buf);
+
 	list_add_tail(&buf->stream, &q->stream);
 	if (q->streaming) {
 		spin_lock_irqsave(q->irqlock, flags);
@@ -761,6 +763,8 @@ static ssize_t videobuf_read_zerocopy(struct videobuf_queue *q,
 	if (0 != retval)
 		goto done;
 
+	CALL(q, sync, q, q->read_buf);
+
 	/* start capture & wait */
 	spin_lock_irqsave(q->irqlock, flags);
 	q->ops->buf_queue(q, q->read_buf);
@@ -826,6 +830,8 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 			goto done;
 		}
 
+		CALL(q, sync, q, q->read_buf);
+
 		spin_lock_irqsave(q->irqlock, flags);
 		q->ops->buf_queue(q, q->read_buf);
 		spin_unlock_irqrestore(q->irqlock, flags);
@@ -893,6 +899,9 @@ static int __videobuf_read_start(struct videobuf_queue *q)
 		err = q->ops->buf_prepare(q, q->bufs[i], field);
 		if (err)
 			return err;
+
+		CALL(q, sync, q, q->read_buf);
+
 		list_add_tail(&q->bufs[i]->stream, &q->stream);
 	}
 	spin_lock_irqsave(q->irqlock, flags);
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index fa78555..2b153f8 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -50,6 +50,9 @@ MODULE_LICENSE("GPL");
 #define dprintk(level, fmt, arg...)	if (debug >= level) \
 	printk(KERN_DEBUG "vbuf-sg: " fmt , ## arg)
 
+#define is_sync_after(vb) \
+	(vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
+
 /* --------------------------------------------------------------------- */
 
 struct scatterlist*
@@ -516,6 +519,9 @@ static int __videobuf_sync(struct videobuf_queue *q,
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
 
+	if (!is_sync_after(buf))
+		return 0;
+
 	return	videobuf_dma_sync(q,&mem->dma);
 }
 
-- 
1.6.4.2.253.g0b1fac

