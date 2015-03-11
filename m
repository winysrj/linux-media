Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51531 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbbCKP6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 11:58:04 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] v4l2-mem2mem: no need to initialize b in v4l2_m2m_next_buf and v4l2_m2m_buf_remove
Date: Wed, 11 Mar 2015 16:57:50 +0100
Message-Id: <1426089470-27923-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first time b is used, it is assigned to the first element of the rdy_queue
list. There is no need to set it to NULL before.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 80c588f..73824a5 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -97,7 +97,7 @@ EXPORT_SYMBOL(v4l2_m2m_get_vq);
  */
 void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 {
-	struct v4l2_m2m_buffer *b = NULL;
+	struct v4l2_m2m_buffer *b;
 	unsigned long flags;
 
 	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
@@ -119,7 +119,7 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_next_buf);
  */
 void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
 {
-	struct v4l2_m2m_buffer *b = NULL;
+	struct v4l2_m2m_buffer *b;
 	unsigned long flags;
 
 	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
-- 
2.1.4

