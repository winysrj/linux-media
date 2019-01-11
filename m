Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F3BC43444
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752C221848
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l4LfizR9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389953AbfAKSRw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 13:17:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732162AbfAKSRt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 13:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GPdfcb/iR/rqqw08xvqL7Vit7Nv3a+9uSEChQ22mIM4=; b=l4LfizR9SJv2NiS1tYohMV0C2e
        d3PPM2gNoYxf009+sTHEbLEk/S6O+J2+VRDporbwoOMQmK+ZIM+ViKHtTgZIGeRF5Z3USrvgt5Rji
        +4wPezjmndPxa4zq1x7x4b2B8UqEAFFYWpmnF7sQilYrxhqxLhnyFaqk8zyRWkdkhQEP5lyO5YKwg
        DpcPMMV+5kgEHDVdhnNBxiTBhfo5kPlf7Ok71Iv9tL4Ojn3FrNgdOilDI+A2YkM/TW6NkLqa3evBy
        6PVL8x5UvjaM6BKeIKNWZxhbYSQsfLLqE9h6zbBxQLbF/tR/najNFqRrV/Iv//4BYgMxysJ0hAMfw
        2BS6bnRg==;
Received: from 089144213167.atnat0022.highway.a1.net ([89.144.213.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gi1NH-0000wU-Ef; Fri, 11 Jan 2019 18:17:44 +0000
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
Subject: [PATCH 2/3] dma-mapping: don't BUG when calling dma_map_resource on RAM
Date:   Fri, 11 Jan 2019 19:17:30 +0100
Message-Id: <20190111181731.11782-3-hch@lst.de>
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

Use WARN_ON_ONCE to print a stack trace and return a proper error
code instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/dma-mapping.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index d3087829a6df..91add0751aa5 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -353,7 +353,8 @@ static inline dma_addr_t dma_map_resource(struct device *dev,
 	BUG_ON(!valid_dma_direction(dir));
 
 	/* Don't allow RAM to be mapped */
-	BUG_ON(pfn_valid(PHYS_PFN(phys_addr)));
+	if (WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
+		return DMA_MAPPING_ERROR;
 
 	if (dma_is_direct(ops))
 		addr = dma_direct_map_resource(dev, phys_addr, size, dir, attrs);
-- 
2.20.1

