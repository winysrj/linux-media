Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42663 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2HAJfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 05:35:42 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8200ILELC7DE70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Aug 2012 10:36:07 +0100 (BST)
Received: from [106.116.147.108] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M8200FQ1LBEFF60@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Aug 2012 10:35:40 +0100 (BST)
Message-id: <5018F868.5000208@samsung.com>
Date: Wed, 01 Aug 2012 11:35:36 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
 <201207311411.06974.hverkuil@xs4all.nl> <5018E269.5060200@samsung.com>
 <201208011028.15947.hverkuil@xs4all.nl>
In-reply-to: <201208011028.15947.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

>>
>> I do not see any good point in using v4l2_plane. What would be the meaning
>> of bytesused, length, data_offset in case of DMABUF exporting?
>>
>> The field reserved0 was introduced to be replaced by __u32 memory if other means
>> of buffer description would be needed. The reserved fields at the end of
>> the structure could be used for auxiliary parameters other then offset and flags.
>> The flags field is expected to be used by all exporting types therefore the
>> layout could be reorganized to:
>>
>> struct v4l2_exportbuffers {
>> 	__u32	fd;
>> 	__u32	flags;
>> 	__u32	reserved0[2]; /* place for '__u32 memory' + forcing 64 bit alignment */
>> 	__u32	mem_offset; /* what do you thing about using 64-bit field? */
>> 	__u32	reserved1[11];
>> };
>>
>> What is your opinion about this idea?
> 
> You're missing the point of my argument. How does v4l2_buffer work currently: you
> have a memory field and a union. The memory field determines which field of the
> union is to be used. In order to be able to use VIDIOC_EXPBUF you need to be
> able to add new memory types in the future. Currently only MMAP makes sense here,
> so all you need is the offset, but in order to be able to support future memory
> types you need to make sure that you can extend v4l2_exportbuffers with the
> largest possible value that v4l2_buffers can contain in the union, and that's
> an unsigned long/pointer. That won't fit in the current proposal since there is only
> a u32.
> 
> So I would propose this:
> 
> struct v4l2_exportbuffers {
> 	__u32	fd;
> 	__u32	memory;
> 	union {
> 		__u32 mem_offset;
> 		void *reserved;	/* ensure that we can handle pointers in the future */
> 	} m;
> 	__u32	flags;
> 	__u32	reserved1[11];
> };

The layout about prevents adding any auxiliary fields other then mem_offset if
expbuf.memory == V4L2_MEMORY_MMAP. This could be fixed by the layout below
(it might be considered ugly by some people):

struct v4l2_exportbuffers {
	__u32	fd;
	__u32	flags;
	__u32	memory;
	__u32	reserved;
	union {
		struct v4l2_exportbyoffset {
			__u32	mem_offset;
			__u32	reserved[11];
		} byoffset;
		struct v4l2_exportbyuserptr {
			__u64	userptr;
			__u32	reserved[10];
		} byuserptr;
		__u32	reserved[12];
	};
};

Notice that the structure above in binary compatible with:

struct v4l2_exportbuffers {
 	__u32	fd;
 	__u32	flags;
 	__u32	reserved0[2];
 	__u32	mem_offset;
 	__u32	reserved1[11];
};

> 
> That way an application can just do:
> 
> 	struct v4l2_buffer buf;
> 	struct v4l2_exportbuffers expbuf;
> 
> 	expbuf.memory = buf.memory;
> 	memcpy(&expbuf.m, &buf.m, sizeof(expbuf.m));
> 
> and VIDIOC_EXPBUF will return an error if expbuf.memory != V4L2_MEMORY_MMAP.

The other question is if we should use V4L2_MEMORY_MMAP as expbuf.memory.
I think that new enums should be introduced for this purpose. Exporting is
very different from buffer requesting or queuing. One could envision
extension to VIDIOC_EXPBUF for exporting a buffer as entity different then
DMABUF file. In such a case, the fd and flags should go to a separate union.
This argument supports *not* using any v4l2_buffer related structs for VIDIOC_EXPBUF.
It should use its own structures. Likely, no extra structs are needed at the moment.

> 
> I was actually wondering whether it might not be an idea to pass a v4l2_buffer
> directly to VIDIOC_EXPBUF. In order to support that you would have to add fd
> fields to v4l2_buffer and v4l2_plane and those would be filled in by VIDIOC_EXPBUF.
> For the flags field in exportbuffers you would have to add new V4L2_BUF_FLAG_ flags.
> 
> That way you don't need to introduce a new struct and all planes are also
> automatically exported. It's just an idea...

One may not want to create DMABUF descriptors for all the planes.
The number of file descriptors is limited for the process.
Why creating file descriptor if they are going to closed or
(even worse) not used?

The mmap is called on each plane separately. So why VIDIOC_EXPBUF should
behave differently?

Regards,
Tomasz Stanislawski

