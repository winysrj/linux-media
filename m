Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45328 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755464AbbDYPn3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/12] dt3155v4l: remove unused statistics
Date: Sat, 25 Apr 2015 17:42:41 +0200
Message-Id: <1429976571-34872-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove struct dt3155_stats since it isn't used.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |  3 ---
 drivers/staging/media/dt3155v4l/dt3155v4l.h | 16 ----------------
 2 files changed, 19 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 07cf8c3..5734dde 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -304,11 +304,8 @@ static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 		ipd->field_count++;
 		return IRQ_HANDLED; /* start of field irq */
 	}
-	if ((tmp & FLD_START) && (tmp & FLD_END_ODD))
-		ipd->stats.start_before_end++;
 	tmp = ioread32(ipd->regs + CSR1) & (FLD_CRPT_EVEN | FLD_CRPT_ODD);
 	if (tmp) {
-		ipd->stats.corrupted_fields++;
 		iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
 						FLD_DN_ODD | FLD_DN_EVEN |
 						CAP_CONT_EVEN | CAP_CONT_ODD,
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index 5aeee75..b4cb412 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -153,21 +153,6 @@
 #define DMA_STRIDE 640
 #endif
 
-/**
- * struct dt3155_stats - statistics structure
- *
- * @free_bufs_empty:	no free image buffers
- * @corrupted_fields:	corrupted fields
- * @dma_map_failed:	dma mapping failed
- * @start_before_end:	new started before old ended
- */
-struct dt3155_stats {
-	int free_bufs_empty;
-	int corrupted_fields;
-	int dma_map_failed;
-	int start_before_end;
-};
-
 /*    per board private data structure   */
 /**
  * struct dt3155_priv - private data structure
@@ -195,7 +180,6 @@ struct dt3155_priv {
 	struct list_head dmaq;
 	spinlock_t lock;
 	unsigned int field_count;
-	struct dt3155_stats stats;
 	void __iomem *regs;
 	int users;
 	u8 csr2, config;
-- 
2.1.4

