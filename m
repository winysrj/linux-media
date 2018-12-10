Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9944C5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 19:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F2842082F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 19:16:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F2842082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbeLJTQh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 14:16:37 -0500
Received: from verein.lst.de ([213.95.11.211]:50615 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbeLJTQh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 14:16:37 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id D22AD68DD2; Mon, 10 Dec 2018 20:16:34 +0100 (CET)
Date:   Mon, 10 Dec 2018 20:16:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     Christoph Hellwig <hch@lst.de>, iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        sparclinux@vger.kernel.org, openrisc@lists.librecores.org,
        linux-parisc@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH 04/10] arm: implement DMA_ATTR_NON_CONSISTENT
Message-ID: <20181210191634.GB30648@lst.de>
References: <20181208173702.15158-1-hch@lst.de> <20181208173702.15158-5-hch@lst.de> <3aeb99c505fd1c33199fcc26fe5e0bf239dee57e.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aeb99c505fd1c33199fcc26fe5e0bf239dee57e.camel@collabora.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Dec 08, 2018 at 07:52:04PM -0300, Ezequiel Garcia wrote:
> >  #ifdef CONFIG_DMA_API_DEBUG
> > @@ -773,7 +791,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
> >  
> >  	if (cma)
> >  		buf->allocator = &cma_allocator;
> > -	else if (is_coherent)
> > +	else if (is_coherent || (attrs & DMA_ATTR_NON_CONSISTENT))
> >  		buf->allocator = &simple_allocator;
> 
> Reading through your code I can't really see where the pgprot is changed
> for non-consistent requests. Namely, __get_dma_pgprot only
> returns writecombine or coherent memory.

We don't look at the pgprot at all for the simple allocator, and
don't look at prot for the DMA_ATTR_NON_CONSISTENT case in the
CMA allocator, so this should not be a problem.  However we need to
take DMA_ATTR_NON_CONSISTENT into account for calculating the mmap
pgprot, with something like this as an incremental patch:

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index b3b66b41c450..6ac7e430a47c 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -873,7 +873,8 @@ int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		 unsigned long attrs)
 {
-	vma->vm_page_prot = __get_dma_pgprot(attrs, vma->vm_page_prot);
+	if (!(attrs & DMA_ATTR_NON_CONSISTENT))
+		vma->vm_page_prot = __get_dma_pgprot(attrs, vma->vm_page_prot);
 	return __arm_dma_mmap(dev, vma, cpu_addr, dma_addr, size, attrs);
 }
 
