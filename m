Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40758 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbeG3RKm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 13:10:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for ISO transfer
Date: Mon, 30 Jul 2018 18:35:48 +0300
Message-ID: <1556658.LS2rrRvGR3@avalon>
In-Reply-To: <CAJs94EahjbkJRWKR=2QeD=tOMR=kznwXbQgTbKvSuTg4jBk1ew@mail.gmail.com>
References: <CAJs94EZEqWEscECp7bsJ3DvqoU83_Y2WQ55jPaG4MyoG-hvLFQ@mail.gmail.com> <Pine.LNX.4.44L0.1807231444150.1328-100000@iolanthe.rowland.org> <CAJs94EahjbkJRWKR=2QeD=tOMR=kznwXbQgTbKvSuTg4jBk1ew@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matwey,

On Tuesday, 24 July 2018 21:56:09 EEST Matwey V. Kornilov wrote:
> 2018-07-23 21:57 GMT+03:00 Alan Stern:
> > On Mon, 23 Jul 2018, Matwey V. Kornilov wrote:
> >> I've tried to strategies:
> >> 
> >> 1) Use dma_unmap and dma_map inside the handler (I suppose this is
> >> similar to how USB core does when there is no URB_NO_TRANSFER_DMA_MAP)
> > 
> > Yes.
> > 
> >> 2) Use sync_cpu and sync_device inside the handler (and dma_map only
> >> once at memory allocation)
> >> 
> >> It is interesting that dma_unmap/dma_map pair leads to the lower
> >> overhead (+1us) than sync_cpu/sync_device (+2us) at x86_64 platform.
> >> At armv7l platform using dma_unmap/dma_map  leads to ~50 usec in the
> >> handler, and sync_cpu/sync_device - ~65 usec.
> >> 
> >> However, I am not sure is it mandatory to call
> >> dma_sync_single_for_device for FROM_DEVICE direction?
> > 
> > According to Documentation/DMA-API-HOWTO.txt, the CPU should not write
> > to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is
> > not needed.
> 
> Well, I measured the following at armv7l. The handler execution time
> (URB_NO_TRANSFER_DMA_MAP is used for all cases):
> 
> 1) coherent DMA: ~3000 usec (pwc is not functional)
> 2) explicit dma_unmap and dma_map in the handler: ~52 usec
> 3) explicit dma_sync_single_for_cpu (no dma_sync_single_for_device): ~56
> usec

I really don't understand why the sync option is slower. Could you please 
investigate ? Before doing anything we need to make sure we have a full 
understanding of the problem.

> So, I suppose that unfortunately Tomasz suggestion doesn't work. There
> is no performance improvement when dma_sync_single is used.
> 
> At x86_64 the following happens:
> 
> 1) coherent DMA: ~2 usec

What do you mean by coherent DMA for x86_64 ? Is that usb_alloc_coherent() ? 
Could you trace it to see how memory is allocated exactly, and how it's mapped 
to the CPU ? I suspect that it will end up in dma_direct_alloc() but I'd like 
a confirmation.

> 2) explicit dma_unmap and dma_map in the handler: ~3.5 usec
> 3) explicit dma_sync_single_for_cpu (no dma_sync_single_for_device): ~4 usec
> 
> So, whats to do next? Personally, I think that DMA streaming API
> introduces not so great overhead.

It might not be very large, but with USB3 cameras at high resolutions and 
framerates, it might still become noticeable. I wouldn't degrade performances 
on x86, especially if we can decide which option to use based on the platform 
(or perhaps even better based on Kconfig options such as DMA_NONCOHERENT).

> Does anybody happy with turning to streaming DMA or I'll introduce
> module-level switch as Ezequiel suggested?

A module-level switch isn't a good idea, it will just confuse users. We need 
to establish a strategy and come up with a good heuristic that can be applied 
at compile and/or runtime to automatically decide how to allocate buffers.

-- 
Regards,

Laurent Pinchart
