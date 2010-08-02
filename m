Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34932 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0HBIiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 04:38:54 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L6I00DL7O0SX0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Aug 2010 09:38:52 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6I006GUO0RSG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Aug 2010 09:38:52 +0100 (BST)
Date: Mon, 02 Aug 2010 10:37:14 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v5 1/3] v4l: Add multi-planar API definitions to the V4L2
 API
In-reply-to: <201008011414.49302.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>
Message-id: <002801cb321d$e85ed300$b91c7900$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1280479783-23945-1-git-send-email-p.osciak@samsung.com>
 <1280479783-23945-2-git-send-email-p.osciak@samsung.com>
 <201008011414.49302.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
thank you for the review.

>Hans Verkuil <hverkuil@xs4all.nl> wrote:
>On Friday 30 July 2010 10:49:41 Pawel Osciak wrote:

<snip>

>> @@ -157,9 +158,23 @@ enum v4l2_buf_type {
>>  	/* Experimental */
>>  	V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
>>  #endif
>> +	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 17,
>> +	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 18,
>
>Why 17 and 18 instead of 9 and 10?
>

To be able to test for "mplane" versions with a bit operation,
(type & 0x10), and to leave some space for future extensions
to "old" formats. I can go back to 9, 10 though if you prefer.


>> + *
>> + * Multi-planar buffers consist of one or more planes, e.g. an YCbCr
>buffer
>> + * with two planes can have one plane for Y, and another for interleaved
>CbCr
>> + * components. Each plane can reside in a separate memory buffer, or even
>in
>> + * a completely separate memory node (e.g. in embedded devices).
>> + */
>> +struct v4l2_plane {
>> +	__u32			bytesused;
>> +	__u32			length;
>> +	union {
>> +		__u32		mem_offset;
>> +		unsigned long	userptr;
>> +	} m;
>> +	__u32			data_offset;
>> +	__u32			reserved[11];
>> +};
>> +
>> +/**
>> + * struct v4l2_buffer - video buffer info
>> + * @index:	id number of the buffer
>> + * @type:	buffer type (type == *_MPLANE for multiplanar buffers)
>> + * @bytesused:	number of bytes occupied by data in the buffer (payload);
>> + * 		unused (set to 0) for multiplanar buffers
>> + * @flags:	buffer informational flags
>> + * @field:	field order of the image in the buffer
>> + * @timestamp:	frame timestamp
>> + * @timecode:	frame timecode
>> + * @sequence:	sequence count of this frame
>> + * @memory:	the method, in which the actual video data is passed
>> + * @offset:	for non-multiplanar buffers with memory ==
>V4L2_MEMORY_MMAP;
>> + * 		offset from the start of the device memory for this plane,
>> + * 		(or a "cookie" that should be passed to mmap() as offset)
>> + * @userptr:	for non-multiplanar buffers with memory ==
>V4L2_MEMORY_USERPTR;
>> + * 		a userspace pointer pointing to this buffer
>> + * @planes:	for multiplanar buffers; userspace pointer to the array
>of plane
>> + * 		info structs for this buffer
>> + * @length:	size in bytes of the buffer (NOT its payload) for single-
>plane
>> + * 		buffers (when type != *_MPLANE); number of planes (and number
>> + * 		of elements in the planes array) for multi-plane buffers
>
>This is confusing. Just write "number of elements in the planes array".
>
>> + * @input:	input number from which the video data has has been captured
>> + *
>> + * Contains data exchanged by application and driver using one of the
>Streaming
>> + * I/O methods.
>> + */
>>  struct v4l2_buffer {
>>  	__u32			index;
>>  	enum v4l2_buf_type      type;
>> @@ -529,6 +606,7 @@ struct v4l2_buffer {
>>  	union {
>>  		__u32           offset;
>>  		unsigned long   userptr;
>> +		struct v4l2_plane *planes;
>
>Should use the __user attribute.
>

We discussed this already, just for others: since we use the "planes" pointer
both as __user and kernel pointer, it's not worth it. We'd have to do some
obscure #ifdef magic and redefine the struct for parts of kernel code.
The same thing goes for controls pointer in v4l2_ext_controls.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


