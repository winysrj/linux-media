Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39207 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbbGQHU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 03:20:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v4 04/19] media/usb/uvc: Implement vivioc_g_def_ext_ctrls
Date: Fri, 17 Jul 2015 10:21:25 +0300
Message-ID: <6354291.bfdrk3ePzE@avalon>
In-Reply-To: <1437037003-6113-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1437037003-6113-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch.

On Thursday 16 July 2015 10:56:43 Ricardo Ribalda Delgado wrote:
> Callback needed by ioctl VIDIOC_G_DEF_EXT_CTRLS as this driver does not
> use the controller framework.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

However, I share Sakari's opinion that he has just voiced in a reply to patch 
02/19.

> ---
> Changelog
> 
> v4: Comments by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Remove unneeded  uvc_ctrl_begin()
> 
> 
>  drivers/media/usb/uvc/uvc_v4l2.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 2764f43607c1..7ec7d45b24ed 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -1001,6 +1001,31 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file,
> void *fh, return uvc_ctrl_rollback(handle);
>  }
> 
> +static int uvc_ioctl_g_def_ext_ctrls(struct file *file, void *fh,
> +				     struct v4l2_ext_controls *ctrls)
> +{
> +	struct uvc_fh *handle = fh;
> +	struct uvc_video_chain *chain = handle->chain;
> +	struct v4l2_ext_control *ctrl = ctrls->controls;
> +	unsigned int i;
> +	int ret;
> +	struct v4l2_queryctrl qc;
> +
> +	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
> +		qc.id = ctrl->id;
> +		ret = uvc_query_v4l2_ctrl(chain, &qc);
> +		if (ret < 0) {
> +			ctrls->error_idx = i;
> +			return ret;
> +		}
> +		ctrl->value = qc.default_value;
> +	}
> +
> +	ctrls->error_idx = 0;
> +
> +	return 0;
> +}
> +
>  static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
>  				     struct v4l2_ext_controls *ctrls,
>  				     bool commit)
> @@ -1500,6 +1525,7 @@ const struct v4l2_ioctl_ops uvc_ioctl_ops = {
>  	.vidioc_g_ctrl = uvc_ioctl_g_ctrl,
>  	.vidioc_s_ctrl = uvc_ioctl_s_ctrl,
>  	.vidioc_g_ext_ctrls = uvc_ioctl_g_ext_ctrls,
> +	.vidioc_g_def_ext_ctrls = uvc_ioctl_g_def_ext_ctrls,
>  	.vidioc_s_ext_ctrls = uvc_ioctl_s_ext_ctrls,
>  	.vidioc_try_ext_ctrls = uvc_ioctl_try_ext_ctrls,
>  	.vidioc_querymenu = uvc_ioctl_querymenu,

-- 
Regards,

Laurent Pinchart

