Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2725 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2KPOAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 09:00:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/6] uvcvideo: Set device_caps in VIDIOC_QUERYCAP
Date: Fri, 16 Nov 2012 15:00:29 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com> <1348758980-21683-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1348758980-21683-5-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161500.29555.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu September 27 2012 17:16:18 Laurent Pinchart wrote:
> Set the capabilities field to global capabilities, and the device_caps
> field to the video node capabilities.
> 
> This issue was found by the v4l2-compliance tool.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c |    5 +++++
>  drivers/media/usb/uvc/uvc_v4l2.c   |   10 ++++++----
>  drivers/media/usb/uvc/uvcvideo.h   |    2 ++
>  3 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 5967081..ae24f7d 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1741,6 +1741,11 @@ static int uvc_register_video(struct uvc_device *dev,
>  		return ret;
>  	}
>  
> +	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
> +	else
> +		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
> +
>  	atomic_inc(&dev->nstreams);
>  	return 0;
>  }
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index 3bd9373..b1aa55f 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -565,12 +565,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		usb_make_path(stream->dev->udev,
>  			      cap->bus_info, sizeof(cap->bus_info));
>  		cap->version = LINUX_VERSION_CODE;
> +		cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
> +				  | chain->caps;
>  		if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -			cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
> -					  | V4L2_CAP_STREAMING;
> +			cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
> +					 | V4L2_CAP_STREAMING;
>  		else
> -			cap->capabilities = V4L2_CAP_VIDEO_OUTPUT
> -					  | V4L2_CAP_STREAMING;
> +			cap->device_caps = V4L2_CAP_VIDEO_OUTPUT
> +					 | V4L2_CAP_STREAMING;

This seems weird. Wouldn't it be easier to do:

		cap->device_caps = chain->caps | V4L2_CAP_STREAMING;

You don't need the if/else here.

>  		break;
>  	}
>  
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index 7244455..28ff015 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -371,6 +371,8 @@ struct uvc_video_chain {
>  	struct uvc_entity *selector;		/* Selector unit */
>  
>  	struct mutex ctrl_mutex;		/* Protects ctrl.info */
> +
> +	u32 caps;				/* V4L2 chain-wide caps */
>  };
>  
>  struct uvc_stats_frame {
> 

Regards,

	Hans
