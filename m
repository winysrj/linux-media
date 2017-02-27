Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:57814 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdB0KNd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 05:13:33 -0500
Date: Mon, 27 Feb 2017 11:09:41 +0100 (CET)
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
        LKML <linux-kernel@vger.kernel.org>, wfg@linux.intel.com
Subject: Re: [WARNING: A/V UNSCANNABLE][Merge tag 'media/v4.11-1' of git]
 ff58d005cd: BUG: unable to handle kernel NULL pointer dereference at
 0000039c
In-Reply-To: <CA+55aFy+ER8cYV02eZsKAOLnZBWY96zNWqUFWSWT1+3sZD4XnQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1702271105090.4732@nanos>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com> <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com> <20170225090741.GA20463@gmail.com> <CA+55aFy+ER8cYV02eZsKAOLnZBWY96zNWqUFWSWT1+3sZD4XnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 25 Feb 2017, Linus Torvalds wrote:
> On Sat, Feb 25, 2017 at 1:07 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > So, should we revert the hw-retrigger change:
> >
> >   a9b4f08770b4 x86/ioapic: Restore IO-APIC irq_chip retrigger callback
> >
> > ... until we managed to fix CONFIG_DEBUG_SHIRQ=y? If you'd like to revert it
> > upstream straight away:
> >
> > Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> So I'm in no huge hurry to revert that commit as long as we're still
> in the merge window or early -rc's.
> 
> From a debug standpoint, the spurious early interrupts are fine, and
> hopefully will help us find more broken drivers.
> 
> It's just that I'd like to revert it before the actual 4.11 release,
> unless we can find a better solution.
> 
> Because it really seems like the interrupt re-trigger is entirely
> bogus. It's not an _actual_ "re-trigger the interrupt that may have
> gotten lost", it's some code that ends up triggering it for no good
> reason.
> 
> So I'd actually hope that we could figure out why IRQS_PENDING got
> set, and perhaps fix the underlying cause?
>
> There are several things that set IRQS_PENDING, ranging from "try to
> test mis-routed interrupts while irqd was working", to "prepare for
> suspend losing the irq for us", to "irq auto-probing uses it on
> unassigned probable irqs".
> 
> The *actual* reason to re-send, namely getting a nested irq that we
> had to drop because we got a second one while still handling the first
> (or because it was disabled), is just one case.
> 
> Personally, I'd suspect some left-over state from auto-probing earlier
> in the boot, but I don't know. Could we fix that underlying issue?

I'm on it.

Thanks,

	tglx
