Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2IKM67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 08:58:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id F205E189AF7
	for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 14:58:56 +0200 (CEST)
Date: Tue, 11 Sep 2012 14:58:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] media: use list_first_entry() instead of open-coding in
 mem2mem core
Message-ID: <Pine.LNX.4.64.1209111457440.22084@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using list_first_entry() improves code readability and makes it less
error-prone.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 97b4831..3ac8358 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -105,7 +105,7 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 		return NULL;
 	}
 
-	b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer, list);
+	b = list_first_entry(&q_ctx->rdy_queue, struct v4l2_m2m_buffer, list);
 	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
 	return &b->vb;
 }
@@ -125,7 +125,7 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
 		spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
 		return NULL;
 	}
-	b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer, list);
+	b = list_first_entry(&q_ctx->rdy_queue, struct v4l2_m2m_buffer, list);
 	list_del(&b->list);
 	q_ctx->num_rdy--;
 	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
@@ -178,7 +178,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
 		return;
 	}
 
-	m2m_dev->curr_ctx = list_entry(m2m_dev->job_queue.next,
+	m2m_dev->curr_ctx = list_first_entry(&m2m_dev->job_queue,
 				   struct v4l2_m2m_ctx, queue);
 	m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
-- 
1.7.2.5

