Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54770 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727050AbeHHQkO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 12:40:14 -0400
Date: Wed, 8 Aug 2018 10:20:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Keiichi Watanabe <keiichiw@chromium.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        <kieran.bingham@ideasonboard.com>,
        Douglas Anderson <dianders@chromium.org>,
        <ezequiel@collabora.com>, <matwey@sai.msu.ru>
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before
 processing
In-Reply-To: <CAD90VcbpeVatm33h2QwGnq_him5KkL1b6n8j0D_RyUyRi3osaQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1808081015110.1466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 8 Aug 2018, Keiichi Watanabe wrote:

> Hi Laurent, Kieran, Tomasz,
> 
> Thank you for reviews and suggestions.
> I want to do additional measurements for improving the performance.
> 
> Let me clarify my understanding:
> Currently, if the platform doesn't support coherent-DMA (e.g. ARM),
> urb_buffer is allocated by usb_alloc_coherent with
> URB_NO_TRANSFER_DMA_MAP flag instead of using kmalloc.

Not exactly.  You are mixing up allocation with mapping.  The speed of 
the allocation doesn't matter; all that matters is whether the memory 
is cached and when it gets mapped/unmapped.

> This is because we want to avoid frequent DMA mappings, which are
> generally expensive.
> However, memories allocated in this way are not cached.
> 
> So, we wonder if using usb_alloc_coherent is really fast.
> In other words, we want to know which is better:
> "No DMA mapping/Uncached memory" v.s. "Frequent DMA mapping/Cached memory".

There is no need to wonder.  "Frequent DMA mapping/Cached memory" is 
always faster than "No DMA mapping/Uncached memory".

The only issue is that on some platform (such as x86) but not others,
there is a third option: "No DMA mapping/Cached memory".  On platforms 
which support it, this is the fastest option.

Alan Stern
