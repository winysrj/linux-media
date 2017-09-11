Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34384 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdIKNSx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:18:53 -0400
Date: Mon, 11 Sep 2017 10:18:46 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v3 01/15] [media] v4l: Document explicit synchronization
 behaviour
Message-ID: <20170911131846.GA7552@jade>
References: <20170907184226.27482-1-gustavo@padovan.org>
 <20170907184226.27482-2-gustavo@padovan.org>
 <22b8926c-4a44-0f22-0717-c36d64003272@xs4all.nl>
 <6bb8df91-4cd2-2ca5-dc4b-aea5ea14e7b1@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bb8df91-4cd2-2ca5-dc4b-aea5ea14e7b1@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-09-11 Hans Verkuil <hverkuil@xs4all.nl>:

> On 09/11/2017 12:50 PM, Hans Verkuil wrote:
> > On 09/07/2017 08:42 PM, Gustavo Padovan wrote:
> >> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> >>
> >> Add section to VIDIOC_QBUF about it
> >>
> >> v2:
> >> 	- mention that fences are files (Hans)
> >> 	- rework for the new API
> >>
> >> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> >> ---
> >>  Documentation/media/uapi/v4l/vidioc-qbuf.rst | 31 ++++++++++++++++++++++++++++
> >>  1 file changed, 31 insertions(+)
> >>
> >> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >> index 1f3612637200..fae0b1431672 100644
> >> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >> @@ -117,6 +117,37 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
> >>  The struct :c:type:`v4l2_buffer` structure is specified in
> >>  :ref:`buffer`.
> >>  
> >> +Explicit Synchronization
> >> +------------------------
> >> +
> >> +Explicit Synchronization allows us to control the synchronization of
> >> +shared buffers from userspace by passing fences to the kernel and/or
> >> +receiving them from it. Fences passed to the kernel are named in-fences and
> >> +the kernel should wait them to signal before using the buffer, i.e., queueing
> > 
> > wait them -> wait on them
> > 
> > (do you wait 'on' a fence or 'for' a fence? I think it's 'on' but I'm not 100% sure)
> > 
> >> +it to the driver. On the other side, the kernel can create out-fences for the
> >> +buffers it queues to the drivers, out-fences signal when the driver is
> > 
> > Start a new sentence here: ...drivers. Out-fences...
> > 
> >> +finished with buffer, that is the buffer is ready. The fence are represented
> > 
> > s/that is/i.e/
> > 
> > s/The fence/The fences/
> > 
> >> +by file and passed as file descriptor to userspace.
> > 
> > s/by file/as a file/
> > s/as file/as a file/
> > 
> >> +
> >> +The in-fences are communicated to the kernel at the ``VIDIOC_QBUF`` ioctl
> >> +using the ``V4L2_BUF_FLAG_IN_FENCE`` buffer
> >> +flags and the `fence_fd` field. If an in-fence needs to be passed to the kernel,
> >> +`fence_fd` should be set to the fence file descriptor number and the
> >> +``V4L2_BUF_FLAG_IN_FENCE`` should be set as well. Failure to set both will
> > 
> > s/Failure to set both/Setting one but not the other/
> > 
> >> +cause ``VIDIOC_QBUF`` to return with error.
> >> +
> >> +To get a out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
> >> +be set to notify it that the next queued buffer should have a fence attached to
> >> +it. That means the out-fence may not be associated with the buffer in the
> >> +current ``VIDIOC_QBUF`` ioctl call because the ordering in which videobuf2 core
> >> +queues the buffers to the drivers can't be guaranteed. To become aware of the
> >> +of the next queued buffer and the out-fence attached to it the
> >> +``V4L2_EVENT_BUF_QUEUED`` event should be used. It will trigger an event
> >> +for every buffer queued to the V4L2 driver.
> > 
> > This makes no sense.
> > 
> > Setting this flag means IMHO that when *this* buffer is queued up to the driver,
> > then it should send the BUF_QUEUED event with an out fence.
> > 
> > I.e. it signals that userspace wants to have the out-fence. The requirement w.r.t.
> > ordering is that the BUF_QUEUED events have to be in order, but that is something
> > that the driver can ensure in the case it is doing internal re-ordering.
> > 
> > This requirement is something that needs to be documented here, BTW.
> > 
> > Anyway, the flag shouldn't refer to some 'next buffer', since that's very confusing.
> 
> Just ignore this comment. I assume v4 will implement it like this.

What approach do you mean by "like this". I'm confused now. :)

In fact, I was in doubt between these two different approaches here.
Should the flag mean *this* or the *next* buffer? The buffers can still
be reordered at the videobuf2 level, because they might be waiting on
in-fences and the fences may signal out of order. Then I went for the
*next* buffer approach because we don't know that buffer for sure.
But now thinking on this again we shouldn't have problems with the 
*this* buffer approach also.

> 
> Regards,
> 
> 	Hans
> 
> > 
> >> +
> >> +At streamoff the out-fences will either signal normally if the drivers wait
> > 
> > s/drivers wait/driver waits/
> > 
> >> +for the operations on the buffers to finish or signal with error if the
> >> +driver cancel the pending operations.
> > 
> > s/cancel/cancels/
> > 
> > Thinking with my evil hat on:
> > 
> > What happens if the application dequeues the buffer (VIDIOC_DQBUF) before
> > dequeuing the BUF_QUEUED event? Or if the application doesn't call VIDIOC_DQEVENT
> > at all? Should any pending BUF_QUEUED event with an out fence be removed from the
> > event queue if the application calls DQBUF on the corresponding buffer?

Good catch, we need to clean that up.

Gustavo
