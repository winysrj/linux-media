Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:32905 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZCSWnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 18:43:45 -0400
Date: Thu, 19 Mar 2009 15:43:42 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Alexey Klimov <klimov.linux@gmail.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [patch review] radio/Kconfig: introduce 3 groups: isa, pci, and
  others drivers
In-Reply-To: <20090319113903.7663ae71@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0903191526120.28292@shell2.speakeasy.net>
References: <1237467800.19717.37.camel@tux.localhost> <20090319110303.7a53f9bb@pedra.chehab.org>
 <208cbae30903190718l10911cc1j2a6f4f21b7f2b107@mail.gmail.com>
 <20090319113903.7663ae71@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009, Mauro Carvalho Chehab wrote:
> On Thu, 19 Mar 2009 17:18:47 +0300
> Alexey Klimov <klimov.linux@gmail.com> wrote:
> over what we currently have on our complex Kbuilding system.
>
> For the out-of-system building, one alternative would be to create some make
> syntax for building just some drivers, like:
>
> 	make driver=cx88,ivtv

The problem with this is that it's really hard to do decently.

For instance, if you want cx88 dvb support, you need some front-ends to do
anything with it.  Well, what front-ends should be turned on?  You can turn
on any number from none to all.  Probably all of them would be best.  But
there are tons of other tuners, front-ends, decoders, drivers, etc. that
cx88 doesn't use.  Those should be off.

So you give an algorithm the config variables you want set (e.g.,
VIDEO_CX88) and then tell it to find a valid solution to the rest of the
variables given the constraints from Kconfig.  This is the classic
NP-complete SAT problem.  It is hard, but we can solve this.

But we get a solution that has all the tuners, etc. that cx88 can't used
turned on.  That's not what we want!  So, we say we want the solution that
has the fewest modules turned on.  Well, you've just made the problem much
much harder to solve as SAT solving heuristics won't do you any good now.

But suppose we solve it anyway and get the solution with the fewest modules
turned on.  It's going to have all the frontends cx88 can use turned OFF.
That's not what we want either!  How is the algorithm supposed to know what
we want on and what we want off?  We basically have to do it so that 'make
cx88' means use certain exact config options that someone has manually
pre-configured.
