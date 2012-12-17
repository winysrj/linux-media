Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21990 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2LQRYF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 12:24:05 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MF6002J2R4E3A00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Dec 2012 17:26:38 +0000 (GMT)
Received: from [106.116.147.88] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MF6008RLR01F410@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Dec 2012 17:24:02 +0000 (GMT)
Message-id: <50CF5531.4030504@samsung.com>
Date: Mon, 17 Dec 2012 18:24:01 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC 2/2] V4L: Add V4L2_CID_AUTO_FOCUS_AREA control
References: <1355147019-25375-1-git-send-email-a.hajda@samsung.com>
 <1355147019-25375-3-git-send-email-a.hajda@samsung.com>
 <20121211213404.GC3747@valkosipuli.retiisi.org.uk>
 <50C89F4E.6010701@samsung.com>
 <20121216150023.GC4738@valkosipuli.retiisi.org.uk> <50CE631E.9010007@gmail.com>
In-reply-to: <50CE631E.9010007@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Sakari,

On 17.12.2012 01:11, Sylwester Nawrocki wrote:
> Hi Sakari,
>
> On 12/16/2012 04:00 PM, Sakari Ailus wrote:
>>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml 
>>>>> b/Documentation/DocBook/media/v4l/controls.xml
>>>>> index 7fe5be1..9d4af8a 100644
>>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>>>> @@ -3347,6 +3347,51 @@ use its minimum possible distance for auto 
>>>>> focus.</entry>
>>>>>       </row>
>>>>>       <row><entry></entry></row>
>>>>> +    <row id="v4l2-auto-focus-area">
>>>>> +    <entry spanname="id">
>>>>> + <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>&nbsp;</entry>
>>>>> + <entry>enum&nbsp;v4l2_auto_focus_area</entry>
>>>>> +    </row>
>>>>> +    <row><entry spanname="descr">Determines the area of the frame 
>>>>> that
>>>>> +the camera uses for automatic focus. The corresponding 
>>>>> coordinates of the
>>>>> +focusing spot or rectangle can be specified and queried using the 
>>>>> selection API.
>>>>> +To change the auto focus region of interest applications first 
>>>>> select required
>>>>> +mode of this control and then set the rectangle or spot 
>>>>> coordinates by means
>>>>> +of the&VIDIOC-SUBDEV-S-SELECTION; or&VIDIOC-S-SELECTION; ioctl. 
>>>>> In order to
>>>>> +trigger again a one shot auto focus with same coordinates 
>>>>> applications should
>>>>> +use the<constant>V4L2_CID_AUTO_FOCUS_START</constant> control. Or 
>>>>> alternatively
>>>> Extra space above.                            ^
>>>>
>>>>> +invoke a&VIDIOC-SUBDEV-S-SELECTION; or a&VIDIOC-S-SELECTION; 
>>>>> ioctl again.
>>>> How about requiring explicit V4L2_CID_AUTO_FOCUS_START? If you need to
>>>> specify several AF selection windows, then on which one do you 
>>>> start the
>>>> algorithm? A bitmask control explicitly telling which ones are 
>>>> active would
>>>> also be needed --- but that's for the future. I think now we just 
>>>> need to
>>>> ascertain we don't make that difficult. :-)
>>> Do you mean only V4L2_CID_AUTO_FOCUS_START should start AF?
>>> What about continuous auto-focus (CAF)? In case of the sensor I am
>>> working on, face detection can work in both AF and CAF.
>>
>> Continuous AF needs to be an exception to that. It's controlled by
>> V4L2_CID_FOCUS_AUTO, which interestingly doesn't even mention 
>> continuous AF.
>
> I think it does, maybe not exactly in these words, but "continuous 
> automatic focus
> adjustments" doesn't sound like a difference thing to me.
>
>>> Should CAF be restarted (ie stopped and started again), to use face
>>> detection?
>>
>> I wonder if V4L2_CID_AUTO_FOCUS_START should be defined to restart 
>> CAF when
>> V4L2_CID_FOCUS_AUTO is enabled. I don't think we currently have a way 
>> to do
>> that; the current definition says that using 
>> V4L2_CID_AUTO_FOCUS_START is
>> undefined then. What do you think?
>
> Yes, it might be worth to reconsider this. However, I would like to 
> see real
> use cases first where V4L2_CID_AUTO_FOCUS_START control is needed in 
> continuous
> AF mode.
> All in all, we have V4L2_AUTO_FOCUS_STATUS_FAILED AF status control 
> value and
> I can't see anything preventing it to be applicable to CAF. So it 
> might make
> sense to define in the API what needs to be done to bring CAF out of 
> this state.
And what about using again V4L2_CID_FOCUS_AUTO=true?

