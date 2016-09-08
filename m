Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935667AbcIHVhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 05/15] [media] v4l2-mem2mem.h: make kernel-doc parse v4l2-mem2mem.h again
Date: Thu,  8 Sep 2016 18:37:31 -0300
Message-Id: <154983a193b661c1d02772f973f85a34ebc0dac9.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kernel-doc C parser doesn't like opaque structures. So,
document it on another way.

This should get rid of this warning:
	./include/media/v4l2-mem2mem.h:62: error: Cannot parse struct or union!

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-mem2mem.h | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index f74ea7026c88..9a7eb5605254 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -53,12 +53,6 @@ struct v4l2_m2m_ops {
 	void (*unlock)(void *priv);
 };
 
-/**
- * struct v4l2_m2m_dev - opaque struct used to represent a V4L2 M2M device.
- *
- * This structure is has the per-device context for a memory to memory
- * device, and it is used internally at v4l2-mem2mem.c.
- */
 struct v4l2_m2m_dev;
 
 /**
@@ -88,7 +82,7 @@ struct v4l2_m2m_queue_ctx {
  * struct v4l2_m2m_ctx - Memory to memory context structure
  *
  * @q_lock: struct &mutex lock
- * @m2m_dev: pointer to struct &v4l2_m2m_dev
+ * @m2m_dev: opaque pointer to the internal data to handle M2M context
  * @cap_q_ctx: Capture (output to memory) queue context
  * @out_q_ctx: Output (input from memory) queue context
  * @queue: List of memory to memory contexts
@@ -131,7 +125,7 @@ struct v4l2_m2m_buffer {
  * v4l2_m2m_get_curr_priv() - return driver private data for the currently
  * running instance or NULL if no instance is running
  *
- * @m2m_dev: pointer to struct &v4l2_m2m_dev
+ * @m2m_dev: opaque pointer to the internal data to handle M2M context
  */
 void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev);
 
@@ -171,7 +165,7 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx);
  * v4l2_m2m_job_finish() - inform the framework that a job has been finished
  * and have it clean up
  *
- * @m2m_dev: pointer to struct &v4l2_m2m_dev
+ * @m2m_dev: opaque pointer to the internal data to handle M2M context
  * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  *
  * Called by a driver to yield back the device after it has finished with it.
@@ -334,7 +328,7 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
 /**
  * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
  *
- * @m2m_dev: pointer to struct &v4l2_m2m_dev
+ * @m2m_dev: opaque pointer to the internal data to handle M2M context
  *
  * Usually called from driver's ``remove()`` function.
  */
@@ -343,7 +337,7 @@ void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
 /**
  * v4l2_m2m_ctx_init() - allocate and initialize a m2m context
  *
- * @m2m_dev: a previously initialized m2m_dev struct
+ * @m2m_dev: opaque pointer to the internal data to handle M2M context
  * @drv_priv: driver's instance private data
  * @queue_init: a callback for queue type-specific initialization function
  * 	to be used for initializing videobuf_queues
-- 
2.7.4


