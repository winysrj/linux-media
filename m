Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:54308 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760380Ab0GSJ1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 05:27:23 -0400
Message-ID: <4C441A41.9050902@maxwell.research.nokia.com>
Date: Mon, 19 Jul 2010 12:26:25 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH 05/10] media: Reference count and power handling
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279114219-27389-6-git-send-email-laurent.pinchart@ideasonboard.com> <201007181347.02995.hverkuil@xs4all.nl>
In-Reply-To: <201007181347.02995.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

And thanks for the comments!

Hans Verkuil wrote:
...
>> +/*
>> + * Apply use count change to an entity and change power state based on
>> + * new use count.
>> + */
>> +static int media_entity_power_apply_one(struct media_entity *entity, int change)
>> +{
>> +	int ret = 0;
>> +
>> +	if (entity->use_count == 0 && change > 0 &&
>> +	    entity->ops && entity->ops->set_power) {
>> +		ret = entity->ops->set_power(entity, 1);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	media_entity_use_apply_one(entity, change);
>> +
>> +	if (entity->use_count == 0 && change < 0 &&
>> +	    entity->ops && entity->ops->set_power)
>> +		ret = entity->ops->set_power(entity, 0);
> 
> Shouldn't this code be executed before the call to media_entity_use_apply_one()?
> Or at least call media_entity_use_apply_one(entity, -change) in case of an
> error? Since it failed to power off the entity it should ensure that the use_count
> remains > 0.

My assumption originally was that powering the device off always
succeeds. Things become interesting if powering off really fails. For
example, the power state is related to open file handles. Do you deny
closing the file handle if the related power state change isn't possible?

It's indeed a good question what should be done in that case. Some
things do go wrong there anyway. I could think of leaving it for drivers
themselves to handle if there's something that can be done.

The power state change for a device can involve an I2C transaction, for
example, which really can fail in practice.

...

>> +static void media_entity_power_disconnect(struct media_entity *one,
>> +					  struct media_entity *theother)
>> +{
>> +	int power_one = media_entity_count_node(one);
>> +	int power_theother = media_entity_count_node(theother);
>> +
>> +	media_entity_power_apply(one, -power_theother);
>> +	media_entity_power_apply(theother, -power_one);
> 
> Needs a comment why the return code is not checked.

Same reason here actually. Agreed on the comment.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
