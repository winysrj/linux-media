Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30915 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2HXIQD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 04:16:03 -0400
Received: from eusync4.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9900I282ZKV130@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 24 Aug 2012 09:16:32 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M9900HVK2YN1P70@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 24 Aug 2012 09:16:00 +0100 (BST)
Message-id: <5037383E.3030109@samsung.com>
Date: Fri, 24 Aug 2012 10:15:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, g.liakhovetski@gmx.de,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 1/4] V4L: Add V4L2_CID_FRAMESIZE image source class
 control
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
 <50363F19.5070607@samsung.com> <5036754C.4040501@iki.fi>
 <1479692.F6ROfrmgsS@avalon>
In-reply-to: <1479692.F6ROfrmgsS@avalon>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/24/2012 12:41 AM, Laurent Pinchart wrote:
> On Thursday 23 August 2012 21:24:12 Sakari Ailus wrote:
>> Sylwester Nawrocki wrote:
>>>> On Thu, Aug 23, 2012 at 11:51:26AM +0200, Sylwester Nawrocki wrote:
>>>>> The V4L2_CID_FRAMESIZE control determines maximum number
>>>>> of media bus samples transmitted within a single data frame.
>>>>> It is useful for determining size of data buffer at the
>>>>> receiver side.
>>>>>
>>>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>> ---
>>>>>
>>>>>   Documentation/DocBook/media/v4l/controls.xml | 12 ++++++++++++
>>>>>   drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
>>>>>   include/linux/videodev2.h                    |  1 +
>>>>>   3 files changed, 15 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>>>>> b/Documentation/DocBook/media/v4l/controls.xml index 93b9c68..ad5d4e5
>>>>> 100644
>>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>>>> @@ -4184,6 +4184,18 @@ interface and may change in the future.</para>
>>>>>
>>>>>   	    conversion.
>>>>>   	    </entry>
>>>>>   	  
>>>>>   	  </row>
>>>>>
>>>>> +	  <row>
>>>>> +	    <entry
>>>>> spanname="id"><constant>V4L2_CID_FRAMESIZE</constant></entry>
>>>>> +	    <entry>integer</entry>
>>>>> +	  </row>
>>>>> +	  <row>
>>>>> +	    <entry spanname="descr">Maximum size of a data frame in media bus
>>>>> +	      sample units. This control determines maximum number of samples
>>>>> +	      transmitted per single compressed data frame. For generic raw
>>>>> +	      pixel formats the value of this control is undefined. This is
>>>>> +	      a read-only control.
>>>>> +	    </entry>
>>>>> +	  </row>
>>>>>
>>>>>   	  <row><entry></entry></row>
>>>>>   	
>>>>>   	</tbody>
>>>>>   	
>>>>>         </tgroup>
>>>>>
>>>>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
>>>>> b/drivers/media/v4l2-core/v4l2-ctrls.c index b6a2ee7..0043fd2 100644
>>>>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>>>>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>>>>> @@ -727,6 +727,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>>>>
>>>>>   	case V4L2_CID_VBLANK:			return "Vertical Blanking";
>>>>>   	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
>>>>>   	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
>>>>>
>>>>> +	case V4L2_CID_FRAMESIZE:		return "Maximum Frame Size";
>>>>
>>>> I would put this to the image processing class, as the control isn't
>>>> related to image capture. Jpeg encoding (or image compression in
>>>> general) after all is related to image processing rather than capturing
>>>> it.
>>>
>>> All right, might make more sense that way. Let me move it to the image
>>> processing class then. It probably also makes sense to name it
>>> V4L2_CID_FRAME_SIZE, rather than V4L2_CID_FRAMESIZE.
>>
>> Hmm. While we're at it, as the size is maximum --- it can be lower ---
>> how about V4L2_CID_MAX_FRAME_SIZE or V4L2_CID_MAX_FRAME_SAMPLES, as the
>> unit is samples?
>
>> Does sample in this context mean pixels for uncompressed formats and
>> bytes (octets) for compressed formats? It's important to define it as
>> we're also using the term "sample" to refer to data units transferred
>> over a parallel bus per a clock cycle.
> 
> I agree with Sakari here, I find the documentation quite vague, I wouldn't 
> understand what the control is meant for from the documentation only.

I thought it was clear enough:

Maximum size of a data frame in media bus sample units.
                             ^^^^^^^^^^^^^^^^^^^^^^^^^
So that means the unit is a number of bits clocked by a single clock
pulse on parallel video bus... :) But how is media bus sample defined
in case of CSI bus ? Looks like "media bus sample" is a useless term
for our purpose.

I thought it was better than just 8-bit byte, because the data receiver
(bridge) could layout data received from video bus in various ways in
memory, e.g. add some padding. OTOH, would any padding make sense
for compressed streams ? It would break the content, wouldn't it ?

So I would propose to use 8-bit byte as a unit for this control and
name it V4L2_CID_MAX_FRAME_SIZE. All in all it's not really tied
to the media bus.

>> On serial busses the former meaning is more obvious.

--

Regards,
Sylwester
