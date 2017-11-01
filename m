Return-path: <linux-media-owner@vger.kernel.org>
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:56968 "EHLO
        cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754562AbdKAPKa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 11:10:30 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Linux Media ML <linux-media@vger.kernel.org>,
        DRI-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH] dma-buf: Cleanup comments on dma_buf_map_attachment()
Date: Wed,  1 Nov 2017 14:06:30 +0000
Message-Id: <20171101140630.2884-1-Liviu.Dudau@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mappings need to be unmapped by calling dma_buf_unmap_attachment() and
not by calling again dma_buf_map_attachment(). Also fix some spelling
mistakes.

Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
---
 drivers/dma-buf/dma-buf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index bc1cb284111cb..1792385405f0e 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -351,13 +351,13 @@ static inline int is_dma_buf_file(struct file *file)
  *
  * 2. Userspace passes this file-descriptors to all drivers it wants this buffer
  *    to share with: First the filedescriptor is converted to a &dma_buf using
- *    dma_buf_get(). The the buffer is attached to the device using
+ *    dma_buf_get(). Then the buffer is attached to the device using
  *    dma_buf_attach().
  *
  *    Up to this stage the exporter is still free to migrate or reallocate the
  *    backing storage.
  *
- * 3. Once the buffer is attached to all devices userspace can inniate DMA
+ * 3. Once the buffer is attached to all devices userspace can initiate DMA
  *    access to the shared buffer. In the kernel this is done by calling
  *    dma_buf_map_attachment() and dma_buf_unmap_attachment().
  *
@@ -617,7 +617,7 @@ EXPORT_SYMBOL_GPL(dma_buf_detach);
  * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
  * on error. May return -EINTR if it is interrupted by a signal.
  *
- * A mapping must be unmapped again using dma_buf_map_attachment(). Note that
+ * A mapping must be unmapped by using dma_buf_unmap_attachment(). Note that
  * the underlying backing storage is pinned for as long as a mapping exists,
  * therefore users/importers should not hold onto a mapping for undue amounts of
  * time.
-- 
2.14.3
