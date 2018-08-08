Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33168 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbeHHSsX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 14:48:23 -0400
Received: by mail-yw1-f65.google.com with SMTP id c135-v6so1993299ywa.0
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 09:27:56 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id z190-v6sm2728370ywz.89.2018.08.08.09.27.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Aug 2018 09:27:55 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id r3-v6so1984708ywc.5
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 09:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <Pine.LNX.4.44L0.1808081015110.1466-100000@iolanthe.rowland.org> <1959555.Z0pJAWgXVZ@avalon>
In-Reply-To: <1959555.Z0pJAWgXVZ@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 9 Aug 2018 01:27:42 +0900
Message-ID: <CAAFQd5AFSFKeMhdpW5PusrtcvD1f9DSu7_MQQyy6fB=HbHvVLw@mail.gmail.com>
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before processing
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, keiichiw@chromium.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Douglas Anderson <dianders@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 9, 2018 at 1:21 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hello,
>
> On Wednesday, 8 August 2018 17:20:21 EEST Alan Stern wrote:
> > On Wed, 8 Aug 2018, Keiichi Watanabe wrote:
> > > Hi Laurent, Kieran, Tomasz,
> > >
> > > Thank you for reviews and suggestions.
> > > I want to do additional measurements for improving the performance.
> > >
> > > Let me clarify my understanding:
> > > Currently, if the platform doesn't support coherent-DMA (e.g. ARM),
> > > urb_buffer is allocated by usb_alloc_coherent with
> > > URB_NO_TRANSFER_DMA_MAP flag instead of using kmalloc.
> >
> > Not exactly.  You are mixing up allocation with mapping.  The speed of
> > the allocation doesn't matter; all that matters is whether the memory
> > is cached and when it gets mapped/unmapped.
> >
> > > This is because we want to avoid frequent DMA mappings, which are
> > > generally expensive. However, memories allocated in this way are not
> > > cached.
> > >
> > > So, we wonder if using usb_alloc_coherent is really fast.
> > > In other words, we want to know which is better:
> > > "No DMA mapping/Uncached memory" v.s. "Frequent DMA mapping/Cached
> > > memory".
>
> The second option should also be split in two:
>
> - cached memory with DMA mapping/unmapping around each transfer
> - cached memory with DMA mapping/unmapping at allocation/free time, and DMA
> sync around each transfer
>
> The second option should in theory lead to at least slightly better
> performances, but tests with the pwc driver have reported contradictory
> results. I'd like to know whether that's also the case with the uvcvideo
> driver, and if so, why.

I thought that the results from retesting on pwc, after making sure
that cpu frequency stays the same all the time, actually clarified
this and indeed map once, sync repeatedly was the fastest?

Best regards,
Tomasz
