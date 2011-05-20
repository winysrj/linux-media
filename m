Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23988 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934962Ab1ETKgG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 06:36:06 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LLH001FYPG4I1@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 May 2011 11:36:04 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LLH00KPSPG3TN@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 May 2011 11:36:03 +0100 (BST)
Date: Fri, 20 May 2011 12:36:02 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH 1/2] v4l: Add generic board subdev registration	function
In-reply-to: <201105201152.17414.hansverk@cisco.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	michael.jones@matrix-vision.de
Message-id: <4DD64412.9010004@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <201105201119.48346.hansverk@cisco.com>
 <201105201137.25556.laurent.pinchart@ideasonboard.com>
 <201105201152.17414.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On 05/20/2011 11:52 AM, Hans Verkuil wrote:
> On Friday, May 20, 2011 11:37:24 Laurent Pinchart wrote:
>> Hi Hans,
>>
>> On Friday 20 May 2011 11:19:48 Hans Verkuil wrote:
>>> On Friday, May 20, 2011 11:05:00 Laurent Pinchart wrote:
>>>> On Friday 20 May 2011 10:53:32 Hans Verkuil wrote:
>>>>> On Friday, May 20, 2011 09:29:32 Laurent Pinchart wrote:
>>>>>> On Friday 20 May 2011 09:14:36 Sylwester Nawrocki wrote:
>>>>>>> On 05/19/2011 08:34 PM, Laurent Pinchart wrote:
>>>>>>>> The new v4l2_new_subdev_board() function creates and register a
>>>>>>>> subdev based on generic board information. The board information
>>>>>>>> structure includes a bus type and bus type-specific information.
>>>>>>>>
>>>>>>>> Only I2C and SPI busses are currently supported.
>>>>>>>>
>>>>>>>> Signed-off-by: Laurent Pinchart
>>>>>>>> <laurent.pinchart@ideasonboard.com>
>>>>
>>>> [snip]
>>>>
>>>>>>> I had an issue when tried to call request_module, to register 
> subdev
>>>>>>> of platform device type, in probe() of other platform device.
>>>>>>> Driver's probe() for devices belonging same bus type cannot be
>>>>>>> nested as the bus lock is taken by the driver core before entering
>>>>>>> probe(), so this would lead to a deadlock.
>>>>>>> That exactly happens in __driver_attach().
>>>>>>>
>>>>>>> For the same reason v4l2_new_subdev_board could not be called from
>>>>>>> probe() of devices belonging to I2C or SPI bus, as request_module
>>>>>>> is called inside of it. I'm not sure how to solve it, yet:)
>>>>>>
>>>>>> Ouch. I wasn't aware of that issue. Looks like it's indeed time to
>>>>>> fix the subdev registration issue, including the module load race
>>>>>> condition. Michael, you said you have a patch to add platform subdev
>>>>>> support, how have you avoided the race condition ?
>>>>>>
>>>>>> I've been thinking for some time now about removing the module load
>>>>>> code completely. I2C, SPI and platform subdevs would be registered
>>>>>> either by board code (possibly through the device tree on platforms
>>>>>> that suppport it) for embedded platforms, and by host drivers for
>>>>>> pluggable hardware (PCI and USB). Module loading would be handled
>>>>>> automatically by the kernel module auto loader, but asynchronously
>>>>>> instead of synchronously. Bus notifiers would then be used by host
>>>>>> drivers to wait for all subdevs to be registered.
>>>>>>
>>>>>> I'm not sure yet if this approach is viable. Hans, I think we've
>>>>>> briefly discussed this (possible quite a long time ago), do you have
>>>>>> any opinion ? Guennadi, based on your previous experience trying to
>>>>>> use bus notifiers to solve the module load race, what do you think
>>>>>> about the idea ? Others, please comment as well :-)
>>>>>
>>>>> It's definitely viable (I believe the required bus notification has
>>>>> been added some time ago), but I am not sure how to implement it in an
>>>>> efficient manner.
>>>>>
>>>>> My initial idea would be to just wait in v4l2_new_subdev_board until
>>>>> you get the notification on the bus (with a timeout, of course).
>>>>> However, I suspect that that does not solve the deadlock, although it
>>>>> would solve the race.
>>>>>
>>>>> As an aside: note that if the module is unloaded right after the
>>>>> request_module, then that will be detected by the code and it will 
> just
>>>>> return an error. It won't oops or anything like that. Personally I
>>>>> don't believe it is worth the effort just to solve this race, since it
>>>>> is highly theoretical.
>>>>>
>>>>> The problem of loading another bus module when in a bus probe function
>>>>> is a separate issue. My initial reaction is: why do you want to do 
> this?
>>>>> Even if you use delayed module loads, you probably still have to wait
>>>>> for them to succeed at a higher-level function. For example: in the
>>>>> probe function of module A it will attempt to load module B. That
>>>>> probably can't succeed as long as you are in A's probe function due to
>>>>> the bus lock. So you can't check for a successful load of B until you
>>>>> return from that probe function and a higher- level function (that
>>>>> likely loaded module A in the first place) does that check.
>>>>>
>>>>> That's all pretty tricky code, and my suggestion would be to simply 
> not
>>>>> do nested module loads from the same bus.
>>>>
>>>> That's unfortunately not an option. Most bridge/host devices in embedded
>>>> systems are platform devices, and they will need to load platform
>>>> subdevs. We need to fix that.
>>>
>>> Good point.
>>>
>>>> My idea was to use bus notifiers to delay the bridge/host device
>>>> initialization. The bridge probe() function would pre-initialize the
>>>> bridge and register notifiers. The driver would then wait until all
>>>> subdevs are properly registered, and then proceed from to register V4L2
>>>> devices from the bus notifier callback (or possible a work queue). There
>>>> would be no nested probe() calls.
>>>
>>> Would it be an option to create a new platform bus for the subdevs? That
>>> would have its own lock. It makes sense from a hierarchical point of view,
>>> but I'm not certain about the amount of work involved.
>>
>> Do you mean a subdev-platform bus for platform subdevs, or a V4L2 subdev bus 
>> for all subdevs ? The first option is possible, but it looks more like a 
> hack 
>> to me. If the subdev really is a platform device, it should be handled by 
> the 
>> platform bus.
> 
> The first. So you have a 'top-level' platform device that wants to load 
> platform subdevs (probably representing internal IP blocks). So it would 
> create its own platform bus that is used to probe those platform subdevs.
> 
> It is similar to e.g. an I2C device that has internal I2C busses: you would
> also create nested busses there.
> 
> BTW, why do these platform subdevs have to be on the platform bus? Why not 
> have standalone subdev drivers that are not on any bus? That's for example 
> what ivtv does for the internal GPIO audio subdev.

Platform devices can have dependencies on their bus drivers. Power/clock domains
can be one of the examples. Mostly host and subdev driver will belong to same
power domain though. There still might be some other side effects from ripping
platform device off from it's bus I'm not aware of right now. 

> 
>> I don't think the second option is possible, I2C and SPI subdevs need to sit 
>> on an I2C or SPI bus (I could be mistaken though, there's at least one 
> example 
>> of a logical bus type in the kernel with the HID bus).
>>
>> Let's also not forget about sub-sub-devices. We need to handle them at some 
>> point as well.
> 
> Sub-sub-devices are not a problem by themselves. They are only a problem if 
> they on the same bus.
> 
>> This being said, I think that the use of platform devices to solve the 
> initial 
>> problem can also be considered a hack as well. What we really need is a way 
> to 
>> handle subdevs that can't be controlled at all (a video source that 
>> continuously delivers data for instance), or that can be controlled through 
>> GPIO. What bus should we use for a bus-less subdev ? And for GPIO-based 
>> subdevs, should we create a GPIO bus ?
> 
> It is perfectly possible to have bus-less subdevs. See ivtv (I think there are 
> one or two other examples as well).
> 

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
