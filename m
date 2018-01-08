Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37146 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S932867AbeAHQKE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 11:10:04 -0500
Date: Mon, 8 Jan 2018 11:10:03 -0500 (EST)
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
In-Reply-To: <20180108074324.3c153189@vento.lan>
Message-ID: <Pine.LNX.4.44L0.1801081055250.1908-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Jan 2018, Mauro Carvalho Chehab wrote:

> Em Sun, 7 Jan 2018 10:41:37 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> escreveu:
> 
> > On Sun, 7 Jan 2018, Mauro Carvalho Chehab wrote:
> > 
> > > > > It seems that the original patch were designed to solve some IRQ issues
> > > > > with network cards with causes data losses on high traffic. However,
> > > > > it is also causing bad effects on sustained high bandwidth demands
> > > > > required by DVB cards, at least on some USB host drivers.
> > > > > 
> > > > > Alan/Greg/Eric/David:
> > > > > 
> > > > > Any ideas about how to fix it without causing regressions to
> > > > > network?    
> > > > 
> > > > It would be good to know what hardware was involved on the x86 system
> > > > and to have some timing data.  Can we see the output from lsusb and
> > > > usbmon, running on a vanilla kernel that gets plenty of video glitches?  
> > > 
> > > From Josef's report, and from the BZ, the affected hardware seems
> > > to be based on Montage Technology M88DS3103/M88TS2022 chipset.  
> > 
> > What type of USB host controller does the x86_64 system use?  EHCI or
> > xHCI?
> 
> I'll let Josef answer this.
> 
> > 
> > > The driver it uses is at drivers/media/usb/dvb-usb-v2/dvbsky.c,
> > > with shares a USB implementation that is used by a lot more drivers.
> > > The URB handling code is at:
> > > 
> > > 	drivers/media/usb/dvb-usb-v2/usb_urb.c
> > > 
> > > This particular driver allocates 8 buffers with 4096 bytes each
> > > for bulk transfers, using transfer_flags = URB_NO_TRANSFER_DMA_MAP.
> > > 
> > > This become a popular USB hardware nowadays. I have one S960c
> > > myself, so I can send you the lsusb from it. You should notice, however,
> > > that a DVB-C/DVB-S2 channel can easily provide very high sustained bit
> > > rates. Here, on my DVB-S2 provider, a typical transponder produces 58 Mpps
> > > of payload after removing URB headers.  
> > 
> > You mentioned earlier that the driver uses bulk transfers.  In USB-2.0,
> > the maximum possible payload data transfer rate using bulk transfers is
> > 53248 bytes/ms, which is 53.248 MB/s (i.e., lower than 58 MB/s).  And
> > even this is possible only if almost nothing else is using the bus at
> > the same time.
> 
> No, I said 58 Mbits/s (not bytes).

Well, what you actually _wrote_ was "58 Mpps of payload" (see above),
and I couldn't tell how to interpret that.  :-)

58 Mb/s is obviously almost 8 times less than the full USB bus 
bandwidth.

> On DVB-C and DVB-S2 specs, AFAIKT, there's no hard limit for the maximum
> payload data rate, although industry seems to limit it to be around
> 60 Mbits/s. On those standards, the maximal bit rate is defined by the
> modulation type and by the channel symbol rate.
> 
> To give you a practical example, my DVB-S2 provider modulates each
> transponder with 8/PSK (3 bits/symbol), and define channels with a
> symbol rate of 30 Mbauds/s. So, it could, theoretically, transport
> a MPEG-TS stream up to 90 Mbits/s (minus headers and guard intervals).
> In practice, the streams there are transmitted with 58,026.5 Kbits/s.

Okay.  This is 58 Kb/ms or 7.25 KB/ms.  So your scheme of eight 4-KB 
buffers gives a latency of 0.57 ms with a total capacity of 4.5 ms, 
which is a lot better than what I was thinking.

> > In any case, you might be able to attack the problem simply by using
> > more than 8 buffers.  With just eight 4096-byte buffers, the total
> > pipeline capacity is only about 0.62 ms (at the maximum possible
> > transfer rate).  Increasing the number of buffers to 65 would give a
> > capacity of 5 ms, which is probably a lot better suited for situations
> > where completions are handled by the ksoftirqd thread.
> 
> Increasing it to 65 shouldn't be hard. Not sure, however, if the hardware
> will actually fill the 65 buffers, but it is worth to try.

Given the new information, 65 would be overkill.  But going from 8 to 
16 might help.

> > > Perhaps media drivers could pass some quirk similar to URB_ISO_ASAP,
> > > in order to revert the kernel logic to prioritize latency instead of
> > > throughput.  
> > 
> > It can't be done without pervasive changes to the USB subsystem, which
> > I would greatly prefer to avoid.  Besides, this wouldn't really solve
> > the problem.  Decreasing the latency for one device will cause it to be
> > increased for others.
> 
> If there is a TV streaming traffic at a USB bus, it means that the
> user wants to either watch and/or record a TV program. On such
> usecase scenario, a low latency is highly desired for the TV capture
> (and display, if the GPU is USB), even it means a higher latency for
> other traffic.

Not if the other traffic is also a TV capture.  :-)

It might make sense to classify softirq sources as "high priority" or 
"low priority", and only defer the "low priority" work to ksoftirqd.

Alan Stern
