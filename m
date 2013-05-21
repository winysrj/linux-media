Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56226 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3EUIQg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 04:16:36 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Pawel Osciak <pawel@osciak.com>, John Sheu <sheu@google.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] [media] v4l2-mem2mem: add v4l2_m2m_create_bufs helper
Date: Tue, 21 May 2013 10:16:28 +0200
Message-Id: <1369124189-590-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 14 ++++++++++++++
 include/media/v4l2-mem2mem.h           |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 66f599f..357efa4 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -372,6 +372,20 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
 /**
+ * v4l2_m2m_create_bufs() - create a source or destination buffer, depending
+ * on the type
+ */
+int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+			 struct v4l2_create_buffers *create)
+{
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, create->format.type);
+        return vb2_create_bufs(vq, create);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_create_bufs);
+
+/**
  * v4l2_m2m_expbuf() - export a source or destination buffer, depending on
  * the type
  */
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index d3eef01..0f4555b 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -110,6 +110,8 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct v4l2_buffer *buf);
 int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf);
+int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+			 struct v4l2_create_buffers *create);
 
 int v4l2_m2m_expbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_exportbuffer *eb);
-- 
1.8.2.rc2

