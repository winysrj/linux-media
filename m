Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39062 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752585AbdBNHwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 02:52:25 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH 12/15] media: s5p-mfc: Add support for probe-time preallocated
 block based allocator
Date: Tue, 14 Feb 2017 08:52:05 +0100
Message-id: <1487058728-16501-13-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075220eucas1p21d7f82fa19a9f058bb6fbe0a994478cc@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current MFC driver depends on the fact that when IOMMU is available, the
DMA-mapping framework and its IOMMU glue will use first-fit allocator.
This was true for ARM architecture, but its not for ARM64 arch. However, in
case of MFC v6+ hardware and latest firmware, it turned out that there is
no strict requirement for ALL buffers to be allocated on higher addresses
than the firmware base. This requirement is true only for the device and
per-context buffers. All video data buffers can be allocated anywhere for
all MFC v6+ versions.

Such relaxed requirements for the memory buffers can be easily fulfilled
by allocating firmware, device and per-context buffers from the probe-time
preallocated larger buffer. This patch adds support for it. This way the
driver finally works fine on ARM64 architecture. The size of the
preallocated buffer is 8 MiB, what is enough for three instances H264
decoders or encoders (other codecs have smaller memory requirements).
If one needs more for particular use case, one can use "mem" module
parameter to force larger (or smaller) buffer (for example by adding
"s5p_mfc.mem=16M" to kernel command line).

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 43 ++++++++++++++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  4 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    | 57 ++++++++++++++++---------
 3 files changed, 79 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index a18740c81c55..7492e81fde6d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -43,6 +43,10 @@
 module_param_named(debug, mfc_debug_level, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug level - higher value produces more verbose messages");
 
+static char *mfc_mem_size = NULL;
+module_param_named(mem, mfc_mem_size, charp, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(mem, "Preallocated memory size for the firmware and context buffers");
+
 /* Helper functions for interrupt processing */
 
 /* Remove from hw execution round robin */
@@ -1174,6 +1178,8 @@ static void s5p_mfc_unconfigure_2port_memory(struct s5p_mfc_dev *mfc_dev)
 static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
 {
 	struct device *dev = &mfc_dev->plat_dev->dev;
+	unsigned long mem_size = SZ_8M;
+	unsigned int bitmap_size;
 	/*
 	 * When IOMMU is available, we cannot use the default configuration,
 	 * because of MFC firmware requirements: address space limited to
@@ -1187,17 +1193,39 @@ static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
 	if (ret)
 		return ret;
 
-	mfc_dev->mem_dev[BANK1_CTX] = mfc_dev->mem_dev[BANK2_CTX] = dev;
-	ret = s5p_mfc_alloc_firmware(mfc_dev);
-	if (ret) {
+	if (mfc_mem_size)
+		mem_size = memparse(mfc_mem_size, NULL);
+
+	bitmap_size = BITS_TO_LONGS(mem_size >> PAGE_SHIFT) * sizeof(long);
+
+	mfc_dev->mem_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!mfc_dev->mem_bitmap) {
 		exynos_unconfigure_iommu(dev);
-		return ret;
+		return -ENOMEM;
 	}
 
-	mfc_dev->dma_base[BANK1_CTX] = mfc_dev->fw_buf.dma;
-	mfc_dev->dma_base[BANK2_CTX] = mfc_dev->fw_buf.dma;
+	mfc_dev->mem_virt = dma_alloc_coherent(dev, mem_size,
+					       &mfc_dev->mem_base, GFP_KERNEL);
+	if (!mfc_dev->mem_virt) {
+		kfree(mfc_dev->mem_bitmap);
+		dev_err(dev, "failed to preallocate %ld MiB for the firmware and context buffers\n",
+			(mem_size / SZ_1M));
+		exynos_unconfigure_iommu(dev);
+		return -ENOMEM;
+	}
+	mfc_dev->mem_size = mem_size;
+	mfc_dev->dma_base[BANK1_CTX] = mfc_dev->mem_base;
+	mfc_dev->dma_base[BANK2_CTX] = mfc_dev->mem_base;
+
+	/* Firmware allocation cannot fail in this case */
+	s5p_mfc_alloc_firmware(mfc_dev);
+
+	mfc_dev->mem_dev[BANK1_CTX] = mfc_dev->mem_dev[BANK2_CTX] = dev;
 	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 
+	dev_info(dev, "preallocated %ld MiB buffer for the firmware and context buffers\n",
+		 (mem_size / SZ_1M));
+
 	return 0;
 }
 
@@ -1206,6 +1234,9 @@ static void s5p_mfc_unconfigure_common_memory(struct s5p_mfc_dev *mfc_dev)
 	struct device *dev = &mfc_dev->plat_dev->dev;
 
 	exynos_unconfigure_iommu(dev);
+	dma_free_coherent(dev, mfc_dev->mem_size, mfc_dev->mem_virt,
+			  mfc_dev->mem_base);
+	kfree(mfc_dev->mem_bitmap);
 	vb2_dma_contig_clear_max_seg_size(dev);
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index cea17a737ef7..e64dc6e3c75e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -315,6 +315,10 @@ struct s5p_mfc_dev {
 	unsigned int int_err;
 	wait_queue_head_t queue;
 	struct s5p_mfc_priv_buf fw_buf;
+	size_t mem_size;
+	dma_addr_t mem_base;
+	unsigned long *mem_bitmap;
+	void *mem_virt;
 	dma_addr_t dma_base[BANK_CTX_NUM];
 	unsigned long hw_lock;
 	struct s5p_mfc_ctx *ctx[MFC_NUM_CONTEXTS];
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index 9294ee124661..34a66189d980 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -40,41 +40,60 @@ void s5p_mfc_init_regs(struct s5p_mfc_dev *dev)
 int s5p_mfc_alloc_priv_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
 			   struct s5p_mfc_priv_buf *b)
 {
-	struct device *mem_dev = dev->mem_dev[mem_ctx];
-	dma_addr_t base = dev->dma_base[mem_ctx];
+	unsigned int bits = dev->mem_size >> PAGE_SHIFT;
+	unsigned int count = b->size >> PAGE_SHIFT;
+	unsigned int align = (SZ_64K >> PAGE_SHIFT) - 1;
+	unsigned int start, offset;
 
 	mfc_debug(3, "Allocating priv: %zu\n", b->size);
 
-	b->ctx = mem_ctx;
-	b->virt = dma_alloc_coherent(mem_dev, b->size, &b->dma, GFP_KERNEL);
+	if (dev->mem_virt) {
+		start = bitmap_find_next_zero_area(dev->mem_bitmap, bits, 0, count, align);
+		if (start > bits)
+			goto no_mem;
 
-	if (!b->virt) {
-		mfc_err("Allocating private buffer of size %zu failed\n",
-			b->size);
-		return -ENOMEM;
-	}
+		bitmap_set(dev->mem_bitmap, start, count);
+		offset = start << PAGE_SHIFT;
+		b->virt = dev->mem_virt + offset;
+		b->dma = dev->mem_base + offset;
+	} else {
+		struct device *mem_dev = dev->mem_dev[mem_ctx];
+		dma_addr_t base = dev->dma_base[mem_ctx];
 
-	if (b->dma < base) {
-		mfc_err("Invalid memory configuration - buffer (%pad) is below base memory address(%pad)\n",
-			&b->dma, &base);
-		dma_free_coherent(mem_dev, b->size, b->virt, b->dma);
-		return -ENOMEM;
+		b->ctx = mem_ctx;
+		b->virt = dma_alloc_coherent(mem_dev, b->size, &b->dma, GFP_KERNEL);
+		if (!b->virt)
+			goto no_mem;
+		if (b->dma < base) {
+			mfc_err("Invalid memory configuration - buffer (%pad) is below base memory address(%pad)\n",
+				&b->dma, &base);
+			dma_free_coherent(mem_dev, b->size, b->virt, b->dma);
+			return -ENOMEM;
+		}
 	}
 
 	mfc_debug(3, "Allocated addr %p %pad\n", b->virt, &b->dma);
 	return 0;
+no_mem:
+	mfc_err("Allocating private buffer of size %zu failed\n", b->size);
+	return -ENOMEM;
 }
 
 void s5p_mfc_release_priv_buf(struct s5p_mfc_dev *dev,
 			      struct s5p_mfc_priv_buf *b)
 {
-	struct device *mem_dev = dev->mem_dev[b->ctx];
+	if (dev->mem_virt) {
+		unsigned int start = (b->dma - dev->mem_base) >> PAGE_SHIFT;
+		unsigned int count = b->size >> PAGE_SHIFT;
+
+		bitmap_clear(dev->mem_bitmap, start, count);
+	} else {
+		struct device *mem_dev = dev->mem_dev[b->ctx];
 
-	if (b->virt) {
 		dma_free_coherent(mem_dev, b->size, b->virt, b->dma);
-		b->virt = NULL;
-		b->dma = 0;
-		b->size = 0;
 	}
+	b->virt = NULL;
+	b->dma = 0;
+	b->size = 0;
 }
 
-- 
1.9.1
