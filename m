Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60912 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1L2Mjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 07:39:31 -0500
Date: Thu, 29 Dec 2011 13:39:11 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 10/11] ARM: integrate CMA with DMA-mapping subsystem
In-reply-to: <1325162352-24709-1-git-send-email-m.szyprowski@samsung.com>
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
	Shariq Hasnain <shariq.hasnain@linaro.org>,
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Message-id: <1325162352-24709-11-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1325162352-24709-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for CMA to dma-mapping subsystem for ARM
architecture. By default a global CMA area is used, but specific devices
are allowed to have their private memory areas if required (they can be
created with dma_declare_contiguous() function during board
initialization).

Contiguous memory areas reserved for DMA are remapped with 2-level page
tables on boot. Once a buffer is requested, a low memory kernel mapping
is updated to to match requested memory access type.

GFP_ATOMIC allocations are performed from special pool which is created
early during boot. This way remapping page attributes is not needed on
allocation time.

CMA has been enabled unconditionally for ARMv6+ systems.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
---
 Documentation/kernel-parameters.txt   |    4 +
 arch/arm/Kconfig                      |    2 +
 arch/arm/include/asm/dma-contiguous.h |   16 ++
 arch/arm/include/asm/mach/map.h       |    1 +
 arch/arm/kernel/setup.c               |    9 +-
 arch/arm/mm/dma-mapping.c             |  368 +++++++++++++++++++++++++++------
 arch/arm/mm/init.c                    |   22 ++-
 arch/arm/mm/mm.h                      |    3 +
 arch/arm/mm/mmu.c                     |   29 ++-
 9 files changed, 367 insertions(+), 87 deletions(-)
 create mode 100644 arch/arm/include/asm/dma-contiguous.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 0a56fd7..c8993cd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -515,6 +515,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			a hypervisor.
 			Default: yes
 
+	coherent_pool=nn[KMG]	[ARM,KNL]
+			Sets the size of memory pool for coherent, atomic dma
+			allocations if Contiguous Memory Allocator (CMA) is used.
+
 	code_bytes	[X86] How many bytes of object code to print
 			in an oops report.
 			Range: 0 - 8192
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 776d76b..2cc4bba 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -4,6 +4,8 @@ config ARM
 	select HAVE_AOUT
 	select HAVE_DMA_API_DEBUG
 	select HAVE_IDE if PCI || ISA || PCMCIA
+	select HAVE_DMA_CONTIGUOUS if (CPU_V6 || CPU_V6K || CPU_V7)
+	select CMA if (CPU_V6 || CPU_V6K || CPU_V7)
 	select HAVE_MEMBLOCK
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
diff --git a/arch/arm/include/asm/dma-contiguous.h b/arch/arm/include/asm/dma-contiguous.h
new file mode 100644
index 0000000..c7ba05e
--- /dev/null
+++ b/arch/arm/include/asm/dma-contiguous.h
@@ -0,0 +1,16 @@
+#ifndef ASMARM_DMA_CONTIGUOUS_H
+#define ASMARM_DMA_CONTIGUOUS_H
+
+#ifdef __KERNEL__
+
+#include <linux/device.h>
+#include <linux/dma-contiguous.h>
+#include <asm-generic/dma-contiguous.h>
+
+#ifdef CONFIG_CMA
+
+void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
+
+#endif
+#endif
+#endif
diff --git a/arch/arm/include/asm/mach/map.h b/arch/arm/include/asm/mach/map.h
index b36f365..a6efcdd 100644
--- a/arch/arm/include/asm/mach/map.h
+++ b/arch/arm/include/asm/mach/map.h
@@ -30,6 +30,7 @@ struct map_desc {
 #define MT_MEMORY_DTCM		12
 #define MT_MEMORY_ITCM		13
 #define MT_MEMORY_SO		14
+#define MT_MEMORY_DMA_READY	15
 
 #ifdef CONFIG_MMU
 extern void iotable_init(struct map_desc *, int);
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 8fc2c8f..9d5bc82f 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -78,6 +78,7 @@ __setup("fpe=", fpe_setup);
 extern void paging_init(struct machine_desc *desc);
 extern void sanity_check_meminfo(void);
 extern void reboot_setup(char *str);
+extern void setup_dma_zone(struct machine_desc *desc);
 
 unsigned int processor_id;
 EXPORT_SYMBOL(processor_id);
@@ -902,12 +903,8 @@ void __init setup_arch(char **cmdline_p)
 	machine_desc = mdesc;
 	machine_name = mdesc->name;
 
-#ifdef CONFIG_ZONE_DMA
-	if (mdesc->dma_zone_size) {
-		extern unsigned long arm_dma_zone_size;
-		arm_dma_zone_size = mdesc->dma_zone_size;
-	}
-#endif
+	setup_dma_zone(mdesc);
+
 	if (mdesc->soft_reboot)
 		reboot_setup("s");
 
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 1aa664a..77e7755 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -17,7 +17,9 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/dma-contiguous.h>
 #include <linux/highmem.h>
+#include <linux/memblock.h>
 #include <linux/slab.h>
 
 #include <asm/memory.h>
@@ -26,6 +28,8 @@
 #include <asm/tlbflush.h>
 #include <asm/sizes.h>
 #include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/dma-contiguous.h>
 
 #include "mm.h"
 
@@ -56,6 +60,19 @@ static u64 get_coherent_dma_mask(struct device *dev)
 	return mask;
 }
 
