Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4048 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaJAMIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Oct 2014 08:08:09 -0400
Message-ID: <542BEE89.2050405@xs4all.nl>
Date: Wed, 01 Oct 2014 14:07:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Paulo Assis <pj.assis@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: uvcvideo fails on 3.16 and 3.17 kernels
References: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com> <3332528.UXGlNqFTSJ@avalon> <CAPueXH5vbm_cSwA_EYyYJRiH3XFKuae9HAG1xGTNha5nB+q0uA@mail.gmail.com> <1782581.QHYlHgcnOV@avalon> <CAPueXH7kjYrumvO56PBcGzNVFgQSzinH4k7OGWmsxNr5GhX+qg@mail.gmail.com>
In-Reply-To: <CAPueXH7kjYrumvO56PBcGzNVFgQSzinH4k7OGWmsxNr5GhX+qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/14 13:53, Paulo Assis wrote:
> Laurent,
> 
> OK, I undersdant what I'm doing wrong now.
> I don't see any other solution in order to follow the v4l2 api, than
> to copy the mmap data into another buffer that will be used in frame
> processing,  and then requeue.
> Guvcview processes frame data in several different threads and I don't
> want to wait for processing to finish before requeing, I just want to
> call the get_frame function from whathever thread and be done with it.
> This solution however forces a mem copy that the mmap operation
> intends to avoid.

Once you requeue the buffer you no longer control it and it is owned by
the driver, which may sync the buffer for the device making it unreliable
to read from by the cpu (esp. on non-Intel architectures). And of course
it will be used to capture frames, so the contents can be modified while
you are still processing. In other words, you should wait with requeuing
the buffer until after processing. What's strange about that? This is
nothing new.

You certainly don't want to copy the buffers, that's nuts. Just fix the
application to postpone calling QBUF until after processing is done.

Regards,

	Hans

> 
> Best regards,
> Paulo
> 
> 2014-10-01 12:05 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> Hi Paulo,
>>
>> On Wednesday 01 October 2014 11:48:26 Paulo Assis wrote:
>>> Laurent hi,
>>>
>>> 2014-09-30 23:31 GMT+01:00 Laurent Pinchart:
>>>> Hi Paulo,
>>>>
>>>> Thank you for investigation this.
>>>>
>>>> On Tuesday 30 September 2014 13:56:15 Paulo Assis wrote:
>>>>
>>>>> Ok,
>>>>> so I've set a workaround in guvcview, it now uses the length filed if
>>>>> bytesused is set to zero.
>>>>> Anyway I think this violates the v4l2 api:
>>>>> http://linuxtv.org/downloads/v4l-dvb-apis/buffer.html
>>>>>
>>>>> bytesused - ..., Drivers must set this field when type refers to an
>>>>> input stream, ...
>>>>>
>>>>> without this value we have no way of knowing the exact frame size for
>>>>> compressed formats.
>>>>>
>>>>> And this was working in uvcvideo up until 3.16, I don't know how many
>>>>> userspace apps rely on this value, but at least guvcview does, and
>>>>> it's currently broken for uvcvideo devices in the latest kernels.
>>>>
>>>> It took me some time to debug the problem, and I think the problem is
>>>> actually on guvcview's side. When dequeuing a video buffer, the
>>>> application requeues it immediately before processing the buffer's
>>>> contents. The VIDIOC_QBUF ioctl will reset the bytesused field to 0.
>>>>
>>>> While you could work around the problem by using a different struct
>>>> v4l2_buffer instance for the VIDIOC_QBUF call, the V4L2 doesn't allow
>>>> userspace application to access a queued buffer. You must process the
>>>> buffer before requeuing it.
>>>
>>> I though this was why we requested multiple buffers. If this is true
>>> then using just one buffer is enough, also using multiple threads to
>>> process frame data seems useless in this case, since we need to
>>> process the buffer before queueing the next one.
>>>
>>> I thought one could request 4 buffers for mmap and do:
>>>
>>> VIDIOC_DQBUF data->buf[0]
>>> VIDIOC_QBUF  driver queues->buf[1]
>>>
>>> process buf[0]
>>>
>>> VIDIOC_DQBUF data->buf[1]
>>> VIDIOC_QBUF  driver queues->buf[2]
>>>
>>> process buf[1]
>>>
>>> VIDIOC_DQBUF data->buf[2]
>>> VIDIOC_QBUF  driver queues->buf[3]
>>>
>>> process buf[2]
>>>
>>> VIDIOC_DQBUF data->buf[3]
>>> VIDIOC_QBUF  driver queues->buf[0]
>>>
>>> process buf[3]
>>
>> That's certainly valid. However, if I'm not mistaken, after dequeuing buffer i
>> you immediately requeue the same buffer, not buffer i+1.
>>
>> What you should do is queueing all buffers right before starting the stream (I
>> think you're doing fine there, but I haven't double-checked), and then, when a
>> buffer is available, perform the following sequence.
>>
>>         VIDIOC_DQBUF() -> returns buffer i
>>         process buffer i
>>         VIDIOC_QBUF(buffer i)
>>
>> You can perform processing in a different thread if needed, the important part
>> being not to requeue the buffer before userspace is done with it.
>>
>> The bug that caused guvcview to stop functioning is in v4l2_core.c.
>>
>>         memset(&vd->buf, 0, sizeof(struct v4l2_buffer));
>>
>>         vd->buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>         vd->buf.memory = V4L2_MEMORY_MMAP;
>>
>>         ret = xioctl(vd->fd, VIDIOC_DQBUF, &vd->buf);
>>
>>         if(!ret)
>>         {
>>                 /*
>>                  * driver timestamp is unreliable
>>                  * use monotonic system time
>>                  */
>>                 vd->timestamp = ns_time_monotonic();
>>
>>                 /* queue the buffers */
>>                 ret = xioctl(vd->fd, VIDIOC_QBUF, &vd->buf);
>>                 ...
>>         }
>>
>> The VIDIOC_DQBUF call will return the correct bytesused value in vd-
>>> buf.bytesused, but the VIDIOC_QBUF call then resets that value to 0.
>>
>> As a quick workaround while you fix the buffer processing sequence, you can
>> copy vd->buf into a new local v4l2_buffer variable after calling VIDIOC_DQBUF,
>> and use that local variable in the VIDIOC_QBUF call. Note that you will still
>> violate the V4L2 API as you're not allowed to touch a buffer after requeuing
>> it, but it should hide the problem and get guvcview to display images again.
>>
>>> Now if we need to process the buffer between VIDIOC_DQBUF and
>>> VIDIOC_QBUF, whats the point in using more than one buffer ?
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

