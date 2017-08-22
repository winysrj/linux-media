Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:10961 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932370AbdHVKJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 06:09:29 -0400
Subject: Re: [PATCH v2 1/2] docs-rst: media: Document s_stream() video op
 usage for MC enabled devices
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
References: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
 <1502886018-31488-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170819073552.08a0ea2b@vento.lan>
 <eb59fda5-ce07-22fa-2973-02fe33efc8d4@linux.intel.com>
 <20170821060844.579521a4@vento.lan>
 <17fc3226-9356-cf96-2857-895f1131b23a@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <01290d34-da0e-a089-748f-9d25629ab01c@linux.intel.com>
Date: Tue, 22 Aug 2017 13:09:26 +0300
MIME-Version: 1.0
In-Reply-To: <17fc3226-9356-cf96-2857-895f1131b23a@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 08/21/17 13:14, Hans Verkuil wrote:
...
>>>>> +The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is responsible
>>>>> +for starting and stopping the stream on the sub-device it is called
>>>>> +on. A device driver is only responsible for calling the ``.s_stream()`` ops
>>>>> +of the adjacent sub-devices that are connected to its sink pads
>>>>> +through an enabled link. A driver may not call ``.s_stream()`` op
>>>>> +of any other sub-device further up in the pipeline, for instance.
>>>>> +
>>>>> +This means that a sub-device driver is thus in direct control of
>>>>> +whether the upstream sub-devices start (or stop) streaming before or
>>>>> +after the sub-device itself is set up for streaming.
>>>>> +
>>>>> +.. note::
>>>>> +
>>>>> +   As the ``.s_stream()`` callback is called recursively through the
>>>>> +   sub-devices along the pipeline, it is important to keep the
>>>>> +   recursion as short as possible. To this end, drivers are encouraged
>>>>> +   to avoid recursively calling ``.s_stream()`` internally to reduce
>>>>> +   stack usage. Instead, the ``.s_stream()`` op of the directly
>>>>> +   connected sub-devices should come from the callback through which
>>>>> +   the driver was first called.
>>>>> +  
>>>>
>>>> That sounds too complex, and can lead into troubles, if the same
>>>> sub-device driver is used on completely different devices.
>>>>
>>>> IMHO, it should be up to the main driver to navigate at the MC
>>>> pipeline and call s_stream(), and not to the sub-drivers.  
>>>
>>> I would agree with the above statement *if* we had no devices that 
>>> require doing this in a different way.
>>>
>>> Consider the following case:
>>>
>>> 	sensor   -> CSI-2 receiver -> ISP (DMA)
>>> 	subdev A -> subdev B	   -> video node
>>
>> Let me be clearer about the issue I see.
>>
>> In the above example, what subdevs are supposed to multicast the
>> s_stream() to their neighbors, and how they will know that they
>> need to multicast it.
>>
>> Let's say, that, in the first pipeline, it would be the sensor
>> and subdev A. How "sensor" and "subdev A" will know that they're
>> meant to broadcast s_stream(), and the other entities know they
>> won't?
> 
> So my understanding is that the bridge driver (ISP) will call s_stream
> for the CSI-2 receiver, and that in turn calls s_stream of the sensor.
> 
> This should only be done for mc-centric devices, so we need a clear
> property telling a subdev whether it is part of an mc-centric pipeline
> or a devnode-centric pipeline. Since in the latter case it should not
> call s_stream in this way. For devnode-centric pipelines the bridge
> driver broadcasts s_stream to all subdevs.
> 
> For the record, I am not aware of any subdevs that are used by both
> mc and devnode-centric scenarios AND that can sit in the middle of a
> pipeline. Sensors/video receiver subdevs can certainly be used in both
> scenarios, but they don't have to propagate a s_stream call.
> 
> It would be very helpful if we have a good description of these two
> scenarios in our documentation, and a capability indicating mc-centric
> behavior for devnodes. And also for v4l2-subdevs internally (i.e.
> am I used in a mc-centric scenario or not?).
> 
> Then this documentation will start to make more sense as well.
> 
>> Also, the same sensor may be used on a device whose CSI-2 is
>> integrated at the ISP driver (the main driver). That's why
>> I think that such logic should be started by the main driver, as
>> it is the only part of the pipeline that it is aware about
>> what it is needed. Also, as the DMA engines are controlled by
>> the main driver (via its associated video devnodes), it is the only
>> part of the pipeline that knows when a stream starts.
> 
> Yes, and this driver is the one that calls s_stream on the
> adjacent subdevs. But just those and not all.
> 
>>
>>> Assume that the CSI-2 receiver requires hardware setup both *before and 
>>> after* streaming has been enabled on the sensor.
>>
>> calling s_stream() before and after seems to be an abuse of it.
> 
> I think you misunderstand what Sakari tries to say.
> 
> In the scenario above the bridge driver calls s_stream for the
> CSI receiver. That in turn has code like this:
> 
> s_stream(bool enable)
> {
> 	... initialize CSI ...
> 	if error initializing CSI
> 		return error
> 	call s_stream for adjacent source subdev (i.e. sensor)
> 	if success
> 		return 0
> 	... de-initialize CSI
> 	return error

This isn't really about error handling: error handling can and is being
done by calling s_stream(0) on subdevs on which streaming had already
been started.

There are two purposes:

1) The knowledge whether the the upstream sub-device should start
streaming before or after is ultimately device specific. A driver for
another device may not know that (or without this information being
explicitly conveyed for which we don't have an API).

2) There may be a need to prepare things before streaming is started on
an upstream sub-device as well as proceed with hardware setup *after*
starting streaming on an upstream sub-device. I.e.

	subdev_s_stream(bool enable)
	{
		do some hardware setup;
		call s_stream on a sensor;
		do more hardware setup;
	}

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
