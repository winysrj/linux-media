Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54659 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810Ab2D0IN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 04:13:56 -0400
Date: Fri, 27 Apr 2012 10:13:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH] V4L: mem2mem: use available list manipulation API
Message-ID: <Pine.LNX.4.64.1204271008560.31986@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use an available standard list_first_entry() function instead of 
open-coding.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/v4l2-mem2mem.c b/drivers/media/video/v4l2-mem2mem.c
index 975d0fa..aaa67d3 100644
--- a/drivers/media/video/v4l2-mem2mem.c
+++ b/drivers/media/video/v4l2-mem2mem.c
@@ -102,7 +102,7 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 		return NULL;
 	}
 
-	b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer, list);
+	b = list_first_entry(&q_ctx->rdy_queue, struct v4l2_m2m_buffer, list);
 	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
 	return &b->vb;
 }
@@ -122,7 +122,7 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
 		spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
 		return NULL;
 	}
-	b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer, list);
+	b = list_first_entry(&q_ctx->rdy_queue, struct v4l2_m2m_buffer, list);
 	list_del(&b->list);
 	q_ctx->num_rdy--;
 	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
@@ -175,7 +175,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
 		return;
 	}
 
-	m2m_dev->curr_ctx = list_entry(m2m_dev->job_queue.next,
+	m2m_dev->curr_ctx = list_first_entry(&m2m_dev->job_queue,
 				   struct v4l2_m2m_ctx, queue);
 	m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
