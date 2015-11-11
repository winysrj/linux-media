Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:49423 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbbKKMLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 07:11:34 -0500
Subject: Re: [PATCH] v4l2-core/v4l2-ctrls: Filter NOOP CH_RANGE events
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dimitrios Katsaros <patcherwork@gmail.com>
References: <1447243114-1011-1-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56433063.3010401@xs4all.nl>
Date: Wed, 11 Nov 2015 13:11:15 +0100
MIME-Version: 1.0
In-Reply-To: <1447243114-1011-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/15 12:58, Ricardo Ribalda Delgado wrote:
> If modify_range is called but no range is changed, do not send the
> CH_RANGE event.

While not opposed to this patch, I do wonder what triggered this patch?
Is it just a matter of efficiency? And since it is a driver that calls
this, shouldn't the driver only call this function when something
actually changes?

In other words, can you give some background information?

Regards,

	Hans

PS: still haven't processed your V4L2_CTRL_WHICH_DEF_VAL patch series. Hope
to do this next week at the latest.

> 
> Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 4a1d9fdd14bb..f9c0e8150bd1 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3300,7 +3300,8 @@ EXPORT_SYMBOL(v4l2_ctrl_notify);
>  int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
>  			s64 min, s64 max, u64 step, s64 def)
>  {
> -	bool changed;
> +	bool value_changed;
> +	bool range_changed = false;
>  	int ret;
>  
>  	lockdep_assert_held(ctrl->handler->lock);
> @@ -3324,10 +3325,14 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
>  	default:
>  		return -EINVAL;
>  	}
> -	ctrl->minimum = min;
> -	ctrl->maximum = max;
> -	ctrl->step = step;
> -	ctrl->default_value = def;
> +	if ((ctrl->minimum != min) || (ctrl->maximum != max) ||
> +		(ctrl->step != step) || ctrl->default_value != def) {
> +		range_changed = true;
> +		ctrl->minimum = min;
> +		ctrl->maximum = max;
> +		ctrl->step = step;
> +		ctrl->default_value = def;
> +	}
>  	cur_to_new(ctrl);
>  	if (validate_new(ctrl, ctrl->p_new)) {
>  		if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
> @@ -3337,12 +3342,12 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
>  	}
>  
>  	if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
> -		changed = *ctrl->p_new.p_s64 != *ctrl->p_cur.p_s64;
> +		value_changed = *ctrl->p_new.p_s64 != *ctrl->p_cur.p_s64;
>  	else
> -		changed = *ctrl->p_new.p_s32 != *ctrl->p_cur.p_s32;
> -	if (changed)
> +		value_changed = *ctrl->p_new.p_s32 != *ctrl->p_cur.p_s32;
> +	if (value_changed)
>  		ret = set_ctrl(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
> -	else
> +	else if (range_changed)
>  		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
>  	return ret;
>  }
> 
