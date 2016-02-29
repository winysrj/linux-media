Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43407 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbcB2L4G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 06:56:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/5] v4l2: add device_caps to struct video_device
Date: Mon, 29 Feb 2016 13:56:10 +0200
Message-ID: <1532376.RKO5DUDMUz@avalon>
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

How about adding capabilities too (on 64-bit systems we won't lose any space 
as the previous and following fields are 64-bit aligned anyway) ? This would 
allow most, if not all, drivers to drop their vidioc_querycap implementation.

>  	/* sysfs */
>  	struct device dev;		/* v4l device */
>  	struct cdev *cdev;		/* character device */

-- 
Regards,

Laurent Pinchart

