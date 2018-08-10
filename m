Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45830 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbeHJMSS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 08:18:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Subject: Re: [PATCH v4 2/2] media: usb: pwc: Don't use coherent DMA buffers for ISO transfer
Date: Fri, 10 Aug 2018 12:49:53 +0300
Message-ID: <66694963.VB7x4V86dC@avalon>
In-Reply-To: <CAJs94EajH_J268GnxygeTZXOjcTuJq+VG7g+ZfAzf0Rf8Wgkbw@mail.gmail.com>
References: <20180809181103.15437-1-matwey@sai.msu.ru> <2131343.ieGLTDdppT@avalon> <CAJs94EajH_J268GnxygeTZXOjcTuJq+VG7g+ZfAzf0Rf8Wgkbw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matwey,

On Friday, 10 August 2018 12:38:39 EEST Matwey V. Kornilov wrote:
> 2018-08-10 11:53 GMT+03:00 Laurent Pinchart:
> > On Thursday, 9 August 2018 21:11:03 EEST Matwey V. Kornilov wrote:
> >> DMA cocherency slows the transfer down on systems without hardware
> >> coherent DMA.
> >> Instead we use noncocherent DMA memory and explicit sync at data receive
> >> handler.
> >> 
> >> Based on previous commit the following performance benchmarks have been
> >> carried out. Average memcpy() data transfer rate (rate) and handler
> >> completion time (time) have been measured when running video stream at
> >> 640x480 resolution at 10fps.
> >> 
> >> x86_64 based system (Intel Core i5-3470). This platform has hardware
> >> coherent DMA support and proposed change doesn't make big difference
> >> here.
> >> 
> >>  * kmalloc:            rate = (2.0 +- 0.4) GBps
> >>                        time = (5.0 +- 3.0) usec
> >>  
> >>  * usb_alloc_coherent: rate = (3.4 +- 1.2) GBps
> >>                        time = (3.5 +- 3.0) usec
> >> 
> >> We see that the measurements agree within error ranges in this case.
> >> So theoretically predicted performance downgrade cannot be reliably
> >> measured here.
> >> 
> >> armv7l based system (TI AM335x BeagleBone Black @ 300MHz). This platform
> >> has no hardware coherent DMA support. DMA coherence is implemented via
> >> disabled page caching that slows down memcpy() due to memory controller
> >> behaviour.
> >> 
> >>  * kmalloc:            rate =  (114 +- 5) MBps
> >>  
> >>                        time =   (84 +- 4) usec
> >>  
> >>  * usb_alloc_coherent: rate = (28.1 +- 0.1) MBps
> >>  
> >>                        time =  (341 +- 2) usec
> >> 
> >> Note, that quantative difference leads (this commit leads to 4 times
> >> acceleration) to qualitative behavior change in this case. As it was
> >> stated before, the video stream cannot be successfully received at AM335x
> >> platforms with MUSB based USB host controller due to performance issues
> >> [1].
> >> 
> >> [1] https://www.spinics.net/lists/linux-usb/msg165735.html
> >> 
> >> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> >> ---
> >> 
> >> drivers/media/usb/pwc/pwc-if.c | 56 +++++++++++++++++++++++++++++-------
> >> 1 file changed, 44 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/drivers/media/usb/pwc/pwc-if.c
> >> b/drivers/media/usb/pwc/pwc-if.c index 72d2897a4b9f..e9c826be1ba6 100644
> >> --- a/drivers/media/usb/pwc/pwc-if.c
> >> +++ b/drivers/media/usb/pwc/pwc-if.c

[snip]

> >> @@ -306,6 +332,11 @@ static void pwc_isoc_handler(struct urb *urb)
> >> 
> >>       /* Reset ISOC error counter. We did get here, after all. */
> >>       pdev->visoc_errors = 0;
> >> 
> >> +     dma_sync_single_for_cpu(&urb->dev->dev,
> >> +                             urb->transfer_dma,
> >> +                             urb->transfer_buffer_length,
> >> +                             DMA_FROM_DEVICE);
> >> +
> > 
> > Aren't you're missing a dma_sync_single_for_device() call before
> > submitting the URB ? IIRC that's required for correct operation of the DMA
> > mapping API on some platforms, depending on the cache architecture. The
> > additional sync can affect performances, so it would be useful to re-run
> > the perf test.
> 
> This was already discussed:
> 
> https://lkml.org/lkml/2018/7/23/1051
> 
> I rely on Alan's reply:
> 
> > According to Documentation/DMA-API-HOWTO.txt, the CPU should not write
> > to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is
> > not needed.

I fully agree that the CPU should not write to the buffer. However, I think 
the sync call is still needed. It's been a long time since I touched this 
area, but IIRC, some cache architectures (VIVT ?) require both cache clean 
before the transfer and cache invalidation after the transfer. On platforms 
where no cache management operation is needed before the transfer in the 
DMA_FROM_DEVICE direction, the dma_sync_*_for_device() calls should be no-ops 
(and if they're not, it's a bug of the DMA mapping implementation).

-- 
Regards,

Laurent Pinchart
