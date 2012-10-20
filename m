Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51245 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab2JTMVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 08:21:15 -0400
Subject: Re: [Intel-gfx] GPU RC6 breaks PCIe to PCI bridge connected to CPU
 PCIe slot on SandyBridge systems
From: Andy Walls <awalls@md.metrocast.net>
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Cc: intel-gfx@lists.freedesktop.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>, bhelgaas@google.com,
	linux-pci@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@infradead.org
Date: Sat, 20 Oct 2012 08:20:57 -0400
In-Reply-To: <2244094.6Dmq15viKH@f17simon>
References: <1704067.2NCOGYajHN@f17simon> <3896332.1fABn9rFR8@f17simon>
	 <2233216.7bl6QCud67@f17simon> <2244094.6Dmq15viKH@f17simon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1350735659.2491.21.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-10-19 at 18:06 +0100, Simon Farnsworth wrote:
> On Friday 19 October 2012 17:10:17 Simon Farnsworth wrote:
> > Mauro, Linux-Media
> > 
> > I have an issue where an SAA7134-based TV capture card connected via a PCIe to
> > PCI bridge chip works when the GPU is kept out of RC6 state, but sometimes
> > "skips" updating lines of the capture when the GPU is in RC6. We've confirmed
> > that a CX23418 based chip doesn't have the problem, so the question is whether
> > the SAA7134 and the saa7134 driver are at fault, or whether it's the PCIe bus.

My money's on the saa7134 driver's irq_handler or the driver's locking
scheme to protect data accessed by both irq handler and userspace file
operations (aka videobuf's locking) in the driver.

It could also be a system level problem with another driver's irq
handler being stupid.

> > This manifests as a regression, as I had no problems with kernel 3.3 (which
> > never enabled RC6 on the Intel GPU), but I do have problems with 3.5 and with
> > current Linus git master. I'm happy to try anything, 

Profile the saa7134 driver in operation:

http://www.spinics.net/lists/linux-media/msg15762.html

That will give you and driver writers a clue as to where any big delays
are hapeening in the saa7134 driver.

Odds are the processor slowing down to a lower power/lower speed state
is exposing inefficiencies in the irq handling of the saa7134 driver.


 
> > I've attached lspci -vvxxxxx output (suitable for feeding to lspci -F) for
> > when the corruption is present (lspci.faulty) and when it's not
> > (lspci.working). 

Doing a diff between the two files and checking what devices have
changed registers I noted that only 3 devices' PCI config space
registers changed: 00:01.0 and 00:1c.1 (both PCIe ports/bridges) and
00:1a.0. 

$ lspci -F lspci.working -tv
-[0000:00]-+-00.0  Intel Corporation 2nd Generation Core Processor Family DRAM Controller
           +-01.0-[01-02]----00.0-[02]----08.0  Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder
           +-02.0  Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller
           +-16.0  Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1
           +-19.0  Intel Corporation 82579V Gigabit Network Connection
           +-1a.0  Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2
           +-1b.0  Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller
           +-1c.0-[03]--
           +-1c.1-[04]----00.0  NEC Corporation uPD720200 USB 3.0 Host Controller
           +-1d.0  Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1
           +-1f.0  Intel Corporation H67 Express Chipset Family LPC Controller
           +-1f.2  Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller
           \-1f.3  Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller

Obviously the changes to the bridge at 00:01.0 might matter, but I would
need to dig up the data sheet for the "00:01.0 PCI bridge [0604]: Intel
Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI
Express Root Port [8086:0101] (rev 09) (prog-if 00 [Normal decode])" to
see if it really mattered.


> The speculation is that the SAA7134 is somehow more
> > sensitive to the changes in timings that RC6 introduces than the CX23418, and
> > that someone who understands the saa7134 driver might be able to make it less
> > sensitive.

I heavily optimized the cx18 driver for the high throughput use case
(mutliple cards running multiple data streams), which meant squeezing
every little bit of useless junk out of the irq handler and adding
highly granular buffer queue locking between the irq handling and the
userspace file operations calls.  Also the CX23418 firmware has a "best
effort" buffer notification handshake and the cx18 driver does some
extra recovery processing to handle when it is late on handling buffer
notifications.  All that optimzation and robustness coding took me a few
months to get right.

I don't see that sort of optimization of the saa7134 driver coming
anytime soon.

Regards,
Andy

> And timings are definitely the problem; I have a userspace provided pm_qos
> request asking for 0 exit latency, but I can see CPU cores entering C6. I'll
> take this problem to an appropriate list.
> 
> There is still be a bug in the SAA7134 driver, as the card clearly wants a
> pm_qos request when streaming to stop the DMA latency becoming too high; this
> doesn't directly affect me, as my userspace always requests minimal DMA
> latency anyway, so consider this message as just closing down the thread for
> now, and as a marker for the future (if people see such corruption, the
> saa7134 driver needs a pm_qos request when streaming that isn't currently
> present).