+static void __dma_clear_buffer(struct page *page, size_t size)
+{
+	void *ptr;
+	/*
+	 * Ensure that the allocated pages are zeroed, and that any data
+	 * lurking in the kernel direct-mapped region is invalidated.
+	 */
+	ptr = page_address(page);
+	memset(ptr, 0, size);
+	dmac_flush_range(ptr, ptr + size);
+	outer_flush_range(__pa(ptr), __pa(ptr) + size);
+}
+
 /*
  * Allocate a DMA buffer for 'dev' of size 'size' using the
  * specified gfp mask.  Note that 'size' must be page aligned.
@@ -64,23 +81,6 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
 {
 	unsigned long order = get_order(size);
 	struct page *page, *p, *e;
-	void *ptr;
-	u64 mask = get_coherent_dma_mask(dev);
-
-#ifdef CONFIG_DMA_API_DEBUG
-	u64 limit = (mask + 1) & ~mask;
-	if (limit && size >= limit) {
-		dev_warn(dev, "coherent allocation too big (requested %#x mask %#llx)\n",
-			size, mask);
-		return NULL;
-	}
-#endif
-
-	if (!mask)
-		return NULL;
-
-	if (mask < 0xffffffffULL)
-		gfp |= GFP_DMA;
 
 	page = alloc_pages(gfp, order);
 	if (!page)
@@ -93,14 +93,7 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
 	for (p = page + (size >> PAGE_SHIFT), e = page + (1 << order); p < e; p++)
 		__free_page(p);
 
-	/*
-	 * Ensure that the allocated pages are zeroed, and that any data
-	 * lurking in the kernel direct-mapped region is invalidated.
-	 */
-	ptr = page_address(page);
-	memset(ptr, 0, size);
-	dmac_flush_range(ptr, ptr + size);
-	outer_flush_range(__pa(ptr), __pa(ptr) + size);
+	__dma_clear_buffer(page, size);
 
 	return page;
 }
@@ -170,6 +163,9 @@ static int __init consistent_init(void)
 	unsigned long base = consistent_base;
 	unsigned long num_ptes = (CONSISTENT_END - base) >> PMD_SHIFT;
 
+	if (cpu_architecture() >= CPU_ARCH_ARMv6)
+		return 0;
+
 	consistent_pte = kmalloc(num_ptes * sizeof(pte_t), GFP_KERNEL);
 	if (!consistent_pte) {
 		pr_err("%s: no memory\n", __func__);
@@ -210,9 +206,101 @@ static int __init consistent_init(void)
 
 	return ret;
 }
-
 core_initcall(consistent_init);
 
