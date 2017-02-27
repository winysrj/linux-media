Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:36532 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751409AbdB0QId (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 11:08:33 -0500
Date: Mon, 27 Feb 2017 08:07:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ruslan Ruslichenko <rruslich@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        kernel@stlinux.com, Sean Young <sean@mess.org>,
        wfg@linux.intel.com, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-mediatek@lists.infradead.org,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        linux-amlogic@lists.infradead.org,
        kernel test robot <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [WARNING: A/V UNSCANNABLE][Merge tag 'media/v4.11-1' of git]
 ff58d005cd: BUG: unable to handle kernel NULL pointer dereference at
 0000039c
Message-ID: <20170227160750.GM21809@atomide.com>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
 <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com>
 <20170225090741.GA20463@gmail.com>
 <CA+55aFy+ER8cYV02eZsKAOLnZBWY96zNWqUFWSWT1+3sZD4XnQ@mail.gmail.com>
 <alpine.DEB.2.20.1702271105090.4732@nanos>
 <alpine.DEB.2.20.1702271231410.4732@nanos>
 <20170227154124.GA20569@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170227154124.GA20569@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Ingo Molnar <mingo@kernel.org> [170227 07:44]:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The pending interrupt issue happens, at least on my test boxen, mostly on
> > the 'legacy' interrupts (0 - 15). But even the IOAPIC interrupts >=16
> > happen occasionally.
> >
> > 
> >  - Spurious interrupts on IRQ7, which are triggered by IRQ 0 (PIT/HPET). On
> >    one of the affected machines this stops when the interrupt system is
> >    switched to interrupt remapping !?!?!?
> > 
> >  - Spurious interrupts on various interrupt lines, which are triggered by
> >    IOAPIC interrupts >= IRQ16. That's a known issue on quite some chipsets
> >    that the legacy PCI interrupt (which is used when IOAPIC is disabled) is
> >    triggered when the IOAPIC >=16 interrupt fires.
> > 
> >  - Spurious interrupt caused by driver probing itself. I.e. the driver
> >    probing code causes an interrupt issued from the device
> >    inadvertently. That happens even on IRQ >= 16.

This sounds a lot like what we saw few weeks ago with dwc3. See commit
12a7f17fac5b ("usb: dwc3: omap: fix race of pm runtime with irq handler in
probe"). It was caused by runtime PM and -EPROBE_DEFER, see the description
Grygorii wrote up in that commit.

> >    This problem might be handled by the device driver code itself, but
> >    that's going to be ugly. See below.
> 
> That's pretty colorful behavior...
> 
> > We can try to sample more data from the machines of affected users, but I doubt 
> > that it will give us more information than confirming that we really have to 
> > deal with all that hardware wreckage out there in some way or the other.
> 
> BTW., instead of trying to avoid the scenario, wow about moving in the other 
> direction: making CONFIG_DEBUG_SHIRQ=y unconditional property in the IRQ core code 
> starting from v4.12 or so, i.e. requiring device driver IRQ handlers to handle the 
> invocation of IRQ handlers at pretty much any moment. (We could also extend it a 
> bit, such as invoking IRQ handlers early after suspend/resume wakeup.)
> 
> Because it's not the requirement that hurts primarily, but the resulting 
> non-determinism and the sporadic crashes. Which can be solved by making the race 
> deterministic via the debug facility.
> 
> If the IRQ handler crashed the moment it was first written by the driver author 
> we'd never see these problems.

Just in case this is PM related.. Maybe the spurious interrupt is pending
from earlier? This could be caused by glitches on the lines with runtime PM,
or a pending interrupt during suspend/resume. In that case IRQ_DISABLE_UNLAZY
might provide more clues if the problem goes away.

Regards,

Tony
