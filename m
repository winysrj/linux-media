Return-path: <linux-media-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:40779 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2HJO6B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 10:58:01 -0400
Subject: [PATCH 3/4] dma-seqno-fence: Hardware dma-buf implementation of
 fencing (v2)
To: sumit.semwal@linaro.org, rob.clark@linaro.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	patches@linaro.org
Date: Fri, 10 Aug 2012 16:57:58 +0200
Message-ID: <20120810145758.5490.62372.stgit@patser.local>
In-Reply-To: <20120810145728.5490.44707.stgit@patser.local>
References: <20120810145728.5490.44707.stgit@patser.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This type of fence can be used with hardware synchronization for simple
hardware that can block execution until the condition
(dma_buf[offset] - value) >= 0 has been met.

A software fallback still has to be provided in case the fence is used
with a device that doesn't support this mechanism. It is useful to expose
this for graphics cards that have an op to support this.

Some cards like i915 can export those, but don't have an option to wait,
so they need the software fallback.

I extended the original patch by Rob Clark.

v1: Original
v2: Renamed from bikeshed to seqno, moved into dma-fence.c since
    not much was left of the file. Lots of documentation added.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/base/dma-fence.c  |   21 +++++++++++++++
 include/linux/dma-fence.h |   61 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/base/dma-fence.c b/drivers/base/dma-fence.c
index 93448e4..4092a58 100644
--- a/drivers/base/dma-fence.c
+++ b/drivers/base/dma-fence.c
@@ -266,3 +266,24 @@ struct dma_fence *dma_fence_create(void *priv)
 	return fence;
 }
 EXPORT_SYMBOL_GPL(dma_fence_create);
+
+static int seqno_enable_signaling(struct dma_fence *fence)
+{
+	struct dma_seqno_fence *seqno_fence = to_seqno_fence(fence);
+	return seqno_fence->enable_signaling(seqno_fence);
+}
+
+static void seqno_release(struct dma_fence *fence)
+{
+	struct dma_seqno_fence *f = to_seqno_fence(fence);
+
+	if (f->release)
+		f->release(f);
+	dma_buf_put(f->sync_buf);
+}
+
+const struct dma_fence_ops dma_seqno_fence_ops = {
+	.enable_signaling = seqno_enable_signaling,
+	.release = seqno_release
+};
+EXPORT_SYMBOL_GPL(dma_seqno_fence_ops);
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index e0ceddd..3ef0da0 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -91,6 +91,19 @@ struct dma_fence_ops {
 	void (*release)(struct dma_fence *fence);
 };
 
+struct dma_seqno_fence {
+	struct dma_fence base;
+
+	struct dma_buf *sync_buf;
+	uint32_t seqno_ofs;
+	uint32_t seqno;
+
+	int (*enable_signaling)(struct dma_seqno_fence *fence);
+	void (*release)(struct dma_seqno_fence *fence);
+};
+
+extern const struct dma_fence_ops dma_seqno_fence_ops;
+
 struct dma_fence *dma_fence_create(void *priv);
 
 /**
@@ -121,4 +134,52 @@ int dma_fence_wait(struct dma_fence *fence, bool intr, unsigned long timeout);
 int dma_fence_add_callback(struct dma_fence *fence, struct dma_fence_cb *cb,
 			   dma_fence_func_t func, void *priv);
 
+/**
+ * to_seqno_fence - cast a dma_fence to a dma_seqno_fence
+ * @fence: dma_fence to cast to a dma_seqno_fence
+ *
+ * Returns NULL if the dma_fence is not a dma_seqno_fence,
+ * or the dma_seqno_fence otherwise.
+ */
+static inline struct dma_seqno_fence *
+to_seqno_fence(struct dma_fence *fence)
+{
+	if (fence->ops != &dma_seqno_fence_ops)
+		return NULL;
+	return container_of(fence, struct dma_seqno_fence, base);
+}
+
+/**
+ * dma_seqno_fence_init - initialize a seqno fence
+ * @fence: dma_seqno_fence to initialize
+ * @sync_buf: buffer containing the memory location to signal on
+ * @seqno_ofs: the offset within @sync_buf
+ * @seqno: the sequence # to signal on
+ * @priv: value of priv member
+ * @enable_signaling: callback which is called when some other device is
+ *    waiting for sw notification of fence
+ * @release: callback called during destruction before object is freed.
+ *
+ * This function initializes a struct dma_seqno_fence with passed parameters,
+ * and takes a reference on sync_buf which is released on fence destruction.
+ */
+static inline void
+dma_seqno_fence_init(struct dma_seqno_fence *fence,
+			struct dma_buf *sync_buf,
+			uint32_t seqno_ofs, uint32_t seqno, void *priv,
+			int (*enable_signaling)(struct dma_seqno_fence *),
+			void (*release)(struct dma_seqno_fence *))
+{
+	BUG_ON(!fence || !sync_buf || !enable_signaling);
+
+	__dma_fence_init(&fence->base, &dma_seqno_fence_ops, priv);
+
+	get_dma_buf(sync_buf);
+	fence->sync_buf = sync_buf;
+	fence->seqno_ofs = seqno_ofs;
+	fence->seqno = seqno;
+	fence->enable_signaling = enable_signaling;
+	fence->release = release;
+}
+
 #endif /* __DMA_FENCE_H__ */

