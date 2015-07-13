Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52088 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbbGMMLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 08:11:41 -0400
Message-ID: <55A3AABF.4030403@xs4all.nl>
Date: Mon, 13 Jul 2015 14:10:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v3 04/19] media/usb/uvc: Implement vivioc_g_def_ext_ctrls
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com> <1434127598-11719-5-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1434127598-11719-5-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

Can you review/ack this since it touches on uvc?

Thanks!

	Hans

On 06/12/2015 06:46 PM, Ricardo Ribalda Delgado wrote:
> Callback needed by ioctl VIDIOC_G_DEF_EXT_CTRLS as this driver does not
> use the controller framework.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index 2764f43607c1..e2698a77138a 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -1001,6 +1001,35 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
>  	return uvc_ctrl_rollback(handle);
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
> +	ret = uvc_ctrl_begin(chain);
> +	if (ret < 0)
> +		return ret;
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
> @@ -1500,6 +1529,7 @@ const struct v4l2_ioctl_ops uvc_ioctl_ops = {
>  	.vidioc_g_ctrl = uvc_ioctl_g_ctrl,
>  	.vidioc_s_ctrl = uvc_ioctl_s_ctrl,
>  	.vidioc_g_ext_ctrls = uvc_ioctl_g_ext_ctrls,
> +	.vidioc_g_def_ext_ctrls = uvc_ioctl_g_def_ext_ctrls,
>  	.vidioc_s_ext_ctrls = uvc_ioctl_s_ext_ctrls,
>  	.vidioc_try_ext_ctrls = uvc_ioctl_try_ext_ctrls,
>  	.vidioc_querymenu = uvc_ioctl_querymenu,
> 

