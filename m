Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38459 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759380Ab3DKWfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 18:35:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	"renwei.wu" <renwei.wu@csr.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	zilong.wu@csr.com, xiaomeng.hou@csr.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v8 1/7] media: V4L2: add temporary clock helpers
Date: Fri, 12 Apr 2013 00:35:38 +0200
Message-ID: <13951098.tvATHWRRmI@avalon>
In-Reply-To: <20130411185258.7915.67263@quantum>
References: <CAGsJ_4zCRBvEX9xEDCr27JLK6wYp_2T_wk2hzVjqpKinbL=9pg@mail.gmail.com> <CAGsJ_4yXE7SYLgPucW9kAEYgKg+z93j8yN3d+gvhqeLAn-sSOw@mail.gmail.com> <20130411185258.7915.67263@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On Thursday 11 April 2013 11:52:58 Mike Turquette wrote:
> Quoting Barry Song (2013-04-11 01:59:28)
> > 2013/4/11 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > > On Thu, 11 Apr 2013, Barry Song wrote:
> > >> 2013/4/11 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > >> > On Thu, 11 Apr 2013, Barry Song wrote:
> > >> >> Hi Guennadi,
> > >> >> 
> > >> >> > Typical video devices like camera sensors require an external
> > >> >> > clock source. Many such devices cannot even access their hardware
> > >> >> > registers without a running clock. These clock sources should be
> > >> >> > controlled by their consumers. This should be performed, using the
> > >> >> > generic clock framework. Unfortunately so far only very few
> > >> >> > systems have been ported to that framework. This patch adds a set
> > >> >> > of temporary helpers, mimicking the generic clock API, to V4L2.
> > >> >> > Platforms, adopting the clock API, should switch to using it.
> > >> >> > Eventually this temporary API should be removed.
> > >> >> > 
> > >> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@xxxxxx>
> > >> >> > ---
> > >> >> 
> > >> >> for your patch 1/8 and 3/8, i think it makes a lot of senses to let
> > >> >> the object manages its own clock by itself.
> > >> >> is it possible for us to implement v4l2-clk.c directly as an
> > >> >> instance of standard clk driver for those systems which don't have
> > >> >> generic clock,  and remove the V4L2 clock APIs like v4l2_clk_get,
> > >> >> v4l2_clk_enable from the first day? i mean v4l2-clk.c becomes a temp
> > >> >> and fake clock controller driver. finally, after people have
> > >> >> generically clk, remove it.
> > >> > 
> > >> > I don't think you can force-enable the CFF on systems, that don't
> > >> > support it, e.g. PXA.
> > >> 
> > >> yes. we can. clock is only a framework, has it any limitation to
> > >> implement a driver instance on any platform?
> > > 
> > > So, you enable CFF, it provides its own clk_* implementation like
> > > clk_get_rate() etc. Now, PXA already has it defined in
> > > arch/arm/mach-pxa/clock.c. Don't think this is going to fly.
> > 
> > agree.
> 
> I came into this thread late and don't have the actual patches in my inbox
> for review.  That said, I don't understand why V4L2 cares about the clk
> framework *implementation*?  The clk.h api is the same for platforms using
> the common struct clk and those still using the legacy method of defining
> their own struct clk.  If drivers are only consumers of the clk.h api then
> the implementation underneath should not matter.

The issue on non-CCF systems is that devices usually can't register clocks 
dynamically. (Most of) those systems provide system clocks only through their 
clock API, without a way for the camera IP core to hook up the clock(s) it can 
provide to the camera sensor. On the consumer side we don't care much about 
the clock framework implementation, but on the provider side we need a 
framework that allows registering non-system clocks at runtime.

-- 
Regards,

Laurent Pinchart