+static void *__alloc_from_contiguous(struct device *dev, size_t size,
+				     pgprot_t prot, struct page **ret_page);
+
+static struct arm_vmregion_head coherent_head = {
+	.vm_lock	= __SPIN_LOCK_UNLOCKED(&coherent_head.vm_lock),
+	.vm_list	= LIST_HEAD_INIT(coherent_head.vm_list),
+};
+
+size_t coherent_pool_size = DEFAULT_CONSISTENT_DMA_SIZE / 8;
+
+static int __init early_coherent_pool(char *p)
+{
+	coherent_pool_size = memparse(p, &p);
+	return 0;
+}
+early_param("coherent_pool", early_coherent_pool);
+
+/*
+ * Initialise the coherent pool for atomic allocations.
+ */
+static int __init coherent_init(void)
+{
+	pgprot_t prot = pgprot_dmacoherent(pgprot_kernel);
+	size_t size = coherent_pool_size;
+	struct page *page;
+	void *ptr;
+
+	if (cpu_architecture() < CPU_ARCH_ARMv6)
+		return 0;
+
+	ptr = __alloc_from_contiguous(NULL, size, prot, &page);
+	if (ptr) {
+		coherent_head.vm_start = (unsigned long) ptr;
+		coherent_head.vm_end = (unsigned long) ptr + size;
+		printk(KERN_INFO "DMA: preallocated %u KiB pool for atomic coherent allocations\n",
+		       (unsigned)size / 1024);
+		return 0;
+	}
+	printk(KERN_ERR "DMA: failed to allocate %u KiB pool for atomic coherent allocation\n",
+	       (unsigned)size / 1024);
+	return -ENOMEM;
+}
+/*
+ * CMA is activated by core_initcall, so we must be called after it
+ */
+postcore_initcall(coherent_init);
+
+struct dma_contig_early_reserve {
+	phys_addr_t base;
+	unsigned long size;
+};
+
+static struct dma_contig_early_reserve dma_mmu_remap[MAX_CMA_AREAS] __initdata;
+
+static int dma_mmu_remap_num __initdata;
+
+void __init dma_contiguous_early_fixup(phys_addr_t base, unsigned long size)
+{
+	dma_mmu_remap[dma_mmu_remap_num].base = base;
+	dma_mmu_remap[dma_mmu_remap_num].size = size;
+	dma_mmu_remap_num++;
+}
+
+void __init dma_contiguous_remap(void)
+{
+	int i;
+	for (i = 0; i < dma_mmu_remap_num; i++) {
+		phys_addr_t start = dma_mmu_remap[i].base;
+		phys_addr_t end = start + dma_mmu_remap[i].size;
+		struct map_desc map;
+		unsigned long addr;
+
+		if (end > arm_lowmem_limit)
+			end = arm_lowmem_limit;
+		if (start >= end)
+			return;
+
+		map.pfn = __phys_to_pfn(start);
+		map.virtual = __phys_to_virt(start);
+		map.length = end - start;
+		map.type = MT_MEMORY_DMA_READY;
+
+		/*
+		 * Clear previous low-memory mapping
+		 */
+		for (addr = __phys_to_virt(start); addr < __phys_to_virt(end);
+		     addr += PGDIR_SIZE)
+			pmd_clear(pmd_off_k(addr));
+
+		iotable_init(&map, 1);
+	}
+}
+
 static void *
 __dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot)
 {
@@ -318,20 +406,172 @@ static void __dma_free_remap(void *cpu_addr, size_t size)
 	arm_vmregion_free(&consistent_head, c);
 }
 
