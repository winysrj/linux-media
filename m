Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55869 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJAKsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Oct 2014 06:48:47 -0400
Received: by mail-ie0-f180.google.com with SMTP id x19so43599ier.39
        for <linux-media@vger.kernel.org>; Wed, 01 Oct 2014 03:48:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3332528.UXGlNqFTSJ@avalon>
References: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com>
 <CAPueXH73_yHoBhHKn+zroC6WViBmU1XH-B-FPVE2Q-V56bcBFQ@mail.gmail.com> <3332528.UXGlNqFTSJ@avalon>
From: Paulo Assis <pj.assis@gmail.com>
Date: Wed, 1 Oct 2014 11:48:26 +0100
Message-ID: <CAPueXH5vbm_cSwA_EYyYJRiH3XFKuae9HAG1xGTNha5nB+q0uA@mail.gmail.com>
Subject: Re: uvcvideo fails on 3.16 and 3.17 kernels
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent hi,

2014-09-30 23:31 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Paulo,
>
> Thank you for investigation this.
>
> On Tuesday 30 September 2014 13:56:15 Paulo Assis wrote:
>> Ok,
>> so I've set a workaround in guvcview, it now uses the length filed if
>> bytesused is set to zero.
>> Anyway I think this violates the v4l2 api:
>> http://linuxtv.org/downloads/v4l-dvb-apis/buffer.html
>>
>> bytesused - ..., Drivers must set this field when type refers to an
>> input stream, ...
>>
>> without this value we have no way of knowing the exact frame size for
>> compressed formats.
>>
>> And this was working in uvcvideo up until 3.16, I don't know how many
>> userspace apps rely on this value, but at least guvcview does, and
>> it's currently broken for uvcvideo devices in the latest kernels.
>
> It took me some time to debug the problem, and I think the problem is actually
> on guvcview's side. When dequeuing a video buffer, the application requeues it
> immediately before processing the buffer's contents. The VIDIOC_QBUF ioctl
> will reset the bytesused field to 0.
>
> While you could work around the problem by using a different struct
> v4l2_buffer instance for the VIDIOC_QBUF call, the V4L2 doesn't allow
> userspace application to access a queued buffer. You must process the buffer
> before requeuing it.

I though this was why we requested multiple buffers. If this is true
then using just one buffer is enough, also using multiple threads to
process frame data seems useless in this case, since we need to
process the buffer before queueing the next one.

I thought one could request 4 buffers for mmap and do:

VIDIOC_DQBUF   data->buf[0]
VIDIOC_QBUF     driver queues->buf[1]

process buf[0]

VIDIOC_DQBUF data->buf[1]
VIDIOC_QBUF   driver queues->buf[2]

process buf[1]

VIDIOC_DQBUF data->buf[2]
VIDIOC_QBUF   driver queues->buf[3]

process buf[2]

VIDIOC_DQBUF data->buf[3]
VIDIOC_QBUF   driver queues->buf[0]

process buf[3]

Now if we need to process the buffer between VIDIOC_DQBUF and
VIDIOC_QBUF, whats the point in using more than one buffer ?

Regards,
Paulo


>
>> 2014-09-30 9:50 GMT+01:00 Paulo Assis <pj.assis@gmail.com>:
>> > I referring to the following bug:
>> >
>> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1362358
>> >
>> > I've run some tests and after increasing verbosity for uvcvideo, I get:
>> > EOF on empty payload
>> >
>> > this seems consistent with the zero size frames returned by the driver.
>> > After VIDIOC_DQBUF | VIDIOC_QBUF, I get buf.bytesused=0
>> >
>> > Testing with an eye toy 2 (gspca), everything works fine, so this is
>> > definitly related to uvcvideo.
>> > This happens on all available formats (YUYV and MJPEG)
>
> --
> Regards,
>
> Laurent Pinchart
>
