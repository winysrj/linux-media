Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39264 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731902AbeISVvb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 17:51:31 -0400
Message-ID: <5216fc0a31c472f260517e78ff3481376b8d88d7.camel@collabora.com>
Subject: Re: [PATCH v5 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
From: Ezequiel Garcia <ezequiel@collabora.com>
To: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Date: Wed, 19 Sep 2018 13:12:45 -0300
In-Reply-To: <CAJs94EZBpUmRXnYRiSHJex+UdLX5tUfW-nxm1bWjy1oQW6vuFQ@mail.gmail.com>
References: <20180821170629.18408-1-matwey@sai.msu.ru>
         <20180821170629.18408-3-matwey@sai.msu.ru>
         <CAJs94EZ5Qh8q3tEABmH89NjDkA=jjzsB63yctRGdEqcvJTnASA@mail.gmail.com>
         <CAJs94EZBpUmRXnYRiSHJex+UdLX5tUfW-nxm1bWjy1oQW6vuFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-09-11 at 21:58 +0300, Matwey V. Kornilov wrote:
> вт, 28 авг. 2018 г. в 10:17, Matwey V. Kornilov <matwey.kornilov@gmail.com>:
> > 
> > вт, 21 авг. 2018 г. в 20:06, Matwey V. Kornilov <matwey@sai.msu.ru>:
> > > 
> > > DMA cocherency slows the transfer down on systems without hardware
> > > coherent DMA.
> > > Instead we use noncocherent DMA memory and explicit sync at data receive
> > > handler.
> > > 
> > > Based on previous commit the following performance benchmarks have been
> > > carried out. Average memcpy() data transfer rate (rate) and handler
> > > completion time (time) have been measured when running video stream at
> > > 640x480 resolution at 10fps.
> > > 
> > > x86_64 based system (Intel Core i5-3470). This platform has hardware
> > > coherent DMA support and proposed change doesn't make big difference here.
> > > 
> > >  * kmalloc:            rate = (2.0 +- 0.4) GBps
> > >                        time = (5.0 +- 3.0) usec
> > >  * usb_alloc_coherent: rate = (3.4 +- 1.2) GBps
> > >                        time = (3.5 +- 3.0) usec
> > > 
> > > We see that the measurements agree within error ranges in this case.
> > > So theoretically predicted performance downgrade cannot be reliably
> > > measured here.
> > > 
> > > armv7l based system (TI AM335x BeagleBone Black @ 300MHz). This platform
> > > has no hardware coherent DMA support. DMA coherence is implemented via
> > > disabled page caching that slows down memcpy() due to memory controller
> > > behaviour.
> > > 
> > >  * kmalloc:            rate =  (114 +- 5) MBps
> > >                        time =   (84 +- 4) usec
> > >  * usb_alloc_coherent: rate = (28.1 +- 0.1) MBps
> > >                        time =  (341 +- 2) usec
> > > 
> > > Note, that quantative difference leads (this commit leads to 4 times
> > > acceleration) to qualitative behavior change in this case. As it was
> > > stated before, the video stream cannot be successfully received at AM335x
> > > platforms with MUSB based USB host controller due to performance issues
> > > [1].
> > > 
> > > [1] https://www.spinics.net/lists/linux-usb/msg165735.html
> > > 
> > > Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> > 
> > Ping
> > 

We are already using slab buffers in em28xx, so I think this change
makes sense, until we have proper a non-coherent allocation API.

Acked-by: Ezequiel Garcia <ezequiel@collabora.com>

Thanks a lot Matwey for your work.
