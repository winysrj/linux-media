Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50251 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753180AbeDJMre (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 08:47:34 -0400
Date: Tue, 10 Apr 2018 09:47:28 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 13/29] v4l2-ctrls: use ref in helper instead of
 ctrl
Message-ID: <20180410094728.71a58d86@vento.lan>
In-Reply-To: <20180409142026.19369-14-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-14-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Apr 2018 16:20:10 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The next patch needs the reference to a control instead of the
> control itself, so change struct v4l2_ctrl_helper accordingly.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 3c1b00baa8d0..da4cc1485dc4 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -37,8 +37,8 @@
>  struct v4l2_ctrl_helper {
>  	/* Pointer to the control reference of the master control */
>  	struct v4l2_ctrl_ref *mref;
> -	/* The control corresponding to the v4l2_ext_control ID field. */
> -	struct v4l2_ctrl *ctrl;

Why are you removing it in this patch? 

I mean: if this is something that it is not used, it should be 
removed on a separate one. Otherwise, please explain it at the
patch description.

> +	/* The control ref corresponding to the v4l2_ext_control ID field. */
> +	struct v4l2_ctrl_ref *ref;
>  	/* v4l2_ext_control index of the next control belonging to the
>  	   same cluster, or 0 if there isn't any. */
>  	u32 next;
> @@ -2887,6 +2887,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  		ref = find_ref_lock(hdl, id);
>  		if (ref == NULL)
>  			return -EINVAL;
> +		h->ref = ref;
>  		ctrl = ref->ctrl;
>  		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
>  			return -EINVAL;
> @@ -2909,7 +2910,6 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  		}
>  		/* Store the ref to the master control of the cluster */
>  		h->mref = ref;
> -		h->ctrl = ctrl;
>  		/* Initially set next to 0, meaning that there is no other
>  		   control in this helper array belonging to the same
>  		   cluster */
> @@ -2994,7 +2994,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>  	cs->error_idx = cs->count;
>  
>  	for (i = 0; !ret && i < cs->count; i++)
> -		if (helpers[i].ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
> +		if (helpers[i].ref->ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)

Shouldn't it be checking if ref is not NULL?

>  			ret = -EACCES;
>  
>  	for (i = 0; !ret && i < cs->count; i++) {
> @@ -3029,7 +3029,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>  
>  			do {
>  				ret = ctrl_to_user(cs->controls + idx,
> -						   helpers[idx].ctrl);
> +						   helpers[idx].ref->ctrl);
>  				idx = helpers[idx].next;
>  			} while (!ret && idx);
>  		}
> @@ -3168,7 +3168,7 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
>  
>  	cs->error_idx = cs->count;
>  	for (i = 0; i < cs->count; i++) {
> -		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
> +		struct v4l2_ctrl *ctrl = helpers[i].ref->ctrl;
>  		union v4l2_ctrl_ptr p_new;
>  
>  		cs->error_idx = i;
> @@ -3280,7 +3280,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  			do {
>  				/* Check if the auto control is part of the
>  				   list, and remember the new value. */
> -				if (helpers[tmp_idx].ctrl == master)
> +				if (helpers[tmp_idx].ref->ctrl == master)
>  					new_auto_val = cs->controls[tmp_idx].value;
>  				tmp_idx = helpers[tmp_idx].next;
>  			} while (tmp_idx);
> @@ -3293,7 +3293,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  		/* Copy the new caller-supplied control values.
>  		   user_to_new() sets 'is_new' to 1. */
>  		do {
> -			struct v4l2_ctrl *ctrl = helpers[idx].ctrl;
> +			struct v4l2_ctrl *ctrl = helpers[idx].ref->ctrl;
>  
>  			ret = user_to_new(cs->controls + idx, ctrl);
>  			if (!ret && ctrl->is_ptr)
> @@ -3309,7 +3309,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  			idx = i;
>  			do {
>  				ret = new_to_user(cs->controls + idx,
> -						helpers[idx].ctrl);
> +						helpers[idx].ref->ctrl);
>  				idx = helpers[idx].next;
>  			} while (!ret && idx);
>  		}



Thanks,
Mauro
