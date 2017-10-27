Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:56290 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbdJ0KI1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 06:08:27 -0400
Date: Fri, 27 Oct 2017 11:08:23 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v4 17/17] [media] v4l: Document explicit synchronization
 behaviour
Message-ID: <20171027100822.GG40170@e107564-lin.cambridge.arm.com>
References: <20171020215012.20646-1-gustavo@padovan.org>
 <20171020215012.20646-18-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20171020215012.20646-18-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 20, 2017 at 07:50:12PM -0200, Gustavo Padovan wrote:
>From: Gustavo Padovan <gustavo.padovan@collabora.com>
>
>Add section to VIDIOC_QBUF about it
>
>v3:
>	- make the out_fence refer to the current buffer (Hans)
>	- Note what happens when the IN_FENCE is not set (Hans)
>
>v2:
>	- mention that fences are files (Hans)
>	- rework for the new API
>
>Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
>---
> Documentation/media/uapi/v4l/vidioc-qbuf.rst | 31 ++++++++++++++++++++++++++++
> 1 file changed, 31 insertions(+)
>
>diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>index 9e448a4aa3aa..a65a50578bad 100644
>--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>@@ -118,6 +118,37 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
> The struct :c:type:`v4l2_buffer` structure is specified in
> :ref:`buffer`.
>
>+Explicit Synchronization
>+------------------------
>+
>+Explicit Synchronization allows us to control the synchronization of
>+shared buffers from userspace by passing fences to the kernel and/or
>+receiving them from it. Fences passed to the kernel are named in-fences and
>+the kernel should wait on them to signal before using the buffer, i.e., queueing
>+it to the driver. On the other side, the kernel can create out-fences for the
>+buffers it queues to the drivers. Out-fences signal when the driver is
>+finished with buffer, i.e., the buffer is ready. The fences are represented
>+as a file and passed as a file descriptor to userspace.
>+
>+The in-fences are communicated to the kernel at the ``VIDIOC_QBUF`` ioctl
>+using the ``V4L2_BUF_FLAG_IN_FENCE`` buffer
>+flags and the `fence_fd` field. If an in-fence needs to be passed to the kernel,
>+`fence_fd` should be set to the fence file descriptor number and the
>+``V4L2_BUF_FLAG_IN_FENCE`` should be set as well Setting one but not the other
>+will cause ``VIDIOC_QBUF`` to return with error.

nit: full-stop before "Setting".

Also, depending what is decided about passing in a -1 in-fence, the
wording might want to include that behaviour.

>+
>+The fence_fd field (formely the reserved2 field) will be ignored if the
>+``V4L2_BUF_FLAG_IN_FENCE`` is not set.
>+
>+To get an out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
>+be set to ask for a fence to be attached to the buffer. To become aware of
>+the out-fence created one should listen for the ``V4L2_EVENT_OUT_FENCE`` event.
>+An event will be triggered for every buffer queued to the V4L2 driver with the
>+``V4L2_BUF_FLAG_OUT_FENCE``.

Is it worth mentioning the immediate out-fence behaviour for ordered
queues? And/or clarifying that otherwise the V4L2_EVENT_OUT_FENCE
event will not be sent until all in-fence(s) on the buffer (or
previously queued ones) have signalled.

Cheers,
-Brian

>+
>+At streamoff the out-fences will either signal normally if the drivers waits
>+for the operations on the buffers to finish or signal with error if the
>+driver cancels the pending operations.
>
> Return Value
> ============
>-- 
>2.13.6
>
