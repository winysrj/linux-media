Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52726 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab1ESPwJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 11:52:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LLG009IR9EVZWA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 May 2011 16:52:07 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLG00H859EU58@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 May 2011 16:52:07 +0100 (BST)
Date: Thu, 19 May 2011 17:50:39 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
In-reply-to: <4DD3FA17.6090705@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@maxwell.research.nokia.com
Message-id: <4DD53C4F.70505@samsung.com>
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
 <201105131443.09458.laurent.pinchart@ideasonboard.com>
 <201105141250.33075.hverkuil@xs4all.nl>
 <201105160921.29283.laurent.pinchart@ideasonboard.com>
 <4DD3FA17.6090705@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Tomasz Stanislawski wrote:
> Laurent Pinchart wrote:
>> On Saturday 14 May 2011 12:50:32 Hans Verkuil wrote:
>>> On Friday, May 13, 2011 14:43:08 Laurent Pinchart wrote:
>>>> On Saturday 07 May 2011 13:52:25 Hans Verkuil wrote:
>>>>> On Thursday, May 05, 2011 11:39:54 Tomasz Stanislawski wrote:
> Hi Laurent and Hans,
> I am very sorry for replying so lately. I was really busy during last 
> week. Thank you very much for your interest and comments :).
>>
>> [snip]
>>
> >> -----------------------------------------------------------------
> >>>>>
> >>>>> Name
> >>>>>
> >>>>>     VIDIOC_S_SELECTION - set cropping rectangle on an input of a 
> device
>
> [snip]
>
> >>>>> v4l2-selection::r is filled with suggested coordinates. The 
> coordinates
> >>>>> are expressed in driver-dependant units.
> >
> > What kind of driver-dependant units do you think will be used in 
> practice ?
>
> In a case of sensors, units could be subpixels. For analog TV inputs, 
> units may be milliseconds. For printers/scanner, units may be 
> centimeters.
> I think that there are many other examples out there.
>
>>>>>> Applications set V4L2_SEL_TRY flag in v4l2_selection::flags to
>>>>>> prevent a driver from applying selection configuration to hardware.
>>>>> I mentioned this before but I am very much opposed to this flag. 
>>>>> It is
>>>>> inconsistent with the TRY_FMT and TRY_EXT_CTRLS ioctls. Note that in
>>>>> video_ioctl2 it should be just one function with 'try' boolean
>>>>> argument. It has always been a mistake that the try and set functions
>>>>> were separated in the driver code IMHO.
>>>>>
>>>>> I know that the subdev ioctls do not have a try version, but it is 
>>>>> not
>>>>> quite the same in that those try functions actually store the try
>>>>> information.
>>>> That's exactly why the subdevs pad-level API has a try flag instead 
>>>> of a
>>>> try operation, and that's why g/s_selection on subdevs will be done 
>>>> with
>>>> a try flag.
>>>>
>>>> As for the video device node API, I won't oppose a TRY ioctl, as 
>>>> long as
>>>> we can guarantee there will never be dependencies between the 
>>>> selection
>>>> rectangles and other parameters (or between the different selection
>>>> rectangles). If the crop rectangle depends on the compose rectangle 
>>>> for
>>>> instance, how can you implement a TRY ioctl to try a crop rectangle 
>>>> for
>>>> a specific compose rectangle, without modifying the active compose
>>>> rectangle first ?
>>> In that case the TRY would adjust the crop so that it works with the
>>> current compose rectangle.
>>
>> And how do you try both crop and compose settings without modifying 
>> the active configuration ? That's not possible, and I think it's a 
>> bad API limitation.
>
> VIDIOC_TRY_MULTISELECTION ?
>
>>
>>> But this is just one more example of our lack of proper support for 
>>> pipeline
>>> setup. It doesn't really matter whether this is at the subdev level 
>>> or at
>>> the driver level, both have the same problems.
>>>
>>> This requires a brainstorm session to work out.
>>>
>>>>> This is something we need to look into more carefully. I am slowly
>>>>> becoming convinced that we need some sort of transaction-based
>>>>> configuration for pipelines.
>>>> This RFC is about video device node configuration, not pipelines. For
>>>> pipelines I think we'll need a transaction-based API. For video device
>>>> nodes, I'm still unsure. As stated above, if we have multiple 
>>>> parameters
>>>> that depend on each other, how do we let the user try them without
>>>> changing the active configuration ?
>>> Cropping/scaling/composing IS a pipeline. Until recently the V4L2 
>>> device
>>> node API was sufficient to setup the trivial pipelines that most V4L2
>>> consumer devices have. But with the more modern devices it starts to 
>>> show
>>> its limitations.
>>
>> It's still a simple pipeline, and I think we should aim at making the 
>> V4L2 device node API useful to configure this kind of pipeline. The 
>> selection API is a superset of the crop API, applications should be 
>> able to use it to replace the crop API in the long term.
>>
>>> The whole 'try' concept we had for a long time needs to be re-examined.
>>
>> I agree.
>>
>>> As you remember, I was never satisfied with the subdev 'try' approach
>>> either, but I never could come up with a better alternative.
>>>
> I've noticed that there are two different meaning of TRY flag
> a) checking if a proposed configuration is applicable for a driver
> b) storing proposed configuration in some form of temporary buffer
>
> Ad. a. This is a real TRY command. The state of both hardware and 
> driver does not change after TRY call.
>
> Ad. b. It should be called not TRY flag because the internal state of 
> a driver changes. It should be named as something like SHADOW flag. It 
> would indicate that the change is applied only to shadow configuration.
>
> I propose to change name of TRY flag for subdev to SHADOW flag. I 
> think it would much clear to express the difference of TRY meaning in 
> video node and subdev contexts.
>
> Therefore ioctl VIDIOC_TRY_SELECTION is probably better and more 
> convenient way of testing if configuration is applicable.
>
>>>>> Regardless of how such a scheme should work, one thing that I believe
>>>>> is missing in the format ioctls (both on the video and subdev level)
>>>>> is a similar concept like the flags in this proposal. It would be
>>>>> quite useful if you could indicate that the desired WxH has to be
>>>>> exact or can be larger or smaller. It would certainly simplify the
>>>>> interaction between the selection and scaling.
>>>>>
>>>>>> On success field v4l2_selection::r is filled with adjusted 
>>>>>> rectangle.
>>>>>>
>>>>>> Return value
>>>>>>
>>>>>>     On success 0 is returned, on error -1 and the errno variable 
>>>>>> is set
>>>>>>     
>>>>>>         appropriately:
>>>>>>     EINVAL - incorrect buffer type, incorrect/not supported target
>>>>>>
>>>>>> 4. Flags
>>>>>> 4.1. Hints
>>>>>>
>>>>>> The field v4l2_selection::flags is used to give a driver a hint 
>>>>>> about
>>>>>> coordinate adjustments. The set of possible hint flags was 
>>>>>> reduced to
>>>>>> two entities for practical reasons. The flag V4L2_SEL_SIZE_LE is a
>>>>>> suggestion for the driver to decrease or keep size of a 
>>>>>> rectangle. The flags V4L2_SEL_SIZE_GE imply keeping or increasing 
>>>>>> a size of a
>>>>>> rectangle.
>>>>>>
>>>>>> By default, lack of any hint flags indicate that driver has to 
>>>>>> choose
>>>>>> selection coordinates as close as possible to the ones passed in
>>>>>> v4l2_selection::r field.
>>>>>>
>>>>>> Setting both flags implies that the driver is free to adjust the
>>>>>> rectangle.  It may return even random one however much more
>>>>>> encouraged behaviour would be adjusting coordinates in such a way
>>>>>> that other stream parameters are left intact. This means that the
>>>>>> driver should avoid changing a format of an image buffer and/or any
>>>>>> other controls.
>>>>> This makes no sense to me. It sounds like this is what flags == 0
>>>>> should do.
>>>>>
>>>>> I would expect that if both flags are specified that that would equal
>>>>> SEL_SIZE_EQ. I.E., the rectangle has to be exact size-wise, and 
>>>>> should
>>>>> be as close as possible to the original position.
>>>> What happens if that's not possible ? The ioctl should never return an
>>>> error,
>>> Why not? If I tell the driver that I want exactly WxH, then I see no 
>>> reason
>>> why it can't return an error. An application might use that result to
>>> switch to a different resolution, for example. E.g., the application 
>>> tries
>>> 640x480 first, that fails, then it tries 320x240 (or whatever).
>>
>> To make the API more consistent. Applications ask drivers for 
>> specific settings (including optional hints), and drivers return what 
>> they've been able to configure. It's then the application's 
>> responsibility to check the return values and act upon it. Drivers 
>> shouldn't return an error when setting formats/selections, except if 
>> the given arguments can't be understood.
> Hmm.. I see two solutions:
>
> Solution I (more restrictive):
> 0 - driver is free to adjust size, it is recommended to choose the 
> crop/compose rectangle as close as possible to desired one
>
> SEL_SIZE_GE - drive is not allowed to shrink the rectangle. If no such 
> a rectangle exists ERANGE is returned (EINVAL is used for 
> not-understandable configuration)
>
> SEL_SIZE_LE - drive is not allowed to grow the rectangle. If no such a 
> rectangle exists ERANGE is returned (EINVAL is used for 
> not-understandable configuration)
>
> SEL_SIZE_EQ = SEL_SIZE_GE | SEL_SIZE_LE - choose size exactly the same 
> as in desired rectangle. Return ERANGE if such a configuration is not 
> possible.
>
> -----------------------------------------
>
> Solution II (less restrictive). Proposed in this RFC.
>
> 0 - apply rectangle as close as possible to desired one like the 
> default behavior of  VIDIOC_S_CROP.
>
> SEL_SIZE_GE - suggestion to increase or keep size of both coordinates
>
> SEL_SIZE_LE - suggestion to decrease or keep size of both coordinates
>
> SEL_SIZE_GE | SEL_SIZE_LE - technically suggestion to "increase or 
> keep or decrease" sizes. Basically, it means that driver is completely 
> free to choose coordinates. It works like saying "give me a crop 
> similar to this one" to the driver. I agree that it is not "a very 
> useful" combination of flags.
>
> In both solutions, the driver is recommended to keep the center of the 
> rectangle in the same place.
>
> Personally, I prefer 'solution I' because it is more logical one.
> One day, the SEL_SIZE_GE could be expanded to LEFT_LE | RIGHT_GE | 
> TOP_LE | BOTTOM_GE flags if drivers could support it.
On a second thought, the 'solution I' could be used in subdevs because 
gives a better control over hardware.
'Solution II' suits better to video nodes. I mean applications that use 
V4L for very simple purposes.
The 'solution II' is less restrictive therefore it is easier to 
implement in a driver.

