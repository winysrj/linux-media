Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2E2C65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 13:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 106BA20870
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 13:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dEjAtK/h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 106BA20870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbeLLNyt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 08:54:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44172 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbeLLNyt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 08:54:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0w6HLL9FddjM2kztTN34xg1U+TV9TJs+iprBg9j9kAU=; b=dEjAtK/hDzPGDVzsUPf4mJvDT
        YcjTJfZYrRV5UATOuQM33BDbMsHDq2t5NajT8/t6KZzTSQTLY9iDbQsOePi5GhtInxH5SLDV74ZGD
        2OCafh0eNy9Vfq8NBBzbc9jfGXTjVEBS2L+Fj+rj6TDbYR7HrDEu5vCLdls8bmxUz+H5fL/Ug5ByX
        RVfkh+gJ8YP5X+tgN/BpC7GT6qoYG3OYA6KEGgAhTHF3uUr5VuL9XNZnXfnvJjNn9zw9jaz9ba2fV
        g+3q88duRnMCSatNl5do/6OcWfK8gD6j5sJ3RceKJ7OBdcjQ6OAtdh77XzcHQBuwrAFzs0c1doDgC
        k3za48Xxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gX4yH-0003W4-4a; Wed, 12 Dec 2018 13:54:41 +0000
Date:   Wed, 12 Dec 2018 05:54:40 -0800
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
Message-ID: <20181212135440.GA6137@infradead.org>
References: <20180821170629.18408-1-matwey@sai.msu.ru>
 <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon>
 <20181207152502.GA30455@infradead.org>
 <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
 <20181212090917.GA30598@infradead.org>
 <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 12, 2018 at 06:34:25PM +0900, Tomasz Figa wrote:
> The typical DMA-buf import/export flow is as follows:
> 1) Driver X allocates buffer A using this API for device x and gets a
> DMA address inside x's DMA (or IOVA) address space.
> 2) Driver X creates a dma_buf D(A), backed by buffer A and gives the
> user space process a file descriptor FD(A) referring to it.
> 3) Driver Y gets FD(A) from the user space and needs to map it into
> the DMA/IOVA address space of device y. It doe it by calling
> dma_buf_map_attachment() which returns an sg_table describing the
> mapping.

And just as I said last time I think we need to fix the dmabuf code
to not rely on struct scatterlist.  struct scatterlist is an interface
that is fundamentally page based, while the dma coherent allocator
only gives your a kernel virtual and dma address (and the option to
map the buffer into userspace).  So we need to fix to get the interface
right as we already have DMAable memory withour a struct page and we
are bound to get more of those.  Nevermind all the caching implications
even if we have a struct page.

It would also be great to use that opportunity to get rid of all the
code duplication of almost the same dmabug provides backed by the
DMA API.
