Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3213 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbaE3M20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 May 2014 08:28:26 -0400
Message-ID: <53887960.3050003@xs4all.nl>
Date: Fri, 30 May 2014 14:28:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/3] v4l: Add test pattern colour component controls
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <48325310.Ydj7bxFi9C@avalon> <53874B33.5050109@linux.intel.com> <1559123.5XHCoOtRWQ@avalon>
In-Reply-To: <1559123.5XHCoOtRWQ@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2014 05:01 PM, Laurent Pinchart wrote:
> On Thursday 29 May 2014 17:58:59 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>>> On Thursday 29 May 2014 17:40:46 Sakari Ailus wrote:
>>>> In many cases the test pattern has selectable values for each colour
>>>> component. Implement controls for raw bayer components. Additional
>>>> controls
>>>> should be defined for colour components that are not covered by these
>>>> controls.
>>>>
>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>> ---
>>>>
>>>>   Documentation/DocBook/media/v4l/controls.xml | 34 +++++++++++++++++++++
>>>>   drivers/media/v4l2-core/v4l2-ctrls.c         |  4 ++++
>>>>   include/uapi/linux/v4l2-controls.h           |  4 ++++
>>>>   3 files changed, 42 insertions(+)
>>>>
>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>>>> b/Documentation/DocBook/media/v4l/controls.xml index 47198ee..bf23994
>>>> 100644
>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>>> @@ -4677,6 +4677,40 @@ interface and may change in the future.</para>
>>>>   	    conversion.
>>>>   	    </entry>
>>>>   	  </row>
>>>> +	  <row>
>>>> +	    <entry
>>>> spanname="id"><constant>V4L2_CID_TEST_PATTERN_RED</constant></entry>
>>>> +       <entry>integer</entry>
>>>> +	  </row>
>>>> +	  <row>
>>>> +	    <entry spanname="descr">Test pattern red colour component.
>>>> +	    </entry>
>>>> +	  </row>
>>>> +	  <row>
>>>> +	    <entry
>>>> spanname="id"><constant>V4L2_CID_TEST_PATTERN_GREENR</constant></entry>
>>>> +	    <entry>integer</entry>
>>>> +	  </row>
>>>> +	  <row>
>>>> +	    <entry spanname="descr">Test pattern green (next to red)
>>>> +	    colour component.
>>>
>>> What about non-Bayer RGB sensors ? Should they use the GREENR or the
>>> GREENB control for the green component ? Or a different control ?
>>
>> A different one. It should be simply green. I could add it to the same
>> patch if you wish.
>>
>>> I'm wondering whether we shouldn't have a single test pattern color
>>> control and create a color type using Hans' complex controls API.
>>
>> A raw bayer four-pixel value, you mean?
> 
> Yes. I'll let Hans comment on that.
> 

Why would you need the complex control API for that? It would fit in a s32,
and certainly in a s64.

We have done something similar to this in the past (V4L2_CID_BG_COLOR).

The main problem is that the interpretation of the s32 value has to be
clearly defined. And if different sensors might have different min/max values
for each component, then it becomes messy to use a single control. My feeling
is that it is better to go with separate controls, one for each component.

Regards,

	Hans
