Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33011 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2A0Nkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 08:40:40 -0500
Received: by dadi2 with SMTP id i2so1411262dad.19
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2012 05:40:39 -0800 (PST)
Message-ID: <4F22A952.2080107@gmail.com>
Date: Fri, 27 Jan 2012 19:10:34 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	pawel@osciak.com, sumit.semwal@ti.com, jesse.barker@linaro.org,
	kyungmin.park@samsung.com, daniel@ffwll.ch
Subject: Re: [Linaro-mm-sig] [PATCH 05/10] v4l: add buffer exporting via dmabuf
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com> <4F1E9100.90306@gmail.com> <4F1E9EAD.60505@samsung.com>
In-Reply-To: <4F1E9EAD.60505@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Tomasz,

Sorry for a late reply. Please find my answers inline.

On 01/24/2012 05:36 PM, Tomasz Stanislawski wrote:
> Hi,
>
> On 01/24/2012 12:07 PM, Subash Patel wrote:
>> Hello Thomasz,
>>
>> Instead of adding another IOCTL to query the file-descriptor in
>> user-space, why dont we extend the existing ones in v4l2/vb2?
>>
>> When the memory type set is V4L2_MEMORY_DMABUF, call to VIDIOC_REQBUFS
>> /VIDIOC_QUERYBUF from driver can take/return the fd. We will need to add
>> another attribute to struct v4l2_requestbuffers for this.
>>
>> struct v4l2_requestbuffers {
>> ...
>> __u32 buf_fd;
>> };
>>
>> The application requesting buffer would set it to -1, and will receive
>> the fd's when it calls the vb2_querybuf. In the same way, application
>> which is trying to attach to already allocated buffer will set this to
>> valid fd when it calls vidioc_reqbuf, and in vb2_reqbuf depending on the
>> memory type, this can be checked and used to attach with the dma_buf for
>> the respective buffer.
>>
>> Ofcourse, this requires changes in vb2_reqbufs and vb2_querybuf similar
>> to what you did in vb2_expbufs.
>>
>> Will there be any issues in such an approach?
>
> I like your idea but IMO there are some issues which this approach.
>
> The VIDIOC_REQBUF is used to create a collection of buffers (i.e. 5
> frames). Every frame is a separate buffer therefore it should have
> separate dmabuf file descriptor. This way you should add buffer index to
> v4l2_request_buffers. Of course but one could reuse count field but
> there is still problem with multiplane buffers (see below).
I agree.
>
> Please note that dmabuf file could be create only for buffers with MMAP
> memory type. The DMABUF memory type for VIDIOC_REQBUFS indicate that a
> buffer is imported from DMABUF file descriptor. Similar way like content
> of USERPTR buffers is taken from user pointer.
>
> Therefore only MMAP buffers can be exported as DMABUF file descriptor.
I think for time being, mmap is best way we can share buffers between 
IP's, like MM and GPU.
>
> If VIDIOC_REQUBUF is used for buffer exporting, how to request a bunch
> of buffers that are dedicated to obtain memory from DMABUF file
> descriptors?
I am not sure if I understand this question. But what I meant is, 
VIDIOC_REQBUF with memory type V4L2_MEMORY_DMABUF will ask the driver to 
allocate MMAP type memory and create the dmabuf handles for those. In 
the next call to VIDIOC_QUERYBUF (which you do on each of the buffers 
infact), driver will return the dmabuf file descriptors to user space. 
This can be used by the user space to mmap(when dmabuf supports) or pass 
it onto another process to share the buffers.

The recipient user process can now pass these dmabuf file descriptors in 
VIDIOC_REQBUF itself to its driver (say another v4l2 based). In the 
driver, when the user space calls VIDIOC_QUERYBUF for those buffers, we 
can call dmabuf's attach() to actually link to the buffer. Does it make 
sense?
>
> The second problem is VIDIOC_QUERYBUF. According to V4L2 spec, the
> memory type field is read only. The driver returns the same memory type
> as it was used in VIDIOC_REQBUFS. Therefore VIDIOC_QUERYBUF can only be
> used for MMAP buffers to obtain memoffset. For DMABUF it may return
> fd=-1 or most recently used file descriptor. As I remember, it was not
> defined yet.
>
I was thinking why not the memory type move out from enum to an int? In 
that case, we can send ORed types, like 
V4L2_MEMORY_MMAP|V4L2_MEMORY_DMABUF etc. Does it help?

> The third reason are multiplane buffers. This API was introduced if V4L2
> buffer (IMO it should be called a frame) consist of multiple memory
> buffers. Every plane can be mmapped separately. Therefore it should be
> possible to export every plane as separate DMABUF descriptor.
>
Do we require to export every plane as separate dmabuf? I think dmabuf 
should cover entire multi-plane buffer instead of individual planes. How 
to calculate individual plane offsets should be the property of the 
driver depending on its need for it.

> After some research it was found that memoffset is good identifier of a
> plane in a buffers. This id is also available in the userspace without
> any API extensions.
>
> VIDIOC_EXPBUF was used to export a buffer by id, similar way as mmap
> uses this identifier to map a buffer to userspace. It seams to be the
> simplest solution.
>
Ok. Then dont you think when dmabuf supports mmaping the buffers, 
VIDIOC_REQBUF will be useless? VIDIOC_EXPBUF will provide that 
functionality as well.

