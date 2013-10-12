Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:32869 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab3JLMiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 08:38:55 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2.1 01/10] V4L: Add mem2mem ioctl and file operation helpers
Date: Sat, 12 Oct 2013 14:38:38 +0200
Message-Id: <1381581518-7022-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1381581120-26883-2-git-send-email-s.nawrocki@samsung.com>
References: <1381581120-26883-2-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds ioctl helpers to the V4L2 mem-to-mem API, so we can avoid
several ioctl handlers in the mem-to-mem video node drivers that are simply
a pass-through to the v4l2_m2m_* calls. These helpers will only be useful
for drivers that use same mutex for both OUTPUT and CAPTURE queue, which
is the case for all currently in tree v4l2 m2m drivers. In order to use
the helpers the drivers are required to use struct v4l2_fh.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v1:
 - added v4l2_m2m_ioctl_create_buf().

This time with the whitespace adjustments I missed to merge into
the first patch.
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |  126 ++++++++++++++++++++++++++++++++
 include/media/v4l2-fh.h                |    4 +
 include/media/v4l2-mem2mem.h           |   24 ++++++
 3 files changed, 154 insertions(+), 0 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 7c43712..7494ee3 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -544,6 +544,8 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,

 	if (m2m_ctx->m2m_dev->m2m_ops->unlock)
 		m2m_ctx->m2m_dev->m2m_ops->unlock(m2m_ctx->priv);
+	else if (m2m_ctx->q_lock)
+		mutex_unlock(m2m_ctx->q_lock);

 	if (list_empty(&src_q->done_list))
 		poll_wait(file, &src_q->done_wq, wait);
@@ -552,6 +554,8 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,

 	if (m2m_ctx->m2m_dev->m2m_ops->lock)
 		m2m_ctx->m2m_dev->m2m_ops->lock(m2m_ctx->priv);
+	else if (m2m_ctx->q_lock)
+		mutex_lock(m2m_ctx->q_lock);

 	spin_lock_irqsave(&src_q->done_lock, flags);
 	if (!list_empty(&src_q->done_list))
@@ -679,6 +683,13 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,

 	if (ret)
 		goto err;
+	/*
+	 * If both queues use same mutex assign it as the common buffer
+	 * queues lock to the m2m context. This lock is used in the
+	 * v4l2_m2m_ioctl_* helpers.
+	 */
+	if (out_q_ctx->q.lock == cap_q_ctx->q.lock)
+		m2m_ctx->q_lock = out_q_ctx->q.lock;

 	return m2m_ctx;
 err:
@@ -726,3 +737,118 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);

+/* Videobuf2 ioctl helpers */
+
+int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
+				struct v4l2_requestbuffers *rb)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_reqbufs(file, fh->m2m_ctx, rb);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_reqbufs);
+
+int v4l2_m2m_ioctl_create_bufs(struct file *file, void *priv,
+				struct v4l2_create_buffers *create)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_create_bufs(file, fh->m2m_ctx, create);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_create_bufs);
+
+int v4l2_m2m_ioctl_querybuf(struct file *file, void *priv,
+				struct v4l2_buffer *buf)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_querybuf(file, fh->m2m_ctx, buf);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_querybuf);
+
+int v4l2_m2m_ioctl_qbuf(struct file *file, void *priv,
+				struct v4l2_buffer *buf)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_qbuf(file, fh->m2m_ctx, buf);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_qbuf);
+
+int v4l2_m2m_ioctl_dqbuf(struct file *file, void *priv,
+				struct v4l2_buffer *buf)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_dqbuf(file, fh->m2m_ctx, buf);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_dqbuf);
+
+int v4l2_m2m_ioctl_expbuf(struct file *file, void *priv,
+				struct v4l2_exportbuffer *eb)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_expbuf(file, fh->m2m_ctx, eb);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_expbuf);
+
+int v4l2_m2m_ioctl_streamon(struct file *file, void *priv,
+				enum v4l2_buf_type type)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_streamon(file, fh->m2m_ctx, type);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_streamon);
+
+int v4l2_m2m_ioctl_streamoff(struct file *file, void *priv,
+				enum v4l2_buf_type type)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_streamoff(file, fh->m2m_ctx, type);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_streamoff);
+
+/*
+ * v4l2_file_operations helpers. It is assumed here same lock is used
+ * for the output and the capture buffer queue.
+ */
+
+int v4l2_m2m_fop_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct v4l2_fh *fh = file->private_data;
+	struct v4l2_m2m_ctx *m2m_ctx = fh->m2m_ctx;
+	int ret;
+
+	if (m2m_ctx->q_lock && mutex_lock_interruptible(m2m_ctx->q_lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_m2m_mmap(file, m2m_ctx, vma);
+
+	if (m2m_ctx->q_lock)
+		mutex_unlock(m2m_ctx->q_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_fop_mmap);
+
+unsigned int v4l2_m2m_fop_poll(struct file *file, poll_table *wait)
+{
+	struct v4l2_fh *fh = file->private_data;
+	struct v4l2_m2m_ctx *m2m_ctx = fh->m2m_ctx;
+	unsigned int ret;
+
+	if (m2m_ctx->q_lock)
+		mutex_lock(m2m_ctx->q_lock);
+
+	ret = v4l2_m2m_poll(file, m2m_ctx, wait);
+
+	if (m2m_ctx->q_lock)
+		mutex_unlock(m2m_ctx->q_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_fop_poll);
+
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index a62ee18..d942f79 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -43,6 +43,10 @@ struct v4l2_fh {
 	struct list_head	available; /* Dequeueable event */
 	unsigned int		navailable;
 	u32			sequence;
+
+#if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
+	struct v4l2_m2m_ctx	*m2m_ctx;
+#endif
 };

 /*
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 44542a2..12ea5a6 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -64,6 +64,9 @@ struct v4l2_m2m_queue_ctx {
 };

 struct v4l2_m2m_ctx {
+	/* optional cap/out vb2 queues lock */
+	struct mutex			*q_lock;
+
 /* private: internal use only */
 	struct v4l2_m2m_dev		*m2m_dev;

@@ -229,5 +232,26 @@ static inline void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 	return v4l2_m2m_buf_remove(&m2m_ctx->cap_q_ctx);
 }

+/* v4l2 ioctl helpers */
+
+int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
+				struct v4l2_requestbuffers *rb);
+int v4l2_m2m_ioctl_create_bufs(struct file *file, void *fh,
+				struct v4l2_create_buffers *create);
+int v4l2_m2m_ioctl_querybuf(struct file *file, void *fh,
+				struct v4l2_buffer *buf);
+int v4l2_m2m_ioctl_expbuf(struct file *file, void *fh,
+				struct v4l2_exportbuffer *eb);
+int v4l2_m2m_ioctl_qbuf(struct file *file, void *fh,
+				struct v4l2_buffer *buf);
+int v4l2_m2m_ioctl_dqbuf(struct file *file, void *fh,
+				struct v4l2_buffer *buf);
+int v4l2_m2m_ioctl_streamon(struct file *file, void *fh,
+				enum v4l2_buf_type type);
+int v4l2_m2m_ioctl_streamoff(struct file *file, void *fh,
+				enum v4l2_buf_type type);
+int v4l2_m2m_fop_mmap(struct file *file, struct vm_area_struct *vma);
+unsigned int v4l2_m2m_fop_poll(struct file *file, poll_table *wait);
+
 #endif /* _MEDIA_V4L2_MEM2MEM_H */

--
1.7.4.1

