Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80395C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FABD20870
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qpU1faoJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbfAKSRt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 13:17:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47266 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfAKSRt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 13:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YQgQah55bxS74bCpAdOJ7aACrg7TuJ0ocAk2SxZT1V8=; b=qpU1faoJOgW0Wubl2RI7LY3laT
        qH2oMsAv68GWgFmOOMlzQdzUiCR5Jrygw++PYUACrverNpTQec1AbX177RgCQWd486fWkFHDPChme
        JdgY5ksca+/MEWyFFM2mSldXM2FfC4io5HFY7uMKU7m8lpb04AfUifHjyjfVeSJuPY1a+ptv6aRTE
        aVNT+JcRHHV61W/DYramXvFA0XJRmccSaRIuTsiUhtxM4L6/6qQRAHWSGebVKnm58tC81GOteDfUx
        yuHgryYJ6MsTMTJLSibIL2rHndFkoTEZmeD/muBZG2VxGdpAJe/K1Lk9mB7ydebRaDck947UDHilI
        WyOb+xUA==;
Received: from 089144213167.atnat0022.highway.a1.net ([89.144.213.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gi1NE-0000vv-An; Fri, 11 Jan 2019 18:17:40 +0000
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
Date:   Fri, 11 Jan 2019 19:17:29 +0100
Message-Id: <20190111181731.11782-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190111181731.11782-1-hch@lst.de>
References: <20190111181731.11782-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Just returning the physical address when not map_resource method is
present is highly dangerous as it doesn't take any offset in the
direct mapping into account and does the completely wrong thing for
IOMMUs.  Instead provide a proper implementation in the direct mapping
code, and also wire it up for arm and powerpc.

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
index cef2127e1d70..d3087829a6df 100644
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
index 355d16acee6d..8e0359b04957 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -356,6 +356,20 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 }
 EXPORT_SYMBOL(dma_direct_map_sg);
 
+dma_addr_t dma_direct_map_resource(struct device *dev, phys_addr_t paddr,
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
+{
+	dma_addr_t dma_addr = phys_to_dma(dev, paddr);
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

