Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39731 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaIIOpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 10:45:43 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBN004L32GVYPC0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Sep 2014 15:48:31 +0100 (BST)
Message-id: <540F127D.4020300@samsung.com>
Date: Tue, 09 Sep 2014 16:45:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Clarify RGB666 pixel format definition
References: <1405975150-9256-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1479223.veAhoGoXLY@avalon> <53CD97D2.1010408@xs4all.nl>
 <1468017.Vb1L5kusHW@avalon>
In-reply-to: <1468017.Vb1L5kusHW@avalon>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/14 15:18, Laurent Pinchart wrote:
> On Tuesday 22 July 2014 00:44:34 Hans Verkuil wrote:
>> On 07/22/2014 12:30 AM, Laurent Pinchart wrote:
>>> On Monday 21 July 2014 23:43:16 Hans Verkuil wrote:
>>>> On 07/21/2014 10:39 PM, Laurent Pinchart wrote:
>>>>> The RGB666 pixel format doesn't include an alpha channel. Document it as
>>>>> such.
>>>>>
>>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>> ---
>>>>>
>>>>>  .../DocBook/media/v4l/pixfmt-packed-rgb.xml          | 20
>>>>>  +++++----------
>>>>>
>>>>> 1 file changed, 6 insertions(+), 14 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
>>>>> b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml index
>>>>> 32feac9..c47692a 100644
>>>>> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
>>>>> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
>>>>> @@ -330,20 +330,12 @@ colorspace
>>>>> <constant>V4L2_COLORSPACE_SRGB</constant>.</para>>
>>>>>  	    <entry></entry>
>>>>>  	    <entry>r<subscript>1</subscript></entry>
>>>>>  	    <entry>r<subscript>0</subscript></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> -	    <entry></entry>
>>>>> +	    <entry>-</entry>
>>>>> +	    <entry>-</entry>
>>>>> +	    <entry>-</entry>
>>>>> +	    <entry>-</entry>
>>>>> +	    <entry>-</entry>
>>>>> +	    <entry>-</entry>
>>>>
>>>> Just to clarify: BGR666 is a three byte format, not a four byte format?
>>>
>>> Well... :-)
>>>
>>> Three drivers seem to support the BGR666 in mainline : sh_veu, s3c-camif
>>> and exynos4-is. Further investigation shows that the sh_veu driver lists
>>> the BGR666 format internally but doesn't expose it to userspace and
>>> doesn't actually support it, so we're down to two drivers.
>>>
>>> Looking at the S3C6410 datasheet, it's unclear how the hardware stores
>>> RGB666 pixels in memory. It could be either
>>>
>>> Byte 0   Byte 1   Byte 2   Byte 3
>>>
>>> -------- ------RR RRRRGGGG GGBBBBBB
>>>
>>> or
>>>
>>> GGBBBBBB RRRRGGGG ------RR --------
>>>
>>> None of those correspond to the RGB666 format defined in the spec.
>>>
>>> The Exynos4 FIMC isn't documented in the public datasheet, so I can't
>>> check how the format is defined.
>>>
>>> Furthermore, various Renesas video-related IP cores support many different
>>> RGB666 variants, on either 32 or 24 bits per pixel, with and without
>>> alpha.
>>>
>>> Beside a loud *sigh*, any comment ? :-)
>>
>> You'll have to check with Samsung then. Sylwester, can you shed any light on
>> what this format *really* is?
> 
> Ping ?

My apologies, I didn't notice this earlier.

In case of S5P/Exynos FIMC the format is:

Byte 0   Byte 1   Byte 2   Byte 3

BBBBBBGG GGGGRRRR RR------ --------

i.e. 4 byte per pixel, with 14-bit padding (don't care bits).

As far as S3C6410 CAMIF is concerned it's hard to say. I primarily
developed the s3c-camif driver for S3C2440 SoC, which doesn't support
BGR666 format. I merged some patches from others adding s3c6410 support,
before sending upstream.

Nevertheless, looking at the S3C CAMIF datasheet the RGB666 format seems
identical with the FIMC one. See [1], chapter "20.7.4 MEMORY STORING
METHOD". This would make sense, since the S5P/Exynos FIMC is basically
a significantly evolved S3C CAMIF AFAICT.

--
Regards,
Sylwester

[1] http://www.arm9board.net/download/OK6410/docs/S3C6410X.pdf
