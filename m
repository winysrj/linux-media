Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52070 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3GXKFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 06:05:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 0/5] v4l2-async DT support improvement and cleanups
Date: Wed, 24 Jul 2013 12:06:29 +0200
Message-ID: <4947234.Fd6zD5WqhW@avalon>
In-Reply-To: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patches.

On Monday 22 July 2013 20:04:42 Sylwester Nawrocki wrote:
> Hello,
> 
> This is a few patches for the v4l2-async API I wrote while adding
> the asynchronous subdev registration support to the exynos4-is
> driver.
> 
> The most significant change is addition of V4L2_ASYNC_MATCH_OF
> subdev matching method, where host driver can pass a list of
> of_node pointers identifying its subdevs.
> 
> I thought it's a reasonable and simple enough way to support device tree
> based systems. Comments/other ideas are of course welcome.

I have similar patches in my tree that I haven't posted yet, so I like the 
idea :-) For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Thanks,
> Sylwester
> 
> Sylwester Nawrocki (5):
>   V4L2: Drop bus_type check in v4l2-async match functions
>   V4L2: Rename v4l2_async_bus_* to v4l2_async_match_*
>   V4L2: Add V4L2_ASYNC_MATCH_OF subdev matching type
>   V4L2: Rename subdev field of struct v4l2_async_notifier
>   V4L2: Fold struct v4l2_async_subdev_list with struct v4l2_subdev
> 
>  drivers/media/platform/soc_camera/soc_camera.c |    4 +-
>  drivers/media/v4l2-core/v4l2-async.c           |  106 ++++++++++-----------
>  include/media/v4l2-async.h                     |   36 ++++----
>  include/media/v4l2-subdev.h                    |   13 ++-
>  4 files changed, 74 insertions(+), 85 deletions(-)

-- 
Regards,

Laurent Pinchart

