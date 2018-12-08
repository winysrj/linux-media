Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149B7C65BAF
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFE512081C
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l3HKh0+8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFE512081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbeLHRhT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:37:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42970 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbeLHRhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XUde1X8jAn8yYeGMwzQeQcuKAPZfRr5Pxt+ez51/3Q4=; b=l3HKh0+8SwXSMPlCOnDZpOZYn
        Avcsn9ArzVvXakztvqLPfKk/9jmeUhKK5JpyaH0SEFkXJNI0l7Q7j27kkN6Pe1BbqIHw4KeJfvkhh
        r7EBVaHYxGOJE34WxwhQY4NE/oZb/OPLoizG+MHdZQvh15KZD+AAWLlfxqDHBi7TrDCToIiPfqW7c
        jlm7sgGXruE3knvFUj4CS5GbX11RxJP/LSiaSIx4tQAmt6csGqczmf8rfJzirjkVsIfy0XMpNxVPA
        aNz46qBQtsh/yYgMhIRDk4Ww4HoPkl6r2ydusm1Kq1xkL2QQH9qG61XgOVGymduA24/bZbHfNmp66
        pB29lUuxw==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgXG-00053u-Gn; Sat, 08 Dec 2018 17:37:02 +0000
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
Subject: make the non-consistent DMA allocator more userful
Date:   Sat,  8 Dec 2018 09:36:52 -0800
Message-Id: <20181208173702.15158-1-hch@lst.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi all,

we had all kinds of discussions about how to best allocate DMAable memory
without having to deal with the problem that your normal "coherent"
DMA allocator can be very slow on platforms where DMA is not DMA
coherent.

To work around this drivers basically two choices at the moment:

 (1) just allocate memory using the page or slab allocator and the call
     one of the dma_map_* APIs on it.  This has a few drawbacks:

       - normal GFP_KERNEL memory might not actually be DMA addressable
	 for all devices, forcing fallbacks to slow bounce buffering
       - there is no easy way to access the CMA allocator for large
	 chunks, or to map small pages into single device and virtually
	 contigous chunks using the iommu and vmap

 (2) use dma_alloc_attrs with the DMA_ATTR_NON_CONSISTENT flag.  This
     has a different set of drawbacks

       - only very few architectures actually implement this API fully,
	 if it is not implemented it falls back to the potentially
	 uncached and slow coherent allocator
       - the dma_cache_sync API to use with it is not very well
	 specified and problematic in that it does not clearly
	 transfer ownership

Based on that I've been planning to introduce a proper API for
allocating DMAable memory for a while.  In the end I've ended up
improving the DMA_ATTR_NON_CONSISTENT flag instead of designing
something new.  To make it useful we need to:

 (a) ensure we don't fall back to the slow coherent allocator except
     on fully coherent platforms where they are the same anyway
 (b) replace the odd dma_cache_sync calls with the proper
     dma_sync_* APIs that we also use for other ownership trasnfers

This turned out to be surprisingly simple now that we have consolidated
most of the direct mapping code.  Note that this series is missing
the updates for powerpc which is in the process of being migrated to
the common direct mapping code in another series and would be covered
by that.

Note that these patches don't use iommu/vmap coalescing as they can
be problematic depending on the cache architecture.  But we could
opt into those when we know we don't have cache interaction problems
based on the API.

All the patches are on top of the dma-mapping for-net tree and also
available as a git tree here:

    git://git.infradead.org/users/hch/misc.git dma-noncoherent-allocator

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma-noncoherent-allocator
