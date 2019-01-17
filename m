Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EE9C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 17:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F6A220856
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 17:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfAQRVy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 12:21:54 -0500
Received: from verein.lst.de ([213.95.11.211]:38650 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbfAQRVy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 12:21:54 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 0146668CEB; Thu, 17 Jan 2019 18:21:52 +0100 (CET)
Date:   Thu, 17 Jan 2019 18:21:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] videobuf2: replace a layering violation with
 dma_map_resource
Message-ID: <20190117172152.GA32292@lst.de>
References: <20190111181731.11782-1-hch@lst.de> <CGME20190111181812epcas2p1eeb68a16701631513eaf297073f7299f@epcas2p1.samsung.com> <20190111181731.11782-4-hch@lst.de> <6f8892ac-c2aa-10df-c74f-ba032bf75160@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f8892ac-c2aa-10df-c74f-ba032bf75160@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 14, 2019 at 01:42:26PM +0100, Marek Szyprowski wrote:
> Hi Christoph,
> 
> On 2019-01-11 19:17, Christoph Hellwig wrote:
> > vb2_dc_get_userptr pokes into arm direct mapping details to get the
> > resemblance of a dma address for a a physical address that does is
> > not backed by a page struct.  Not only is this not portable to other
> > architectures with dma direct mapping offsets, but also not to uses
> > of IOMMUs of any kind.  Switch to the proper dma_map_resource /
> > dma_unmap_resource interface instead.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> There are checks for IOMMU presence in other places in vb2-dma-contig,
> so it was used only when no IOMMU is available, but I agree that the
> hacky code should be replaced by a generic code if possible.
> 
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> V4L2 pipeline works fine on older Exynos-based boards with CMA and IOMMU
> disabled.

Do you know if these rely on the offsets?  E.g. would they still work
with the patch below applied on top.  That would keep the map_resource
semantics as-is as solve the issue pointed out by Robin for now.

If not I can only think of a flag to bypass the offseting for now, but
that would be pretty ugly.  Or go for the long-term solution of
discovering the relationship between the two devices, as done by the
PCIe P2P code..

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 8e0359b04957..25bd19974223 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -359,7 +359,7 @@ EXPORT_SYMBOL(dma_direct_map_sg);
 dma_addr_t dma_direct_map_resource(struct device *dev, phys_addr_t paddr,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	dma_addr_t dma_addr = phys_to_dma(dev, paddr);
+	dma_addr_t dma_addr = paddr;
 
 	if (unlikely(!dma_direct_possible(dev, dma_addr, size))) {
 		report_addr(dev, dma_addr, size);

