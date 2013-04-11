Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:63846 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3DKSxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 14:53:06 -0400
Received: by mail-da0-f50.google.com with SMTP id t1so789569dae.23
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 11:53:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Barry Song <21cnbao@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAGsJ_4yXE7SYLgPucW9kAEYgKg+z93j8yN3d+gvhqeLAn-sSOw@mail.gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	"renwei.wu" <renwei.wu@csr.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	zilong.wu@csr.com, xiaomeng.hou@csr.com,
	linux-media@vger.kernel.org
References: <CAGsJ_4zCRBvEX9xEDCr27JLK6wYp_2T_wk2hzVjqpKinbL=9pg@mail.gmail.com>
 <Pine.LNX.4.64.1304110921480.23859@axis700.grange>
 <CAGsJ_4xXRHDbpuqT3e5=0vz9_NxxCXfvrci+h567HP9=AhwRiQ@mail.gmail.com>
 <Pine.LNX.4.64.1304111028090.23859@axis700.grange>
 <CAGsJ_4yXE7SYLgPucW9kAEYgKg+z93j8yN3d+gvhqeLAn-sSOw@mail.gmail.com>
Message-ID: <20130411185258.7915.67263@quantum>
Subject: Re: [PATCH v8 1/7] media: V4L2: add temporary clock helpers
Date: Thu, 11 Apr 2013 11:52:58 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Barry Song (2013-04-11 01:59:28)
> 2013/4/11 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > On Thu, 11 Apr 2013, Barry Song wrote:
> >
> >> 2013/4/11 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> >> > Hi Barry
> >> >
> >> > On Thu, 11 Apr 2013, Barry Song wrote:
> >> >
> >> >> Hi Guennadi,
> >> >>
> >> >> > Typical video devices like camera sensors require an external clock source.
> >> >> > Many such devices cannot even access their hardware registers without a
> >> >> > running clock. These clock sources should be controlled by their consumers.
> >> >> > This should be performed, using the generic clock framework. Unfortunately
> >> >> > so far only very few systems have been ported to that framework. This patch
> >> >> > adds a set of temporary helpers, mimicking the generic clock API, to V4L2.
> >> >> > Platforms, adopting the clock API, should switch to using it. Eventually
> >> >> > this temporary API should be removed.
> >> >>
> >> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@xxxxxx>
> >> >> > ---
> >> >>
> >> >> for your patch 1/8 and 3/8, i think it makes a lot of senses to let
> >> >> the object manages its own clock by itself.
> >> >> is it possible for us to implement v4l2-clk.c directly as an instance
> >> >> of standard clk driver for those systems which don't have generic
> >> >> clock,  and remove the V4L2 clock APIs like v4l2_clk_get,
> >> >> v4l2_clk_enable from the first day? i mean v4l2-clk.c becomes a temp
> >> >> and fake clock controller driver. finally, after people have
> >> >> generically clk, remove it.
> >> >
> >> > I don't think you can force-enable the CFF on systems, that don't support
> >> > it, e.g. PXA.
> >>
> >> yes. we can. clock is only a framework, has it any limitation to
> >> implement a driver instance on any platform?
> >
> > So, you enable CFF, it provides its own clk_* implementation like
> > clk_get_rate() etc. Now, PXA already has it defined in
> > arch/arm/mach-pxa/clock.c. Don't think this is going to fly.
> 
> agree.
> 

Hi,

I came into this thread late and don't have the actual patches in my
inbox for review.  That said, I don't understand why V4L2 cares about
the clk framework *implementation*?  The clk.h api is the same for
platforms using the common struct clk and those still using the legacy
method of defining their own struct clk.  If drivers are only consumers
of the clk.h api then the implementation underneath should not matter.

Regards,
Mike

> >
> > Thanks
> > Guennadi
> >
> >> people have tried to move to common clk and generic framework for a
> >> long time, now you still try to provide a v4l2 specific clock APIs, it
> >> just makes v4l2 unacceptable and much complex.
> >>
> >> >
> >> > Thanks
> >> > Guennadi
> >> >
> >> >> > v8: Updated both (C) dates
> >> >>
> >> >> >  drivers/media/v4l2-core/Makefile   |    2 +-
> >> >> >  drivers/media/v4l2-core/v4l2-clk.c |  177 ++++++++++++++++++++++++++++++++++++
> >> >> >  include/media/v4l2-clk.h           |   54 +++++++++++
> >> >> >  3 files changed, 232 insertions(+), 1 deletions(-)
> >> >> >  create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
> >> >> >  create mode 100644 include/media/v4l2-clk.h
> >> >>
> >> >> > diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> >> >> > index aa50c46..628c630 100644
> >> >> > --- a/drivers/media/v4l2-core/Makefile
> >> >> > +++ b/drivers/media/v4l2-core/Makefile
> >> >> > @@ -5,7 +5,7 @@
> >> >> >  tuner-objs :=      tuner-core.o
> >> >>
> >> >> >  videodev-objs      :=      v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> >> >> > -                   v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
> >> >> > +                   v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o
> >> >> > ifeq ($(CONFIG_COMPAT),y)
> >> >> >    videodev-objs += v4l2-compat-ioctl32.o
> >> >> >  endif
> >> >> > diff --git a/drivers/media/v4l2-core/v4l2-clk.c b/drivers/media/v4l2-core/v4l2-clk.c
> >> >> > new file mode 100644
> >> >> > index 0000000..d7cc13e
> >> >> > --- /dev/null
> >> >> > +++ b/drivers/media/v4l2-core/v4l2-clk.c
> >> >> > @@ -0,0 +1,177 @@
> >> >>
> >> >> -barry
> 
> -barry
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
