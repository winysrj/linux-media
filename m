Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59384 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2BGKtS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 05:49:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	linux-input@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/6] v4l2-subdev: add start/end messages for log_status.
Date: Tue, 07 Feb 2012 11:49:06 +0100
Message-ID: <2337556.GQrkDqkaKo@avalon>
In-Reply-To: <5dc424690702cb423288fe9b1e30f7ad225fc6e5.1328183271.git.hans.verkuil@cisco.com>
References: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl> <5dc424690702cb423288fe9b1e30f7ad225fc6e5.1328183271.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Thursday 02 February 2012 12:56:32 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add the start and end messages for log_status when called from a
> subdev device node.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/v4l2-subdev.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-subdev.c
> b/drivers/media/video/v4l2-subdev.c index 41d118e..6fe88e9 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -194,8 +194,16 @@ static long subdev_do_ioctl(struct file *file, unsigned
> int cmd, void *arg) }
>  #endif
> 
> -	case VIDIOC_LOG_STATUS:
> -		return v4l2_subdev_call(sd, core, log_status);
> +	case VIDIOC_LOG_STATUS: {
> +		int ret;
> +
> +		pr_info("%s: =================  START STATUS  =================\n",
> +			sd->name);
> +		ret = v4l2_subdev_call(sd, core, log_status);
> +		pr_info("%s: ==================  END STATUS  ==================\n",
> +			sd->name);
> +		return ret;
> +	}
> 
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  	case VIDIOC_SUBDEV_G_FMT: {

-- 
Regards,

Laurent Pinchart
