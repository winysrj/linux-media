Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3351 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0GGMd4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 08:33:56 -0400
Message-ID: <97beeba6e8a645b4d57e16ffa36f2321.squirrel@webmail.xs4all.nl>
In-Reply-To: <1278503608-9126-5-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1278503608-9126-5-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Wed, 7 Jul 2010 14:33:52 +0200
Subject: Re: [RFC/PATCH 4/6] v4l: subdev: Control ioctls support
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Pass the control-related ioctls to the subdev driver through the core
> operations.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/video4linux/v4l2-framework.txt |   24
> ++++++++++++++++++++++++
>  drivers/media/video/v4l2-subdev.c            |   24
> ++++++++++++++++++++++++
>  2 files changed, 48 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/video4linux/v4l2-framework.txt
> b/Documentation/video4linux/v4l2-framework.txt
> index e831aac..f315858 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -314,6 +314,30 @@ controlled through GPIO pins. This distinction is
> only relevant when setting
>  up the device, but once the subdev is registered it is completely
> transparent.
>
>
> +V4L2 sub-device userspace API
> +-----------------------------
> +
> +Beside exposing a kernel API through the v4l2_subdev_ops structure, V4L2
> +sub-devices can also be controlled directly by userspace applications.
> +
> +When a sub-device is registered, a device node named subdevX is created
> in /dev.
> +The device node handles a subset of the V4L2 API.
> +
> +VIDIOC_QUERYCTRL
> +VIDIOC_QUERYMENU
> +VIDIOC_G_CTRL
> +VIDIOC_S_CTRL
> +VIDIOC_G_EXT_CTRLS
> +VIDIOC_S_EXT_CTRLS
> +VIDIOC_TRY_EXT_CTRLS
> +
> +	The controls ioctls are identical to the ones defined in V4L2. They
> +	behave identically, with the only exception that they deal only with
> +	controls implemented in the sub-device. Depending on the driver, those
> +	controls can be also be accessed through one (or several) V4L2 device
> +	nodes.
> +
> +
>  I2C sub-device drivers
>  ----------------------
>
> diff --git a/drivers/media/video/v4l2-subdev.c
> b/drivers/media/video/v4l2-subdev.c
> index a3672f0..141098b 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -43,7 +43,31 @@ static int subdev_close(struct file *file)
>
>  static long subdev_do_ioctl(struct file *file, unsigned int cmd, void
> *arg)
>  {
> +	struct video_device *vdev = video_devdata(file);
> +	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> +
>  	switch (cmd) {
> +	case VIDIOC_QUERYCTRL:
> +		return v4l2_subdev_call(sd, core, queryctrl, arg);
> +
> +	case VIDIOC_QUERYMENU:
> +		return v4l2_subdev_call(sd, core, querymenu, arg);
> +
> +	case VIDIOC_G_CTRL:
> +		return v4l2_subdev_call(sd, core, g_ctrl, arg);
> +
> +	case VIDIOC_S_CTRL:
> +		return v4l2_subdev_call(sd, core, s_ctrl, arg);
> +
> +	case VIDIOC_G_EXT_CTRLS:
> +		return v4l2_subdev_call(sd, core, g_ext_ctrls, arg);
> +
> +	case VIDIOC_S_EXT_CTRLS:
> +		return v4l2_subdev_call(sd, core, s_ext_ctrls, arg);
> +
> +	case VIDIOC_TRY_EXT_CTRLS:
> +		return v4l2_subdev_call(sd, core, try_ext_ctrls, arg);
> +
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This should simplify substantially once the control framework is in place.

IMHO the control framework should go in first, then this code, updated for
the control framework.

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

