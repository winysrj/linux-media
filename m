Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1364 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3JBOFh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 10:05:37 -0400
Message-ID: <524C2826.6030902@xs4all.nl>
Date: Wed, 02 Oct 2013 16:05:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 1/4] v4l: return POLLERR on V4L2 sub-devices if no events
 are subscribed
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <1380721516-488-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1380721516-488-2-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/13 15:45, Sakari Ailus wrote:
> From: Teemu Tuominen <teemux.tuominen@intel.com>
>
> Add check and return POLLERR from subdev_poll() in case of no events
> subscribed and wakeup once the last event subscription is removed.
>
> This change is essentially done to add possibility to wakeup polling
> with concurrent unsubscribe.
>
> Signed-off-by: Teemu Tuominen <teemux.tuominen@intel.com>
>
> Move the check after calling poll_wait(). Otherwise it's possible that we go
> to sleep without getting notified if the subscription went away between the
> two.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Tested-by: Teemu Tuominen <teemux.tuominen@intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>   drivers/media/v4l2-core/v4l2-event.c  | 15 +++++++++++++++
>   drivers/media/v4l2-core/v4l2-subdev.c |  3 +++
>   include/media/v4l2-event.h            |  1 +
>   3 files changed, 19 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
> index 86dcb54..b53897e 100644
> --- a/drivers/media/v4l2-core/v4l2-event.c
> +++ b/drivers/media/v4l2-core/v4l2-event.c
> @@ -107,6 +107,19 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
>   	return NULL;
>   }
>
> +bool v4l2_event_has_subscribed(struct v4l2_fh *fh)
> +{
> +	unsigned long flags;
> +	bool rval;
> +
> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> +	rval = !list_empty(&fh->subscribed);
> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> +
> +	return rval;
> +}
> +EXPORT_SYMBOL(v4l2_event_has_subscribed);
> +
>   static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
>   		const struct timespec *ts)
>   {
> @@ -299,6 +312,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>   			fh->navailable--;
>   		}
>   		list_del(&sev->list);
> +		if (list_empty(&fh->subscribed))
> +			wake_up_all(&fh->wait);
>   	}
>
>   	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 996c248..7d72389 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -382,6 +382,9 @@ static unsigned int subdev_poll(struct file *file, poll_table *wait)
>   	if (v4l2_event_pending(fh))
>   		return POLLPRI;
>
> +	if (!v4l2_event_has_subscribed(fh))
> +		return POLLERR | POLLPRI;
> +
>   	return 0;
>   }
>
> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> index be05d01..a9ca2b5 100644
> --- a/include/media/v4l2-event.h
> +++ b/include/media/v4l2-event.h
> @@ -121,6 +121,7 @@ struct v4l2_subscribed_event {
>
>   int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
>   		       int nonblocking);
> +bool v4l2_event_has_subscribed(struct v4l2_fh *fh);
>   void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
>   void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
>   int v4l2_event_pending(struct v4l2_fh *fh);
>

