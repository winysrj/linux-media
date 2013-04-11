Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3DKHWp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 03:22:45 -0400
Date: Thu, 11 Apr 2013 09:22:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Barry Song <21cnbao@gmail.com>
cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"renwei.wu" <renwei.wu@csr.com>,
	DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
	xiaomeng.hou@csr.com, zilong.wu@csr.com
Subject: Re: [PATCH v8 1/7] media: V4L2: add temporary clock helpers
In-Reply-To: <CAGsJ_4zCRBvEX9xEDCr27JLK6wYp_2T_wk2hzVjqpKinbL=9pg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1304110921480.23859@axis700.grange>
References: <CAGsJ_4zCRBvEX9xEDCr27JLK6wYp_2T_wk2hzVjqpKinbL=9pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Barry

On Thu, 11 Apr 2013, Barry Song wrote:

> Hi Guennadi,
> 
> > Typical video devices like camera sensors require an external clock source.
> > Many such devices cannot even access their hardware registers without a
> > running clock. These clock sources should be controlled by their consumers.
> > This should be performed, using the generic clock framework. Unfortunately
> > so far only very few systems have been ported to that framework. This patch
> > adds a set of temporary helpers, mimicking the generic clock API, to V4L2.
> > Platforms, adopting the clock API, should switch to using it. Eventually
> > this temporary API should be removed.
> 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@xxxxxx>
> > ---
> 
> for your patch 1/8 and 3/8, i think it makes a lot of senses to let
> the object manages its own clock by itself.
> is it possible for us to implement v4l2-clk.c directly as an instance
> of standard clk driver for those systems which don't have generic
> clock,  and remove the V4L2 clock APIs like v4l2_clk_get,
> v4l2_clk_enable from the first day? i mean v4l2-clk.c becomes a temp
> and fake clock controller driver. finally, after people have
> generically clk, remove it.

I don't think you can force-enable the CFF on systems, that don't support 
it, e.g. PXA.

Thanks
Guennadi

> > v8: Updated both (C) dates
> 
> >  drivers/media/v4l2-core/Makefile   |    2 +-
> >  drivers/media/v4l2-core/v4l2-clk.c |  177 ++++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-clk.h           |   54 +++++++++++
> >  3 files changed, 232 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
> >  create mode 100644 include/media/v4l2-clk.h
> 
> > diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> > index aa50c46..628c630 100644
> > --- a/drivers/media/v4l2-core/Makefile
> > +++ b/drivers/media/v4l2-core/Makefile
> > @@ -5,7 +5,7 @@
> >  tuner-objs	:=	tuner-core.o
> 
> >  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> > -			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
> > +			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o
> > ifeq ($(CONFIG_COMPAT),y)
> >    videodev-objs += v4l2-compat-ioctl32.o
> >  endif
> > diff --git a/drivers/media/v4l2-core/v4l2-clk.c b/drivers/media/v4l2-core/v4l2-clk.c
> > new file mode 100644
> > index 0000000..d7cc13e
> > --- /dev/null
> > +++ b/drivers/media/v4l2-core/v4l2-clk.c
> > @@ -0,0 +1,177 @@
> 
> -barry
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
