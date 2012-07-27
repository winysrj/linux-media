Return-path: <linux-media-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:32961 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2G0OOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 10:14:00 -0400
Subject: [RFC PATCH 3/3] dma-bikeshed-fence: Hardware dma-buf implementation
 of fencing
To: linaro-mm-sig@lists.linaro.org, rob.clark@linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: patches@linaro.org, linux-kernel@vger.kernel.org,
	sumit.semwal@linaro.org
Date: Fri, 27 Jul 2012 15:40:13 +0200
Message-ID: <20120727134011.2036.58474.stgit@patser.local>
In-Reply-To: <20120727133952.2036.61330.stgit@patser.local>
References: <20120727133952.2036.61330.stgit@patser.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This type of fence can be used with hardware synchronization for simple
hardware that can block execution until the condition
dma_buf[offset] >= value has been met, accounting for wraparound.

A software fallback still has to be provided in case the fence is used
with a device that doesn't support this mechanism. It is useful to expose
this for graphics cards that have an op to support this.

Some cards like i915 can export those, but don't have an option to wait,
so they need the software fallback.

I extended the original patch by Rob Clark.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/base/Makefile              |    2 -
 drivers/base/dma-bikeshed-fence.c  |   44 +++++++++++++++++
 include/linux/dma-bikeshed-fence.h |   92 ++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/dma-bikeshed-fence.c
 create mode 100644 include/linux/dma-bikeshed-fence.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 6e9f217..1e7723b 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o dma-bikeshed-fence.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-bikeshed-fence.c b/drivers/base/dma-bikeshed-fence.c
new file mode 100644
index 0000000..fa063e8
--- /dev/null
+++ b/drivers/base/dma-bikeshed-fence.c
@@ -0,0 +1,44 @@
+/*
+ * dma-fence implementation that supports hw synchronization via hw
+ * read/write of memory semaphore
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Author: Rob Clark <rob.clark@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/dma-bikeshed-fence.h>
+
+static int enable_signaling(struct dma_fence *fence)
+{
+	struct dma_bikeshed_fence *bikeshed_fence = to_bikeshed_fence(fence);
+	return bikeshed_fence->enable_signaling(bikeshed_fence);
+}
+
+static void bikeshed_release(struct dma_fence *fence)
+{
+	struct dma_bikeshed_fence *f = to_bikeshed_fence(fence);
+
+	if (f->release)
+		f->release(f);
+	dma_buf_put(f->sync_buf);
+}
+
+struct dma_fence_ops dma_bikeshed_fence_ops = {
+	.enable_signaling = enable_signaling,
+	.release = bikeshed_release
+};
+EXPORT_SYMBOL_GPL(dma_bikeshed_fence_ops);
diff --git a/include/linux/dma-bikeshed-fence.h b/include/linux/dma-bikeshed-fence.h
new file mode 100644
index 0000000..4f19801
--- /dev/null
+++ b/include/linux/dma-bikeshed-fence.h
@@ -0,0 +1,92 @@
+/*
+ * dma-fence implementation that supports hw synchronization via hw
+ * read/write of memory semaphore
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Author: Rob Clark <rob.clark@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __DMA_BIKESHED_FENCE_H__
+#define __DMA_BIKESHED_FENCE_H__
+
+#include <linux/types.h>
+#include <linux/dma-fence.h>
+#include <linux/dma-buf.h>
+
+struct dma_bikeshed_fence {
+	struct dma_fence base;
+
+	struct dma_buf *sync_buf;
+	uint32_t seqno_ofs;
+	uint32_t seqno;
+
+	int (*enable_signaling)(struct dma_bikeshed_fence *fence);
+	void (*release)(struct dma_bikeshed_fence *fence);
+};
+
+/*
+ * TODO does it make sense to be able to enable dma-fence without dma-buf,
+ * or visa versa?
+ */
+#ifdef CONFIG_DMA_SHARED_BUFFER
+
+extern struct dma_fence_ops dma_bikeshed_fence_ops;
+
+static inline bool is_bikeshed_fence(struct dma_fence *fence)
+{
+	return fence->ops == &dma_bikeshed_fence_ops;
+}
+
+static inline struct dma_bikeshed_fence *to_bikeshed_fence(struct dma_fence *fence)
+{
+	if (WARN_ON(!is_bikeshed_fence(fence)))
+		return NULL;
+	return container_of(fence, struct dma_bikeshed_fence, base);
+}
+
+/**
+ * dma_bikeshed_fence_init - Initialize a fence
+ *
+ * @fence: dma_bikeshed_fence to initialize
+ * @sync_buf: buffer containing the memory location to signal on
+ * @seqno_ofs: the offset within @sync_buf
+ * @seqno: the sequence # to signal on
+ * @priv: value of priv member
+ * @enable_signaling: callback which is called when some other device is
+ *    waiting for sw notification of fence
+ * @release: callback called during destruction before object is freed.
+ */
+static inline void dma_bikeshed_fence_init(struct dma_bikeshed_fence *fence,
+		struct dma_buf *sync_buf,
+		uint32_t seqno_ofs, uint32_t seqno, void *priv,
+		int (*enable_signaling)(struct dma_bikeshed_fence *fence),
+		void (*release)(struct dma_bikeshed_fence *fence))
+{
+	BUG_ON(!fence || !sync_buf || !enable_signaling);
+
+	__dma_fence_init(&fence->base, &dma_bikeshed_fence_ops, priv);
+
+	get_dma_buf(sync_buf);
+	fence->sync_buf = sync_buf;
+	fence->seqno_ofs = seqno_ofs;
+	fence->seqno = seqno;
+	fence->enable_signaling = enable_signaling;
+}
+
+#else
+// TODO
+#endif /* CONFIG_DMA_SHARED_BUFFER */
+
+#endif /* __DMA_BIKESHED_FENCE_H__ */

