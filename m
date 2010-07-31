Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42828 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab0GaOhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 10:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <1280586534.3587.0.camel@maxim-laptop>
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
	<1280584531.2473.4.camel@localhost>
	<1280586534.3587.0.camel@maxim-laptop>
Date: Sat, 31 Jul 2010 10:37:54 -0400
Message-ID: <AANLkTi=Nw5QTkVKEbLZ4sH0xVH7-oSAB6gaQ2YCEyV=O@mail.gmail.com>
Subject: Re: [PATCH 13/13] IR: Port ene driver to new IR subsystem and enable
	it.
From: Jon Smirl <jonsmirl@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 31, 2010 at 10:28 AM, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> On Sat, 2010-07-31 at 09:55 -0400, Andy Walls wrote:
>> On Fri, 2010-07-30 at 15:45 +0300, Maxim Levitsky wrote:
>> > On Fri, 2010-07-30 at 08:07 -0400, Jon Smirl wrote:
>> > > On Fri, Jul 30, 2010 at 8:02 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
>> > > > On Fri, Jul 30, 2010 at 7:54 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>>
>> >
>> > > >
>> > > > +       pll_freq = (ene_hw_read_reg(dev, ENE_PLLFRH) << 4) +
>> > > > +               (ene_hw_read_reg(dev, ENE_PLLFRL) >> 2);
>> > >
>> >
>> >
>> > > I can understand the shift of the high bits, but that shift of the low
>> > > bits is unlikely.  A manual would tell us if it is right.
>> > >
>> > This shift is correct (according to datasheet, which contains mostly
>> > useless info, but it does dociment this reg briefly.)
>>
>> The KB3700 series datasheet indicates that the value from ENE_PLLFRL
>> should be shifted by >> 4 bits, not by >> 2.  Of course, the KB3700
>> isn't the exact same chip.
> You are right about that, thanks!

I looked at KB3700 manual. It says it is trying to make a 32Mhz clock
by multiplying 32.768Khz * 1000.

32,768 * 1000 = 32.768Mhz is a 2.4% error.

When you are computing the timings of the pulses did you assume a
32Mhz clock? It looks like the clock is actuall 32.768Mhz.


>
> Best regards,
> Maxim Levitsky
>
>



-- 
Jon Smirl
jonsmirl@gmail.com
