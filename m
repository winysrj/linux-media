Return-Path: <hverkuil@xs4all.nl>
Message-id: <54EAED82.5040804@xs4all.nl>
Date: Mon, 23 Feb 2015 10:06:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] media/v4l2-ctrls: Always run s_ctrl on volatile
 ctrls
References: <1424185706-16711-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1424185706-16711-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On 02/17/2015 04:08 PM, Ricardo Ribalda Delgado wrote:
> Volatile controls can change their value outside the v4l-ctrl framework.
> We should ignore the cached written value of the ctrl when evaluating if
> we should run s_ctrl.

I've been thinking some more about this (also due to some comments Laurent
made on irc), and I think this should be done differently.

What you want to do here is to signal that setting this control will execute
some action that needs to happen even if the same value is set twice.

That's not really covered by VOLATILE. Interestingly, the WRITE_ONLY flag is
to be used for just that purpose, but this happens to be a R/W control, so
that can't be used either.

What is needed is the following:

1) Add a new flag: V4L2_CTRL_FLAG_ACTION.
2) Any control that sets FLAG_WRITE_ONLY should OR it with FLAG_ACTION (to
   keep the current meaning of WRITE_ONLY).
3) Any control with FLAG_ACTION set should return changed == true in
   cluster_changed.
4) Any control with FLAG_VOLATILE set should set ctrl->has_changed to false
   to prevent generating the CH_VALUE control (that's a real bug).

Your control will now set FLAG_ACTION and FLAG_VOLATILE and it will do the
right thing.

Basically what was missing was a flag to explicitly signal this 'writing
executes an action' behavior. Trying to shoehorn that into the volatile
flag or the write_only flag is just not right. It's a flag in its own right.

Regards,

	Hans

> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> v4: Hans Verkuil:
> 
> explicity set has_changed to false. and add comment
> 
>  drivers/media/v4l2-core/v4l2-ctrls.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 45c5b47..f34a689 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1609,6 +1609,17 @@ static int cluster_changed(struct v4l2_ctrl *master)
>  
>  		if (ctrl == NULL)
>  			continue;
> +
> +		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
> +			/*
> +			 * Set has_changed to false to avoid generating
> +			 * the event V4L2_EVENT_CTRL_CH_VALUE
> +			 */
> +			ctrl->has_changed = false;
> +			changed = true;
> +			continue;
> +		}
> +
>  		for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
>  			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
>  				ctrl->p_cur, ctrl->p_new);
> 
