Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-243.synserver.de ([212.40.185.243]:1045 "EHLO
	smtp-out-241.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751882AbbFYKlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 06:41:55 -0400
Message-ID: <558BDAEF.4010009@metafoo.de>
Date: Thu, 25 Jun 2015 12:41:51 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] [media] Add helper function for subdev event notifications
References: <1435164631-19924-1-git-send-email-lars@metafoo.de> <1435164631-19924-3-git-send-email-lars@metafoo.de> <20150625094748.GJ5904@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150625094748.GJ5904@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/25/2015 11:47 AM, Sakari Ailus wrote:
> Hi Lars-Peter,
>
> On Wed, Jun 24, 2015 at 06:50:29PM +0200, Lars-Peter Clausen wrote:
>> Add a new helper function called v4l2_subdev_notify_event() which will
>> deliver the specified event to both the v4l2 subdev event queue as well as
>> to the notify callback. The former is typically used by userspace
>> applications to listen to notification events while the later is used by
>> bridge drivers. Combining both into the same function avoids boilerplate
>> code in subdev drivers.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> ---
>>   drivers/media/v4l2-core/v4l2-subdev.c | 18 ++++++++++++++++++
>>   include/media/v4l2-subdev.h           |  4 ++++
>>   2 files changed, 22 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>> index 6359606..83615b8 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -588,3 +588,21 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>>   #endif
>>   }
>>   EXPORT_SYMBOL(v4l2_subdev_init);
>> +
>> +/**
>> + * v4l2_subdev_notify_event() - Delivers event notification for subdevice
>> + * @sd: The subdev for which to deliver the event
>> + * @ev: The event to deliver
>> + *
>> + * Will deliver the specified event to all userspace event listeners which are
>> + * subscribed to the v42l subdev event queue as well as to the bridge driver
>> + * using the notify callback. The notification type for the notify callback
>> + * will be V4L2_DEVICE_NOTIFY_EVENT.
>> + */
>> +void v4l2_subdev_notify_event(struct v4l2_subdev *sd,
>> +			      const struct v4l2_event *ev)
>> +{
>> +	v4l2_event_queue(sd->devnode, ev);
>> +	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT, (void *)ev);
>
> This is ugly. The casting avoids a warning for passing a const variable as
> non-const.

v4l2_subdev_notify() is a ioctl() style interface, which means you don't get 
type safety for the arg parameter, this includes any modifiers like const. 
Any subscriber to the notify callback needs to be aware that the type for 
the arg parameter for events of type V4L2_DEVICE_NOTIFY_EVENT is const 
struct v4l2_event *.

Having the cast here confined to a single place hides the ugliness from the 
users and you don't have to put the case, like it is right now, into each 
individual driver.

>
> Could v4l2_subdev_notify() be changed to take the third argument as const?

You could, I guess, but you don't really gain anything. The subscriber still 
needs to be aware what the correct type of the arg parameter is for a 
specific event type.

> Alternatively I'd just leave it out from v4l2_subdev_notify_event().

The whole point of the helper function is to have something that does both, 
add the event to the asynchronous event queue as well as call the 
synchronous event callback.

