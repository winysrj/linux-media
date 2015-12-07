Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41206 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136AbbLGPRZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 10:17:25 -0500
Subject: Re: [PATCH v8 18/55] [media] omap3isp: create links after all subdevs
 have been bound
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
 <20150909080333.GL3175@valkosipuli.retiisi.org.uk>
 <55EFF25D.5010905@osg.samsung.com> <2092688.POBCcC9dJr@avalon>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5665A2FD.8010308@osg.samsung.com>
Date: Mon, 7 Dec 2015 12:17:17 -0300
MIME-Version: 1.0
In-Reply-To: <2092688.POBCcC9dJr@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 12/06/2015 12:05 AM, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thank you for the patch.
> 
> On Wednesday 09 September 2015 10:48:29 Javier Martinez Canillas wrote:
>> On 09/09/2015 10:03 AM, Sakari Ailus wrote:
>>> On Sun, Aug 30, 2015 at 12:06:29AM -0300, Mauro Carvalho Chehab wrote:
>>>> From: Javier Martinez Canillas <javier@osg.samsung.com>
>>>>
>>>> The omap3isp driver parses the graph endpoints to know how many
>>>> subdevices needs to be registered async and register notifiers callbacks
>>>> for to know when these are bound and when the async registrations are
>>>> completed.
>>>>
>>>> Currently the entities pad are linked with the correct ISP input
>>>> interface when the subdevs are bound but it happens before entitities are
>>>> registered with the media device so that won't work now that the entity
>>>> links list is initialized on device registration.
>>>>
>>>> So instead creating the pad links when the subdevice is bound, create
>>>> them on the complete callback once all the subdevices have been bound but
>>>> only try to create for the ones that have a bus configuration set during
>>>> bound.
>>>>
>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>
>>>> diff --git a/drivers/media/platform/omap3isp/isp.c
>>>> b/drivers/media/platform/omap3isp/isp.c index b8f6f81d2db2..69e7733d36cd
>>>> 100644
>>>> --- a/drivers/media/platform/omap3isp/isp.c
>>>> +++ b/drivers/media/platform/omap3isp/isp.c
>>>> @@ -2321,26 +2321,33 @@ static int isp_subdev_notifier_bound(struct
>>>> v4l2_async_notifier *async,
>>>>  				     struct v4l2_subdev *subdev,
>>>>  				     struct v4l2_async_subdev *asd)
>>>>  {
>>>> -	struct isp_device *isp = container_of(async, struct isp_device,
>>>> -					      notifier);
>>>>  	struct isp_async_subdev *isd =
>>>>  		container_of(asd, struct isp_async_subdev, asd);
>>>> -	int ret;
>>>> -
>>>> -	ret = isp_link_entity(isp, &subdev->entity, isd->bus.interface);
>>>> -	if (ret < 0)
>>>> -		return ret;
>>>>
>>>>  	isd->sd = subdev;
>>>>  	isd->sd->host_priv = &isd->bus;
>>>>
>>>> -	return ret;
>>>> +	return 0;
>>>>  }
>>>>  
>>>>  static int isp_subdev_notifier_complete(struct v4l2_async_notifier
>>>>  *async)
>>>>  {
>>>>  	struct isp_device *isp = container_of(async, struct isp_device,
>>>>  					      notifier);
>>>> +	struct v4l2_device *v4l2_dev = &isp->v4l2_dev;
>>>> +	struct v4l2_subdev *sd;
>>>> +	struct isp_bus_cfg *bus;
>>>> +	int ret;
>>>> +
>>>> +	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
>>>> +		/* Only try to link entities whose interface was set on bound */
>>>> +		if (sd->host_priv) {
>>>> +			bus = (struct isp_bus_cfg *)sd->host_priv;
>>>> +			ret = isp_link_entity(isp, &sd->entity, bus->interface);
>>>> +			if (ret < 0)
>>>> +				return ret;
>>>> +		}
>>>> +	}
>>>>  	return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
>>>>  }
>>>
>>> I think you're working around a problem here, not really fixing it.
>>>
>>> This change will create the links only after the media device is
>>> registered, which means the user may obtain a partial enumeration of
>>> links if the enumeration is performed too early.
>>>
>>> Before this set, the problem also was that the media device was registered
>>> before the async entities were bound, again making it possible to obtain a
>>> partial enumeration of entities.
>>
>> You are absolutely correct but I think these are separate issues. The
>> problem here is that v4l2_async_test_notify() [0] first invokes the bound
>> notifier callback and then calls v4l2_device_register_subdev() that
>> register the media entity with the media device.
>>
>> Since now is a requirement that the entities must be registered prior
>> creating pads links (because to init a MEDIA_GRAPH_LINK object a mdev has
>> to be set), $SUBJECT is needed regardless of the race between subdev
>> registration and the media dev node being available to user-space before
>> everything is registered.
>>> What I'd suggest instead is that we split media device initialisation and
>>> registration to the system; that way the media device can be prepared
>>> (entities registered and links created) before it becomes visible to the
>>> user space. I can write a patch for that if you like.
>>
>> Agreed, looking at the implementation it seems that
>> __media_device_register() has to be split (possibly being renamed to
>> __media_device_init) so it only contains the initialization logic and all
>> the media device node registration logic moved to another function (that
>> would become media_device_register).
>>
>> I think the media dev node registration has to be made in the complete
>> callback to make sure that happens when all the subdevs have been already
>> registered.
>>
>> Is that what you had in mind? I can also write such a patch if you want.
> 
> I think I've already commented on it in my review of another patch (but can't 
> find it right now), I agree with you. We need to properly think about 

I'm glad that you agree, could you please review the v4 of patch series
"Fix race between graph enumeration and entities registration" [0] that
I posted a while ago?

> initialization (and, for that matter, cleanup as well) order, both for the 
> media device and the entities. And, as a corollary, for subdevs too. The
> current media entity and subdevs initialization and registration code grew in 
> an organic way without much design behind it, let's not repeat the same 
> mistake.
> 

Agreed, and this should be properly documented so driver authors can follow.

[0]: https://lkml.org/lkml/2015/9/15/371

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
