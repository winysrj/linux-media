Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35667 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaEZNta (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 09:49:30 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] mem2mem: make queue lock in v4l2_m2m_poll interruptible
Date: Mon, 26 May 2014 15:49:22 +0200
Message-Id: <1401112162-1912-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch makes the queue lock taken in v4l2_m2m_poll interruptible.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 178ce96..97defed 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -568,8 +568,12 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	if (m2m_ctx->m2m_dev->m2m_ops->lock)
 		m2m_ctx->m2m_dev->m2m_ops->lock(m2m_ctx->priv);
-	else if (m2m_ctx->q_lock)
-		mutex_lock(m2m_ctx->q_lock);
+	else if (m2m_ctx->q_lock) {
+		if (mutex_lock_interruptible(m2m_ctx->q_lock)) {
+			rc |= POLLERR;
+			goto end;
+		}
+	}
 
 	spin_lock_irqsave(&src_q->done_lock, flags);
 	if (!list_empty(&src_q->done_list))
-- 
2.0.0.rc2

