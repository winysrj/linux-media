Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:41693 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933764AbeALOsI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 09:48:08 -0500
Subject: Re: [PATCH v7 6/6] [media] v4l: Document explicit synchronization
 behavior
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <20180110160732.7722-7-gustavo@padovan.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e3eda520-eae3-3c77-7752-58ed7305baa6@xs4all.nl>
Date: Fri, 12 Jan 2018 15:48:02 +0100
MIME-Version: 1.0
In-Reply-To: <20180110160732.7722-7-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/18 17:07, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Add section to VIDIOC_QBUF about it
> 
> v5:
> 	- Remove V4L2_CAP_ORDERED
> 	- Add doc about V4L2_FMT_FLAG_UNORDERED
> 
> v4:
> 	- Document ordering behavior for in-fences
> 	- Document V4L2_CAP_ORDERED capability
> 	- Remove doc about OUT_FENCE event
> 	- Document immediate return of out-fence in QBUF
> 
> v3:
> 	- make the out_fence refer to the current buffer (Hans)
> 	- Note what happens when the IN_FENCE is not set (Hans)
> 
> v2:
> 	- mention that fences are files (Hans)
> 	- rework for the new API
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst     | 47 +++++++++++++++++++++++-
>  Documentation/media/uapi/v4l/vidioc-querybuf.rst |  9 ++++-
>  2 files changed, 54 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index 9e448a4aa3aa..8809397fb110 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -54,7 +54,7 @@ When the buffer is intended for output (``type`` is
>  or ``V4L2_BUF_TYPE_VBI_OUTPUT``) applications must also initialize the
>  ``bytesused``, ``field`` and ``timestamp`` fields, see :ref:`buffer`
>  for details. Applications must also set ``flags`` to 0. The
> -``reserved2`` and ``reserved`` fields must be set to 0. When using the
> +``reserved`` field must be set to 0. When using the
>  :ref:`multi-planar API <planar-apis>`, the ``m.planes`` field must
>  contain a userspace pointer to a filled-in array of struct
>  :c:type:`v4l2_plane` and the ``length`` field must be set
> @@ -118,6 +118,51 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
>  The struct :c:type:`v4l2_buffer` structure is specified in
>  :ref:`buffer`.
>  
> +Explicit Synchronization
> +------------------------
> +
> +Explicit Synchronization allows us to control the synchronization of
> +shared buffers from userspace by passing fences to the kernel and/or
> +receiving them from it. Fences passed to the kernel are named in-fences and
> +the kernel should wait on them to signal before using the buffer, i.e., queueing
> +it to the driver.

I would drop ", i.e., queueing it to the driver"

On the other side, the kernel can create out-fences for the
> +buffers it queues to the drivers. Out-fences signal when the driver is
> +finished with buffer, i.e., the buffer is ready. The fences are represented
> +as a file and passed as a file descriptor to userspace.
> +
> +The in-fences are communicated to the kernel at the ``VIDIOC_QBUF`` ioctl
> +using the ``V4L2_BUF_FLAG_IN_FENCE`` buffer flag and the `fence_fd` field. If
> +an in-fence needs to be passed to the kernel, `fence_fd` should be set to the
> +fence file descriptor number and the ``V4L2_BUF_FLAG_IN_FENCE`` should be set
> +as well. Setting one but not the other will cause ``VIDIOC_QBUF`` to return
> +with error. The fence_fd field will be ignored if the

with -> with an

> +``V4L2_BUF_FLAG_IN_FENCE`` is not set.
> +
> +The videobuf2-core will guarantee that all buffers queued with in-fence will

with -> with an

> +be queued to the drivers in the same order. Fence may signal out of order, so

Fence -> Fences

> +this guarantee at videobuf2 is necessary to not change ordering.

Add some text here to make it clear that waiting for a buffer with an in-fence
will also block all buffers queued after that buffer.

> +
> +If the in-fence signals with an error the videobuf2 won't queue the buffer to
> +the driver, instead it will flag it with an error. And then wait for the
> +previous buffer to complete before asking userspace dequeue the buffer with
> +error - to make sure we deliver the buffers back in the correct order.

I think there is no need to describe the internal implementation. It is enough
to say that the buffer is marked with FLAG_ERROR if the in-fence signals an
error.

> +
> +To get an out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
> +be set to ask for a fence to be attached to the buffer. The out-fence fd is
> +sent to userspace as a ``VIDIOC_QBUF`` return argument on the `fence_fd` field.
> +
> +Note the the same `fence_fd` field is used for both sending the in-fence as
> +input argument to receive the out-fence as a return argument.
> +
> +At streamoff the out-fences will either signal normally if the driver waits
> +for the operations on the buffers to finish or signal with an error if the
> +driver cancels the pending operations. Buffers with in-fences won't be queued
> +to the driver if their fences signal. It will be cleaned up.

It -> They

It should be clarified here if you can or cannot use both in and out fences for
the same buffer.

> +
> +The ``V4L2_FMT_FLAG_UNORDERED`` flag in ``VIDIOC_ENUM_FMT`` tells userspace
> +that the current buffer queues is able to keep the ordering of buffers, i.e.,
> +the dequeing of buffers will happen at the same order we queue them, with no
> +reordering by the driver.

You described what it means when this flags isn't set :-)

Anyway, I'd rephrase this:

... tells userspace that when using this format the order in which buffers are
dequeued can be different from the order in which they were queued.

You should add some additional text to that explaining why this is relevant
for fences.

>  
>  Return Value
>  ============
> diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
> index dd54747fabc9..df964c4d916b 100644
> --- a/Documentation/media/uapi/v4l/vidioc-querybuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
> @@ -44,7 +44,7 @@ and the ``index`` field. Valid index numbers range from zero to the
>  number of buffers allocated with
>  :ref:`VIDIOC_REQBUFS` (struct
>  :c:type:`v4l2_requestbuffers` ``count``) minus
> -one. The ``reserved`` and ``reserved2`` fields must be set to 0. When
> +one. The ``reserved`` field must be set to 0. When
>  using the :ref:`multi-planar API <planar-apis>`, the ``m.planes``
>  field must contain a userspace pointer to an array of struct
>  :c:type:`v4l2_plane` and the ``length`` field has to be set
> @@ -64,6 +64,13 @@ elements will be used instead and the ``length`` field of struct
>  array elements. The driver may or may not set the remaining fields and
>  flags, they are meaningless in this context.
>  
> +When using in-fences, the ``V4L2_BUF_FLAG_IN_FENCE`` will be set if the
> +in-fence didn't signal at the time of the
> +:ref:`VIDIOC_QUERYBUF`. The ``V4L2_BUF_FLAG_OUT_FENCE`` will be set if
> +the user asked for an out-fence for the buffer, but the ``fence_fd``
> +field will be set to -1. In case ``V4L2_BUF_FLAG_OUT_FENCE`` is not set

I don't think there is any reason not to return the out fence fd here.

> +``fence_fd`` will be set to 0 for backward compatibility.
> +
>  The struct :c:type:`v4l2_buffer` structure is specified in
>  :ref:`buffer`.
>  
> 

Regards,

	Hans
