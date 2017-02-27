Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:36586 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751461AbdB0Q0p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 11:26:45 -0500
Date: Mon, 27 Feb 2017 08:26:39 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>,
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
Message-ID: <20170227162639.GN21809@atomide.com>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
 <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com>
 <20170225090741.GA20463@gmail.com>
 <CA+55aFy+ER8cYV02eZsKAOLnZBWY96zNWqUFWSWT1+3sZD4XnQ@mail.gmail.com>
 <alpine.DEB.2.20.1702271105090.4732@nanos>
 <alpine.DEB.2.20.1702271231410.4732@nanos>
 <20170227154124.GA20569@gmail.com>
 <20170227160750.GM21809@atomide.com>
 <alpine.DEB.2.20.1702271712470.4732@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1702271712470.4732@nanos>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Thomas Gleixner <tglx@linutronix.de> [170227 08:20]:
> On Mon, 27 Feb 2017, Tony Lindgren wrote:
> > * Ingo Molnar <mingo@kernel.org> [170227 07:44]:
> > > Because it's not the requirement that hurts primarily, but the resulting 
> > > non-determinism and the sporadic crashes. Which can be solved by making the race 
> > > deterministic via the debug facility.
> > > 
> > > If the IRQ handler crashed the moment it was first written by the driver author 
> > > we'd never see these problems.
> > 
> > Just in case this is PM related.. Maybe the spurious interrupt is pending
> > from earlier? This could be caused by glitches on the lines with runtime PM,
> > or a pending interrupt during suspend/resume. In that case IRQ_DISABLE_UNLAZY
> > might provide more clues if the problem goes away.
> 
> It's not PM related.  That's just silly hardware. At the moment when you
> enable some magic bit in the control register, which is required to probe
> the version, the fricking thing spits out a spurious interrupt despite the
> interrupt enable bit in the same control register being still disabled. Of
> course we cannot install an interrupt handler before having probed the
> version and setup other stuff, except we add magic 'if (!initialized)'
> crappola into the handler and lose the ability to install version dependent
> handlers afterwards.

OK and presumably no -EPROBE_DEFER happening either.

> Wonderful crap that, isn't it?

Sounds broken..

Regards,

Tony
