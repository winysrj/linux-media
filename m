Return-path: <mchehab@pedra>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab0JSMkC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 08:40:02 -0400
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Airlie <airlied@gmail.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Greg KH <greg@kroah.com>, codalist@telemann.coda.cs.cmu.edu,
	autofs@linux.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
	Jan Kara <jack@suse.cz>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
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
In-Reply-To: <201010190926.54635.arnd@arndb.de>
References: <201009161632.59210.arnd@arndb.de>
	 <alpine.LNX.2.00.1010182342120.31740@banach.math.auburn.edu>
	 <AANLkTi=oAeuz8ZxcOMpf=3MVY=WMt0BwHiGCUxO7OAEV@mail.gmail.com>
	 <201010190926.54635.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 08:39:58 -0400
Message-ID: <1287491998.16971.360.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2010-10-19 at 09:26 +0200, Arnd Bergmann wrote:
> On Tuesday 19 October 2010 06:52:32 Dave Airlie wrote:
> > > I might be able to find some hardware still lying around here that uses an
> > > i810. Not sure unless I go hunting it. But I get the impression that if
> > > the kernel is a single-CPU kernel there is not any problem anyway? Don't
> > > distros offer a non-smp kernel as an installation option in case the user
> > > needs it? So in reality how big a problem is this?
> > 
> > Not anymore, which is my old point of making a fuss. Nowadays in the
> > modern distro world, we supply a single kernel that can at runtime
> > decide if its running on SMP or UP and rewrite the text section
> > appropriately with locks etc. Its like magic, and something like
> > marking drivers as BROKEN_ON_SMP at compile time is really wrong when
> > what you want now is a runtime warning if someone tries to hotplug a
> > CPU with a known iffy driver loaded or if someone tries to load the
> > driver when we are already in SMP mode.
> 
> We could make the driver run-time non-SMP by adding
> 
> 	if (num_present_cpus() > 1) {
> 		pr_err("i810 no longer supports SMP\n");
> 		return -EINVAL;
> 	}
> 
> to the init function. That would cover the vast majority of the
> users of i810 hardware, I guess.

I think we also need to cover the PREEMPT case too. But that could be a
compile time check, since you can't boot a preempt kernel and make it
non preempt.

-- Steve


