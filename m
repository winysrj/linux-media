Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A4AC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 07:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50A52214C6
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 07:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mX1EOumc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbeLRH22 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 02:28:28 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:46683 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbeLRH22 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 02:28:28 -0500
Received: by mail-yb1-f193.google.com with SMTP id f9so6101213ybm.13
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2018 23:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rXAbq+7gPg7ftySi18RLKiOZP5ChhlNAMQPad33V3tg=;
        b=mX1EOumciwAlufHq4kC0L/SFQ6FPBBSLMp4Zz4dyUI/cUO+3Vb+vZLK5S6GXWC2vag
         QH+1SLYmb/7MMPajrfD6ThOUALiKhTnAs5pT71BVgXYtCyUdriG+7MSX0DvYo6sQfYZj
         I86CbY6af+3m8NISO7eQZJZOSCLXFFUbPkiis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rXAbq+7gPg7ftySi18RLKiOZP5ChhlNAMQPad33V3tg=;
        b=sskwMaK6KXMihQ0L6QCK2J+m5b99hfBfT/rePuBMmWFfUISwmyfY07dA1GjQ+m7/FL
         wGZzfz27NtkW2/tSoym2D9ZfuHOcF/ABdGxLskRflZVHJYia1D4x+IjEJJkbAGh3q4o/
         RCAtvUwjP05aD3UOxk4RozHB5WNMSlJKxycZZypLzziGHvzZjTnHWgONAyLYmbj08j2+
         z3L+/fSf2tj2yErHhOzGrJ5mWdR5MM2cH9a8cZn0YgLKKIiZw1KieB2XYMLloVIxkcug
         irXfJ7q8AGvVEWL+z7IGvHA7yEB2e+TQtZ4bScbWHPHPLgNnoIpNxAE95O43rIRxvP1B
         JPPg==
X-Gm-Message-State: AA+aEWbTQfiRv2q3SnVxdSJ3lTdna2eEqaW91bjifo0QtQBayrhRMpcr
        HbWpl9+SlC5ENClz9xCJjEllmTqpRO3XYQ==
X-Google-Smtp-Source: AFSGD/V+TmEIV9ovLbJPqzI1Rps6st/5iBWgoNbue6bENYc+a1K8D5zCf5HqdpmnnLdtx+PNfERRtw==
X-Received: by 2002:a25:e095:: with SMTP id x143mr16166467ybg.42.1545118106974;
        Mon, 17 Dec 2018 23:28:26 -0800 (PST)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id x132sm5779610ywx.27.2018.12.17.23.28.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Dec 2018 23:28:26 -0800 (PST)
Received: by mail-yw1-f43.google.com with SMTP id n21so5243270ywd.10
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2018 23:28:26 -0800 (PST)
X-Received: by 2002:a81:3194:: with SMTP id x142mr15655803ywx.92.1545117775088;
 Mon, 17 Dec 2018 23:22:55 -0800 (PST)
MIME-Version: 1.0
References: <20180821170629.18408-3-matwey@sai.msu.ru> <2213616.rQm4DhIJ7U@avalon>
 <20181207152502.GA30455@infradead.org> <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
 <20181212090917.GA30598@infradead.org> <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
 <20181212135440.GA6137@infradead.org> <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
 <20181213140329.GA25339@infradead.org> <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
 <20181214123624.GA5824@infradead.org>
In-Reply-To: <20181214123624.GA5824@infradead.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 18 Dec 2018 16:22:43 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
Message-ID: <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
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

On Fri, Dec 14, 2018 at 9:36 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Dec 14, 2018 at 12:12:38PM +0900, Tomasz Figa wrote:
> > > If the buffer always is physically contiguous, as it is in the currently
> > > posted series, we can always map it with a single dma_map_single call
> > > (if the hardware can handle that in a single segment is a different
> > > question, but out of scope here).
> >
> > Are you sure the buffer is always physically contiguous? At least the
> > ARM IOMMU dma_ops [1] and the DMA-IOMMU dma_ops [2] will simply
> > allocate pages without any continuity guarantees and remap the pages
> > into a contiguous kernel VA (unless DMA_ATTR_NO_KERNEL_MAPPING is
> > given, which makes them return an opaque cookie instead of the kernel
> > VA).
> >
> > [1] http://git.infradead.org/users/hch/misc.git/blob/2dbb028e4a3017e1b71a6ae3828a3548545eba24:/arch/arm/mm/dma-mapping.c#l1291
> > [2] http://git.infradead.org/users/hch/misc.git/blob/2dbb028e4a3017e1b71a6ae3828a3548545eba24:/drivers/iommu/dma-iommu.c#l450
>
> We never end up in this allocator for the new DMA_ATTR_NON_CONSISTENT
> case, and that is intentional.

It kind of limits the usability of this API, since it enforces
contiguous allocations even for big sizes even for devices behind
IOMMU (contrary to the case when DMA_ATTR_NON_CONSISTENT is not set),
but given that it's just a temporary solution for devices like these
USB cameras, I guess that's fine.

Note that in V4L2 we use the DMA API extensively, so that we don't
need to embed any device-specific or integration-specific knowledge in
the framework. Right now we're using dma_alloc_attrs() with
driver-provided attrs [1], but current driver never request
non-consistent memory. We're however thinking about making it possible
to allocate non-consistent memory. What would you suggest for this?

[1] https://elixir.bootlin.com/linux/v4.20-rc7/source/drivers/media/common/videobuf2/videobuf2-dma-contig.c#L139

Best regards,
Tomasz
