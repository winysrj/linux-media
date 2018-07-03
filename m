Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52356 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752935AbeGCL2F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jul 2018 07:28:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tom aan de Wiel <tom.aandewiel@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/4] v4l2-mem2mem: add v4l2_m2m_last_buf()
Date: Tue,  3 Jul 2018 13:28:01 +0200
Message-Id: <20180703112803.24343-3-hverkuil@xs4all.nl>
In-Reply-To: <20180703112803.24343-1-hverkuil@xs4all.nl>
References: <20180703112803.24343-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This can be used to mark the last queued source buffer as the last
buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 18 ++++++++++++++++
 include/media/v4l2-mem2mem.h           | 29 ++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 725da74d15d8..3b5b610665f3 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -129,6 +129,24 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_next_buf);
 
+void *v4l2_m2m_last_buf(struct v4l2_m2m_queue_ctx *q_ctx)
+{
+	struct v4l2_m2m_buffer *b;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
+
+	if (list_empty(&q_ctx->rdy_queue)) {
+		spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
+		return NULL;
+	}
+
+	b = list_last_entry(&q_ctx->rdy_queue, struct v4l2_m2m_buffer, list);
+	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
+	return &b->vb;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_last_buf);
+
 void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
 {
 	struct v4l2_m2m_buffer *b;
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index af48b1eca025..bbf300c7b12c 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -449,6 +449,35 @@ static inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
 	return v4l2_m2m_next_buf(&m2m_ctx->cap_q_ctx);
 }
 
+/**
+ * v4l2_m2m_last_buf() - return last buffer from the list of ready buffers
+ *
+ * @q_ctx: pointer to struct @v4l2_m2m_queue_ctx
+ */
+void *v4l2_m2m_last_buf(struct v4l2_m2m_queue_ctx *q_ctx);
+
+/**
+ * v4l2_m2m_last_src_buf() - return last destination buffer from the list of
+ * ready buffers
+ *
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ */
+static inline void *v4l2_m2m_last_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return v4l2_m2m_last_buf(&m2m_ctx->out_q_ctx);
+}
+
+/**
+ * v4l2_m2m_last_dst_buf() - return last destination buffer from the list of
+ * ready buffers
+ *
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ */
+static inline void *v4l2_m2m_last_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return v4l2_m2m_last_buf(&m2m_ctx->cap_q_ctx);
+}
+
 /**
  * v4l2_m2m_for_each_dst_buf() - iterate over a list of destination ready
  * buffers
-- 
2.18.0
