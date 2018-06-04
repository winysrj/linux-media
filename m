Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:50064 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751933AbeFDLrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 28/35] v4l2-mem2mem: add vb2_m2m_request_queue
Date: Mon,  4 Jun 2018 13:46:41 +0200
Message-Id: <20180604114648.26159-29-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For mem2mem devices we have to make sure that v4l2_m2m_try_schedule()
is called whenever a request is queued.

We do that by creating a vb2_m2m_request_queue() helper that should
be used instead of the 'normal' vb2_request_queue() helper. The m2m
helper function will call v4l2_m2m_try_schedule() as needed.

In addition we also avoid calling v4l2_m2m_try_schedule() when preparing
or queueing a buffer for a request since that is no longer needed.
Instead this helper function will do that when the request is actually
queued.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 43 +++++++++++++++++++++-----
 include/media/v4l2-mem2mem.h           |  4 +++
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 88f95b78e4d0..ec0f8924f5c7 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -304,7 +304,7 @@ static void v4l2_m2m_cancel_job(struct v4l2_m2m_ctx *m2m_ctx)
 	if (m2m_ctx->job_flags & TRANS_RUNNING) {
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
 		m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
-		dprintk("m2m_ctx %p running, will wait to complete", m2m_ctx);
+		dprintk("m2m_ctx %p running, will wait to complete\n", m2m_ctx);
 		wait_event(m2m_ctx->finished,
 				!(m2m_ctx->job_flags & TRANS_RUNNING));
 	} else if (m2m_ctx->job_flags & TRANS_QUEUED) {
@@ -396,8 +396,14 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	if (!V4L2_TYPE_IS_OUTPUT(vq->type) &&
+	    (buf->flags & V4L2_BUF_FLAG_REQUEST_FD)) {
+		dprintk("%s: requests cannot be used with capture buffers\n",
+			__func__);
+		return -EINVAL;
+	}
 	ret = vb2_qbuf(vq, vdev->v4l2_dev->mdev, buf);
-	if (!ret)
+	if (!ret && !(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
 		v4l2_m2m_try_schedule(m2m_ctx);
 
 	return ret;
@@ -419,14 +425,9 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 {
 	struct video_device *vdev = video_devdata(file);
 	struct vb2_queue *vq;
-	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
-	if (!ret)
-		v4l2_m2m_try_schedule(m2m_ctx);
-
-	return ret;
+	return vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
 
@@ -703,6 +704,32 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
 
+void vb2_m2m_request_queue(struct media_request *req)
+{
+	struct media_request_object *obj;
+
+	list_for_each_entry(obj, &req->objects, list) {
+		struct v4l2_m2m_ctx *m2m_ctx;
+		struct vb2_buffer *vb;
+
+		if (!obj->ops->queue)
+			continue;
+
+		obj->ops->queue(obj);
+		if (!vb2_request_object_is_buffer(obj))
+			continue;
+
+		vb = container_of(obj, struct vb2_buffer, req_obj);
+		if (WARN_ON(!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)))
+			continue;
+		m2m_ctx = container_of(vb->vb2_queue,
+				       struct v4l2_m2m_ctx,
+				       out_q_ctx.q);
+		v4l2_m2m_try_schedule(m2m_ctx);
+	}
+}
+EXPORT_SYMBOL_GPL(vb2_m2m_request_queue);
+
 /* Videobuf2 ioctl helpers */
 
 int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 3d07ba3a8262..f01b3fc13b0e 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -580,6 +580,10 @@ v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
 	return v4l2_m2m_buf_remove_by_idx(&m2m_ctx->cap_q_ctx, idx);
 }
 
+/* v4l2 request helper */
+
+void vb2_m2m_request_queue(struct media_request *req);
+
 /* v4l2 ioctl helpers */
 
 int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
-- 
2.17.0
