Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41248 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3DLIWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 04:22:41 -0400
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
Date: Fri, 12 Apr 2013 10:22:41 +0200
Message-ID: <1682270.VnHBnRB9ZY@avalon>
In-Reply-To: <20130411231923.7915.17215@quantum>
References: <CAGsJ_4zCRBvEX9xEDCr27JLK6wYp_2T_wk2hzVjqpKinbL=9pg@mail.gmail.com> <13951098.tvATHWRRmI@avalon> <20130411231923.7915.17215@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On Thursday 11 April 2013 16:19:23 Mike Turquette wrote:
> Quoting Laurent Pinchart (2013-04-11 15:35:38)
> > On Thursday 11 April 2013 11:52:58 Mike Turquette wrote:

[snip]

> > > I came into this thread late and don't have the actual patches in my
> > > inbox for review.  That said, I don't understand why V4L2 cares about
> > > the clk framework *implementation*?  The clk.h api is the same for
> > > platforms using the common struct clk and those still using the legacy
> > > method of defining their own struct clk.  If drivers are only consumers
> > > of the clk.h api then the implementation underneath should not matter.
> > 
> > The issue on non-CCF systems is that devices usually can't register clocks
> > dynamically. (Most of) those systems provide system clocks only through
> > their clock API, without a way for the camera IP core to hook up the
> > clock(s) it can provide to the camera sensor. On the consumer side we
> > don't care much about the clock framework implementation, but on the
> > provider side we need a framework that allows registering non-system
> > clocks at runtime.
> 
> Yes, you do care about the clock framework implementation if you are a clock
> provider.  I still haven't gone through the archives to find these patches
> but I hope that any dependency on CONFIG_COMMON_CLK is conditionalized to
> have the smallest impact possible. Making v4l2 as a whole depend on
> COMMON_CLK might be a bit overkill compared to just making individual camera
> drivers depend on it.

The basic idea is to push the dependency on CONFIG_COMMON_CLK to individual 
drivers, and provide a V4L2-specific clock framework (that looks like a 
stripped-down version of CCF) for platforms that don't implement CCF yet.

-- 
Regards,

Laurent Pinchart

