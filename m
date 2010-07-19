Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1545 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760385Ab0GSJ4D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 05:56:03 -0400
Message-ID: <cf2ca57033486758e0b039ce4c133a3e.squirrel@webmail.xs4all.nl>
In-Reply-To: <4C441A41.9050902@maxwell.research.nokia.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1279114219-27389-6-git-send-email-laurent.pinchart@ideasonboard.com>
    <201007181347.02995.hverkuil@xs4all.nl>
    <4C441A41.9050902@maxwell.research.nokia.com>
Date: Mon, 19 Jul 2010 11:55:59 +0200
Subject: Re: [RFC/PATCH 05/10] media: Reference count and power handling
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans,
>
> And thanks for the comments!
>
> Hans Verkuil wrote:
> ...
>>> +/*
>>> + * Apply use count change to an entity and change power state based on
>>> + * new use count.
>>> + */
>>> +static int media_entity_power_apply_one(struct media_entity *entity,
>>> int change)
>>> +{
>>> +	int ret = 0;
>>> +
>>> +	if (entity->use_count == 0 && change > 0 &&
>>> +	    entity->ops && entity->ops->set_power) {
>>> +		ret = entity->ops->set_power(entity, 1);
>>> +		if (ret)
>>> +			return ret;
>>> +	}
>>> +
>>> +	media_entity_use_apply_one(entity, change);
>>> +
>>> +	if (entity->use_count == 0 && change < 0 &&
>>> +	    entity->ops && entity->ops->set_power)
>>> +		ret = entity->ops->set_power(entity, 0);
>>
>> Shouldn't this code be executed before the call to
>> media_entity_use_apply_one()?
>> Or at least call media_entity_use_apply_one(entity, -change) in case of
>> an
>> error? Since it failed to power off the entity it should ensure that the
>> use_count
>> remains > 0.
>
> My assumption originally was that powering the device off always
> succeeds. Things become interesting if powering off really fails. For
> example, the power state is related to open file handles. Do you deny
> closing the file handle if the related power state change isn't possible?
>
> It's indeed a good question what should be done in that case. Some
> things do go wrong there anyway. I could think of leaving it for drivers
> themselves to handle if there's something that can be done.
>
> The power state change for a device can involve an I2C transaction, for
> example, which really can fail in practice.

There are two issue here: my comment above was limited to the fact that as
far as I can see the use_count will be off by one if the power off fails.
That should be fixed.

The other issue is what to do when power off fails. There are a few
possible schemes:

1) Just power off everything, ignoring any failures (although they should
be reported in the kernel log). Probably what you want in practice.
2) Revert to the previous state (that's what happening in your code).
Sounds nice, but what do you do next?
3) Add a boolean to choose whether to forcefully power off everything
(i.e. case 1), or report an error and restore the state (case 2).

Frankly, I'm in favor of the simple solution: case 1. When you get i2c
errors when powering off you are probably experiencing lots of other
problems as well.

Regards,

          Hans

>
> ...
>
>>> +static void media_entity_power_disconnect(struct media_entity *one,
>>> +					  struct media_entity *theother)
>>> +{
>>> +	int power_one = media_entity_count_node(one);
>>> +	int power_theother = media_entity_count_node(theother);
>>> +
>>> +	media_entity_power_apply(one, -power_theother);
>>> +	media_entity_power_apply(theother, -power_one);
>>
>> Needs a comment why the return code is not checked.
>
> Same reason here actually. Agreed on the comment.
>
> Regards,
>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

