Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44767 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbcCAOQw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 09:16:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/5] v4l2: add device_caps to struct video_device
Date: Tue, 01 Mar 2016 16:16:59 +0200
Message-ID: <1944635.GBfyVlzrOX@avalon>
In-Reply-To: <1456746345-1431-2-git-send-email-hverkuil@xs4all.nl>
References: <1456746345-1431-1-git-send-email-hverkuil@xs4all.nl> <1456746345-1431-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 29 February 2016 12:45:41 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Instead of letting drivers fill in device_caps at querycap time,
> let them fill it in when the video device is registered.
> 
> This has the advantage that in the future the v4l2 core can access
> the video device's capabilities and take decisions based on that.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've acked the first three patches, could you get them merged through your 
tree ? I'll incorporate patch 4 in my media entity type series and post patch 
5 rebased on top of it.

> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 3 +++
>  include/media/v4l2-dev.h             | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index 86c4c19..706bb42 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1020,9 +1020,12 @@ static int v4l_querycap(const struct v4l2_ioctl_ops
> *ops, struct file *file, void *fh, void *arg)
>  {
>  	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
> +	struct video_device *vfd = video_devdata(file);
>  	int ret;
> 
>  	cap->version = LINUX_VERSION_CODE;
> +	cap->device_caps = vfd->device_caps;
> +	cap->capabilities = vfd->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
>  	ret = ops->vidioc_querycap(file, fh, cap);
> 
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 76056ab..25a3190 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -92,6 +92,9 @@ struct video_device
>  	/* device ops */
>  	const struct v4l2_file_operations *fops;
> 
> +	/* device capabilities as used in v4l2_capabilities */
> +	u32 device_caps;
> +
>  	/* sysfs */
>  	struct device dev;		/* v4l device */
>  	struct cdev *cdev;		/* character device */

-- 
Regards,

Laurent Pinchart

