Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36175 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbbAARmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 12:42:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, m.chehab@samsung.com,
	linux-arm-kernel@lists.infradead.org, s.nawrocki@samsung.com,
	festevam@gmail.com, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4 2/5] media: ov2640: add async probe function
Date: Thu, 01 Jan 2015 19:43:02 +0200
Message-ID: <2161202.2T9kzBHd7d@avalon>
In-Reply-To: <54A2782F.7040907@atmel.com>
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com> <18685044.d1UcSWNIMH@avalon> <54A2782F.7040907@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Tuesday 30 December 2014 18:02:23 Josh Wu wrote:
> On 12/30/2014 8:15 AM, Laurent Pinchart wrote:
> > On Monday 29 December 2014 16:28:02 Josh Wu wrote:
> >> On 12/26/2014 6:06 PM, Laurent Pinchart wrote:
> >>> On Friday 26 December 2014 10:14:26 Guennadi Liakhovetski wrote:
> >>>> On Fri, 26 Dec 2014, Laurent Pinchart wrote:

[snip]

> >>>>> Talking about mclk and xvclk is quite confusing. There's no mclk from
> >>>>> an ov2640 point of view. The ov2640 driver should call
> >>>>> v4l2_clk_get("xvclk").
> >>>> 
> >>>> Yes, I also was thinking about this, and yes, requesting a "xvclk"
> >>>> clock would be more logical. But then, as you write below, if we let
> >>>> the v4l2_clk wrapper first check for a CCF "xvclk" clock, say, none is
> >>>> found. How do we then find the exported "mclk" V4L2 clock? Maybe
> >>>> v4l2_clk_get() should use two names?..
> >>> 
> >>> Given that v4l2_clk_get() is only used by soc-camera drivers and that
> >>> they all call it with the clock name set to "mclk", I wonder whether we
> >>> couldn't just get rid of struct v4l2_clk.id and ignore the id argument
> >>> to v4l2_clk_get() when CCF isn't available. Maybe we've overdesigned
> >>> v4l2_clk :-)
> >> 
> >> Sorry, I'm not clear about how to implement what you discussed here.
> >> 
> >> Do you mean, In the ov2640 driver:
> >> 1. need to remove the patch 4/5, "add a master clock for sensor"
> > 
> > No, the sensor has a clock input named "xvclk", the ov2640 driver should
> > thus manage that clock. Patch 4/5 does the right thing.
> > 
> > However, I've just realized that it will cause regressions on the i.MX27,
> > i.MX31 and i.MX37 3DS development boards that use the sensor without
> > registering a clock named xvclk. You should fix that as part of the patch
> > series.
> 
> Thanks for the information.
> So I think to be compatible with i.MX series board, I have two ways:
>   1. Make the xvclk clock be optional in ov2640 driver. After the i.MX
> series board switch to CCF, and we can change it to mandatory.
>   2. switch the i.MX host driver to DT, and add the xvclk to their dts.
> 
> As I am not similar with i.MX board and cannot test for them. I prefer
> to the #1, which is simple and work well. We can change the property
> when CCF & DT is introduced to i.MX boards.

I'd be fine with this if DT bindings were not required to be stable. The 
driver can always be fixed later, but biding should be correct from the start. 
As the ov2640 chip requires a clock, the bindings must require the clock, and 
the driver must enforce the requirement, at least when the device is 
instantiated from DT.

-- 
Regards,

Laurent Pinchart

