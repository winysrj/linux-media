Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:35130 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752222AbdB1Nww (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 08:52:52 -0500
Date: Tue, 28 Feb 2017 11:51:25 +0100 (CET)
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
In-Reply-To: <CA+55aFxwtkOs95R-v7z8yjguvp91oDTxRKs-x3uN_=sM_33Gvg@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1702281103590.4732@nanos>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com> <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com> <20170225090741.GA20463@gmail.com> <CA+55aFy+ER8cYV02eZsKAOLnZBWY96zNWqUFWSWT1+3sZD4XnQ@mail.gmail.com>
 <alpine.DEB.2.20.1702271105090.4732@nanos> <alpine.DEB.2.20.1702271231410.4732@nanos> <20170227154124.GA20569@gmail.com> <CA+55aFxwtkOs95R-v7z8yjguvp91oDTxRKs-x3uN_=sM_33Gvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Feb 2017, Linus Torvalds wrote:
> So I don't disagree that in a perfect world all drivers should just
> handle it. It's just that it's not realistic.
> 
> The fact that we have now *twice* gotten an oops report or a "this
> machine doesn't boot" report etc within a week or so of merging the
> problematic patch does *not* indicate that it's easy to fix or rare.
> 
> Quite the reverse.
> 
> It indicates that it's just rare enough that core developers don't see
> it, but it's common enough to have triggered issues in random places.
> 
> And it will just get *much* worse when you then get the random
> end-users that usually have older machines than the developers who
> actually test daily development -git trees.

I tend to disagree.

The retrigger mechanism has been there forever, at least the history git
tree which goes back to 2.5.0 has it and as it was in the initial commit is
it was there in 2.4 already.

We broke that in 4.2 when the x86 interrupt mechanism was reworked
completely. That went pretty much unnoticed until somebody moved from 4.1
to 4.9 and discovered that edge interrupts got lost. It's not surprising
that it went unnoticed because lots of stuff moved towards MSI (which has
the retrigger still enabled) and the devices which are prone to the 'lost
edge' issue are limited.

So we had that retrigger exposing crappy older drivers to the spurious
interrupt until 2 years ago. The two drivers which have been exposed by
bringing the retrigger back are post 4.2 or have been wreckaged post 4.2.

Due to the fact that the old drivers have been exposed over many years to
the spurious retrigger (that "feature" exists on old hardware as well) I
don't think it's much of a problem.

We also had the DEBUG_SHIRQ active until we had to disable it in
6d83f94db95cf (2.6.38) but not because it exposed crappy interrupt
handlers. We had to disable due to a functional problem described in the
commit message. I know for sure that distros had enabled DEBUG_SHIRQ (and
some still have the reduced functionality of it enabled).

What I find more problematic is:

 - to keep this 'lost edge' regression around, which really can render
   hardware useless.

 - to ignore the fact that these buggy interrupt handlers can be exposed by
   spurious interrupt events (as I showed in the other mail) "naturaly",
   but with a way smaller probability. If a user runs into such a spurious
   problem he has absolutely NO chance to debug it at all. Exposing it by
   the retrigger mechanism makes the detection more "reliable" and allows
   debugging it. The backtraces are pretty telling and clear.

Thanks,

	tglx
