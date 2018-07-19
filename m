Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:55483 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727575AbeGSQgs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 12:36:48 -0400
Subject: Re: [PATCH 2/5] videodev.h: add PIX_FMT_FWHT for use with vicodec
To: Tom aan de Wiel <tom.aandewiel@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
References: <20180719121353.20021-1-hverkuil@xs4all.nl>
 <20180719121353.20021-3-hverkuil@xs4all.nl>
 <20180719131544.kxbwpzssskepwple@lanttu.localdomain>
 <d912d4c6-90ec-ed89-31fa-6a5243a7b0de@cisco.com>
 <20180719153900.mybhstbhiaegtunn@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8358997e-ec42-f813-4c60-a62202f5fb5f@xs4all.nl>
Date: Thu, 19 Jul 2018 17:52:55 +0200
MIME-Version: 1.0
In-Reply-To: <20180719153900.mybhstbhiaegtunn@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2018 05:39 PM, Sakari Ailus wrote:
> On Thu, Jul 19, 2018 at 03:20:22PM +0200, Hans Verkuil wrote:
>> On 07/19/18 15:15, sakari.ailus@iki.fi wrote:
>>> On Thu, Jul 19, 2018 at 02:13:50PM +0200, Hans Verkuil wrote:
>>>> From: Hans Verkuil <hansverk@cisco.com>
>>>>
>>>> Add a new pixelformat for the vicodec software codec using the
>>>> Fast Walsh Hadamard Transform.
>>>>
>>>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>>>
>>> Could you add documentation for this format, please?
>>>
>>
>> ??? It's part of the patch:
>>
>> diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
>> index abec03937bb3..e5419f046b59 100644
>> --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
>> +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
>> @@ -95,3 +95,10 @@ Compressed Formats
>>        - ``V4L2_PIX_FMT_HEVC``
>>        - 'HEVC'
>>        - HEVC/H.265 video elementary stream.
>> +    * .. _V4L2-PIX-FMT-FWHT:
>> +
>> +      - ``V4L2_PIX_FMT_FWHT``
>> +      - 'FWHT'
>> +      - Video elementary stream using a codec based on the Fast Walsh Hadamard
>> +        Transform. This codec is implemented by the vicodec ('Virtual Codec')
>> +	driver.
>>
>> Since the whole codec is implemented in the vicodec source I didn't think it
>> necessary to say more about it.
> 
> Oh, well. The source is there but user space developers shouldn't need to
> read it. OTOH it might be that they're also not the primary audience for
> this driver either. If there's a Wikipedia article you could refer to or
> such that'd be fine IMO, too.
> 
> Up to you.
> 

Tom,

Do you have a newer version of your document? If not, can I refer to the version
I have? If it can be put up at the linuxtv.org website, then that takes care of
the documentation.

Regards,

	Hans
