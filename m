Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50949 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754141AbZCEUgG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 15:36:06 -0500
Date: Thu, 5 Mar 2009 21:36:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <Pine.LNX.4.58.0903051217070.24268@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.64.0903052129510.4980@axis700.grange>
References: <200903022218.24259.hverkuil@xs4all.nl> <20090304141715.0a1af14d@pedra.chehab.org>
 <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
 <Pine.LNX.4.58.0903051217070.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Trent Piepho wrote:

> On Thu, 5 Mar 2009, Guennadi Liakhovetski wrote:
> > On Wed, 4 Mar 2009, Mauro Carvalho Chehab wrote:
> > > Beside the fact that we don't need to strip support for legacy kernels, the
> > > advantage of using this method is that we can evolute to a new development
> > > model. As several developers already required, we should really use the
> > > standard -git tree as everybody's else. This will simplify a lot the way we
> > > work, and give us more agility to send patches upstream.
> > >
> > > With this backport script, plus the current v4l-dvb building systems, and after
> > > having all backport rules properly mapped, we can generate a "test tree"
> > > based on -git drivers/media, for the users to test the drivers against their
> > > kernels, and still use a clean tree for development.
> >
> > Sorry, switching to git is great, but just to make sure I understood you
> > right: by "-git drivers/media" you don't mean it is going to be a git tree
> > of only drivers/media, but it is going to be a normal complete Linux
> > kernel tree, right?
> 
> So there will be no way we can test a driver without switching to a new
> kernel hourly?  And there is no way we can test someone else's tree without
> compiling an entirely new kernel and rebooting?  And every tree we want to
> work on requires a complete copy of the entire kernel source?

AFAIR, Mauro wanted to provide snapshots for those who absolutely prefer 
to work with partial trees. Although, to be honest, I don't understand 
what makes video drivers so special. Think about audio drivers, or 
network, including WLAN. I never heard about those subsystems working with 
or providing subtree snapshots. If only before specific drivers or 
subsystems are included in the mainline, but not long after that.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
