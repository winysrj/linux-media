Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64948 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab2IYQas (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 12:30:48 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAW00DDEZ7Z9410@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 17:31:11 +0100 (BST)
Received: from [106.116.147.108] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MAW004W5Z79WG60@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 17:30:46 +0100 (BST)
Message-id: <5061DC33.9090307@samsung.com>
Date: Tue, 25 Sep 2012 18:30:43 +0200
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
 <1344958496-9373-19-git-send-email-t.stanislaws@samsung.com>
 <201208221341.06056.hverkuil@xs4all.nl>
In-reply-to: <201208221341.06056.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank you for review.
Please refer to the comments below.

On 08/22/2012 01:41 PM, Hans Verkuil wrote:
> On Tue August 14 2012 17:34:48 Tomasz Stanislawski wrote:
>> This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
>> descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
>> mmap and return a file descriptor on success.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/video/v4l2-compat-ioctl32.c |    1 +
>>  drivers/media/video/v4l2-dev.c            |    1 +
>>  drivers/media/video/v4l2-ioctl.c          |   15 +++++++++++++++
>>  include/linux/videodev2.h                 |   26 ++++++++++++++++++++++++++
>>  include/media/v4l2-ioctl.h                |    2 ++
>>  5 files changed, 45 insertions(+)
>>

[snip]

>> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
>> index dffd3c9..c4e8c7e 100644
>> --- a/drivers/media/video/v4l2-ioctl.c
>> +++ b/drivers/media/video/v4l2-ioctl.c
>> @@ -458,6 +458,14 @@ static void v4l_print_buffer(const void *arg, bool write_only)
>>  			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
>>  }
>>  
>> +static void v4l_print_exportbuffer(const void *arg, bool write_only)
>> +{
>> +	const struct v4l2_exportbuffer *p = arg;
>> +
>> +	pr_cont("fd=%d, mem_offset=%lx, flags=%lx\n",
>> +		p->fd, (unsigned long)p->mem_offset, (unsigned long)p->flags);
> 
> Why the unsigned long casts?
> 

It is needed to avoid compiler warnings on machines where "%lx" is not
compatible with u32.

>> +}
>> +
>>  static void v4l_print_create_buffers(const void *arg, bool write_only)
>>  {
>>  	const struct v4l2_create_buffers *p = arg;

[snip]

>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index 7f918dc..b5d058b 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -688,6 +688,31 @@ struct v4l2_buffer {
>>  #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
>>  #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
>>  
>> +/**
>> + * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
>> + *
>> + * @fd:		file descriptor associated with DMABUF (set by driver)
>> + * @mem_offset:	buffer memory offset as returned by VIDIOC_QUERYBUF in struct
>> + *		v4l2_buffer::m.offset (for single-plane formats) or
>> + *		v4l2_plane::m.offset (for multi-planar formats)
>> + * @flags:	flags for newly created file, currently only O_CLOEXEC is
>> + *		supported, refer to manual of open syscall for more details
>> + *
>> + * Contains data used for exporting a video buffer as DMABUF file descriptor.
>> + * The buffer is identified by a 'cookie' returned by VIDIOC_QUERYBUF
>> + * (identical to the cookie used to mmap() the buffer to userspace). All
>> + * reserved fields must be set to zero. The field reserved0 is expected to
>> + * become a structure 'type' allowing an alternative layout of the structure
>> + * content. Therefore this field should not be used for any other extensions.
>> + */
>> +struct v4l2_exportbuffer {
>> +	__u32		fd;
>> +	__u32		reserved0;
>> +	__u32		mem_offset;
>> +	__u32		flags;
>> +	__u32		reserved[12];
>> +};
> 
> OK, I realized that we also need a type field here: you need the type field
> (same as in v4l2_buffer) to know which queue the mem_offset refers to. For
> M2M devices you have two queues, so you need this information.

I do not agree with you. The mmap() does not need buffer_type.
So VIDIOC_EXPBUF should not need the field either.
Please refer to patch "[PATCHv8 26/26] v4l: s5p-mfc: support for dmabuf exporting"
for example how to deal without buffer_type.

> 
> Is there any reason not to use __u32 memory instead of __u32 reserved0?
> I really dislike 'reserved0'. It's also very inconsistent with the other
> buffer ioctls which all have type+memory fields.

The type is not needed for exporting if mem_offset is available like in mmap() case.
The memory is not needed because exporting is available only for MMAP buffers.

I see two ways to describe a buffer for exporting:
a) by mem_offset
b) by (buffer_type, index, plane_index) tuple

For know I prefer to implement only method (a) to avoid
"single vs. multi plane" madness. Moreover it guarantees
that only MMAP buffers are exported.

The second method assisted by VIDIOC_PREPARE_BUF will allow
userptr-to-dmabuf conversion or dmabuf reexporting.

> 
> Regarding mem_offset: I would prefer a union (possibly anonymous):

I prefer not to add anonymous unions (though I like them) because
the unions are not compatible with multiple C standards including C89.

> 
>         union {
>                 __u32           mem_offset;
>                 unsigned long   reserved;
>         } m;
> 
> Again, it's more consistent with the existing buffer ioctls, and it prepares
> the API for future pointer values. 'reserved' in the union above could even
> safely be renamed to userptr, even though userptr isn't supported at the
> moment.
> 

There is no guarantee that DMABUF could ever be created from user pointer.
IMO, there is little need for support for such a feature.
I prefer not to add any fields that to not immediately map to DMABUF
functionalities. Let's keep the structures simple for now.

Moreover I prefer not to add 'unsigned long' as union member because
the size of the union would be different on 32 and 64 bit machines.

The API is marked as experimental so it can change significantly.

Regards,
Tomasz Stanislawski

