Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:34711 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728133AbeKFRhy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 12:37:54 -0500
Subject: Re: [PATCH v3 1/1] v4l: event: Add subscription to list before
 calling "add" operation
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, dave.stevenson@raspberrypi.org
References: <20181106080035.30351-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <46e71d96-c8c5-bd97-1b9a-21f4d62c2adf@xs4all.nl>
Date: Tue, 6 Nov 2018 09:13:47 +0100
MIME-Version: 1.0
In-Reply-To: <20181106080035.30351-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/2018 09:00 AM, Sakari Ailus wrote:
> Patch ad608fbcf166 changed how events were subscribed to address an issue
> elsewhere. As a side effect of that change, the "add" callback was called
> before the event subscription was added to the list of subscribed events,
> causing the first event queued by the add callback (and possibly other
> events arriving soon afterwards) to be lost.
> 
> Fix this by adding the subscription to the list before calling the "add"
> callback, and clean up afterwards if that fails.
> 
> Fixes: ad608fbcf166 ("media: v4l: event: Prevent freeing event subscriptions while accessed")
> 
> Reported-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

Tested with vivid & v4l2-compliance.

Regards,

	Hans

> ---
> since v2:
> 
> - More accurate commit message. No other changes.
> 
>  drivers/media/v4l2-core/v4l2-event.c | 43 ++++++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
> index a3ef1f50a4b3..481e3c65cf97 100644
> --- a/drivers/media/v4l2-core/v4l2-event.c
> +++ b/drivers/media/v4l2-core/v4l2-event.c
> @@ -193,6 +193,22 @@ int v4l2_event_pending(struct v4l2_fh *fh)
>  }
>  EXPORT_SYMBOL_GPL(v4l2_event_pending);
>  
> +static void __v4l2_event_unsubscribe(struct v4l2_subscribed_event *sev)
> +{
> +	struct v4l2_fh *fh = sev->fh;
> +	unsigned int i;
> +
> +	lockdep_assert_held(&fh->subscribe_lock);
> +	assert_spin_locked(&fh->vdev->fh_lock);
> +
> +	/* Remove any pending events for this subscription */
> +	for (i = 0; i < sev->in_use; i++) {
> +		list_del(&sev->events[sev_pos(sev, i)].list);
> +		fh->navailable--;
> +	}
> +	list_del(&sev->list);
> +}
> +
>  int v4l2_event_subscribe(struct v4l2_fh *fh,
>  			 const struct v4l2_event_subscription *sub, unsigned elems,
>  			 const struct v4l2_subscribed_event_ops *ops)
> @@ -224,27 +240,23 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  
>  	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>  	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
> +	if (!found_ev)
> +		list_add(&sev->list, &fh->subscribed);
>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>  
>  	if (found_ev) {
>  		/* Already listening */
>  		kvfree(sev);
> -		goto out_unlock;
> -	}
> -
> -	if (sev->ops && sev->ops->add) {
> +	} else if (sev->ops && sev->ops->add) {
>  		ret = sev->ops->add(sev, elems);
>  		if (ret) {
> +			spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> +			__v4l2_event_unsubscribe(sev);
> +			spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>  			kvfree(sev);
> -			goto out_unlock;
>  		}
>  	}
>  
> -	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> -	list_add(&sev->list, &fh->subscribed);
> -	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> -
> -out_unlock:
>  	mutex_unlock(&fh->subscribe_lock);
>  
>  	return ret;
> @@ -279,7 +291,6 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  {
>  	struct v4l2_subscribed_event *sev;
>  	unsigned long flags;
> -	int i;
>  
>  	if (sub->type == V4L2_EVENT_ALL) {
>  		v4l2_event_unsubscribe_all(fh);
> @@ -291,14 +302,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>  
>  	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
> -	if (sev != NULL) {
> -		/* Remove any pending events for this subscription */
> -		for (i = 0; i < sev->in_use; i++) {
> -			list_del(&sev->events[sev_pos(sev, i)].list);
> -			fh->navailable--;
> -		}
> -		list_del(&sev->list);
> -	}
> +	if (sev != NULL)
> +		__v4l2_event_unsubscribe(sev);
>  
>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>  
> 
