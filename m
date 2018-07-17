Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46550 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1729757AbeGQVZf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 17:25:35 -0400
Date: Tue, 17 Jul 2018 16:51:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ezequiel Garcia <ezequiel@collabora.com>
cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Hans de Goede <hdegoede@redhat.com>, <hverkuil@xs4all.nl>,
        <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <rostedt@goodmis.org>, <mingo@redhat.com>, <isely@pobox.com>,
        <bhumirks@gmail.com>, <colin.king@canonical.com>,
        <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
In-Reply-To: <eb2b495fe7e8bbeaf3f9e2814be4923583482852.camel@collabora.com>
Message-ID: <Pine.LNX.4.44L0.1807171643120.1344-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Jul 2018, Ezequiel Garcia wrote:

> Hi Matwey,
> 
> First of all, sorry for the delay.
> 
> Adding Alan and Hans. Guys, do you have any feedback here?

...

> > > So, what is the benefit of using consistent
> > > for these URBs, as opposed to streaming?
> > 
> > I don't know, I think there is no real benefit and all we see is a
> > consequence of copy-pasta when some webcam drivers were inspired by
> > others and development priparily was going at x86 platforms.
> 
> You are probably right about the copy-pasta.
> 
> >  It would
> > be great if somebody corrected me here. DMA Coherence is quite strong
> > property and I cannot figure out how can it help when streaming video.
> > The CPU host always reads from the buffer and never writes to.
> > Hardware perepherial always writes to and never reads from. Moreover,
> > buffer access is mutually exclusive and separated in time by Interrupt
> > fireing and URB starting (when we reuse existing URB for new request).
> > Only single one memory barrier is really required here.
> > 
> 
> Yeah, and not setting URB_NO_TRANSFER_DMA_MAP makes the USB core
> create DMA mappings and use the streaming API. Which makes more
> sense in hardware without hardware coherency.

As far as I know, the _only_ advantage to using coherent DMA in this
situation is that you then do not have to pay the overhead of
constantly setting up and tearing down the streaming mappings.  So it
depends very much on the platform: If coherent buffers are cached then
it's a slight win and otherwise it's a big lose.

Alan Stern
