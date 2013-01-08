Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54596 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3AHVWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 16:22:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH 1/6 v4] media: V4L2: support asynchronous subdevice registration
Date: Tue, 08 Jan 2013 22:23:59 +0100
Message-ID: <2104236.7Jc8OO4KhX@avalon>
In-Reply-To: <50EC32A5.6010306@gmail.com>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de> <2418280.Sa45Lqe0AC@avalon> <50EC32A5.6010306@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 08 January 2013 15:52:21 Sylwester Nawrocki wrote:
> On 01/08/2013 09:10 AM, Laurent Pinchart wrote:
> >> +/*
> >> + * If subdevice probing fails any time after v4l2_async_subdev_bind(),
> >> + * no clean up must be called. This function is only a message of
> >> + * intention.
> >> + */
> >> +int v4l2_async_subdev_bind(struct v4l2_async_subdev_list *asdl);
> >> +int v4l2_async_subdev_bound(struct v4l2_async_subdev_list *asdl);
> > 
> > Could you please explain why you need both a bind notifier and a bound
> > notifier ? I was expecting a single v4l2_async_subdev_register() call in
> > subdev drivers (and, thinking about it, I would probably name it
> > v4l2_subdev_register()).
> 
> I expected it to be done this way too, and I also used
> v4l2_subdev_register() name in my early version of the subdev registration
> code where subdevs were registering themselves to the v4l2 core.

I think we can switch back to v4l2_subdev_register() if we can solve the clock 
name issue. This doesn't seem impossible at first sight.

> BTW, this might not be most important thing here, but do we need separate
> file, i.e. v4l2-async.c, instead of for example putting it in v4l2-device.c
> ?

I'm fine with both, but I tend to try and keep source files not too large for 
ease of reading. Depending on the amount of code we end up adding, moving the 
functions to v4l2-device.c might be a good idea.

> >> +void v4l2_async_subdev_unbind(struct v4l2_async_subdev_list *asdl);
> >> +#endif

-- 
Regards,

Laurent Pinchart

