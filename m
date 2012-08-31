Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52697 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab2HaNSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:08 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <p.osciak@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/2] media v4l2-mem2mem: Use list_first_entry
Date: Fri, 31 Aug 2012 15:18:03 +0200
Message-Id: <1346419084-10879-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1346419084-10879-1-git-send-email-s.hauer@pengutronix.de>
References: <1346419084-10879-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use list_first_entry instead of list_entry which makes the intention
of the code more clear.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/video/v4l2-mem2mem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
-- 
1.7.10.4

