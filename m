Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:38800 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab1ERR7x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 13:59:53 -0400
Message-ID: <4DD409CF.4020901@maxwell.research.nokia.com>
Date: Wed, 18 May 2011 21:02:55 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer
 management
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104011010530.9530@axis700.grange> <Pine.LNX.4.64.1105121835370.24486@axis700.grange> <201105181559.09194.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1105181649590.16324@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105181649590.16324@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Guennadi Liakhovetski wrote:
> On Wed, 18 May 2011, Laurent Pinchart wrote:
> 
>> On Friday 13 May 2011 09:45:51 Guennadi Liakhovetski wrote:
> 
> [snip]
> 
>>> 2. Both these flags should not be passed with CREATE, but with SUBMIT
>>> (which will be renamed to PREPARE or something similar). It should be
>>> possible to prepare the same buffer with different cacheing attributes
>>> during a running operation. Shall these flags be added to values, taken by
>>> struct v4l2_buffer::flags, since that is the struct, that will be used as
>>> the argument for the new version of the SUBMIT ioctl()?
>>
>> Do you have a use case for per-submit cache handling ?
> 
> This was Sakari's idea, I think, ask him;) But I think, he suggested a 
> case, when not all buffers have to be processed in the user-space. In 
> principle, I can imagine such a case too. E.g., if most of the buffers you 
> pass directly to output / further processing, and only some of them you 
> analyse in software, perhaps, for some WB, exposure, etc.

Yes; I think I mentioned this. It's possible that some rather
CPU-intensive processing is only done on the CPU on every n:th image,
for example. In this case flushing the cache on images that won't be
touched by the CPU is not necessary.

>>>> +
>>>> +/* VIDIOC_CREATE_BUFS */
>>>> +struct v4l2_create_buffers {
>>>> +	__u32			index;		/* output: buffers index...index + count - 1 have 
>> been
>>>> created */ +	__u32			count;
>>>> +	__u32			flags;		/* V4L2_BUFFER_FLAG_* */
>>>> +	enum v4l2_memory        memory;
>>>> +	__u32			size;		/* Explicit size, e.g., for compressed streams */
>>>> +	struct v4l2_format	format;		/* "type" is used always, the rest if 
>> size
>>>> == 0 */ +};
>>>
>>> 1. Care must be taken to keep index <= V4L2_MAX_FRAME
>>
>> Does that requirement still make sense ?
> 
> Don't know, again, not my idea. videobuf2-core still uses it. At one 
> location it seems to be pretty arbitrary, at another it is the size of an 
> array in struct vb2_fileio_data, but maybe we could allocate that one 
> dynamically too. So, do I understand it right, that this would affect our 
> case, if we would CREATE our buffers and then the user would decide to do 
> read() / write() on them?

My issue with this number, as I gave it a little more thought, is that
it is actually quite low. The devices will have more memory in the
future and 32 might become a real limitation. I think it would be wise
to define the API so that the number of simultaneous buffers allocated
on a device is not limited by this number.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
