Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:61632 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3GXKQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 06:16:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC 0/5] v4l2-async DT support improvement and cleanups
Date: Wed, 24 Jul 2013 12:16:26 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307241216.26949.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 22 July 2013 20:04:42 Sylwester Nawrocki wrote:
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

Looks good!

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

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
