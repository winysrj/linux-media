Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35933 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751457AbdB0Plg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 10:41:36 -0500
Date: Mon, 27 Feb 2017 16:41:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20170227154124.GA20569@gmail.com>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
 <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com>
 <20170225090741.GA20463@gmail.com>
 <CA+55aFy+ER8cYV02eZsKAOLnZBWY96zNWqUFWSWT1+3sZD4XnQ@mail.gmail.com>
 <alpine.DEB.2.20.1702271105090.4732@nanos>
 <alpine.DEB.2.20.1702271231410.4732@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1702271231410.4732@nanos>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The pending interrupt issue happens, at least on my test boxen, mostly on
> the 'legacy' interrupts (0 - 15). But even the IOAPIC interrupts >=16
> happen occasionally.
>
> 
>  - Spurious interrupts on IRQ7, which are triggered by IRQ 0 (PIT/HPET). On
>    one of the affected machines this stops when the interrupt system is
>    switched to interrupt remapping !?!?!?
> 
>  - Spurious interrupts on various interrupt lines, which are triggered by
>    IOAPIC interrupts >= IRQ16. That's a known issue on quite some chipsets
>    that the legacy PCI interrupt (which is used when IOAPIC is disabled) is
>    triggered when the IOAPIC >=16 interrupt fires.
> 
>  - Spurious interrupt caused by driver probing itself. I.e. the driver
>    probing code causes an interrupt issued from the device
>    inadvertently. That happens even on IRQ >= 16.
> 
>    This problem might be handled by the device driver code itself, but
>    that's going to be ugly. See below.

That's pretty colorful behavior...

> We can try to sample more data from the machines of affected users, but I doubt 
> that it will give us more information than confirming that we really have to 
> deal with all that hardware wreckage out there in some way or the other.

BTW., instead of trying to avoid the scenario, wow about moving in the other 
direction: making CONFIG_DEBUG_SHIRQ=y unconditional property in the IRQ core code 
starting from v4.12 or so, i.e. requiring device driver IRQ handlers to handle the 
invocation of IRQ handlers at pretty much any moment. (We could also extend it a 
bit, such as invoking IRQ handlers early after suspend/resume wakeup.)

Because it's not the requirement that hurts primarily, but the resulting 
non-determinism and the sporadic crashes. Which can be solved by making the race 
deterministic via the debug facility.

If the IRQ handler crashed the moment it was first written by the driver author 
we'd never see these problems.

Thanks,

	Ingo
