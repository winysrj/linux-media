Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30563 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1KXMZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 07:25:56 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LV5006M9ZV66G60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 12:25:54 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV5002HYZV6Z1@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 12:25:54 +0000 (GMT)
Date: Thu, 24 Nov 2011 13:25:53 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l: Add a global color alpha control
In-reply-to: <201111241306.11651.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@redhat.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4ECE37D1.9030505@samsung.com>
References: <1322131997-26195-1-git-send-email-s.nawrocki@samsung.com>
 <4ECE2D0A.8060209@samsung.com> <201111241249.00601.hverkuil@xs4all.nl>
 <201111241306.11651.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2011 01:06 PM, Laurent Pinchart wrote:
> On Thursday 24 November 2011 12:49:00 Hans Verkuil wrote:
>> On Thursday, November 24, 2011 12:39:54 Sylwester Nawrocki wrote:
>>> On 11/24/2011 12:09 PM, Laurent Pinchart wrote:
>>>> On Thursday 24 November 2011 12:00:45 Hans Verkuil wrote:
>>>>> On Thursday, November 24, 2011 11:53:16 Sylwester Nawrocki wrote:
>>>>>> This control is intended for video capture or memory-to-memory
>>>>>> devices that are capable of setting up the alpha conponent to
>>>>>> some arbitrary value.
>>>>>> The V4L2_CID_COLOR_ALPHA control allows to set the alpha channel
>>>>>> globally to a value in range from 0 to 255.
>>>>>>
>>>>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>>> ---
>>>>>>
>>>>>>  Documentation/DocBook/media/v4l/controls.xml       |   20
>>>>>>  ++++++++++++++------ .../DocBook/media/v4l/pixfmt-packed-rgb.xml
>>>>>>  
>>>>>>  |    7 +++++-- drivers/media/video/v4l2-ctrls.c                   |
>>>>>>  
>>>>>>  7 +++++++ include/linux/videodev2.h                          |    6
>>>>>>  +++--- 4 files changed, 29 insertions(+), 11 deletions(-)
>>>>>>
>>>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>>>>>> b/Documentation/DocBook/media/v4l/controls.xml index 3bc5ee8..7f99222
>>>>>> 100644
>>>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>>>>> @@ -324,12 +324,6 @@ minimum value disables backlight
>>>>>> compensation.</entry>
>>>>>>
>>>>>>  		(usually a microscope).</entry>
>>>>>>  		
>>>>>>  	  </row>
>>>>>>  	  <row>
>>>>>>
>>>>>> -	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
>>>>>> -	    <entry></entry>
>>>>>> -	    <entry>End of the predefined control IDs (currently
>>>>>> -<constant>V4L2_CID_ILLUMINATORS_2</constant> + 1).</entry>
>>>>>> -	  </row>
>>>>>> -	  <row>
>>>>>>
>>>>>>  	    <entry><constant>V4L2_CID_MIN_BUFFERS_FOR_CAPTURE</constant></e
>>>>>>  	    ntry
>>>>>>  	    
>>>>>>  	    > <entry>integer</entry>
>>>>>>  	    
>>>>>>  	    <entry>This is a read-only control that can be read by the
>>>>>>  	    application
>>>>>>
>>>>>> @@ -345,6 +339,20 @@ and used as a hint to determine the number of
>>>>>> OUTPUT buffers to pass to REQBUFS.
>>>>>>
>>>>>>  The value is the minimum number of OUTPUT buffers that is necessary
>>>>>>  for hardware to work.</entry>
>>>>>>  
>>>>>>  	  </row>
>>>>>>
>>>>>> +	  <row id="v4l2-color-alpha">
>>>>>> +	    <entry><constant>V4L2_CID_COLOR_ALPHA</constant></entry>
>>>>>> +	    <entry>integer</entry>
>>>>>> +	    <entry> Sets the color alpha component on the capture device.
>>>>>> It is +	    applicable to any pixel formats that contain the alpha
>>>>>> component, +	    e.g. <link linkend="rgb-formats">packed RGB image
>>>>>> formats</link>. +	    </entry>
>>>>
>>>> As the alpha value is global, isn't it applicable to formats with no
>>>> alpha component as well ?
>>>
>>> Hmm, I can't say no.. The control was intended as a means of setting up
>>> the alpha value for packed RGB formats:
>>> http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html#rgb-formats
>>>
>>> However it could well be used for formats with no alpha. Do you think
>>> the second sentence above should be removed or should something else be
>>> added to indicate it doesn't necessarily have to have a connection
>>> with ARGB color formats ?
> 
> I think we should make it explicit that this global alpha value is applied in 
> addition to a possibly per-pixel alpha value (if available in the selected 
> format).

