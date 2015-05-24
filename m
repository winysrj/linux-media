Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:60681 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbbEXWna (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2015 18:43:30 -0400
Message-ID: <5562540D.5090106@xs4all.nl>
Date: Mon, 25 May 2015 00:43:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	sergei.shtylyov@cogentembedded.com, rob.taylor@codethink.co.uk
Subject: Re: [PATCH 08/20] media: soc_camera pad-aware driver initialisation
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <2679646.jJocfX2rY2@avalon> <556186EF.9010306@xs4all.nl> <1930195.jDtoRqGTcH@avalon>
In-Reply-To: <1930195.jDtoRqGTcH@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2015 11:50 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Sunday 24 May 2015 10:08:15 Hans Verkuil wrote:
>> On 05/23/2015 08:32 PM, Laurent Pinchart wrote:
>>> On Thursday 21 May 2015 07:55:10 Hans Verkuil wrote:
>>>> On 05/20/2015 06:39 PM, William Towle wrote:
>>>>> Add detection of source pad number for drivers aware of the media
>>>>> controller API, so that soc_camera/rcar_vin can create device nodes
>>>>> to support a driver such as adv7604.c (for HDMI on Lager) underneath.
>>>>>
>>>>> Signed-off-by: William Towle <william.towle@codethink.co.uk>
>>>>> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
>>>>> ---
>>>>>
>>>>>  drivers/media/platform/soc_camera/rcar_vin.c   |    4 ++++
>>>>>  drivers/media/platform/soc_camera/soc_camera.c |   27 ++++++++++++++++-
>>>>>  include/media/soc_camera.h                     |    1 +
>>>>>  3 files changed, 31 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
>>>>> b/drivers/media/platform/soc_camera/rcar_vin.c index 0f67646..b4e9b43
>>>>> 100644
>>>>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>>>>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>>>>> @@ -1364,8 +1364,12 @@ static int rcar_vin_get_formats(struct
>>>>> soc_camera_device *icd, unsigned int idx,
>>>>>  		struct v4l2_mbus_framefmt *mf = &fmt.format;
>>>>>  		struct v4l2_rect rect;
>>>>>  		struct device *dev = icd->parent;
>>>>> +		struct media_pad *remote_pad;
>>>>>  		int shift;
>>>>>
>>>>> +		remote_pad = media_entity_remote_pad(
>>>>> +					&icd->vdev->entity.pads[0]);
>>>>> +		fmt.pad = remote_pad->index;
>>>>
>>>> This won't work if CONFIG_MEDIA_CONTROLLER isn't defined. All these media
>>>> calls would all have to be under #ifdef CONFIG_MEDIA_CONTROLLER.
>>>>
>>>> Unfortunately, if it is not defined, then you still have no way of
>>>> finding the source pad.
>>>>
>>>> Laurent, do you think if it would make sense to add a new subdev core op
>>>> that will return the default source pad (I'm saying 'default' in case
>>>> there are more) of a subdev? That way it can be used in non-MC drivers.
>>>> We never needed the source pad before, but now we do, and this op only
>>>> needs to be implemented if the default source pad != 0.
>>>
>>> I'm not too fond of that. Is there something wrong with the method
>>> implemented in this patch ? Is the dependency on CONFIG_MEDIA_CONTROLLER
>>> an issue ?
>>
>> 1) it's a heck of a lot of code just to get a simple source pad that the
>> subdev knows anyway,
> 
> I don't think the subdev knows. If a subdev has multiple source pads there's 
> no concept of a default source. It all depends on how the subdevs are 
> connected, and media_entity_remote_pad() is the right way to find out.

Note that with 'source pad' I am referring to the output pad of a subdev
(ADV7604_PAD_SOURCE in the case of the adv7604). There may be some confusion
here.

In my experience subdevs in a capture path have usually multiple input (sink)
pads, but only one output (source) pad. Subdevs in a video output path tend to
have one input (sink) pad and multiple output (source) pads.

The multiple inputs/outputs are things like composite, S-Video, HDMI, VGA, etc.
and the single input/output pad is where the device is hooked up to the mediabus
which in turn connects to a DMA engine.

>> 2) soc-camera doesn't use the media controller today, so this would add a
>> dependency on the mc just for this,
> 
> I agree that we shouldn't pull the whole MC userspace API in just for this, 
> but the kernel side of the API should be available as pad-level operations 
> depend on MC. We could split the CONFIG_MEDIA_CONTROLLER option in two.

The way it is now is pretty OK. We just miss the information about the pad
that feeds the dma capture path and for output we miss the the pad that is fed
by the dma output path.

Bridge drivers currently just assume pad 0 in all cases, but that's obviously
not always right as the adv7604 illustrates.

The alternative would be to just hardcode it in platform data or card information.
What this patch does is just enumerating pads until it finds the first one that
fits the criteria, which fails as well if there are multiple pads that would
match and is a lot more code than just have the subdev provide the information.

Regards,

	Hans

>> 3) it doesn't actually make a media device, it is just fakes enough to make
>> the subdev think it there is an MC.
>>
>> It doesn't actually have to be a new op, it could be a new field in
>> v4l2_subdev as well. For those bridge drivers that do not use the MC but do
>> need to know the source pad this is important information.
>>
>> It might even simplify the device tree if the default source pad is implied
>> unless stated otherwise (but that might be a step too far).
>>
>> I wonder if a default input pad might also be useful to expose. I suspect
>> this might become important if we want to add MC support to all existing
>> v4l2 drivers.
> 
> The concept of a default sink pad makes more sense, but I'm not sure I like it 
> too much either. I'd have to think about it.
> 

