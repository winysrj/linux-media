Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59633 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdB0RFo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 12:05:44 -0500
Date: Mon, 27 Feb 2017 17:12:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        kernel test robot <fengguang.wu@intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Ruslan Ruslichenko <rruslich@cisco.com>, LKP <lkp@01.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        kernel@stlinux.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, wfg@linux.intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [WARNING: A/V UNSCANNABLE][Merge tag 'media/v4.11-1' of git]
 ff58d005cd: BUG: unable to handle kernel NULL pointer dereference at
 0000039c
In-Reply-To: <20170227154124.GA20569@gmail.com>
Message-ID: <alpine.DEB.2.20.1702271647570.4732@nanos>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com> <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com> <20170225090741.GA20463@gmail.com> <CA+55aFy+ER8cYV02eZsKAOLnZBWY96zNWqUFWSWT1+3sZD4XnQ@mail.gmail.com>
 <alpine.DEB.2.20.1702271105090.4732@nanos> <alpine.DEB.2.20.1702271231410.4732@nanos> <20170227154124.GA20569@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Feb 2017, Ingo Molnar wrote:
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
> > 
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

Yes, I'd love to do that. That's just a nightmare as well.

See commit 6d83f94db95cf, which added the _FIXME suffix to that code.

So recently I tried to invoke the primary handler, which causes another
issue:

  Some of the low level code (e.g. IOAPIC interrupt migration, but also
  some PPC irq chip machinery) depends on being called in hard interrupt
  context. They invoke get_irq_regs(), which obviously does not work from
  thread context.

So I removed that one from -next as well and postponed it another time. And
I should have known before I tried it that it does not work. Simply because
of that stuff x86 cannot use the software based resend mechanism.

Still trying to wrap my head around a proper solution for the problem. On
x86 we might just check whether we are really in hard irq context and
otherwise skip the part which depends on get_irq_regs(). That would be a
sane thing to do. Have not yet looked at the PPC side of affairs, whether
that's easy to solve as well. But even if it is, then there might be still
other magic code in some irq chip drivers which relies on things which are
only available/correct when actually invoked by a hardware interrupt.

Not only the hardware has colorful behaviour ....

Thanks,

	tglx
