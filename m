Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7EBC43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 08:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DC93218E2
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 08:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mMlR30Ny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732992AbeLUIOH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 03:14:07 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48506 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732939AbeLUIOG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 03:14:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xj8v9RiCbsYFgncrU2PXgIx0psdaYzSXHjjjO5PYYDk=; b=mMlR30NyrMrmYfpBUO82lGYR1
        Q18NYmKiGGVfpsJ9GRadPhfVQ9QJO+dBjiqGVmB1B8H7GqjVyjxhB/84x9CzEGoUeKAag9uCkk70S
        dVCUjthvBBH0LMaEB9+cIXafXBG7jBIy2NxEKu8jEMlKAfBlPvuAf2OX/iDrmUKXjDv0gt0/U+l4V
        7vXphmaPJobkLr91Pik7s5CchCARLNQmiI5tbEl5H5TERiQZR+JLynokQBiBSmfNvJq1HYDPlHb7e
        xEH48Ycj8ElbCfWPrwEu5lZzrCGP3HQ7mu5a6KSI8FQIMc74IjhBlMGxeKeiKmCJijsZW9waLvkfa
        EctBE5gHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gaFwV-0005p4-Le; Fri, 21 Dec 2018 08:13:59 +0000
Date:   Fri, 21 Dec 2018 00:13:59 -0800
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
Message-ID: <20181221081359.GA14707@infradead.org>
References: <20181213140329.GA25339@infradead.org>
 <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
 <20181214123624.GA5824@infradead.org>
 <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
 <20181218073847.GA4552@infradead.org>
 <CAAFQd5AT3ixnbZRm3TOjoWrk2UNH0bXqgR+Z8wyjMhr0xHtSOg@mail.gmail.com>
 <20181219075150.GA26656@infradead.org>
 <CAAFQd5DJPDpFDxU_m2r02bA59J8RCHW7iE8zYQUmkL4sFSz05Q@mail.gmail.com>
 <20181219145122.GA31947@infradead.org>
 <CAAFQd5CsX-YJdwQUS+eEK6kj1xU94AiGHY0QX=QGnf67JcKyaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5CsX-YJdwQUS+eEK6kj1xU94AiGHY0QX=QGnf67JcKyaQ@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 20, 2018 at 12:23:46PM +0900, Tomasz Figa wrote:
> I haven't been following the problems with virtually tagged cases,
> would you mind sharing some background, so that we can consider it
> when adding non-consistent allocations to VB2?

The problem exists at least partially with the current consistent
allocator, and we need to fix it.  My non-coherent series does not have
it, but we would add it if we allowed virtual remapping.

The problem with get_sgtable is that it creates aliasing of kernel
virtual addresses used to access memory and thus the cache.  We have
the mapping return from dma_alloc_*, which in case of a remap contains
a vmap/ioremap style address that is different from the kernel direct
mapping address you get from using page_address/kmap on the pages
backing that mapping.  (assuming you even have pages - in a few corner
cases we don't and the whole interface concept breaks down).

This creates various problems as the the scatterlist returned from
get_stable now gives a second way to access this memory through direct
mapping addresses in the pages contained in it, but as soon as we do
that we:

 a) don't use the nocache mapping used by the coherent allocator if that
    is on a per-mapping basis (which it is for many architectures), so
    you do get data in the cache even when that might not be assumed
 b) if the data returned from dma_alloc_coherent was not actually a
    remap but a special pool of non-cached address the cache flushing
    instructions might be invalid and caused problems
 c) any cache flushing now operates on just those direct mappings, which
    in case of the non-coherent allocator and access through the
    remapped address does the wrong thing for virtually tagged caches