I'm not sure if it was the intention. If pixel format has alpha component
this control would set per-pixel alpha to an arbitrary control value.

If the pixel format doesn't have alpha, then what this control would do
- I'm not sure.

> 
>> Huh? How can this be used for formats without an alpha channel?
> 
> If my understanding is correct, this control sets a global alpha value for the 
> whole overlay. For instance, with V4L2_CID_COLOR_ALPHA set to 0.5, an overlay 

More precisely it sets a per-pixel alpha to some arbitrary value. For instance
in this case the A value for each pixel with ARGB8888 pixel format would be 128.

> using a non-alpha format (such as YUYV), or an overlay using an alpha format  
> with the alpha value set to 1 for every pixel, would be half transparent.
> 
> In other words, the resulting alpha value is the product of the global alpha 
> value and the per-pixel alpha value. Non-alpha formats have an implicit per-
> pixel alpha value equal to 1 for every pixel.
> 
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
>>>>>> +	    <entry></entry>
>>>>>> +	    <entry>End of the predefined control IDs (currently
>>>>>> +	      <constant>V4L2_CID_COLOR_ALPHA</constant> + 1).</entry>
>>>>>> +	  </row>
>>>>>>
>>>>>>  	  <row>
>>>>>>  	  
>>>>>>  	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
>>>>>>  	    <entry></entry>
>>>>>>
>>>>>> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
>>>>>> b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml index
>>>>>> 4db272b..da4c360 100644
>>>>>> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
>>>>>> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
>>>>>> @@ -428,8 +428,11 @@ colorspace
>>>>>> <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>>>>>>
>>>>>>      <para>Bit 7 is the most significant bit. The value of a = alpha
>>>>>>  
>>>>>>  bits is undefined when reading from the driver, ignored when writing
>>>>>>  to the driver, except when alpha blending has been negotiated for a
>>>>>>
>>>>>> -<link linkend="overlay">Video Overlay</link> or <link
>>>>>> -linkend="osd">Video Output Overlay</link>.</para>
>>>>>> +<link linkend="overlay">Video Overlay</link> or <link linkend="osd">
>>>>>> +Video Output Overlay</link> or when global alpha has been configured
>>>>>> +for a <link linkend="capture">Video Capture</link> by means of
>>>>>> +<link linkend="v4l2-color-alpha"> <constant>V4L2_CID_COLOR_ALPHA
>>>>>> +</constant> </link> control.</para>
>>>>>>
>>>>>>      <example>
>>>>>>      
>>>>>>        <title><constant>V4L2_PIX_FMT_BGR24</constant> 4 &times; 4
>>>>>>        pixel
>>>>>>
>>>>>> diff --git a/drivers/media/video/v4l2-ctrls.c
>>>>>> b/drivers/media/video/v4l2-ctrls.c index 5552f81..bd90955 100644
>>>>>> --- a/drivers/media/video/v4l2-ctrls.c
>>>>>> +++ b/drivers/media/video/v4l2-ctrls.c
>>>>>> @@ -466,6 +466,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>>>>>
>>>>>>  	case V4L2_CID_ILLUMINATORS_2:		return "Illuminator 2";
>>>>>>  	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:	return "Minimum Number of
>>>>>>  	Capture Buffers"; case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return
>>>>>>  	"Minimum Number of Output Buffers";
>>>>>>
>>>>>> +	case V4L2_CID_COLOR_ALPHA:		return "Color Alpha";
>>>>>
>>>>> I prefer CID_ALPHA_COLOR and string "Alpha Color". I think it is more
>>>>> natural than the other way around.
>>>
>>> OK, I guess you're right. And Google returns about twice as many hits for
>>> "alpha color" than for "color alpha"...
>>>
>>>> I'm not too found of "color" in the name. Is the alpha value considered
>>>> as a color ?
>>>
>>> Certainly it isn't, but Alpha alone looks a bit odd. It's too generic
>>> IMHO.
>>
>> How about V4L2_CID_ALPHA_COMPONENT?
> 
> Or V4L2_CID_GLOBAL_ALPHA ?

Although V4L2_CID_GLOBAL_ALPHA sounds good, V4L2_CID_ALPHA_COMPONENT reflects 
more precisely what was my intention. The control was supposed to set the alpha
component for ARGB formats.
 

-- 
Regards,
Sylwester

