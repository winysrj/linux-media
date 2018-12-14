Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CDCC65BAE
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 03:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 719B020879
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 03:12:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IGSSdUc6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 719B020879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbeLNDMx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 22:12:53 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35073 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbeLNDMx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 22:12:53 -0500
Received: by mail-yw1-f68.google.com with SMTP id h32so1748787ywk.2
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 19:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6chvDpYuKOUdNKAhe8SqsSGz5gKVHREizTUjW93gBBA=;
        b=IGSSdUc6+P3lkRXfOyEfw7/1isV/6KpGPmHELrENxMdUc1FplkWRDfhO2ubD52uRYD
         E8LBvKkk24JMp5/qxdO5aW11YgW57cMtQuiQRRamCy2xj/6J+q82hbEl6f9hDxEE78fr
         ZY/h5FK5Hox0VeSHXp5IuvafDSDqjQihnqX9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6chvDpYuKOUdNKAhe8SqsSGz5gKVHREizTUjW93gBBA=;
        b=nkraH/fmOr/g9s2lGnb9cayO+nOjAX+z15IH5Fkp3ySY2zKEJucrwefyvWgnSB308R
         /eA+Q5v37cF+3Nybq++keIEUCGuBsn1M0UFegyWPT8PlpZAzjnQliFcI9umb1OEXV0nZ
         i7i2bunIDneJwKzQ566ZwidC9gLOzCeqqchShAaMZx4ZNMmv04rzdS69DZFC8iq7o2vw
         k1ArXsTCXpWKrtd3rl8CanHtFF1l7Ua+an4EAO2VgrPknfNbU5lESrfuzzDDLncg85Rj
         9lUEY6Bcuz8Il6af0nDKbZt6qdUwL0z6oJCS98K8sqJuFO4keMd1Bksv5Rgg25mGabzY
         8CtA==
X-Gm-Message-State: AA+aEWbqiGJZeeuusVbRGFOajJE+tPHybD0MMXTJVoXAFu+4chRDoFhq
        CkONI6xPF8ApYulrswWrQiWrTFCrwHw=
X-Google-Smtp-Source: AFSGD/Uii0ULIkbDkPKG0T9ucutHKAOIzNQ6CNO4En/NgdmoGHz1Ds9UuJstTDKHMOzaLN8K64RLAQ==
X-Received: by 2002:a81:6a04:: with SMTP id f4mr1381271ywc.485.1544757171959;
        Thu, 13 Dec 2018 19:12:51 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id w77sm1117757ywa.9.2018.12.13.19.12.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 19:12:51 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id d136so1708849ybh.10
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 19:12:50 -0800 (PST)
X-Received: by 2002:a25:84c6:: with SMTP id x6mr1366869ybm.293.1544757170391;
 Thu, 13 Dec 2018 19:12:50 -0800 (PST)
MIME-Version: 1.0
References: <20180821170629.18408-1-matwey@sai.msu.ru> <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon> <20181207152502.GA30455@infradead.org>
 <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
 <20181212090917.GA30598@infradead.org> <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
 <20181212135440.GA6137@infradead.org> <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
 <20181213140329.GA25339@infradead.org>
In-Reply-To: <20181213140329.GA25339@infradead.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 14 Dec 2018 12:12:38 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
Message-ID: <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 11:03 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Dec 13, 2018 at 12:13:29PM +0900, Tomasz Figa wrote:
> > Putting aside the problem of memory without struct page, one thing to
> > note here that what is a contiguous DMA range for device X, may not be
> > mappable contiguously for device Y and it would still need something
> > like a scatter list to fully describe the buffer.
>
> I think we need to define contiguous here.
>
> If the buffer always is physically contiguous, as it is in the currently
> posted series, we can always map it with a single dma_map_single call
> (if the hardware can handle that in a single segment is a different
> question, but out of scope here).

Are you sure the buffer is always physically contiguous? At least the
ARM IOMMU dma_ops [1] and the DMA-IOMMU dma_ops [2] will simply
allocate pages without any continuity guarantees and remap the pages
into a contiguous kernel VA (unless DMA_ATTR_NO_KERNEL_MAPPING is
given, which makes them return an opaque cookie instead of the kernel
VA).

[1] http://git.infradead.org/users/hch/misc.git/blob/2dbb028e4a3017e1b71a6ae3828a3548545eba24:/arch/arm/mm/dma-mapping.c#l1291
[2] http://git.infradead.org/users/hch/misc.git/blob/2dbb028e4a3017e1b71a6ae3828a3548545eba24:/drivers/iommu/dma-iommu.c#l450

>
> If on the other hand we have multiple discontiguous physical address
> range that are mapped using the iommu and vmap this interface doesn't
> work anyway.
>
> But in that case you should just do multiple allocations and then use
> dma_map_sg coalescing on the hardware side, and vmap [1] if really
> needed.  I guess for this we want to gurantee that dma_alloc_attrs
> with the DMA_ATTR_NON_CONSISTENT allows virt_to_page to be used on
> the return value, which the currently posted implementation does,
> although I'm a it reluctant about the API guarantee.
>
>
> > Do we already have a structure that would work for this purposes? I'd
> > assume that we need something like the existing scatterlist but with
> > page links replaced with something that doesn't require the memory to
> > have struct page, possibly just PFN?
>
> The problem is that just the PFN / physical address isn't enough for
> most use cases as you also need a kernel virtual address.  But moving
> struct scatterlist to store a pfn instead of a struct page would be
> pretty nice for various reasons anyway.
>
> >
> > >
> > > It would also be great to use that opportunity to get rid of all the
> > > code duplication of almost the same dmabug provides backed by the
> > > DMA API.
> >
> > Could you sched some more light on this? I'm curious what is the code
> > duplication you're referring to.
>
> It seems like a lot of the dmabuf ops are just slight various of
> dma_alloc + dma_get_sttable + dma_map_sg / dma_unmap_sg.  There must be
> a void to not duplicate that over and over.

Device/kernel/userspace maps/unmaps shouldn't really be
exporter-specific indeed, as long as one provides a uniform way of
describing a buffer and then have dma_map_*() work on that. Possibly a
part that manages the CPU cache maintenance either. There is still
some space for some special device caches (or other synchronization),
though.

>
> [1] and use invalidate_kernel_vmap_range and flush_kernel_vmap_range
>     to manually take care of cache flushing.
