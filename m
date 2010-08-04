Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3565 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0HDShS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 14:37:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v3 6/7] v4l: subdev: Control ioctls support
Date: Wed, 4 Aug 2010 20:37:08 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278948352-17892-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278948352-17892-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278948352-17892-7-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042037.08922.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 12 July 2010 17:25:51 Laurent Pinchart wrote:
> Pass the control-related ioctls to the subdev driver through the core
> operations.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Note: if the control framework is merged first, then this code will
no doubt have to change.

> ---
>  Documentation/video4linux/v4l2-framework.txt |   16 ++++++++++++++++
>  drivers/media/video/v4l2-subdev.c            |   24 ++++++++++++++++++++++++
>  2 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index 164bb0f..9c3f33c 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -331,6 +331,22 @@ argument to 0. Setting the argument to 1 will only enable device node
>  registration if the sub-device driver has set the V4L2_SUBDEV_FL_HAS_DEVNODE
>  flag.
>  
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
>  
>  I2C sub-device drivers
>  ----------------------
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index 052dc9c..ea3941a 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -43,7 +43,31 @@ static int subdev_close(struct file *file)
>  
>  static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
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
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
