Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54311 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1DTKSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2011 06:18:16 -0400
Received: by qwk3 with SMTP id 3so272032qwk.19
        for <linux-media@vger.kernel.org>; Wed, 20 Apr 2011 03:18:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110420085908.GA7294@minime.bse>
References: <1302261394-25695-1-git-send-email-lliubbo@gmail.com>
	<BANLkTikGxffMuxWq3P7QxM0213k9oRU4hw@mail.gmail.com>
	<20110420085908.GA7294@minime.bse>
Date: Wed, 20 Apr 2011 18:18:15 +0800
Message-ID: <BANLkTi=2Yd2JgoG2BxKqJ7KdW_ADbyUY5Q@mail.gmail.com>
Subject: Re: Fwd: [PATCH v2] media: uvc_driver: add NO-MMU arch support
From: Bob Liu <lliubbo@gmail.com>
To: Bob Liu <lliubbo@gmail.com>, linux-media@vger.kernel.org,
	linux-uvc-devel@lists.berlios.de, mchehab@redhat.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
	jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
	agust@denx.de, gregkh@suse.de
Cc: =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Apr 20, 2011 at 4:59 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Wed, Apr 20, 2011 at 02:02:41PM +0800, Bob Liu wrote:
>> ---------- Forwarded message ----------
>
> Forwarding broke tabs.
>

Hi, Daniel
Thanks for your review, I will make a new patch later.

>> @@ -445,6 +446,20 @@ int uvc_queue_mmap(struct uvc_video_queue *queue,
>> struct vm_area_struct *vma)
>>                addr += PAGE_SIZE;
>>                size -= PAGE_SIZE;
>>        }
>> +#else
>> +       if (i == queue->count ||
>> +                       PAGE_ALIGN(size) != queue->buf_size) {
>
> Why do you need to round up size on nommu?
>

If didn't round up, it always return  -EINVAL.
I don't know why config-mmu doesn't have this problem.

I use luvcview for testing and added some print, you can see that size
always != queue->buf_size.
So we need round up.

root:/> luvcview -f yuv -s 320x240 -i 30
luvcview 0.2.4

SDL information:
  Video driver: fbcon
  Hardware surfaces are available (382k video memory)
Device information:
  Device path:  /dev/video0
Stream settings:
  Frame format: YUYV
  Frame size:   320x240
  Fsaiz e tis  03x2f5800, align size is 0x26000, bufsize is 0x26000

size is 0x25800, align size is 0x26000, bufsize is 0x26000
Unable to map buffer: Invalid argument
 Init v4L2 failed !! exit fatal
root:/>

>> +               ret = -EINVAL;
>> +               goto done;
>> +       }
>> +
>> +       /* documentation/nommu-mmap.txt */
>
> I don't see where Documentation/nommu-mmap.txt provides any information
> on the following line(s).
>

I will rm it, sorry for that.

>> +       vma->vm_flags |= VM_IO | VM_MAYSHARE;
>> +
>> +       addr = (unsigned long)queue->mem + buffer->buf.m.offset;
>> +       vma->vm_start = addr;
>> +       vma->vm_end = addr +  queue->buf_size;
>
> You don't need to do this here. vm_start and vm_end have already been
> modified like this by do_mmap_pgoff after get_unmapped_area had been
> called.
>

will rm also.

>> +#endif
>>
>>        vma->vm_ops = &uvc_vm_ops;
>>        vma->vm_private_data = buffer;
>> @@ -489,6 +504,38 @@ done:
>>  }
>>
>>  /*
>> + * Get unmapped area.
>> + *
>> + * NO-MMU arch need this function to make mmap() work correctly.
>> + */
>> +unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
>> +               unsigned long addr, unsigned long len, unsigned long pgoff)
>> +{
>> +       struct uvc_buffer *buffer;
>> +       unsigned int i;
>> +       int ret = 0;
>
> ret should be an unsigned long. You later try to store a pointer in
> there.
>

okay.

>> +
>> +       mutex_lock(&queue->mutex);
>> +       for (i = 0; i < queue->count; ++i) {
>> +               buffer = &queue->buffer[i];
>> +               if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
>> +                       break;
>> +       }
>> +
>> +       if (i == queue->count ||
>> +                       PAGE_ALIGN(len) != queue->buf_size) {
>> +               ret = -EINVAL;
>> +               goto done;
>> +       }
>> +
>> +       addr = (unsigned long)queue->mem + buffer->buf.m.offset;
>> +       ret = addr;
>> +done:
>> +       mutex_unlock(&queue->mutex);
>> +       return ret;
>> +}
>> +
>> +/*
>>  * Enable or disable the video buffers queue.
>>  *
>>  * The queue must be enabled before starting video acquisition and must be
>> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
>> b/drivers/media/video/uvc/uvc_v4l2.c
>> index 9005a8d..9efab61 100644
>> --- a/drivers/media/video/uvc/uvc_v4l2.c
>> +++ b/drivers/media/video/uvc/uvc_v4l2.c
>> @@ -1081,6 +1081,18 @@ static unsigned int uvc_v4l2_poll(struct file
>> *file, poll_table *wait)
>>        return uvc_queue_poll(&stream->queue, file, wait);
>>  }
>>
>> +static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
>> +               unsigned long addr, unsigned long len, unsigned long pgoff,
>> +               unsigned long flags)
>> +{
>> +       struct uvc_fh *handle = file->private_data;
>> +       struct uvc_streaming *stream = handle->stream;
>> +
>> +       uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_get_unmapped_area\n");
>> +
>> +       return uvc_queue_get_unmapped_area(&stream->queue, addr, len, pgoff);
>> +}
>> +
>>  const struct v4l2_file_operations uvc_fops = {
>>        .owner          = THIS_MODULE,
>>        .open           = uvc_v4l2_open,
>> @@ -1089,5 +1101,6 @@ const struct v4l2_file_operations uvc_fops = {
>>        .read           = uvc_v4l2_read,
>>        .mmap           = uvc_v4l2_mmap,
>>        .poll           = uvc_v4l2_poll,
>> +       .get_unmapped_area = uvc_v4l2_get_unmapped_area,
>>  };
>>
>> diff --git a/drivers/media/video/uvc/uvcvideo.h
>> b/drivers/media/video/uvc/uvcvideo.h
>> index 45f01e7..48a2378 100644
>> --- a/drivers/media/video/uvc/uvcvideo.h
>> +++ b/drivers/media/video/uvc/uvcvideo.h
>> @@ -580,6 +580,12 @@ extern int uvc_queue_mmap(struct uvc_video_queue *queue,
>>                struct vm_area_struct *vma);
>>  extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
>>                struct file *file, poll_table *wait);
>> +#ifdef CONFIG_MMU
>> +#define uvc_queue_get_unmapped_area NULL
>> +#else
>> +extern unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
>> +               unsigned long addr, unsigned long len, unsigned long pgoff);
>> +#endif
>>  extern int uvc_queue_allocated(struct uvc_video_queue *queue);
>>  static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
>>  {
>> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
>
> Rest looks good.
> Did you change anything in the generic code or is this a plain
> git revert c29fcff3daafbf46d64a543c1950bbd206ad8c1c
> ?
>

It's not a simple revert, I added  uvc_v4l2_get_unmapped_area().

> Maybe one can unify the mmu and nommu versions of uvc_queue_mmap by using
> remap_vmalloc_range but IMHO the nommu versions of the remap_*_range
> functions are broken and should only validate if the source and destination
> addresses match.
>

Maybe we can try in future.
Thanks!
-- 
Regards,
--Bob
