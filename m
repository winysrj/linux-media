Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41152 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbbIDK53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 06:57:29 -0400
Message-ID: <55E978DA.1040604@xs4all.nl>
Date: Fri, 04 Sep 2015 12:56:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/10] usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
References: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com> <1440163169-18047-7-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1440163169-18047-7-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent, can you review this?

Regards,

	Hans

On 08/21/2015 03:19 PM, Ricardo Ribalda Delgado wrote:
> This driver does not use the control infrastructure.
> Add support for the new field which on structure
>  v4l2_ext_controls
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index 2764f43607c1..e6d3a1bcfa2f 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -980,6 +980,7 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
>  	struct uvc_fh *handle = fh;
>  	struct uvc_video_chain *chain = handle->chain;
>  	struct v4l2_ext_control *ctrl = ctrls->controls;
> +	struct v4l2_queryctrl qc;
>  	unsigned int i;
>  	int ret;
>  
> @@ -988,7 +989,14 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
>  		return ret;
>  
>  	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
> -		ret = uvc_ctrl_get(chain, ctrl);
> +		if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
> +			qc.id = ctrl->id;
> +			ret = uvc_query_v4l2_ctrl(chain, &qc);
> +			if (!ret)
> +				ctrl->value = qc.default_value;
> +		} else
> +			ret = uvc_ctrl_get(chain, ctrl);
> +
>  		if (ret < 0) {
>  			uvc_ctrl_rollback(handle);
>  			ctrls->error_idx = i;
> @@ -1010,6 +1018,10 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
>  	unsigned int i;
>  	int ret;
>  
> +	/* Default value cannot be changed */
> +	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL)
> +		return -EINVAL;
> +
>  	ret = uvc_ctrl_begin(chain);
>  	if (ret < 0)
>  		return ret;
> 

