Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35580 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581Ab1BWNAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 08:00:32 -0500
Subject: Re: No data from tuner over PCI bridge adapter (Cablestar HD 2 /
 mantis / PEX 8112)
From: Andy Walls <awalls@md.metrocast.net>
To: Dennis Kurten <dennis.kurten@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTiko3nTvcaNr73LmUuvmnk0_tr7BoRh-zYJ2a-nQ@mail.gmail.com>
References: <AANLkTik_PcJdKSE1+konisckfb-j05+yaUFuiG+CsRTQ@mail.gmail.com>
	 <1297735794.2394.88.camel@localhost>
	 <AANLkTikcQw8+Xb1zFr75zxuG9P4p14egw=9HeN7kswAN@mail.gmail.com>
	 <AANLkTiko3nTvcaNr73LmUuvmnk0_tr7BoRh-zYJ2a-nQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 08:00:46 -0500
Message-ID: <1298466046.2423.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-02-22 at 14:34 +0200, Dennis Kurten wrote:
> On Tue, Feb 15, 2011 at 4:23 PM, Dennis Kurten <dennis.kurten@gmail.com> wrote:
> > Hello Andy, I've tried some of your suggestions, but no luck so far.
> >
> >
> > On Tue, Feb 15, 2011 at 4:09 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> >> On Mon, 2011-02-14 at 13:35 +0200, Dennis Kurten wrote:
> >>> Hello,
> >>>
> >>> This card (technisat cablestar hd 2 dvb-c) works fine when plugged
> >>> into a native PCI slot. When I try it with a PCI-adapter I intend to use in
> >>> mITX-builds there doesn't seem to be any data coming in through the
> >>> tuner. The adapter is a transparent bridge (with a PEX 8112 chip) that
> >>> goes into a 1xPCIe-slot and gets power through a 4-pin molex.
> >>>
> >>> [...]
> >>>
> >>> Kernel is 2.6.32 (+the compiled drivers)
> 
> 
> I have upgraded my system to 2.6.35 so now I'm using "vanilla drivers" but
> the problem remains: Works fine in PCI - doesn't in PCIE behind adapter.

Before you go too crazy throwing probes in your box, have you tested the
PCIe adapter and Mantis device in Windows?


> >>> [...]
> >>>
> >>>         Latency: 32 (2000ns min, 63750ns max)
> >>>         Interrupt: pin A routed to IRQ 16
> >>>         Region 0: Memory at fdcff000 (32-bit, prefetchable) [size=4K]
> >>                                                ^^^^^^^^^^^^
> >>
> >> Heh, I always find it curious when I/O peripherials claim their register
> >> space is prefetchable (the CX23416 does this as well).  If the chip is
> >> designed right, it is valid though AFAICT.
> >>
> 
> 
> And is there any point with prefetchable mechanisms if bus mastering
> is employed?

Yes.

The Bus Mastering by the Mantis device is for when the device performs
DMA transfers.

The "command and control" by the Linux mantis driver to set up the
transfers and check interrupt status are mastered by the CPU and PCI/e
bridges.

Problems would only arise if the device marked the region as
prefetchable but didn't obey the conditions for doing so in the PCI
specs (e.g. reads should not  have side effects, etc.).  I'm guessing
that is unlikely to be the problem here.



>  This is what the adapter reports:
> 
>         I/O behind bridge: 0000e000-0000efff
>         Memory behind bridge: fdd00000-fddfffff
>         Prefetchable memory behind bridge: fdc00000-fdcfffff
> 
> I'd have thought that the memory behind the bridge would include any
> prefetchable segment. The tuner card happens to registers within that
> "0xfdc"-segment too.

That's right.  The bridge should report the aggregation of all the
active regions and region types behind it.  The bridge needs to know
this so it doesn't respond to address ranges some other bridge might be
fronting for.

Again everyuthing looks OK here.

> 
> > [...]
> >
> > from /cat/interrupts:
> > -----------------------
> >  16:       9751          0   IO-APIC-fasteoi   ahci, nvidia, Mantis
> >
> > [...]
> 
> 
> The above shared interrupt assignment is the same for both cases. There
> is however a difference how the interrupt link is set up:
> 
> Mantis 0000:05:06.0: PCI INT A -> Link[APC1] ... (<-- without bridge)
>   vs.
> Mantis 0000:04:00.0: PCI INT A -> Link[APC7] ... (<-- with bridge)
> 
> Don't know if the different APC# is of any significance here.


I'm not sure what those Links are so I can't help there.


My plan of attack, if this were my problem, would be to

a) test the video card and PCIe adapetr in Windows to eliminate bad
hardware.

b) test a different PCI card, driver by a different Linux driver, and
the PCIe adapter in Linux

c) Based on those results investigate either the Mantis driver or the
setup of the PCIe bridge.

Sometimes there is some odd register in the PCIe bridge that needs to be
tweaked.  The datasheet for the PEX8112 doesn't require an NDA, PLX just
wants you to register to be a "member" to download it.

	http://www.plxtech.com/products/expresslane/pex8112

	http://www.plxtech.com/premium_services/

I'm not sure what "membership" costs aside from storing a web-browser
cookie, the possibility of rejection, and periodic calls from sales
associates....

d) I'd investigate the possibility of the nvidia or ahci driver claiming
the interrupts from the Mantis device as theirs, thus preventing them
from being sent to the mantis driver.

e) Examin the PCI config space settings of the Mantis device (using
lspci -vvvxxxx as root) to see the difference in the PCI configuration
registers and then check the PCI sepc for what they mean.

Good Luck.

Regards,
Andy

> Regards,
> Dennis


