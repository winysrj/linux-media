Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:46569 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab3AHO6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 09:58:05 -0500
Message-ID: <50EC32A5.6010306@gmail.com>
Date: Tue, 08 Jan 2013 15:52:21 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH 1/6 v4] media: V4L2: support asynchronous subdevice registration
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de> <1356544151-6313-2-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1301071121280.23972@axis700.grange> <2418280.Sa45Lqe0AC@avalon>
In-Reply-To: <2418280.Sa45Lqe0AC@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/08/2013 09:10 AM, Laurent Pinchart wrote:
>> +/*
>> + * If subdevice probing fails any time after v4l2_async_subdev_bind(), no
>> + * clean up must be called. This function is only a message of intention.
>> + */
>> +int v4l2_async_subdev_bind(struct v4l2_async_subdev_list *asdl);
>> +int v4l2_async_subdev_bound(struct v4l2_async_subdev_list *asdl);
>
> Could you please explain why you need both a bind notifier and a bound
> notifier ? I was expecting a single v4l2_async_subdev_register() call in
> subdev drivers (and, thinking about it, I would probably name it
> v4l2_subdev_register()).

I expected it to be done this way too, and I also used 
v4l2_subdev_register()
name in my early version of the subdev registration code where subdevs
were registering themselves to the v4l2 core.

BTW, this might not be most important thing here, but do we need separate
file, i.e. v4l2-async.c, instead of for example putting it in 
v4l2-device.c ?

>> +void v4l2_async_subdev_unbind(struct v4l2_async_subdev_list *asdl);
>> +#endif

--

Regards,
Sylwester
