Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:36577 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727092AbeHDQrc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2018 12:47:32 -0400
Date: Sat, 4 Aug 2018 10:46:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, <mingo@redhat.com>,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        <keiichiw@chromium.org>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
In-Reply-To: <CAJs94EZA=o5=4frPhXs3vnr4x-__gSZ2ximvTyugLoaD6KLcUg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1808041045060.25853-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 4 Aug 2018, Matwey V. Kornilov wrote:

> 2018-07-30 18:35 GMT+03:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > Hi Matwey,
> >
> > On Tuesday, 24 July 2018 21:56:09 EEST Matwey V. Kornilov wrote:
> >> 2018-07-23 21:57 GMT+03:00 Alan Stern:
> >> > On Mon, 23 Jul 2018, Matwey V. Kornilov wrote:
> >> >> I've tried to strategies:
> >> >>
> >> >> 1) Use dma_unmap and dma_map inside the handler (I suppose this is
> >> >> similar to how USB core does when there is no URB_NO_TRANSFER_DMA_MAP)
> >> >
> >> > Yes.
> >> >
> >> >> 2) Use sync_cpu and sync_device inside the handler (and dma_map only
> >> >> once at memory allocation)
> >> >>
> >> >> It is interesting that dma_unmap/dma_map pair leads to the lower
> >> >> overhead (+1us) than sync_cpu/sync_device (+2us) at x86_64 platform.
> >> >> At armv7l platform using dma_unmap/dma_map  leads to ~50 usec in the
> >> >> handler, and sync_cpu/sync_device - ~65 usec.
> >> >>
> >> >> However, I am not sure is it mandatory to call
> >> >> dma_sync_single_for_device for FROM_DEVICE direction?
> >> >
> >> > According to Documentation/DMA-API-HOWTO.txt, the CPU should not write
> >> > to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is
> >> > not needed.
> >>
> >> Well, I measured the following at armv7l. The handler execution time
> >> (URB_NO_TRANSFER_DMA_MAP is used for all cases):
> >>
> >> 1) coherent DMA: ~3000 usec (pwc is not functional)
> >> 2) explicit dma_unmap and dma_map in the handler: ~52 usec
> >> 3) explicit dma_sync_single_for_cpu (no dma_sync_single_for_device): ~56
> >> usec
> >
> > I really don't understand why the sync option is slower. Could you please
> > investigate ? Before doing anything we need to make sure we have a full
> > understanding of the problem.
> 
> Hi,
> 
> I've found one drawback in my measurements. I forgot to fix CPU
> frequency at lowest state 300MHz. Now, I remeasured
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
> 
> So, now we see that 2A and 3A (as well as 2B and 3B) agree good within
> error ranges.

Taken together, those measurements look like a pretty good argument for 
always using dma_sync_single_for_cpu in the driver.  Provided results 
on other platforms aren't too far out of line with these results.

Alan Stern
