Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39103 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0G3LgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:36:08 -0400
Subject: Re: [PATCH 13/13] IR: Port ene driver to new IR subsystem and
 enable  it.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jon Smirl <jonsmirl@gmail.com>, lirc-list@lists.sourceforge.net,
	Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <1280461565.15737.124.camel@localhost>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
	 <1280456235-2024-14-git-send-email-maximlevitsky@gmail.com>
	 <AANLkTim42mHVhOgmVGxh2XsbbbVC7ZOgtfd7DDSrxZDB@mail.gmail.com>
	 <1280461565.15737.124.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 14:36:01 +0300
Message-ID: <1280489761.3646.3.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-29 at 23:46 -0400, Andy Walls wrote: 
> On Thu, 2010-07-29 at 22:39 -0400, Jon Smirl wrote:
> > On Thu, Jul 29, 2010 at 10:17 PM, Maxim Levitsky
> > <maximlevitsky@gmail.com> wrote:
> > > note that error_adjustment module option is added.
> > > This allows to reduce input samples by a percent.
> > > This makes input on my system more correct.
> > >
> > > Default is 4% as it works best here.
> > >
> > > Note that only normal input is adjusted. I don't know
> > > what adjustments to apply to fan tachometer input.
> > > Maybe it is accurate already.
> > 
> > Do you have the manual for the ENE chip in English? or do you read Chinese?
> 
> The datasheet for a similar chip, the KB3700, is out there in English,
> but it doesn't have CIR.
> 
> You might find these links mildly interesting:
> 
> http://www.coreboot.org/Embedded_controller
> http://wiki.laptop.org/go/Embedded_controller
> http://lists.laptop.org/pipermail/openec/2008-July/000108.html

Nope, I have read that. 
> 
> Regards,
> Andy
> 
> > Maybe you can figure out why the readings are off by 4%. I suspect
> > that someone has set a clock divider wrong when programming the chip.
> > For example setting the divider for a 25Mhz clock when the clock is
> > actually 26Mhz would cause the error you are seeing. Or they just made
> > a mistake in computing the divisor. It is probably a bug in the BIOS
> > of your laptop.  If that's the case you could add a quirk in the
> > system boot code to fix the register setting.

I figured out how windows driver compensates for the offset, and do the
same in my driver. I think the problem is solved.


Best regards,
Maxim Levitsky

