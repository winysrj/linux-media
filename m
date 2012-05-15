Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43633 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab2EOGPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 02:15:10 -0400
Received: by wibhj8 with SMTP id hj8so2426057wib.1
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 23:15:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA_GA1cEr=SZ65SfptRyfP6hT_7sjr2RgMbkY3N6FHTHZ7BWvA@mail.gmail.com>
References: <1336991039-15970-1-git-send-email-lliubbo@gmail.com>
	<1463663.qyvIXF66SU@avalon>
	<CAA_GA1cEr=SZ65SfptRyfP6hT_7sjr2RgMbkY3N6FHTHZ7BWvA@mail.gmail.com>
Date: Tue, 15 May 2012 14:15:09 +0800
Message-ID: <CAA_GA1dw6gFfsDrykyFZpSSK-dK7Q4BduenWEs3zz=itYytK2w@mail.gmail.com>
Subject: Re: [PATCH] drivers:media:video:uvc: fix uvc_v4l2_get_unmapped_area
 for NOMMU
From: Bob Liu <lliubbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	linux-uvc-devel@lists.berlios.de,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, May 15, 2012 at 9:01 AM, Bob Liu <lliubbo@gmail.com> wrote:
> Hi Laurent,
>
> On Mon, May 14, 2012 at 7:31 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Bob,
>>
>> On Monday 14 May 2012 18:23:59 Bob Liu wrote:
>>> Fix uvc_v4l2_get_unmapped_area() for NOMMU arch like blackfin after
>>> framework updated to use videobuf2.
>>
>> Thank you for the patch, but I'm afraid you're too late. The fix is already
>> queued for v3.5 :-)
>
> It doesn't matter.

Sorry for my misunderstanding. I've seen the fix in the queue for v3.5.
Please ignore my noise.

>
>>
>>> Signed-off-by: Bob Liu <lliubbo@gmail.com>
>>> ---
>>>  drivers/media/video/uvc/uvc_queue.c |   30 ------------------------------
>>>  drivers/media/video/uvc/uvc_v4l2.c  |    2 +-
>>>  2 files changed, 1 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/drivers/media/video/uvc/uvc_queue.c
>>> b/drivers/media/video/uvc/uvc_queue.c index 518f77d..30be060 100644
>>> --- a/drivers/media/video/uvc/uvc_queue.c
>>> +++ b/drivers/media/video/uvc/uvc_queue.c
>>> @@ -237,36 +237,6 @@ int uvc_queue_allocated(struct uvc_video_queue *queue)
>>>       return allocated;
>>>  }
>>>
>>> -#ifndef CONFIG_MMU
>>> -/*
>>> - * Get unmapped area.
>>> - *
>>> - * NO-MMU arch need this function to make mmap() work correctly.
>>> - */
>>> -unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
>>> -             unsigned long pgoff)
>>> -{
>>> -     struct uvc_buffer *buffer;
>>> -     unsigned int i;
>>> -     unsigned long ret;
>>> -
>>> -     mutex_lock(&queue->mutex);
>>> -     for (i = 0; i < queue->count; ++i) {
>>> -             buffer = &queue->buffer[i];
>>> -             if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
>>> -                     break;
>>> -     }
>>> -     if (i == queue->count) {
>>> -             ret = -EINVAL;
>>> -             goto done;
>>> -     }
>>> -     ret = (unsigned long)buf->mem;
>>> -done:
>>> -     mutex_unlock(&queue->mutex);
>>> -     return ret;
>>> -}
>>> -#endif
>>> -
>>>  /*
>>>   * Enable or disable the video buffers queue.
>>>   *
>>> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
>>> b/drivers/media/video/uvc/uvc_v4l2.c index 2ae4f88..506d3d6 100644
>>> --- a/drivers/media/video/uvc/uvc_v4l2.c
>>> +++ b/drivers/media/video/uvc/uvc_v4l2.c
>>> @@ -1067,7 +1067,7 @@ static unsigned long uvc_v4l2_get_unmapped_area(struct
>>> file *file,
>>>
>>>       uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_get_unmapped_area\n");
>>>
>>> -     return uvc_queue_get_unmapped_area(&stream->queue, pgoff);
>>> +     return vb2_get_unmapped_area(&stream->queue, addr, len, pgoff, flags);
>>
>> Just for the record you would have needed to take the queue->mutex around the
>> vb2_get_unmapped_area() call here.
>>
>
> okay, i'll send out v2 soon, please queue it for next window.
> Thank you.
>
>>>  }
>>>  #endif
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
>
> --
> Regards,
> --Bob

-- 
Regards,
--Bob
