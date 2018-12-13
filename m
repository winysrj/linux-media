Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BFFC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 14:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1876920849
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 14:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="StbrLesM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1876920849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbeLMODf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:03:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41450 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729568AbeLMODf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 09:03:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/CF9W99XVoYJNDd3+iCcFlq55XNH3VI4Dmssok+metU=; b=StbrLesMyZm3hkPcFR0TlBB1k
        biToAlqNNAU45exC7ziE3x5zylI/5DM2pEuWQbX+3rIujDKvV4nLE6a76ZP9Hr/lZI40Bet7qMKIl
        uP3fxp9jCjilL/goM/EICUSBndGtlO/1Wfa5ICoeaS/XYaonlXuKmrb3c0BF1VwgrMFhBTsvHid7W
        SfxQySuBN38hg/3YQIZAdOK3fARjKc0XymAlAW2zm3VjchDATUpbqTqprgSUcH+2LxaRNI6rTAcNf
        m4boOKC3D79vEuu733ahoW4FoVXLJcxVHMBF9zV5t0N5yDsUCP5vTwgHCrL3px2Qg8J/tzTjW6jyo
        xeKh/YU/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXRaL-0001kl-9S; Thu, 13 Dec 2018 14:03:29 +0000
Date:   Thu, 13 Dec 2018 06:03:29 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>, hdegoede@redhat.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        rostedt@goodmis.org, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Subject: Re: [PATCH v5 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
Message-ID: <20181213140329.GA25339@infradead.org>
References: <20180821170629.18408-1-matwey@sai.msu.ru>
 <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon>
 <20181207152502.GA30455@infradead.org>
 <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
 <20181212090917.GA30598@infradead.org>
 <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
 <20181212135440.GA6137@infradead.org>
 <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 12:13:29PM +0900, Tomasz Figa wrote:
> Putting aside the problem of memory without struct page, one thing to
> note here that what is a contiguous DMA range for device X, may not be
> mappable contiguously for device Y and it would still need something
> like a scatter list to fully describe the buffer.

I think we need to define contiguous here.

If the buffer always is physically contiguous, as it is in the currently
posted series, we can always map it with a single dma_map_single call
(if the hardware can handle that in a single segment is a different
question, but out of scope here).

If on the other hand we have multiple discontiguous physical address
range that are mapped using the iommu and vmap this interface doesn't
work anyway.

But in that case you should just do multiple allocations and then use
dma_map_sg coalescing on the hardware side, and vmap [1] if really
needed.  I guess for this we want to gurantee that dma_alloc_attrs
with the DMA_ATTR_NON_CONSISTENT allows virt_to_page to be used on
the return value, which the currently posted implementation does,
although I'm a it reluctant about the API guarantee.


> Do we already have a structure that would work for this purposes? I'd
> assume that we need something like the existing scatterlist but with
> page links replaced with something that doesn't require the memory to
> have struct page, possibly just PFN?

The problem is that just the PFN / physical address isn't enough for
most use cases as you also need a kernel virtual address.  But moving
struct scatterlist to store a pfn instead of a struct page would be
pretty nice for various reasons anyway.

> 
> >
> > It would also be great to use that opportunity to get rid of all the
> > code duplication of almost the same dmabug provides backed by the
> > DMA API.
> 
> Could you sched some more light on this? I'm curious what is the code
> duplication you're referring to.

It seems like a lot of the dmabuf ops are just slight various of
dma_alloc + dma_get_sttable + dma_map_sg / dma_unmap_sg.  There must be
a void to not duplicate that over and over.

[1] and use invalidate_kernel_vmap_range and flush_kernel_vmap_range
    to manually take care of cache flushing.
