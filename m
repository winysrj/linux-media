Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33446 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1FTNdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 09:33:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv3 PATCH 13/18] v4l2-ctrls: add control events.
Date: Mon, 20 Jun 2011 15:33:36 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <fe0a2747088972ad92088ce06c701a8f722c0831.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <fe0a2747088972ad92088ce06c701a8f722c0831.1307458245.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201533.36310.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch, and sorry for the late review.

On Tuesday 07 June 2011 17:05:18 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Whenever a control changes value or state an event is sent to anyone
> that subscribed to it.
> 
> This functionality is useful for control panels but also for applications
> that need to wait for (usually status) controls to change value.

[snip]

> +static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32
> changes) +{
> +	struct v4l2_event ev;
> +	struct v4l2_ctrl_fh *pos;
> +
> +	if (list_empty(&ctrl->fhs))
> +			return;

There's one extra tab here.

> +	fill_event(&ev, ctrl, changes);
> +
> +	list_for_each_entry(pos, &ctrl->fhs, node)
> +		if (pos->fh != fh)
> +			v4l2_event_queue_fh(pos->fh, &ev);
> +}

[snip]

> @@ -1222,15 +1279,21 @@ EXPORT_SYMBOL(v4l2_ctrl_auto_cluster);
>  /* Activate/deactivate a control. */
>  void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
>  {
> +	/* invert since the actual flag is called 'inactive' */
> +	bool inactive = !active;
> +	bool old;
> +
>  	if (ctrl == NULL)
>  		return;
> 
> -	if (!active)
> +	if (inactive)
>  		/* set V4L2_CTRL_FLAG_INACTIVE */
> -		set_bit(4, &ctrl->flags);
> +		old = test_and_set_bit(4, &ctrl->flags);

I've never been found of hardcoded constants. What about 
ffs(V4L2_CTRL_FLAG_INACTIVE) - 1 instead ? gcc will optimize that to a 
constant.

>  	else
>  		/* clear V4L2_CTRL_FLAG_INACTIVE */
> -		clear_bit(4, &ctrl->flags);
> +		old = test_and_clear_bit(4, &ctrl->flags);
> +	if (old != inactive)
> +		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_FLAGS);
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_activate);

[snip]

> @@ -182,37 +218,26 @@ void v4l2_event_queue(struct video_device *vdev,
> const struct v4l2_event *ev) spin_lock_irqsave(&vdev->fh_lock, flags);
> 
>  	list_for_each_entry(fh, &vdev->fh_list, list) {
> -		struct v4l2_events *events = fh->events;
> -		struct v4l2_kevent *kev;
> -
> -		/* Are we subscribed? */
> -		if (!v4l2_event_subscribed(fh, ev->type))
> -			continue;
> -
> -		/* Increase event sequence number on fh. */
> -		events->sequence++;
> -
> -		/* Do we have any free events? */
> -		if (list_empty(&events->free))
> -			continue;
> -
> -		/* Take one and fill it. */
> -		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
> -		kev->event.type = ev->type;
> -		kev->event.u = ev->u;
> -		kev->event.timestamp = timestamp;
> -		kev->event.sequence = events->sequence;
> -		list_move_tail(&kev->list, &events->available);
> -
> -		events->navailable++;
> -
> -		wake_up_all(&events->wait);
> +		__v4l2_event_queue_fh(fh, ev, &timestamp);
>  	}

You can remove the braces.

> 
>  	spin_unlock_irqrestore(&vdev->fh_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_event_queue);

-- 
Regards,

Laurent Pinchart
