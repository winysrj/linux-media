Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37624 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbeIUDKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 23:10:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl, mchehab@kernel.org
Subject: Re: [PATCH v3 1/1] v4l: event: Prevent freeing event subscriptions while accessed
Date: Fri, 21 Sep 2018 00:25:37 +0300
Message-ID: <3060033.FijsL0T3jF@avalon>
In-Reply-To: <20180914110301.12728-1-sakari.ailus@linux.intel.com>
References: <20180914110301.12728-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday, 14 September 2018 14:03:01 EEST Sakari Ailus wrote:
> The event subscriptions are added to the subscribed event list while
> holding a spinlock, but that lock is subsequently released while still
> accessing the subscription object. This makes it possible to unsubscribe
> the event --- and freeing the subscription object's memory --- while
> the subscription object is simultaneously accessed.
> 
> Prevent this by adding a mutex to serialise the event subscription and
> unsubscription. This also gives a guarantee to the callback ops that the
> add op has returned before the del op is called.
> 
> This change also results in making the elems field less special:
> subscriptions are only added to the event list once they are fully
> initialised.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

It wasn't immediately clear to me that the !sev->elems check can be removed 
because the subscriptions are *now* only added to the event list once they are 
fully initialized, I thought the sentence documented the current 
implementation. After realizing that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> since v1:
> 
> - Call the mutex field subscribe_lock instead.
> 
> - Move the field that is now subscribe_lock above the subscribed field the
>   write access to which it serialises.
> 
> - Improve documentation of the subscribe_lock field.
> 
> since v2:
> 
> - Acquire spinlock for the duration of list_add() in v4l2_event_subscribe().
> 
> - Remove a redundant comment in the same place.
> 
>  drivers/media/v4l2-core/v4l2-event.c | 38 +++++++++++++++++----------------
>  drivers/media/v4l2-core/v4l2-fh.c    |  2 ++
>  include/media/v4l2-fh.h              |  4 ++++
>  3 files changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-event.c
> b/drivers/media/v4l2-core/v4l2-event.c index 127fe6eb91d9..a3ef1f50a4b3
> 100644
> --- a/drivers/media/v4l2-core/v4l2-event.c
> +++ b/drivers/media/v4l2-core/v4l2-event.c
> @@ -115,14 +115,6 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh,
> const struct v4l2_event *e if (sev == NULL)
>  		return;
> 
> -	/*
> -	 * If the event has been added to the fh->subscribed list, but its
> -	 * add op has not completed yet elems will be 0, treat this as
> -	 * not being subscribed.
> -	 */
> -	if (!sev->elems)
> -		return;
> -
>  	/* Increase event sequence number on fh. */
>  	fh->sequence++;
> 
> @@ -208,6 +200,7 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  	struct v4l2_subscribed_event *sev, *found_ev;
>  	unsigned long flags;
>  	unsigned i;
> +	int ret = 0;
> 
>  	if (sub->type == V4L2_EVENT_ALL)
>  		return -EINVAL;
> @@ -225,31 +218,36 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  	sev->flags = sub->flags;
>  	sev->fh = fh;
>  	sev->ops = ops;
> +	sev->elems = elems;
> +
> +	mutex_lock(&fh->subscribe_lock);
> 
>  	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>  	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
> -	if (!found_ev)
> -		list_add(&sev->list, &fh->subscribed);
>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> 
>  	if (found_ev) {
> +		/* Already listening */
>  		kvfree(sev);
> -		return 0; /* Already listening */
> +		goto out_unlock;
>  	}
> 
>  	if (sev->ops && sev->ops->add) {
> -		int ret = sev->ops->add(sev, elems);
> +		ret = sev->ops->add(sev, elems);
>  		if (ret) {
> -			sev->ops = NULL;
> -			v4l2_event_unsubscribe(fh, sub);
> -			return ret;
> +			kvfree(sev);
> +			goto out_unlock;
>  		}
>  	}
> 
> -	/* Mark as ready for use */
> -	sev->elems = elems;
> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> +	list_add(&sev->list, &fh->subscribed);
> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> 
> -	return 0;
> +out_unlock:
> +	mutex_unlock(&fh->subscribe_lock);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
> 
> @@ -288,6 +286,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  		return 0;
>  	}
> 
> +	mutex_lock(&fh->subscribe_lock);
> +
>  	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> 
>  	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
> @@ -305,6 +305,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  	if (sev && sev->ops && sev->ops->del)
>  		sev->ops->del(sev);
> 
> +	mutex_unlock(&fh->subscribe_lock);
> +
>  	kvfree(sev);
> 
>  	return 0;
> diff --git a/drivers/media/v4l2-core/v4l2-fh.c
> b/drivers/media/v4l2-core/v4l2-fh.c index 3895999bf880..c91a7bd3ecfc 100644
> --- a/drivers/media/v4l2-core/v4l2-fh.c
> +++ b/drivers/media/v4l2-core/v4l2-fh.c
> @@ -45,6 +45,7 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device
> *vdev) INIT_LIST_HEAD(&fh->available);
>  	INIT_LIST_HEAD(&fh->subscribed);
>  	fh->sequence = -1;
> +	mutex_init(&fh->subscribe_lock);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fh_init);
> 
> @@ -90,6 +91,7 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
>  		return;
>  	v4l_disable_media_source(fh->vdev);
>  	v4l2_event_unsubscribe_all(fh);
> +	mutex_destroy(&fh->subscribe_lock);
>  	fh->vdev = NULL;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fh_exit);
> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> index ea73fef8bdc0..8586cfb49828 100644
> --- a/include/media/v4l2-fh.h
> +++ b/include/media/v4l2-fh.h
> @@ -38,10 +38,13 @@ struct v4l2_ctrl_handler;
>   * @prio: priority of the file handler, as defined by &enum v4l2_priority
>   *
>   * @wait: event' s wait queue
> + * @subscribe_lock: serialise changes to the subscribed list; guarantee
> that + *		    the add and del event callbacks are orderly called
>   * @subscribed: list of subscribed events
>   * @available: list of events waiting to be dequeued
>   * @navailable: number of available events at @available list
>   * @sequence: event sequence number
> + *
>   * @m2m_ctx: pointer to &struct v4l2_m2m_ctx
>   */
>  struct v4l2_fh {
> @@ -52,6 +55,7 @@ struct v4l2_fh {
> 
>  	/* Events */
>  	wait_queue_head_t	wait;
> +	struct mutex		subscribe_lock;
>  	struct list_head	subscribed;
>  	struct list_head	available;
>  	unsigned int		navailable;


-- 
Regards,

Laurent Pinchart