+static int __dma_update_pte(pte_t *pte, pgtable_t token, unsigned long addr,
+			    void *data)
+{
+	struct page *page = virt_to_page(addr);
+	pgprot_t prot = *(pgprot_t *)data;
+
+	set_pte_ext(pte, mk_pte(page, prot), 0);
+	return 0;
+}
+
+static void __dma_remap(struct page *page, size_t size, pgprot_t prot)
+{
+	unsigned long start = (unsigned long) page_address(page);
+	unsigned end = start + size;
+
+	apply_to_page_range(&init_mm, start, size, __dma_update_pte, &prot);
+	dsb();
+	flush_tlb_kernel_range(start, end);
+}
+
+static void *__alloc_remap_buffer(struct device *dev, size_t size, gfp_t gfp,
+				 pgprot_t prot, struct page **ret_page)
+{
+	struct page *page;
+	void *ptr;
+	page = __dma_alloc_buffer(dev, size, gfp);
+	if (!page)
+		return NULL;
+
+	ptr = __dma_alloc_remap(page, size, gfp, prot);
+	if (!ptr) {
+		__dma_free_buffer(page, size);
+		return NULL;
+	}
+
+	*ret_page = page;
+	return ptr;
+}
+
+static void *__alloc_from_pool(struct device *dev, size_t size,
+			       struct page **ret_page)
+{
+	struct arm_vmregion *c;
+	size_t align;
+
+	if (!coherent_head.vm_start) {
+		printk(KERN_ERR "%s: coherent pool not initialised!\n",
+		       __func__);
+		dump_stack();
+		return NULL;
+	}
+
+	/*
+	 * Align the region allocation - allocations from pool are rather
+	 * small, so align them to their order in pages, minimum is a page
+	 * size. This helps reduce fragmentation of the DMA space.
+	 */
+	align = PAGE_SIZE << get_order(size);
+	c = arm_vmregion_alloc(&coherent_head, align, size, 0);
+	if (c) {
+		void *ptr = (void *)c->vm_start;
+		struct page *page = virt_to_page(ptr);
+		*ret_page = page;
+		return ptr;
+	}
+	return NULL;
+}
+
+static int __free_from_pool(void *cpu_addr, size_t size)
+{
+	unsigned long start = (unsigned long)cpu_addr;
+	unsigned long end = start + size;
+	struct arm_vmregion *c;
+
+	if (start < coherent_head.vm_start || end > coherent_head.vm_end)
+		return 0;
+
+	c = arm_vmregion_find_remove(&coherent_head, (unsigned long)start);
+
+	if ((c->vm_end - c->vm_start) != size) {
+		printk(KERN_ERR "%s: freeing wrong coherent size (%ld != %d)\n",
+		       __func__, c->vm_end - c->vm_start, size);
+		dump_stack();
+		size = c->vm_end - c->vm_start;
+	}
+
+	arm_vmregion_free(&coherent_head, c);
+	return 1;
+}
+
+static void *__alloc_from_contiguous(struct device *dev, size_t size,
+				     pgprot_t prot, struct page **ret_page)
+{
+	unsigned long order = get_order(size);
+	size_t count = size >> PAGE_SHIFT;
+	struct page *page;
+
+	page = dma_alloc_from_contiguous(dev, count, order);
+	if (!page)
+		return NULL;
+
+	__dma_clear_buffer(page, size);
+	__dma_remap(page, size, prot);
+
+	*ret_page = page;
+	return page_address(page);
+}
+
+static void __free_from_contiguous(struct device *dev, struct page *page,
+				   size_t size)
+{
+	__dma_remap(page, size, pgprot_kernel);
+	dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT);
+}
+
+#define nommu() 0
+
 #else	/* !CONFIG_MMU */
 
-#define __dma_alloc_remap(page, size, gfp, prot)	page_address(page)
-#define __dma_free_remap(addr, size)			do { } while (0)
+#define nommu() 1
+
+#define __alloc_remap_buffer(dev, size, gfp, prot, ret)	NULL
+#define __alloc_from_pool(dev, size, ret_page)		NULL
+#define __alloc_from_contiguous(dev, size, prot, ret)	NULL
+#define __free_from_pool(cpu_addr, size)		0
+#define __free_from_contiguous(dev, page, size)		do { } while (0)
+#define __dma_free_remap(cpu_addr, size)		do { } while (0)
 
 #endif	/* CONFIG_MMU */
 
