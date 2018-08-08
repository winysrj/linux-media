Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38744 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731015AbeHIA4Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 20:56:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        kieran.bingham@ideasonboard.com,
        Douglas Anderson <dianders@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>, matwey@sai.msu.ru
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before processing
Date: Thu, 09 Aug 2018 01:35:13 +0300
Message-ID: <2864865.ZqDiYThxxv@avalon>
In-Reply-To: <CAAEAJfASOfP5tMuiBtufVbH91MNHgeTqpbmyc42igSnEKMxO1Q@mail.gmail.com>
References: <Pine.LNX.4.44L0.1808081015110.1466-100000@iolanthe.rowland.org> <1959555.Z0pJAWgXVZ@avalon> <CAAEAJfASOfP5tMuiBtufVbH91MNHgeTqpbmyc42igSnEKMxO1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On Wednesday, 8 August 2018 19:29:56 EEST Ezequiel Garcia wrote:
> On 8 August 2018 at 13:22, Laurent Pinchart wrote:
> > On Wednesday, 8 August 2018 17:20:21 EEST Alan Stern wrote:
> >> On Wed, 8 Aug 2018, Keiichi Watanabe wrote:
> >>> Hi Laurent, Kieran, Tomasz,
> >>> 
> >>> Thank you for reviews and suggestions.
> >>> I want to do additional measurements for improving the performance.
> >>> 
> >>> Let me clarify my understanding:
> >>> Currently, if the platform doesn't support coherent-DMA (e.g. ARM),
> >>> urb_buffer is allocated by usb_alloc_coherent with
> >>> URB_NO_TRANSFER_DMA_MAP flag instead of using kmalloc.
> >> 
> >> Not exactly.  You are mixing up allocation with mapping.  The speed of
> >> the allocation doesn't matter; all that matters is whether the memory
> >> is cached and when it gets mapped/unmapped.
> >> 
> >>> This is because we want to avoid frequent DMA mappings, which are
> >>> generally expensive. However, memories allocated in this way are not
> >>> cached.
> >>> 
> >>> So, we wonder if using usb_alloc_coherent is really fast.
> >>> In other words, we want to know which is better:
> >>> "No DMA mapping/Uncached memory" v.s. "Frequent DMA mapping/Cached
> >>> memory".
> > 
> > The second option should also be split in two:
> > 
> > - cached memory with DMA mapping/unmapping around each transfer
> > - cached memory with DMA mapping/unmapping at allocation/free time, and
> > DMA sync around each transfer
> 
> I agree with this, the second one should be better.
> 
> I still wonder if there is anyway we can create a helper for this,
> as I am under the impression most USB video4linux drivers
> will want to implement the same.

I agree with you, drivers shouldn't care.

> > The second option should in theory lead to at least slightly better
> > performances, but tests with the pwc driver have reported contradictory
> > results. I'd like to know whether that's also the case with the uvcvideo
> > driver, and if so, why.
> 
> I believe that is no longer the case. Matwey measured again and the results
> are what we expected: a single mapping, and sync in the interrupt handler
> is a little bit faster. See https://lkml.org/lkml/2018/8/4/44
> 
> 2) dma_unmap and dma_map in the handler:
> 2A) dma_unmap_single call: 28.8 +- 1.5 usec
> 2B) memcpy and the rest: 58 +- 6 usec
> 2C) dma_map_single call: 22 +- 2 usec
> Total: 110 +- 7 usec
> 
> 3) dma_sync_single_for_cpu
> 3A) dma_sync_single_for_cpu call: 29.4 +- 1.7 usec
> 3B) memcpy and the rest: 59 +- 6 usec
> 3C) noop (trace events overhead): 5 +- 2 usec
> Total: 93 +- 7 usec

I hadn't caught up with the pwc e-mail thread, I now have, and I'm happy to 
see that everything is now properly understood. Thanks again Matwey for your 
work.

-- 
Regards,

Laurent Pinchart
