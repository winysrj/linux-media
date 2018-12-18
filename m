Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473ABC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 07:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16254214C6
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 07:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eTElaZPL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbeLRHi5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 02:38:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34004 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbeLRHi5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 02:38:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WzeH3TUgsIdeLiBDUJctOAhNPrFwEjE+QueOyLQxYCA=; b=eTElaZPLrVJKh7nAcsbB19+hi
        okOtAo88127AYLlij5sJfivLV5Qm1pFzx21H7kEPs6nNwPIPjhrIi+ij3MQ6KiF5m8jhoT9W7dO/P
        O24o6fsY317KwhPDxmioC9e2q7fNWSIIizZFU0aYjLeieLSQBGPSzMhK8aDKOSph5mwZlWaAMyBaL
        1wsavnj3gLgV9AgZca3bmIXsPYw+awCJv9MQpHgY+uxsAYu0EPuUvCA8U/1EeL8a8uuCNU3BFv+gM
        4EVxTtFyJynyR9dh6+/MMlS/ApHxQCzbQqDp2CxvMDbP7r6R5a94RPjQCdBAuYsQGmuWWrDKs6wgi
        7bft4M1HQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZ9xn-0002fj-Bx; Tue, 18 Dec 2018 07:38:47 +0000
Date:   Mon, 17 Dec 2018 23:38:47 -0800
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
Message-ID: <20181218073847.GA4552@infradead.org>
References: <20181207152502.GA30455@infradead.org>
 <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
 <20181212090917.GA30598@infradead.org>
 <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
 <20181212135440.GA6137@infradead.org>
 <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
 <20181213140329.GA25339@infradead.org>
 <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
 <20181214123624.GA5824@infradead.org>
 <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 18, 2018 at 04:22:43PM +0900, Tomasz Figa wrote:
> It kind of limits the usability of this API, since it enforces
> contiguous allocations even for big sizes even for devices behind
> IOMMU (contrary to the case when DMA_ATTR_NON_CONSISTENT is not set),
> but given that it's just a temporary solution for devices like these
> USB cameras, I guess that's fine.

The problem is that you can't have flexibility and simplicity at the
same time.  Once you use kernel virtual address remapping you need to
be prepared to have multiple segments.

So as I said you can call dma_alloc_attrs with DMA_ATTR_NON_CONSISTENT
in a loop with a suitably small chunk size, then stuff the results into
a scatterlist and map that again for the device share with if you don't
want a single contigous region.  You just have to either deal with
non-contigous access from the kernel or use vmap and the right vmap
cache flushing helpers.

> Note that in V4L2 we use the DMA API extensively, so that we don't
> need to embed any device-specific or integration-specific knowledge in
> the framework. Right now we're using dma_alloc_attrs() with
> driver-provided attrs [1], but current driver never request
> non-consistent memory. We're however thinking about making it possible
> to allocate non-consistent memory. What would you suggest for this?
> 
> [1] https://elixir.bootlin.com/linux/v4.20-rc7/source/drivers/media/common/videobuf2/videobuf2-dma-contig.c#L139

I would advice against new non-consistent users until this series
goes through, mostly because dma_cache_sync is such an amazing bad
API.  Otherwise things will just work at the allocation side, you'll
just need to be careful to transfer ownership between the cpu and
the device(s) carefully using the dma_sync_* APIs.
