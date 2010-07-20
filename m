Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44278 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab0GTOrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 10:47:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC/PATCH 05/10] media: Reference count and power handling
Date: Tue, 20 Jul 2010 16:47:13 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com> <cf2ca57033486758e0b039ce4c133a3e.squirrel@webmail.xs4all.nl> <4C443501.4030401@maxwell.research.nokia.com>
In-Reply-To: <4C443501.4030401@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007201647.14002.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 19 July 2010 13:20:33 Sakari Ailus wrote:
> Hans Verkuil wrote:
> >>>> +/*
> >>>> + * Apply use count change to an entity and change power state based
> >>>> on + * new use count.
> >>>> + */
> >>>> +static int media_entity_power_apply_one(struct media_entity *entity,
> >>>> int change)
> >>>> +{
> >>>> +	int ret = 0;
> >>>> +
> >>>> +	if (entity->use_count == 0 && change > 0 &&
> >>>> +	    entity->ops && entity->ops->set_power) {
> >>>> +		ret = entity->ops->set_power(entity, 1);
> >>>> +		if (ret)
> >>>> +			return ret;
> >>>> +	}
> >>>> +
> >>>> +	media_entity_use_apply_one(entity, change);
> >>>> +
> >>>> +	if (entity->use_count == 0 && change < 0 &&
> >>>> +	    entity->ops && entity->ops->set_power)
> >>>> +		ret = entity->ops->set_power(entity, 0);
> >>> 
> >>> Shouldn't this code be executed before the call to
> >>> media_entity_use_apply_one()?
> >>> Or at least call media_entity_use_apply_one(entity, -change) in case of
> >>> an error? Since it failed to power off the entity it should ensure that
> >>> the use_count remains > 0.
> 
> Forgot to answer this one.
> 
> The first entity->ops->set_power() is called to power on the device.
> This will be done when the use_count was 0 and change is positive, i.e.
> we're asked to power on the entity. The actual use count is not changed
> in case of a failure.
> 
> The latter entity->ops->set_power() is called to power the device off.
> media_entity_use_apply_one() is called first to apply the change since
> the change isn't necessarily -1 or 1.The change was already applied to
> the entity->use_count that's why the comparison against 0. And the
> change was negative, i.e. the device is to be powered off.
> 
> So I don't think there's an error in use_count calculation. But the
> second set_power() to power the device off shouldn't set ret at all and
> the function should return zero at the end.
> 
> Then I think it'd be correct. Things can currently go wrong when
> media_entity_power_apply() is called from
> media_entity_node_power_change() with a negative change.

To summarize the discussion, what should I change here ? Just remove the "ret 
= " in the second set_power call ?

-- 
Regards,

Laurent Pinchart
