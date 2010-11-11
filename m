Return-path: <mchehab@pedra>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:55104 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932219Ab0KKCCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 21:02:36 -0500
Subject: Re: Bounty for the first Open Source driver for Kinect
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTi=v9Ev0BDXBTWZs=LcMVGXoxcA7we5bKaR_m+2Z@mail.gmail.com>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
	 <AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
	 <AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
	 <20101110222418.6098a92a.ospite@studenti.unina.it>
	 <AANLkTin+HtdoXO7+ObNCoix70knaL+Fi4725BOWVXuy9@mail.gmail.com>
	 <AANLkTim4hzoTg4t-jHFUCrpQwQ9Pj2sbJAH=iuawrK7E@mail.gmail.com>
	 <20101111002952.f5873ed4.ospite@studenti.unina.it>
	 <AANLkTi=v9Ev0BDXBTWZs=LcMVGXoxcA7we5bKaR_m+2Z@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 11 Nov 2010 02:58:37 +0100
Message-Id: <1289440717.7148.30.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Am Donnerstag, den 11.11.2010, 00:36 +0100 schrieb Markus Rechberger:
> On Thu, Nov 11, 2010 at 12:29 AM, Antonio Ospite
> <ospite@studenti.unina.it> wrote:
> > On Thu, 11 Nov 2010 00:13:09 +0100
> > Markus Rechberger <mrechberger@gmail.com> wrote:
> >
> >> On Wed, Nov 10, 2010 at 11:48 PM, Mohamed Ikbel Boulabiar
> >> <boulabiar@gmail.com> wrote:
> >> > On Wed, Nov 10, 2010 at 10:24 PM, Antonio Ospite
> >> > <ospite@studenti.unina.it> wrote:
> >> >> If there are arguments against a kernel driver I can't see them yet.
> > [...]
> >> > If I want to use this device, I will add many userspace code to create
> >> > the skeleton model and that need much computation. Kernel Module adds
> >> > performance to my other code.
> >>
> >> just some experience from our side, we do have fully working
> >> video4linux1/2 drivers
> >> in userspace, the only exception we have is a very thin layered
> >> kernelmodule in order
> >> to improve the datatransfer.
> >
> > Markus, can you point to some example so I can get a clearer picture?
> >
> 
> unfortunately we're closed source (and much more advanced) but you can
> have a look at other projects:

Markus,

please go away with such.

Despite of all previously, this is _not_ a place for any closed source
to discuss. There is nothing to discuss on that, please stop it.

Either try to come back with open source in a new round, or at least
don't try to hide what you have. Without all the code and hardware
specific stuff _previously_ developed/hacked on v4l-dvb, you don't
exist.

I still admit, overall, you did a very good job previously, but all
others are _not_ just your captives after some clashes.

With "unfortunately we're closed source", you deliberately declare, that
you have nothing to do with open source at all anymore.

?

So, what is the remaining interest for you, except that you can continue
easier in userspace, instead of getting a hard block in the kernel, if
some enough have enough of your "closed source" ?

Cheers,
Hermann


> * libv4l2
> * freebsd has webcamd or something like that to emulate analog
> tv/webcams and dvb (they are even reusing linux kernel drivers with a
> userspace wrapper - so everything works in userspace for them).
> 
> aside of that you can just debug userspace drivers with gdb, valgrind
> etc. if issues come up it will only affect your work not the entire
> system, kernel is seriously something critical.
> 
> Markus
> > Thanks,
> >   Antonio
> >
> > --
> > Antonio Ospite
> > http://ao2.it

