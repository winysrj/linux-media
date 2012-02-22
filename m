Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55254 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab2BVQtN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 11:49:13 -0500
Date: Wed, 22 Feb 2012 17:48:55 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv23 14/16] X86: integrate CMA with DMA-mapping subsystem
In-reply-to: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Message-id: <1329929337-16648-15-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for CMA to dma-mapping subsystem for x86
architecture that uses common pci-dma/pci-nommu implementation. This
allows to test CMA on KVM/QEMU and a lot of common x86 boxes.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/dma-contiguous.h |   13 +++++++++++++
 arch/x86/include/asm/dma-mapping.h    |    4 ++++
 arch/x86/kernel/pci-dma.c             |   18 ++++++++++++++++--
 arch/x86/kernel/pci-nommu.c           |    8 +-------
 arch/x86/kernel/setup.c               |    2 ++
 6 files changed, 37 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/include/asm/dma-contiguous.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a61db6d..fea7f3a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -31,6 +31,7 @@ config X86
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
+	select HAVE_DMA_CONTIGUOUS if !SWIOTLB
 	select HAVE_KRETPROBES
 	select HAVE_OPTPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/x86/include/asm/dma-contiguous.h b/arch/x86/include/asm/dma-contiguous.h
new file mode 100644
index 0000000..c092416
--- /dev/null
+++ b/arch/x86/include/asm/dma-contiguous.h
@@ -0,0 +1,13 @@
+#ifndef ASMX86_DMA_CONTIGUOUS_H
+#define ASMX86_DMA_CONTIGUOUS_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <asm-generic/dma-contiguous.h>
+
+static inline void
+dma_contiguous_early_fixup(phys_addr_t base, unsigned long size) { }
+
+#endif
+#endif
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 4b4331d..8ca32d4 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -13,6 +13,7 @@
 #include <asm/io.h>
 #include <asm/swiotlb.h>
 #include <asm-generic/dma-coherent.h>
+#include <linux/dma-contiguous.h>
 
 #ifdef CONFIG_ISA
 # define ISA_DMA_BIT_MASK DMA_BIT_MASK(24)
@@ -62,6 +63,9 @@ extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
 					struct dma_attrs *attrs);
 
+extern void dma_generic_free_coherent(struct device *dev, size_t size,
+				      void *vaddr, dma_addr_t dma_addr);
+
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 75e1cc1..caba818 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -100,14 +100,18 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 struct dma_attrs *attrs)
 {
 	unsigned long dma_mask;
-	struct page *page;
+	struct page *page = NULL;
+	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	dma_addr_t addr;
 
 	dma_mask = dma_alloc_coherent_mask(dev, flag);
 
 	flag |= __GFP_ZERO;
 again:
-	page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
+	if (!(flag & GFP_ATOMIC))
+		page = dma_alloc_from_contiguous(dev, count, get_order(size));
+	if (!page)
+		page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
 	if (!page)
 		return NULL;
 
@@ -127,6 +131,16 @@ again:
 	return page_address(page);
 }
 
+void dma_generic_free_coherent(struct device *dev, size_t size, void *vaddr,
+			       dma_addr_t dma_addr, struct dma_attrs *attrs)
+{
+	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	struct page *page = virt_to_page(vaddr);
+
+	if (!dma_release_from_contiguous(dev, page, count))
+		free_pages((unsigned long)vaddr, get_order(size));
+}
+
 /*
  * See <Documentation/x86/x86_64/boot-options.txt> for the iommu kernel
  * parameter documentation.
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index f960506..871be4a 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -74,12 +74,6 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	return nents;
 }
 
-static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
-				dma_addr_t dma_addr, struct dma_attrs *attrs)
-{
-	free_pages((unsigned long)vaddr, get_order(size));
-}
-
 static void nommu_sync_single_for_device(struct device *dev,
 			dma_addr_t addr, size_t size,
 			enum dma_data_direction dir)
@@ -97,7 +91,7 @@ static void nommu_sync_sg_for_device(struct device *dev,
 
 struct dma_map_ops nommu_dma_ops = {
 	.alloc			= dma_generic_alloc_coherent,
-	.free			= nommu_free_coherent,
+	.free			= dma_generic_free_coherent,
 	.map_sg			= nommu_map_sg,
 	.map_page		= nommu_map_page,
 	.sync_single_for_device = nommu_sync_single_for_device,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e22bb08..d20ef5b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -50,6 +50,7 @@
 #include <asm/pci-direct.h>
 #include <linux/init_ohci1394_dma.h>
 #include <linux/kvm_para.h>
+#include <linux/dma-contiguous.h>
 
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -957,6 +958,7 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 	memblock.current_limit = get_max_mapped();
+	dma_contiguous_reserve(0);
 
 	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
-- 
1.7.1.569.g6f426