However, I made a little social experiment and I asked few developers in 
my team which API they would like to use.
They preferred 'solution I' because it is logical and deterministic.

Moreover, an application that use these flags is aware that introduction 
of constraints may cause a failure.
Anyway, the application can always withdraw explicitly to using 
S_SELECTION without any flags.

BTW.. what do you think about changing the flags names from 
SE_SIZE_LE/SEL_SIZE_GE to SEL_INSIDE/SEL_OUTSIDE?
New name better describe the flags' purpose.
For the first solution the 'hint flags' should be renamed to 'constraint 
flags', too.

Bye
Tomasz Stanislawski
>
> [snip]
>
> >>> One thing I think would be helpful though, is if the target name 
> would tell
> >>> you whether it is a read-only or a read-write target. It might 
> also be
> >>> helpful if the IDs of the read-only targets would set some 
> read-only bit.
> >>> That would make it easy for video_ioctl2 to test for invalid 
> targets for
> >>> S_SELECTION.
> >>>
> >>> Not sure about the naming though:
> >>>
> >>> V4L2_SEL_RO_CROP_DEFAULT
> >>> V4L2_SEL_CROP_RO_DEFAULT
> >>> V4L2_SEL_CROP_DEFAULT_RO
> >>>
> >>> None looks right. A read-only bit might be sufficient as it would 
> clearly
> >>> indicate in the header that that target is a read-only target.
> >> What if some future hardware have setable default or bounds 
> rectangles ? I
> >> don't know what that would be used for, it's just in case :-)
> >
> > If it is settable, then it is no longer a default or bounds 
> rectangle but
> > some other rectangle :-)
> >
>
> I agree with Laurent. Both bounds and defrect are not exactly read-only.
> They could be modified by S_FMT, S_STD/S_DV_PRESET ioctl.
> The DEFRECT can change after switching aspect ratio on TV output.
>
> If cropping is not supported setting ACTIVE target returns EINVAL, 
> because this target is read-only in this context.
> Change of ACTIVE target might be also impossible because hardware is 
> in streaming state.
>
> Basically, ant target could be Read-only because of some reason.
>
> Therefore I see no reason to break symmetry between 
> active/bound/defrect/? by adding RO {pre/suff}ix.
>
> [snip]
>
>>>>>> All cropcap fields except pixel aspect are supported in new API. I
>>>>>> noticed that there was discussion about pixel aspect and I am not
>>>>>> convinced that it should be a part of the cropping API. Please refer
>>>>>> to the post:
>>>>>> http://lists-archives.org/video4linux/22837-need-vidioc_cropcap-clari 
>>>>>>
>>>>>> fica tion.html
>>>>> Yeah, what are we going to do about that? I agree that it does not
>>>>> belong here. But we can't sweep it under the carpet either.
>>>>>
>>>>> The pixel aspect ratio is typically a property of the current 
>>>>> input or
>>>>> output video format (either a DV preset or a PAL/NTSC STD). For DV
>>>>> presets we could add it to struct v4l2_dv_enum_presets and we 
>>>>> could do
>>>>> the same for STD formats by adding it to struct v4l2_standard.
>>>> Cropping and composing doesn't modify the pixel aspect ratio, so I 
>>>> agree
>>>> it doesn't belong there.
>>>>
>>>>> This would fail for sensors, though, since there the chosen sensor
>>>>> framesize is set through S_FMT. (This never quite made sense to me,
>>>>> though, from a V4L2 API perspective). I'm not sure whether we can
>>>>> always assume 1:1 pixel ratio for sensors. Does anyone know?
>>>> Most of the time I suppose so, but I wouldn't be surprise if some 
>>>> exotic
>>>> sensors had non-square pixel aspect ratios.
>>> Would it make sense to add the pixel ratio to struct v4l2_frmsizeenum?
>>>
>>> And what about adding a VIDIOC_G/S_FRAMESIZE to select a sensor 
>>> resolution?
>>>
>>> This would typically be one of the discrete framesizes supported by a
>>> sensor through binning/skipping. If there is also a scaler on the 
>>> sensor,
>>> then that is controlled through S_FMT. For video it is S_FMT that 
>>> controls
>>> the scaler (together with S_CROP at the moment), but the source 
>>> resolution
>>> is set through S_STD/S_DV_PRESET/S_DV_TIMINGS. It always felt very
>>> inconsistent to me that there is no equivalent for sensors, even though
>>> you can enumerate all the available framesizes (just as you can with
>>> ENUMSTD and ENUM_DV_PRESETS).
>
> The problem is that S_FMT is used to configure two entities:
> - memory buffer
> - sensor
> The selection API help to configure crop/compose/scaling. Therefore if 
> selection would be accepted in V4L, then it may be worth to consider 
> separation of memory and sensors configuration.
>
> I agree that sensors need a dedicated ioctl of {G,S,TRY,ENUM}_SENSOR 
> family. I do not feel competent in this matter but I think that the 
> ioctl should support feature typical for sensors like:
> - array size (before scaling)
> - array shape
> - (sub)pixel ratio or equivalent
> - binning/skipping
>
> The V4L is designed for simple pipelines like one below:
>
> Input ---->  Processing ----> Output
>
> In sensor case we have:
>
> Sensor array  ----->  Processing --------> Memory
> - resolution          - compose            - format
> - binning             - crop               - resolution bounds
> - skipping            - scaling            - size in bytes (!)
>                                            - alignment/bytesperline
>
> For TV output the pipeline is following:
>
> Memory       ------> Processing --------> TV output
> - format             - compose            - tv standard
> - bounds             - crop               - timing
> - size               - scaling            - DAC encoding
> - alignment
>
> I think that memory(buffers) should be configured using S_FMT.
> Sensors should be configured with new S_SENSOR ioctl.
>
> I do not see how this approach could break backward compatibility?
> The only problem might be that the sensor may not work optimally is 
> its default resolution is too big in comparison to buffer resolution.
> Choosing optimal configuration of sensor/scaler is done in MC.
> Applying overmentioned approach, it could be also configured in video 
> node.
>
> What is your opinion about this idea?
>
>>
>> Let's take one step back here.
>>
>> We started with the V4L2 device node API to control (more or less) 
>> simple devices. Device became more complex, and we created a new MC 
>> API (along with the subdev pad-level API) to configure complex 
>> pipelines. The V4L2 device node API still lives, and we want to 
>> enhance it to configure medium complexity devices.
>>
>> Before going much further, I think we need to define what a medium 
>> complexity device is and where we put the boundary between devices 
>> that can be configured with the V4L2 device node API, and devices 
>> that require the MC API.
>>
>> I believe this shouldn't be too difficult. What we need to do is 
>> create a simple virtual pipeline that supports cropping, scaling and 
>> composing, and map the V4L2 device node API to that pipeline 
>> configuration. Devices that map to that pipeline could then use the 
>> V4L2 device node API only, with clearly defined semantics.
>>
>> [snip]
>>
>>>>>>   * resolution of an image combined with support for
>>>>>>   VIDIOC_S_MULTISELECTION
>>>>>>       allows to pass a triple format/crop/compose sizes in a single
>>>>>>     ioctl
>>>>> I don't believe S_MULTISELECTION will solve anything. Specific
>>>>> use-cases perhaps, but not the general problem of setting up a
>>>>> pipeline. I feel another brainstorm session coming to solve that. We
>>>>> never came to a solution for it in Warsaw.
>>>> Pipelines are configured on subdev nodes, not on video nodes, so 
>>>> I'm also
>>>> unsure whether multiselection support would really be useful.
>>>>
>
> Passing compose and crop rectangle in single ioctl might help in some 
> cases, like the one described here:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/27581 
>
>
>>>> If we decide to implement multiselection support, we might as well use
>>>> that only. We would need a multiselection target bitmask, so selection
>>>> targets should all be < 32.
> I was considering something like this:
>
> struct v4l2_multiselection {
>     int n; /* number of targets */
>     struct v4l2_selection s[0]; /* 0-length array */
> };
>
> There is no need for a bitmask.
>
>>>>
>>>> Thinking some more about it, does it make sense to set both crop and
>>>> compose on a single video device node (not talking about mem-to-mem,
>>>> where you use the type to multiplex input/output devices on the same
>>>> node) ? If so, what would the use cases be ?
>
> Configuration of multi input/output devices could be realised by 
> adding extra targets and passing them all using MULTISELECTION.
>
> To sum up, the multiselection is only an brainstorm idea. I think that 
> transaction-based API is simpler and more robust.
> Multiselection would be realized by passing multiple VIDIOC_S_SELECTION
> inside single transaction window.
>
> Best regards,
> Tomasz Stanislawski
>
>>>>
>>>> Should all devices support the selection API, or only the simple ones
>>>> that don't expose a user-configurable pipeline to userspace through 
>>>> the
>>>> MC API ? The proposed API looks good to me, but before acking it I'd
>>>> like to clarify how (if at all) this will interact with subdev 
>>>> pad-level
>>>> configuration on devices that support that. My current feeling is that
>>>> video device nodes for such devices should only be used for video
>>>> streaming. All parameters should be configured directly on the 
>>>> subdevs.
>>>> Application might still need to call S_FMT in order to be able to
>>>> allocate buffers though.
>>> This comes back to how we want to implement backwards compatibility for
>>> existing applications. There must be a way for 'standard' apps to work
>>> with complex drivers for specific video nodes (the mc would probably 
>>> mark
>>> those as a 'DEFAULT' node).
>>>
>>> I'd say that there are roughly two options: either implement the 
>>> selection
>>> etc. APIs for those video nodes only in the driver, letting the 
>>> driver set
>>> up the subdev pipeline, or do it via libv4l SoC-specific plugins.
>>>
>>> In my opinion we need to finish the pipeline configuration topic we 
>>> started
>>> in Warsaw before we can finalize this RFC. This RFC clearly 
>>> demonstrates
>>> that we have inconsistencies and deficiencies in our API that need 
>>> to be
>>> solved first. When we have done that, then I expect that this selection
>>> API will be easy to finalize.
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

