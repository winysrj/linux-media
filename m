Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37716 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab1KDKnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 06:43:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes
Date: Fri, 4 Nov 2011 11:43:17 +0100
Cc: linux-media@vger.kernel.org, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1320250557-20880-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1320250557-20880-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111041143.17621.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

On Wednesday 02 November 2011 17:15:57 Sylwester Nawrocki wrote:
> The VIDIOC_LOG_STATUS ioctl allows to dump current status of a driver
> to the kernel log. Currently this ioctl is only available at video
> device nodes and the subdevs rely on the host driver to expose their
> core.log_status operation to user space.
> 
> This patch adds VIDIOC_LOG_STATUS support at the sub-device nodes,
> for standalone subdevs that expose their own /dev entry.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/v4l2-subdev.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-subdev.c
> b/drivers/media/video/v4l2-subdev.c index 179e20e..4fe1e7a 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -192,6 +192,9 @@ static long subdev_do_ioctl(struct file *file, unsigned
> int cmd, void *arg) return v4l2_subdev_call(sd, core, s_register, p);
>  	}
>  #endif

I would have put a blank line here, but that's probably just me :-)

> +	case VIDIOC_LOG_STATUS:
> +		return v4l2_subdev_call(sd, core, log_status);
> +
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  	case VIDIOC_SUBDEV_G_FMT: {
>  		struct v4l2_subdev_format *format = arg;

-- 
Regards,

Laurent Pinchart
