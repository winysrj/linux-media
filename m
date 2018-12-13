Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DC4C67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 03:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 526A920873
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 03:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FfMIJow9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 526A920873
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbeLMDNo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 22:13:44 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40370 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbeLMDNo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 22:13:44 -0500
Received: by mail-yb1-f195.google.com with SMTP id e12so237811ybq.7
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2018 19:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MldMfPal7dPKOr4CmHsfYUHEZUZOt1yez2Jjq7koQXo=;
        b=FfMIJow9xXjJOb9uv+S19WVho/xpoSYdlRYljj8NsdspAOdNL73U6VH+gl/3OTmdRQ
         ynJzdHPThQIJ4l/PQWrQuC36P5q2EnvePsoGDEMF3Fx61d1sy8GUptwnACHS+q112Vbo
         YfbkFbVMptj9BV93h65Mhgrl2Ane1hawHzGIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MldMfPal7dPKOr4CmHsfYUHEZUZOt1yez2Jjq7koQXo=;
        b=n8VHeMFKpJ+h5e84h6Ev/uS4YrDeFuhjDIramUWAIhJDty08Qbv8t7abX4rHJZNZjV
         yqI1KOMxuzvrOQ1UVcXulil472qGl6EzR6iDfLrqDTnf3eVGvlaCt390PkwZA6ZzSdPF
         qEHfvWEmJzqKWWndzsNdkVaPKO3I0QlXg979BBD4ioGkqeknX5dMN/TH88uNoBdDGlNL
         CNZPwf8XI6090crK4LSXquuaeVdjvLCXkcRLjbp4dDP/ofgjxU9ljf+feVU0FRW/VR4c
         vw89BgnR94Pgykqg7B/5SQigOIRP2GQQBHI5TrEyYR0hZGEsaNIjwHN2nGLC9ldDrDi4
         oI8w==
X-Gm-Message-State: AA+aEWbJyvz0+kB4i39JnxzqnbVgZHo3w3VmvTKsTxx/KeKarml37hcm
        a0my9EMqoZYdNSFq605pnkGslmeynDF8aQ==
X-Google-Smtp-Source: AFSGD/Ur0Y940p47vrovb1v2VnLCaBX3JmLISvC31XYqLdbfYgK4C+AquoZdHbTT85GV8MxvS6qmdQ==
X-Received: by 2002:a25:8412:: with SMTP id u18mr11680756ybk.182.1544670822534;
        Wed, 12 Dec 2018 19:13:42 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id x4sm377422ywj.80.2018.12.12.19.13.41
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 19:13:41 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id f9so226346ybm.13
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2018 19:13:41 -0800 (PST)
X-Received: by 2002:a25:a44:: with SMTP id 65-v6mr22661413ybk.373.1544670820921;
 Wed, 12 Dec 2018 19:13:40 -0800 (PST)
MIME-Version: 1.0
References: <20180821170629.18408-1-matwey@sai.msu.ru> <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon> <20181207152502.GA30455@infradead.org>
 <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
 <20181212090917.GA30598@infradead.org> <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
 <20181212135440.GA6137@infradead.org>
In-Reply-To: <20181212135440.GA6137@infradead.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 13 Dec 2018 12:13:29 +0900
X-Gmail-Original-Message-ID: <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
Message-ID: <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
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

On Wed, Dec 12, 2018 at 10:54 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Dec 12, 2018 at 06:34:25PM +0900, Tomasz Figa wrote:
> > The typical DMA-buf import/export flow is as follows:
> > 1) Driver X allocates buffer A using this API for device x and gets a
> > DMA address inside x's DMA (or IOVA) address space.
> > 2) Driver X creates a dma_buf D(A), backed by buffer A and gives the
> > user space process a file descriptor FD(A) referring to it.
> > 3) Driver Y gets FD(A) from the user space and needs to map it into
> > the DMA/IOVA address space of device y. It doe it by calling
> > dma_buf_map_attachment() which returns an sg_table describing the
> > mapping.
>
> And just as I said last time I think we need to fix the dmabuf code
> to not rely on struct scatterlist.  struct scatterlist is an interface
> that is fundamentally page based, while the dma coherent allocator
> only gives your a kernel virtual and dma address (and the option to
> map the buffer into userspace).  So we need to fix to get the interface
> right as we already have DMAable memory withour a struct page and we
> are bound to get more of those.  Nevermind all the caching implications
> even if we have a struct page.

Putting aside the problem of memory without struct page, one thing to
note here that what is a contiguous DMA range for device X, may not be
mappable contiguously for device Y and it would still need something
like a scatter list to fully describe the buffer.

Do we already have a structure that would work for this purposes? I'd
assume that we need something like the existing scatterlist but with
page links replaced with something that doesn't require the memory to
have struct page, possibly just PFN?

>
> It would also be great to use that opportunity to get rid of all the
> code duplication of almost the same dmabug provides backed by the
> DMA API.

Could you sched some more light on this? I'm curious what is the code
duplication you're referring to.

Best regards,
Tomasz
