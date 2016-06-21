Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:34700 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbcFUHRt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 03:17:49 -0400
From: Chris Wilson <chris@chris-wilson.co.uk>
To: dri-devel@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dma-buf: Wait on the reservation object when sync'ing before CPU access
Date: Tue, 21 Jun 2016 08:04:00 +0100
Message-Id: <1466492640-12551-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rendering operations to the dma-buf are tracked implicitly via the
reservation_object (dmabuf->resv). This is used to allow poll() to
wait upon outstanding rendering (or just query the current status of
rendering). The dma-buf sync ioctl allows userspace to prepare the
dma-buf for CPU access, which should include waiting upon rendering.
(Some drivers may need to do more work to ensure that the dma-buf mmap
is coherent as well as complete.)

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-kernel@vger.kernel.org
---

I'm wondering whether it makes sense just to always do the wait first.
It is one of the first operations every driver has to make. A driver
that wants to implement it differently (e.g. they can special case
native waits) will still require a wait on the reservation object to
finish external rendering.
-Chris

---
 drivers/dma-buf/dma-buf.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index ddaee60ae52a..123f14b8e882 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -586,6 +586,22 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
 
+static int __dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
+				      enum dma_data_direction direction)
+{
+	bool write = (direction == DMA_BIDIRECTIONAL ||
+		      direction == DMA_TO_DEVICE);
+	struct reservation_object *resv = dma_buf->resv;
+	long ret;
+
+	/* Wait on any implicit rendering fences */
+	ret = reservation_object_wait_timeout_rcu(resv, write, true,
+						  MAX_SCHEDULE_TIMEOUT);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
 
 /**
  * dma_buf_begin_cpu_access - Must be called before accessing a dma_buf from the
@@ -607,6 +623,8 @@ int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
 
 	if (dmabuf->ops->begin_cpu_access)
 		ret = dmabuf->ops->begin_cpu_access(dmabuf, direction);
+	else
+		ret = __dma_buf_begin_cpu_access(dmabuf, direction);
 
 	return ret;
 }
-- 
2.8.1

