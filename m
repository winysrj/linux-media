Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1236 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0BMOkM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 09:40:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v4 7/7] V4L: Events: Support all events
Date: Sat, 13 Feb 2010 15:42:20 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
References: <4B72C965.7040204@maxwell.research.nokia.com> <1265813889-17847-6-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1265813889-17847-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265813889-17847-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002131542.20916.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 February 2010 15:58:09 Sakari Ailus wrote:
> Add support for subscribing all events with a special id V4L2_EVENT_ALL. If
> V4L2_EVENT_ALL is subscribed, no other events may be subscribed. Otherwise
> V4L2_EVENT_ALL is considered just as any other event.

We should do this differently. I think that EVENT_ALL should not be used
internally (i.e. in the actual list of subscribed events), but just as a
special value for the subscribe and unsubscribe ioctls. So when used with
unsubscribe you can just unsubscribe all subscribed events and when used
with subscribe, then you just subscribe all valid events (valid for that
device node).

So in v4l2-event.c you will have a v4l2_event_unsubscribe_all() to quickly
unsubscribe all events.

In order to easily add all events from the driver it would help if the
v4l2_event_subscribe and v4l2_event_unsubscribe just take the event type
as argument rather than the whole v4l2_event_subscription struct.

You will then get something like this in the driver:

	if (sub->type == V4L2_EVENT_ALL) {
		int ret = v4l2_event_alloc(fh, 60);

		ret = ret ? ret : v4l2_event_subscribe(fh, V4L2_EVENT_EOS);
		ret = ret ? ret : v4l2_event_subscribe(fh, V4L2_EVENT_VSYNC);
		return ret;
	}

An alternative might be to add a v4l2_event_subscribe_all(fh, const u32 *events)
where 'events' is a 0 terminated list of events that need to be subscribed.

For each event this function would then call:

fh->vdev->ioctl_ops->vidioc_subscribe_event(fh, sub);

The nice thing about that is that in the driver you have a minimum of fuss.

I'm leaning towards this second solution due to the simple driver implementation.

Handling EVENT_ALL will simplify things substantially IMHO.

Regards,

	Hans

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/v4l2-event.c |   13 ++++++++++++-
>  include/linux/videodev2.h        |    1 +
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index 0af0de5..68b3cf4 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -139,6 +139,14 @@ static struct v4l2_subscribed_event *__v4l2_event_subscribed(
>  	struct v4l2_events *events = fh->events;
>  	struct v4l2_subscribed_event *sev;
>  
> +	if (list_empty(&events->subscribed))
> +		return NULL;
> +
> +	sev = list_entry(events->subscribed.next,
> +			 struct v4l2_subscribed_event, list);
> +	if (sev->type == V4L2_EVENT_ALL)
> +		return sev;
> +
>  	list_for_each_entry(sev, &events->subscribed, list) {
>  		if (sev->type == type)
>  			return sev;
> @@ -222,6 +230,8 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  	/* Allow subscribing to valid events only. */
>  	if (sub->type < V4L2_EVENT_PRIVATE_START)
>  		switch (sub->type) {
> +		case V4L2_EVENT_ALL:
> +			break;
>  		default:
>  			return -EINVAL;
>  		}
> @@ -262,7 +272,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  
>  	sev = __v4l2_event_subscribed(fh, sub->type);
>  
> -	if (sev == NULL) {
> +	if (sev == NULL ||
> +	    (sub->type != V4L2_EVENT_ALL && sev->type == V4L2_EVENT_ALL)) {
>  		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>  		return -EINVAL;
>  	}
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index a19ae89..9ae9a1c 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1553,6 +1553,7 @@ struct v4l2_event_subscription {
>  	__u32		reserved[7];
>  };
>  
> +#define V4L2_EVENT_ALL				0
>  #define V4L2_EVENT_PRIVATE_START		0x08000000
>  
>  /*
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
