Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:59981 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0JSEao (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 00:30:44 -0400
Date: Tue, 19 Oct 2010 00:00:58 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Dave Airlie <airlied@gmail.com>, Greg KH <greg@kroah.com>,
	codalist@telemann.coda.cs.cmu.edu, autofs@linux.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>, Jan Kara <jack@suse.cz>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Arnd Bergmann <arnd@arndb.de>,
	Jan Harkes <jaharkes@cs.cmu.edu>, netdev@vger.kernel.org,
	Anders Larsen <al@alarsen.net>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Bryan Schumaker <bjschuma@netapp.com>,
	Christoph Hellwig <hch@infradead.org>,
	ksummit-2010-discuss@lists.linux-foundation.org,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	linux-fsdevel@vger.kernel.org,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Hendry <andrew.hendry@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
In-Reply-To: <1287459219.16971.352.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LNX.2.00.1010182342120.31740@banach.math.auburn.edu>
References: <201009161632.59210.arnd@arndb.de>  <201010181742.06678.arnd@arndb.de> <20101018184346.GD27089@kroah.com>  <AANLkTin2KPNNXvwcWphhM-5qexB14FS7M7ezkCCYCZ2H@mail.gmail.com>  <20101019004004.GB28380@kroah.com>  <AANLkTi=ffaihP5-yNYFKAbAbX+XbRgWRXXfCZd4J3KwQ@mail.gmail.com>
  <20101019022413.GB30307@kroah.com>  <AANLkTinv4VFpi=Jkc_5oyFgPbdLRg0ResJx9u9Puhm-7@mail.gmail.com> <1287459219.16971.352.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Mon, 18 Oct 2010, Steven Rostedt wrote:

> On Tue, 2010-10-19 at 12:45 +1000, Dave Airlie wrote:
> > On Tue, Oct 19, 2010 at 12:24 PM, Greg KH <greg@kroah.com> wrote:
> 
> > > So, there is no need for the i830 driver?  Can it just be removed
> > > because i915 works instead?
> > 
> > No because it provides a different userspace ABI to the i915 driver to
> > a different userspace X driver etc.
> > 
> > like I'm sure the intersection of this driver and reality are getting
> > quite limited, but its still a userspace ABI change and needs to be
> > treated as such. Xorg 6.7 and XFree86 4.3 were the last users of the
> > old driver/API.
> 
> Thus, you are saying that this will break for people with older user
> apps and have a newer kernel?
> 
> > 
> > >> So it really only leaves the problem case of what do distros do if we
> > >> mark things as BROKEN_ON_SMP, since no distro builds UP kernels and
> > >> when you boot the SMP kernels on UP they don't run as SMP so not
> > >> having the driver load on those is a problem. Maybe we just need some
> > >> sort of warn on smp if a smp unfriendly driver is loaded and we
> > >> transition to SMP mode. Though this sounds like either (a) something
> > >> we do now and I don't about it, (b) work.
> > >
> > > So you are saying that just because distros will never build such a
> > > thing, we should keep it building for SMP mode?  Why not prevent it from
> > > being built and if a distro really cares, then they will pony up the
> > > development to fix the driver up?
> > 
> > Distros build the driver now even it it didn't work on SMP it wouldn't
> > matter to the 99% of people who have this hw since it can't suppport
> > SMP except in some corner cases. So not building for SMP is the same
> > as just throwing it out of the kernel since most people don't run
> > kernel.org kernels, and shouldn't have to just to get a driver for
> > some piece of hardware that worked fine up until now.
> 
> Ah! Exactly! Thus, those that do not run kernel.org kernels are using a
> distro kernel. Wont these same people use the distro userspace? That is,
> if they have upgraded their kernel, most likely, they also update their
> X interface.
> 
> > 
> > Look at this from a user who has this hardware pov, it works for them
> > now with a distro kernel, us breaking it isn't going to help that user
> > or make any distro care, its just going to screw over the people who
> > are actually using it.
> 
> But they can use the i915 driver instead, because they are using the
> newer userspace apps.
> 
> > 
> > > In other words, if someone really cares, then they will do the work,
> > > otherwise why worry?  Especially as it seems that no one here is going
> > > to do it, right?
> > 
> > Well the thing is doing the work right is a non-trivial task and just
> > dropping support only screws the people using the hardware,
> > it doesn't place any burden on the distro developers to fix it up. If
> > people are really serious about making the BKL go away completely, I
> > think the onus should be on them to fix the drivers not on the users
> > who are using it, like I'm  guessing if this gets broken the bug will
> > end up in Novell or RH bugzilla in a year and nobody will ever see it.
> 
> Well the problem comes down to testing it. I don't know of any developer
> that is removing the BKL that actually owns hardware to test out these
> broken drivers. And for the change not being trivial, means that there's
> no way to do in correctly.
> 
> -- Steve

I might be able to find some hardware still lying around here that uses an 
i810. Not sure unless I go hunting it. But I get the impression that if 
the kernel is a single-CPU kernel there is not any problem anyway? Don't 
distros offer a non-smp kernel as an installation option in case the user 
needs it? So in reality how big a problem is this?

Theodore Kilgore
