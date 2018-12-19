Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C107FC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 07:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CE6221850
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 07:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vjr7hpPO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbeLSHv4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 02:51:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46632 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbeLSHvz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 02:51:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=E8s0pTXCClRjqdCV/nUnzdAXumVNkERnmd8w/qjr6Eo=; b=Vjr7hpPOXwFuR4XENuWTBnhHa
        dtZLoxBJNx8NNfpsuf/FyqY0aR0g6TuViDPcutmXiKFfBRK669hj1v9qiXh8LiayBVTCT2IIjlzx9
        XYIgzqgdkvB8HqfzK4SkqYIejKlqPoDF22GWP75OJ4UXQz8s14vKwtuxCdvzbTdYSSO6zOyQy5Qu6
        7DA93lXUnHYctUQRyqArMQs5/Ye5OvhU4F7CijO9ZdHIZ6G95yEp2Kgm1dtYlavFWGBd5BXiXEK2C
        5myP1wLZFR+J0Zi1CK54JB8p48xy1HPbAYMpQqPcGbnFwZckiZ5zmVMyEdL4aGoWF4rKNucr71VNn
        t1hNq8hBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZWdy-0000Qs-Ux; Wed, 19 Dec 2018 07:51:50 +0000
Date:   Tue, 18 Dec 2018 23:51:50 -0800
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
Message-ID: <20181219075150.GA26656@infradead.org>
References: <20181212090917.GA30598@infradead.org>
 <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
 <20181212135440.GA6137@infradead.org>
 <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
 <20181213140329.GA25339@infradead.org>
 <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
 <20181214123624.GA5824@infradead.org>
 <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
 <20181218073847.GA4552@infradead.org>
 <CAAFQd5AT3ixnbZRm3TOjoWrk2UNH0bXqgR+Z8wyjMhr0xHtSOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5AT3ixnbZRm3TOjoWrk2UNH0bXqgR+Z8wyjMhr0xHtSOg@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 18, 2018 at 06:48:03PM +0900, Tomasz Figa wrote:
> > So as I said you can call dma_alloc_attrs with DMA_ATTR_NON_CONSISTENT
> > in a loop with a suitably small chunk size, then stuff the results into
> > a scatterlist and map that again for the device share with if you don't
> > want a single contigous region.  You just have to either deal with
> > non-contigous access from the kernel or use vmap and the right vmap
> > cache flushing helpers.
> 
> The point is that you didn't have to do this small chunk loop without
> DMA_ATTR_NON_CONSISTENT, so it's at least inconsistent now and not
> sure why it could be better than just a loop of alloc_page().

You have to do it if you want to map the addresses for a second device.

> > I would advice against new non-consistent users until this series
> > goes through, mostly because dma_cache_sync is such an amazing bad
> > API.  Otherwise things will just work at the allocation side, you'll
> > just need to be careful to transfer ownership between the cpu and
> > the device(s) carefully using the dma_sync_* APIs.
> 
> Just to clarify, the actual code isn't very likely to surface any time
> soon. so I assume it would be after this series lands.
> 
> We will however need an API that can transparently handle both cases
> of contiguous (without IOMMU) and page-by-page allocations (with
> IOMMU) behind the scenes, like the current dma_alloc_attrs() without
> DMA_ATTR_NON_CONSISTENT.

Is the use case to then share the memory between multiples devices
or just for a single device?  The latter case is generally easy, the
former is rather more painful.
