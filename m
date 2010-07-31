Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:24023 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538Ab0GaNzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 09:55:15 -0400
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
Date: Sat, 31 Jul 2010 09:55:31 -0400
Message-ID: <1280584531.2473.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-30 at 15:45 +0300, Maxim Levitsky wrote:
> On Fri, 2010-07-30 at 08:07 -0400, Jon Smirl wrote: 
> > On Fri, Jul 30, 2010 at 8:02 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
> > > On Fri, Jul 30, 2010 at 7:54 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> 
> > >
> > > +       pll_freq = (ene_hw_read_reg(dev, ENE_PLLFRH) << 4) +
> > > +               (ene_hw_read_reg(dev, ENE_PLLFRL) >> 2);
> > 
> 
> 
> > I can understand the shift of the high bits, but that shift of the low
> > bits is unlikely.  A manual would tell us if it is right.
> > 
> This shift is correct (according to datasheet, which contains mostly
> useless info, but it does dociment this reg briefly.)

The KB3700 series datasheet indicates that the value from ENE_PLLFRL
should be shifted by >> 4 bits, not by >> 2.  Of course, the KB3700
isn't the exact same chip.

Regards,
Andy


