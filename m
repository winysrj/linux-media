Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52996 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab2JJOF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:05:26 -0400
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00LW6KHKTI30@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 15:05:44 +0100 (BST)
Received: from [106.116.147.108] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBO000D2KGZ0I80@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 15:05:24 +0100 (BST)
Message-id: <507580A2.2050803@samsung.com>
Date: Wed, 10 Oct 2012 16:05:22 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: Re: [PATCHv9 19/25] v4l: vb2: add buffer exporting via dmabuf
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
 <1349188056-4886-20-git-send-email-t.stanislaws@samsung.com>
 <201210061422.27704.hverkuil@xs4all.nl>
In-reply-to: <201210061422.27704.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/2012 02:22 PM, Hans Verkuil wrote:
> On Tue October 2 2012 16:27:30 Tomasz Stanislawski wrote:
>> This patch adds extension to videobuf2-core. It allow to export a mmap buffer
>> as a file descriptor.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> ---
>>  drivers/media/video/videobuf2-core.c |   82 ++++++++++++++++++++++++++++++++++
>>  include/media/videobuf2-core.h       |    4 ++
>>  2 files changed, 86 insertions(+)
>>
>> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
>> index 05da3b4..a97815b 100644
>> --- a/drivers/media/video/videobuf2-core.c
>> +++ b/drivers/media/video/videobuf2-core.c
> 
> <snip>
> 
>> @@ -2455,6 +2528,15 @@ int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
>>  
>> +int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
>> +{
>> +	struct video_device *vdev = video_devdata(file);
>> +
>> +	/* No need to call vb2_queue_is_busy(), anyone can export buffers. */

Hi Hans,

> 
> After thinking about this some more I'm not so sure we should allow this.
> Exporting a buffer also means that the memory can't be freed as long as the
> exported filehandle remains open.
> 

You are completely right.
But the problem is much more complex ... see below.

> That means that it is possible to make a malicious application that exports
> the buffers and never frees them, which can cause havoc.

What kind of havoc do you mean? Resource leakage?

> I think that only
> the filehandle that called REQBUFS/CREATE_BUFS should be allowed to export
> buffers.

Notice that you should allow to call mmap() only for the file handles that called
REQBUFS/CREATE_BUFS. The mmap() creates a vma that holds a reference to a buffer.
As long as the mapping exists, the buffers cannot be freed and REQBUFS(count=0) returns -EBUSY.
According to V4L2 spec all the nodes share the same context, therefore
one process can call REQBUFS, and the other can call QUERYBUF and mmap().

Therefore if EXPBUF has to check vb2_queue_is_busy() then vb2_fop_mmap()
should do the same check too.

IMO, it is very difficult to develop a useful multi-client API that
would protect V4L2 from creating non-freeable buffers by a rogue applications.

I think that the requirements below:

- the buffers should be sharable between processes by mmap(), or DMABUF exporting
- the REQBUFS(count=0) should release the buffers

are contradictory and cannot be *reliably* satisfied at the same time.
Notice that REQBUFS(count=0) that unexpectedly return -EBUSY is not
a reliable solution. The application cannot do anything fix the problem
after receiving -EBUSY.

Anyway, I will apply the check for vb2_queue_is_busy() in v2b_ioctl_expbuf().

Regards,
Tomasz Stanislawski

> 
> What do you think?
> 
> Regards,
> 
> 	Hans
> 
>> +	return vb2_expbuf(vdev->queue, p);
>> +}
>> +EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
>> +
>>  /* v4l2_file_operations helpers */
>>  
>>  int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)

