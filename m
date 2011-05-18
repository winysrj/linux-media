Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11755 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab1ERMGZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 08:06:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LLE00M6Z4ANKJ30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 May 2011 13:06:23 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LLE00FF74AM8P@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 May 2011 13:06:22 +0100 (BST)
Date: Wed, 18 May 2011 14:06:21 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
In-reply-to: <201105160921.29283.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com
Message-id: <4DD3B63D.1060105@samsung.com>
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
 <201105131443.09458.laurent.pinchart@ideasonboard.com>
 <201105141250.33075.hverkuil@xs4all.nl>
 <201105160921.29283.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent, Hans,

On 05/16/2011 09:21 AM, Laurent Pinchart wrote:
> On Saturday 14 May 2011 12:50:32 Hans Verkuil wrote:
>> On Friday, May 13, 2011 14:43:08 Laurent Pinchart wrote:
>>> On Saturday 07 May 2011 13:52:25 Hans Verkuil wrote:
>>>> On Thursday, May 05, 2011 11:39:54 Tomasz Stanislawski wrote:
> 
> [snip]

...
 
>>>>> All cropcap fields except pixel aspect are supported in new API. I
>>>>> noticed that there was discussion about pixel aspect and I am not
>>>>> convinced that it should be a part of the cropping API. Please refer
>>>>> to the post:
>>>>> http://lists-archives.org/video4linux/22837-need-vidioc_cropcap-clari
>>>>> fica tion.html
>>>>
>>>> Yeah, what are we going to do about that? I agree that it does not
>>>> belong here. But we can't sweep it under the carpet either.
>>>>
>>>> The pixel aspect ratio is typically a property of the current input or
>>>> output video format (either a DV preset or a PAL/NTSC STD). For DV
>>>> presets we could add it to struct v4l2_dv_enum_presets and we could do
>>>> the same for STD formats by adding it to struct v4l2_standard.
>>>
>>> Cropping and composing doesn't modify the pixel aspect ratio, so I agree
>>> it doesn't belong there.
>>>
>>>> This would fail for sensors, though, since there the chosen sensor
>>>> framesize is set through S_FMT. (This never quite made sense to me,
>>>> though, from a V4L2 API perspective). I'm not sure whether we can
>>>> always assume 1:1 pixel ratio for sensors. Does anyone know?
>>>
>>> Most of the time I suppose so, but I wouldn't be surprise if some exotic
>>> sensors had non-square pixel aspect ratios.
>>
>> Would it make sense to add the pixel ratio to struct v4l2_frmsizeenum?
>>
>> And what about adding a VIDIOC_G/S_FRAMESIZE to select a sensor resolution?
>>
>> This would typically be one of the discrete framesizes supported by a
>> sensor through binning/skipping. If there is also a scaler on the sensor,
>> then that is controlled through S_FMT. For video it is S_FMT that controls
>> the scaler (together with S_CROP at the moment), but the source resolution
>> is set through S_STD/S_DV_PRESET/S_DV_TIMINGS. It always felt very
>> inconsistent to me that there is no equivalent for sensors, even though
>> you can enumerate all the available framesizes (just as you can with
>> ENUMSTD and ENUM_DV_PRESETS).
> 
> Let's take one step back here.
> 
> We started with the V4L2 device node API to control (more or less) simple 
> devices. Device became more complex, and we created a new MC API (along with 
> the subdev pad-level API) to configure complex pipelines. The V4L2 device node 
> API still lives, and we want to enhance it to configure medium complexity 
> devices.
> 
> Before going much further, I think we need to define what a medium complexity 
> device is and where we put the boundary between devices that can be configured 
> with the V4L2 device node API, and devices that require the MC API.
> 
> I believe this shouldn't be too difficult. What we need to do is create a 
> simple virtual pipeline that supports cropping, scaling and composing, and map 
> the V4L2 device node API to that pipeline configuration. Devices that map to 
> that pipeline could then use the V4L2 device node API only, with clearly 
> defined semantics.

The need to define clearly what's possible to cover with the V4L2 device node
API sounds reasonable. Nevertheless I like Hans' proposal of new 
VIDIOC_G/S_FRAMESIZE ioctls unifying the video capture and tv/dv APIs.
It extends V4L2 API with capability to handle scaling feature which well might
be available in video pipelines that might not want to use MC API at all.

> [snip]
> 
>>>>>   * resolution of an image combined with support for
>>>>>   VIDIOC_S_MULTISELECTION
>>>>>   
>>>>>     allows to pass a triple format/crop/compose sizes in a single
>>>>>     ioctl
>>>>
>>>> I don't believe S_MULTISELECTION will solve anything. Specific
>>>> use-cases perhaps, but not the general problem of setting up a
>>>> pipeline. I feel another brainstorm session coming to solve that. We
>>>> never came to a solution for it in Warsaw.
>>>
>>> Pipelines are configured on subdev nodes, not on video nodes, so I'm also
>>> unsure whether multiselection support would really be useful.
>>>
>>> If we decide to implement multiselection support, we might as well use
>>> that only. We would need a multiselection target bitmask, so selection
>>> targets should all be < 32.
>>>
>>> Thinking some more about it, does it make sense to set both crop and
>>> compose on a single video device node (not talking about mem-to-mem,
>>> where you use the type to multiplex input/output devices on the same
>>> node) ? If so, what would the use cases be ?

I can't think of any, one either use crop or compose.

>>> Should all devices support the selection API, or only the simple ones
>>> that don't expose a user-configurable pipeline to userspace through the
>>> MC API ? The proposed API looks good to me, but before acking it I'd
>>> like to clarify how (if at all) this will interact with subdev pad-level

>>> configuration on devices that support that. My current feeling is that
>>> video device nodes for such devices should only be used for video
>>> streaming. All parameters should be configured directly on the subdevs.
>>> Application might still need to call S_FMT in order to be able to
>>> allocate buffers though.

I'm not sure whether moving all configuration to subdev API for medium
complexity devices which well might have exposed core functionality through
standard V4L2 device node API and still use MC API for pipeline reconfiguration
(in terms of linking entities with each other) is the way to go.

In order to support existing applications SoC-specific libraries would
have to be used in addition to a MC driver ?
Leaving ourselves without support for default configuration that would work
with "old" V4L2 device node API (in connection with common libv4l library) ?

I thought that weren't the prerequisites when designing the MC API.
I'm afraid we'll end up with two distinct APIs in Video4Linux and thus
two sets of drivers and applications that will not work with one another.

>>
>> This comes back to how we want to implement backwards compatibility for
>> existing applications. There must be a way for 'standard' apps to work
>> with complex drivers for specific video nodes (the mc would probably mark
>> those as a 'DEFAULT' node).
>>
>> I'd say that there are roughly two options: either implement the selection
>> etc. APIs for those video nodes only in the driver, letting the driver set
>> up the subdev pipeline, or do it via libv4l SoC-specific plugins.


>>
>> In my opinion we need to finish the pipeline configuration topic we started
>> in Warsaw before we can finalize this RFC. This RFC clearly demonstrates
>> that we have inconsistencies and deficiencies in our API that need to be
>> solved first. When we have done that, then I expect that this selection
>> API will be easy to finalize.
> 

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
