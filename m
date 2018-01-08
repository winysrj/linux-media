Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53500 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756236AbeAHJnk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 04:43:40 -0500
Date: Mon, 8 Jan 2018 07:43:24 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josef Griebichler <griebichler.josef@gmx.at>,
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
Message-ID: <20180108074324.3c153189@vento.lan>
In-Reply-To: <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
References: <20180107090336.03826df2@vento.lan>
        <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 7 Jan 2018 10:41:37 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> escreveu:

> On Sun, 7 Jan 2018, Mauro Carvalho Chehab wrote:
> 
> > > > It seems that the original patch were designed to solve some IRQ issues
> > > > with network cards with causes data losses on high traffic. However,
> > > > it is also causing bad effects on sustained high bandwidth demands
> > > > required by DVB cards, at least on some USB host drivers.
> > > > 
> > > > Alan/Greg/Eric/David:
> > > > 
> > > > Any ideas about how to fix it without causing regressions to
> > > > network?    
> > > 
> > > It would be good to know what hardware was involved on the x86 system
> > > and to have some timing data.  Can we see the output from lsusb and
> > > usbmon, running on a vanilla kernel that gets plenty of video glitches?  
> > 
> > From Josef's report, and from the BZ, the affected hardware seems
> > to be based on Montage Technology M88DS3103/M88TS2022 chipset.  
> 
> What type of USB host controller does the x86_64 system use?  EHCI or
> xHCI?

I'll let Josef answer this.

> 
> > The driver it uses is at drivers/media/usb/dvb-usb-v2/dvbsky.c,
> > with shares a USB implementation that is used by a lot more drivers.
> > The URB handling code is at:
> > 
> > 	drivers/media/usb/dvb-usb-v2/usb_urb.c
> > 
> > This particular driver allocates 8 buffers with 4096 bytes each
> > for bulk transfers, using transfer_flags = URB_NO_TRANSFER_DMA_MAP.
> > 
> > This become a popular USB hardware nowadays. I have one S960c
> > myself, so I can send you the lsusb from it. You should notice, however,
> > that a DVB-C/DVB-S2 channel can easily provide very high sustained bit
> > rates. Here, on my DVB-S2 provider, a typical transponder produces 58 Mpps
> > of payload after removing URB headers.  
> 
> You mentioned earlier that the driver uses bulk transfers.  In USB-2.0,
> the maximum possible payload data transfer rate using bulk transfers is
> 53248 bytes/ms, which is 53.248 MB/s (i.e., lower than 58 MB/s).  And
> even this is possible only if almost nothing else is using the bus at
> the same time.

No, I said 58 Mbits/s (not bytes).

On DVB-C and DVB-S2 specs, AFAIKT, there's no hard limit for the maximum
payload data rate, although industry seems to limit it to be around
60 Mbits/s. On those standards, the maximal bit rate is defined by the
modulation type and by the channel symbol rate.

To give you a practical example, my DVB-S2 provider modulates each
transponder with 8/PSK (3 bits/symbol), and define channels with a
symbol rate of 30 Mbauds/s. So, it could, theoretically, transport
a MPEG-TS stream up to 90 Mbits/s (minus headers and guard intervals).
In practice, the streams there are transmitted with 58,026.5 Kbits/s.

> > A 10 minutes record with the
> > entire data (with typically contains 5-10 channels) can easily go
> > above 4 GB, just to reproduce 1-2 glitches. So, I'm not sure if
> > a usbmon dump would be useful.  
> 
> It might not be helpful at all.  However, I'm not interested in the 
> payload data (which would be unintelligible to me anyway) but rather 
> the timing of URB submissions and completions.  A usbmon trace which 
> didn't keep much of the payload data would only require on the order of 
> 50 MB per minute -- and Josef said that glitches usually would show up 
> within a minute or so.

Yeah, this could help.

Josef,

You can get it with wireshark/tshark or tcpdump. See:
	https://technolinchpin.wordpress.com/2015/10/23/usb-bus-sniffers-for-linux-system/
	https://wiki.wireshark.org/CaptureSetup/USB

> > I'm enclosing the lsusb from a S960C device, with is based on those
> > Montage chipsets:  
> 
> What I wanted to see was the output from "lsusb" on the affected
> system, not the output from "lsusb -v -s B:D" on your system.
> 
> > > Overall, this may be a very difficult problem to solve.  The
> > > 4cd13c21b207 commit was intended to improve throughput at the cost of
> > > increased latency.  But then what do you do when the latency becomes
> > > too high for the video subsystem to handle?  
> > 
> > Latency can't be too high, otherwise frames will be dropped.  
> 
> Yes, that's the whole point.
> 
> > Even if the Kernel itself doesn't drop, if the delay goes higher
> > than a certain threshold, userspace will need to drop, as it
> > should be presenting audio and video on real time. Yet, typically,
> > userspace will delay it by one or two seconds, with would mean
> > 1500-3500 buffers, with I suspect it is a lot more than the hardware
> > limits. So I suspect that the hardware starves free buffers a way 
> > before userspace, as media hardware don't have unlimited buffers
> > inside them, as they assume that the Kernel/userspace will be fast
> > enough to sustain bit rates up to 66 Mbps of payload.  
> 
> The timing information would tell us how large the latency is.
> 
> In any case, you might be able to attack the problem simply by using
> more than 8 buffers.  With just eight 4096-byte buffers, the total
> pipeline capacity is only about 0.62 ms (at the maximum possible
> transfer rate).  Increasing the number of buffers to 65 would give a
> capacity of 5 ms, which is probably a lot better suited for situations
> where completions are handled by the ksoftirqd thread.

Increasing it to 65 shouldn't be hard. Not sure, however, if the hardware
will actually fill the 65 buffers, but it is worth to try.

> > Perhaps media drivers could pass some quirk similar to URB_ISO_ASAP,
> > in order to revert the kernel logic to prioritize latency instead of
> > throughput.  
> 
> It can't be done without pervasive changes to the USB subsystem, which
> I would greatly prefer to avoid.  Besides, this wouldn't really solve
> the problem.  Decreasing the latency for one device will cause it to be
> increased for others.

If there is a TV streaming traffic at a USB bus, it means that the
user wants to either watch and/or record a TV program. On such
usecase scenario, a low latency is highly desired for the TV capture
(and display, if the GPU is USB), even it means a higher latency for
other traffic.

Josef,

Could you please try the following patch on Kernel 4.14.10 (without
reverting any changesets), and see if it fixes the issue?


media: dvbsky: Increase the number of buffers

Right now, This driver expects a 0.62 ms delay with 8 buffers on an USB 2.0
high speed bus. Increase it to 65 buffers, in order to give more time for
the top half of the USB transfer handler to complete its task.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 131b6c08e199..d3f5ffc54b25 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -740,7 +740,7 @@ static struct dvb_usb_device_properties dvbsky_s960_props = {
 	.num_adapters = 1,
 	.adapter = {
 		{
-			.stream = DVB_USB_STREAM_BULK(0x82, 8, 4096),
+			.stream = DVB_USB_STREAM_BULK(0x82, 65, 4096),
 		}
 	}
 };


> 



Thanks,
Mauro
