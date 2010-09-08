Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:7951 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756606Ab0IHXDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 19:03:09 -0400
Subject: Re: [PATCH 7/8] IR: extend ir_raw_event and do refactoring
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <20100908172708.GH22323@redhat.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	 <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
	 <AANLkTinr6mN=t=vNnR3pSBxXb0ud=Ymrqn_WyDNkUJTz@mail.gmail.com>
	 <1283964646.6372.90.camel@morgan.silverblock.net>
	 <20100908172708.GH22323@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 19:02:33 -0400
Message-ID: <1283986953.29812.24.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 2010-09-08 at 13:27 -0400, Jarod Wilson wrote:
> On Wed, Sep 08, 2010 at 12:50:46PM -0400, Andy Walls wrote:
> > On Wed, 2010-09-08 at 11:26 -0400, Jarod Wilson wrote:
> > > On Mon, Sep 6, 2010 at 5:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> > > 
> > > I'm generally good with this entire patch, but the union usage looks a
> > > bit odd, as the members aren't of the same size, which is generally
> > > what I've come to expect looking at other code.
> > 
> > Having a union with different sized members is perfectly valid C code. 
> > 

> Yeah, no, I know that it'll work, just that most of the unions I've
> actually paid any attention to had members all of the same size. Seemed
> like sort of an unwritten rule for in-kernel use. But its probably just
> fine.

Well if it's an unwritten rule, not everyone is following it. :)
There are numerous counter-examples in include/linux/*.h .  Here are a
few easy to see ones:

include/linux/input.h:
	union in struct ff_effect: ff_rumble vs. ff_periodic   

include/linux/i2c.h
	union i2c_smbus_data: byte vs. word vs. block[]

include/linux/kfifo.h
	DECLARE_KFIFO



> > >  I'd be inclined to
> > > simply move duty_cycle out of the union and leave just duration and
> > > carrier in it.
> > 
> > That's not necessary and it could be confusing depending on where you
> > put duty_cycle.
> 
> There's that. But without having code that actually uses duty_cycle in a
> meaningful way yet, its hard to say for sure. If carrier and duty_cycle
> were only being sent out in their own events, you might actually want a
> union of duration, carrier and duty_cycle. Though I suspect we'll probably
> want to pass along carrier and duty_cycle at the same time.

I suspect you're right on that.  I don't have any experience with
hardware that can actually estimate carrier freq or duty cycle.  I
suspect they can be measured together using edge detection on both
rising and falling edges.

Regards,
Andy




