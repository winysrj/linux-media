Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34896 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3KARbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 13:31:12 -0400
Received: by mail-wi0-f181.google.com with SMTP id ex4so1395862wid.14
        for <linux-media@vger.kernel.org>; Fri, 01 Nov 2013 10:31:11 -0700 (PDT)
Message-ID: <5273E55B.10103@gmail.com>
Date: Fri, 01 Nov 2013 18:31:07 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: subdev: Check for pads in [gs]_frame_interval
References: <1381997754-3348-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1381997754-3348-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/17/2013 10:15 AM, Sakari Ailus wrote:
> The validity of the pad field in struct v4l2_subdev_frame_interval was not
> ensured by the V4L2 subdev IOCTL helper. Fix this.
>
> Signed-off-by: Sakari Ailus<sakari.ailus@linux.intel.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Regards,
Sylwester

> ---
>   drivers/media/v4l2-core/v4l2-subdev.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 996c248..3fa1907 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -305,11 +305,23 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>   					fse);
>   	}
>
> -	case VIDIOC_SUBDEV_G_FRAME_INTERVAL:
> +	case VIDIOC_SUBDEV_G_FRAME_INTERVAL: {
> +		struct v4l2_subdev_frame_interval *fi = arg;
> +
> +		if (fi->pad>= sd->entity.num_pads)
> +			return -EINVAL;
> +
>   		return v4l2_subdev_call(sd, video, g_frame_interval, arg);
> +	}
> +
> +	case VIDIOC_SUBDEV_S_FRAME_INTERVAL: {
> +		struct v4l2_subdev_frame_interval *fi = arg;
> +
> +		if (fi->pad>= sd->entity.num_pads)
> +			return -EINVAL;
>
> -	case VIDIOC_SUBDEV_S_FRAME_INTERVAL:
>   		return v4l2_subdev_call(sd, video, s_frame_interval, arg);
> +	}
>
>   	case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL: {
>   		struct v4l2_subdev_frame_interval_enum *fie = arg;
