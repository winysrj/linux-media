Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:58421 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbdB0Nf0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 08:35:26 -0500
Date: Mon, 27 Feb 2017 13:32:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@kernel.org>,
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
In-Reply-To: <alpine.DEB.2.20.1702271105090.4732@nanos>
Message-ID: <alpine.DEB.2.20.1702271231410.4732@nanos>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com> <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com> <20170225090741.GA20463@gmail.com> <CA+55aFy+ER8cYV02eZsKAOLnZBWY96zNWqUFWSWT1+3sZD4XnQ@mail.gmail.com>
 <alpine.DEB.2.20.1702271105090.4732@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Feb 2017, Thomas Gleixner wrote:
> On Sat, 25 Feb 2017, Linus Torvalds wrote:
> > There are several things that set IRQS_PENDING, ranging from "try to
> > test mis-routed interrupts while irqd was working", to "prepare for
> > suspend losing the irq for us", to "irq auto-probing uses it on
> > unassigned probable irqs".
> > 
> > The *actual* reason to re-send, namely getting a nested irq that we
> > had to drop because we got a second one while still handling the first
> > (or because it was disabled), is just one case.
> > 
> > Personally, I'd suspect some left-over state from auto-probing earlier
> > in the boot, but I don't know. Could we fix that underlying issue?
> 
> I'm on it.

Adding a few trace points to the irq code gives me a pretty consistent
picture across a bunch of different machines.

The pending interrupt issue happens, at least on my test boxen, mostly on
the 'legacy' interrupts (0 - 15). But even the IOAPIC interrupts >=16
happen occasionally.

 - Spurious interrupts on IRQ7, which are triggered by IRQ 0 (PIT/HPET). On
   one of the affected machines this stops when the interrupt system is
   switched to interrupt remapping !?!?!?

 - Spurious interrupts on various interrupt lines, which are triggered by
   IOAPIC interrupts >= IRQ16. That's a known issue on quite some chipsets
   that the legacy PCI interrupt (which is used when IOAPIC is disabled) is
   triggered when the IOAPIC >=16 interrupt fires.

 - Spurious interrupt caused by driver probing itself. I.e. the driver
   probing code causes an interrupt issued from the device
   inadvertently. That happens even on IRQ >= 16.

   This problem might be handled by the device driver code itself, but
   that's going to be ugly. See below.

None of that was caused by misrouted irq or autoprobing. Autoprobing is not
used on any modern maschine at all and the misrouted mechanism cannot
set the pending flag on a interrupt which has no action installed.

Sure, we might not set the pending flag on spurious interrupts, when an
interrupt has no action assigned. We had it that way quite some years
ago. But that caused issues on a couple of (non x86) systems because the
peripheral which sent the spurious interrupt was waiting for
acknowledgement forever and therefor not sending new interrupts. There was
no way to handle that other than resending the interrupt after the action
was installed. The reason for this is the following race:

Device driver init()

  ack_bogus_pending_irq_in_device();
                          <---- Device sends spurious interrupt
  request_irq();

We cannot call ack_bogus_pending_irq_in_device() after the handler has been
installed because it might clear a real interrupt before the handler is
invoked. In fact we can, but that requires pretty ugly code. See below.

Yes, it's broken hardware, but in that area there is more broken than sane
hardware.

The other point here is, that the "IOAPIC triggers spurious interrupt on
legacy lines" issue can actually cause the same problem as the immediate
resend/retrigger:

  request_irq();
  			 <---- Other device sends IOAPIC interrupt which
			       triggers the legacy line.

If the handler is not prepared at that point, then it explodes as
well. Same for this odd IRQ0 -> IRQ7 trigger, which I can observe on two
machines.

The whole resend/retrigger business is only relevant for edge type
interrupts to deal with the following problem:

  disable_irq();
			<---- Device sends interrupt
  enable_irq();

  ===> Previously sent interrupt has not been acked in the device so no
       further interrupts happen. We lost an edge and are toast.

We never do the resend/retrigger for level type interrupts, because they
are resent by hardware if the interrupt is still pending, which is the case
when you don't acknowlegde it at the device level.

So now you might argue that a driver could handle this by doing:

  disable_irq();
			<---- Device sends interrupt
  enable_irq();

  lock_device();
   do_some_magic_checks_and_handle_pending_irq();
  unlock_device();

Requiring this would add tons of even more broken code to the device
drivers and I really doubt that we want to go there. Same for the
request_irq() case.

I rather prefer that drivers are able to deal with spurious interrupts even
on non shared interrupt lines and let the resend/retrigger mechanism expose
them early when they do not.

We can try to sample more data from the machines of affected users, but I
doubt that it will give us more information than confirming that we really
have to deal with all that hardware wreckage out there in some way or the
other.

Thanks,

	tglx
