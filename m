Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab1J1IhD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Oct 2011 04:37:03 -0400
Message-ID: <4EAA69BF.8060702@redhat.com>
Date: Fri, 28 Oct 2011 10:37:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 5/6] v4l2-event: Add v4l2_subscribed_event_ops
References: <1319714283-3991-1-git-send-email-hdegoede@redhat.com> <1319714283-3991-6-git-send-email-hdegoede@redhat.com> <201110271430.25044.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201110271430.25044.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/27/2011 02:30 PM, Laurent Pinchart wrote:
> Hi Hans,
>
> On Thursday 27 October 2011 13:18:02 Hans de Goede wrote:
>> Just like with ctrl events, drivers may want to get called back on
>> listener add / remove for other event types too. Rather then special
>> casing all of this in subscribe / unsubscribe event it is better to
>> use ops for this.
>>
>> Signed-off-by: Hans de Goede<hdegoede@redhat.com>
>> ---
>>   drivers/media/video/ivtv/ivtv-ioctl.c  |    2 +-
>>   drivers/media/video/omap3isp/ispccdc.c |    2 +-
>>   drivers/media/video/omap3isp/ispstat.c |    2 +-
>>   drivers/media/video/pwc/pwc-v4l.c      |    2 +-
>>   drivers/media/video/v4l2-event.c       |   42 ++++++++++++++++++++++-------
>>   drivers/media/video/vivi.c             |    2 +-
>>   include/media/v4l2-event.h             |   24 +++++++++++++-----
>
> Haven't you forgotten to update Documentation/video4linux/v4l2-framework.txt ?
>

I think I have, I'll go and do another revision fixing this.

>>   7 files changed, 54 insertions(+), 22 deletions(-)
>
> [snip]
>
>> diff --git a/drivers/media/video/v4l2-event.c
>> b/drivers/media/video/v4l2-event.c index 3d27300..2dd9252 100644
>> --- a/drivers/media/video/v4l2-event.c
>> +++ b/drivers/media/video/v4l2-event.c
>> @@ -131,14 +131,14 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh,
>> const struct v4l2_event *e sev->first = sev_pos(sev, 1);
>>   		fh->navailable--;
>>   		if (sev->elems == 1) {
>> -			if (sev->replace) {
>> -				sev->replace(&kev->event, ev);
>> +			if (sev->ops&&  sev->ops->replace) {
>> +				sev->ops->replace(&kev->event, ev);
>>   				copy_payload = false;
>>   			}
>> -		} else if (sev->merge) {
>> +		} else if (sev->ops&&  sev->ops->merge) {
>>   			struct v4l2_kevent *second_oldest =
>>   				sev->events + sev_pos(sev, 0);
>> -			sev->merge(&kev->event,&second_oldest->event);
>> +			sev->ops->merge(&kev->event,&second_oldest->event);
>>   		}
>>   	}
>>
>> @@ -207,8 +207,14 @@ static void ctrls_merge(const struct v4l2_event *old,
>> struct v4l2_event *new) new->u.ctrl.changes |= old->u.ctrl.changes;
>>   }
>>
>> +const struct v4l2_subscribed_event_ops ctrl_ops = {
>
> Shouldn't this be static const ?
>

You're right I will fix this in the next iteration.

>> +	.replace = ctrls_replace,
>> +	.merge = ctrls_merge,
>> +};
>> +
>>   int v4l2_event_subscribe(struct v4l2_fh *fh,
>> -			 struct v4l2_event_subscription *sub, unsigned elems)
>> +			 struct v4l2_event_subscription *sub, unsigned elems,
>> +			 const struct v4l2_subscribed_event_ops *ops)
>>   {
>>   	struct v4l2_subscribed_event *sev, *found_ev;
>>   	struct v4l2_ctrl *ctrl = NULL;
>> @@ -236,9 +242,9 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>>   	sev->flags = sub->flags;
>>   	sev->fh = fh;
>>   	sev->elems = elems;
>> +	sev->ops = ops;
>>   	if (ctrl) {
>> -		sev->replace = ctrls_replace;
>> -		sev->merge = ctrls_merge;
>> +		sev->ops =&ctrl_ops;
>>   	}
>
> You can remove the brackets here.
>

I was aiming for minimal diff size here, since this bit will go away in the
next patch in the series anyways.

>>
>>   	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>> @@ -247,10 +253,22 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>>   		list_add(&sev->list,&fh->subscribed);
>>   	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>>
>> -	/* v4l2_ctrl_add_event uses a mutex, so do this outside the spin lock */
>> -	if (found_ev)
>> +	if (found_ev) {
>>   		kfree(sev);
>> -	else if (ctrl)
>> +		return 0; /* Already listening */
>> +	}
>> +
>> +	if (sev->ops&&  sev->ops->add) {
>> +		int ret = sev->ops->add(sev);
>> +		if (ret) {
>> +			sev->ops = NULL;
>> +			v4l2_event_unsubscribe(fh, sub);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	/* v4l2_ctrl_add_event uses a mutex, so do this outside the spin lock */
>> +	if (ctrl)
>>   		v4l2_ctrl_add_event(ctrl, sev);
>>
>>   	return 0;
>> @@ -307,6 +325,10 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>>   	}
>>
>>   	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>> +
>> +	if (sev&&  sev->ops&&  sev->ops->del)
>> +		sev->ops->del(sev);
>> +
>>   	if (sev&&  sev->type == V4L2_EVENT_CTRL) {
>>   		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
>>
>

Regards,

Hans
