Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8695EC65BAF
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 470EA208E7
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="boH8jLor"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 470EA208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbeLHRh1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43020 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbeLHRhU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rf2INvOvASb+bwKkLRGXlrOoY5ukby0zM9d4/mbNcZk=; b=boH8jLoroyijxSr4D+a04FIPAF
        nnSdifDeV7Nfok8PX4Tr7695v6WUMHSyHoUoUUzer4+YY2wD2i+ho+3xCco2Rm2h4UJg7chVghL9x
        l82519lVq9LNMO7K1jLjvdnU3qYRzoprOhssFDWlcMAOEGSjxMwAKLXX8NcduitKLF98+G/8HpcD9
        Obsk/bnCKyp+j7qlhMokloDgqwMRvVsOmkNxwgJ3ZApvV1awPnzHoPHcVAjTdq2WkvFkO1vnIqQK0
        acQW+J00CEFIXFopETVhAyyDm/0zgl1eX4RqF66JjIsnN8DkHNA3hr96Oy01ye//QNJ18IhlhZ5mY
        iItdF11g==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXJ-00054J-1i; Sat, 08 Dec 2018 17:37:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     iommu@lists.linux-foundation.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH 06/10] sparc64/iommu: implement DMA_ATTR_NON_CONSISTENT
Date:   Sat,  8 Dec 2018 09:36:58 -0800
Message-Id: <20181208173702.15158-7-hch@lst.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181208173702.15158-1-hch@lst.de>
References: <20181208173702.15158-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Just allocate the memory and use map_page to map the memory.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/sparc/kernel/iommu.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 4bf0497e0704..4ce24c9dc691 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -699,14 +699,19 @@ static void *dma_4u_alloc(struct device *dev, size_t size,
 	first_page = (unsigned long) page_address(page);
 	memset((char *)first_page, 0, PAGE_SIZE << order);
 
+	if (attrs & DMA_ATTR_NON_CONSISTENT) {
+		*dma_addrp = dma_4u_map_page(dev, page, 0, size,
+					     DMA_BIDIRECTIONAL, 0);
+		if (*dma_addrp == DMA_MAPPING_ERROR)
+			goto out_free_page;
+		return page_address(page);
+	}
+
 	iommu = dev->archdata.iommu;
 
 	iopte = alloc_npages(dev, iommu, size >> IO_PAGE_SHIFT);
-
-	if (unlikely(iopte == NULL)) {
-		free_pages(first_page, order);
-		return NULL;
-	}
+	if (unlikely(iopte == NULL))
+		goto out_free_page;
 
 	*dma_addrp = (iommu->tbl.table_map_base +
 		      ((iopte - iommu->page_table) << IO_PAGE_SHIFT));
@@ -722,18 +727,26 @@ static void *dma_4u_alloc(struct device *dev, size_t size,
 	}
 
 	return ret;
+
+out_free_page:
+	free_pages(first_page, order);
+	return NULL;
 }
 
 static void dma_4u_free(struct device *dev, size_t size, void *cpu,
 			dma_addr_t dvma, unsigned long attrs)
 {
-	struct iommu *iommu;
-	unsigned long order, npages;
+	unsigned long order;
 
-	npages = IO_PAGE_ALIGN(size) >> IO_PAGE_SHIFT;
-	iommu = dev->archdata.iommu;
+	if (attrs & DMA_ATTR_NON_CONSISTENT) {
+		dma_4u_unmap_page(dev, dvma, size, DMA_BIDIRECTIONAL, 0);
+	} else {
+		struct iommu *iommu = dev->archdata.iommu;
 
-	iommu_tbl_range_free(&iommu->tbl, dvma, npages, IOMMU_ERROR_CODE);
+		iommu_tbl_range_free(&iommu->tbl, dvma,
+				     IO_PAGE_ALIGN(size) >> IO_PAGE_SHIFT,
+				     IOMMU_ERROR_CODE);
+	}
 
 	order = get_order(size);
 	if (order < 10)
-- 
2.19.2

