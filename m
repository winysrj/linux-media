Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab2AWPEx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 10:04:53 -0500
Message-ID: <4F1D7705.3080601@redhat.com>
Date: Mon, 23 Jan 2012 13:04:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com
Subject: Re: [PATCH 05/10] v4l: add buffer exporting via dmabuf
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com> <4F1D6F88.5080202@redhat.com> <4F1D71EA.2060402@samsung.com>
In-Reply-To: <4F1D71EA.2060402@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-01-2012 12:42, Tomasz Stanislawski escreveu:
> Hi Mauro.
> On 01/23/2012 03:32 PM, Mauro Carvalho Chehab wrote:
>> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>>> This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
>>> descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
>>> mmap and return a file descriptor on success.
>>
>> This requires more discussions.
>>
>> The usecase for this new API seems to replace the features previously provided
>> by the overlay mode. There, not only the buffer were exposed to userspace, but
>> some control were provided, in order to control the overlay window.
> 
> This ioctl was introduced to support exporting of V4L2 buffers via dma-buf interface. This framework was little common with overlay mode. Could you describe what overlay mode feature is replaced by VIDIOC_EXPBUF?

The V4L2 API doesn't just export "raw" buffers. It provides a logic to control
the streams, with includes buffer settings, buffer queue/dequeue, buffer meta-data
(like timestamps), etc.

I would expect to see something similar for the dma buffers.

With regards to the overlay mode, this is the old way to export DMA buffers between
a video capture driver and a graphics adapter driver. A dma-buf interface will
superseed the video overlay mode, as it will provide more features. Yet, care
should be taken when writing the userspace interface, in order to be sure that all
features needed will be provided there.

>>
>> Please start a separate thread about that, explaining how are you imagining that
>> a V4L2 application would use such ioctl.
> 
> This patch is essential for full implementation of support for DMABUF framework in V4L2. Therefore the patch cannot be moved to separate thread.

I'm not proposing to move the patch to a separate thread. All I'm saying
is that the API extensions for dmabuf requires its own separate discussions.

I couldn't guess, just from your patches, what ioctl's a V4L2 application
like tvtime or xawtv would use the DMABUF.

> 
> Regrads,
> Tomasz Stanislawski
> 
>>
>> Regards,
>> Mauro
> 
> 
> 
>>
>>>
>>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>> ---
>>>   drivers/media/video/v4l2-compat-ioctl32.c |    1 +
>>>   drivers/media/video/v4l2-ioctl.c          |   11 +++++++++++
>>>   include/linux/videodev2.h                 |    1 +
>>>   include/media/v4l2-ioctl.h                |    1 +
>>>   4 files changed, 14 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
>>> index c68531b..0f18b5e 100644
>>> --- a/drivers/media/video/v4l2-compat-ioctl32.c
>>> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
>>> @@ -954,6 +954,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>>>       case VIDIOC_S_FBUF32:
>>>       case VIDIOC_OVERLAY32:
>>>       case VIDIOC_QBUF32:
>>> +    case VIDIOC_EXPBUF:
>>>       case VIDIOC_DQBUF32:
>>>       case VIDIOC_STREAMON32:
>>>       case VIDIOC_STREAMOFF32:
>>> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
>>> index e1da8fc..cb29e00 100644
>>> --- a/drivers/media/video/v4l2-ioctl.c
>>> +++ b/drivers/media/video/v4l2-ioctl.c
>>> @@ -207,6 +207,7 @@ static const char *v4l2_ioctls[] = {
>>>       [_IOC_NR(VIDIOC_S_FBUF)]           = "VIDIOC_S_FBUF",
>>>       [_IOC_NR(VIDIOC_OVERLAY)]          = "VIDIOC_OVERLAY",
>>>       [_IOC_NR(VIDIOC_QBUF)]             = "VIDIOC_QBUF",
>>> +    [_IOC_NR(VIDIOC_EXPBUF)]           = "VIDIOC_EXPBUF",
>>>       [_IOC_NR(VIDIOC_DQBUF)]            = "VIDIOC_DQBUF",
>>>       [_IOC_NR(VIDIOC_STREAMON)]         = "VIDIOC_STREAMON",
>>>       [_IOC_NR(VIDIOC_STREAMOFF)]        = "VIDIOC_STREAMOFF",
>>> @@ -932,6 +933,16 @@ static long __video_do_ioctl(struct file *file,
>>>               dbgbuf(cmd, vfd, p);
>>>           break;
>>>       }
>>> +    case VIDIOC_EXPBUF:
>>> +    {
>>> +        unsigned int *p = arg;
>>> +
>>> +        if (!ops->vidioc_expbuf)
>>> +            break;
>>> +
>>> +        ret = ops->vidioc_expbuf(file, fh, *p);
>>> +        break;
>>> +    }
>>>       case VIDIOC_DQBUF:
>>>       {
>>>           struct v4l2_buffer *p = arg;
>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>> index 3c0ade1..448fbed 100644
>>> --- a/include/linux/videodev2.h
>>> +++ b/include/linux/videodev2.h
>>> @@ -2183,6 +2183,7 @@ struct v4l2_create_buffers {
>>>   #define VIDIOC_S_FBUF         _IOW('V', 11, struct v4l2_framebuffer)
>>>   #define VIDIOC_OVERLAY         _IOW('V', 14, int)
>>>   #define VIDIOC_QBUF        _IOWR('V', 15, struct v4l2_buffer)
>>> +#define VIDIOC_EXPBUF        _IOWR('V', 16, __u32)
>>>   #define VIDIOC_DQBUF        _IOWR('V', 17, struct v4l2_buffer)
>>>   #define VIDIOC_STREAMON         _IOW('V', 18, int)
>>>   #define VIDIOC_STREAMOFF     _IOW('V', 19, int)
>>> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
>>> index 4d1c74a..8201546 100644
>>> --- a/include/media/v4l2-ioctl.h
>>> +++ b/include/media/v4l2-ioctl.h
>>> @@ -120,6 +120,7 @@ struct v4l2_ioctl_ops {
>>>       int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
>>>       int (*vidioc_querybuf)(struct file *file, void *fh, struct v4l2_buffer *b);
>>>       int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer *b);
>>> +    int (*vidioc_expbuf)  (struct file *file, void *fh, __u32 offset);
>>>       int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer *b);
>>>
>>>       int (*vidioc_create_bufs)(struct file *file, void *fh, struct v4l2_create_buffers *b);
>>
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

