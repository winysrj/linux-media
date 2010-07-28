Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56131 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755795Ab0G1RCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 13:02:40 -0400
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
In-Reply-To: <4C504FDB.4070400@redhat.com>
References: <1280269990.21278.15.camel@maxim-laptop>
	 <1280273550.32216.4.camel@maxim-laptop>
	 <AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
	 <AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
	 <1280298606.6736.15.camel@maxim-laptop>
	 <AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>
	 <4C502CE6.80106@redhat.com>
	 <AANLkTinCs7f6zF-tYZqJ49CAjNWF=2MPGh0VRuU=VLzq@mail.gmail.com>
	 <1280327929.11072.24.camel@morgan.silverblock.net>
	 <AANLkTikFfXx4NBB2z2UXNt5Kt-2QrvTfvK0nQhSSqw8v@mail.gmail.com>
	 <4C504FDB.4070400@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 13:02:10 -0400
Message-ID: <1280336530.19593.52.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-07-28 at 12:42 -0300, Mauro Carvalho Chehab wrote:
> Em 28-07-2010 11:53, Jon Smirl escreveu:
> > On Wed, Jul 28, 2010 at 10:38 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> >> On Wed, 2010-07-28 at 09:46 -0400, Jon Smirl wrote:

> > I recommend that all decoders initially follow the strict protocol
> > rules. That will let us find bugs like this one in the ENE driver.
> 
> Agreed.

Well... 

I'd possibly make an exception for the protocols that have long-mark
leaders.  The actual long mark measurement can be far off from the
protocol's specification and needs a larger tolerance (IMO).

Only allowing 0.5 to 1.0 of a protocol time unit tolerance, for a
protocol element that is 8 to 16 protocol time units long, doesn't make
too much sense to me.  If the remote has the basic protocol time unit
off from our expectation, the error will likely be amplified in a long
protocol elements and very much off our expectation.


> I think that the better is to add some parameters, via sysfs, to relax the
> rules at the current decoders, if needed.

Is that worth the effort?  It seems like only going half-way to an
ultimate end state.

<crazy idea>
If you go through the effort of implementing fine grained controls
(tweaking tolerances for this pulse type here or there), why not just
implement a configurable decoding engine that takes as input:

	symbol definitions
		(pulse and space length specifications and tolerances)
	pulse train states
	allowed state transitions
	gap length
	decoded output data length

and instantiates a decoder that follows a user-space provided
specification?

The user can write his own decoding engine specification in a text file,
feed it into the kernel, and the kernel can implement it for him.
</crazy idea>

OK, maybe that is a little too much time and effort. ;)

Regards,
Andy


> Cheers,
> Mauro


