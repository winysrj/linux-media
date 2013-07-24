Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3GXLhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 07:37:01 -0400
Date: Wed, 24 Jul 2013 13:36:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 0/5] v4l2-async DT support improvement and cleanups
In-Reply-To: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1307241333020.30777@axis700.grange>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Mon, 22 Jul 2013, Sylwester Nawrocki wrote:

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
> I thought it's a reasonable and simple enough way to support device
> tree based systems. Comments/other ideas are of course welcome.

Thanks for the patches. In principle I have nothing against them, OF 
support looks good, integrating asdl into struct v4l2_subdev, dropping 
redundant checks, renaming "bus" to "match look ok too. Plural vs. 
singular seems to be a matter of taste to me :) But in general, provided 
my single comment concerning struct forward-declaration is addressed

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> 
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
>  drivers/media/v4l2-core/v4l2-async.c           |  106 ++++++++++++------------
>  include/media/v4l2-async.h                     |   36 ++++----
>  include/media/v4l2-subdev.h                    |   13 ++-
>  4 files changed, 74 insertions(+), 85 deletions(-)
> 
> --
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
