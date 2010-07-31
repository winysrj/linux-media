Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52824 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0GaQvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 12:51:14 -0400
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
Date: Sat, 31 Jul 2010 19:51:09 +0300
Message-ID: <1280595069.3523.10.camel@maxim-laptop>
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
> 
> How is sample period being computed, where is the complete source to
> this driver?
> 
>        dev->tx_period = 32;
> 
> Where is sample_period computed?
> 
> @@ -672,13 +583,25 @@ static irqreturn_t ene_isr(int irq, void *data)
>                        pulse = !(hw_value & ENE_SAMPLE_SPC_MASK);
>                        hw_value &= ENE_SAMPLE_VALUE_MASK;
>                        hw_sample = hw_value * sample_period;
> +
> +                       if (dev->rx_period_adjust) {
> +                               hw_sample *= (100 - dev->rx_period_adjust);
> +                               hw_sample /= 100;
> +                       }
>                }
> 
> I suspect sample_period is set to 32us. For 32.768Mhz the period needs
> to be 30.5us. I don't see the code for how it was computed.
> 
> You have to be careful with rounding errors when doing this type of
> computation. What looks like a minor error can amplify into a large
> error. Sometimes I do the math in 64b ints just to keep the round off
> errors from accumulating.  Instead of doing the math in calculator and
> plugging in 32. Use #defines and do the math in the
There is no reason to worry about rounding here.

hw_sample is maximum of 127 * 50, so when I muliply by 100 I get exact
result.
Then I do one divide.

Best regards,
Maxim Levitsky