-static void *
-__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
-	    pgprot_t prot)
+static void *__alloc_simple_buffer(struct device *dev, size_t size, gfp_t gfp,
+				   struct page **ret_page)
 {
 	struct page *page;
+	page = __dma_alloc_buffer(dev, size, gfp);
+	if (!page)
+		return NULL;
+
+	*ret_page = page;
+	return page_address(page);
+}
+
+
+
+static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
+			 gfp_t gfp, pgprot_t prot)
+{
+	u64 mask = get_coherent_dma_mask(dev);
+	struct page *page;
 	void *addr;
 
+#ifdef CONFIG_DMA_API_DEBUG
+	u64 limit = (mask + 1) & ~mask;
+	if (limit && size >= limit) {
+		dev_warn(dev, "coherent allocation too big (requested %#x mask %#llx)\n",
+			size, mask);
+		return NULL;
+	}
+#endif
+
+	if (!mask)
+		return NULL;
+
+	if (mask < 0xffffffffULL)
+		gfp |= GFP_DMA;
+
 	/*
 	 * Following is a work-around (a.k.a. hack) to prevent pages
 	 * with __GFP_COMP being passed to split_page() which cannot
@@ -344,19 +584,17 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
 	*handle = ~0;
 	size = PAGE_ALIGN(size);
 
-	page = __dma_alloc_buffer(dev, size, gfp);
-	if (!page)
-		return NULL;
-
-	if (!arch_is_coherent())
-		addr = __dma_alloc_remap(page, size, gfp, prot);
+	if (arch_is_coherent() || nommu())
+		addr = __alloc_simple_buffer(dev, size, gfp, &page);
+	else if (cpu_architecture() < CPU_ARCH_ARMv6)
+		addr = __alloc_remap_buffer(dev, size, gfp, prot, &page);
+	else if (gfp & GFP_ATOMIC)
+		addr = __alloc_from_pool(dev, size, &page);
 	else
-		addr = page_address(page);
+		addr = __alloc_from_contiguous(dev, size, prot, &page);
 
 	if (addr)
 		*handle = pfn_to_dma(dev, page_to_pfn(page));
-	else
-		__dma_free_buffer(page, size);
 
 	return addr;
 }
@@ -365,8 +603,8 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
  * Allocate DMA-coherent memory space and return both the kernel remapped
  * virtual and bus address for that space.
  */
-void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp)
+void *dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle,
+			 gfp_t gfp)
 {
 	void *memory;
 
@@ -395,25 +633,11 @@ static int dma_mmap(struct device *dev, struct vm_area_struct *vma,
 {
 	int ret = -ENXIO;
 #ifdef CONFIG_MMU
-	unsigned long user_size, kern_size;
-	struct arm_vmregion *c;
-
-	user_size = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-
-	c = arm_vmregion_find(&consistent_head, (unsigned long)cpu_addr);
-	if (c) {
-		unsigned long off = vma->vm_pgoff;
-
-		kern_size = (c->vm_end - c->vm_start) >> PAGE_SHIFT;
-
-		if (off < kern_size &&
-		    user_size <= (kern_size - off)) {
-			ret = remap_pfn_range(vma, vma->vm_start,
-					      page_to_pfn(c->vm_pages) + off,
-					      user_size << PAGE_SHIFT,
-					      vma->vm_page_prot);
-		}
-	}
+	unsigned long pfn = dma_to_pfn(dev, dma_addr);
+	ret = remap_pfn_range(vma, vma->vm_start,
+			      pfn + vma->vm_pgoff,
+			      vma->vm_end - vma->vm_start,
+			      vma->vm_page_prot);
 #endif	/* CONFIG_MMU */
 
 	return ret;
@@ -435,23 +659,33 @@ int dma_mmap_writecombine(struct device *dev, struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL(dma_mmap_writecombine);
 
+
 /*
- * free a page as defined by the above mapping.
- * Must not be called with IRQs disabled.
+ * Free a buffer as defined by the above mapping.
  */
 void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr_t handle)
 {
-	WARN_ON(irqs_disabled());
+	struct page *page = pfn_to_page(dma_to_pfn(dev, handle));
 
 	if (dma_release_from_coherent(dev, get_order(size), cpu_addr))
 		return;
 
 	size = PAGE_ALIGN(size);
 
-	if (!arch_is_coherent())
+	if (arch_is_coherent() || nommu()) {
+		__dma_free_buffer(page, size);
+	} else if (cpu_architecture() < CPU_ARCH_ARMv6) {
 		__dma_free_remap(cpu_addr, size);
-
-	__dma_free_buffer(pfn_to_page(dma_to_pfn(dev, handle)), size);
+		__dma_free_buffer(page, size);
+	} else {
+		if (__free_from_pool(cpu_addr, size))
+			return;
+		/*
+		 * Non-atomic allocations cannot be freed with IRQs disabled
+		 */
+		WARN_ON(irqs_disabled());
+		__free_from_contiguous(dev, page, size);
+	}
 }
 EXPORT_SYMBOL(dma_free_coherent);
 
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index fbdd12e..dd0a1e4 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -21,6 +21,7 @@
 #include <linux/gfp.h>
 #include <linux/memblock.h>
 #include <linux/sort.h>
+#include <linux/dma-contiguous.h>
 
 #include <asm/mach-types.h>
 #include <asm/prom.h>
@@ -238,6 +239,17 @@ static void __init arm_adjust_dma_zone(unsigned long *size, unsigned long *hole,
 }
 #endif
 
+void __init setup_dma_zone(struct machine_desc *mdesc)
+{
+#ifdef CONFIG_ZONE_DMA
+	if (mdesc->dma_zone_size) {
+		arm_dma_zone_size = mdesc->dma_zone_size;
+		arm_dma_limit = PHYS_OFFSET + arm_dma_zone_size - 1;
+	} else
+		arm_dma_limit = 0xffffffff;
+#endif
+}
+
 static void __init arm_bootmem_free(unsigned long min, unsigned long max_low,
 	unsigned long max_high)
 {
@@ -285,12 +297,9 @@ static void __init arm_bootmem_free(unsigned long min, unsigned long max_low,
 	 * Adjust the sizes according to any special requirements for
 	 * this machine type.
 	 */
-	if (arm_dma_zone_size) {
+	if (arm_dma_zone_size)
 		arm_adjust_dma_zone(zone_size, zhole_size,
 			arm_dma_zone_size >> PAGE_SHIFT);
-		arm_dma_limit = PHYS_OFFSET + arm_dma_zone_size - 1;
-	} else
-		arm_dma_limit = 0xffffffff;
 #endif
 
 	free_area_init_node(0, zone_size, min, zhole_size);
@@ -371,6 +380,11 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 	if (mdesc->reserve)
 		mdesc->reserve();
 
+	/* reserve memory for DMA contigouos allocations,
+	   must come from DMA area inside low memory */
+	dma_contiguous_reserve(arm_dma_limit < arm_lowmem_limit ?
+			       arm_dma_limit : arm_lowmem_limit);
+
 	memblock_analyze();
 	memblock_dump_all();
 }
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index ad7cce3..fa95d9b 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -29,5 +29,8 @@ extern u32 arm_dma_limit;
 #define arm_dma_limit ((u32)~0)
 #endif
 
+extern phys_addr_t arm_lowmem_limit;
+
 void __init bootmem_init(void);
 void arm_mm_memblock_reserve(void);
+void dma_contiguous_remap(void);
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index dc8c550..9796cf1 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -281,6 +281,11 @@ static struct mem_type mem_types[] = {
 				PMD_SECT_UNCACHED | PMD_SECT_XN,
 		.domain    = DOMAIN_KERNEL,
 	},
+	[MT_MEMORY_DMA_READY] = {
+		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY,
+		.prot_l1   = PMD_TYPE_TABLE,
+		.domain    = DOMAIN_KERNEL,
+	},
 };
 
 const struct mem_type *get_mem_type(unsigned int type)
@@ -422,6 +427,7 @@ static void __init build_mem_type_table(void)
 	if (arch_is_coherent() && cpu_is_xsc3()) {
 		mem_types[MT_MEMORY].prot_sect |= PMD_SECT_S;
 		mem_types[MT_MEMORY].prot_pte |= L_PTE_SHARED;
+		mem_types[MT_MEMORY_DMA_READY].prot_pte |= L_PTE_SHARED;
 		mem_types[MT_MEMORY_NONCACHED].prot_sect |= PMD_SECT_S;
 		mem_types[MT_MEMORY_NONCACHED].prot_pte |= L_PTE_SHARED;
 	}
@@ -451,6 +457,7 @@ static void __init build_mem_type_table(void)
 			mem_types[MT_DEVICE_CACHED].prot_pte |= L_PTE_SHARED;
 			mem_types[MT_MEMORY].prot_sect |= PMD_SECT_S;
 			mem_types[MT_MEMORY].prot_pte |= L_PTE_SHARED;
+			mem_types[MT_MEMORY_DMA_READY].prot_pte |= L_PTE_SHARED;
 			mem_types[MT_MEMORY_NONCACHED].prot_sect |= PMD_SECT_S;
 			mem_types[MT_MEMORY_NONCACHED].prot_pte |= L_PTE_SHARED;
 		}
@@ -490,6 +497,7 @@ static void __init build_mem_type_table(void)
 	mem_types[MT_HIGH_VECTORS].prot_l1 |= ecc_mask;
 	mem_types[MT_MEMORY].prot_sect |= ecc_mask | cp->pmd;
 	mem_types[MT_MEMORY].prot_pte |= kern_pgprot;
+	mem_types[MT_MEMORY_DMA_READY].prot_pte |= kern_pgprot;
 	mem_types[MT_MEMORY_NONCACHED].prot_sect |= ecc_mask;
 	mem_types[MT_ROM].prot_sect |= cp->pmd;
 
@@ -569,7 +577,7 @@ static void __init alloc_init_section(pud_t *pud, unsigned long addr,
 	 * L1 entries, whereas PGDs refer to a group of L1 entries making
 	 * up one logical pointer to an L2 table.
 	 */
-	if (((addr | end | phys) & ~SECTION_MASK) == 0) {
+	if (type->prot_sect && ((addr | end | phys) & ~SECTION_MASK) == 0) {
 		pmd_t *p = pmd;
 
 		if (addr & SECTION_SIZE)
@@ -765,7 +773,7 @@ static int __init early_vmalloc(char *arg)
 }
 early_param("vmalloc", early_vmalloc);
 
-static phys_addr_t lowmem_limit __initdata = 0;
+phys_addr_t arm_lowmem_limit __initdata = 0;
 
 void __init sanity_check_meminfo(void)
 {
@@ -834,8 +842,8 @@ void __init sanity_check_meminfo(void)
 			bank->size = newsize;
 		}
 #endif
-		if (!bank->highmem && bank->start + bank->size > lowmem_limit)
-			lowmem_limit = bank->start + bank->size;
+		if (!bank->highmem && bank->start + bank->size > arm_lowmem_limit)
+			arm_lowmem_limit = bank->start + bank->size;
 
 		j++;
 	}
@@ -860,7 +868,7 @@ void __init sanity_check_meminfo(void)
 	}
 #endif
 	meminfo.nr_banks = j;
-	memblock_set_current_limit(lowmem_limit);
+	memblock_set_current_limit(arm_lowmem_limit);
 }
 
 static inline void prepare_page_table(void)
@@ -885,8 +893,8 @@ static inline void prepare_page_table(void)
 	 * Find the end of the first block of lowmem.
 	 */
 	end = memblock.memory.regions[0].base + memblock.memory.regions[0].size;
-	if (end >= lowmem_limit)
-		end = lowmem_limit;
+	if (end >= arm_lowmem_limit)
+		end = arm_lowmem_limit;
 
 	/*
 	 * Clear out all the kernel space mappings, except for the first
@@ -1020,8 +1028,8 @@ static void __init map_lowmem(void)
 		phys_addr_t end = start + reg->size;
 		struct map_desc map;
 
-		if (end > lowmem_limit)
-			end = lowmem_limit;
+		if (end > arm_lowmem_limit)
+			end = arm_lowmem_limit;
 		if (start >= end)
 			break;
 
@@ -1042,11 +1050,12 @@ void __init paging_init(struct machine_desc *mdesc)
 {
 	void *zero_page;
 
-	memblock_set_current_limit(lowmem_limit);
+	memblock_set_current_limit(arm_lowmem_limit);
 
 	build_mem_type_table();
 	prepare_page_table();
 	map_lowmem();
+	dma_contiguous_remap();
 	devicemaps_init(mdesc);
 	kmap_init();
 
-- 
1.7.1.569.g6f426

