Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48208 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756014Ab0GaPMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 11:12:17 -0400
Subject: Re: [PATCH 13/13] IR: Port ene driver to new IR subsystem and
 enable  it.
From: Andy Walls <awalls@md.metrocast.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, lirc-list@lists.sourceforge.net,
	Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <1280493911.22296.5.camel@maxim-laptop>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
	 <1280456235-2024-14-git-send-email-maximlevitsky@gmail.com>
	 <AANLkTim42mHVhOgmVGxh2XsbbbVC7ZOgtfd7DDSrxZDB@mail.gmail.com>
	 <1280461565.15737.124.camel@localhost>
	 <1280489761.3646.3.camel@maxim-laptop>
	 <AANLkTimqi+DwXUKxBkfkLVnvS4ONRT461CcRLk3F9ojX@mail.gmail.com>
	 <1280490865.21345.0.camel@maxim-laptop>
	 <AANLkTikMkWt9bnY58tOneydJNHi1PZO5DsQbwuucJcrO@mail.gmail.com>
	 <AANLkTi=dkyrJM_WRhQPTY1V_1YnJRwNN5RN4hGNNeZ9v@mail.gmail.com>
	 <1280493911.22296.5.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 11:12:33 -0400
Message-ID: <1280589153.2473.78.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-30 at 15:45 +0300, Maxim Levitsky wrote:
> On Fri, 2010-07-30 at 08:07 -0400, Jon Smirl wrote: 
> > On Fri, Jul 30, 2010 at 8:02 AM, Jon Smirl <jonsmirl@gmail.com> wrote:

> > >>> >
> > >>>
> > >>> Should that be a <= or >= instead of !=?
> > >>> +       if (pll_freq != 1000)
> > >>
> > >> This is how its done in windows driver.
> > >
> > > That doesn't mean it is bug free.
> 
> This PLL frequency is likely to be chip internal frequency.
> And windows driver doesn't touch it.
> Its embedded controller, so I don't want to touch things I am not sure
> about.


The KB3700 datasheet states there are 4 clock domains in the chip.

One of the clock domains is a PLL LOW domain, used to clock
miscellaneous peripherials (which probably includes CIR on similar
chips).   The defualt for this clock appears to be 32.768 kHz clock
derived from a 32.768 MHz clock from which a 32.768 kHz clock is
derived.  It seems to be set up in the EC (ACPI 2.0 Embedded Controller)
register bank of the KB3700 chip.

That 1000 (0x3e8) is the default divider value to go from 32.768 MHz to
32.768 kHz.  I suspect it could be off by one - 0x3e7 might be the right
value - but that is only a 30 ns difference in the 30 us clock period.


So the check for 1000 by the Windows driver is likely a check for the
chip being in it's default configuration.  Looking at the CLKCFG2
register, the PLL can apparently output a 25 MHz clock instead of a
32.768 MHz clock.

While I'm looking at CLKCFG2, I note the default divider value of 0x1f
(31) for 1000 ns is wrong as well:

	32 / 32.768 MHz ~= 977 ns = 0.977 us   (-2.3%)

where as

	33 / 32.768 MHz ~= 1007 ns = 1.007 us  (+0.7%)

so the CLKCFG2 register programmed with 0x20 (32) would a better divisor
for a 1 us time period, if the functions in the chip can tolerate being
a little late vs. early.

I also read that the PLL reference comes from the LPC portion of the
chip which is the PCI clock domain.  So if a 33 MHz reference is used
instead of 32.768 MHz, then the default CLKCFG2 value yields this for a
nominal 1 us:

	32 / 33.333 MHz ~= 960 ns = 0.960 us   (-4.0%)
 





> > > Experimenting with changing the PLL frequency register may correct the
> > > error.  Try taking 96% of pll_freq and write it back into these
> > > register. This would be easy to fix with a manual. The root problem is
> > > almost certainly a bug in the way the PLLs were programmed.
> > >
> > > I don't like putting in fudge factors like the 4% correction. What
> > > happens if a later version of the hardware has fixed firmware? I
> > > normal user is never going to figure out that they need to change the
> > > fudge factor.
> I don't think that is a hardware bug, rather a limitation.
> 
> Lets leave it as is.
> I will soon publish the driver on launchpad or something like that and
> try to contact users I debugged that driver with, and then see what
> ranges PLL register takes.

I think you won't be able to fix the problem conclusively either way.  A
lot of how the chip's clocks should be programmed depends on how the
GPIOs are used and what crystal is used.

I suspect many designers will use some reference design layout from ENE,
but it won't be good in every case.  The wire-up of the ENE of various
motherboards is likely something you'll have to live with as unknowns.

This is a case where looser tolerances in the in kernel decoders could
reduce this driver's complexity and/or get rid of arbitrary fudge
factors in the driver.

Regards,
Andy

