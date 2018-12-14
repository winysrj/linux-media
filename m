Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 856E1C67839
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 12:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DC6A208E7
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 12:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ryNQmOc1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DC6A208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbeLNMga (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 07:36:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58246 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730362AbeLNMg3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 07:36:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gethElgK4t4uthIH0qKj11ax8WB7r9nnrelsz3eSwtk=; b=ryNQmOc1MuVg0deN9P4dvCWsx
        r8yb0koMWs1RdnpRrJ2v80NSTpua4n7y0QDugZqzH9MHlIf9E5eC3mCRWIfeaByYnrWapYyG58q4S
        S2Mxuk5VMVMM1Me4ZgwwkXXlvusSC6M7/iyxWUikjokdjTPVezcaJ4uW8vw4cxy5R/cfQcYfMeC5O
        kw5wujH1aWtHGsdDw1XX+bz3ETvS2VLa+XFFjntrToHUNMyLAKZsXER6d082wuIfVol9JNcTtk0dp
        N1MTwmGsaEOvUxYSIagDzCxsi7zBQ86nUjU/BiLxtOx0JEechOkopkDRZetfHNkx2wOtCkPJ7wwsf
        85gUM/LXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXmhd-0002zl-0r; Fri, 14 Dec 2018 12:36:25 +0000
Date:   Fri, 14 Dec 2018 04:36:24 -0800
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
Message-ID: <20181214123624.GA5824@infradead.org>
References: <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon>
 <20181207152502.GA30455@infradead.org>
 <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
 <20181212090917.GA30598@infradead.org>
 <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
 <20181212135440.GA6137@infradead.org>
 <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
 <20181213140329.GA25339@infradead.org>
 <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 14, 2018 at 12:12:38PM +0900, Tomasz Figa wrote:
> > If the buffer always is physically contiguous, as it is in the currently
> > posted series, we can always map it with a single dma_map_single call
> > (if the hardware can handle that in a single segment is a different
> > question, but out of scope here).
> 
> Are you sure the buffer is always physically contiguous? At least the
> ARM IOMMU dma_ops [1] and the DMA-IOMMU dma_ops [2] will simply
> allocate pages without any continuity guarantees and remap the pages
> into a contiguous kernel VA (unless DMA_ATTR_NO_KERNEL_MAPPING is
> given, which makes them return an opaque cookie instead of the kernel
> VA).
> 
> [1] http://git.infradead.org/users/hch/misc.git/blob/2dbb028e4a3017e1b71a6ae3828a3548545eba24:/arch/arm/mm/dma-mapping.c#l1291
> [2] http://git.infradead.org/users/hch/misc.git/blob/2dbb028e4a3017e1b71a6ae3828a3548545eba24:/drivers/iommu/dma-iommu.c#l450

We never end up in this allocator for the new DMA_ATTR_NON_CONSISTENT
case, and that is intentional.
