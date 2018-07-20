Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:37844 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727675AbeGTMKp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 08:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAAFQd5D4YHOkMhyTmpPzpp9aPNoZtJMHgU1xmvb4PoPRaOFrbg@mail.gmail.com>
References: <eb2b495fe7e8bbeaf3f9e2814be4923583482852.camel@collabora.com>
 <Pine.LNX.4.44L0.1807171643120.1344-100000@iolanthe.rowland.org> <CAAFQd5D4YHOkMhyTmpPzpp9aPNoZtJMHgU1xmvb4PoPRaOFrbg@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Fri, 20 Jul 2018 14:22:37 +0300
Message-ID: <CAJs94EY4x7GWuT1tF4cPquLRDFR060CuZAxS75nhOf0deYbG2w@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
To: Tomasz Figa <tfiga@chromium.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-07-20 13:55 GMT+03:00 Tomasz Figa <tfiga@chromium.org>:
> On Wed, Jul 18, 2018 at 5:51 AM Alan Stern <stern@rowland.harvard.edu> wrote:
>>
>> On Tue, 17 Jul 2018, Ezequiel Garcia wrote:
>>
>> > Hi Matwey,
>> >
>> > First of all, sorry for the delay.
>> >
>> > Adding Alan and Hans. Guys, do you have any feedback here?
>>
>> ...
>>
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
>>
>> As far as I know, the _only_ advantage to using coherent DMA in this
>> situation is that you then do not have to pay the overhead of
>> constantly setting up and tearing down the streaming mappings.  So it
>> depends very much on the platform: If coherent buffers are cached then
>> it's a slight win and otherwise it's a big lose.
>
> Isn't it about usb_alloc_coherent() being backed by DMA coherent API
> (dma_alloc_coherent/attrs()) and ending up allocating uncached (or
> write-combine) memory for devices with non-coherent DMAs? I'm not sure

Yes, this is what exactly happens at armv7l platforms.

> how this memory is used by this driver, but if it reads from it using
> CPU, uncached mapping might be significantly slower than cached
> mapping of memory allocated with kmalloc().
>
> Best regards,
> Tomasz
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
