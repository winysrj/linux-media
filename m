Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27152 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab2HAIBu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 04:01:50 -0400
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8200FSNGZR5N50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Aug 2012 09:02:15 +0100 (BST)
Received: from [106.116.147.108] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M8200C53GYZQQ40@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Aug 2012 09:01:48 +0100 (BST)
Message-id: <5018E269.5060200@samsung.com>
Date: Wed, 01 Aug 2012 10:01:45 +0200
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
 <201207310833.56566.hverkuil@xs4all.nl> <36319543.mdnBULUSen@avalon>
 <201207311411.06974.hverkuil@xs4all.nl>
In-reply-to: <201207311411.06974.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 07/31/2012 02:11 PM, Hans Verkuil wrote:
> On Tue 31 July 2012 13:56:14 Laurent Pinchart wrote:
>> Hi Hans,
>>
>> On Tuesday 31 July 2012 08:33:56 Hans Verkuil wrote:
>>> On Thu June 14 2012 16:32:23 Tomasz Stanislawski wrote:
>>>> +/**
>>>> + * struct v4l2_exportbuffer - export of video buffer as DMABUF file
>>>> descriptor + *
>>>> + * @fd:		file descriptor associated with DMABUF (set by driver)
>>>> + * @mem_offset:	buffer memory offset as returned by VIDIOC_QUERYBUF in
>>>> struct + *		v4l2_buffer::m.offset (for single-plane formats) or
>>>> + *		v4l2_plane::m.offset (for multi-planar formats)
>>>> + * @flags:	flags for newly created file, currently only O_CLOEXEC is
>>>> + *		supported, refer to manual of open syscall for more details
>>>> + *
>>>> + * Contains data used for exporting a video buffer as DMABUF file
>>>> descriptor. + * The buffer is identified by a 'cookie' returned by
>>>> VIDIOC_QUERYBUF + * (identical to the cookie used to mmap() the buffer to
>>>> userspace). All + * reserved fields must be set to zero. The field
>>>> reserved0 is expected to + * become a structure 'type' allowing an
>>>> alternative layout of the structure + * content. Therefore this field
>>>> should not be used for any other extensions. + */
>>>> +struct v4l2_exportbuffer {
>>>> +	__u32		fd;
>>>> +	__u32		reserved0;
>>>> +	__u32		mem_offset;
>>>
>>> This should be a union identical to the m union in v4l2_plane, together with
>>> a u32 memory field. That way you can just copy memory and m from
>>> v4l2_plane/buffer and call expbuf. If new memory types are added in the
>>> future, then you don't need to change this struct.
>>
>> OK, reserved0 could be replace by __u32 memory. Could we have other dma-buf 
>> export types in the future not corresponding to a memory type ? I don't see 
>> any use case right now though.
> 
> The memory type should be all you need. And the union is also needed since the
> userptr value is unsigned long, thus ensuring that you have 64-bits available
> for pointer types in the future. That's really my main point: the union should
> have the same size as the union in v4l2_buffer/plane, allowing for the same
> size pointers or whatever to be added in the future.
> 

I do not see any good point in using v4l2_plane. What would be the meaning
of bytesused, length, data_offset in case of DMABUF exporting?

The field reserved0 was introduced to be replaced by __u32 memory if other means
of buffer description would be needed. The reserved fields at the end of
the structure could be used for auxiliary parameters other then offset and flags.
The flags field is expected to be used by all exporting types therefore the
layout could be reorganized to:

struct v4l2_exportbuffers {
	__u32	fd;
	__u32	flags;
	__u32	reserved0[2]; /* place for '__u32 memory' + forcing 64 bit alignment */
	__u32	mem_offset; /* what do you thing about using 64-bit field? */
	__u32	reserved1[11];
};

What is your opinion about this idea?

>>> For that matter, wouldn't it be useful to support exporting a userptr buffer
>>> at some point in the future?
>>
>> Shouldn't USERPTR usage be discouraged once we get dma-buf support ?
> 
> Why? It's perfectly fine to use it and it's not going away.
> 
> I'm not saying that we should support exporting a userptr buffer as a dmabuf fd,
> but I'm just wondering if that is possible at all and how difficult it would be.

It would be difficult. Currently there is no safe/portable way to transform
a userptr into a scatterlist mappable for other devices. The most trouble
some examples are userspace-mapping of IO memory like framebuffers.
How reference management is going to work if there are no struct pages
describing mapped memory?

The VB2 uses a workaround by keeping a copy of vma that is used to call
open/close callbacks. I am not sure how reliable this solution is.

Who knows, maybe in future someone will introduce a mechanism for creation of
DMABUF descriptor from a userptr without any help of client APIs.
In such a case, it will be the part of DMABUF api not V4L2 :).

Regards,
Tomasz Stanislawski

> 
> Regards,
> 
> 	Hans
> 
>>
>>> BTW, this patch series needs to be rebased to the latest for_v3.6. Quite a
>>> few core things have changed when it comes to adding new ioctls.
>>
>>

