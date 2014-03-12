Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32387 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaCLKee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 06:34:34 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2B00I5IK1KNG00@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Mar 2014 06:34:33 -0400 (EDT)
Date: Wed, 12 Mar 2014 07:34:26 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 11/35] v4l2-ctrls: prepare for matrix support: add
 cols & rows fields.
Message-id: <20140312073426.4c4bdc08@samsung.com>
In-reply-to: <1392631070-41868-12-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
 <1392631070-41868-12-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 17 Feb 2014 10:57:26 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add cols and rows fields to the core control structures in preparation
> for matrix support.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 26 +++++++++++++++++---------
>  include/media/v4l2-ctrls.h           |  6 ++++++
>  2 files changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index ad8e5e4..a136cdc 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1731,7 +1731,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  			u32 id, const char *name, const char *unit,
>  			enum v4l2_ctrl_type type,
>  			s64 min, s64 max, u64 step, s64 def,
> -			u32 elem_size,
> +			u32 cols, u32 rows, u32 elem_size,
>  			u32 flags, const char * const *qmenu,
>  			const s64 *qmenu_int, void *priv)
>  {
> @@ -1744,6 +1744,11 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	if (hdl->error)
>  		return NULL;
>  
> +	if (cols == 0)
> +		cols = 1;
> +	if (rows == 0)
> +		rows = 1;
> +
>  	if (type == V4L2_CTRL_TYPE_INTEGER64)
>  		elem_size = sizeof(s64);
>  	else if (type == V4L2_CTRL_TYPE_STRING)
> @@ -1803,6 +1808,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	ctrl->is_string = type == V4L2_CTRL_TYPE_STRING;
>  	ctrl->is_ptr = type >= V4L2_CTRL_COMPLEX_TYPES || ctrl->is_string;
>  	ctrl->is_int = !ctrl->is_ptr && type != V4L2_CTRL_TYPE_INTEGER64;
> +	ctrl->cols = cols;
> +	ctrl->rows = rows;
>  	ctrl->elem_size = elem_size;
>  	if (type == V4L2_CTRL_TYPE_MENU)
>  		ctrl->qmenu = qmenu;
> @@ -1868,8 +1875,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
>  
>  	ctrl = v4l2_ctrl_new(hdl, cfg->ops, cfg->type_ops, cfg->id, name, unit,
>  			type, min, max,
> -			is_menu ? cfg->menu_skip_mask : step,
> -			def, cfg->elem_size,
> +			is_menu ? cfg->menu_skip_mask : step, def,
> +			cfg->cols, cfg->rows, cfg->elem_size,
>  			flags, qmenu, qmenu_int, priv);
>  	if (ctrl)
>  		ctrl->is_private = cfg->is_private;
> @@ -1895,7 +1902,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
>  		return NULL;
>  	}
>  	return v4l2_ctrl_new(hdl, ops, NULL, id, name, unit, type,
> -			     min, max, step, def, 0,
> +			     min, max, step, def, 0, 0, 0,
>  			     flags, NULL, NULL, NULL);

Gah, the number of parameters here is too big... 18 parameters on this
function call! Please replace it by an structure.

>  }
>  EXPORT_SYMBOL(v4l2_ctrl_new_std);
> @@ -1929,7 +1936,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
>  		return NULL;
>  	}
>  	return v4l2_ctrl_new(hdl, ops, NULL, id, name, unit, type,
> -			     0, max, mask, def, 0,
> +			     0, max, mask, def, 0, 0, 0,
>  			     flags, qmenu, qmenu_int, NULL);
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
> @@ -1962,8 +1969,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
>  		return NULL;
>  	}
>  	return v4l2_ctrl_new(hdl, ops, NULL, id, name, unit, type,
> -			     0, max, mask, def,
> -			     0, flags, qmenu, NULL, NULL);
> +			     0, max, mask, def, 0, 0, 0,
> +			     flags, qmenu, NULL, NULL);
>  
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_new_std_menu_items);
> @@ -1988,7 +1995,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
>  		return NULL;
>  	}
>  	return v4l2_ctrl_new(hdl, ops, NULL, id, name, unit, type,
> -			     0, max, 0, def, 0,
> +			     0, max, 0, def, 0, 0, 0,
>  			     flags, NULL, qmenu_int, NULL);
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_new_int_menu);
> @@ -2334,7 +2341,8 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
>  	qc->min.val = ctrl->minimum;
>  	qc->max.val = ctrl->maximum;
>  	qc->def.val = ctrl->default_value;
> -	qc->cols = qc->rows = 1;
> +	qc->cols = ctrl->cols;
> +	qc->rows = ctrl->rows;
>  	if (ctrl->type == V4L2_CTRL_TYPE_MENU
>  	    || ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU)
>  		qc->step.val = 1;
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 5a39877..9eeb9d9 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -129,6 +129,8 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
>    * @minimum:	The control's minimum value.
>    * @maximum:	The control's maximum value.
>    * @default_value: The control's default value.
> +  * @rows:	The number of rows in the matrix.
> +  * @cols:	The number of columns in the matrix.
>    * @step:	The control's step value for non-menu controls.
>    * @elem_size:	The size in bytes of the control.
>    * @menu_skip_mask: The control's skip mask for menu controls. This makes it
> @@ -178,6 +180,7 @@ struct v4l2_ctrl {
>  	const char *unit;
>  	enum v4l2_ctrl_type type;
>  	s64 minimum, maximum, default_value;
> +	u32 rows, cols;
>  	u32 elem_size;
>  	union {
>  		u64 step;
> @@ -265,6 +268,8 @@ struct v4l2_ctrl_handler {
>    * @max:	The control's maximum value.
>    * @step:	The control's step value for non-menu controls.
>    * @def: 	The control's default value.
> +  * @rows:	The number of rows in the matrix.
> +  * @cols:	The number of columns in the matrix.
>    * @elem_size:	The size in bytes of the control.
>    * @flags:	The control's flags.
>    * @menu_skip_mask: The control's skip mask for menu controls. This makes it
> @@ -291,6 +296,7 @@ struct v4l2_ctrl_config {
>  	s64 max;
>  	u64 step;
>  	s64 def;
> +	u32 rows, cols;
>  	u32 elem_size;
>  	u32 flags;
>  	u64 menu_skip_mask;


-- 

Regards,
Mauro
