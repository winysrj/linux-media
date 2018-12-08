Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F386C64EB1
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 268E92081C
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ihDkI2KB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 268E92081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbeLHRhW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbeLHRhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NLkfdUBEdCMvItDNu9ApfVyxMTjrOso1MH0a7btwpaw=; b=ihDkI2KBJLoZeyxd3zD6I3kY0i
        BZms6VHd7EFml42ho/Wk/Ab1yUJ5Z7RKMsqFDIsqx/9XUadtmf1Q5+3bAe6KStmKApoGMmy2kldOy
        2PClm98ZZ+p/9hcZJ+98ZnTEhZgAAOVS4V77SOn8v9DfmUiC2JHkbYu8CUNj9FDaVZqRc9AjKSD8g
        yOTn36/h8m1BbxZLks4s5YW4JXCAllgq8EQDKDkma+E+WJzw5e5LO02QIA82StUmVpehkfvT3jE++
        Q5m0OWuykXvlff+gh5p6l6ZreX0TuQxntNZDjVWEg/Ls0RErcTVBl+iDCV2Jajnq6RaI984DcWfNt
        VYUj8b3g==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXK-00054Y-Md; Sat, 08 Dec 2018 17:37:06 +0000
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
Subject: [PATCH 10/10] Documentation: update the description for DMA_ATTR_NON_CONSISTENT
Date:   Sat,  8 Dec 2018 09:37:02 -0800
Message-Id: <20181208173702.15158-11-hch@lst.de>
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

We got rid of the odd selective consistent or not behavior, and now
want the normal dma_sync_single_* functions to be used for strict
ownership transfers.  While dma_cache_sync hasn't been removed from
the tree yet it should not be used in any new caller, so documentation
for it is dropped here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/DMA-API.txt        | 30 ++++--------------------------
 Documentation/DMA-attributes.txt |  9 +++++----
 include/linux/dma-mapping.h      |  3 +++
 3 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index ac66ae2509a9..c81fe8a4aeec 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -518,20 +518,9 @@ API at all.
 	dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 			gfp_t flag, unsigned long attrs)
 
-Identical to dma_alloc_coherent() except that when the
-DMA_ATTR_NON_CONSISTENT flags is passed in the attrs argument, the
-platform will choose to return either consistent or non-consistent memory
-as it sees fit.  By using this API, you are guaranteeing to the platform
-that you have all the correct and necessary sync points for this memory
-in the driver should it choose to return non-consistent memory.
-
-Note: where the platform can return consistent memory, it will
-guarantee that the sync points become nops.
-
-Warning:  Handling non-consistent memory is a real pain.  You should
-only use this API if you positively know your driver will be
-required to work on one of the rare (usually non-PCI) architectures
-that simply cannot make consistent memory.
+Similar to dma_alloc_coherent(), except that the behavior can be controlled
+in more detail using the attrs argument.  See Documentation/DMA-attributes.txt
+for more details.
 
 ::
 
@@ -540,7 +529,7 @@ that simply cannot make consistent memory.
 		       dma_addr_t dma_handle, unsigned long attrs)
 
 Free memory allocated by the dma_alloc_attrs().  All parameters common
-parameters must identical to those otherwise passed to dma_fre_coherent,
+parameters must identical to those otherwise passed to dma_free_coherent,
 and the attrs argument must be identical to the attrs passed to
 dma_alloc_attrs().
 
@@ -560,17 +549,6 @@ memory or doing partial flushes.
 	into the width returned by this call.  It will also always be a power
 	of two for easy alignment.
 
-::
-
-	void
-	dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-		       enum dma_data_direction direction)
-
-Do a partial sync of memory that was allocated by dma_alloc_attrs() with
-the DMA_ATTR_NON_CONSISTENT flag starting at virtual address vaddr and
-continuing on for size.  Again, you *must* observe the cache line
-boundaries when doing this.
-
 ::
 
 	int
diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index 8f8d97f65d73..2bb3fc0a621b 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -46,10 +46,11 @@ behavior.
 DMA_ATTR_NON_CONSISTENT
 -----------------------
 
-DMA_ATTR_NON_CONSISTENT lets the platform to choose to return either
-consistent or non-consistent memory as it sees fit.  By using this API,
-you are guaranteeing to the platform that you have all the correct and
-necessary sync points for this memory in the driver.
+DMA_ATTR_NON_CONSISTENT specifies that the memory returned is not
+required to be consistent.  The memory is owned by the device when
+returned from this function, and ownership must be explicitly
+transferred to the CPU using dma_sync_single_for_cpu, and back to the
+device using dma_sync_single_for_device.
 
 DMA_ATTR_NO_KERNEL_MAPPING
 --------------------------
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 8c81fa5d1f44..8757ad5087c4 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -432,6 +432,9 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 #define dma_map_page(d, p, o, s, r) dma_map_page_attrs(d, p, o, s, r, 0)
 #define dma_unmap_page(d, a, s, r) dma_unmap_page_attrs(d, a, s, r, 0)
 
+/*
+ * Don't use in new code, use dma_sync_single_for_{device,cpu} instead.
+ */
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction dir)
-- 
2.19.2

