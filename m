Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFC4C04EB8
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 539912082D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XMfu6/L0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 539912082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbeLHRla (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:41:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59742 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbeLHRl3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C9+f+sTZKVaaesLrcg+Cvm1V/YhZblchgVdOQkYRC2w=; b=XMfu6/L06ylsjt2lcONiN6fRPR
        0lW1iBvN4VEIYj3vmgeSjoDVMDkMAOYUJA0U1BDaNjFhTRJabs7x9HqFvUCkdl9dtimQMainbBFYf
        /tId001+UDoSKEI8XkrlHEb/ZOWC4ojs/hnCsbc2jCwV1dwLD6DIWUKzDax9Liv0IUmzSaTf98dud
        dwukQGYiVNFTbbCS7fqlRXzzWUZCRlaseVxnOAizzv0gGmTsybB0s3YGry/tmYdwUwNR5Qjf1eCk1
        BTmlT6LzPhswVbFGeF9ybv+jsbv4B+xVsCLyvUwGMVl8ls9Il/3KgrgPFMbDDNxWsEwbmDafuQ0YC
        IA0yxrsw==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgbN-0000Zt-W8; Sat, 08 Dec 2018 17:41:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     iommu@lists.linux-foundation.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH 3/6] sparc: remove the sparc32_dma_ops indirection
Date:   Sat,  8 Dec 2018 09:41:12 -0800
Message-Id: <20181208174115.16237-4-hch@lst.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181208174115.16237-1-hch@lst.de>
References: <20181208174115.16237-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is no good reason to have a double indirection for the sparc32
dma ops, so remove the sparc32_dma_ops and define separate dma_map_ops
instance for the different IOMMU types.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/sparc/include/asm/dma.h |  48 +-----------
 arch/sparc/kernel/ioport.c   | 124 +------------------------------
 arch/sparc/mm/io-unit.c      |  65 ++++++++++++-----
 arch/sparc/mm/iommu.c        | 137 ++++++++++++++++++++++-------------
 4 files changed, 138 insertions(+), 236 deletions(-)

diff --git a/arch/sparc/include/asm/dma.h b/arch/sparc/include/asm/dma.h
index a1d7c86917c6..462e7c794a09 100644
--- a/arch/sparc/include/asm/dma.h
+++ b/arch/sparc/include/asm/dma.h
@@ -91,54 +91,10 @@ extern int isa_dma_bridge_buggy;
 #endif
 
 #ifdef CONFIG_SPARC32
-
-/* Routines for data transfer buffers. */
 struct device;
-struct scatterlist;
-
-struct sparc32_dma_ops {
-	__u32 (*get_scsi_one)(struct device *, char *, unsigned long);
-	void (*get_scsi_sgl)(struct device *, struct scatterlist *, int);
-	void (*release_scsi_one)(struct device *, __u32, unsigned long);
-	void (*release_scsi_sgl)(struct device *, struct scatterlist *,int);
-#ifdef CONFIG_SBUS
-	int (*map_dma_area)(struct device *, dma_addr_t *, unsigned long, unsigned long, int);
-	void (*unmap_dma_area)(struct device *, unsigned long, int);
-#endif
-};
-extern const struct sparc32_dma_ops *sparc32_dma_ops;
-
-#define mmu_get_scsi_one(dev,vaddr,len) \
-	sparc32_dma_ops->get_scsi_one(dev, vaddr, len)
-#define mmu_get_scsi_sgl(dev,sg,sz) \
-	sparc32_dma_ops->get_scsi_sgl(dev, sg, sz)
-#define mmu_release_scsi_one(dev,vaddr,len) \
-	sparc32_dma_ops->release_scsi_one(dev, vaddr,len)
-#define mmu_release_scsi_sgl(dev,sg,sz) \
-	sparc32_dma_ops->release_scsi_sgl(dev, sg, sz)
-
-#ifdef CONFIG_SBUS
-/*
- * mmu_map/unmap are provided by iommu/iounit; Invalid to call on IIep.
- *
- * The mmu_map_dma_area establishes two mappings in one go.
- * These mappings point to pages normally mapped at 'va' (linear address).
- * First mapping is for CPU visible address at 'a', uncached.
- * This is an alias, but it works because it is an uncached mapping.
- * Second mapping is for device visible address, or "bus" address.
- * The bus address is returned at '*pba'.
- *
- * These functions seem distinct, but are hard to split.
- * On sun4m, page attributes depend on the CPU type, so we have to
- * know if we are mapping RAM or I/O, so it has to be an additional argument
- * to a separate mapping function for CPU visible mappings.
- */
-#define sbus_map_dma_area(dev,pba,va,a,len) \
-	sparc32_dma_ops->map_dma_area(dev, pba, va, a, len)
-#define sbus_unmap_dma_area(dev,ba,len) \
-	sparc32_dma_ops->unmap_dma_area(dev, ba, len)
-#endif /* CONFIG_SBUS */
 
