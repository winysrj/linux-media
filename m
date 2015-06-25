Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-243.synserver.de ([212.40.185.243]:1065 "EHLO
	smtp-out-241.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752801AbbFYKod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 06:44:33 -0400
Message-ID: <558BDB8E.6000705@metafoo.de>
Date: Thu, 25 Jun 2015 12:44:30 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] [media] adv7604: Deliver resolution change events
 to userspace
References: <1435164631-19924-1-git-send-email-lars@metafoo.de> <1435164631-19924-4-git-send-email-lars@metafoo.de> <20150625102124.GK5904@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150625102124.GK5904@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/25/2015 12:21 PM, Sakari Ailus wrote:
> Hi Lars-Peter,
>
> On Wed, Jun 24, 2015 at 06:50:30PM +0200, Lars-Peter Clausen wrote:
>> Use the new v4l2_subdev_notify_event() helper function to deliver the
>> resolution change event to userspace via the v4l2 subdev event queue as
>> well as to the bridge driver using the callback notify mechanism.
>>
>> This allows userspace applications to react to changes in resolution. This
>> is useful and often necessary for video pipelines where there is no direct
>> 1-to-1 relationship between the subdevice converter and the video capture
>> device and hence it does not make sense to directly forward the event to
>> the video capture device node.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> ---
>>   drivers/media/i2c/adv7604.c | 23 ++++++++++++++++++-----
>>   1 file changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>> index cf1cb5a..b66f63e3 100644
>> --- a/drivers/media/i2c/adv7604.c
>> +++ b/drivers/media/i2c/adv7604.c
>> @@ -1761,8 +1761,8 @@ static int adv76xx_s_routing(struct v4l2_subdev *sd,
>>   	select_input(sd);
>>   	enable_input(sd);
>>
>> -	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
>> -			   (void *)&adv76xx_ev_fmt);
>> +	v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
>> +
>>   	return 0;
>>   }
>>
>> @@ -1929,8 +1929,7 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
>>   			"%s: fmt_change = 0x%x, fmt_change_digital = 0x%x\n",
>>   			__func__, fmt_change, fmt_change_digital);
>>
>> -		v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
>> -				   (void *)&adv76xx_ev_fmt);
>> +		v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
>>
>>   		if (handled)
>>   			*handled = true;
>> @@ -2348,6 +2347,20 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
>>   	return 0;
>>   }
>>
>> +static int adv76xx_subscribe_event(struct v4l2_subdev *sd,
>> +				   struct v4l2_fh *fh,
>> +				   struct v4l2_event_subscription *sub)
>> +{
>> +	switch (sub->type) {
>> +	case V4L2_EVENT_SOURCE_CHANGE:
>> +		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
>> +	case V4L2_EVENT_CTRL:
>> +		return v4l2_event_subdev_unsubscribe(sd, fh, sub);
>
> This should be ..._subscribe(), shouldn't it?

Right, not sure how that happened.

>
> You could simply use v4l2_event_subscribe(fh, sub),
> v4l2_event_subdev_unsubscribe() is there so you can use it directly as the
> subscribe_event() op.

It's just to be on the safe side in case v4l2_event_subdev_subscribe() 
starts to do something in addition to just being a wrapper around 
v4l2_event_subscribe().

Thanks,
- Lars
