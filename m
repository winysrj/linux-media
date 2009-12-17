Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34061 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZLQCpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 21:45:52 -0500
Received: by yxe17 with SMTP id 17so1551132yxe.33
        for <linux-media@vger.kernel.org>; Wed, 16 Dec 2009 18:45:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <36be2c7a0912161000j2004b15r920089bddf9066c@mail.gmail.com>
References: <36be2c7a0912070918h23cee33bia26c85b13d242ca9@mail.gmail.com>
	 <200912160112.41754.laurent.pinchart@ideasonboard.com>
	 <36be2c7a0912152251l6e1eb991t773dd26f0a973941@mail.gmail.com>
	 <200912161149.38618.laurent.pinchart@ideasonboard.com>
	 <36be2c7a0912161000j2004b15r920089bddf9066c@mail.gmail.com>
Date: Wed, 16 Dec 2009 23:45:51 -0300
Message-ID: <36be2c7a0912161845x5506db2ame48ad79176097d65@mail.gmail.com>
Subject: Re: uvcvideo kernel panic when using libv4l
From: Pablo Baena <pbaena@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "lcostantino@gmail.com" <lcostantino@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After testing all day non-stop, I can confirm this works great without
throwing oops.

THank you very much.

On Wed, Dec 16, 2009 at 3:00 PM, Pablo Baena <pbaena@gmail.com> wrote:
> Yes! This patch worked. So far I got no kernel panic, and image is
> correct. Will be testing today to see if something comes up, but so
> far it's doing great. Thank you!
>
> On Wed, Dec 16, 2009 at 7:49 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Pablo,
>>
>> On Wednesday 16 December 2009 07:51:20 Pablo Baena wrote:
>>> With that patch, libv4l throws an error at some point, no crashes so far
>>>  though:
>>>
>>> libv4l2: error dequeuing buf: Invalid argument
>>> read error 22, Invalid argument
>>
>> Could you please try this updated patch ?
>>
>> diff -r c1f376eae978 linux/drivers/media/video/uvc/uvc_queue.c
>> --- a/linux/drivers/media/video/uvc/uvc_queue.c Sat Dec 12 18:57:17 2009 +0100
>> +++ b/linux/drivers/media/video/uvc/uvc_queue.c Wed Dec 16 11:47:40 2009 +0100
>> @@ -59,7 +59,7 @@
>>  *    returns immediately.
>>  *
>>  *    When the buffer is full, the completion handler removes it from the irq
>> - *    queue, marks it as ready (UVC_BUF_STATE_DONE) and wakes its wait queue.
>> + *    queue, marks it as ready (UVC_BUF_STATE_READY) and wakes its wait queue.
>>  *    At that point, any process waiting on the buffer will be woken up. If a
>>  *    process tries to dequeue a buffer after it has been marked ready, the
>>  *    dequeing will succeed immediately.
>> @@ -196,11 +196,12 @@
>>
>>        switch (buf->state) {
>>        case UVC_BUF_STATE_ERROR:
>> -       case UVC_BUF_STATE_DONE:
>> +       case UVC_BUF_STATE_READY:
>>                v4l2_buf->flags |= V4L2_BUF_FLAG_DONE;
>>                break;
>>        case UVC_BUF_STATE_QUEUED:
>>        case UVC_BUF_STATE_ACTIVE:
>> +       case UVC_BUF_STATE_DONE:
>>                v4l2_buf->flags |= V4L2_BUF_FLAG_QUEUED;
>>                break;
>>        case UVC_BUF_STATE_IDLE:
>> @@ -295,13 +296,15 @@
>>  {
>>        if (nonblocking) {
>>                return (buf->state != UVC_BUF_STATE_QUEUED &&
>> -                       buf->state != UVC_BUF_STATE_ACTIVE)
>> +                       buf->state != UVC_BUF_STATE_ACTIVE &&
>> +                       buf->state != UVC_BUF_STATE_DONE)
>>                        ? 0 : -EAGAIN;
>>        }
>>
>>        return wait_event_interruptible(buf->wait,
>>                buf->state != UVC_BUF_STATE_QUEUED &&
>> -               buf->state != UVC_BUF_STATE_ACTIVE);
>> +               buf->state != UVC_BUF_STATE_ACTIVE &&
>> +               buf->state != UVC_BUF_STATE_DONE);
>>  }
>>
>>  /*
>> @@ -341,13 +344,14 @@
>>                uvc_trace(UVC_TRACE_CAPTURE, "[W] Corrupted data "
>>                        "(transmission error).\n");
>>                ret = -EIO;
>> -       case UVC_BUF_STATE_DONE:
>> +       case UVC_BUF_STATE_READY:
>>                buf->state = UVC_BUF_STATE_IDLE;
>>                break;
>>
>>        case UVC_BUF_STATE_IDLE:
>>        case UVC_BUF_STATE_QUEUED:
>>        case UVC_BUF_STATE_ACTIVE:
>> +       case UVC_BUF_STATE_DONE:
>>        default:
>>                uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer state %u "
>>                        "(driver bug?).\n", buf->state);
>> @@ -383,7 +387,7 @@
>>        buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
>>
>>        poll_wait(file, &buf->wait, wait);
>> -       if (buf->state == UVC_BUF_STATE_DONE ||
>> +       if (buf->state == UVC_BUF_STATE_READY ||
>>            buf->state == UVC_BUF_STATE_ERROR)
>>                mask |= POLLIN | POLLRDNORM;
>>
>> @@ -489,6 +493,7 @@
>>
>>        spin_lock_irqsave(&queue->irqlock, flags);
>>        list_del(&buf->queue);
>> +       buf->state = UVC_BUF_STATE_READY;
>>        if (!list_empty(&queue->irqqueue))
>>                nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
>>                                           queue);
>> diff -r c1f376eae978 linux/drivers/media/video/uvc/uvc_video.c
>> --- a/linux/drivers/media/video/uvc/uvc_video.c Sat Dec 12 18:57:17 2009 +0100
>> +++ b/linux/drivers/media/video/uvc/uvc_video.c Wed Dec 16 11:47:40 2009 +0100
>> @@ -578,8 +578,7 @@
>>                uvc_video_decode_end(stream, buf, mem,
>>                        urb->iso_frame_desc[i].actual_length);
>>
>> -               if (buf->state == UVC_BUF_STATE_DONE ||
>> -                   buf->state == UVC_BUF_STATE_ERROR)
>> +               if (buf->state == UVC_BUF_STATE_DONE)
>>                        buf = uvc_queue_next_buffer(&stream->queue, buf);
>>        }
>>  }
>> @@ -637,8 +636,7 @@
>>                if (!stream->bulk.skip_payload && buf != NULL) {
>>                        uvc_video_decode_end(stream, buf, stream->bulk.header,
>>                                stream->bulk.payload_size);
>> -                       if (buf->state == UVC_BUF_STATE_DONE ||
>> -                           buf->state == UVC_BUF_STATE_ERROR)
>> +                       if (buf->state == UVC_BUF_STATE_DONE)
>>                                buf = uvc_queue_next_buffer(&stream->queue,
>>                                                            buf);
>>                }
>> diff -r c1f376eae978 linux/drivers/media/video/uvc/uvcvideo.h
>> --- a/linux/drivers/media/video/uvc/uvcvideo.h  Sat Dec 12 18:57:17 2009 +0100
>> +++ b/linux/drivers/media/video/uvc/uvcvideo.h  Wed Dec 16 11:47:40 2009 +0100
>> @@ -370,7 +370,8 @@
>>        UVC_BUF_STATE_QUEUED    = 1,
>>        UVC_BUF_STATE_ACTIVE    = 2,
>>        UVC_BUF_STATE_DONE      = 3,
>> -       UVC_BUF_STATE_ERROR     = 4,
>> +       UVC_BUF_STATE_READY     = 4,
>> +       UVC_BUF_STATE_ERROR     = 5,
>>  };
>>
>>  struct uvc_buffer {
>>
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
>
>
>
> --
> "Not possessing the gift of reflection, a dog does not know that he
> does not know, and does not understand that he understands nothing;
> we, on the other hand, are aware of both. If we behave otherwise, it
> is from stupidity, or else from self-deception, to preserve our peace
> of mind."
>



-- 
"Not possessing the gift of reflection, a dog does not know that he
does not know, and does not understand that he understands nothing;
we, on the other hand, are aware of both. If we behave otherwise, it
is from stupidity, or else from self-deception, to preserve our peace
of mind."
