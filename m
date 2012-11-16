Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4517 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KPOHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 09:07:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 6/6] uvcvideo: Add VIDIOC_[GS]_PRIORITY support
Date: Fri, 16 Nov 2012 15:07:42 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com> <1348758980-21683-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1348758980-21683-7-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161507.42201.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu September 27 2012 17:16:20 Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c |    3 ++
>  drivers/media/usb/uvc/uvc_v4l2.c   |   45 ++++++++++++++++++++++++++++++++++++
>  drivers/media/usb/uvc/uvcvideo.h   |    1 +
>  3 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index ae24f7d..22f14d2 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1562,6 +1562,7 @@ static int uvc_scan_device(struct uvc_device *dev)
>  		INIT_LIST_HEAD(&chain->entities);
>  		mutex_init(&chain->ctrl_mutex);
>  		chain->dev = dev;
> +		v4l2_prio_init(&chain->prio);
>  
>  		if (uvc_scan_chain(chain, term) < 0) {
>  			kfree(chain);
> @@ -1722,6 +1723,8 @@ static int uvc_register_video(struct uvc_device *dev,
>  	vdev->v4l2_dev = &dev->vdev;
>  	vdev->fops = &uvc_fops;
>  	vdev->release = uvc_release;
> +	vdev->prio = &stream->chain->prio;
> +	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);

This set_bit() doesn't do anything as long as you are not using video_ioctl2().
And why aren't you using video_ioctl2()? This is the last driver to do it all
manually. If you'd switch to video_ioctl2(), then setting this bit would be
all you had to do.

>  	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  		vdev->vfl_dir = VFL_DIR_TX;
>  	strlcpy(vdev->name, dev->name, sizeof vdev->name);
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index bf9d073..d6aa402 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -576,6 +576,19 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		break;
>  	}
>  
> +	/* Priority */
> +	case VIDIOC_G_PRIORITY:
> +		*(u32 *)arg = v4l2_prio_max(vdev->prio);
> +		break;
> +
> +	case VIDIOC_S_PRIORITY:
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;
> +
> +		return v4l2_prio_change(vdev->prio, &handle->vfh.prio,
> +					*(u32 *)arg);
> +
>  	/* Get, Set & Query control */
>  	case VIDIOC_QUERYCTRL:
>  		return uvc_query_v4l2_ctrl(chain, arg);
> @@ -606,6 +619,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		struct v4l2_control *ctrl = arg;
>  		struct v4l2_ext_control xctrl;
>  
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;
> +
>  		memset(&xctrl, 0, sizeof xctrl);
>  		xctrl.id = ctrl->id;
>  		xctrl.value = ctrl->value;
> @@ -653,6 +670,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	}
>  
>  	case VIDIOC_S_EXT_CTRLS:
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;
> +
>  	case VIDIOC_TRY_EXT_CTRLS:
>  	{
>  		struct v4l2_ext_controls *ctrls = arg;
> @@ -747,6 +768,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	{
>  		u32 input = *(u32 *)arg + 1;
>  
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;
> +
>  		if ((ret = uvc_acquire_privileges(handle)) < 0)
>  			return ret;
>  
> @@ -800,6 +825,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	}
>  
>  	case VIDIOC_S_FMT:
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;
> +
>  		if ((ret = uvc_acquire_privileges(handle)) < 0)
>  			return ret;
>  
> @@ -902,6 +931,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		return uvc_v4l2_get_streamparm(stream, arg);
>  
>  	case VIDIOC_S_PARM:
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;
> +
>  		if ((ret = uvc_acquire_privileges(handle)) < 0)
>  			return ret;
>  
> @@ -936,6 +969,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  
>  	/* Buffers & streaming */
>  	case VIDIOC_REQBUFS:
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;
> +
>  		if ((ret = uvc_acquire_privileges(handle)) < 0)
>  			return ret;
>  
> @@ -981,6 +1018,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		if (*type != stream->type)
>  			return -EINVAL;
>  
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;
> +
>  		if (!uvc_has_privileges(handle))
>  			return -EBUSY;
>  
> @@ -999,6 +1040,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		if (*type != stream->type)
>  			return -EINVAL;
>  
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;
> +
>  		if (!uvc_has_privileges(handle))
>  			return -EBUSY;

This patch is hard to read since I can't see for which ioctls you check the prio.
Can you regenerate the patch with more context lines? The patch as it is will
probably not apply reliably due to the same reason.

In particular, make sure you also check for the UVC-specific ioctls (UVCIOC_CTRL_MAP
might need this, but I'm not sure about that).

Regards,

	Hans

>  
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index 28ff015..acf6bf2 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -372,6 +372,7 @@ struct uvc_video_chain {
>  
>  	struct mutex ctrl_mutex;		/* Protects ctrl.info */
>  
> +	struct v4l2_prio_state prio;		/* V4L2 priority state */
>  	u32 caps;				/* V4L2 chain-wide caps */
>  };
>  
> 
