Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564A7C67839
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10CE22082D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZhhS/IKe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10CE22082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbeLHRle (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:41:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59532 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbeLHRl1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:41:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HWl3tmq+6mRU3BJi/Tj3ZbJzsWwA8iOoYnJdq8X2jeY=; b=ZhhS/IKe4ZbuxeLvUwojeWqxMt
        M1dBuhYaTxyTmi3WiLXzkXLcahcgNhMqATENKWtTQCrXiXfC+ZkOgB+R1S9PzZZXKvU28PXAz8VyH
        Qa0cWL46f+f3sOAMgbATKu/Pt5vDYLsgplHRRtMoUQDMJVDsJMRaLlHkKOskHo7lJkxtU0fTicHjz
        npZSm6RG1otbk3Wib/3hSKr7De9KwNRejTUCswCb4fF9XSZVk9I8UoBgQu2R7e4bDJmGpnYx2pi9m
        I1kYJe8d3f5eWmWewQ3VbXDi3RLbsiDVayyRh2ZHFvdX2cB91m2oW/yszr2K0MvHFWo8I1y5DHVaq
        BjFkVVgw==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgbN-0000ZH-Cw; Sat, 08 Dec 2018 17:41:17 +0000
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
Subject: [PATCH 2/6] sparc: factor the dma coherent mapping into helper
Date:   Sat,  8 Dec 2018 09:41:11 -0800
Message-Id: <20181208174115.16237-3-hch@lst.de>
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

Factor the code to remap memory returned from the DMA coherent allocator
into two helpers that can be shared by the IOMMU and direct mapping code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/sparc/kernel/ioport.c | 151 ++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 84 deletions(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 4b2167a0ec0b..fd7a41c6d688 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -247,6 +247,53 @@ static void _sparc_free_io(struct resource *res)
 	release_resource(res);
 }
 
+static unsigned long sparc_dma_alloc_resource(struct device *dev, size_t len)
+{
+	struct resource *res;
+
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return 0;
+	res->name = dev->of_node->name;
+
+	if (allocate_resource(&_sparc_dvma, res, len, _sparc_dvma.start,
+			_sparc_dvma.end, PAGE_SIZE, NULL, NULL) != 0) {
+		printk("sbus_alloc_consistent: cannot occupy 0x%zx", len);
+		kfree(res);
+		return 0;
+	}
+
+	return res->start;
+}
+
+static bool sparc_dma_free_resource(void *cpu_addr, size_t size)
+{
+	unsigned long addr = (unsigned long)cpu_addr;
+	struct resource *res;
+
+	res = lookup_resource(&_sparc_dvma, addr);
+	if (!res) {
+		printk("%s: cannot free %p\n", __func__, cpu_addr);
+		return false;
+	}
+
+	if ((addr & (PAGE_SIZE - 1)) != 0) {
+		printk("%s: unaligned va %p\n", __func__, cpu_addr);
+		return false;
+	}
+
+	size = PAGE_ALIGN(size);
+	if (resource_size(res) != size) {
+		printk("%s: region 0x%lx asked 0x%zx\n",
+			__func__, (long)resource_size(res), size);
+		return false;
+	}
+
+	release_resource(res);
+	kfree(res);
+	return true;
+}
+
 #ifdef CONFIG_SBUS
 
 void sbus_set_sbus64(struct device *dev, int x)
@@ -264,10 +311,8 @@ static void *sbus_alloc_coherent(struct device *dev, size_t len,
 				 dma_addr_t *dma_addrp, gfp_t gfp,
 				 unsigned long attrs)
 {
-	struct platform_device *op = to_platform_device(dev);
 	unsigned long len_total = PAGE_ALIGN(len);
-	unsigned long va;
-	struct resource *res;
+	unsigned long va, addr;
 	int order;
 
 	/* XXX why are some lengths signed, others unsigned? */
@@ -284,32 +329,23 @@ static void *sbus_alloc_coherent(struct device *dev, size_t len,
 	if (va == 0)
 		goto err_nopages;
 
-	if ((res = kzalloc(sizeof(struct resource), GFP_KERNEL)) == NULL)
+	addr = sparc_dma_alloc_resource(dev, len_total);
+	if (!addr)
 		goto err_nomem;
 
-	if (allocate_resource(&_sparc_dvma, res, len_total,
-	    _sparc_dvma.start, _sparc_dvma.end, PAGE_SIZE, NULL, NULL) != 0) {
-		printk("sbus_alloc_consistent: cannot occupy 0x%lx", len_total);
-		goto err_nova;
-	}
-
 	// XXX The sbus_map_dma_area does this for us below, see comments.
 	// srmmu_mapiorange(0, virt_to_phys(va), res->start, len_total);
 	/*
 	 * XXX That's where sdev would be used. Currently we load
 	 * all iommu tables with the same translations.
 	 */
-	if (sbus_map_dma_area(dev, dma_addrp, va, res->start, len_total) != 0)
+	if (sbus_map_dma_area(dev, dma_addrp, va, addr, len_total) != 0)
 		goto err_noiommu;
 
-	res->name = op->dev.of_node->name;
-
-	return (void *)(unsigned long)res->start;
+	return (void *)addr;
 
 err_noiommu:
-	release_resource(res);
-err_nova:
-	kfree(res);
+	sparc_dma_free_resource((void *)addr, len_total);
 err_nomem:
 	free_pages(va, order);
 err_nopages:
@@ -319,29 +355,11 @@ static void *sbus_alloc_coherent(struct device *dev, size_t len,
 static void sbus_free_coherent(struct device *dev, size_t n, void *p,
 			       dma_addr_t ba, unsigned long attrs)
 {
-	struct resource *res;
 	struct page *pgv;
 
-	if ((res = lookup_resource(&_sparc_dvma,
-	    (unsigned long)p)) == NULL) {
-		printk("sbus_free_consistent: cannot free %p\n", p);
-		return;
-	}
-
-	if (((unsigned long)p & (PAGE_SIZE-1)) != 0) {
-		printk("sbus_free_consistent: unaligned va %p\n", p);
-		return;
-	}
-
 	n = PAGE_ALIGN(n);
-	if (resource_size(res) != n) {
-		printk("sbus_free_consistent: region 0x%lx asked 0x%zx\n",
-		    (long)resource_size(res), n);
+	if (!sparc_dma_free_resource(p, n))
 		return;
-	}
-
-	release_resource(res);
-	kfree(res);
 
 	pgv = virt_to_page(p);
 	sbus_unmap_dma_area(dev, ba, n);
@@ -418,45 +436,30 @@ arch_initcall(sparc_register_ioport);
 void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs)
 {
-	unsigned long len_total = PAGE_ALIGN(size);
+	unsigned long addr;
 	void *va;
-	struct resource *res;
-	int order;
 
-	if (size == 0) {
+	if (!size || size > 256 * 1024)	/* __get_free_pages() limit */
 		return NULL;
-	}
-	if (size > 256*1024) {			/* __get_free_pages() limit */
-		return NULL;
-	}
 
-	order = get_order(len_total);
-	va = (void *) __get_free_pages(gfp, order);
-	if (va == NULL) {
-		printk("%s: no %ld pages\n", __func__, len_total>>PAGE_SHIFT);
-		goto err_nopages;
+	size = PAGE_ALIGN(size);
+	va = (void *) __get_free_pages(gfp, get_order(size));
+	if (!va) {
+		printk("%s: no %zd pages\n", __func__, size >> PAGE_SHIFT);
+		return NULL;
 	}
 
-	if ((res = kzalloc(sizeof(struct resource), GFP_KERNEL)) == NULL) {
-		printk("%s: no core\n", __func__);
+	addr = sparc_dma_alloc_resource(dev, size);
+	if (!addr)
 		goto err_nomem;
-	}
 
-	if (allocate_resource(&_sparc_dvma, res, len_total,
-	    _sparc_dvma.start, _sparc_dvma.end, PAGE_SIZE, NULL, NULL) != 0) {
-		printk("%s: cannot occupy 0x%lx", __func__, len_total);
-		goto err_nova;
-	}
-	srmmu_mapiorange(0, virt_to_phys(va), res->start, len_total);
+	srmmu_mapiorange(0, virt_to_phys(va), addr, size);
 
 	*dma_handle = virt_to_phys(va);
-	return (void *) res->start;
+	return (void *)addr;
 
-err_nova:
-	kfree(res);
 err_nomem:
-	free_pages((unsigned long)va, order);
-err_nopages:
+	free_pages((unsigned long)va, get_order(size));
 	return NULL;
 }
 
@@ -471,31 +474,11 @@ void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs)
 {
-	struct resource *res;
-
-	if ((res = lookup_resource(&_sparc_dvma,
-	    (unsigned long)cpu_addr)) == NULL) {
-		printk("%s: cannot free %p\n", __func__, cpu_addr);
-		return;
-	}
-
-	if (((unsigned long)cpu_addr & (PAGE_SIZE-1)) != 0) {
-		printk("%s: unaligned va %p\n", __func__, cpu_addr);
+	if (!sparc_dma_free_resource(cpu_addr, PAGE_ALIGN(size)))
 		return;
-	}
-
-	size = PAGE_ALIGN(size);
-	if (resource_size(res) != size) {
-		printk("%s: region 0x%lx asked 0x%zx\n", __func__,
-		    (long)resource_size(res), size);
-		return;
-	}
 
 	dma_make_coherent(dma_addr, size);
 	srmmu_unmapiorange((unsigned long)cpu_addr, size);
-
-	release_resource(res);
-	kfree(res);
 	free_pages((unsigned long)phys_to_virt(dma_addr), get_order(size));
 }
 
-- 
2.19.2

