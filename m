Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51315 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaJALFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Oct 2014 07:05:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: uvcvideo fails on 3.16 and 3.17 kernels
Date: Wed, 01 Oct 2014 14:05:22 +0300
Message-ID: <1782581.QHYlHgcnOV@avalon>
In-Reply-To: <CAPueXH5vbm_cSwA_EYyYJRiH3XFKuae9HAG1xGTNha5nB+q0uA@mail.gmail.com>
References: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com> <3332528.UXGlNqFTSJ@avalon> <CAPueXH5vbm_cSwA_EYyYJRiH3XFKuae9HAG1xGTNha5nB+q0uA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paulo,

On Wednesday 01 October 2014 11:48:26 Paulo Assis wrote:
> Laurent hi,
> 
> 2014-09-30 23:31 GMT+01:00 Laurent Pinchart:
> > Hi Paulo,
> > 
> > Thank you for investigation this.
> > 
> > On Tuesday 30 September 2014 13:56:15 Paulo Assis wrote:
> >
> >> Ok,
> >> so I've set a workaround in guvcview, it now uses the length filed if
> >> bytesused is set to zero.
> >> Anyway I think this violates the v4l2 api:
> >> http://linuxtv.org/downloads/v4l-dvb-apis/buffer.html
> >> 
> >> bytesused - ..., Drivers must set this field when type refers to an
> >> input stream, ...
> >> 
> >> without this value we have no way of knowing the exact frame size for
> >> compressed formats.
> >> 
> >> And this was working in uvcvideo up until 3.16, I don't know how many
> >> userspace apps rely on this value, but at least guvcview does, and
> >> it's currently broken for uvcvideo devices in the latest kernels.
> > 
> > It took me some time to debug the problem, and I think the problem is
> > actually on guvcview's side. When dequeuing a video buffer, the
> > application requeues it immediately before processing the buffer's
> > contents. The VIDIOC_QBUF ioctl will reset the bytesused field to 0.
> > 
> > While you could work around the problem by using a different struct
> > v4l2_buffer instance for the VIDIOC_QBUF call, the V4L2 doesn't allow
> > userspace application to access a queued buffer. You must process the
> > buffer before requeuing it.
> 
> I though this was why we requested multiple buffers. If this is true
> then using just one buffer is enough, also using multiple threads to
> process frame data seems useless in this case, since we need to
> process the buffer before queueing the next one.
> 
> I thought one could request 4 buffers for mmap and do:
> 
> VIDIOC_DQBUF data->buf[0]
> VIDIOC_QBUF  driver queues->buf[1]
> 
> process buf[0]
> 
> VIDIOC_DQBUF data->buf[1]
> VIDIOC_QBUF  driver queues->buf[2]
> 
> process buf[1]
> 
> VIDIOC_DQBUF data->buf[2]
> VIDIOC_QBUF  driver queues->buf[3]
> 
> process buf[2]
> 
> VIDIOC_DQBUF data->buf[3]
> VIDIOC_QBUF  driver queues->buf[0]
> 
> process buf[3]

That's certainly valid. However, if I'm not mistaken, after dequeuing buffer i 
you immediately requeue the same buffer, not buffer i+1.

What you should do is queueing all buffers right before starting the stream (I 
think you're doing fine there, but I haven't double-checked), and then, when a 
buffer is available, perform the following sequence.

	VIDIOC_DQBUF() -> returns buffer i
	process buffer i
	VIDIOC_QBUF(buffer i)

You can perform processing in a different thread if needed, the important part 
being not to requeue the buffer before userspace is done with it.

The bug that caused guvcview to stop functioning is in v4l2_core.c.

        memset(&vd->buf, 0, sizeof(struct v4l2_buffer));

        vd->buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        vd->buf.memory = V4L2_MEMORY_MMAP;

        ret = xioctl(vd->fd, VIDIOC_DQBUF, &vd->buf);

        if(!ret)
        {
                /*
                 * driver timestamp is unreliable 
                 * use monotonic system time
                 */
                vd->timestamp = ns_time_monotonic();

                /* queue the buffers */ 
                ret = xioctl(vd->fd, VIDIOC_QBUF, &vd->buf);
                ...
        }

The VIDIOC_DQBUF call will return the correct bytesused value in vd-
>buf.bytesused, but the VIDIOC_QBUF call then resets that value to 0.

As a quick workaround while you fix the buffer processing sequence, you can 
copy vd->buf into a new local v4l2_buffer variable after calling VIDIOC_DQBUF, 
and use that local variable in the VIDIOC_QBUF call. Note that you will still 
violate the V4L2 API as you're not allowed to touch a buffer after requeuing 
it, but it should hide the problem and get guvcview to display images again.

> Now if we need to process the buffer between VIDIOC_DQBUF and
> VIDIOC_QBUF, whats the point in using more than one buffer ?

-- 
Regards,

Laurent Pinchart