+unsigned long sparc_dma_alloc_resource(struct device *dev, size_t len);
+bool sparc_dma_free_resource(void *cpu_addr, size_t size);
 #endif
 
 #endif /* !(_ASM_SPARC_DMA_H) */
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index fd7a41c6d688..f46213035637 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -52,8 +52,6 @@
 #include <asm/io-unit.h>
 #include <asm/leon.h>
 
-const struct sparc32_dma_ops *sparc32_dma_ops;
-
 /* This function must make sure that caches and memory are coherent after DMA
  * On LEON systems without cache snooping it flushes the entire D-CACHE.
  */
@@ -247,7 +245,7 @@ static void _sparc_free_io(struct resource *res)
 	release_resource(res);
 }
 
-static unsigned long sparc_dma_alloc_resource(struct device *dev, size_t len)
+unsigned long sparc_dma_alloc_resource(struct device *dev, size_t len)
 {
 	struct resource *res;
 
@@ -266,7 +264,7 @@ static unsigned long sparc_dma_alloc_resource(struct device *dev, size_t len)
 	return res->start;
 }
 
-static bool sparc_dma_free_resource(void *cpu_addr, size_t size)
+bool sparc_dma_free_resource(void *cpu_addr, size_t size)
 {
 	unsigned long addr = (unsigned long)cpu_addr;
 	struct resource *res;
@@ -302,122 +300,6 @@ void sbus_set_sbus64(struct device *dev, int x)
 }
 EXPORT_SYMBOL(sbus_set_sbus64);
 
