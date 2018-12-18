Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59474C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 09:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 273DC21841
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 09:54:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="b4A8P6kv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbeLRJyA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 04:54:00 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:34345 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbeLRJyA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 04:54:00 -0500
Received: by mail-yb1-f195.google.com with SMTP id k136so6265526ybk.1
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 01:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UOsg+T9I/Y86s/PmwPeCfAyfVgMDr1qGlTe10iB9Nc=;
        b=b4A8P6kvelHDkeipf6OBBIxE03WGVA3w2tLBZcmtG14lVV2+kQDxfGigyYElhQ9XDn
         jw1pd8RixJ2ZVU661DdrR4n83gJj2xO5wTNY9hy4/xHNUAISCRIqwWIJxRe1APCXGLk4
         nrLpF+/QI8YudK3frQ2cnf4psylojCWxZM4eI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UOsg+T9I/Y86s/PmwPeCfAyfVgMDr1qGlTe10iB9Nc=;
        b=K1vHWdsOauvGwhToaZXKJdFFtY2v+SXLw5gWYTVNM8CMpvip8MlgBSYPt/8ZmokAWO
         uwg7TFlO9hQQELWWEcCQjTO6o83IWju5ajJrPdGtFUAPn/kmh0GazmZ3W9IedO5iUjHL
         h/jjsfWg1Cu4wjGq77lSXPNQHlom6COBjL0aNGtC8/ZkB1VbCC0F45WikbprE9kzPaeq
         AV1wsZpk/fRHL37QEQkcoBcP5bnNQAa9FDefcRs5snUAFbn6I38GEA2qgf9Oge3x6Aei
         kE7zoxGYwi4Le6IdRWw1n9zTDWQP2026KqMru1lFmakMws6kd5wg9KBxXzM4gdaCeTAA
         sopA==
X-Gm-Message-State: AA+aEWYSdnUmK64oEhFdplc+sGUPh6ZHbxe+ZehgLMZH6dlz1NLrnVks
        e63OD5jObsbXXEA8CtQ2LyMXtwvMXplYWQ==
X-Google-Smtp-Source: AFSGD/WoyfrukMoSrz3O196F3fJxDRq/T9mevnWQrTRyBcL6aFJWBYAhDwMpGb427QvzHOnwNEsrbw==
X-Received: by 2002:a25:1443:: with SMTP id 64mr15962254ybu.223.1545126838977;
        Tue, 18 Dec 2018 01:53:58 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id p201sm6825942ywe.45.2018.12.18.01.53.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 01:53:58 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id a10so2840424ybl.7
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 01:53:58 -0800 (PST)
X-Received: by 2002:a25:9907:: with SMTP id z7mr16484713ybn.114.1545126494341;
 Tue, 18 Dec 2018 01:48:14 -0800 (PST)
MIME-Version: 1.0
References: <20181207152502.GA30455@infradead.org> <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
 <20181212090917.GA30598@infradead.org> <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
 <20181212135440.GA6137@infradead.org> <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
 <20181213140329.GA25339@infradead.org> <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
 <20181214123624.GA5824@infradead.org> <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
 <20181218073847.GA4552@infradead.org>
In-Reply-To: <20181218073847.GA4552@infradead.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 18 Dec 2018 18:48:03 +0900
X-Gmail-Original-Message-ID: <CAAFQd5AT3ixnbZRm3TOjoWrk2UNH0bXqgR+Z8wyjMhr0xHtSOg@mail.gmail.com>
Message-ID: <CAAFQd5AT3ixnbZRm3TOjoWrk2UNH0bXqgR+Z8wyjMhr0xHtSOg@mail.gmail.com>
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

On Tue, Dec 18, 2018 at 4:38 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Dec 18, 2018 at 04:22:43PM +0900, Tomasz Figa wrote:
> > It kind of limits the usability of this API, since it enforces
> > contiguous allocations even for big sizes even for devices behind
> > IOMMU (contrary to the case when DMA_ATTR_NON_CONSISTENT is not set),
> > but given that it's just a temporary solution for devices like these
> > USB cameras, I guess that's fine.
>
> The problem is that you can't have flexibility and simplicity at the
> same time.  Once you use kernel virtual address remapping you need to
> be prepared to have multiple segments.
>
> So as I said you can call dma_alloc_attrs with DMA_ATTR_NON_CONSISTENT
> in a loop with a suitably small chunk size, then stuff the results into
> a scatterlist and map that again for the device share with if you don't
> want a single contigous region.  You just have to either deal with
> non-contigous access from the kernel or use vmap and the right vmap
> cache flushing helpers.

The point is that you didn't have to do this small chunk loop without
DMA_ATTR_NON_CONSISTENT, so it's at least inconsistent now and not
sure why it could be better than just a loop of alloc_page().

>
> > Note that in V4L2 we use the DMA API extensively, so that we don't
> > need to embed any device-specific or integration-specific knowledge in
> > the framework. Right now we're using dma_alloc_attrs() with
> > driver-provided attrs [1], but current driver never request
> > non-consistent memory. We're however thinking about making it possible
> > to allocate non-consistent memory. What would you suggest for this?
> >
> > [1] https://elixir.bootlin.com/linux/v4.20-rc7/source/drivers/media/common/videobuf2/videobuf2-dma-contig.c#L139
>
> I would advice against new non-consistent users until this series
> goes through, mostly because dma_cache_sync is such an amazing bad
> API.  Otherwise things will just work at the allocation side, you'll
> just need to be careful to transfer ownership between the cpu and
> the device(s) carefully using the dma_sync_* APIs.

Just to clarify, the actual code isn't very likely to surface any time
soon. so I assume it would be after this series lands.

We will however need an API that can transparently handle both cases
of contiguous (without IOMMU) and page-by-page allocations (with
IOMMU) behind the scenes, like the current dma_alloc_attrs() without
DMA_ATTR_NON_CONSISTENT.

Best regards,
Tomasz
