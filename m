Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZCTWtA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 18:49:00 -0400
Date: Fri, 20 Mar 2009 19:48:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [patch review] radio/Kconfig: introduce 3 groups: isa, pci, and
  others drivers
Message-ID: <20090320194831.76352e76@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0903191526120.28292@shell2.speakeasy.net>
References: <1237467800.19717.37.camel@tux.localhost>
	<20090319110303.7a53f9bb@pedra.chehab.org>
	<208cbae30903190718l10911cc1j2a6f4f21b7f2b107@mail.gmail.com>
	<20090319113903.7663ae71@pedra.chehab.org>
	<Pine.LNX.4.58.0903191526120.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009 15:43:42 -0700 (PDT)
Trent Piepho <xyzzy@speakeasy.org> wrote:

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

True.

> For instance, if you want cx88 dvb support, you need some front-ends to do
> anything with it.  Well, what front-ends should be turned on?  You can turn
> on any number from none to all.  Probably all of them would be best.  But
> there are tons of other tuners, front-ends, decoders, drivers, etc. that
> cx88 doesn't use.  Those should be off.
>
> So you give an algorithm the config variables you want set (e.g.,
> VIDEO_CX88) and then tell it to find a valid solution to the rest of the
> variables given the constraints from Kconfig.  This is the classic
> NP-complete SAT problem.  It is hard, but we can solve this.
> 
> But we get a solution that has all the tuners, etc. that cx88 can't used
> turned on.  That's not what we want!  So, we say we want the solution that
> has the fewest modules turned on.  Well, you've just made the problem much
> much harder to solve as SAT solving heuristics won't do you any good now.
> 
> But suppose we solve it anyway and get the solution with the fewest modules
> turned on.  It's going to have all the frontends cx88 can use turned OFF.
> That's not what we want either!  How is the algorithm supposed to know what
> we want on and what we want off?  We basically have to do it so that 'make
> cx88' means use certain exact config options that someone has manually
> pre-configured.

It is hard to have a tool that will truly compile just the minimum amount of
things that the user needs.

Yet, it seems valid to have a make to select some specific subsets. For
example, we may select the the "common" configs, like:
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y
CONFIG_DVB_DYNAMIC_MINORS=y
(we need to add here also the menu-only group of configs)

And allowing the automation of the helper chips:
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
# CONFIG_DVB_FE_CUSTOMISE is not set

Then, the make will add just the modules for that specific driver. In the case
of cx88, an interesting subset would be to select CX88*:

CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m

For sure this is _not_ the minimal set of cx88. People may not want
blackbird, or their device may not need xc5000, for example.

Yet, it is faster to compile the above 42 kernel modules than all the 200+
modules of a full build.

The advantages are bigger if we think on those smaller drivers, like for example opera1:
CONFIG_DVB_USB_OPERA1=m

Such config will compile only 15 drivers:
  LD [M]  /home/v4l/master/v4l/dvb-usb-opera.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb.ko
  LD [M]  /home/v4l/master/v4l/tea5767.ko
  LD [M]  /home/v4l/master/v4l/stv0299.ko
  LD [M]  /home/v4l/master/v4l/dvb-pll.ko
  LD [M]  /home/v4l/master/v4l/mt20xx.ko
  LD [M]  /home/v4l/master/v4l/mc44s803.ko
  LD [M]  /home/v4l/master/v4l/xc5000.ko
  LD [M]  /home/v4l/master/v4l/tuner-simple.ko
  LD [M]  /home/v4l/master/v4l/tuner-types.ko
  LD [M]  /home/v4l/master/v4l/tda8290.ko
  LD [M]  /home/v4l/master/v4l/v4l2-common.ko
  LD [M]  /home/v4l/master/v4l/tea5761.ko
  LD [M]  /home/v4l/master/v4l/tuner-xc2028.ko
  LD [M]  /home/v4l/master/v4l/tda9887.ko

Cheers,
Mauro
