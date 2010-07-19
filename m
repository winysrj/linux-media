Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63166 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760557Ab0GSLUq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 07:20:46 -0400
Message-ID: <4C443501.4030401@maxwell.research.nokia.com>
Date: Mon, 19 Jul 2010 14:20:33 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH 05/10] media: Reference count and power handling
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>    <1279114219-27389-6-git-send-email-laurent.pinchart@ideasonboard.com>    <201007181347.02995.hverkuil@xs4all.nl>    <4C441A41.9050902@maxwell.research.nokia.com> <cf2ca57033486758e0b039ce4c133a3e.squirrel@webmail.xs4all.nl>
In-Reply-To: <cf2ca57033486758e0b039ce4c133a3e.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> 
>> Hi Hans,
>>
>> And thanks for the comments!
>>
>> Hans Verkuil wrote:
>> ...
>>>> +/*
>>>> + * Apply use count change to an entity and change power state based on
>>>> + * new use count.
>>>> + */
>>>> +static int media_entity_power_apply_one(struct media_entity *entity,
>>>> int change)
>>>> +{
>>>> +	int ret = 0;
>>>> +
>>>> +	if (entity->use_count == 0 && change > 0 &&
>>>> +	    entity->ops && entity->ops->set_power) {
>>>> +		ret = entity->ops->set_power(entity, 1);
>>>> +		if (ret)
>>>> +			return ret;
>>>> +	}
>>>> +
>>>> +	media_entity_use_apply_one(entity, change);
>>>> +
>>>> +	if (entity->use_count == 0 && change < 0 &&
>>>> +	    entity->ops && entity->ops->set_power)
>>>> +		ret = entity->ops->set_power(entity, 0);
>>>
>>> Shouldn't this code be executed before the call to
>>> media_entity_use_apply_one()?
>>> Or at least call media_entity_use_apply_one(entity, -change) in case of
>>> an
>>> error? Since it failed to power off the entity it should ensure that the
>>> use_count
>>> remains > 0.

Forgot to answer this one.

The first entity->ops->set_power() is called to power on the device.
This will be done when the use_count was 0 and change is positive, i.e.
we're asked to power on the entity. The actual use count is not changed
in case of a failure.

The latter entity->ops->set_power() is called to power the device off.
media_entity_use_apply_one() is called first to apply the change since
the change isn't necessarily -1 or 1.The change was already applied to
the entity->use_count that's why the comparison against 0. And the
change was negative, i.e. the device is to be powered off.

So I don't think there's an error in use_count calculation. But the
second set_power() to power the device off shouldn't set ret at all and
the function should return zero at the end.

Then I think it'd be correct. Things can currently go wrong when
media_entity_power_apply() is called from
media_entity_node_power_change() with a negative change.

>>
>> My assumption originally was that powering the device off always
>> succeeds. Things become interesting if powering off really fails. For
>> example, the power state is related to open file handles. Do you deny
>> closing the file handle if the related power state change isn't possible?
>>
>> It's indeed a good question what should be done in that case. Some
>> things do go wrong there anyway. I could think of leaving it for drivers
>> themselves to handle if there's something that can be done.
>>
>> The power state change for a device can involve an I2C transaction, for
>> example, which really can fail in practice.
> 
> There are two issue here: my comment above was limited to the fact that as
> far as I can see the use_count will be off by one if the power off fails.
> That should be fixed.
>
> The other issue is what to do when power off fails. There are a few
> possible schemes:
> 
> 1) Just power off everything, ignoring any failures (although they should
> be reported in the kernel log). Probably what you want in practice.
> 2) Revert to the previous state (that's what happening in your code).
> Sounds nice, but what do you do next?

In one case, yes, as far as I can see, entities could have been powered
on again as a result of a failed power off. But that's a bug. :-)

> 3) Add a boolean to choose whether to forcefully power off everything
> (i.e. case 1), or report an error and restore the state (case 2).
> 
> Frankly, I'm in favor of the simple solution: case 1. When you get i2c
> errors when powering off you are probably experiencing lots of other
> problems as well.

I fully agree.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
