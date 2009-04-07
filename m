Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:9069 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZDGMgu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 08:36:50 -0400
Date: Tue, 7 Apr 2009 14:36:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, Janne Grunau <j@jannau.net>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] Anticipating lirc breakage
Message-ID: <20090407143617.2c2adbf7@hyperion.delvare>
In-Reply-To: <20090407075029.21d14f4a@pedra.chehab.org>
References: <20090406174448.118f574e@hyperion.delvare>
	<Pine.LNX.4.64.0904070049470.2076@cnc.isely.net>
	<20090407120209.1d42bacd@hyperion.delvare>
	<20090407075029.21d14f4a@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, 7 Apr 2009 07:50:29 -0300, Mauro Carvalho Chehab wrote:
> On Tue, 7 Apr 2009 12:02:09 +0200
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Hi Mike,
> > 
> > Glad to see we all mostly agree on what to do now. I'll still answer
> > some of your questions below, to clarify things even more.
> 
> I don't understand why you are preferring to do some workaround, spending
> energy to add hooks at the kernel drivers to support out-of-tree drivers,
> instead of working to provide the proper solution.

What I am proposing isn't a workaround, it is a fundamental part of
the solution, and it is even the approach which requires the minimum
amount of changes. This is as straightforward a solution as you can
hope for.

> I'm against adding any hook on kernel to support an out-of-tree driver.

I do not plan to add any hook. The plan is to instantiate all IR
devices we know are present, and let ir-kbd-i2c bind to the ones it
supports. The fact that another out-of-tree driver may optionally bind
to these devices is a side effect.

I would love to say "let's just ignore lirc altogether", however 1* I
don't think it makes any sense to break user systems when it is trivial
for us to not break them and 2* I don't think it is smart to be rude
with lirc developers are the exact moment they decide to attempt to
merge their drivers in the kernel tree.

> From what I understood, lirc developers are interested on merging lirc drivers.
> We all agree that ir-kbd-i2c doesn't address all i2c IR's, and that lirc
> drivers provide support for the remaining ones.

Yes, this is my understanding as well.

> So, let's just forget the workarounds and go straight to the point: focus on
> merging lirc-i2c drivers.

Will this happen next week? I fear not. Which is why I can't wait for
it. And anyway, in order to merge the lirc_i2c driver, it must be
turned into a new-style I2C driver first, so bridge drivers must be
prepared for this, which is _exactly_ what my patches are doing.

-- 
Jean Delvare
