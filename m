Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55229 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JHJkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 05:40:42 -0400
Received: from eusync2.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBK0026RIWF0T80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Oct 2012 10:41:03 +0100 (BST)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBK00CMFIVRPYC0@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Oct 2012 10:40:40 +0100 (BST)
Message-id: <50729F95.70003@samsung.com>
Date: Mon, 08 Oct 2012 11:40:37 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: Re: [PATCHv9 18/25] v4l: add buffer exporting via dmabuf
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
 <201210051055.40904.hverkuil@xs4all.nl> <1481309.1Xrun8GG9o@avalon>
 <201210071617.03213.hverkuil@xs4all.nl>
In-reply-to: <201210071617.03213.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 10/07/2012 04:17 PM, Hans Verkuil wrote:
> On Sun October 7 2012 15:38:30 Laurent Pinchart wrote:
>> Hi Hans,
>>
>> On Friday 05 October 2012 10:55:40 Hans Verkuil wrote:
>>> On Tue October 2 2012 16:27:29 Tomasz Stanislawski wrote:
>>>> This patch adds extension to V4L2 api. It allow to export a mmap buffer as
>>>> file descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer
>>>> offset used by mmap and return a file descriptor on success.
>>>>
>>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> [snip]
>>
>>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>>> index e04a73e..f429b6a 100644
>>>> --- a/include/linux/videodev2.h
>>>> +++ b/include/linux/videodev2.h
>>>> @@ -688,6 +688,33 @@ struct v4l2_buffer {
>>>>
>>>>  #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
>>>>  #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
>>>>
>>>> +/**
>>>> + * struct v4l2_exportbuffer - export of video buffer as DMABUF file
>>>> descriptor + *
>>>> + * @fd:		file descriptor associated with DMABUF (set by driver)
>>>> + * @flags:	flags for newly created file, currently only O_CLOEXEC is
>>>> + *		supported, refer to manual of open syscall for more details
>>>> + * @index:	id number of the buffer
>>>> + * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
>>>> + *		multiplanar buffers);
>>>> + * @plane:	index of the plane to be exported, 0 for single plane queues
>>>> + *
>>>> + * Contains data used for exporting a video buffer as DMABUF file
>>>> descriptor. + * The buffer is identified by a 'cookie' returned by
>>>> VIDIOC_QUERYBUF + * (identical to the cookie used to mmap() the buffer to
>>>> userspace). All + * reserved fields must be set to zero. The field
>>>> reserved0 is expected to + * become a structure 'type' allowing an
>>>> alternative layout of the structure + * content. Therefore this field
>>>> should not be used for any other extensions. + */
>>>> +struct v4l2_exportbuffer {
>>>> +	__s32		fd;
>>>> +	__u32		flags;
>>>> +	__u32		type; /* enum v4l2_buf_type */
>>>> +	__u32		index;
>>>> +	__u32		plane;
>>>
>>> As suggested in my comments in the previous patch, I think it is a more
>>> natural order to have the type/index/plane fields first in this struct.
>>>
>>> Actually, I think that flags should also come before fd:
>>>
>>> struct v4l2_exportbuffer {
>>> 	__u32		type; /* enum v4l2_buf_type */
>>> 	__u32		index;
>>> 	__u32		plane;
>>> 	__u32		flags;
>>> 	__s32		fd;
>>> 	__u32		reserved[11];
>>> };
>>
>> It would indeed feel more natural, but putting them right before the reserved 
>> fields allows creating an anonymous union around type, index and plane and 
>> extending it with reserved fields if needed. That's (at least to my 
>> understanding) the rationale behind the current structure layout.
> 
> The anonymous union argument makes no sense to me, to be honest.

I agree that the anonymous unions are not good solutions because they are not
supported in many C dialects. However I have nothing against using named unions.

> It's standard practice within V4L2 to have the IN fields first, then the OUT fields, followed
> by reserved fields for future expansion.

IMO, the "input/output/reserved rule" is only a recommendation.
The are places in V4L2 where this rule is violated with structure
v4l2_buffer being the most notable example.

Notice that if at least one of the reserved fields becomes an input
file then "the rule" will be violated anyway.

> Should we ever need a, say, sub-plane
> index (whatever that might be), then we can use one of the reserved fields.

Maybe not subplane :).
But maybe some data_offset for exporting only a part of the buffer will
be needed some day.
Moreover, the integration of DMABUF with the DMA synchronization framework
may involve passing additional parameters from the userspace.

Notice that flags and fd fields are not logically connected with
(type/index/plane) tuple.
Therefore both field sets should be separated by some reserved fields to
ensure that any of them can be extended if needed.

This was the rationale for the structure layout in v9.

Regards,
Tomasz Stanislawski

> Regards,
> 
> 	Hans
> 
>>
>>>> +	__u32		reserved[11];
>>>> +};
>>>> +
>>>>
>>>>  /*
>>>>  
>>>>   *	O V E R L A Y   P R E V I E W
>>>>   */
>>
>>
> 

