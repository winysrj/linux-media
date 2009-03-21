Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:48986 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbZCUVLl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 17:11:41 -0400
Subject: Re: [patch review] radio/Kconfig: introduce 3 groups: isa, pci,
 and others drivers
From: Alain Kalker <miki@dds.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0903191526120.28292@shell2.speakeasy.net>
References: <1237467800.19717.37.camel@tux.localhost>
	 <20090319110303.7a53f9bb@pedra.chehab.org>
	 <208cbae30903190718l10911cc1j2a6f4f21b7f2b107@mail.gmail.com>
	 <20090319113903.7663ae71@pedra.chehab.org>
	 <Pine.LNX.4.58.0903191526120.28292@shell2.speakeasy.net>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 22:11:30 +0100
Message-Id: <1237669890.6280.51.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op donderdag 19-03-2009 om 15:43 uur [tijdzone -0700], schreef Trent
Piepho:
> On Thu, 19 Mar 2009, Mauro Carvalho Chehab wrote:
> > On Thu, 19 Mar 2009 17:18:47 +0300
> > Alexey Klimov <klimov.linux@gmail.com> wrote:
> > over what we currently have on our complex Kbuilding system.
> >
> > For the out-of-system building, one alternative would be to create some make
> > syntax for building just some drivers, like:
> >
> > 	make driver=cx88,ivtv
> 
> The problem with this is that it's really hard to do decently.

It depends on how you define 'decently'. We're not trying to find a
general solution to the Boolean Satisfiability Problem here, we can use
information about the structure of the dependencies to simplify.
As I see it, drivers depend on subsystems, which in turn depend on core
functionality. These are mandatory dependencies: an USB device won't
function without USB support.
Then there are recommended and optional dependencies, which enhance the
functionality of a driver. As I have seen with the dummy frontend
module, a driver doesn't need to _have_ a frontend module to be
functional (e.g. if there simply isn't one written yet), it just will be
(much) less useful.

Pruning (deselecting) all principal modules (i.e. those that actually
provide modaliases) for devices that we don't want, and then pruning all
of their dependencies that have now become redundant (i.e. modules that
have nothing or only unselected modules depending on them) seems decent
enough to me.

> For instance, if you want cx88 dvb support, you need some front-ends to do
> anything with it.  Well, what front-ends should be turned on?  You can turn
> on any number from none to all.  Probably all of them would be best.  But
> there are tons of other tuners, front-ends, decoders, drivers, etc. that
> cx88 doesn't use.  Those should be off.

This is already covered by DVB_FE_CUSTOMIZE. A user who just wants a
driver for his device and doesn't know (or care) what frontend it uses,
can just supply a target config of:

CONFIG_DVB_FE_CUSTOMISE=n
CONFIG_<driver>=m

and build the driver, which should simply build all available frontend
modules. This already happens with allmodconfig, and as far as I know,
the current drivers don't care if one or many frontent modules are
available, the right one to use will be selected during hardware
probe/attach depending on the actual hardware anyway.

A user who wants to further customise the frontend(s) used with the
driver, should supply this information:

DVB_FE_CUSTOMISE=y
CONFIG_<driver>=m
CONFIG_<frontend>=M
...

This looks very much like the 'virtual packages' and 'alternatives'
support in package managers.

> So you give an algorithm the config variables you want set (e.g.,
> VIDEO_CX88) and then tell it to find a valid solution to the rest of the
> variables given the constraints from Kconfig.  This is the classic
> NP-complete SAT problem.  It is hard, but we can solve this.

By redefining dependencies and restructuring the dependency graph so
requirements can be propagated better, you can greatly reduce this
problem, to the point that simple search, backtracking or heuristics
become quite feasible. Again, package managers are a good example.
Entire Linux installers, live cds and preconfigured embedded systems are
being generated with very little user intervention on a daily basis.

Kind regards,

Alain

