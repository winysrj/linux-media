Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:54491 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZCEU5T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 15:57:19 -0500
Date: Thu, 5 Mar 2009 12:57:16 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <Pine.LNX.4.64.0903052129510.4980@axis700.grange>
Message-ID: <Pine.LNX.4.58.0903051243270.24268@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl> <20090304141715.0a1af14d@pedra.chehab.org>
 <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
 <Pine.LNX.4.58.0903051217070.24268@shell2.speakeasy.net>
 <Pine.LNX.4.64.0903052129510.4980@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Guennadi Liakhovetski wrote:
> On Thu, 5 Mar 2009, Trent Piepho wrote:
> > On Thu, 5 Mar 2009, Guennadi Liakhovetski wrote:
> > > On Wed, 4 Mar 2009, Mauro Carvalho Chehab wrote:
> > > > Beside the fact that we don't need to strip support for legacy kernels, the
> > > > advantage of using this method is that we can evolute to a new development
> > > > model. As several developers already required, we should really use the
> > > > standard -git tree as everybody's else. This will simplify a lot the way we
> > > > work, and give us more agility to send patches upstream.
> > > >
> > > > With this backport script, plus the current v4l-dvb building systems, and after
> > > > having all backport rules properly mapped, we can generate a "test tree"
> > > > based on -git drivers/media, for the users to test the drivers against their
> > > > kernels, and still use a clean tree for development.
> > >
> > > Sorry, switching to git is great, but just to make sure I understood you
> > > right: by "-git drivers/media" you don't mean it is going to be a git tree
> > > of only drivers/media, but it is going to be a normal complete Linux
> > > kernel tree, right?
> >
> > So there will be no way we can test a driver without switching to a new
> > kernel hourly?  And there is no way we can test someone else's tree without
> > compiling an entirely new kernel and rebooting?  And every tree we want to
> > work on requires a complete copy of the entire kernel source?
>
> AFAIR, Mauro wanted to provide snapshots for those who absolutely prefer
> to work with partial trees. Although, to be honest, I don't understand
> what makes video drivers so special. Think about audio drivers, or
> network, including WLAN. I never heard about those subsystems working with
> or providing subtree snapshots. If only before specific drivers or
> subsystems are included in the mainline, but not long after that.

ALSA used a partial tree, but their system was much worse than v4l-dvb's.
I think the reason more systems don't do it is that setting up the build
system we have with v4l-dvb was a lot of work.  They don't have that.

Lots of subsystems are more tightly connected to the kernel and compiling
the subsystem out of tree against any kernel just wouldn't work.  Some
subsystems (like say gpio or led) mostly provide a framework to the rest of
the kernel so working on them without the rest of the tree doesn't make
sense either.  Or they don't get many patches and don't have many active
maintainers so they don't really have any development SCM at all.  Just
some patches through email that get applied by one maintainer.