-/*
- * Allocate a chunk of memory suitable for DMA.
- * Typically devices use them for control blocks.
- * CPU may access them without any explicit flushing.
- */
-static void *sbus_alloc_coherent(struct device *dev, size_t len,
-				 dma_addr_t *dma_addrp, gfp_t gfp,
-				 unsigned long attrs)
-{
-	unsigned long len_total = PAGE_ALIGN(len);
-	unsigned long va, addr;
-	int order;
-
-	/* XXX why are some lengths signed, others unsigned? */
-	if (len <= 0) {
-		return NULL;
-	}
-	/* XXX So what is maxphys for us and how do drivers know it? */
-	if (len > 256*1024) {			/* __get_free_pages() limit */
-		return NULL;
-	}
-
-	order = get_order(len_total);
-	va = __get_free_pages(gfp, order);
-	if (va == 0)
-		goto err_nopages;
-
-	addr = sparc_dma_alloc_resource(dev, len_total);
-	if (!addr)
-		goto err_nomem;
-
-	// XXX The sbus_map_dma_area does this for us below, see comments.
-	// srmmu_mapiorange(0, virt_to_phys(va), res->start, len_total);
-	/*
-	 * XXX That's where sdev would be used. Currently we load
-	 * all iommu tables with the same translations.
-	 */
-	if (sbus_map_dma_area(dev, dma_addrp, va, addr, len_total) != 0)
-		goto err_noiommu;
-
-	return (void *)addr;
-
-err_noiommu:
-	sparc_dma_free_resource((void *)addr, len_total);
-err_nomem:
-	free_pages(va, order);
-err_nopages:
-	return NULL;
-}
-
-static void sbus_free_coherent(struct device *dev, size_t n, void *p,
-			       dma_addr_t ba, unsigned long attrs)
-{
-	struct page *pgv;
-
-	n = PAGE_ALIGN(n);
-	if (!sparc_dma_free_resource(p, n))
-		return;
-
-	pgv = virt_to_page(p);
-	sbus_unmap_dma_area(dev, ba, n);
-
-	__free_pages(pgv, get_order(n));
-}
-
-/*
- * Map a chunk of memory so that devices can see it.
- * CPU view of this memory may be inconsistent with
- * a device view and explicit flushing is necessary.
- */
-static dma_addr_t sbus_map_page(struct device *dev, struct page *page,
-				unsigned long offset, size_t len,
-				enum dma_data_direction dir,
-				unsigned long attrs)
-{
-	void *va = page_address(page) + offset;
-
-	/* XXX why are some lengths signed, others unsigned? */
-	if (len <= 0) {
-		return 0;
-	}
-	/* XXX So what is maxphys for us and how do drivers know it? */
-	if (len > 256*1024) {			/* __get_free_pages() limit */
-		return 0;
-	}
-	return mmu_get_scsi_one(dev, va, len);
-}
-
-static void sbus_unmap_page(struct device *dev, dma_addr_t ba, size_t n,
-			    enum dma_data_direction dir, unsigned long attrs)
-{
-	mmu_release_scsi_one(dev, ba, n);
-}
-
-static int sbus_map_sg(struct device *dev, struct scatterlist *sg, int n,
-		       enum dma_data_direction dir, unsigned long attrs)
-{
-	mmu_get_scsi_sgl(dev, sg, n);
-	return n;
-}
-
-static void sbus_unmap_sg(struct device *dev, struct scatterlist *sg, int n,
-			  enum dma_data_direction dir, unsigned long attrs)
-{
-	mmu_release_scsi_sgl(dev, sg, n);
-}
-
-static const struct dma_map_ops sbus_dma_ops = {
-	.alloc			= sbus_alloc_coherent,
-	.free			= sbus_free_coherent,
-	.map_page		= sbus_map_page,
-	.unmap_page		= sbus_unmap_page,
-	.map_sg			= sbus_map_sg,
-	.unmap_sg		= sbus_unmap_sg,
-};
-
 static int __init sparc_register_ioport(void)
 {
 	register_proc_sparc_ioport();
@@ -491,7 +373,7 @@ void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
 		dma_make_coherent(paddr, PAGE_ALIGN(size));
 }
 
-const struct dma_map_ops *dma_ops = &sbus_dma_ops;
+const struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 #ifdef CONFIG_PROC_FS
diff --git a/arch/sparc/mm/io-unit.c b/arch/sparc/mm/io-unit.c
index c8cb27d3ea75..2088d292c6e5 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -12,7 +12,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>	/* pte_offset_map => kmap_atomic */
 #include <linux/bitops.h>
-#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 
@@ -140,18 +140,26 @@ nexti:	scan = find_next_zero_bit(iounit->bmap, limit, scan);
 	return vaddr;
 }
 
-static __u32 iounit_get_scsi_one(struct device *dev, char *vaddr, unsigned long len)
+static dma_addr_t iounit_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t len, enum dma_data_direction dir,
+		unsigned long attrs)
 {
+	void *vaddr = page_address(page) + offset;
 	struct iounit_struct *iounit = dev->archdata.iommu;
 	unsigned long ret, flags;
 	
+	/* XXX So what is maxphys for us and how do drivers know it? */
+	if (!len || len > 256 * 1024)
+		return DMA_MAPPING_ERROR;
+
 	spin_lock_irqsave(&iounit->lock, flags);
 	ret = iounit_get_area(iounit, (unsigned long)vaddr, len);
 	spin_unlock_irqrestore(&iounit->lock, flags);
 	return ret;
 }
 
