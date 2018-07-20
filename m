Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:43587 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbeGTMVi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 08:21:38 -0400
Received: by mail-yb0-f195.google.com with SMTP id x10-v6so4490449ybl.10
        for <linux-media@vger.kernel.org>; Fri, 20 Jul 2018 04:33:48 -0700 (PDT)
Received: from mail-yb0-f171.google.com (mail-yb0-f171.google.com. [209.85.213.171])
        by smtp.gmail.com with ESMTPSA id i125-v6sm718423ywd.92.2018.07.20.04.33.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Jul 2018 04:33:46 -0700 (PDT)
Received: by mail-yb0-f171.google.com with SMTP id c10-v6so4492897ybf.9
        for <linux-media@vger.kernel.org>; Fri, 20 Jul 2018 04:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <eb2b495fe7e8bbeaf3f9e2814be4923583482852.camel@collabora.com>
 <Pine.LNX.4.44L0.1807171643120.1344-100000@iolanthe.rowland.org>
 <CAAFQd5D4YHOkMhyTmpPzpp9aPNoZtJMHgU1xmvb4PoPRaOFrbg@mail.gmail.com> <CAJs94EY4x7GWuT1tF4cPquLRDFR060CuZAxS75nhOf0deYbG2w@mail.gmail.com>
In-Reply-To: <CAJs94EY4x7GWuT1tF4cPquLRDFR060CuZAxS75nhOf0deYbG2w@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 20 Jul 2018 20:33:33 +0900
Message-ID: <CAAFQd5Bwokm4GH5qXTDFCyH=cN2T-r5bR4F036-TGA+CK77MCA@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>, hdegoede@redhat.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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

On Fri, Jul 20, 2018 at 8:23 PM Matwey V. Kornilov <matwey@sai.msu.ru> wrote:
>
> 2018-07-20 13:55 GMT+03:00 Tomasz Figa <tfiga@chromium.org>:
> > On Wed, Jul 18, 2018 at 5:51 AM Alan Stern <stern@rowland.harvard.edu> wrote:
> >>
> >> On Tue, 17 Jul 2018, Ezequiel Garcia wrote:
> >>
> >> > Hi Matwey,
> >> >
> >> > First of all, sorry for the delay.
> >> >
> >> > Adding Alan and Hans. Guys, do you have any feedback here?
> >>
> >> ...
> >>
> >> > > > So, what is the benefit of using consistent
> >> > > > for these URBs, as opposed to streaming?
> >> > >
> >> > > I don't know, I think there is no real benefit and all we see is a
> >> > > consequence of copy-pasta when some webcam drivers were inspired by
> >> > > others and development priparily was going at x86 platforms.
> >> >
> >> > You are probably right about the copy-pasta.
> >> >
> >> > >  It would
> >> > > be great if somebody corrected me here. DMA Coherence is quite strong
> >> > > property and I cannot figure out how can it help when streaming video.
> >> > > The CPU host always reads from the buffer and never writes to.
> >> > > Hardware perepherial always writes to and never reads from. Moreover,
> >> > > buffer access is mutually exclusive and separated in time by Interrupt
> >> > > fireing and URB starting (when we reuse existing URB for new request).
> >> > > Only single one memory barrier is really required here.
> >> > >
> >> >
> >> > Yeah, and not setting URB_NO_TRANSFER_DMA_MAP makes the USB core
> >> > create DMA mappings and use the streaming API. Which makes more
> >> > sense in hardware without hardware coherency.
> >>
> >> As far as I know, the _only_ advantage to using coherent DMA in this
> >> situation is that you then do not have to pay the overhead of
> >> constantly setting up and tearing down the streaming mappings.  So it
> >> depends very much on the platform: If coherent buffers are cached then
> >> it's a slight win and otherwise it's a big lose.
> >
> > Isn't it about usb_alloc_coherent() being backed by DMA coherent API
> > (dma_alloc_coherent/attrs()) and ending up allocating uncached (or
> > write-combine) memory for devices with non-coherent DMAs? I'm not sure
>
> Yes, this is what exactly happens at armv7l platforms.

Okay, thanks. So this seems to be exactly the same thing that is
happening in the UVC driver. There is quite a bit of random accesses
to extract some header fields and then a big memcpy into VB2 buffer to
assemble final frame.

If we don't want to pay the cost of creating and destroying the
streaming mapping, we could map (dma_map_single()) once, set
transfer_dma of URB and URB_NO_TRANSFER_DMA_MAP and then just
synchronize the caches (dma_sync_single()) before submitting/after
completing the URB.

Best regards,
Tomasz
