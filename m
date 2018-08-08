Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33252 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbeHHSl7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 14:41:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Keiichi Watanabe <keiichiw@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        kieran.bingham@ideasonboard.com,
        Douglas Anderson <dianders@chromium.org>,
        ezequiel@collabora.com, matwey@sai.msu.ru
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before processing
Date: Wed, 08 Aug 2018 19:22:16 +0300
Message-ID: <1959555.Z0pJAWgXVZ@avalon>
In-Reply-To: <Pine.LNX.4.44L0.1808081015110.1466-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1808081015110.1466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, 8 August 2018 17:20:21 EEST Alan Stern wrote:
> On Wed, 8 Aug 2018, Keiichi Watanabe wrote:
> > Hi Laurent, Kieran, Tomasz,
> > 
> > Thank you for reviews and suggestions.
> > I want to do additional measurements for improving the performance.
> > 
> > Let me clarify my understanding:
> > Currently, if the platform doesn't support coherent-DMA (e.g. ARM),
> > urb_buffer is allocated by usb_alloc_coherent with
> > URB_NO_TRANSFER_DMA_MAP flag instead of using kmalloc.
> 
> Not exactly.  You are mixing up allocation with mapping.  The speed of
> the allocation doesn't matter; all that matters is whether the memory
> is cached and when it gets mapped/unmapped.
> 
> > This is because we want to avoid frequent DMA mappings, which are
> > generally expensive. However, memories allocated in this way are not
> > cached.
> > 
> > So, we wonder if using usb_alloc_coherent is really fast.
> > In other words, we want to know which is better:
> > "No DMA mapping/Uncached memory" v.s. "Frequent DMA mapping/Cached
> > memory".

The second option should also be split in two:

- cached memory with DMA mapping/unmapping around each transfer
- cached memory with DMA mapping/unmapping at allocation/free time, and DMA 
sync around each transfer

The second option should in theory lead to at least slightly better 
performances, but tests with the pwc driver have reported contradictory 
results. I'd like to know whether that's also the case with the uvcvideo 
driver, and if so, why.

> There is no need to wonder.  "Frequent DMA mapping/Cached memory" is
> always faster than "No DMA mapping/Uncached memory".

Is it really, doesn't it depend on the CPU access pattern ?

> The only issue is that on some platform (such as x86) but not others,
> there is a third option: "No DMA mapping/Cached memory".  On platforms
> which support it, this is the fastest option.

-- 
Regards,

Laurent Pinchart
