Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4112 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3AUIZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 03:25:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH 2/3] v4l2-ctrl: Add helper function for control range update
Date: Mon, 21 Jan 2013 09:25:23 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <1358630842-12689-1-git-send-email-sylvester.nawrocki@gmail.com> <1358630842-12689-3-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1358630842-12689-3-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301210925.23817.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester!

On Sat January 19 2013 22:27:21 Sylwester Nawrocki wrote:
> This patch adds a helper function that allows to modify range,
> i.e. minimum, maximum, step and default value of a v4l2 control,
> after the control has been created and initialized. This is helpful
> in situations when range of a control depends on user configurable
> parameters, e.g. camera sensor absolute exposure time depending on
> an output image resolution and frame rate.
> 
> v4l2_ctrl_modify_range() function allows to modify range of an
> INTEGER, BOOL, MENU, INTEGER_MENU and BITMASK type controls.
> 
> Based on a patch from Hans Verkuil http://patchwork.linuxtv.org/patch/8654.
> 
> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

This is a very nice patch. I found only one small mistake:

> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index f6ee201..d68fb57 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2721,10 +2751,44 @@ int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
>  	/* It's a driver bug if this happens. */
>  	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
>  	c.value64 = val;
> -	return set_ctrl(NULL, ctrl, &c);
> +	return set_ctrl_lock(NULL, ctrl, &c);
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_s_ctrl_int64);
>  
> +int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
> +			s32 min, s32 max, u32 step, s32 def)
> +{
> +	int ret = check_range(ctrl->type, min, max, step, def);
> +	struct v4l2_ext_control c;
> +
> +	switch (ctrl->type) {
> +	case V4L2_CTRL_TYPE_INTEGER:
> +	case V4L2_CTRL_TYPE_BOOLEAN:
> +	case V4L2_CTRL_TYPE_MENU:
> +	case V4L2_CTRL_TYPE_BITMASK:

TYPE_INTEGER_MENU is missing here!

> +		if (ret)
> +			return ret;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	v4l2_ctrl_lock(ctrl);
> +	ctrl->minimum = min;
> +	ctrl->maximum = max;
> +	ctrl->step = step;
> +	ctrl->default_value = def;
> +	c.value = ctrl->cur.val;
> +	if (validate_new(ctrl, &c))
> +		c.value = def;
> +	if (c.value != ctrl->cur.val)
> +		ret = set_ctrl(NULL, ctrl, &c, V4L2_EVENT_CTRL_CH_RANGE);
> +	else
> +		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
> +	v4l2_ctrl_unlock(ctrl);
> +	return ret;
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_modify_range);
> +
>  static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned elems)
>  {
>  	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(sev->fh->ctrl_handler, sev->id);

After correcting that missing case you can add my ack:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
