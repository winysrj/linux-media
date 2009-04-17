Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZDQEeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 00:34:04 -0400
Date: Fri, 17 Apr 2009 01:32:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [REVIEW] v4l2 loopback
Message-ID: <20090417013239.72393e56@pedra.chehab.org>
In-Reply-To: <20090414160450.4ac1a498.ospite@studenti.unina.it>
References: <200903262049.10425.vasily@scopicsoftware.com>
	<200904131317.01731.hverkuil@xs4all.nl>
	<36c518800904131808m67482f2ex54307dfab91ccdf0@mail.gmail.com>
	<20090414091233.3ea2f6e4@pedra.chehab.org>
	<36c518800904140553m41fcbd34rb265e0993dd76689@mail.gmail.com>
	<20090414160450.4ac1a498.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 14 Apr 2009 16:04:50 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> On Tue, 14 Apr 2009 15:53:00 +0300
> vasaka@gmail.com wrote:
> 
> > On Tue, Apr 14, 2009 at 3:12 PM, Mauro Carvalho Chehab
> > <mchehab@infradead.org> wrote:
> >
> > > The issue I see is that the V4L drivers are meant to support real devices. This
> > > driver that is a loopback for some userspace driver. I don't discuss its value
> > > for testing purposes or other random usage, but I can't see why this should be
> > > at upstream kernel.
> > >
> > > So, I'm considering to add it at v4l-dvb tree, but as an out-of-tree driver
> > > only. For this to happen, probably, we'll need a few adjustments at v4l build.
> > >
> > > Cheers,
> > > Mauro
> > >
> > 
> > Mauro,
> > 
> > ok, let it be out-of -tree driver, this is also good as I do not have
> > to adapt the driver to each new kernel, but I want to argue alittle
> > about Inclusion of the driver into upstream kernel.
> > 
> >  Main reason for inclusion to the kernel is ease of use, as I
> > understand installing the out-of-tree driver for some kernel needs
> > downloading of the whole v4l-dvb tree(am I right?).
> > 
> >  Loopback gives one opportunities to do many fun things with video
> > streams and when it needs just one step to begin using it chances that
> > someone will do something useful with the driver are higher.
> >
> 
> I, as a target user of vloopback, agree that having it in mainline
> would be really handy. Think that with a stable vloopback solution,
> with device detection and parameter setting, we can really make PTP
> digicams as webcams[1] useful, right now this is tricky and very
> uncomfortable on kernel update.

This is, in fact, a good reason why we shouldn't add it upstream: instead of
adding proper V4L interface to PTP and other similar stuff, people could just
do some userspace hack with a in-kernel loopback (or even worse: work against
Open Source community, by writing binary-only drivers), and use the loopback to
make it work with existing applications (ok, there are other forms to provide
such things, but we shouldn't make it even easier).

I can see the value of a video loopback for development and tests, but those
people could easily download some tree with the video loopback driver and use
it.

> >  Awareness that there is such thing as loopback is also. If the driver
> > is in upstream tree - more people will see it and more chances that
> > more people will participate in loopback getiing better.

I'm afraid not. The contributions we generally receive on other drivers from
developers that don't participate on v4l-dvb community are generally just API
fixups and new board additions. In fact, the people that can help with this
driver will be already developing using v4l-dvb tree, so, I doubt you'll have
more contributions by having it on kernel.

> >  vivi is an upstream driver :-)
> >
> 
> Even vivi can be seen as a particular case of a vloopback device, can't
> it?

Vivi is just a driver skeleton. It could eventually be removed from upstream,
without any real damage. 

Yet, it is the easiest way for a video app developer to test their driver.

Also, vivi is very useful to test newer core improvements, before actually
damag^Wchanging the internal API's at the real drivers. I used it with this
objective during video_ioctl2() callback changes, during videobuf split into a
core and a helper module, and on other similar situations.

On the other hand, It is dubious that a distro would provide a kernel with this
module enabled. So, even being at the kernel tree, for you to use it, you'll
need to download the kernel and compile it by hand, or use v4l-dvb (it is the
same case of the DVB dummy frontend, for example).

Cheers,
Mauro
