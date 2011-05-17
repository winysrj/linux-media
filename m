Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:19488 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab1EQFt1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 01:49:27 -0400
Message-ID: <4DD20D1C.4020808@maxwell.research.nokia.com>
Date: Tue, 17 May 2011 08:52:28 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer
 management
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104011010530.9530@axis700.grange> <Pine.LNX.4.64.1105121835370.24486@axis700.grange> <4DD12784.2000100@maxwell.research.nokia.com> <Pine.LNX.4.64.1105162144200.29373@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105162144200.29373@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Guennadi Liakhovetski wrote:
> Hi Sakari

Hi Guennadi,

[clip]

>>>>  		bool valid_prio = true;
>>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>>> index aa6c393..b6ef46e 100644
>>>> --- a/include/linux/videodev2.h
>>>> +++ b/include/linux/videodev2.h
>>>> @@ -1847,6 +1847,26 @@ struct v4l2_dbg_chip_ident {
>>>>  	__u32 revision;    /* chip revision, chip specific */
>>>>  } __attribute__ ((packed));
>>>>  
>>>> +/* VIDIOC_DESTROY_BUFS */
>>>> +struct v4l2_buffer_span {
>>>> +	__u32			index;	/* output: buffers index...index + count - 1 have been created */
>>>> +	__u32			count;
>>>> +	__u32			reserved[2];
>>>> +};
>>>> +
>>>> +/* struct v4l2_createbuffers::flags */
>>>> +#define V4L2_BUFFER_FLAG_NO_CACHE_INVALIDATE	(1 << 0)
>>>
>>> 1. An additional flag FLAG_NO_CACHE_FLUSH is needed for output devices.
>>
>> Should this be called FLAG_NO_CACHE_CLEAN?
>>
>> Invalidate == Make contents of the cache invalid
>>
>> Clean == Make sure no dirty stuff resides in the cache
> 
> and mark it clean?...
> 
>> Flush == invalidate + clean
> 
> Maybe you meant "first clean, then invalidate?"
> 
> In principle, I think, yes, CLEAN would define it more strictly.

Yes; I'd prefer that. :-)

>> It occurred to me to wonder if two flags are needed for this, but I
>> think the answer is yes, since there can be memory-to-memory devices
>> which are both OUTPUT and CAPTURE.
>>
>>> 2. Both these flags should not be passed with CREATE, but with SUBMIT 
>>> (which will be renamed to PREPARE or something similar). It should be 
>>> possible to prepare the same buffer with different cacheing attributes 
>>> during a running operation. Shall these flags be added to values, taken by 
>>> struct v4l2_buffer::flags, since that is the struct, that will be used as 
>>> the argument for the new version of the SUBMIT ioctl()?
>>>
>>>> +
>>>> +/* VIDIOC_CREATE_BUFS */
>>>> +struct v4l2_create_buffers {
>>>> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
>>>> +	__u32			count;
>>>> +	__u32			flags;		/* V4L2_BUFFER_FLAG_* */
>>>> +	enum v4l2_memory        memory;
>>>> +	__u32			size;		/* Explicit size, e.g., for compressed streams */
>>>> +	struct v4l2_format	format;		/* "type" is used always, the rest if size == 0 */
>>>> +};
>>>
>>> 1. Care must be taken to keep index <= V4L2_MAX_FRAME
>>
>> This will make allocating new ranges of buffers impossible if the
>> existing buffer indices are scattered within the range.
>>
>> What about making it possible to pass an array of buffer indices to the
>> user, just like VIDIOC_S_EXT_CTRLS does? I'm not sure if this would be
>> perfect, but it would avoid the problem of requiring continuous ranges
>> of buffer ids.
>>
>> struct v4l2_create_buffers {
>> 	__u32			*index;
>> 	__u32			count;
>> 	__u32			flags;
>> 	enum v4l2_memory        memory;
>> 	__u32			size;
>> 	struct v4l2_format	format;
>> };
>>
>> Index would be a pointer to an array of buffer indices and its length
>> would be count.
> 
> I don't understand this. We do _not_ want to allow holes in indices. For 
> now we decide to not implement DESTROY at all. In this case indices just 
> increment contiguously.
> 
> The next stage is to implement DESTROY, but only in strict reverse order - 
> without holes and in the same ranges, as buffers have been CREATEd before. 
> So, I really don't understand why we need arrays, sorry.

Well, now that we're defining a second interface to make new buffer
objects, I just thought it should be made as future-proof as we can. But
even with single index, it's always possible to issue the ioctl more
than once and achieve the same result as if there was an array of indices.

What would be the reason to disallow creating holes to index range? I
don't see much reason from application or implementation point of view,
as we're even being limited to such low numbers.

Speaking of which; perhaps I'm bringing this up rather late, but should
we define the API to allow larger numbers than VIDEO_MAX_FRAME? 32 isn't
all that much after all --- this might become a limiting factor later on
when there are devices with huge amounts of memory.

Allowing CREATE_BUF to do that right now would be possible since
applications using it are new users and can be expected to be using it
properly. :-)

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
