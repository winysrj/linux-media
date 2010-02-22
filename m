Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3797 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0BVUA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 15:00:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 5/6] V4L: Events: Support event handling in do_ioctl
Date: Mon, 22 Feb 2010 21:02:59 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@nokia.com,
	david.cohen@nokia.com
References: <4B82A7FB.50505@maxwell.research.nokia.com> <1266853897-25749-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1266853897-25749-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1266853897-25749-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002222102.59373.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just one tiny comment:

On Monday 22 February 2010 16:51:36 Sakari Ailus wrote:
> Add support for event handling to do_ioctl.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/v4l2-fh.c    |    5 +++-
>  drivers/media/video/v4l2-ioctl.c |   50 ++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-ioctl.h       |    7 +++++
>  3 files changed, 61 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
> index 713f5a0..2986a2c 100644
> --- a/drivers/media/video/v4l2-fh.c
> +++ b/drivers/media/video/v4l2-fh.c
> @@ -33,7 +33,10 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
>  	fh->vdev = vdev;
>  	INIT_LIST_HEAD(&fh->list);
>  	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
> -	v4l2_event_init(fh);

I recommend adding a small comment here along the lines of:

/* fh->events only needs to be initialized if the driver supports the
   VIDIOC_SUBSCRIBE_EVENT ioctl. */

> +	if (vdev->ioctl_ops && vdev->ioctl_ops->vidioc_subscribe_event)
> +		v4l2_event_init(fh);
> +	else
> +		fh->events = NULL;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fh_init);
>  

Other than that:

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
