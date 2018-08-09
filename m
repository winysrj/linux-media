Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44863 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbeHIE7c (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 00:59:32 -0400
Received: by mail-yw1-f65.google.com with SMTP id l9-v6so3167421ywc.11
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 19:37:03 -0700 (PDT)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id d185-v6sm4551376ywf.100.2018.08.08.19.36.59
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Aug 2018 19:37:00 -0700 (PDT)
Received: by mail-yw1-f48.google.com with SMTP id l189-v6so3169310ywb.10
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 19:36:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAJs94EZEqWEscECp7bsJ3DvqoU83_Y2WQ55jPaG4MyoG-hvLFQ@mail.gmail.com>
 <1556658.LS2rrRvGR3@avalon> <CAJs94EZA=o5=4frPhXs3vnr4x-__gSZ2ximvTyugLoaD6KLcUg@mail.gmail.com>
 <1913405.2MshdJEm1G@avalon>
In-Reply-To: <1913405.2MshdJEm1G@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 9 Aug 2018 11:36:46 +0900
Message-ID: <CAAFQd5Bv=WyQ2qK7pNGJFEcQ9PfQgqWVU72K5Zu0SXuG3VQ2fQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>, hdegoede@redhat.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        rostedt@goodmis.org, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 9, 2018 at 7:31 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Matwey,
>
> On Saturday, 4 August 2018 11:00:05 EEST Matwey V. Kornilov wrote:
> > 2018-07-30 18:35 GMT+03:00 Laurent Pinchart:
> > > On Tuesday, 24 July 2018 21:56:09 EEST Matwey V. Kornilov wrote:
> > >> 2018-07-23 21:57 GMT+03:00 Alan Stern:
> > >>> On Mon, 23 Jul 2018, Matwey V. Kornilov wrote:
> > >>>> I've tried to strategies:
> > >>>>
> > >>>> 1) Use dma_unmap and dma_map inside the handler (I suppose this is
> > >>>> similar to how USB core does when there is no URB_NO_TRANSFER_DMA_MAP)
> > >>>
> > >>> Yes.
> > >>>
> > >>>> 2) Use sync_cpu and sync_device inside the handler (and dma_map only
> > >>>> once at memory allocation)
> > >>>>
> > >>>> It is interesting that dma_unmap/dma_map pair leads to the lower
> > >>>> overhead (+1us) than sync_cpu/sync_device (+2us) at x86_64 platform.
> > >>>> At armv7l platform using dma_unmap/dma_map  leads to ~50 usec in the
> > >>>> handler, and sync_cpu/sync_device - ~65 usec.
> > >>>>
> > >>>> However, I am not sure is it mandatory to call
> > >>>> dma_sync_single_for_device for FROM_DEVICE direction?
> > >>>
> > >>> According to Documentation/DMA-API-HOWTO.txt, the CPU should not write
> > >>> to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is
> > >>> not needed.
> > >>
> > >> Well, I measured the following at armv7l. The handler execution time
> > >> (URB_NO_TRANSFER_DMA_MAP is used for all cases):
> > >>
> > >> 1) coherent DMA: ~3000 usec (pwc is not functional)
> > >> 2) explicit dma_unmap and dma_map in the handler: ~52 usec
> > >> 3) explicit dma_sync_single_for_cpu (no dma_sync_single_for_device): ~56
> > >> usec
> > >
> > > I really don't understand why the sync option is slower. Could you please
> > > investigate ? Before doing anything we need to make sure we have a full
> > > understanding of the problem.
> >
> > Hi,
> >
> > I've found one drawback in my measurements. I forgot to fix CPU
> > frequency at lowest state 300MHz. Now, I remeasured
> >
> > 2) dma_unmap and dma_map in the handler:
> > 2A) dma_unmap_single call: 28.8 +- 1.5 usec
> > 2B) memcpy and the rest: 58 +- 6 usec
> > 2C) dma_map_single call: 22 +- 2 usec
> > Total: 110 +- 7 usec
> >
> > 3) dma_sync_single_for_cpu
> > 3A) dma_sync_single_for_cpu call: 29.4 +- 1.7 usec
> > 3B) memcpy and the rest: 59 +- 6 usec
> > 3C) noop (trace events overhead): 5 +- 2 usec
> > Total: 93 +- 7 usec
> >
> > So, now we see that 2A and 3A (as well as 2B and 3B) agree good within
> > error ranges.
>
> Thank you for the time you've spent on these measurements, the information is
> useful and your work very appreciated.
>
> > >> So, I suppose that unfortunately Tomasz suggestion doesn't work. There
> > >> is no performance improvement when dma_sync_single is used.
> > >>
> > >> At x86_64 the following happens:
> > >>
> > >> 1) coherent DMA: ~2 usec
> > >
> > > What do you mean by coherent DMA for x86_64 ? Is that usb_alloc_coherent()
> > > ? Could you trace it to see how memory is allocated exactly, and how it's
> > > mapped to the CPU ? I suspect that it will end up in dma_direct_alloc()
> > > but I'd like a confirmation.
> >
> > usb_alloc_coherents() ends up inside hcd_buffer_alloc() where
> > dma_alloc_coherent() is called. Keep in mind, that requested size is
> > 9560 in our case and pool is not used.
> >
> > >> 2) explicit dma_unmap and dma_map in the handler: ~3.5 usec
> > >> 3) explicit dma_sync_single_for_cpu (no dma_sync_single_for_device): ~4
> > >> usec
> > >>
> > >> So, whats to do next? Personally, I think that DMA streaming API
> > >> introduces not so great overhead.
> > >
> > > It might not be very large, but with USB3 cameras at high resolutions and
> > > framerates, it might still become noticeable. I wouldn't degrade
> > > performances on x86, especially if we can decide which option to use
> > > based on the platform (or perhaps even better based on Kconfig options
> > > such as DMA_NONCOHERENT).
> >
> > PWC is discontinued chip, so there will not be any new USB3 cameras.
>
> You're right. I had in mind other USB cameras that would benefit from the same
> change, and in particular the uvcvideo driver, which is used by USB3 cameras.
>
> > Kconfig won't work here, as I said before, DMA config is stored inside
> > device tree blob on ARM architecture.
>
> But couldn't we skip it at least on x86 ?

If we use the map-once, sync-repeatedly approach, would there be
anything to gain on x86? I believe the sync ops there would be
effectively no-ops, so the only overhead would be of a function call.

Best regards,
Tomasz
