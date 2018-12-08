Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C70C67838
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0233A2081C
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jcwyDbqR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0233A2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbeLHRhT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42958 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbeLHRhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=itmW2VTZOd8rUAhTAA5rXh48hRuTxgk6doJ5rJPhYhw=; b=jcwyDbqRd5uJfegfK33I29M4qZ
        QJc+UC8+Ial6xQVasjjhwQ1tRtP0BmxeQEqhywdDfH3cd4OH/CQ/7JU9DWLtPZR5IEl4kSA2kCzo3
        Lzfvez+RGSIyuvbCdUF6j2sXnSFkAb6JzRy8SeuoYakaPKHe9MPI38WGmSHQAlEcQ7ErbfCapSB+H
        dWbvXWBLED/oQs/FZ31Y4Jg9uTdPn2sUnDWuNMp+y7n+lnn7XhbnrksK2CucqDuX/YYvdWwuY3dpG
        7iPrAweJ4mJg11h/4EPW33ciDSfaVgNOsA4u7RK+Ul63Um/nT463wGQhjcHf+HGNtZElW6NmJPCPW
        xF8pkExA==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXJ-00054P-RK; Sat, 08 Dec 2018 17:37:05 +0000
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
Subject: [PATCH 08/10] sparc64/pci_sun4v: implement DMA_ATTR_NON_CONSISTENT
Date:   Sat,  8 Dec 2018 09:37:00 -0800
Message-Id: <20181208173702.15158-9-hch@lst.de>
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
 arch/sparc/kernel/pci_sun4v.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index b95c70136559..24a76ecf2986 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -590,6 +590,14 @@ static void *dma_4v_alloc(struct device *dev, size_t size,
 	first_page = (unsigned long) page_address(page);
 	memset((char *)first_page, 0, PAGE_SIZE << order);
 
+	if (attrs & DMA_ATTR_NON_CONSISTENT) {
+		*dma_addrp = dma_4v_map_page(dev, page, 0, size,
+					     DMA_BIDIRECTIONAL, 0);
+		if (*dma_addrp == DMA_MAPPING_ERROR)
+			goto range_alloc_fail;
+		return page_address(page);
+	}
+
 	iommu = dev->archdata.iommu;
 	atu = iommu->atu;
 
@@ -649,6 +657,11 @@ static void dma_4v_free(struct device *dev, size_t size, void *cpu,
 	unsigned long iotsb_num;
 	u32 devhandle;
 
+	if (attrs & DMA_ATTR_NON_CONSISTENT) {
+		dma_4v_unmap_page(dev, dvma, size, DMA_BIDIRECTIONAL, 0);
+		goto free_pages;
+	}
+
 	npages = IO_PAGE_ALIGN(size) >> IO_PAGE_SHIFT;
 	iommu = dev->archdata.iommu;
 	pbm = dev->archdata.host_controller;
@@ -665,6 +678,7 @@ static void dma_4v_free(struct device *dev, size_t size, void *cpu,
 	entry = ((dvma - tbl->table_map_base) >> IO_PAGE_SHIFT);
 	dma_4v_iommu_demap(dev, devhandle, dvma, iotsb_num, entry, npages);
 	iommu_tbl_range_free(tbl, dvma, npages, IOMMU_ERROR_CODE);
+free_pages:
 	order = get_order(size);
 	if (order < 10)
 		free_pages((unsigned long)cpu, order);
-- 
2.19.2

