Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:56357 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbZCRBM3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 21:12:29 -0400
Subject: Re: Improve DKMS build of v4l-dvb?
From: Alain Kalker <miki@dds.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0903171153230.28292@shell2.speakeasy.net>
References: <1236612894.5982.72.camel@miki-desktop>
	 <Pine.LNX.4.58.0903130153220.28292@shell2.speakeasy.net>
	 <1237303798.5988.27.camel@miki-desktop>
	 <Pine.LNX.4.58.0903171153230.28292@shell2.speakeasy.net>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 02:12:24 +0100
Message-Id: <1237338744.5988.176.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op dinsdag 17-03-2009 om 12:50 uur [tijdzone -0700], schreef Trent
Piepho:
> On Tue, 17 Mar 2009, Alain Kalker wrote:
> > Op vrijdag 13-03-2009 om 02:12 uur [tijdzone -0700], schreef Trent
> > Piepho:
> > > On Mon, 9 Mar 2009, Alain Kalker wrote:
> > > > Firstly: generating a .config with just one config variable for the
> > > > requested driver set to 'm' merged with the config for the kernel being
> > > > built for, and then doing a "make silentoldconfig". Big disatvantage is
> > > > that full kernel source is required for the 'silentoldconfig' target to
> > > > be available.
> > >
> > > Does that actually work?  Figuring out that needs to be turned on to enable
> > > some config options is a hard problem.  It's not just simple dependencies
> > > between modules, but complex expressions that need to be satisfied.  E.g.,
> > > something "depends on A || B", which do you turn on, A or B?  There are
> > > multiple solutions so how does the code decide which is best?
> >
> > Well, make_kconfig.pl does quite a nice job trying to select as many
> > drivers without causing conflicts.
> 
> What I did in make_kconfig.pl was just turn everything on, then recursively
> disable anything that has a failed dependency.  There isn't any
> intelligence when it comes to choices where you can have driver set A or
> driver set B, but not both.  Options that we want disabled, like some
> drivers' advanced debug controls, must be explicitly disabled in
> make_kconfig.  Still, it ends up doing what we want in the end, which is to
> compile all the drivers that we can compile.
> 
> > Anyway, you're quite right about this being a hard problem, and the
> > fact that the Kconfig system wasn't designed to be very helpful in
> > auto-selecting dependencies and resolving conflicts the same way modern
> > package managers are, doesn't make it any easier.
> 
> >From what I can tell, solving the dependency problem is easily shown to be
> the same as the classical satisfiability problem, which is proven to be NP
> complete.  Now, there are heuristics that can usually solve SAT problems
> quicker but finding the "best" solution quickly is quite a bit harder.

Yet, most of us are quite content with the solutions which the
dependency resolvers in package managers offer, even if they're possibly
non-optimal. Package maintainers try very hard to find ways to ease the
dependency problem by supplying acceptable defaults. And like I said
before, when no unique solution can be found, the user should have the
final say on which solution should be applied.

Back to the problem of DKMS builds, I'm not looking for a "perfect"
solution for a single driver (neither does make_kconfig.pl look for a
"perfect solution for all drivers at once :-) ), I'm looking for a way
to reduces the total number of modules that have to be rebuilt when the
v4l-dvb source or the kernel is upgraded.

How about disabling all modules which don't affect the dependencies of
the "target" driver? Attacking the problem from the other side, so to
speak. Even when unneccessary modules are still left enabled in the
.config, this is still better than building everything but the kitchen
sink, which is what the current DKMS script does (it simply does a
"make all").

> You don't need write access to the kernel source.  The kernel's config
> programs have to be built, but that can be done ahead of time.  Once they
> are, then you can use that menu tool from v4l-dvb without write access to
> the kernel source.
> 
> There is support for an alternate output directory for the kernel that can
> work too.  In the kernel dir, run "make O=~/kernel-output-dir menuconfig".
> That should not require write access to the kernel source dir and will put
> the necessary config programs in ~/kernel-output-dir.  Then point v4l-dvb
> at the kernel output dir, with "make release DIR=~/kernel-output-dir".
> 
> See the explanation from my changeset that added this,
> http://linuxtv.org/hg/v4l-dvb/log/6331 Good thing I wrote this 17 months
> ago when I did the work, instead of just using some two word patch
> description, since I sure wouldn't remember how all that works today.

Thanks for the info, I will try this.

Kind regards, Alain

