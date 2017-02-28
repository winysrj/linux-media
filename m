Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35297 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751650AbdB1HcA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 02:32:00 -0500
Date: Tue, 28 Feb 2017 08:25:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20170228072550.GA17204@gmail.com>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
 <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com>
 <20170225090741.GA20463@gmail.com>
 <CA+55aFy+ER8cYV02eZsKAOLnZBWY96zNWqUFWSWT1+3sZD4XnQ@mail.gmail.com>
 <alpine.DEB.2.20.1702271105090.4732@nanos>
 <alpine.DEB.2.20.1702271231410.4732@nanos>
 <20170227154124.GA20569@gmail.com>
 <CA+55aFxwtkOs95R-v7z8yjguvp91oDTxRKs-x3uN_=sM_33Gvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxwtkOs95R-v7z8yjguvp91oDTxRKs-x3uN_=sM_33Gvg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In other words: what will happen is that distros start getting bootup problem 
> reports six months or a year after we've done it, and *if* they figure out it's 
> the irq enabling, they'll disable it, because they have no way to solve it 
> either.
> 
> And core developers will just maybe see the occasional "4.12 doesn't boot for 
> me" reports, but by then developers will ahve moved on to 4.16 or something.

Yeah, you are right, there's over 2,100 request_irq() calls in the kernel and 
perhaps only 1% of them gets tested on real hardware by the time a change gets 
upstream :-/

So in theory we could require all *new* drivers handle this properly, as new 
drivers tend to come through developers who can fix such bugs - which would at 
least guarantee that with time the problem would obsolete itself.

But I cannot see an easy non-intrusive way to do that - we'd have to rename all 
existing request_irq() calls:

 - We could rename request_irq() to request_irq_legacy() - which does not do the 
   tests.

 - The 'new' request_irq() function would do the tests unconditionally.

... and that's just too much churn - unless you think it's worth it, or if anyone 
can think of a better method to phase in the new behavior without affecting old 
users.

Another, less intrusive method would be to introduce a new request_irq_shared() 
API call, mark request_irq() obsolete (without putting warnings into the build 
though), and put a check into checkpatch that warns about request_irq() use.

The flip side would be that:

 - request_irq() is such a nice and well-known name to waste

 - plus request_irq_shared() is a misnomer, as this has nothing to do with sharing 
   IRQs, it's about getting IRQs in unexpected moments.

I'd rather do the renaming that is easy to automate and the pain is one time only.

Or revert the retrigger change and muddle through, although as per Thomas's 
observations spurious interrupts are very common.

Thanks,

	Ingo
