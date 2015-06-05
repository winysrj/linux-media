Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:53341 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933061AbbFEO3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 10:29:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] v4l2-mem2mem: add support for prepare_buf
Date: Fri,  5 Jun 2015 16:28:50 +0200
Message-Id: <1433514532-23306-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433514532-23306-1-git-send-email-hverkuil@xs4all.nl>
References: <1433514532-23306-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This was never added for some reason, so add it now.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 28 ++++++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           |  4 ++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index cbef15c..dc853e5 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -427,6 +427,25 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
 /**
+ * v4l2_m2m_prepare_buf() - prepare a source or destination buffer, depending on
+ * the type
+ */
+int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+			 struct v4l2_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_prepare_buf(vq, buf);
+	if (!ret)
+		v4l2_m2m_try_schedule(m2m_ctx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
+
+/**
  * v4l2_m2m_create_bufs() - create a source or destination buffer, depending
  * on the type
  */
@@ -811,6 +830,15 @@ int v4l2_m2m_ioctl_dqbuf(struct file *file, void *priv,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_dqbuf);
 
+int v4l2_m2m_ioctl_prepare_buf(struct file *file, void *priv,
+			       struct v4l2_buffer *buf)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_prepare_buf(file, fh->m2m_ctx, buf);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_prepare_buf);
+
 int v4l2_m2m_ioctl_expbuf(struct file *file, void *priv,
 				struct v4l2_exportbuffer *eb)
 {
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index c5f3914..3bbd96d 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -116,6 +116,8 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct v4l2_buffer *buf);
 int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf);
+int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+			 struct v4l2_buffer *buf);
 int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct v4l2_create_buffers *create);
 
@@ -248,6 +250,8 @@ int v4l2_m2m_ioctl_qbuf(struct file *file, void *fh,
 				struct v4l2_buffer *buf);
 int v4l2_m2m_ioctl_dqbuf(struct file *file, void *fh,
 				struct v4l2_buffer *buf);
+int v4l2_m2m_ioctl_prepare_buf(struct file *file, void *fh,
+			       struct v4l2_buffer *buf);
 int v4l2_m2m_ioctl_streamon(struct file *file, void *fh,
 				enum v4l2_buf_type type);
 int v4l2_m2m_ioctl_streamoff(struct file *file, void *fh,
-- 
2.1.4

