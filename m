Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3425 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab0HBJA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 05:00:59 -0400
Message-ID: <ab15fd1bc1548120c62404c3bab9280e.squirrel@webmail.xs4all.nl>
In-Reply-To: <002801cb321d$e85ed300$b91c7900$%osciak@samsung.com>
References: <1280479783-23945-1-git-send-email-p.osciak@samsung.com>
    <1280479783-23945-2-git-send-email-p.osciak@samsung.com>
    <201008011414.49302.hverkuil@xs4all.nl>
    <002801cb321d$e85ed300$b91c7900$%osciak@samsung.com>
Date: Mon, 2 Aug 2010 11:00:47 +0200
Subject: RE: [PATCH v5 1/3] v4l: Add multi-planar API definitions to the
 V4L2 API
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Pawel Osciak" <p.osciak@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	"Marek Szyprowski" <m.szyprowski@samsung.com>,
	"Tomasz Fujak" <t.fujak@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel!

> Hi Hans,
> thank you for the review.
>
>>Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>On Friday 30 July 2010 10:49:41 Pawel Osciak wrote:
>
> <snip>
>
>>> @@ -157,9 +158,23 @@ enum v4l2_buf_type {
>>>  	/* Experimental */
>>>  	V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
>>>  #endif
>>> +	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 17,
>>> +	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 18,
>>
>>Why 17 and 18 instead of 9 and 10?
>>
>
> To be able to test for "mplane" versions with a bit operation,
> (type & 0x10), and to leave some space for future extensions
> to "old" formats. I can go back to 9, 10 though if you prefer.

I prefer 9, 10. I would agree with you if there was some sort
of numbering scheme already, but it is just an enum with no particular
order.

>
>
>>> + *
>>> + * Multi-planar buffers consist of one or more planes, e.g. an YCbCr
>>buffer
>>> + * with two planes can have one plane for Y, and another for
>>> interleaved
>>CbCr
>>> + * components. Each plane can reside in a separate memory buffer, or
>>> even
>>in
>>> + * a completely separate memory node (e.g. in embedded devices).
>>> + */
>>> +struct v4l2_plane {
>>> +	__u32			bytesused;
>>> +	__u32			length;
>>> +	union {
>>> +		__u32		mem_offset;
>>> +		unsigned long	userptr;
>>> +	} m;
>>> +	__u32			data_offset;
>>> +	__u32			reserved[11];
>>> +};
>>> +
>>> +/**
>>> + * struct v4l2_buffer - video buffer info
>>> + * @index:	id number of the buffer
>>> + * @type:	buffer type (type == *_MPLANE for multiplanar buffers)
>>> + * @bytesused:	number of bytes occupied by data in the buffer
>>> (payload);
>>> + * 		unused (set to 0) for multiplanar buffers
>>> + * @flags:	buffer informational flags
>>> + * @field:	field order of the image in the buffer
>>> + * @timestamp:	frame timestamp
>>> + * @timecode:	frame timecode
>>> + * @sequence:	sequence count of this frame
>>> + * @memory:	the method, in which the actual video data is passed
>>> + * @offset:	for non-multiplanar buffers with memory ==
>>V4L2_MEMORY_MMAP;
>>> + * 		offset from the start of the device memory for this plane,
>>> + * 		(or a "cookie" that should be passed to mmap() as offset)
>>> + * @userptr:	for non-multiplanar buffers with memory ==
>>V4L2_MEMORY_USERPTR;
>>> + * 		a userspace pointer pointing to this buffer
>>> + * @planes:	for multiplanar buffers; userspace pointer to the array
>>of plane
>>> + * 		info structs for this buffer
>>> + * @length:	size in bytes of the buffer (NOT its payload) for single-
>>plane
>>> + * 		buffers (when type != *_MPLANE); number of planes (and number
>>> + * 		of elements in the planes array) for multi-plane buffers
>>
>>This is confusing. Just write "number of elements in the planes array".
>>
>>> + * @input:	input number from which the video data has has been
>>> captured
>>> + *
>>> + * Contains data exchanged by application and driver using one of the
>>Streaming
>>> + * I/O methods.
>>> + */
>>>  struct v4l2_buffer {
>>>  	__u32			index;
>>>  	enum v4l2_buf_type      type;
>>> @@ -529,6 +606,7 @@ struct v4l2_buffer {
>>>  	union {
>>>  		__u32           offset;
>>>  		unsigned long   userptr;
>>> +		struct v4l2_plane *planes;
>>
>>Should use the __user attribute.
>>
>
> We discussed this already, just for others: since we use the "planes"
> pointer
> both as __user and kernel pointer, it's not worth it. We'd have to do some
> obscure #ifdef magic and redefine the struct for parts of kernel code.
> The same thing goes for controls pointer in v4l2_ext_controls.

Indeed. This is also the reason why there is no __user in v4l2_ext_controls.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

