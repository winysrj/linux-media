Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2041 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaFCMnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 08:43:06 -0400
Message-ID: <538DC29C.8030705@xs4all.nl>
Date: Tue, 03 Jun 2014 14:42:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/3] v4l: Add test pattern colour component controls
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <1559123.5XHCoOtRWQ@avalon> <53887960.3050003@xs4all.nl> <2201153.BLlnLr5VnQ@avalon>
In-Reply-To: <2201153.BLlnLr5VnQ@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/14 14:21, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 30 May 2014 14:28:16 Hans Verkuil wrote:
>> On 05/29/2014 05:01 PM, Laurent Pinchart wrote:
>>> On Thursday 29 May 2014 17:58:59 Sakari Ailus wrote:
>>>> Laurent Pinchart wrote:
>>>>> On Thursday 29 May 2014 17:40:46 Sakari Ailus wrote:
>>>>>> In many cases the test pattern has selectable values for each colour
>>>>>> component. Implement controls for raw bayer components. Additional
>>>>>> controls should be defined for colour components that are not covered
>>>>>> by these controls.
>>>>>>
>>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>>> ---
>>>>>>
>>>>>>  Documentation/DocBook/media/v4l/controls.xml | 34 ++++++++++++++++++++
>>>>>>  drivers/media/v4l2-core/v4l2-ctrls.c         |  4 ++++
>>>>>>  include/uapi/linux/v4l2-controls.h           |  4 ++++
>>>>>>  3 files changed, 42 insertions(+)
>>>>>>
>>>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>>>>>> b/Documentation/DocBook/media/v4l/controls.xml index 47198ee..bf23994
>>>>>> 100644
>>>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>>>>> @@ -4677,6 +4677,40 @@ interface and may change in the future.</para>
>>>>>>   	    conversion.
>>>>>>   	    </entry>
>>>>>>   	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry
>>>>>> spanname="id"><constant>V4L2_CID_TEST_PATTERN_RED</constant></entry>
>>>>>> +       <entry>integer</entry>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry spanname="descr">Test pattern red colour component.
>>>>>> +	    </entry>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry
>>>>>> spanname="id"><constant>V4L2_CID_TEST_PATTERN_GREENR</constant></entry>
>>>>>> +	    <entry>integer</entry>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry spanname="descr">Test pattern green (next to red)
>>>>>> +	    colour component.
>>>>>
>>>>> What about non-Bayer RGB sensors ? Should they use the GREENR or the
>>>>> GREENB control for the green component ? Or a different control ?
>>>>
>>>> A different one. It should be simply green. I could add it to the same
>>>> patch if you wish.
>>>>
>>>>> I'm wondering whether we shouldn't have a single test pattern color
>>>>> control and create a color type using Hans' complex controls API.
>>>>
>>>> A raw bayer four-pixel value, you mean?
>>>
>>> Yes. I'll let Hans comment on that.
>>
>> Why would you need the complex control API for that? It would fit in a s32,
>> and certainly in a s64.
> 
> It wouldn't fit in a s32 when using more than 8 bits per component. s64 would 
> be an option, until we reach 16 bits per component (or more than 4 
> components).
> 
>> We have done something similar to this in the past (V4L2_CID_BG_COLOR).
>>
>> The main problem is that the interpretation of the s32 value has to be
>> clearly defined. And if different sensors might have different min/max
>> values for each component, then it becomes messy to use a single control.
> 
> The interpretation would depend on both the sensor and the color format.
> 
>> My feeling is that it is better to go with separate controls, one for each
>> component.
> 
> What bothers me is that we'll need to add lots of controls, for each 
> component. There's 4 controls for Bayer, one additional green control for RGB, 
> 3 controls for YUV, ... That's already 8 controls to support the common 
> Bayer/RGB/YUV formats. As colors can be used for different purposes (test 
> pattern with possibly more than one color, background color, ...) that would 
> increase the complexity beyond my comfort zone.

Why would this be any better with compound type controls? In fact, I think
it is worse: simple controls will show up in qv4l2 and v4l2-ctl and are easy
to set from the GUI/command line. To set compound controls you will need to
write custom code for them. You also only see the controls that the driver
actually needs. So while there may be X component controls, a driver for a
Bayer sensor will only use four of them.

If you want to support a driver that has highly specialized test pattern
support, then I'm leaning towards a custom ioctl for that driver.

Regards,

	Hans

