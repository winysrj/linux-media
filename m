Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13667 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1ISIhT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 04:37:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRR000VDHA57J00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 09:37:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRR00LXKHA4S5@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 09:37:17 +0100 (BST)
Date: Mon, 19 Sep 2011 10:37:16 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l2: Add the parallel bus HREF signal polarity
 flags
In-reply-to: <201109190102.04870.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	g.liakhovetski@gmx.de, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <4E76FF3C.9020703@samsung.com>
References: <1316194123-21185-1-git-send-email-s.nawrocki@samsung.com>
 <201109171254.49003.laurent.pinchart@ideasonboard.com>
 <4E748D82.8040006@gmail.com>
 <201109190102.04870.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2011 01:02 AM, Laurent Pinchart wrote:
> On Saturday 17 September 2011 14:07:30 Sylwester Nawrocki wrote:
>> On 09/17/2011 12:54 PM, Laurent Pinchart wrote:
>>> On Friday 16 September 2011 19:28:42 Sylwester Nawrocki wrote:
>>>> HREF is a signal indicating valid data during single line transmission.
>>>> Add corresponding flags for this signal to the set of mediabus signal
>>>> polarity flags.
>>>
>>> So that's a data valid signal that gates the pixel data ? The OMAP3 ISP
>>> has a
>>
>> Yes, it's "horizontal window reference" signal, it's well described in this
>> datasheet: http://www.morninghan.com/pdf/OV2640FSL_DS_(1_3).pdf
> 
> In that specific case I would likely connect to HREF signal to the ISP HSYNC 
> signal and ignore the sensor HSYNC signal completely :-)
> 
>> AFAICS there can be also its vertical counterpart - VREF.
> 
> OK, your HREF signal is thus completely unrelated to my DVAL signal. DVAL 
> really qualifies pixel. For instance, if the sensor outputs pixels at half the 
> pixel rate, DVAL would switch at every pixel clock cycle during a line.

Yeah, sounds it's entirely different.

> 
>> Many devices seem to use this terminology. However, I realize, not all, as
>> you're pointing out. So perhaps it's time for some naming contest now..
>> :-)
>>
>>> similar signal called WEN, and I've seen other chips using DVAL. Your
>>> patch looks good to me, except maybe for the signal name that could be
>>> made a bit more explicit (I'm not sure what most chips use though).
>>
>> I'm pretty OK with HREF/VREF. But I'm open to any better suggestions.
>>
>> Maybe
>>
>> V4L2_MBUS_LINE_VALID_ACTIVE_HIGH
>> V4L2_MBUS_LINE_VALID_ACTIVE_LOW
>>
>> V4L2_MBUS_FRAME_VALID_ACTIVE_HIGH
>> V4L2_MBUS_FRAME_VALID_ACTIVE_LOW
>>
>> ?
>> Some of Aptina sensor datasheets describes those signals as
>> LINE_VALID/FRAME_VALID, (www.aptina.com/assets/downloadDocument.do?id=76).
> 
> LINE_VALID/FRAME_VALID are HSYNC/VSYNC.

I would say these are rather inverted horizontal/vertical blanking signal.

> 
>>>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>> ---
>>>>
>>>>   include/media/v4l2-mediabus.h |   14 ++++++++------
>>>>   1 files changed, 8 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/include/media/v4l2-mediabus.h
>>>> b/include/media/v4l2-mediabus.h index 6114007..41d8771 100644
>>>> --- a/include/media/v4l2-mediabus.h
>>>> +++ b/include/media/v4l2-mediabus.h
>>>> @@ -26,12 +26,14 @@
>>>>
>>>>   /* Note: in BT.656 mode HSYNC and VSYNC are unused */
>>
>> I've forgotten to update this:
>>
>> /* Note: in BT.656 mode HSYNC, HREF and VSYNC are unused */
>>
>>>>   #define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1<<  2)
>>>>   #define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1<<  3)
>>>>
>>>> -#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1<<  4)
>>>> -#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1<<  5)
>>>> -#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1<<  6)
>>>> -#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1<<  7)
>>>> -#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1<<  8)
>>>> -#define V4L2_MBUS_DATA_ACTIVE_LOW		(1<<  9)
>>>> +#define V4L2_MBUS_HREF_ACTIVE_HIGH		(1<<  4)
>>>> +#define V4L2_MBUS_HREF_ACTIVE_LOW		(1<<  5)
>>>> +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1<<  6)
>>>> +#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1<<  7)
>>>> +#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1<<  8)
>>>> +#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1<<  9)
>>>> +#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1<<  10)
>>>> +#define V4L2_MBUS_DATA_ACTIVE_LOW		(1<<  11)
> 

Thanks
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
