Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139A0C67839
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C631A2146D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VB3KXCQu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C631A2146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbeLHRhV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42966 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbeLHRhT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0CD6uo+bwgT+H68fZmDPIq1sLN+h7RevkhK940kBU8E=; b=VB3KXCQu/XqE5/eRoXYXL5UAyp
        PMwyq/2HuGy3y6C4GaRuzE3Ax9/mpPAf8stvE8ysr8Hg6YU16vt/EGetBczq2oSrzygLBhFfV0UOm
        vm5tNR46EMCp03o8MJnroaB8z9ymeHIJEVU5nnywOiO6FknzJ05lIPvNnJW3AYep76UcooN6Y297B
        V0PJeDcNMSWrFQbIoUHa1l8WI19GsyMUwa0V8eH75dlMkphAqU8wcpEWwzqnFqQ4ejZUamnSoP5Pk
        L0CzZJAASGcMT0hVCMwnyiCHEV3EGDxmdrFPIA9Y5VUd2L9iaDOoh7zkgFU34x7RI4i9D9Iv3yl71
        KFj2qEiw==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXK-00054V-9p; Sat, 08 Dec 2018 17:37:06 +0000
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
Subject: [PATCH 09/10] dma-mapping: skip declared coherent memory for DMA_ATTR_NON_CONSISTENT
Date:   Sat,  8 Dec 2018 09:37:01 -0800
Message-Id: <20181208173702.15158-10-hch@lst.de>
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

Memory declared using dma_declare_coherent is ioremapped and thus not
always suitable for our tightened DMA_ATTR_NON_CONSISTENT definition.

Skip it given all the existing callers don't DMA_ATTR_NON_CONSISTENT
anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/dma-mapping.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 7799c2b27849..8c81fa5d1f44 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -521,7 +521,8 @@ static inline void *dma_alloc_attrs(struct device *dev, size_t size,
 	BUG_ON(!ops);
 	WARN_ON_ONCE(dev && !dev->coherent_dma_mask);
 
-	if (dma_alloc_from_dev_coherent(dev, size, dma_handle, &cpu_addr))
+	if (!(attrs & DMA_ATTR_NON_CONSISTENT) &&
+	    dma_alloc_from_dev_coherent(dev, size, dma_handle, &cpu_addr))
 		return cpu_addr;
 
 	/* let the implementation decide on the zone to allocate from: */
-- 
2.19.2

