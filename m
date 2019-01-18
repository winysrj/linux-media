Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1678C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 11:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 669CD20652
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 11:38:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JUFdV6ag"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfARLhv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 06:37:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56758 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfARLhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 06:37:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=onP7tSqCOObp60S51bk8Ez5+ZsHmuF3HzNza6b83R+4=; b=JUFdV6agaFlBexuYPNCElM7UK6
        WXxyEtr534d3QnhsVx08q+lon+LZEVQMb0n6rbe6tLa0atF64kIigAomBV3MqHJfCzuOyuLzFSmCa
        A+MiekCAK8Ue5cg/RkhOkq+Q9KmTJh7KZlF7tO58xwSVIQpjJgLwqo/DSwpEuwUQEnr6IIXhv/0JT
        HY0MBtQD+zjWL1kda54zSFsyDKlfneB04unHhLfEuJz7s6ki78MxTpYupbDqdS8xXBLZiIZj/0Y6t
        luVZesGpiP4R7w80kQgHjRRoBeeJh4UhvCu88QkzxRUH+lOopcIJtR6IpxTnWxrFKL166SlKn54AA
        voqJBe4A==;
Received: from 089144210168.atnat0019.highway.a1.net ([89.144.210.168] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gkSSx-0005Rq-Ba; Fri, 18 Jan 2019 11:37:40 +0000
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
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 3/3] videobuf2: replace a layering violation with dma_map_resource
Date:   Fri, 18 Jan 2019 12:37:27 +0100
Message-Id: <20190118113727.3270-4-hch@lst.de>
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

vb2_dc_get_userptr pokes into arm direct mapping details to get the
resemblance of a dma address for a a physical address that does is
not backed by a page struct.  Not only is this not portable to other
architectures with dma direct mapping offsets, but also not to uses
of IOMMUs of any kind.  Switch to the proper dma_map_resource /
dma_unmap_resource interface instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../common/videobuf2/videobuf2-dma-contig.c   | 41 ++++---------------
 1 file changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index aff0ab7bf83d..82389aead6ed 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -439,42 +439,14 @@ static void vb2_dc_put_userptr(void *buf_priv)
 				set_page_dirty_lock(pages[i]);
 		sg_free_table(sgt);
 		kfree(sgt);
+	} else {
+		dma_unmap_resource(buf->dev, buf->dma_addr, buf->size,
+				   buf->dma_dir, 0);
 	}
 	vb2_destroy_framevec(buf->vec);
 	kfree(buf);
 }
 
-/*
- * For some kind of reserved memory there might be no struct page available,
- * so all that can be done to support such 'pages' is to try to convert
- * pfn to dma address or at the last resort just assume that
- * dma address == physical address (like it has been assumed in earlier version
- * of videobuf2-dma-contig
- */
-
-#ifdef __arch_pfn_to_dma
-static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
-{
-	return (dma_addr_t)__arch_pfn_to_dma(dev, pfn);
-}
-#elif defined(__pfn_to_bus)
-static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
-{
-	return (dma_addr_t)__pfn_to_bus(pfn);
-}
-#elif defined(__pfn_to_phys)
-static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
-{
-	return (dma_addr_t)__pfn_to_phys(pfn);
-}
-#else
-static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
-{
-	/* really, we cannot do anything better at this point */
-	return (dma_addr_t)(pfn) << PAGE_SHIFT;
-}
-#endif
-
 static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
@@ -528,7 +500,12 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 		for (i = 1; i < n_pages; i++)
 			if (nums[i-1] + 1 != nums[i])
 				goto fail_pfnvec;
-		buf->dma_addr = vb2_dc_pfn_to_dma(buf->dev, nums[0]);
+		buf->dma_addr = dma_map_resource(buf->dev,
+				__pfn_to_phys(nums[0]), size, buf->dma_dir, 0);
+		if (dma_mapping_error(buf->dev, buf->dma_addr)) {
+			ret = -ENOMEM;
+			goto fail_pfnvec;
+		}
 		goto out;
 	}
 
-- 
2.20.1

