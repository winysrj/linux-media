Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55370 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727069AbeHHTZV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 15:25:21 -0400
Date: Wed, 8 Aug 2018 13:04:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Keiichi Watanabe <keiichiw@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        <kieran.bingham@ideasonboard.com>,
        Douglas Anderson <dianders@chromium.org>,
        <ezequiel@collabora.com>, <matwey@sai.msu.ru>
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before
 processing
In-Reply-To: <1959555.Z0pJAWgXVZ@avalon>
Message-ID: <Pine.LNX.4.44L0.1808081250430.6325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 8 Aug 2018, Laurent Pinchart wrote:

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
> 
> > There is no need to wonder.  "Frequent DMA mapping/Cached memory" is
> > always faster than "No DMA mapping/Uncached memory".
> 
> Is it really, doesn't it depend on the CPU access pattern ?

Well, if your access pattern involves transferring data in from the
device and then throwing it away without reading it, you might get a
different result.  :-)  But assuming you plan to read the data after
transferring it, using uncached memory slows things down so much that
the overhead of DMA mapping/unmapping is negligible by comparison.

The only exception might be if you were talking about very small
amounts of data.  I don't know exactly where the crossover occurs, but
bear in mind that Matwey's tests required ~50 us for mapping/unmapping
and 3000 us for accessing uncached memory.  He didn't say how large the
transfers were, but that's still a pretty big difference.

Alan Stern

> > The only issue is that on some platform (such as x86) but not others,
> > there is a third option: "No DMA mapping/Cached memory".  On platforms
> > which support it, this is the fastest option.
