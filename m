Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36248 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdBYJHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 04:07:47 -0500
Date: Sat, 25 Feb 2017 10:07:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel test robot <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20170225090741.GA20463@gmail.com>
References: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
 <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFytXj+TZ_TanbxcY0KgRTrV7Vvr=fWON8tioUGmYHYiNA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I'm pretty sure that the thing that triggered this is once more commit
> a9b4f08770b4 ("x86/ioapic: Restore IO-APIC irq_chip retrigger
> callback") which seems to retrigger stale irqs that simply should not
> be retriggered.
> 
> They aren't actually active any more, if they ever were.
> 
> So that commit seems to act like a random CONFIG_DEBUG_SHIRQ. It's
> good for testing, but not good for actual users.

Yeah, so some distros like Fedora already have CONFIG_DEBUG_SHIRQ=y enabled, but 
part of the problem is that CONFIG_DEBUG_SHIRQ=y has this:

#ifdef CONFIG_DEBUG_SHIRQ_FIXME
        if (!retval && (irqflags & IRQF_SHARED)) {
                /*
                 * It's a shared IRQ -- the driver ought to be prepared for it
                 * to happen immediately, so let's make sure....
                 * We disable the irq to make sure that a 'real' IRQ doesn't
                 * run in parallel with our fake.
                 */
                unsigned long flags;

                disable_irq(irq);
                local_irq_save(flags);

                handler(irq, dev_id);

                local_irq_restore(flags);
                enable_irq(irq);
        }
#endif

Note that the '_FIXME' postfix effectively turns off this particular debug check 
...

Thomas and me realized this risk a week ago ago, and tried to resurrect full 
CONFIG_DEBUG_SHIRQ=y functionality to more reliably trigger these problems:

  https://lkml.org/lkml/2017/2/15/341

... but were forced to revert that fix because it's not working on x86 yet (it's 
crashing). We also thought we fixed the problems exposed in drivers, as the 
retrigger changes have been in -tip and -next for some time, but were clearly too 
optimistic about that.

So, should we revert the hw-retrigger change:

  a9b4f08770b4 x86/ioapic: Restore IO-APIC irq_chip retrigger callback

... until we managed to fix CONFIG_DEBUG_SHIRQ=y? If you'd like to revert it 
upstream straight away:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