Regarding the proposition that setting V4L2_CID_AUTO_FOCUS_AREA should 
not trigger AF/CAF.
I am not sure if it will be good in case of CAF. After setting this 
control but before restarting CAF driver will not
reflect hardware state. It does not seem to be dangerous but I do not 
see why we should allow for such situation anyway.

In case of AF it seems to me OK. FOCUS_AREA is a setting which will be 
used only when AF action is started, ie. only in V4L2_CID_AUTO_FOCUS_START.
Documentation should clearly state that only V4L2_CID_AUTO_FOCUS_START 
starts AF.

>>>>> +In the latter case the new pixel coordinates are applied to 
>>>>> hardware only when
>>>>> +the focus area control was set to
>>>>> +<constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>.</entry>
>>>>> +    </row>
>>>>> +    <row>
>>>>> +    <entrytbl spanname="descr" cols="2">
>>>>> +    <tbody valign="top">
>>>>> +        <row>
>>>>> + <entry><constant>V4L2_AUTO_FOCUS_AREA_ALL</constant>&nbsp;</entry>
>>>>> +        <entry>Normal auto focus, the focusing area extends over the
>>>>> +entire frame.</entry>
>>>> Does this need to be explicitly specified? Shouldn't the user just 
>>>> choose
>>>> the largest possible AF window instead? I'd even expect that the AF 
>>>> window
>>>> might span the whole frame by default (up to driver, hardware etc.).
>>> Yes it could be removed. There are two reasons I have left it:
>>> 1. If hardware support only AF on spots, V4L2_AUTO_FOCUS_AREA_ALL
>>> seems to be more
>>> natural than focusing on the whole image.
>>
>> If the hardware only supports spots, then wouldn't 
>> V4L2_AUTO_FOCUS_AREA_ALL
>> give false information to the user, suggesting the focus area is 
>> actually
>> the whole image?
>
> I think Andrzej meant to say that there can be hardware that supports:
>
> a. AF where region of interest is whole frame,
> b. AF where region of interest is some rectangle of size that may be not
>    known exactly, and position (center) of that rectangle only is defined
>    through AF selections.
>
> So you would be really switching AF algorithms by manipulating AF 
> selection
> rectangle only.
>
> That said I really think V4L2_AUTO_FOCUS_AREA_ALL is a bad name here.
> I originally started with single AF mode control and then after 
> discussions
> we came up with V4L2_AUTO_FOCUS_RANGE and V4L2_AUTO_FOCUS_AREA controls.
>
> My motivation behind V4L2_AUTO_FOCUS_AREA_ALL was to provide a menu
> item that would allow to select "normal" AF, with supposedly whole frame
> being the AF region of interest. "Normal" AF might mean really any area
> of the frame, so I propose to just replace V4L2_AUTO_FOCUS_AREA_ALL with
> V4L2_AUTO_FOCUS_AREA_AUTO. This entry would naturally mean that AF area
> is automatically selected by an ISP and it might not be known exactly to
> user. Like in case of those superb AF algorithms that many companies
> value to keep secret...
>
>>> 2. (Hypothetical) Instructing HW to area-focusing on the whole are
>>> could have different results than just starting default auto-focus,
>>> ie there could be different algorithms involved. It is just a
>>> prediction based on my current experience :)
>>
>> If the algorithm is different in that case, then it should be made a new
>> control, not implicitly throught a seemingly unrelated control.
>>
>> We currently don't have one, and this kind of things could be hardware
>> specific, so this could be a private control IMO.
>
> We have already something like V4L2_CID_AUTO_FOCUS_MODE private control,
> common to multiple Samsung camera sensors. And each device has mostly
> different set of options in such a control. Not sure if it wouldn't make
> more sense to have standard menu control ID with driver specific entries
> for all AF modes. It likely makes sense to have common patterns expressed
> in standard controls though. It seems current set of AF controls, 
> together
> with V4L2_AUTO_FOCUS_AREA covers pretty much of the functionality,
> without resorting to the private controls interface, that is so awkward
> to use when you have to deal with multiple different devices...
>
> -- 
>
> Thanks,
> Sylwester
>