-static void iounit_get_scsi_sgl(struct device *dev, struct scatterlist *sg, int sz)
+static int iounit_map_sg(struct device *dev, struct scatterlist *sg, int sz,
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	struct iounit_struct *iounit = dev->archdata.iommu;
 	unsigned long flags;
@@ -165,9 +173,11 @@ static void iounit_get_scsi_sgl(struct device *dev, struct scatterlist *sg, int
 		sg = sg_next(sg);
 	}
 	spin_unlock_irqrestore(&iounit->lock, flags);
+	return sz;
 }
 
-static void iounit_release_scsi_one(struct device *dev, __u32 vaddr, unsigned long len)
+static void iounit_unmap_page(struct device *dev, dma_addr_t vaddr, size_t len,
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	struct iounit_struct *iounit = dev->archdata.iommu;
 	unsigned long flags;
@@ -181,7 +191,8 @@ static void iounit_release_scsi_one(struct device *dev, __u32 vaddr, unsigned lo
 	spin_unlock_irqrestore(&iounit->lock, flags);
 }
 
-static void iounit_release_scsi_sgl(struct device *dev, struct scatterlist *sg, int sz)
+static void iounit_unmap_sg(struct device *dev, struct scatterlist *sg, int sz,
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	struct iounit_struct *iounit = dev->archdata.iommu;
 	unsigned long flags;
@@ -201,14 +212,27 @@ static void iounit_release_scsi_sgl(struct device *dev, struct scatterlist *sg,
 }
 
 #ifdef CONFIG_SBUS
-static int iounit_map_dma_area(struct device *dev, dma_addr_t *pba, unsigned long va, unsigned long addr, int len)
+static void *iounit_alloc(struct device *dev, size_t len,
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	struct iounit_struct *iounit = dev->archdata.iommu;
-	unsigned long page, end;
+	unsigned long va, addr, page, end, ret;
 	pgprot_t dvma_prot;
 	iopte_t __iomem *iopte;
 
-	*pba = addr;
+	/* XXX So what is maxphys for us and how do drivers know it? */
+	if (!len || len > 256 * 1024)
+		return NULL;
+
+	len = PAGE_ALIGN(len);
+	va = __get_free_pages(gfp, get_order(len));
+	if (!va)
+		return NULL;
+
+	addr = ret = sparc_dma_alloc_resource(dev, len);
+	if (!addr)
+		goto out_free_pages;
+	*dma_handle = addr;
 
 	dvma_prot = __pgprot(SRMMU_CACHE | SRMMU_ET_PTE | SRMMU_PRIV);
 	end = PAGE_ALIGN((addr + len));
@@ -237,27 +261,32 @@ static int iounit_map_dma_area(struct device *dev, dma_addr_t *pba, unsigned lon
 	flush_cache_all();
 	flush_tlb_all();
 
-	return 0;
+	return (void *)ret;
+
+out_free_pages:
+	free_pages(va, get_order(len));
+	return NULL;
 }
 
-static void iounit_unmap_dma_area(struct device *dev, unsigned long addr, int len)
+static void iounit_free(struct device *dev, size_t size, void *cpu_addr,
+		dma_addr_t dma_addr, unsigned long attrs)
 {
 	/* XXX Somebody please fill this in */
 }
 #endif
 
-static const struct sparc32_dma_ops iounit_dma_ops = {
-	.get_scsi_one		= iounit_get_scsi_one,
-	.get_scsi_sgl		= iounit_get_scsi_sgl,
-	.release_scsi_one	= iounit_release_scsi_one,
-	.release_scsi_sgl	= iounit_release_scsi_sgl,
+static const struct dma_map_ops iounit_dma_ops = {
 #ifdef CONFIG_SBUS
-	.map_dma_area		= iounit_map_dma_area,
-	.unmap_dma_area		= iounit_unmap_dma_area,
+	.alloc			= iounit_alloc,
+	.free			= iounit_free,
 #endif
+	.map_page		= iounit_map_page,
+	.unmap_page		= iounit_unmap_page,
+	.map_sg			= iounit_map_sg,
+	.unmap_sg		= iounit_unmap_sg,
 };
 
 void __init ld_mmu_iounit(void)
 {
-	sparc32_dma_ops = &iounit_dma_ops;
+	dma_ops = &iounit_dma_ops;
 }
diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index 2c5f8a648f8c..3599485717e7 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -13,7 +13,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>	/* pte_offset_map => kmap_atomic */
-#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 
@@ -205,38 +205,44 @@ static u32 iommu_get_one(struct device *dev, struct page *page, int npages)
 	return busa0;
 }
 
-static u32 iommu_get_scsi_one(struct device *dev, char *vaddr, unsigned int len)
+static dma_addr_t __sbus_iommu_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t len)
 {
-	unsigned long off;
-	int npages;
-	struct page *page;
-	u32 busa;
-
-	off = (unsigned long)vaddr & ~PAGE_MASK;
-	npages = (off + len + PAGE_SIZE-1) >> PAGE_SHIFT;
-	page = virt_to_page((unsigned long)vaddr & PAGE_MASK);
-	busa = iommu_get_one(dev, page, npages);
-	return busa + off;
+	void *vaddr = page_address(page) + offset;
+	unsigned long off = (unsigned long)vaddr & ~PAGE_MASK;
+	unsigned long npages = (off + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	
+	/* XXX So what is maxphys for us and how do drivers know it? */
+	if (!len || len > 256 * 1024)
+		return DMA_MAPPING_ERROR;
+	return iommu_get_one(dev, virt_to_page(vaddr), npages) + off;
 }
 
-static __u32 iommu_get_scsi_one_gflush(struct device *dev, char *vaddr, unsigned long len)
+static dma_addr_t sbus_iommu_map_page_gflush(struct device *dev,
+		struct page *page, unsigned long offset, size_t len,
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	flush_page_for_dma(0);
-	return iommu_get_scsi_one(dev, vaddr, len);
+	return __sbus_iommu_map_page(dev, page, offset, len);
 }
 
-static __u32 iommu_get_scsi_one_pflush(struct device *dev, char *vaddr, unsigned long len)
+static dma_addr_t sbus_iommu_map_page_pflush(struct device *dev,
+		struct page *page, unsigned long offset, size_t len,
+		enum dma_data_direction dir, unsigned long attrs)
 {
-	unsigned long page = ((unsigned long) vaddr) & PAGE_MASK;
+	void *vaddr = page_address(page) + offset;
+	unsigned long p = ((unsigned long)vaddr) & PAGE_MASK;
 
-	while(page < ((unsigned long)(vaddr + len))) {
-		flush_page_for_dma(page);
-		page += PAGE_SIZE;
+	while (p < (unsigned long)vaddr + len) {
+		flush_page_for_dma(p);
+		p += PAGE_SIZE;
 	}
-	return iommu_get_scsi_one(dev, vaddr, len);
+
+	return __sbus_iommu_map_page(dev, page, offset, len);
 }
 
-static void iommu_get_scsi_sgl_gflush(struct device *dev, struct scatterlist *sg, int sz)
+static int sbus_iommu_map_sg_gflush(struct device *dev, struct scatterlist *sg,
+		int sz, enum dma_data_direction dir, unsigned long attrs)
 {
 	int n;
 
@@ -248,9 +254,12 @@ static void iommu_get_scsi_sgl_gflush(struct device *dev, struct scatterlist *sg
 		sg->dma_length = sg->length;
 		sg = sg_next(sg);
 	}
+
+	return sz;
 }
 
-static void iommu_get_scsi_sgl_pflush(struct device *dev, struct scatterlist *sg, int sz)
+static int sbus_iommu_map_sg_pflush(struct device *dev, struct scatterlist *sg,
+		int sz, enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long page, oldpage = 0;
 	int n, i;
@@ -279,6 +288,8 @@ static void iommu_get_scsi_sgl_pflush(struct device *dev, struct scatterlist *sg
 		sg->dma_length = sg->length;
 		sg = sg_next(sg);
 	}
+
+	return sz;
 }
 
 static void iommu_release_one(struct device *dev, u32 busa, int npages)
@@ -297,23 +308,23 @@ static void iommu_release_one(struct device *dev, u32 busa, int npages)
 	bit_map_clear(&iommu->usemap, ioptex, npages);
 }
 
-static void iommu_release_scsi_one(struct device *dev, __u32 vaddr, unsigned long len)
+static void sbus_iommu_unmap_page(struct device *dev, dma_addr_t dma_addr,
+		size_t len, enum dma_data_direction dir, unsigned long attrs)
 {
-	unsigned long off;
+	unsigned long off = dma_addr & ~PAGE_MASK;
 	int npages;
 
-	off = vaddr & ~PAGE_MASK;
 	npages = (off + len + PAGE_SIZE-1) >> PAGE_SHIFT;
-	iommu_release_one(dev, vaddr & PAGE_MASK, npages);
+	iommu_release_one(dev, dma_addr & PAGE_MASK, npages);
 }
 
-static void iommu_release_scsi_sgl(struct device *dev, struct scatterlist *sg, int sz)
+static void sbus_iommu_unmap_sg(struct device *dev, struct scatterlist *sg,
+		int sz, enum dma_data_direction dir, unsigned long attrs)
 {
 	int n;
 
 	while(sz != 0) {
 		--sz;
-
 		n = (sg->length + sg->offset + PAGE_SIZE-1) >> PAGE_SHIFT;
 		iommu_release_one(dev, sg->dma_address & PAGE_MASK, n);
 		sg->dma_address = 0x21212121;
@@ -322,15 +333,28 @@ static void iommu_release_scsi_sgl(struct device *dev, struct scatterlist *sg, i
 }
 
 #ifdef CONFIG_SBUS
-static int iommu_map_dma_area(struct device *dev, dma_addr_t *pba, unsigned long va,
-			      unsigned long addr, int len)
+static void *sbus_iommu_alloc(struct device *dev, size_t len,
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	struct iommu_struct *iommu = dev->archdata.iommu;
-	unsigned long page, end;
+	unsigned long va, addr, page, end, ret;
 	iopte_t *iopte = iommu->page_table;
 	iopte_t *first;
 	int ioptex;
 
+	/* XXX So what is maxphys for us and how do drivers know it? */
+	if (!len || len > 256 * 1024)
+		return NULL;
+
+	len = PAGE_ALIGN(len);
+	va = __get_free_pages(gfp, get_order(len));
+	if (va == 0)
+		return NULL;
+
+	addr = ret = sparc_dma_alloc_resource(dev, len);
+	if (!addr)
+		goto out_free_pages;
+
 	BUG_ON((va & ~PAGE_MASK) != 0);
 	BUG_ON((addr & ~PAGE_MASK) != 0);
 	BUG_ON((len & ~PAGE_MASK) != 0);
@@ -385,16 +409,25 @@ static int iommu_map_dma_area(struct device *dev, dma_addr_t *pba, unsigned long
 	flush_tlb_all();
 	iommu_invalidate(iommu->regs);
 
-	*pba = iommu->start + (ioptex << PAGE_SHIFT);
-	return 0;
+	*dma_handle = iommu->start + (ioptex << PAGE_SHIFT);
+	return (void *)ret;
+
+out_free_pages:
+	free_pages(va, get_order(len));
+	return NULL;
 }
 
-static void iommu_unmap_dma_area(struct device *dev, unsigned long busa, int len)
+static void sbus_iommu_free(struct device *dev, size_t len, void *cpu_addr,
+			       dma_addr_t busa, unsigned long attrs)
 {
 	struct iommu_struct *iommu = dev->archdata.iommu;
 	iopte_t *iopte = iommu->page_table;
-	unsigned long end;
+	struct page *page = virt_to_page(cpu_addr);
 	int ioptex = (busa - iommu->start) >> PAGE_SHIFT;
+	unsigned long end;
+
+	if (!sparc_dma_free_resource(cpu_addr, len))
+		return;
 
 	BUG_ON((busa & ~PAGE_MASK) != 0);
 	BUG_ON((len & ~PAGE_MASK) != 0);
@@ -408,38 +441,40 @@ static void iommu_unmap_dma_area(struct device *dev, unsigned long busa, int len
 	flush_tlb_all();
 	iommu_invalidate(iommu->regs);
 	bit_map_clear(&iommu->usemap, ioptex, len >> PAGE_SHIFT);
+
+	__free_pages(page, get_order(len));
 }
 #endif
 
-static const struct sparc32_dma_ops iommu_dma_gflush_ops = {
-	.get_scsi_one		= iommu_get_scsi_one_gflush,
-	.get_scsi_sgl		= iommu_get_scsi_sgl_gflush,
-	.release_scsi_one	= iommu_release_scsi_one,
-	.release_scsi_sgl	= iommu_release_scsi_sgl,
+static const struct dma_map_ops sbus_iommu_dma_gflush_ops = {
 #ifdef CONFIG_SBUS
-	.map_dma_area		= iommu_map_dma_area,
-	.unmap_dma_area		= iommu_unmap_dma_area,
+	.alloc			= sbus_iommu_alloc,
+	.free			= sbus_iommu_free,
 #endif
+	.map_page		= sbus_iommu_map_page_gflush,
+	.unmap_page		= sbus_iommu_unmap_page,
+	.map_sg			= sbus_iommu_map_sg_gflush,
+	.unmap_sg		= sbus_iommu_unmap_sg,
 };
 
-static const struct sparc32_dma_ops iommu_dma_pflush_ops = {
-	.get_scsi_one		= iommu_get_scsi_one_pflush,
-	.get_scsi_sgl		= iommu_get_scsi_sgl_pflush,
-	.release_scsi_one	= iommu_release_scsi_one,
-	.release_scsi_sgl	= iommu_release_scsi_sgl,
+static const struct dma_map_ops sbus_iommu_dma_pflush_ops = {
 #ifdef CONFIG_SBUS
-	.map_dma_area		= iommu_map_dma_area,
-	.unmap_dma_area		= iommu_unmap_dma_area,
+	.alloc			= sbus_iommu_alloc,
+	.free			= sbus_iommu_free,
 #endif
+	.map_page		= sbus_iommu_map_page_pflush,
+	.unmap_page		= sbus_iommu_unmap_page,
+	.map_sg			= sbus_iommu_map_sg_pflush,
+	.unmap_sg		= sbus_iommu_unmap_sg,
 };
 
 void __init ld_mmu_iommu(void)
 {
 	if (flush_page_for_dma_global) {
 		/* flush_page_for_dma flushes everything, no matter of what page is it */
-		sparc32_dma_ops = &iommu_dma_gflush_ops;
+		dma_ops = &sbus_iommu_dma_gflush_ops;
 	} else {
-		sparc32_dma_ops = &iommu_dma_pflush_ops;
+		dma_ops = &sbus_iommu_dma_pflush_ops;
 	}
 
 	if (viking_mxcc_present || srmmu_modtype == HyperSparc) {
-- 
2.19.2

