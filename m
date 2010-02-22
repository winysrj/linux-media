Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43500 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab0BVXKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:10:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/master] V4L/DVB: uvcvideo: Clamp control values to the minimum and maximum values
Date: Tue, 23 Feb 2010 00:11:03 +0100
Cc: linux-media@vger.kernel.org, MXXrton NXXmeth <nm127@freemail.hu>
References: <E1Njfbf-0000g0-7v@www.linuxtv.org>
In-Reply-To: <E1Njfbf-0000g0-7v@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002230011.05447.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 22 February 2010 22:14:19 Patch from Laurent Pinchart wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit

There's a problem somewhere.

> When setting a control, the V4L2 specification requires drivers to
> either clamp the control value to the [minimum, maximum] range or return
> the -ERANGE error.
> 
> Fix the driver to clamp control values to the valid range in
> uvc_ctrl_set() and make sure the value differs from the minimum by an
> integer multiple of step.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Tested-by: Márton Németh <nm127@freemail.hu>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/video/uvc/uvc_ctrl.c |   47
> ++++++++++++++++++++++++++++++++--- drivers/media/video/uvc/uvc_v4l2.c |  
>  2 +
>  2 files changed, 45 insertions(+), 4 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/v4l-dvb.git?a=commitdiff;h=a8677cd5589be9e35ef5117f7
> 5e4b996724102fb
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 5ff5013..f38bc6b 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1021,19 +1021,57 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
>  {
>  	struct uvc_control *ctrl;
>  	struct uvc_control_mapping *mapping;
> -	s32 value = xctrl->value;
> +	s32 value;
> +	u32 step;
> +	s32 min;
> +	s32 max;
>  	int ret;
> 
>  	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
>  	if (ctrl == NULL || (ctrl->info->flags & UVC_CONTROL_SET_CUR) == 0)
>  		return -EINVAL;
> 
> -	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
> -		if (value < 0 || value >= mapping->menu_count)
> +	/* Clamp out of range values. */
> +	switch (mapping->v4l2_type) {
> +	case V4L2_CTRL_TYPE_INTEGER:
> +		if (!ctrl->cached) {
> +			ret = uvc_ctrl_populate_cache(chain, ctrl);
> +			if (ret < 0)
> +				return ret;
> +		}
> +
> +		min = mapping->get(mapping, UVC_GET_MIN,
> +				   uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MIN));
> +		max = mapping->get(mapping, UVC_GET_MAX,
> +				   uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX));
> +		step = mapping->get(mapping, UVC_GET_RES,
> +				    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
> +
> +		xctrl->value = min + (xctrl->value - min + step/2) / step * step;
> +		xctrl->value = clamp(xctrl->value, min, max);
> +		value = xctrl->value;
> +		break;
> +
> +	case V4L2_CTRL_TYPE_BOOLEAN:
> +		xctrl->value = clamp(xctrl->value, 0, 1);
> +		value = xctrl->value;
> +		break;
> +
> +	case V4L2_CTRL_TYPE_MENU:
> +		if (xctrl->value < 0 || xctrl->value >= mapping->menu_count)
>  			return -ERANGE;
> -		value = mapping->menu_info[value].value;
> +		value = mapping->menu_info[xctrl->value].value;
> +		break;
> +
> +	default:
> +		value = xctrl->value;
> +		break;
>  	}
> 
> +	/* If the mapping doesn't span the whole UVC control, the current value
> +	 * needs to be loaded from the device to perform the read-modify-write
> +	 * operation.
> +	 */
>  	if (!ctrl->loaded && (ctrl->info->size * 8) != mapping->size) {
>  		if ((ctrl->info->flags & UVC_CONTROL_GET_CUR) == 0) {
>  			memset(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
> @@ -1051,6 +1089,7 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
>  		ctrl->loaded = 1;
>  	}
> 
> +	/* Backup the current value in case we need to rollback later. */
>  	if (!ctrl->dirty) {
>  		memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
>  		       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 23239a4..bf1fc7f 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -549,6 +549,8 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) return ret;
>  		}
>  		ret = uvc_ctrl_commit(chain);
> +		if (ret == 0)
> +			ctrl->value = xctrl.value;
>  		break;
>  	}

-- 
Regards,

Laurent Pinchart
