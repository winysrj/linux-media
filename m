Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/39] [media] Docbook: Fix comments at v4l2-mem2mem.h
Date: Sat, 22 Aug 2015 14:27:53 -0300
Message-Id: <d3c44887dc46109609d8ee02beaa64362a65c63a.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/v4l2-mem2mem.h:50): No description found for parameter 'lock'
Warning(.//include/media/v4l2-mem2mem.h:50): No description found for parameter 'unlock'
Warning(.//include/media/v4l2-mem2mem.h:167): No description found for parameter 'm2m_ctx'
Warning(.//include/media/v4l2-mem2mem.h:177): No description found for parameter 'm2m_ctx'
Warning(.//include/media/v4l2-mem2mem.h:188): No description found for parameter 'm2m_ctx'
Warning(.//include/media/v4l2-mem2mem.h:197): No description found for parameter 'm2m_ctx'
Warning(.//include/media/v4l2-mem2mem.h:206): No description found for parameter 'm2m_ctx'
Warning(.//include/media/v4l2-mem2mem.h:215): No description found for parameter 'm2m_ctx'
Warning(.//include/media/v4l2-mem2mem.h:226): No description found for parameter 'm2m_ctx'
Warning(.//include/media/v4l2-mem2mem.h:235): No description found for parameter 'm2m_ctx'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 3bbd96da25c9..8849aaba6aa5 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -40,6 +40,10 @@
  *		v4l2_m2m_job_finish() (as if the transaction ended normally).
  *		This function does not have to (and will usually not) wait
  *		until the device enters a state when it can be stopped.
+ * @lock:	optional. Define a driver's own lock callback, instead of using
+ *		m2m_ctx->q_lock.
+ * @unlock:	optional. Define a driver's own unlock callback, instead of
+ *		using m2m_ctx->q_lock.
  */
 struct v4l2_m2m_ops {
 	void (*device_run)(void *priv);
@@ -161,6 +165,8 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
 /**
  * v4l2_m2m_num_src_bufs_ready() - return the number of source buffers ready for
  * use
+ *
+ * @m2m_ctx: pointer to struct v4l2_m2m_ctx
  */
 static inline
 unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
@@ -171,6 +177,8 @@ unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
 /**
  * v4l2_m2m_num_src_bufs_ready() - return the number of destination buffers
  * ready for use
+ *
+ * @m2m_ctx: pointer to struct v4l2_m2m_ctx
  */
 static inline
 unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
@@ -183,6 +191,8 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
 /**
  * v4l2_m2m_next_src_buf() - return next source buffer from the list of ready
  * buffers
+ *
+ * @m2m_ctx: pointer to struct v4l2_m2m_ctx
  */
 static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
@@ -192,6 +202,8 @@ static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
 /**
  * v4l2_m2m_next_dst_buf() - return next destination buffer from the list of
  * ready buffers
+ *
+ * @m2m_ctx: pointer to struct v4l2_m2m_ctx
  */
 static inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
@@ -200,6 +212,8 @@ static inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
 
 /**
  * v4l2_m2m_get_src_vq() - return vb2_queue for source buffers
+ *
+ * @m2m_ctx: pointer to struct v4l2_m2m_ctx
  */
 static inline
 struct vb2_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx)
@@ -209,6 +223,8 @@ struct vb2_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx)
 
 /**
  * v4l2_m2m_get_dst_vq() - return vb2_queue for destination buffers
+ *
+ * @m2m_ctx: pointer to struct v4l2_m2m_ctx
  */
 static inline
 struct vb2_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
@@ -221,6 +237,8 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx);
 /**
  * v4l2_m2m_src_buf_remove() - take off a source buffer from the list of ready
  * buffers and return it
+ *
+ * @m2m_ctx: pointer to struct v4l2_m2m_ctx
  */
 static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
@@ -230,6 +248,8 @@ static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 /**
  * v4l2_m2m_dst_buf_remove() - take off a destination buffer from the list of
  * ready buffers and return it
+ *
+ * @m2m_ctx: pointer to struct v4l2_m2m_ctx
  */
 static inline void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
-- 
2.4.3

