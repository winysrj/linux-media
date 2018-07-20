Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:38460 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbeGTKXd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 06:23:33 -0400
MIME-Version: 1.0
In-Reply-To: <31826cf1b99fa2372cd4cf0b6cee8ba0ba4288f1.camel@collabora.com>
References: <20180617143625.32133-1-matwey@sai.msu.ru> <20180617143625.32133-2-matwey@sai.msu.ru>
 <c02f92a8998fc62d3e3d48aa154fbaa7e223dd10.camel@collabora.com>
 <CAJs94EavBDcFHpd0KcCZJTgWf0JC=AEDY=X8b3P2nZvt8mBCPA@mail.gmail.com>
 <eb2b495fe7e8bbeaf3f9e2814be4923583482852.camel@collabora.com>
 <CAJs94EZjTLLCN=oy3aapMsbLEHU69iO9yq=hXdm4_G1H2UMcyQ@mail.gmail.com> <31826cf1b99fa2372cd4cf0b6cee8ba0ba4288f1.camel@collabora.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Fri, 20 Jul 2018 12:35:49 +0300
Message-ID: <CAJs94EZgww6Ez+O74=qL8g0HdpbfTPjZbcoikcnzUtBOk2-Vxw@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>, hverkuil@xs4all.nl,
        mchehab@kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        linux-media@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-07-20 2:36 GMT+03:00 Ezequiel Garcia <ezequiel@collabora.com>:
> On Wed, 2018-07-18 at 15:10 +0300, Matwey V. Kornilov wrote:
>> 2018-07-17 23:10 GMT+03:00 Ezequiel Garcia <ezequiel@collabora.com>:
>> > Hi Matwey,
>> >
>> > First of all, sorry for the delay.
>> >
>> > Adding Alan and Hans. Guys, do you have any feedback here?
>> >
>> > See below for some feedback on my side.
>> >
>> > On Mon, 2018-06-18 at 10:10 +0300, Matwey V. Kornilov wrote:
>> > > Hi Ezequiel,
>> > >
>> > > 2018-06-18 8:11 GMT+03:00 Ezequiel Garcia <ezequiel@collabora.com>:
>> > > > + Laurent
>> > > >
>> > > > On Sun, 2018-06-17 at 17:36 +0300, Matwey V. Kornilov wrote:
>> > > > > DMA cocherency slows the transfer down on systems without hardware
>> > > > > coherent DMA.
>> > > > >
>> > > > > Based on previous commit the following performance benchmarks have been
>> > > > > carried out. Average memcpy() data transfer rate (rate) and handler
>> > > > > completion time (time) have been measured when running video stream at
>> > > > > 640x480 resolution at 10fps.
>> > > > >
>> > > > > x86_64 based system (Intel Core i5-3470). This platform has hardware
>> > > > > coherent DMA support and proposed change doesn't make big difference here.
>> > > > >
>> > > > >  * kmalloc:            rate = (4.4 +- 1.0) GBps
>> > > > >                        time = (2.4 +- 1.2) usec
>> > > > >  * usb_alloc_coherent: rate = (4.1 +- 0.9) GBps
>> > > > >                        time = (2.5 +- 1.0) usec
>> > > > >
>> > > > > We see that the measurements agree well within error ranges in this case.
>> > > > > So no performance downgrade is introduced.
>> > > > >
>> > > > > armv7l based system (TI AM335x BeagleBone Black). This platform has no
>> > > > > hardware coherent DMA support. DMA coherence is implemented via disabled
>> > > > > page caching that slows down memcpy() due to memory controller behaviour.
>> > > > >
>> > > > >  * kmalloc:            rate =  (190 +-  30) MBps
>> > > > >                        time =   (50 +-  10) usec
>> > > > >  * usb_alloc_coherent: rate =   (33 +-   4) MBps
>> > > > >                        time = (3000 +- 400) usec
>> > > > >
>> > > > > Note, that quantative difference leads (this commit leads to 5 times
>> > > > > acceleration) to qualitative behavior change in this case. As it was
>> > > > > stated before, the video stream can not be successfully received at AM335x
>> > > > > platforms with MUSB based USB host controller due to performance issues
>> > > > > [1].
>> > > > >
>> > > > > [1] https://www.spinics.net/lists/linux-usb/msg165735.html
>> > > > >
>> > > >
>> > > > This is quite interesting! I have receive similar complaints
>> > > > from users wanting to use stk1160 on BBB and Raspberrys,
>> > > > without much luck on either, due to insufficient isoc bandwidth.
>> > > >
>> > > > I'm guessing other ARM platforms could be suffering
>> > > > from the same issue.
>> > > >
>> > > > Note that stk1160 and uvcvideo drivers use kmalloc on platforms
>> > > > where DMA_NONCOHERENT is defined, but this is not the case
>> > > > on ARM platforms.
>> > >
>> > > There are some ARMv7 platforms that have coherent DMA (for instance
>> > > Broadcome Horthstar Plus series), but the most of them don't have. It
>> > > is defined in device tree file, and there is no way to recover this
>> > > information at runtime in USB perepherial driver.
>> > >
>> > > >
>> > > > So, what is the benefit of using consistent
>> > > > for these URBs, as opposed to streaming?
>> > >
>> > > I don't know, I think there is no real benefit and all we see is a
>> > > consequence of copy-pasta when some webcam drivers were inspired by
>> > > others and development priparily was going at x86 platforms.
>> >
>> > You are probably right about the copy-pasta.
>> >
>> > >  It would
>> > > be great if somebody corrected me here. DMA Coherence is quite strong
>> > > property and I cannot figure out how can it help when streaming video.
>> > > The CPU host always reads from the buffer and never writes to.
>> > > Hardware perepherial always writes to and never reads from. Moreover,
>> > > buffer access is mutually exclusive and separated in time by Interrupt
>> > > fireing and URB starting (when we reuse existing URB for new request).
>> > > Only single one memory barrier is really required here.
>> > >
>> >
>> > Yeah, and not setting URB_NO_TRANSFER_DMA_MAP makes the USB core
>> > create DMA mappings and use the streaming API. Which makes more
>> > sense in hardware without hardware coherency.
>> >
>> > The only thing that bothers me with this patch is that it's not
>> > really something specific to this driver. If this fix is valid
>> > for pwc, then it's valid for all the drivers allocating coherent
>> > memory.
>> >
>> > And also, this path won't prevent further copy-paste spread
>> > of the coherent allocation.
>> >
>> > Is there any chance we can introduce a helper to allocate
>> > isoc URBs, and then change all drivers to use it? No need
>> > to do all of them now, but it would be good to at least have
>> > a plan for it.
>>
>> Well, basically I am agree with you.
>> However, I don't have all possible hardware to test, so I can't fix
>> all possible drivers.
>
> Sure. And keep in mind this is more about the USB host controller,
> than about this specific driver. So it's the controller what we
> would have to test!
>
>> Also I can not figure out how could the helper looked like. What do
>> you think about usb_alloc() (c.f. usb_alloc_coherent()) ?
>>
>
> I do not know that either. But it's something we can think about.
>
> Meanwhile, it would be a shame to loose or stall this excellent
> effort (which is effectively enabling a cameras on a bunch of devices).
>
> How about you introduce a driver parameter (or device attribute),
> to avoid changing the behavior for USB host controllers we don't know
> about?

It would be fine for me, if there are no objections. I know that some
maintainers don't like module parameters per se.

>
> Something like 'alloc_coherent_urbs=y/n'. Perhaps set that
> to 'yes' by default in x86, and 'no' by default in the rest?
>
> We can think about a generic solution later.
>
> Thanks,
> Eze
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
