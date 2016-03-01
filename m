Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44474 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbcCAIzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 03:55:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/2] v4l2: collect the union of all device_caps in struct v4l2_device
Date: Tue, 01 Mar 2016 10:55:09 +0200
Message-ID: <1604845.OChSsb5RTF@avalon>
In-Reply-To: <1456750657-11108-2-git-send-email-hverkuil@xs4all.nl>
References: <1456750657-11108-1-git-send-email-hverkuil@xs4all.nl> <1456750657-11108-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 29 February 2016 13:57:36 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The capabilities field of struct v4l2_capabilities should be the
> union of the capabilities of all video devices. This has always been
> annoying for drivers to calculate, but now that device_caps is part
> of struct video_device we can easily OR that with a capabilities
> field in struct v4l2_device and return that as the capabilities field
> when QUERYCAP is called.

I like the concept, but how can we deal with devices that dynamically register 
video_device instances at runtime ?

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c   | 1 +
>  drivers/media/v4l2-core/v4l2-ioctl.c | 2 +-
>  include/media/v4l2-device.h          | 2 ++
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c
> b/drivers/media/v4l2-core/v4l2-dev.c index 7e766a9..6ef9169 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -1011,6 +1011,7 @@ int __video_register_device(struct video_device *vdev,
> int type, int nr, ret = video_register_media_controller(vdev, type);
> 
>  	/* Part 6: Activate this minor. The char device can now be used. */
> +	vdev->v4l2_dev->capabilities |= vdev->device_caps;
>  	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
> 
>  	return 0;
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index 706bb42..013d58d 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1025,7 +1025,7 @@ static int v4l_querycap(const struct v4l2_ioctl_ops
> *ops,
> 
>  	cap->version = LINUX_VERSION_CODE;
>  	cap->device_caps = vfd->device_caps;
> -	cap->capabilities = vfd->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	cap->capabilities = vfd->v4l2_dev->capabilities | V4L2_CAP_DEVICE_CAPS;
> 
>  	ret = ops->vidioc_querycap(file, fh, cap);
> 
> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index 9c58157..8964d60 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -44,6 +44,8 @@ struct v4l2_device {
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	struct media_device *mdev;
>  #endif
> +	/* union of the capabilities of all video devices */
> +	u32 capabilities;
>  	/* used to keep track of the registered subdevs */
>  	struct list_head subdevs;
>  	/* lock this struct; can be used by the driver as well if this

-- 
Regards,

Laurent Pinchart

