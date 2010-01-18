Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1281 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab0ARMsS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 07:48:18 -0500
Date: Mon, 18 Jan 2010 13:48:04 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com
Subject: Re: [RFC v2 6/7] V4L: Events: Sequence numbers
In-Reply-To: <1261500191-9441-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Message-ID: <alpine.LNX.2.01.1001181344190.31857@alastor>
References: <4B30F713.8070004@maxwell.research.nokia.com> <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-2-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-5-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Some more review comments:

On Tue, 22 Dec 2009, Sakari Ailus wrote:

> Add sequence numbers to events.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
> drivers/media/video/v4l2-event.c |    8 ++++++++
> include/media/v4l2-event.h       |    1 +
> 2 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index 72fdf7f..cc2bf57 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -58,6 +58,7 @@ void v4l2_event_init_fh(struct v4l2_fh *fh)
> 	INIT_LIST_HEAD(&events->subscribed);
>
> 	atomic_set(&events->navailable, 0);
> +	events->sequence = 0;

Why not make this atomic_t as well?

> }
> EXPORT_SYMBOL_GPL(v4l2_event_init_fh);
>
> @@ -158,10 +159,16 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
>
> 	list_for_each_entry(fh, &vdev->fh, list) {
> 		struct _v4l2_event *_ev;
> +		u32 sequence;
>
> 		if (!v4l2_event_subscribed(fh, ev->type))
> 			continue;
>
> +		spin_lock(&fh->events.lock);
> +		sequence = fh->events.sequence;
> +		fh->events.sequence++;
> +		spin_unlock(&fh->events.lock);

Then you can use atomic_inc_return() here.

> +
> 		if (atomic_read(&fh->events.navailable) >= V4L2_MAX_EVENTS)
> 			continue;
>
> @@ -172,6 +179,7 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
> 		_ev->event = *ev;
>
> 		spin_lock(&fh->events.lock);
> +		_ev->event.sequence = sequence;
> 		list_add_tail(&_ev->list, &fh->events.available);
> 		spin_unlock(&fh->events.lock);
>
> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> index 69305c6..5a778d4 100644
> --- a/include/media/v4l2-event.h
> +++ b/include/media/v4l2-event.h
> @@ -44,6 +44,7 @@ struct v4l2_events {
> 	spinlock_t		lock; /* Protect everything here. */
> 	struct list_head	available;
> 	atomic_t		navailable;
> +	u32			sequence;
> 	wait_queue_head_t	wait;
> 	struct list_head	subscribed; /* Subscribed events. */
> };
> -- 
> 1.5.6.5
>

Regards,

 	Hans
