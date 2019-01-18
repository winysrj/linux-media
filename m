Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21132C43444
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 11:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCCC02086D
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 11:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pcBdhcCw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfARLhr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 06:37:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56696 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfARLhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 06:37:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R5IQsd9ZXv+7QWopB1S9h+jsF+zX7CmCehcK3NfGkjM=; b=pcBdhcCwvxevK6cUl41RbG93ND
        xIl1vml+9yeFAHEMTArqlUjmqFm3reqM29gveR4plRwuZke0pLBVJBT6/FSHnqkpigaW7HLm/kptW
        7kr3IXmblIs+YNMyRwHCtKgvHMpwnbnVRxxM+F71ehML3MrE3zPvjKLY5hNBA8ijafftUCu42B2UR
        fxA6RgbaWyeVOndQ4InhFJOXrpSAuxeiwLnxIiRKMkRGOI59YvqVf86Qxfr2ORpBSc3XZnB9mXnLZ
        YHFatSWDZy4u4bh/E+ipMzPOKzDUIbdR+nWhwf05vHA7rcxWBgeCisGyhYtAetF0R1mctvu7c7f37
        NcLRCxXQ==;
Received: from 089144210168.atnat0019.highway.a1.net ([89.144.210.168] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gkSSr-0005OP-HA; Fri, 18 Jan 2019 11:37:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] dma-mapping: remove the default map_resource implementation
Date:   Fri, 18 Jan 2019 12:37:25 +0100
Message-Id: <20190118113727.3270-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118113727.3270-1-hch@lst.de>
References: <20190118113727.3270-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Instead provide a proper implementation in the direct mapping code, and
also wire it up for arm and powerpc, leaving an error return for all the
IOMMU or virtual mapping instances for which we'd have to wire up an
actual implementation

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm/mm/dma-mapping.c         |  2 ++
 arch/powerpc/kernel/dma-swiotlb.c |  1 +
 arch/powerpc/kernel/dma.c         |  1 +
 include/linux/dma-mapping.h       | 12 +++++++-----
 kernel/dma/direct.c               | 14 ++++++++++++++
 5 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index f1e2922e447c..3c8534904209 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -188,6 +188,7 @@ const struct dma_map_ops arm_dma_ops = {
 	.unmap_page		= arm_dma_unmap_page,
 	.map_sg			= arm_dma_map_sg,
 	.unmap_sg		= arm_dma_unmap_sg,
+	.map_resource		= dma_direct_map_resource,
 	.sync_single_for_cpu	= arm_dma_sync_single_for_cpu,
 	.sync_single_for_device	= arm_dma_sync_single_for_device,
 	.sync_sg_for_cpu	= arm_dma_sync_sg_for_cpu,
@@ -211,6 +212,7 @@ const struct dma_map_ops arm_coherent_dma_ops = {
 	.get_sgtable		= arm_dma_get_sgtable,
 	.map_page		= arm_coherent_dma_map_page,
 	.map_sg			= arm_dma_map_sg,
+	.map_resource		= dma_direct_map_resource,
 	.dma_supported		= arm_dma_supported,
 };
 EXPORT_SYMBOL(arm_coherent_dma_ops);
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index 7d5fc9751622..fbb2506a414e 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -55,6 +55,7 @@ const struct dma_map_ops powerpc_swiotlb_dma_ops = {
 	.dma_supported = swiotlb_dma_supported,
 	.map_page = dma_direct_map_page,
 	.unmap_page = dma_direct_unmap_page,
+	.map_resource = dma_direct_map_resource,
 	.sync_single_for_cpu = dma_direct_sync_single_for_cpu,
 	.sync_single_for_device = dma_direct_sync_single_for_device,
 	.sync_sg_for_cpu = dma_direct_sync_sg_for_cpu,
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index b1903ebb2e9c..258b9e8ebb99 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -273,6 +273,7 @@ const struct dma_map_ops dma_nommu_ops = {
 	.dma_supported			= dma_nommu_dma_supported,
 	.map_page			= dma_nommu_map_page,
 	.unmap_page			= dma_nommu_unmap_page,
+	.map_resource			= dma_direct_map_resource,
 	.get_required_mask		= dma_nommu_get_required_mask,
 #ifdef CONFIG_NOT_COHERENT_CACHE
 	.sync_single_for_cpu 		= dma_nommu_sync_single,
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index f6ded992c183..9842085e6774 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -208,6 +208,8 @@ dma_addr_t dma_direct_map_page(struct device *dev, struct page *page,
 		unsigned long attrs);
 int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 		enum dma_data_direction dir, unsigned long attrs);
+dma_addr_t dma_direct_map_resource(struct device *dev, phys_addr_t paddr,
+		size_t size, enum dma_data_direction dir, unsigned long attrs);
 
 #if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
     defined(CONFIG_SWIOTLB)
@@ -346,19 +348,19 @@ static inline dma_addr_t dma_map_resource(struct device *dev,
 					  unsigned long attrs)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
-	dma_addr_t addr;
+	dma_addr_t addr = DMA_MAPPING_ERROR;
 
 	BUG_ON(!valid_dma_direction(dir));
 
 	/* Don't allow RAM to be mapped */
 	BUG_ON(pfn_valid(PHYS_PFN(phys_addr)));
 
-	addr = phys_addr;
-	if (ops && ops->map_resource)
+	if (dma_is_direct(ops))
+		addr = dma_direct_map_resource(dev, phys_addr, size, dir, attrs);
+	else if (ops->map_resource)
 		addr = ops->map_resource(dev, phys_addr, size, dir, attrs);
 
 	debug_dma_map_resource(dev, phys_addr, size, dir, addr);
-
 	return addr;
 }
 
@@ -369,7 +371,7 @@ static inline void dma_unmap_resource(struct device *dev, dma_addr_t addr,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (ops && ops->unmap_resource)
+	if (!dma_is_direct(ops) && ops->unmap_resource)
 		ops->unmap_resource(dev, addr, size, dir, attrs);
 	debug_dma_unmap_resource(dev, addr, size, dir);
 }
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 355d16acee6d..25bd19974223 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -356,6 +356,20 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 }
 EXPORT_SYMBOL(dma_direct_map_sg);
 
+dma_addr_t dma_direct_map_resource(struct device *dev, phys_addr_t paddr,
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
+{
+	dma_addr_t dma_addr = paddr;
+
+	if (unlikely(!dma_direct_possible(dev, dma_addr, size))) {
+		report_addr(dev, dma_addr, size);
+		return DMA_MAPPING_ERROR;
+	}
+
+	return dma_addr;
+}
+EXPORT_SYMBOL(dma_direct_map_resource);
+
 /*
  * Because 32-bit DMA masks are so common we expect every architecture to be
  * able to satisfy them - either by not supporting more physical memory, or by
-- 
2.20.1

