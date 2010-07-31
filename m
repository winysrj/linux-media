Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40789 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab0GaQod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 12:44:33 -0400
Subject: Re: [PATCH 13/13] IR: Port ene driver to new IR subsystem and
 enable  it.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <AANLkTimaut1mMUXwbJAgjNjmQkxgsf-GOCTXmKYNm1Lz@mail.gmail.com>
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
	 <1280589153.2473.78.camel@localhost>
	 <AANLkTimaut1mMUXwbJAgjNjmQkxgsf-GOCTXmKYNm1Lz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 19:44:25 +0300
Message-ID: <1280594665.3523.7.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-07-31 at 12:25 -0400, Jon Smirl wrote: 
> On Sat, Jul 31, 2010 at 11:12 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> > I think you won't be able to fix the problem conclusively either way.  A
> > lot of how the chip's clocks should be programmed depends on how the
> > GPIOs are used and what crystal is used.
> >
> > I suspect many designers will use some reference design layout from ENE,
> > but it won't be good in every case.  The wire-up of the ENE of various
> > motherboards is likely something you'll have to live with as unknowns.
> >
> > This is a case where looser tolerances in the in kernel decoders could
> > reduce this driver's complexity and/or get rid of arbitrary fudge
> > factors in the driver.
> 
> The tolerances are as loose as they can be. The NEC protocol uses
> pulses that are 4% longer than JVC. The decoders allow errors up to 2%
> (50% of 4%).  The crystals used in electronics are accurate to
> 0.0001%+.  The 4% error in this driver is because the hardware is not
> being programmed accurately. This needs to be fixed in the driver and
> not in the upper layers.

Let me explain again.

I get samples in 4 byte buffer. each sample is a count of sample
periods.
Sample period is programmed into hardware, at 'ENE_CIR_SAMPLE_PERIOD'
(it is in us)

Default sample period is 50 us.

The error source isn't 'electronics' fault.
The device is microprocessor.
I don't read the samples 'directly' from hardware, but rather from ram
of that microprocessor.
I don't know how it samples the input.
A expiration of sample period might just cause a IRQ inside that
microprocessor, and it can't process it instantly. That is probably the
source of the delay.
Or something like that.

Best regards,
Maxim Levitsky