> Fourth reason, VIDIOC_REQBUF means that the application request a
> buffer. DMABUF framework is used to export existing buffers. Note that
> memory may not be pinned to a buffer for some APIs like DRM. I think
> that is should stated explicitly that application wants to export not
> request a buffer. Using VIDIOC_REQBUF seams to be an API abuse.
I agree that memory may not be static like V4L2 in case of DRM. But this 
is still an issue even with a new IOCTL :) VIDIOC_REQBUF might not be 
abused as far I feel. It is extended to a) request buffers if not 
allocated b) request, as well as pass the information of already 
allocated buffers if any. Both ways, we are using it for the same 
purpose, requesting the buffers from corresponding driver.
>
> What is your opinion?
My concern is what will happen to applications which are already written 
with existing V4L2 IOCTL flows on new framework? i.e., if I have 
developed an application for say, just camera using s5p-fimc, and 
s5p-fimc driver eventually moves to dmabuf. If the application wont move 
into new buffer sharing framework, will things work in first place, and 
second will driver state move even if the new IOCTL is not made (driver 
can question QBUF without QUERYBUF and/or EXPBUF)?

Regards,
Subash
>
> Regards,
> Tomasz Stanislawski
>
>>
>> Regards,
>> Subash
>>
>> On 01/23/2012 07:21 PM, Tomasz Stanislawski wrote:
>>> This patch adds extension to V4L2 api. It allow to export a mmap
>>> buffer as file
>>> descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset
>>> used by
>>> mmap and return a file descriptor on success.
>>>
>>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>> ---
>>> drivers/media/video/v4l2-compat-ioctl32.c | 1 +
>>> drivers/media/video/v4l2-ioctl.c | 11 +++++++++++
>>> include/linux/videodev2.h | 1 +
>>> include/media/v4l2-ioctl.h | 1 +
>>> 4 files changed, 14 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c
>>> b/drivers/media/video/v4l2-compat-ioctl32.c
>>> index c68531b..0f18b5e 100644
>>> --- a/drivers/media/video/v4l2-compat-ioctl32.c
>>> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
>>> @@ -954,6 +954,7 @@ long v4l2_compat_ioctl32(struct file *file,
>>> unsigned int cmd, unsigned long arg)
>>> case VIDIOC_S_FBUF32:
>>> case VIDIOC_OVERLAY32:
>>> case VIDIOC_QBUF32:
>>> + case VIDIOC_EXPBUF:
>>> case VIDIOC_DQBUF32:
>>> case VIDIOC_STREAMON32:
>>> case VIDIOC_STREAMOFF32:
>>> diff --git a/drivers/media/video/v4l2-ioctl.c
>>> b/drivers/media/video/v4l2-ioctl.c
>>> index e1da8fc..cb29e00 100644
>>> --- a/drivers/media/video/v4l2-ioctl.c
>>> +++ b/drivers/media/video/v4l2-ioctl.c
>>> @@ -207,6 +207,7 @@ static const char *v4l2_ioctls[] = {
>>> [_IOC_NR(VIDIOC_S_FBUF)] = "VIDIOC_S_FBUF",
>>> [_IOC_NR(VIDIOC_OVERLAY)] = "VIDIOC_OVERLAY",
>>> [_IOC_NR(VIDIOC_QBUF)] = "VIDIOC_QBUF",
>>> + [_IOC_NR(VIDIOC_EXPBUF)] = "VIDIOC_EXPBUF",
>>> [_IOC_NR(VIDIOC_DQBUF)] = "VIDIOC_DQBUF",
>>> [_IOC_NR(VIDIOC_STREAMON)] = "VIDIOC_STREAMON",
>>> [_IOC_NR(VIDIOC_STREAMOFF)] = "VIDIOC_STREAMOFF",
>>> @@ -932,6 +933,16 @@ static long __video_do_ioctl(struct file *file,
>>> dbgbuf(cmd, vfd, p);
>>> break;
>>> }
>>> + case VIDIOC_EXPBUF:
>>> + {
>>> + unsigned int *p = arg;
>>> +
>>> + if (!ops->vidioc_expbuf)
>>> + break;
>>> +
>>> + ret = ops->vidioc_expbuf(file, fh, *p);
>>> + break;
>>> + }
>>> case VIDIOC_DQBUF:
>>> {
>>> struct v4l2_buffer *p = arg;
>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>> index 3c0ade1..448fbed 100644
>>> --- a/include/linux/videodev2.h
>>> +++ b/include/linux/videodev2.h
>>> @@ -2183,6 +2183,7 @@ struct v4l2_create_buffers {
>>> #define VIDIOC_S_FBUF _IOW('V', 11, struct v4l2_framebuffer)
>>> #define VIDIOC_OVERLAY _IOW('V', 14, int)
>>> #define VIDIOC_QBUF _IOWR('V', 15, struct v4l2_buffer)
>>> +#define VIDIOC_EXPBUF _IOWR('V', 16, __u32)
>>> #define VIDIOC_DQBUF _IOWR('V', 17, struct v4l2_buffer)
>>> #define VIDIOC_STREAMON _IOW('V', 18, int)
>>> #define VIDIOC_STREAMOFF _IOW('V', 19, int)
>>> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
>>> index 4d1c74a..8201546 100644
>>> --- a/include/media/v4l2-ioctl.h
>>> +++ b/include/media/v4l2-ioctl.h
>>> @@ -120,6 +120,7 @@ struct v4l2_ioctl_ops {
>>> int (*vidioc_reqbufs) (struct file *file, void *fh, struct
>>> v4l2_requestbuffers *b);
>>> int (*vidioc_querybuf)(struct file *file, void *fh, struct v4l2_buffer
>>> *b);
>>> int (*vidioc_qbuf) (struct file *file, void *fh, struct v4l2_buffer *b);
>>> + int (*vidioc_expbuf) (struct file *file, void *fh, __u32 offset);
>>> int (*vidioc_dqbuf) (struct file *file, void *fh, struct v4l2_buffer
>>> *b);
>>>
>>> int (*vidioc_create_bufs)(struct file *file, void *fh, struct
>>> v4l2_create_buffers *b);
>>
>
