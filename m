Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:54499 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1753452AbeAGPlj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 Jan 2018 10:41:39 -0500
Date: Sun, 7 Jan 2018 10:41:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
cc: Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        <torvalds@linux-foundation.org>
Subject: Re: dvb usb issues since kernel 4.9
In-Reply-To: <20180107090336.03826df2@vento.lan>
Message-ID: <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 7 Jan 2018, Mauro Carvalho Chehab wrote:

> > > It seems that the original patch were designed to solve some IRQ issues
> > > with network cards with causes data losses on high traffic. However,
> > > it is also causing bad effects on sustained high bandwidth demands
> > > required by DVB cards, at least on some USB host drivers.
> > > 
> > > Alan/Greg/Eric/David:
> > > 
> > > Any ideas about how to fix it without causing regressions to
> > > network?  
> > 
> > It would be good to know what hardware was involved on the x86 system
> > and to have some timing data.  Can we see the output from lsusb and
> > usbmon, running on a vanilla kernel that gets plenty of video glitches?
> 
> From Josef's report, and from the BZ, the affected hardware seems
> to be based on Montage Technology M88DS3103/M88TS2022 chipset.

What type of USB host controller does the x86_64 system use?  EHCI or
xHCI?

> The driver it uses is at drivers/media/usb/dvb-usb-v2/dvbsky.c,
> with shares a USB implementation that is used by a lot more drivers.
> The URB handling code is at:
> 
> 	drivers/media/usb/dvb-usb-v2/usb_urb.c
> 
> This particular driver allocates 8 buffers with 4096 bytes each
> for bulk transfers, using transfer_flags = URB_NO_TRANSFER_DMA_MAP.
> 
> This become a popular USB hardware nowadays. I have one S960c
> myself, so I can send you the lsusb from it. You should notice, however,
> that a DVB-C/DVB-S2 channel can easily provide very high sustained bit
> rates. Here, on my DVB-S2 provider, a typical transponder produces 58 Mpps
> of payload after removing URB headers.

You mentioned earlier that the driver uses bulk transfers.  In USB-2.0,
the maximum possible payload data transfer rate using bulk transfers is
53248 bytes/ms, which is 53.248 MB/s (i.e., lower than 58 MB/s).  And
even this is possible only if almost nothing else is using the bus at
the same time.

> A 10 minutes record with the
> entire data (with typically contains 5-10 channels) can easily go
> above 4 GB, just to reproduce 1-2 glitches. So, I'm not sure if
> a usbmon dump would be useful.

It might not be helpful at all.  However, I'm not interested in the 
payload data (which would be unintelligible to me anyway) but rather 
the timing of URB submissions and completions.  A usbmon trace which 
didn't keep much of the payload data would only require on the order of 
50 MB per minute -- and Josef said that glitches usually would show up 
within a minute or so.

> I'm enclosing the lsusb from a S960C device, with is based on those
> Montage chipsets:

What I wanted to see was the output from "lsusb" on the affected
system, not the output from "lsusb -v -s B:D" on your system.

> > Overall, this may be a very difficult problem to solve.  The
> > 4cd13c21b207 commit was intended to improve throughput at the cost of
> > increased latency.  But then what do you do when the latency becomes
> > too high for the video subsystem to handle?
> 
> Latency can't be too high, otherwise frames will be dropped.

Yes, that's the whole point.

> Even if the Kernel itself doesn't drop, if the delay goes higher
> than a certain threshold, userspace will need to drop, as it
> should be presenting audio and video on real time. Yet, typically,
> userspace will delay it by one or two seconds, with would mean
> 1500-3500 buffers, with I suspect it is a lot more than the hardware
> limits. So I suspect that the hardware starves free buffers a way 
> before userspace, as media hardware don't have unlimited buffers
> inside them, as they assume that the Kernel/userspace will be fast
> enough to sustain bit rates up to 66 Mbps of payload.

The timing information would tell us how large the latency is.

In any case, you might be able to attack the problem simply by using
more than 8 buffers.  With just eight 4096-byte buffers, the total
pipeline capacity is only about 0.62 ms (at the maximum possible
transfer rate).  Increasing the number of buffers to 65 would give a
capacity of 5 ms, which is probably a lot better suited for situations
where completions are handled by the ksoftirqd thread.

> Perhaps media drivers could pass some quirk similar to URB_ISO_ASAP,
> in order to revert the kernel logic to prioritize latency instead of
> throughput.

It can't be done without pervasive changes to the USB subsystem, which
I would greatly prefer to avoid.  Besides, this wouldn't really solve
the problem.  Decreasing the latency for one device will cause it to be
increased for others.

Alan Stern
