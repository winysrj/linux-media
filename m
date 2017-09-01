Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:34421 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751901AbdIAMuf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 08:50:35 -0400
Subject: Re: [PATCH v2 14/14] [media] v4l: Document explicit synchronization
 behaviour
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170901015041.7757-1-gustavo@padovan.org>
 <20170901015041.7757-15-gustavo@padovan.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b75d6534-9b05-a317-8a29-9f51687cb136@xs4all.nl>
Date: Fri, 1 Sep 2017 14:50:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170901015041.7757-15-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

I think I concentrate on this last patch first. Once I fully understand this
I can review the code. Remember, it's been a while for me since I last looked
at fences, so forgive me if I ask stupid questions. On the other hand, others
with a similar lack of understanding of fences probably have similar questions,
so it is a good indication where the documentation needs improvement :-)

On 01/09/17 03:50, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Add section to VIDIOC_QBUF about it
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst | 30 ++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index 1f3612637200..6bd960d3972b 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -117,6 +117,36 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
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
> +finished with buffer, that is the buffer is ready.

This should add a line explaining that fences are represented by file descriptors.

> +
> +The in-fences and out-fences are communicated at the ``VIDIOC_QBUF`` ioctl
> +using the ``V4L2_BUF_FLAG_IN_FENCE`` and ``V4L2_BUF_FLAG_OUT_FENCE`` buffer
> +flags and the `fence_fd` field. If an in-fence needs to be passed to the kernel,
> +`fence_fd` should be set to the fence file descriptor number and the
> +``V4L2_BUF_FLAG_IN_FENCE`` should be set as well.

Is it possible to have both flags at the same time? Or are they mutually exclusive?

If only V4L2_BUF_FLAG_IN_FENCE is set, then what is the value of fence_fd after
the QBUF call? -1?

> +
> +To get a out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
> +be set and the `fence_fd` field will be returned with the out-fence file
> +descriptor related to the next buffer to be queued internally to the V4L2
> +driver. That means the out-fence may not be associated with the buffer in the
> +current ``VIDIOC_QBUF`` ioctl call because the ordering in which videobuf2 core
> +queues the buffers to the drivers can't be guaranteed. To become aware of the
> +buffer with which the out-fence will be attached the ``V4L2_EVENT_BUF_QUEUED``
> +should be used. It will trigger an event for every buffer queued to the V4L2
> +driver.

General question: does it even make sense to use an out-fence if you don't know with
what buffer is it associated? I mean, QBUF returns an out fence, but only some
time later are you informed about a buffer being queued. It also looks like userspace
has to keep track of the issued out-fences and the queued buffers and map them
accordingly.

If the out-fence cannot be used until you know the buffer as well, then wouldn't
it make more sense if the out-fence and the buffer index are both sent by the
event? Of course, in that case the event can only be sent to the owner file handle
of the streaming device node, but that's OK, we have that.

Setting the OUT_FENCE flag will just cause this event to be sent whenever that
buffer is queued internally.

Sorry if this just shows a complete lack of understanding of fences on my side,
that's perfectly possible.

It could be that when the out-fence triggers the listener is informed about the
associated buffer information, and in that case it makes a bit more sense.
Although in that case I don't see the reason for the event. Regardless, this
should be documented better.

This documentation should also clarify what happens with fences if the streaming
stops, either by a STREAMOFF, closing the filehandle or a crash or whatever.
Do they signal? What about out-fences not yet associated with a buffer?

> +
> +Note that the `fence_fd` field is both an input and output argument here with
> +different meaning on each direction. As input argument it carries an in-fence
> +and as output argument it carries an out-fence.
>  
>  Return Value
>  ============
> 

Regards,

	Hans
