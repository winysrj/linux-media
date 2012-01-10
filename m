Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57850 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab2AJLUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 06:20:24 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LXK00FOPY5Y8K@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Jan 2012 11:20:22 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LXK00ASNY5XK7@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Jan 2012 11:20:22 +0000 (GMT)
Date: Tue, 10 Jan 2012 12:20:19 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC 06/17] v4l: Add selections documentation.
In-reply-to: <4F0B2EF0.5080203@maxwell.research.nokia.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Message-id: <4F0C1EF3.7040704@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7BIT
References: <4EF0EFC9.6080501@maxwell.research.nokia.com>
 <1324412889-17961-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <201201061243.56158.laurent.pinchart@ideasonboard.com>
 <4F0B2EF0.5080203@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> Hi Laurent,
>
> Thanks for the comments!
>
> Laurent Pinchart wrote:
>> On Tuesday 20 December 2011 21:27:58 Sakari Ailus wrote:
>>
>> [snip]
>>
>>> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
>>> b/Documentation/DocBook/media/v4l/dev-subdev.xml index 0916a73..722db60
>>> 100644
>>> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
>>> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml

[snip]

>>
>> This sounds a bit confusing to me. One issue is that composing is not formally
>> defined. I think it would help if you could draw a diagram that shows how the
>> operations are applied, and modify the text to describe the diagram, using the
>> natural order of the compose and crop operations on sink and source pads.
>
> I drew a diagram based on your suggestion, but I'd prefer the formal
> definition would come from someone who needs composition and better
> understands the use cases.
>
> Also cc Tomasz.
>
>>> +<section>
>>> +<title>Order of configuration and format propagation</title>
>>> +
>>> +<para>The order of image processing steps will always be from
>>> +      the sink pad towards the source pad. This is also reflected in
>>> +      the order in which the configuration must be performed by the
>>> +      user. The format is propagated within the subdev along the later
>>> +      processing steps. For example, setting the sink pad format
>>> +      causes all the selection rectangles and the source pad format to
>>> +      be set to sink pad format --- if allowed by the hardware, and if
>>> +      not, then closest possible. The coordinates to a step always
>>> +      refer to the active size of the previous step.</para>
>>
>> This also sounds a bit ambiguous if I try to ignore the fact that I know how
>> it works :-) You should at least make it explicit that propagation inside
>> subdevs is performed by the driver(s), and that propagation outside subdevs is
>> to be handled by userspace.
>
> Agreed. I'll reword it.
>

[snip]

>>> +<para>The are four types of selection targets: active, default,
>>> +      bounds and padding. The ACTIVE targets are the targets which
>>> +      configure the hardware. The DEFAULT target provides the default
>>> +      for the ACTIVE selection. The BOUNDS target will return the
>>> +      maximum width and height of the target.
>>
>> What about the minimum ?

There are multiple problems with idea of the maximal rectangle because 
one has to provide definition how to compare size of two rectangles. If 
you had to compare rectangles 10x1, 1x10, 5x5 which would you choose as 
the largest? Such problems may appear if HW has width, height and size 
constraints. One encounters similar problem with definition of the 
smallest rectangle. I prefer to define "is larger" as "contains". 
Rectangle 10x10 contains all three overmentioned rectangles therefore it 
is the maximal rectangle. The problem with such a definition is that 
such a rectangle may not be accepted by HW.

>
> Good question. We could also specify that the minimum is obtained by
> using the V4L2_SUBDEV_SEL_FLAG_LE flag with the BOUNDS target.
>

As I remember bounds rectangle is fixed and there is no such a thing as 
minimal/maximal bounds. For V4L2 video node API, the bounds rectangle is 
read-only value describing rectangle that contains all pixels.
Could you describe the use case that utilities minimal bounds rectangle?

>>> The PADDED target
>>> +      provides the width and height for the padded image,
>>
>> Is it valid for both crop and compose rectangles ?
>
> I think all targets are valid for all rectangles. Should I mention that?
>
> The practical use cases may be more limited, though. I wonder if I
> should remove the padded targets until we get use cases for them. I
> included them for the reason that they also exist in the V4L2.
>
> Tomasz, Sylwester: do you have use for the PADDED targets?

S5P-TV and S5P-JPEG (by Andrzej Pietrasiewicz) makes use of PADDED 
target. The padded target is very hardware/application dependent 
parameter. It is defined only for composing targets. Basically it refers 
to all pixels that are modified by the hardware. In S5P-TV the padded 
rectangle is equal to active rectangle. However, if having no good idea 
about padded area, then it is always safe/consistent to make padded 
rectangle equal to bounds one.

>
> I think we also must define what will be done in cases where crop (on
> either sink or source) / scaling / composition is not supported by the
> subdev. That's currently undefined. I think it'd be most clear to return
> an error code but I'm not sure which one --- EINVAL is an obvious
> candidate but that is also returned when the pad is wrong. It looks
> still like the best choice to me.

Maybe one should return EPERM or EACCES if S_SELECTION is called on 
read-only target. Other idea is to introduce V4L2_SEL_FLAG_RDONLY flag 
which is set by VIDIOC_G_SELECTION for a given target. The driver may 
return EINVAL if target is not supported. It would imply that support 
for the target is not implemented in the driver.

Regards,
Tomasz Stanislawski

>
>>> and is
>>> +      directly affected by the ACTIVE target. The PADDED targets may
>>> +      be configurable depending on the hardware.</para>
>>
>> If that's configurable drivers will need a way to store it in the file handle.
>
> Good point. I'll add it if we end up defining the padded targets now.
>
>>> +</section>
>>> +
