Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59417 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934282AbbA1Urn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:43 -0500
Message-ID: <54C8B7FC.4090806@xs4all.nl>
Date: Wed, 28 Jan 2015 11:20:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: Re: [PATCH v2 3/6] v4l2-ctrls: Make the control type init op initialize
 the whole control
References: <1422436639-18292-1-git-send-email-laurent.pinchart@ideasonboard.com> <1422436639-18292-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1422436639-18292-4-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/15 10:17, Laurent Pinchart wrote:
> The control type init operation is called in a loop to initialize all
> elements of a control. Not only is this inefficient for control types
> that could use a memset(), it also complicates the implementation of
> custom control types, for instance when a matrix needs to be initialized
> with different values for its elements.
> 
> Make the init operation initialize the whole control instead, and use
> memset() when possible.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 46 ++++++++++++++++++++++++++----------
>  include/media/v4l2-ctrls.h           |  3 +--
>  2 files changed, 34 insertions(+), 15 deletions(-)
> 
> Changes since v1:
> 
> - Remove support for V4L2_CTRL_TYPE_U8 and V4L2_CTRL_TYPE_S8 from
>   std_init_one(), as those cases are now handled by std_init()
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index adac93e..81b8e66 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1263,8 +1263,8 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
>  	}
>  }
>  
> -static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
> -		     union v4l2_ctrl_ptr ptr)
> +static void std_init_one(const struct v4l2_ctrl *ctrl, u32 idx,
> +			 union v4l2_ctrl_ptr ptr)
>  {
>  	switch (ctrl->type) {
>  	case V4L2_CTRL_TYPE_STRING:
> @@ -1282,10 +1282,6 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
>  	case V4L2_CTRL_TYPE_BOOLEAN:
>  		ptr.p_s32[idx] = ctrl->default_value;
>  		break;
> -	case V4L2_CTRL_TYPE_U8:
> -	case V4L2_CTRL_TYPE_S8:
> -		ptr.p_u8[idx] = ctrl->default_value;
> -		break;
>  	case V4L2_CTRL_TYPE_U16:
>  	case V4L2_CTRL_TYPE_S16:
>  		ptr.p_u16[idx] = ctrl->default_value;
> @@ -1295,8 +1291,35 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
>  		ptr.p_u32[idx] = ctrl->default_value;
>  		break;
>  	default:
> -		idx *= ctrl->elem_size;
> -		memset(ptr.p + idx, 0, ctrl->elem_size);
> +		break;
> +	}
> +}
> +
> +static void std_init(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr ptr)
> +{
> +	u32 idx;
> +
> +	switch (ctrl->type) {
> +	case V4L2_CTRL_TYPE_STRING:
> +	case V4L2_CTRL_TYPE_INTEGER64:
> +	case V4L2_CTRL_TYPE_INTEGER:
> +	case V4L2_CTRL_TYPE_INTEGER_MENU:
> +	case V4L2_CTRL_TYPE_MENU:
> +	case V4L2_CTRL_TYPE_BITMASK:
> +	case V4L2_CTRL_TYPE_BOOLEAN:
> +	case V4L2_CTRL_TYPE_U16:
> +	case V4L2_CTRL_TYPE_S16:
> +	case V4L2_CTRL_TYPE_U32:
> +	case V4L2_CTRL_TYPE_S32:
> +		for (idx = 0; idx < ctrl->elems; idx++)
> +			std_init_one(ctrl, idx, ptr);
> +		break;
> +	case V4L2_CTRL_TYPE_U8:
> +	case V4L2_CTRL_TYPE_S8:
> +		memset(ptr.p_u8, ctrl->default_value, ctrl->elems);
> +		break;
> +	default:
> +		memset(ptr.p, 0, ctrl->elems * ctrl->elem_size);
>  		break;
>  	}
>  }
> @@ -1929,7 +1952,6 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	unsigned elems = 1;
>  	bool is_array;
>  	unsigned tot_ctrl_size;
> -	unsigned idx;
>  	void *data;
>  	int err;
>  
> @@ -2049,10 +2071,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  		ctrl->p_new.p = &ctrl->val;
>  		ctrl->p_cur.p = &ctrl->cur.val;
>  	}
> -	for (idx = 0; idx < elems; idx++) {
> -		ctrl->type_ops->init(ctrl, idx, ctrl->p_cur);
> -		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
> -	}
> +	ctrl->type_ops->init(ctrl, ctrl->p_cur);
> +	ctrl->type_ops->init(ctrl, ctrl->p_new);
>  
>  	if (handler_new_ref(hdl, ctrl)) {
>  		kfree(ctrl);
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index e1cfb8f..a7280e9 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -87,8 +87,7 @@ struct v4l2_ctrl_type_ops {
>  	bool (*equal)(const struct v4l2_ctrl *ctrl, u32 idx,
>  		      union v4l2_ctrl_ptr ptr1,
>  		      union v4l2_ctrl_ptr ptr2);
> -	void (*init)(const struct v4l2_ctrl *ctrl, u32 idx,
> -		     union v4l2_ctrl_ptr ptr);
> +	void (*init)(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr ptr);
>  	void (*log)(const struct v4l2_ctrl *ctrl);
>  	int (*validate)(const struct v4l2_ctrl *ctrl, u32 idx,
>  			union v4l2_ctrl_ptr ptr);
> 

