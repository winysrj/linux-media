Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36521 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbdIHCjg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 22:39:36 -0400
Received: by mail-it0-f44.google.com with SMTP id 6so3075453itl.1
        for <linux-media@vger.kernel.org>; Thu, 07 Sep 2017 19:39:36 -0700 (PDT)
Message-ID: <1504838373.11720.15.camel@ndufresne.ca>
Subject: Re: [PATCH v3 01/15] [media] v4l: Document explicit synchronization
 behaviour
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Date: Thu, 07 Sep 2017 22:39:33 -0400
In-Reply-To: <20170907184226.27482-2-gustavo@padovan.org>
References: <20170907184226.27482-1-gustavo@padovan.org>
         <20170907184226.27482-2-gustavo@padovan.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 07 septembre 2017 à 15:42 -0300, Gustavo Padovan a écrit :
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Add section to VIDIOC_QBUF about it
> 
> v2:
> 	- mention that fences are files (Hans)
> 	- rework for the new API
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst | 31 ++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index 1f3612637200..fae0b1431672 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -117,6 +117,37 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
>  The struct :c:type:`v4l2_buffer` structure is specified in
>  :ref:`buffer`.
>  
> +Explicit Synchronization
> +------------------------
> +
> +Explicit Synchronization allows us to control the synchronization of
> +shared buffers from userspace by passing fences to the kernel and/or
> +receiving them from it. Fences passed to the kernel are named in-fences and
> +the kernel should wait them to signal before using the buffer, i.e., queueing
> +it to the driver. On the other side, the kernel can create out-fences for the
> +buffers it queues to the drivers, out-fences signal when the driver is
> +finished with buffer, that is the buffer is ready. The fence are represented
> +by file and passed as file descriptor to userspace.

I think the API works to deliver the fence FD userspace, though for the
userspace I maintain (GStreamer) it's often the case that the buffer is
unusable without the associated timestamp.

Let's consider the capture to display case (V4L2 -> DRM). As soon as
you add audio capture to the loop, GStreamer will need to start dealing
with synchronization. We can't just blindly give that buffer to the
display, we need to make sure this buffer makes it on time, in a way
that it is synchronized with the audio. To deal with synchronization,
we need to be able to correlate the video image capture time with the
audio capture time.

The problem is that this timestamp is only delivered when DQBUF
succeed, which is after the fence has unblocked. This makes the fences
completely unusable for that purpose. In general, to achieve very low
latency and still have synchronization, we'll probably need the
timestamp to be delivered somehow before the image transfer have
complete. Obviously, this is only possible if we have timestamp with
flag V4L2_BUF_FLAG_TSTAMP_SRC_SOE.

On another note, for m2m drivers that behave as color converters and
scalers, with ordered queues, userspace knows the timestamp already, so
 using the proposed API and passing the buffer immediately with it's
fence is really going to help.

For encoded (compressed) data, similar issues will be found with the
bytesused member of struct v4l2_buffer. We'll need to know the size of
the encoded data before we can pass it to another driver. I'm not sure
how relevant fences are for this type of data.

> +
> +The in-fences are communicated to the kernel at the ``VIDIOC_QBUF`` ioctl
> +using the ``V4L2_BUF_FLAG_IN_FENCE`` buffer
> +flags and the `fence_fd` field. If an in-fence needs to be passed to the kernel,
> +`fence_fd` should be set to the fence file descriptor number and the
> +``V4L2_BUF_FLAG_IN_FENCE`` should be set as well. Failure to set both will
> +cause ``VIDIOC_QBUF`` to return with error.
> +
> +To get a out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
> +be set to notify it that the next queued buffer should have a fence attached to
> +it. That means the out-fence may not be associated with the buffer in the
> +current ``VIDIOC_QBUF`` ioctl call because the ordering in which videobuf2 core
> +queues the buffers to the drivers can't be guaranteed. To become aware of the
> +of the next queued buffer and the out-fence attached to it the

"of the" is repeated twice.

> +``V4L2_EVENT_BUF_QUEUED`` event should be used. It will trigger an event
> +for every buffer queued to the V4L2 driver.
> +
> +At streamoff the out-fences will either signal normally if the drivers wait
> +for the operations on the buffers to finish or signal with error if the
> +driver cancel the pending operations.
>  
>  Return Value
>  ============
