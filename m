Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965358Ab3HHPuT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 11:50:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	pawel@osciak.com
Subject: Re: [PATCH] v4l2-ctrl: fix setting volatile controls
Date: Thu, 08 Aug 2013 17:51:24 +0200
Message-ID: <2421409.LVIZ41ySbB@avalon>
In-Reply-To: <520379EC.9020307@xs4all.nl>
References: <520379EC.9020307@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 08 August 2013 12:58:52 Hans Verkuil wrote:
> The V4L2 specification allows setting volatile controls as that is needed
> if you want to be able to set all controls in one go using
> VIDIOC_S_EXT_CTRLS.
> 
> However, such new values should be ignored by the control framework
> since it makes no sense to set a volatile control. While the new value
> will be ignored anyway, it does generate a bogus 'change value' control
> event that should be suppressed.
> 
> This patch changes the code to skip setting volatile controls, except for
> one particular case where an autocluster switches to manual mode, because
> that causes the volatile controls to become non-volatile, so the new
> specified values should be retained.
> 
> Note that the values returned by VIDIOC_S_CTRL and VIDIOC_S_EXT_CTRLS for
> such skipped volatile controls will be the currently cached values and not
> the latest volatile value. This is something that might have to be fixed
> as well in the future should that be necessary. I think it is overkill,
> though.

This restriction is not documented in Documentation/video4linux/v4l2-
controls.txt. Do we really want to assume that all volatile controls are read-
only and/or inactive ?

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: pawel@osciak.com
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c index fccd08b..a7cd830 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2592,6 +2592,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
> struct v4l2_ctrl_handler *hdl, cs->error_idx = cs->count;
>  	for (i = 0; !ret && i < cs->count; i++) {
>  		struct v4l2_ctrl *master;
> +		bool set_volatiles = false;
>  		u32 idx = i;
> 
>  		if (helpers[i].mref == NULL)
> @@ -2627,14 +2628,24 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
> struct v4l2_ctrl_handler *hdl, } while (tmp_idx);
>  			/* If the new value == the manual value, then copy
>  			   the current volatile values. */
> -			if (new_auto_val == master->manual_mode_value)
> +			if (new_auto_val == master->manual_mode_value) {
>  				update_from_auto_cluster(master);
> +				set_volatiles = true;
> +			}
>  		}
> 
>  		/* Copy the new caller-supplied control values.
>  		   user_to_new() sets 'is_new' to 1. */
>  		do {
> -			ret = user_to_new(cs->controls + idx, helpers[idx].ctrl);
> +			/*
> +			 * Skip attempts to set volatile controls since those are
> +			 * ignored anyway. The exception is when an autocluster is
> +			 * switched to manual mode, since in that case the specified
> +			 * 'volatile' controls are actually the new manual
> +			 * non-volatile values.
> +			 */
> +			if (set_volatiles || !(helpers[idx].ctrl->flags &
> V4L2_CTRL_FLAG_VOLATILE)) +				ret = user_to_new(cs->controls + 
idx,
> helpers[idx].ctrl);
>  			idx = helpers[idx].next;
>  		} while (!ret && idx);
> 
> @@ -2697,6 +2708,9 @@ static int set_ctrl(struct v4l2_fh *fh, struct
> v4l2_ctrl *ctrl, if (ctrl->type == V4L2_CTRL_TYPE_STRING)
>  		return -EINVAL;
> 
> +	if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE)
> +		return 0;
> +
>  	/* Reset the 'is_new' flags of the cluster */
>  	for (i = 0; i < master->ncontrols; i++)
>  		if (master->cluster[i])
-- 
Regards,

Laurent Pinchart

