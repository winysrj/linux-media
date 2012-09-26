Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42069 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2IZJzJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 05:55:09 -0400
Received: from eusync2.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAY00C4KBKPQ0A0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Sep 2012 10:55:37 +0100 (BST)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAY00ECCBJUDV80@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Sep 2012 10:55:07 +0100 (BST)
Message-id: <5062D0F7.8000605@samsung.com>
Date: Wed, 26 Sep 2012 11:55:03 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	dmitriyz@google.com, s.nawrocki@samsung.com, k.debski@samsung.com
Subject: Re: [PATCHv8 18/26] v4l: add buffer exporting via dmabuf
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
 <201208221341.06056.hverkuil@xs4all.nl> <5061DC33.9090307@samsung.com>
 <201209260839.42998.hverkuil@xs4all.nl>
In-reply-to: <201209260839.42998.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank your for your comments.

On 09/26/2012 08:39 AM, Hans Verkuil wrote:
> On Tue September 25 2012 18:30:43 Tomasz Stanislawski wrote:
>> Hi Hans,
>> Thank you for review.
>> Please refer to the comments below.
>>
>> On 08/22/2012 01:41 PM, Hans Verkuil wrote:
>>> On Tue August 14 2012 17:34:48 Tomasz Stanislawski wrote:
>>>> This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
>>>> descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
>>>> mmap and return a file descriptor on success.
>>>>
>>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>  drivers/media/video/v4l2-compat-ioctl32.c |    1 +
>>>>  drivers/media/video/v4l2-dev.c            |    1 +
>>>>  drivers/media/video/v4l2-ioctl.c          |   15 +++++++++++++++
>>>>  include/linux/videodev2.h                 |   26 ++++++++++++++++++++++++++
>>>>  include/media/v4l2-ioctl.h                |    2 ++
>>>>  5 files changed, 45 insertions(+)
>>>>
>>
>> [snip]
>>
>>>> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
>>>> index dffd3c9..c4e8c7e 100644
>>>> --- a/drivers/media/video/v4l2-ioctl.c
>>>> +++ b/drivers/media/video/v4l2-ioctl.c
>>>> @@ -458,6 +458,14 @@ static void v4l_print_buffer(const void *arg, bool write_only)
>>>>  			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
>>>>  }
>>>>  
>>>> +static void v4l_print_exportbuffer(const void *arg, bool write_only)
>>>> +{
>>>> +	const struct v4l2_exportbuffer *p = arg;
>>>> +
>>>> +	pr_cont("fd=%d, mem_offset=%lx, flags=%lx\n",
>>>> +		p->fd, (unsigned long)p->mem_offset, (unsigned long)p->flags);
>>>
>>> Why the unsigned long casts?
>>>
>>
>> It is needed to avoid compiler warnings on machines where "%lx" is not
>> compatible with u32.
> 
> Why not use %x instead of %lx?
> 

Ok. '%x' or '%08x' should be compatible with u32.
Hopefully, no one is using V4L2 on 16-bit machines :).

>>>> +}
>>>> +
>>>>  static void v4l_print_create_buffers(const void *arg, bool write_only)
>>>>  {
>>>>  	const struct v4l2_create_buffers *p = arg;
>>
>> [snip]
>>
>>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>>> index 7f918dc..b5d058b 100644
>>>> --- a/include/linux/videodev2.h
>>>> +++ b/include/linux/videodev2.h
>>>> @@ -688,6 +688,31 @@ struct v4l2_buffer {
>>>>  #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
>>>>  #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
>>>>  
>>>> +/**
>>>> + * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
>>>> + *
>>>> + * @fd:		file descriptor associated with DMABUF (set by driver)
>>>> + * @mem_offset:	buffer memory offset as returned by VIDIOC_QUERYBUF in struct
>>>> + *		v4l2_buffer::m.offset (for single-plane formats) or
>>>> + *		v4l2_plane::m.offset (for multi-planar formats)
>>>> + * @flags:	flags for newly created file, currently only O_CLOEXEC is
>>>> + *		supported, refer to manual of open syscall for more details
>>>> + *
>>>> + * Contains data used for exporting a video buffer as DMABUF file descriptor.
>>>> + * The buffer is identified by a 'cookie' returned by VIDIOC_QUERYBUF
>>>> + * (identical to the cookie used to mmap() the buffer to userspace). All
>>>> + * reserved fields must be set to zero. The field reserved0 is expected to
>>>> + * become a structure 'type' allowing an alternative layout of the structure
>>>> + * content. Therefore this field should not be used for any other extensions.
>>>> + */
>>>> +struct v4l2_exportbuffer {
>>>> +	__u32		fd;
>>>> +	__u32		reserved0;
>>>> +	__u32		mem_offset;
>>>> +	__u32		flags;
>>>> +	__u32		reserved[12];
>>>> +};
>>>
>>> OK, I realized that we also need a type field here: you need the type field
>>> (same as in v4l2_buffer) to know which queue the mem_offset refers to. For
>>> M2M devices you have two queues, so you need this information.
>>
>> I do not agree with you. The mmap() does not need buffer_type.
>> So VIDIOC_EXPBUF should not need the field either.
>> Please refer to patch "[PATCHv8 26/26] v4l: s5p-mfc: support for dmabuf exporting"
>> for example how to deal without buffer_type.
>>
>>>
>>> Is there any reason not to use __u32 memory instead of __u32 reserved0?
>>> I really dislike 'reserved0'. It's also very inconsistent with the other
>>> buffer ioctls which all have type+memory fields.
>>
>> The type is not needed for exporting if mem_offset is available like in mmap() case.
>> The memory is not needed because exporting is available only for MMAP buffers.
> 
> Today, yes. Perhaps not in the future. mem_offset uniquely identifies a buffer,
> but only in the MMAP case. That happens to be the only one we support at the
> moment, but in the future we might want to support others as well.
> 
>> I see two ways to describe a buffer for exporting:
>> a) by mem_offset
>> b) by (buffer_type, index, plane_index) tuple
> 
> Actually a (buffer_type, index, plane_index, memory) tuple.
> 

