Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758DCC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 08:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 375472184A
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 08:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Z3mUSPpM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbeLSIZC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 03:25:02 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:33916 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbeLSIZC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 03:25:02 -0500
Received: by mail-yb1-f195.google.com with SMTP id k136so7594739ybk.1
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 00:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xhHRctd/XqQnCYeEth+JKGS9rV5kdfu9x8MbR/nYHqA=;
        b=Z3mUSPpMBqrVISWypSsUV3Uk7yalWO+6tVXRckFg0hFhHekN9Go+A8p1WcSRDadDVJ
         tY73oeOzdvEyF+QrGrIzRpOMpUJ1Kj4CLNTIjopc6pbdSdELm6l8GIbofaNrmjxnkEKz
         +m5axO0v9jVp+ueBvx7W2goRn5L3Hy/RZQLIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xhHRctd/XqQnCYeEth+JKGS9rV5kdfu9x8MbR/nYHqA=;
        b=cdbGCz9w0DOqMoOuw+Ja7poyiBF2h2B4NQfChPPaUR1qMRakFu4TF/ISCzPJ3EoMtw
         G/vjoizDnYQaNwC/xYqnoRT4L/iUaZIewMb25TdU+Ra9CeDvUE9OES6e/sJsEw8j2Tl4
         v9pLC1PpR30X60UKeS/SJ99KGNvWiOagv6Hq6wzhoxVaIOwdhjYm7KZ9gnoXkeCYNht7
         sqpUlJllZpWWAQLSGJWuetVQ4W232v8NLyXl6741mIBe6P6gWveWBRNyi1r2/QDxEIE2
         8f7axCRQ9AvL/HJKQf8wawWx6eGRim+Yfks9AyXzzbD25g5+YjvN7LEAKUlaEORgRF04
         8/3A==
X-Gm-Message-State: AA+aEWb5aCkbVMcEixHWS44hwg0dpvyMpW4grbf4uHzN+TpYcwAlMk9U
        XWKlYnAM7Q1gzxuzjzC2aQKooVI6HVU=
X-Google-Smtp-Source: AFSGD/WqP19Au5LS1MyN64S1VlGCnmvawpDByarQOKZMz+VzWDeTlahSb5xG1Rj9RNnQSW8jGpdi3w==
X-Received: by 2002:a25:6d8a:: with SMTP id i132mr20217936ybc.16.1545207901079;
        Wed, 19 Dec 2018 00:25:01 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id k62sm5790881ywk.84.2018.12.19.00.25.00
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Dec 2018 00:25:00 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id d187so7571084ybb.5
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 00:25:00 -0800 (PST)
X-Received: by 2002:a25:910f:: with SMTP id v15mr20413719ybl.285.1545207526870;
 Wed, 19 Dec 2018 00:18:46 -0800 (PST)
MIME-Version: 1.0
References: <20181212090917.GA30598@infradead.org> <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
 <20181212135440.GA6137@infradead.org> <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
 <20181213140329.GA25339@infradead.org> <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
 <20181214123624.GA5824@infradead.org> <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
 <20181218073847.GA4552@infradead.org> <CAAFQd5AT3ixnbZRm3TOjoWrk2UNH0bXqgR+Z8wyjMhr0xHtSOg@mail.gmail.com>
 <20181219075150.GA26656@infradead.org>
In-Reply-To: <20181219075150.GA26656@infradead.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 19 Dec 2018 17:18:35 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DJPDpFDxU_m2r02bA59J8RCHW7iE8zYQUmkL4sFSz05Q@mail.gmail.com>
Message-ID: <CAAFQd5DJPDpFDxU_m2r02bA59J8RCHW7iE8zYQUmkL4sFSz05Q@mail.gmail.com>
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

On Wed, Dec 19, 2018 at 4:51 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Dec 18, 2018 at 06:48:03PM +0900, Tomasz Figa wrote:
> > > So as I said you can call dma_alloc_attrs with DMA_ATTR_NON_CONSISTENT
> > > in a loop with a suitably small chunk size, then stuff the results into
> > > a scatterlist and map that again for the device share with if you don't
> > > want a single contigous region.  You just have to either deal with
> > > non-contigous access from the kernel or use vmap and the right vmap
> > > cache flushing helpers.
> >
> > The point is that you didn't have to do this small chunk loop without
> > DMA_ATTR_NON_CONSISTENT, so it's at least inconsistent now and not
> > sure why it could be better than just a loop of alloc_page().
>
> You have to do it if you want to map the addresses for a second device.
>

The existing code that deals with dma_alloc_attrs() without
DMA_ATTR_NON_CONSISTENT would just call dma_get_sgtable_attrs() like
here:

https://elixir.bootlin.com/linux/v4.20-rc7/source/drivers/media/common/videobuf2/videobuf2-dma-contig.c#L366

and then dma_map_sg() for the other device like here;

https://elixir.bootlin.com/linux/v4.20-rc7/source/drivers/media/common/videobuf2/videobuf2-dma-contig.c#L283

> > > I would advice against new non-consistent users until this series
> > > goes through, mostly because dma_cache_sync is such an amazing bad
> > > API.  Otherwise things will just work at the allocation side, you'll
> > > just need to be careful to transfer ownership between the cpu and
> > > the device(s) carefully using the dma_sync_* APIs.
> >
> > Just to clarify, the actual code isn't very likely to surface any time
> > soon. so I assume it would be after this series lands.
> >
> > We will however need an API that can transparently handle both cases
> > of contiguous (without IOMMU) and page-by-page allocations (with
> > IOMMU) behind the scenes, like the current dma_alloc_attrs() without
> > DMA_ATTR_NON_CONSISTENT.
>
> Is the use case to then share the memory between multiples devices
> or just for a single device?  The latter case is generally easy, the
> former is rather more painful.

The former, but the convention has been to assume that the userspace
will choose the right (the most constrained typically) device to
allocate from or otherwise handle the import failure (e.g. by falling
back to copying into a buffer allocated from the importer).

Best regards,
Tomasz
