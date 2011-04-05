Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:52152 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab1DEOOl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2011 10:14:41 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Q771k-0000NI-5c
	for linux-media@vger.kernel.org; Tue, 05 Apr 2011 16:14:40 +0200
Received: from 217067201162.u.itsa.pl ([217.67.201.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2011 16:14:40 +0200
Received: from t.stanislaws by 217067201162.u.itsa.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2011 16:14:40 +0200
To: linux-media@vger.kernel.org
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
Date: Tue, 05 Apr 2011 16:14:44 +0200
Message-ID: <inf83v$vou$1@dough.gmane.org>
References: <1301325596-18166-1-git-send-email-t.stanislaws@samsung.com> <201103291150.29555.hansverk@cisco.com> <4D91B6BA.1070103@samsung.com> <201104051600.38985.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <201104051600.38985.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi Tomasz,
> 
> On Tuesday 29 March 2011 12:38:50 Tomasz Stanislawski wrote:
>> Hans Verkuil wrote:
>>> On Tuesday, March 29, 2011 11:22:17 Tomasz Stanislawski wrote:
>>>> Hans Verkuil wrote:
>>>>> On Monday, March 28, 2011 17:19:54 Tomasz Stanislawski wrote:
>>>>>> Hello everyone,
>>>>>>
>>>>>> This patch-set introduces new ioctls to V4L2 API. The new method for
>>>>>> configuration of cropping and composition is presented.
>>>>>>
>>>>>> There is some confusion in understanding of a cropping in current
>>>>>> version of V4L2. For CAPTURE devices cropping refers to choosing only a
>>>>>> part of input data stream and processing it and storing it in a memory
>>>>>> buffer. The buffer is fully filled by data. It is not possible to
>>>>>> choose only a part of a buffer for being updated by hardware.
>>>>>>
>>>>>> In case of OUTPUT devices, the whole content of a buffer is passed by
>>>>>> hardware to output display. Cropping means selecting only a part of an
>>>>>> output display/signal. It is not possible to choose only a part for a
>>>>>> memory buffer to be processed.
>>>>>>
>>>>>> The overmentioned flaws in cropping API were discussed in post:
>>>>>> http://article.gmane.org/gmane.linux.drivers.video-input-
> infrastructure/28945
>>>>>> A solution was proposed during brainstorming session in Warsaw.
>>>> Hello. Thank you for a quick comment.
>>>>
>>>>> I don't have time right now to review this RFC in-depth, but one thing
>>>>> that needs more attention is the relationship between these new ioctls
>>>>> and CROPCAP.
>>>>> And also how this relates to analog inputs (I don't think analog
>>>>> outputs make any sense). And would a COMPOSECAP ioctl make sense?
>>>> Maybe two new ioctl COMPOSECAP and EXTCROPCAP should be added.
>>>> For input CROPCAP maps to EXTCROPCAP, for output it maps to COMPOSECAP.
>>>> The output EXTCROPCAP would return dimentions of a buffer.
>>>> But in my opinion field v4l2_selection::bounds should be added to
>>>> structure below. In such a case G_EXTCROP could be used to obtain
>>>> cropping bounds.
> 
> Using flags to tell G_EXTCROP and G_COMPOSE whether we want to retrieve the 
> bounds, default rectangle or current rectangle would be a sensible option in 
> my opinion.
> 
I am preparing second version of this RFC that added support for 
obtaining bounds and defrect using G_{EXTCROP / COMPOSE}. It will be 
posted soon.
>>> There is more in CROPCAP than just the bounds. I'd have to think about
>>> this myself.
> 
> [snip]
> 
>>>>>> 3. Hints
>>>>>>
>>>>>> The v4l2_selection::flags field is used to give a driver a hint about
>>>>>> coordinate adjustments.  Below one can find the proposition of
>>>>>> adjustment flags. The syntax is V4L2_SEL_{name}_{LE/GE}, where {name}
>>>>>> refer to a
>>> field in
>>>
>>>>>> struct v4l2_rect. The LE is abbreviation from "lesser or equal".  It
>>> prevents
>>>
>>>>>> the driver form increasing a parameter. In similar fashion GE means
>>> "greater or
>>>
>>>>>> equal" and it disallows decreasing. Combining LE and GE flags prevents
>>> the
>>>
>>>>>> driver from any adjustments of parameters.  In such a manner, setting
>>> flags
>>>
>>>>>> field to zero would give a driver a free hand in coordinate
>>>>>> adjustment.
>>>>>>
>>>>>> #define V4L2_SEL_WIDTH_GE	0x00000001
>>>>>> #define V4L2_SEL_WIDTH_LE	0x00000002
>>>>>> #define V4L2_SEL_HEIGHT_GE	0x00000004
>>>>>> #define V4L2_SEL_HEIGHT_LE	0x00000008
>>>>>> #define V4L2_SEL_LEFT_GE	0x00000010
>>>>>> #define V4L2_SEL_LEFT_LE	0x00000020
>>>>>> #define V4L2_SEL_TOP_GE		0x00000040
>>>>>> #define V4L2_SEL_TOP_LE		0x00000080
>>>>> Wouldn't you also need similar flags for RIGHT and BOTTOM?
>>>>>
>>>>> Regards,
>>>>>
>>>>> 	Hans
>>>> Proposed flags refer to fields in v4l2_rect structure. These are left,
>>>> top, width and height. Fields bottom and right and not present in
>>>> v4l2_rect structure.
>>> But what if I want to keep the bottom right corner fixed, and allow other
>>> parameters to change? I don't think you can do that with the current set
>>> of flags.
>>>
>>> Regards,
>>>
>>> 	Hans
>> You are right. New flags should be added:
>>
>> #define V4L2_SEL_RIGHT_GE	0x00000100
>> #define V4L2_SEL_RIGHT_LE	0x00000200
>> #define V4L2_SEL_BOTTOM_GE	0x00000400
>> #define V4L2_SEL_BOTTOM_LE	0x00000800
>>
>> They  would be used to inform a driver about adjusting a bottom-right
>> corner. Right and bottom would be defined as:
>>
>> right = v4l2_rect::left + v4l2_rect::width
>> bottom = v4l2_rect::top + v4l2_rect::height
> 
> What if you want to allow the rectangle to be slightly enlarged or reduced, 
> but want to keep it centered ? I feel like this would get out of hands quite 
> fast. Hints are not a bad idea, but they will become very complex to implement 
> in drivers, especially when the hardware forces all kind of weird constraints 
> (and we all know that hardware designers get extremely creative in that area 
> :-)).
Yes.. it may be complex. Unfortunately, currently there is no way to 
control a crop adjustment. The proposed solution is not perfect but I 
think it is sufficient to deal with the most common situations.
Quite probably some simple framework or helper functions have to be 
added to V4L2 kernel API to help driver to deal with a business logic 
hidden behind crop adjustments.

Regards,
Tomasz Stanislawski

> 
>>>>>> #define V4L2_SEL_WIDTH_FIXED	0x00000003
>>>>>> #define V4L2_SEL_HEIGHT_FIXED	0x0000000c
>>>>>> #define V4L2_SEL_LEFT_FIXED	0x00000030
>>>>>> #define V4L2_SEL_TOP_FIXED	0x000000c0
>>>>>>
>>>>>> #define V4L2_SEL_FIXED		0x000000ff
>>>>>>
>>>>>> The hint flags may be useful in a following scenario.  There is a
>>>>>> sensor with a face detection functionality. An application receives
>>>>>> information about a position of a face on sensor array. Assume that the
>>>>>> camera pipeline is capable of an image scaling. The application is
>>>>>> capable of obtaining a location of a face using V4L2 controls. The task
>>>>>> it to grab only part of image that contains a face, and store it to a
>>>>>> framebuffer at a fixed window. Therefore following constrains have to
>>>>>> be satisfied:
>>>>>> - the rectangle that contains a face must lay inside cropping area
>>>>>> - hardware is allowed only to access area inside window on the
>>>>>> framebuffer
>>>>>>
>>>>>> Both constraints could be satisfied with two ioctl calls.
>>>>>> - VIDIOC_EXTCROP with flags field equal to
>>>>>>
>>>>>>   V4L2_SEL_TOP_FIXED | V4L2_SEL_LEFT_FIXED |
>>>>>>   V4L2_SEL_WIDTH_GE | V4L2_SEL_HEIGHT_GE.
>>>>>>
>>>>>> - VIDIOC_COMPOSE with flags field equal to
>>>>>>
>>>>>>   V4L2_SEL_TOP_FIXED | V4L2_SEL_LEFT_FIXED |
>>>>>>   V4L2_SEL_WIDTH_LE | V4L2_SEL_HEIGHT_LE
> 