Why the memory goes into the tuple?
Is it possible that the queue can work in two modes at the same time?
Is it possible that userptr and mmap buffers both with index 0 can coexist
at the same queue?

IMO, currently the memory is  a parameter of a V4L queue, not buffer's.
In time, the field may become a buffer parameter if VIDIOC_CREATE_BUFS
would permit a creation of buffers with different memory modes.
Anyway, the memory would become only a parameter of a buffer.
Similar to 'length' or 'sequence' or etc.
As I understand, the memory field is used for v4l2_buffer only to
inform which members of 'union m' should be copied to/from the userspace
by V4L middle layer operation between ioctl() and a driver.

>>
>> For know I prefer to implement only method (a) to avoid
>> "single vs. multi plane" madness. Moreover it guarantees
>> that only MMAP buffers are exported.
> 
> You see that as an advantage, I see that as a disadvantage. Because b is more
> future-proof than a. And while you need to provide more information, you do
> have that information available anyway in struct v4l2_buffer. It's the same
> information we use in any of the other streaming I/O ioctls, and I really
> like that consistency.
> 

I agree that proposition (b) is more future-proof.
Bad news is that implementing it implies significant changes to vb2-dmabuf code
and documentation. It will postpone v9 which is already late.
However, it is better to sacrifice some time on doing things right.
I will start modifications now.

Does the structure layout suit you?

struct v4l2_exportbuffer {
	s32	fd;
	u32	reserved0; /* place for export-mode if some fields below become a union */
	u32	type; /* enum v4l2_buf_type */
	u32	index;
	u32	plane;
	u32	reserved[10];
	u32	flags;
};


>> The second method assisted by VIDIOC_PREPARE_BUF will allow
>> userptr-to-dmabuf conversion or dmabuf reexporting.
>>
>>>
>>> Regarding mem_offset: I would prefer a union (possibly anonymous):
>>
>> I prefer not to add anonymous unions (though I like them) because
>> the unions are not compatible with multiple C standards including C89.
>>
>>>
>>>         union {
>>>                 __u32           mem_offset;
>>>                 unsigned long   reserved;
>>>         } m;
>>>
>>> Again, it's more consistent with the existing buffer ioctls, and it prepares
>>> the API for future pointer values. 'reserved' in the union above could even
>>> safely be renamed to userptr, even though userptr isn't supported at the
>>> moment.
>>>
>>
>> There is no guarantee that DMABUF could ever be created from user pointer.
> 
> There is no guarantee that it could never be created from a user pointer either.
> Or some other newer memory type that doesn't exist yet.
> 
>> IMO, there is little need for support for such a feature.
>> I prefer not to add any fields that to not immediately map to DMABUF
>> functionalities. Let's keep the structures simple for now.
>>
>> Moreover I prefer not to add 'unsigned long' as union member because
>> the size of the union would be different on 32 and 64 bit machines.
> 
> Well, that's the point. sizeof(unsigned long) == sizeof(void *)
> You could also write 'void *reserved;', as long as we can stick a pointer
> in there.
> 

The problem is that the size of void* varies on different architectures.
The u64 can always store void*, it has a fixed size and should be
sufficient for at least 50 years :).

>> The API is marked as experimental so it can change significantly.
> 
> If we ever add new memory types or userptr dmabuf support, then that's
> most likely a long time in the future. By that time the experimental status
> of the API is surely revoked. So we need to do this right the first time.
> One reason the V4L2 API has scaled so well for the most part is due to the
> fact that the original designers were very conscious of the fact that the API
> should be as future proof as possible. We should follow that.
> 
> So instead of thinking of this ioctl as "exporting an mmaped buffer", think
> of it as "exporting a buffer". The first will work today, the second will
> work in the future as well.
> 
> Regards,
> 
> 	Hans
> 

Regards,
Tomasz Stanislawski

