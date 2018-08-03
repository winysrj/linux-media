Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:44109 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbeHCQ5E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 12:57:04 -0400
Received: by mail-yw1-f66.google.com with SMTP id l9-v6so1062193ywc.11
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2018 08:00:21 -0700 (PDT)
Received: from mail-yb0-f178.google.com (mail-yb0-f178.google.com. [209.85.213.178])
        by smtp.gmail.com with ESMTPSA id d10-v6sm5510576ywh.87.2018.08.03.08.00.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Aug 2018 08:00:18 -0700 (PDT)
Received: by mail-yb0-f178.google.com with SMTP id x15-v6so2754597ybm.2
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2018 08:00:18 -0700 (PDT)
MIME-Version: 1.0
References: <20180705160337.54379-1-hverkuil@xs4all.nl> <20180705160337.54379-2-hverkuil@xs4all.nl>
In-Reply-To: <20180705160337.54379-2-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 4 Aug 2018 00:00:05 +0900
Message-ID: <CAAFQd5C56H3eHoceh9FRM7YqyTfazvbZQv6aifz8nZE4kTu8nw@mail.gmail.com>
Subject: Re: [PATCHv16 01/34] Documentation: v4l: document request API
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jul 6, 2018 at 1:04 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Alexandre Courbot <acourbot@chromium.org>
>
> Document the request API for V4L2 devices, and amend the documentation
> of system calls influenced by it.
>
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../media/uapi/mediactl/media-controller.rst  |   1 +
>  .../media/uapi/mediactl/media-funcs.rst       |   6 +
>  .../uapi/mediactl/media-ioc-request-alloc.rst |  77 ++++++
>  .../uapi/mediactl/media-request-ioc-queue.rst |  81 ++++++
>  .../mediactl/media-request-ioc-reinit.rst     |  51 ++++
>  .../media/uapi/mediactl/request-api.rst       | 247 ++++++++++++++++++
>  .../uapi/mediactl/request-func-close.rst      |  49 ++++
>  .../uapi/mediactl/request-func-ioctl.rst      |  68 +++++
>  .../media/uapi/mediactl/request-func-poll.rst |  74 ++++++
>  Documentation/media/uapi/v4l/buffer.rst       |  21 +-
>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  94 ++++---
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  32 ++-
>  .../media/videodev2.h.rst.exceptions          |   1 +
>  13 files changed, 766 insertions(+), 36 deletions(-)
>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
>  create mode 100644 Documentation/media/uapi/mediactl/request-api.rst
>  create mode 100644 Documentation/media/uapi/mediactl/request-func-close.rst
>  create mode 100644 Documentation/media/uapi/mediactl/request-func-ioctl.rst
>  create mode 100644 Documentation/media/uapi/mediactl/request-func-poll.rst
>

Thanks a lot for working on this and sorry for being late to the
party. Please see some comments inline. (Mostly wording nits, though.)

> diff --git a/Documentation/media/uapi/mediactl/media-controller.rst b/Documentation/media/uapi/mediactl/media-controller.rst
> index 0eea4f9a07d5..66aff38cd499 100644
> --- a/Documentation/media/uapi/mediactl/media-controller.rst
> +++ b/Documentation/media/uapi/mediactl/media-controller.rst
> @@ -21,6 +21,7 @@ Part IV - Media Controller API
>      media-controller-intro
>      media-controller-model
>      media-types
> +    request-api
>      media-funcs
>      media-header
>
> diff --git a/Documentation/media/uapi/mediactl/media-funcs.rst b/Documentation/media/uapi/mediactl/media-funcs.rst
> index 076856501cdb..260f9dcadcde 100644
> --- a/Documentation/media/uapi/mediactl/media-funcs.rst
> +++ b/Documentation/media/uapi/mediactl/media-funcs.rst
> @@ -16,3 +16,9 @@ Function Reference
>      media-ioc-enum-entities
>      media-ioc-enum-links
>      media-ioc-setup-link
> +    media-ioc-request-alloc
> +    request-func-close
> +    request-func-ioctl
> +    request-func-poll
> +    media-request-ioc-queue
> +    media-request-ioc-reinit
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> new file mode 100644
> index 000000000000..8f8ecf6c63b6
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> @@ -0,0 +1,77 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +.. _media_ioc_request_alloc:
> +
> +*****************************
> +ioctl MEDIA_IOC_REQUEST_ALLOC
> +*****************************
> +
> +Name
> +====
> +
> +MEDIA_IOC_REQUEST_ALLOC - Allocate a request
> +
> +
> +Synopsis
> +========
> +
> +.. c:function:: int ioctl( int fd, MEDIA_IOC_REQUEST_ALLOC, struct media_request_alloc *argp )
> +    :name: MEDIA_IOC_REQUEST_ALLOC
> +
> +
> +Arguments
> +=========
> +
> +``fd``
> +    File descriptor returned by :ref:`open() <media-func-open>`.
> +
> +``argp``
> +

Missing description.

> +
> +Description
> +===========
> +
> +If the media device supports :ref:`requests <media-request-api>`, then
> +this ioctl can be used to allocate a request. If it is not supported, then
> +``errno`` is set to ``ENOTTY``. A request is accessed through a file descriptor
> +that is returned in struct :c:type:`media_request_alloc`.
> +
> +If the request was successfully allocated, then the request file descriptor
> +can be passed to the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
> +:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
> +:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
> +:ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctls.
> +
> +In addition, the request can be queued by calling
> +:ref:`MEDIA_REQUEST_IOC_QUEUE` and re-initialized by calling
> +:ref:`MEDIA_REQUEST_IOC_REINIT`.
> +
> +Finally, the file descriptor can be :ref:`polled <request-func-poll>` to wait
> +for the request to complete.
> +
> +The request will remain allocated until the associated file descriptor is
> +closed by :ref:`close() <request-func-close>` and the driver no longer uses
> +the request internally.

I suppose that would be "until all the file descriptors associated
with it are closed and", since one could dup() the original file
descriptor and even close it, keeping just the copy.

> +
> +.. c:type:: media_request_alloc
> +
> +.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
> +
> +.. flat-table:: struct media_request_alloc
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    *  -  __s32
> +       -  ``fd``
> +       -  The file descriptor of the request.
> +
> +Return Value
> +============
> +
> +On success 0 is returned, on error -1 and the ``errno`` variable is set
> +appropriately. The generic error codes are described at the
> +:ref:`Generic Error Codes <gen-errors>` chapter.
> +
> +ENOTTY
> +    The driver has no support for requests.
> diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
> new file mode 100644
> index 000000000000..725854605e41
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
> @@ -0,0 +1,81 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +.. _media_request_ioc_queue:
> +
> +*****************************
> +ioctl MEDIA_REQUEST_IOC_QUEUE
> +*****************************
> +
> +Name
> +====
> +
> +MEDIA_REQUEST_IOC_QUEUE - Queue a request
> +
> +
> +Synopsis
> +========
> +
> +.. c:function:: int ioctl( int request_fd, MEDIA_REQUEST_IOC_QUEUE )
> +    :name: MEDIA_REQUEST_IOC_QUEUE
> +
> +
> +Arguments
> +=========
> +
> +``request_fd``
> +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
> +
> +
> +Description
> +===========
> +
> +If the media device supports :ref:`requests <media-request-api>`, then
> +this request ioctl can be used to queue a previously allocated request.
> +
> +If the request was successfully queued, then the file descriptor can be
> +:ref:`polled <request-func-poll>` to wait for the request to complete.
> +
> +If the request was already queued before, then ``EBUSY`` is returned.
> +Other errors can be returned if the contents of the request contained
> +invalid or inconsistent data, see the next section for a list of
> +common error codes. On error both the request and driver state are unchanged.
> +
> +Typically if you get an error here, then that means that the application
> +did something wrong and you have to fix the application.
> +
> +Once a request is queued, then the driver is required to gracefully handle
> +errors that occur when the request is applied to the hardware. The
> +exception is the ``EIO`` error which signals a fatal error that requires
> +the application to stop streaming to reset the hardware state.
> +
> +It is not allowed to mix queuing requests with queuing buffers directly
> +(without a request). ``EPERM`` will be returned if the first buffer was
> +queued directly and you next try to queue a request, or vice versa.
> +
> +A request must contain at least one buffer, otherwise this ioctl will
> +return an ``ENOENT`` error.
> +
> +Return Value
> +============
> +
> +On success 0 is returned, on error -1 and the ``errno`` variable is set
> +appropriately. The generic error codes are described at the
> +:ref:`Generic Error Codes <gen-errors>` chapter.
> +
> +EBUSY
> +    The request was already queued.
> +EPERM
> +    The first buffer was queued directly, but now you try to use a
> +    request. It is not permitted to mix the two APIs.

Cosmetic only, but perhaps "The application queued the first buffer
directly, but later attempted to use a request."?

> +ENOENT
> +    The request did not contain any buffers. All requests are required
> +    to have at least one buffer. This can also be returned if required
> +    controls are missing.
> +ENOMEM
> +    Out of memory when allocating internal data structures for this
> +    request.
> +EINVAL
> +    The request has invalid data.
> +EIO
> +    The hardware is in a bad state. To recover, stop streaming to reset
> +    the hardware state. Then try to restart streaming.

Cosmetic: "To recover, the application needs to stop streaming to
reset the hardware state and then try to restart streaming."?

> diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
> new file mode 100644
> index 000000000000..7ede0584a0d7
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
> @@ -0,0 +1,51 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +.. _media_request_ioc_reinit:
> +
> +******************************
> +ioctl MEDIA_REQUEST_IOC_REINIT
> +******************************
> +
> +Name
> +====
> +
> +MEDIA_REQUEST_IOC_REINIT - Re-initialize a request
> +
> +
> +Synopsis
> +========
> +
> +.. c:function:: int ioctl( int request_fd, MEDIA_REQUEST_IOC_REINIT )
> +    :name: MEDIA_REQUEST_IOC_REINIT
> +
> +
> +Arguments
> +=========
> +
> +``request_fd``
> +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
> +
> +Description
> +===========
> +
> +If the media device supports :ref:`requests <media-request-api>`, then
> +this request ioctl can be used to re-initialize a previously allocated
> +request.
> +
> +Re-initializing a request will clear any existing data from the request.
> +This avoids having to :ref:`close() <request-func-close>` a completed
> +request and allocate a new request. Instead the completed request can just
> +be re-initialized and it is ready to be used again.
> +
> +A request can only be re-initialized if it either has not been queued
> +yet, or if it was queued and completed. Otherwise it will set ``errno``
> +to ``EBUSY``. No other error codes can be returned.
> +
> +Return Value
> +============
> +
> +On success 0 is returned, on error -1 and the ``errno`` variable is set
> +appropriately.
> +
> +EBUSY
> +    The request is queued but not yet completed.
> diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
> new file mode 100644
> index 000000000000..3c49627acb72
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/request-api.rst
> @@ -0,0 +1,247 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _media-request-api:
> +
> +Request API
> +===========
> +
> +The Request API has been designed to allow V4L2 to deal with requirements of
> +modern devices (stateless codecs, complex camera pipelines, ...) and APIs
> +(Android Codec v2). One such requirement is the ability for devices belonging to
> +the same pipeline to reconfigure and collaborate closely on a per-frame basis.
> +Another is efficient support of stateless codecs, which need per-frame controls
> +to be set synchronously in order to be used efficiently.

I think "synchronously" would match what we could do without Request
API (wait for 1 frame to be dequeued, set control, queue next frame,
etc.) and it would be inefficient. Perhaps "Another is efficient
support of stateless codecs, which need controls to be set for exact
frames beforehand to be used efficiently."?

> +
> +Supporting these features without the Request API is not always possible and if
> +it is, it is terribly inefficient: user-space would have to flush all activity
> +on the media pipeline, reconfigure it for the next frame, queue the buffers to
> +be processed with that configuration, and wait until they are all available for
> +dequeuing before considering the next frame. This defeats the purpose of having
> +buffer queues since in practice only one buffer would be queued at a time.
> +
> +The Request API allows a specific configuration of the pipeline (media
> +controller topology + controls for each media entity) to be associated with
> +specific buffers. The parameters are applied by each participating device as
> +buffers associated to a request flow in. This allows user-space to schedule
> +several tasks ("requests") with different parameters in advance, knowing that
> +the parameters will be applied when needed to get the expected result. Control
> +values at the time of request completion are also available for reading.
> +
> +Usage
> +=====
> +
> +The Request API is used on top of standard media controller and V4L2 calls,
> +which are augmented with an extra ``request_fd`` parameter. Requests themselves
> +are allocated from the supporting media controller node.
> +
> +Request Allocation
> +------------------
> +
> +User-space allocates requests using :ref:`MEDIA_IOC_REQUEST_ALLOC`
> +for the media device node. This returns a file descriptor representing the
> +request. Typically, several such requests will be allocated.
> +
> +Request Preparation
> +-------------------
> +
> +Standard V4L2 ioctls can then receive a request file descriptor to express the
> +fact that the ioctl is part of said request, and is not to be applied
> +immediately. See :ref:`MEDIA_IOC_REQUEST_ALLOC` for a list of ioctls that
> +support this. Controls set with a ``request_fd`` parameter are stored instead
> +of being immediately applied, and buffers queued to a request do not enter the
> +regular buffer queue until the request itself is queued.
> +
> +Request Submission
> +------------------
> +
> +Once the parameters and buffers of the request are specified, it can be
> +queued by calling :ref:`MEDIA_REQUEST_IOC_QUEUE` on the request FD. A request
> +must contain at least one buffer, otherwise ``ENOENT`` is returned.
> +This will make the buffers associated to the request available to their driver,
> +which can then apply the associated controls as buffers are processed. A queued
> +request cannot be modified anymore.
> +
> +.. caution::
> +   For :ref:`memory-to-memory devices <codec>` you can use requests only for
> +   output buffers, not for capture buffers. Attempting to add a capture buffer
> +   to a request will result in an ``EPERM`` error.
> +
> +If the request contains parameters for multiple entities, individual drivers may
> +synchronize so the requested pipeline's topology is applied before the buffers
> +are processed. Media controller drivers do a best effort implementation since
> +perfect atomicity may not be possible due to hardware limitations.
> +
> +.. caution::
> +
> +   It is not allowed to mix queuing requests with directly queuing buffers: whichever
> +   method is used first locks this in place until :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
> +   is called or the device is :ref:`closed <func-close>`. Attempts to
> +   directly queue a buffer when earlier a buffer was queued via a request or
> +   vice versa will result in an ``EPERM`` error.
> +
> +Controls can still be set without a request and are applied immediately,
> +regardless of whether a request is in use or not.
> +
> +.. caution::
> +
> +   Setting the same control through a request and also directly can lead to
> +   undefined behavior!
> +
> +User-space can :ref:`poll() <request-func-poll>` a request FD in order to
> +wait until the request completes. A request is considered complete once all its
> +associated buffers are available for dequeuing and all the associated controls
> +have been updated with the values at the time of completion. Note that user-space
> +does not need to wait for the request to complete to dequeue its buffers: buffers
> +that are available halfway through a request can be dequeued independently of the
> +request's state.
> +
> +A completed request contains the state of the request at the time of the
> +request completion. User-space can query that state by calling
> +:ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with the request FD.
> +Calling :ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` for a
> +request that has been queued but not yet completed will return ``EBUSY``
> +since the control values might be changed at any time by the driver while the
> +request is in flight.
> +
> +Recycling and Destruction
> +-------------------------
> +
> +Finally, a completed request can either be discarded or be reused. Calling
> +:ref:`close() <request-func-close>` on a request FD will make that FD unusable
> +and the request will be freed once it is no longer in use by the kernel. That
> +is, if the request is queued and then the FD is closed, then it won't be freed
> +until the driver completed the request.
> +
> +The :ref:`MEDIA_REQUEST_IOC_REINIT` will clear a request's state and make it
> +available again. No state is retained by this operation: the request is as
> +if it had just been allocated.
> +
> +Example for a Codec Device
> +--------------------------
> +
> +For use-cases such as :ref:`codecs <codec>`, the request API can be used
> +to associate specific controls to
> +be applied by the driver for the OUTPUT buffer, allowing user-space
> +to queue many such buffers in advance. It can also take advantage of requests'
> +ability to capture the state of controls when the request completes to read back
> +information that may be subject to change.
> +
> +Put into code, after obtaining a request, user-space can assign controls and one
> +OUTPUT buffer to it:
> +
> +.. code-block:: c
> +
> +       struct v4l2_buffer buf;
> +       struct v4l2_ext_controls ctrls;
> +       struct media_request_alloc alloc = { 0 };
> +       int req_fd;
> +       ...
> +       if (ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &alloc))
> +               return some_error;
> +       req_fd = alloc.fd;
> +       ...
> +       ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
> +       ctrls.request_fd = req_fd;
> +       if (ioctl(codec_fd, VIDIOC_S_EXT_CTRLS, &ctrls))
> +               return some_error;
> +       ...
> +       buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +       buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;
> +       buf.request_fd = req_fd;
> +       if (ioctl(codec_fd, VIDIOC_QBUF, &buf))
> +               return some_error;
> +
> +Note that there is typically no need to use the Request API for CAPTURE buffers
> +since there are no per-frame settings to report there.
> +
> +Once the request is fully prepared, it can be queued to the driver:
> +
> +.. code-block:: c
> +
> +       if (ioctl(req_fd, MEDIA_REQUEST_IOC_QUEUE))
> +               return some_error;

This may suggest that it's okay to ignore the error code and just
handle all the errors the same way. Perhaps "return some_error; /*
check errno for exact error code */"?

> +
> +User-space can then either wait for the request to complete by calling poll() on
> +its file descriptor, or start dequeuing CAPTURE buffers. Most likely, it will
> +want to get CAPTURE buffers as soon as possible and this can be done using a
> +regular DQBUF:
> +
> +.. code-block:: c
> +
> +       struct v4l2_buffer buf;
> +
> +       memset(&buf, 0, sizeof(buf));
> +       buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       if (ioctl(codec_fd, VIDIOC_DQBUF, &buf))
> +               return some_error;
> +
> +Note that this example assumes for simplicity that for every OUTPUT buffer
> +there will be one CAPTURE buffer, but this does not have to be the case.
> +
> +We can then, after ensuring that the request is completed via polling the
> +request FD, query control values at the time of its completion via a
> +call to :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
> +This is particularly useful for volatile controls for which we want to
> +query values as soon as the capture buffer is produced.
> +
> +.. code-block:: c
> +
> +       struct pollfd pfd = { .events = POLLPRI, .fd = request_fd };

req_fd

> +       poll(&pfd, 1, -1);
> +       ...
> +       ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
> +       ctrls.request_fd = req_fd;
> +       if (ioctl(codec_fd, VIDIOC_G_EXT_CTRLS, &ctrls))
> +               return some_error;
> +
> +Once we don't need the request anymore, we can either recycle it for reuse with
> +:ref:`MEDIA_REQUEST_IOC_REINIT`...
> +
> +.. code-block:: c
> +
> +       if (ioctl(req_fd, MEDIA_REQUEST_IOC_REINIT))
> +               return some_error;
> +
> +... or close its file descriptor to completely dispose of it.
> +
> +.. code-block:: c
> +
> +       close(req_fd);
> +
> +Example for a Simple Capture Device
> +-----------------------------------
> +
> +With a simple capture device, requests can be used to specify controls to apply
> +for a given CAPTURE buffer.
> +
> +.. code-block:: c
> +
> +       struct v4l2_buffer buf;
> +       struct v4l2_ext_controls ctrls;
> +       struct media_request_alloc alloc = { 0 };
> +       int req_fd;
> +       ...
> +       if (ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &alloc))
> +               return some_error;
> +       req_fd = alloc.fd;
> +       ...
> +       ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
> +       ctrls.request_fd = req_fd;
> +       if (ioctl(camera_fd, VIDIOC_S_EXT_CTRLS, &ctrls))
> +               return some_error;
> +       ...
> +       buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;
> +       buf.request_fd = req_fd;
> +       if (ioctl(camera_fd, VIDIOC_QBUF, &buf))
> +               return some_error;
> +
> +Once the request is fully prepared, it can be queued to the driver:
> +
> +.. code-block:: c
> +
> +       if (ioctl(req_fd, MEDIA_REQUEST_IOC_QUEUE))
> +               return some_error;
> +
> +User-space can then dequeue buffers, wait for the request completion, query
> +controls and recycle the request as in the M2M example above.
> diff --git a/Documentation/media/uapi/mediactl/request-func-close.rst b/Documentation/media/uapi/mediactl/request-func-close.rst
> new file mode 100644
> index 000000000000..1195f493bf05
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/request-func-close.rst
> @@ -0,0 +1,49 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _request-func-close:
> +
> +***************
> +request close()
> +***************
> +
> +Name
> +====
> +
> +request-close - Close a request file descriptor
> +
> +
> +Synopsis
> +========
> +
> +.. code-block:: c
> +
> +    #include <unistd.h>
> +
> +
> +.. c:function:: int close( int fd )
> +    :name: req-close
> +
> +Arguments
> +=========
> +
> +``fd``
> +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
> +

I guess for now we're not considering exchanging those between
processes, but even then, this could be a dup()ed descriptor too.

> +
> +Description
> +===========
> +
> +Closes the request file descriptor. Resources associated with the file descriptor
> +are freed once the driver has completed the request and no longer needs to
> +reference it.

and any other dup()s of that descriptor are closed too.

> +
> +
> +Return Value
> +============
> +
> +:ref:`close() <request-func-close>` returns 0 on success. On error, -1 is
> +returned, and ``errno`` is set appropriately. Possible error codes are:
> +
> +EBADF
> +    ``fd`` is not a valid open file descriptor.
> diff --git a/Documentation/media/uapi/mediactl/request-func-ioctl.rst b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
> new file mode 100644
> index 000000000000..33cadfd6a90b
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
> @@ -0,0 +1,68 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _request-func-ioctl:
> +
> +***************
> +request ioctl()
> +***************
> +
> +Name
> +====
> +
> +request-ioctl - Control a request file descriptor
> +
> +
> +Synopsis
> +========
> +
> +.. code-block:: c
> +
> +    #include <sys/ioctl.h>
> +
> +
> +.. c:function:: int ioctl( int fd, int cmd, void *argp )
> +    :name: req-ioctl
> +
> +Arguments
> +=========
> +
> +``fd``
> +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
> +
> +``cmd``
> +    The request ioctl command code as defined in the media.h header file, for
> +    example :ref:`MEDIA_REQUEST_IOC_QUEUE`.
> +
> +``argp``
> +    Pointer to a request-specific structure.
> +
> +
> +Description
> +===========
> +
> +The :ref:`ioctl() <request-func-ioctl>` function manipulates request
> +parameters. The argument ``fd`` must be an open file descriptor.
> +
> +The ioctl ``cmd`` code specifies the request function to be called. It
> +has encoded in it whether the argument is an input, output or read/write
> +parameter, and the size of the argument ``argp`` in bytes.
> +
> +Macros and structures definitions specifying request ioctl commands and
> +their parameters are located in the media.h header file. All request ioctl
> +commands, their respective function and parameters are specified in
> +:ref:`media-user-func`.
> +
> +
> +Return Value
> +============
> +
> +On success 0 is returned, on error -1 and the ``errno`` variable is set
> +appropriately. The generic error codes are described at the
> +:ref:`Generic Error Codes <gen-errors>` chapter.
> +
> +Command-specific error codes are listed in the individual command
> +descriptions.
> +
> +When an ioctl that takes an output or read/write parameter fails, the
> +parameter remains unmodified.
> diff --git a/Documentation/media/uapi/mediactl/request-func-poll.rst b/Documentation/media/uapi/mediactl/request-func-poll.rst
> new file mode 100644
> index 000000000000..930862b702ff
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/request-func-poll.rst
> @@ -0,0 +1,74 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _request-func-poll:
> +
> +**************
> +request poll()
> +**************
> +
> +Name
> +====
> +
> +request-poll - Wait for some event on a file descriptor
> +
> +
> +Synopsis
> +========
> +
> +.. code-block:: c
> +
> +    #include <sys/poll.h>
> +
> +
> +.. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
> +   :name: request-poll
> +
> +Arguments
> +=========
> +
> +``ufds``
> +   List of FD events to be watched
> +
> +``nfds``
> +   Number of FD events at the \*ufds array
> +
> +``timeout``
> +   Timeout to wait for events
> +
> +
> +Description
> +===========
> +
> +With the :c:func:`poll() <request-func-poll>` function applications can wait
> +for a request to complete.
> +
> +On success :c:func:`poll() <request-func-poll>` returns the number of file
> +descriptors that have been selected (that is, file descriptors for which the
> +``revents`` field of the respective struct :c:type:`pollfd`
> +is non-zero). Request file descriptor set the ``POLLPRI`` flag in ``revents``
> +when the request was completed.  When the function times out it returns
> +a value of zero, on failure it returns -1 and the ``errno`` variable is
> +set appropriately.

Should we also reserve POLLERR for error signaling purposes? Given the
drivers being expected to apply the state gracefully and also that we
could have a failure reported by respective buffer anyway, maybe no
need.

> +
> +
> +Return Value
> +============
> +
> +On success, :c:func:`poll() <request-func-poll>` returns the number of
> +structures which have non-zero ``revents`` fields, or zero if the call
> +timed out. On error -1 is returned, and the ``errno`` variable is set
> +appropriately:
> +
> +``EBADF``
> +    One or more of the ``ufds`` members specify an invalid file
> +    descriptor.
> +
> +``EFAULT``
> +    ``ufds`` references an inaccessible memory area.
> +
> +``EINTR``
> +    The call was interrupted by a signal.
> +
> +``EINVAL``
> +    The ``nfds`` argument is greater than ``OPEN_MAX``.
> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> index e2c85ddc990b..dd0065a95ea0 100644
> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst
> @@ -306,10 +306,15 @@ struct v4l2_buffer
>        - A place holder for future extensions. Drivers and applications
>         must set this to 0.
>      * - __u32
> -      - ``reserved``
> +      - ``request_fd``
>        -
> -      - A place holder for future extensions. Drivers and applications
> -       must set this to 0.
> +      - The file descriptor of the request to queue the buffer to. If specified
> +        and flag ``V4L2_BUF_FLAG_REQUEST_FD`` is set, then the buffer will be
> +       queued to that request. This is set by the user when calling
> +       :ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
> +       If the device does not support requests, then ``EPERM`` will be returned.
> +       If requests are supported but an invalid request FD is given, then
> +       ``ENOENT`` will be returned.
>
>
>
> @@ -514,6 +519,11 @@ Buffer Flags
>         streaming may continue as normal and the buffer may be reused
>         normally. Drivers set this flag when the ``VIDIOC_DQBUF`` ioctl is
>         called.
> +    * .. _`V4L2-BUF-FLAG-IN-REQUEST`:
> +
> +      - ``V4L2_BUF_FLAG_IN_REQUEST``
> +      - 0x00000080
> +      - This buffer is part of a request that hasn't been queued yet.
>      * .. _`V4L2-BUF-FLAG-KEYFRAME`:
>
>        - ``V4L2_BUF_FLAG_KEYFRAME``
> @@ -589,6 +599,11 @@ Buffer Flags
>         the format. Any Any subsequent call to the
>         :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
>         but return an ``EPIPE`` error code.
> +    * .. _`V4L2-BUF-FLAG-REQUEST-FD`:
> +
> +      - ``V4L2_BUF_FLAG_REQUEST_FD``
> +      - 0x00800000
> +      - The ``request_fd`` field contains a valid file descriptor.
>      * .. _`V4L2-BUF-FLAG-TIMESTAMP-MASK`:
>
>        - ``V4L2_BUF_FLAG_TIMESTAMP_MASK``
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> index 2011c2b2ee67..c592074be273 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> @@ -95,6 +95,26 @@ appropriate. In the first case the new value is set in struct
>  is inappropriate (e.g. the given menu index is not supported by the menu
>  control), then this will also result in an ``EINVAL`` error code error.
>
> +If ``request_fd`` is set to a not-yet-queued :ref:`request <media-request-api>`
> +file descriptor and ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``,
> +then the controls are not applied immediately when calling
> +:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, but instead are applied by
> +the driver for the buffer associated with the same request.
> +If the device does not support requests, then ``EPERM`` will be returned.
> +If requests are supported but an invalid request FD is given, then
> +``ENOENT`` will be returned.
> +
> +An attempt to call :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` for a
> +request that has already been queued will result in an ``EBUSY`` error.
> +
> +If ``request_fd`` is specified and ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``
> +during a call to :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, then the
> +returned values will be the values currently set for the request (or the
> +hardware value if none is set) if the request has not yet been queued, or the
> +values of the controls at the time of request completion if it has already
> +completed. Attempting to get controls while the request has been queued but
> +not yet completed will result in an ``EBUSY`` error.
> +
>  The driver will only set/get these controls if all control values are
>  correct. This prevents the situation where only some of the controls
>  were set/get. Only low-level errors (e. g. a failed i2c command) can
> @@ -110,15 +130,13 @@ still cause this situation.
>  .. flat-table:: struct v4l2_ext_control
>      :header-rows:  0
>      :stub-columns: 0
> -    :widths:       1 1 1 2
> +    :widths:       1 1 3
>
>      * - __u32
>        - ``id``
> -      -
>        - Identifies the control, set by the application.
>      * - __u32
>        - ``size``
> -      -
>        - The total size in bytes of the payload of this control. This is
>         normally 0, but for pointer controls this should be set to the
>         size of the memory containing the payload, or that will receive
> @@ -135,51 +153,43 @@ still cause this situation.
>            *length* of the string may well be much smaller.
>      * - __u32
>        - ``reserved2``\ [1]
> -      -
>        - Reserved for future extensions. Drivers and applications must set
>         the array to zero.
> -    * - union
> +    * - union {
>        - (anonymous)
> -    * -
> -      - __s32
> +    * - __s32
>        - ``value``
>        - New value or current value. Valid if this control is not of type
>         ``V4L2_CTRL_TYPE_INTEGER64`` and ``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is
>         not set.
> -    * -
> -      - __s64
> +    * - __s64
>        - ``value64``
>        - New value or current value. Valid if this control is of type
>         ``V4L2_CTRL_TYPE_INTEGER64`` and ``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is
>         not set.
> -    * -
> -      - char *
> +    * - char *
>        - ``string``
>        - A pointer to a string. Valid if this control is of type
>         ``V4L2_CTRL_TYPE_STRING``.
> -    * -
> -      - __u8 *
> +    * - __u8 *
>        - ``p_u8``
>        - A pointer to a matrix control of unsigned 8-bit values. Valid if
>         this control is of type ``V4L2_CTRL_TYPE_U8``.
> -    * -
> -      - __u16 *
> +    * - __u16 *
>        - ``p_u16``
>        - A pointer to a matrix control of unsigned 16-bit values. Valid if
>         this control is of type ``V4L2_CTRL_TYPE_U16``.
> -    * -
> -      - __u32 *
> +    * - __u32 *
>        - ``p_u32``
>        - A pointer to a matrix control of unsigned 32-bit values. Valid if
>         this control is of type ``V4L2_CTRL_TYPE_U32``.
> -    * -
> -      - void *
> +    * - void *
>        - ``ptr``
>        - A pointer to a compound type which can be an N-dimensional array
>         and/or a compound type (the control's type is >=
>         ``V4L2_CTRL_COMPOUND_TYPES``). Valid if
>         ``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is set for this control.
> -
> +    * - }
>
>  .. tabularcolumns:: |p{4.0cm}|p{2.2cm}|p{2.1cm}|p{8.2cm}|
>
> @@ -190,12 +200,11 @@ still cause this situation.
>  .. flat-table:: struct v4l2_ext_controls
>      :header-rows:  0
>      :stub-columns: 0
> -    :widths:       1 1 2 1
> +    :widths:       1 1 3
>
> -    * - union
> +    * - union {
>        - (anonymous)
> -    * -
> -      - __u32
> +    * - __u32
>        - ``ctrl_class``
>        - The control class to which all controls belong, see
>         :ref:`ctrl-class`. Drivers that use a kernel framework for
> @@ -204,18 +213,21 @@ still cause this situation.
>         support this can be tested by setting ``ctrl_class`` to 0 and
>         calling :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with a ``count`` of 0. If that
>         succeeds, then the driver supports this feature.
> -    * -
> -      - __u32
> +    * - __u32
>        - ``which``
>        - Which value of the control to get/set/try.
>         ``V4L2_CTRL_WHICH_CUR_VAL`` will return the current value of the
> -       control and ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
> -       value of the control.
> +       control, ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
> +       value of the control and ``V4L2_CTRL_WHICH_REQUEST_VAL`` indicates that
> +       these controls have to be retrieved from a request or tried/set for
> +       a request. In the latter case the ``request_fd`` field contains the
> +       file descriptor of the request that should be used. If the device
> +       does not support requests, then ``EPERM`` will be returned.
>
>         .. note::
>
> -          You can only get the default value of the control,
> -          you cannot set or try it.
> +          When using ``V4L2_CTRL_WHICH_DEF_VAL`` note that You can only
> +          get the default value of the control, you cannot set or try it.
>
>         For backwards compatibility you can also use a control class here
>         (see :ref:`ctrl-class`). In that case all controls have to
> @@ -226,6 +238,7 @@ still cause this situation.
>         by setting ctrl_class to ``V4L2_CTRL_WHICH_CUR_VAL`` and calling
>         VIDIOC_TRY_EXT_CTRLS with a count of 0. If that fails, then the
>         driver does not support ``V4L2_CTRL_WHICH_CUR_VAL``.
> +    * - }
>      * - __u32
>        - ``count``
>        - The number of controls in the controls array. May also be zero.
> @@ -272,8 +285,15 @@ still cause this situation.
>         then you can call :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` to try to discover the
>         actual control that failed the validation step. Unfortunately,
>         there is no ``TRY`` equivalent for :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
> +    * - __s32
> +      - ``request_fd``
> +      - File descriptor of the request to be used by this operation. Only
> +       valid if ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``.
> +       If the device does not support requests, then ``EPERM`` will be returned.
> +       If requests are supported but an invalid request FD is given, then
> +       ``ENOENT`` will be returned.
>      * - __u32
> -      - ``reserved``\ [2]
> +      - ``reserved``\ [1]
>        - Reserved for future extensions.
>
>         Drivers and applications must set the array to zero.
> @@ -362,7 +382,9 @@ ERANGE
>  EBUSY
>      The control is temporarily not changeable, possibly because another
>      applications took over control of the device function this control
> -    belongs to.
> +    belongs to, or (if the ``which`` field was set to
> +    ``V4L2_CTRL_WHICH_REQUEST_VAL``) the request was queued but not yet
> +    completed.
>
>  ENOSPC
>      The space reserved for the control's payload is insufficient. The
> @@ -372,3 +394,11 @@ ENOSPC
>  EACCES
>      Attempt to try or set a read-only control or to get a write-only
>      control.
> +
> +EPERM
> +    The ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL`` but the
> +    device does not support requests.
> +
> +ENOENT
> +    The ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL`` but the
> +    the given ``request_fd`` was invalid.
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index 9e448a4aa3aa..886af7590ff5 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -65,7 +65,7 @@ To enqueue a :ref:`memory mapped <mmap>` buffer applications set the
>  with a pointer to this structure the driver sets the
>  ``V4L2_BUF_FLAG_MAPPED`` and ``V4L2_BUF_FLAG_QUEUED`` flags and clears
>  the ``V4L2_BUF_FLAG_DONE`` flag in the ``flags`` field, or it returns an
> -EINVAL error code.
> +``EINVAL`` error code.
>
>  To enqueue a :ref:`user pointer <userp>` buffer applications set the
>  ``memory`` field to ``V4L2_MEMORY_USERPTR``, the ``m.userptr`` field to
> @@ -98,6 +98,25 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
>  :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
>  device is closed.
>
> +The ``request_fd`` field can be used with the ``VIDIOC_QBUF`` ioctl to specify
> +the file descriptor of a :ref:`request <media-request-api>`, if requests are
> +in use. Setting it means that the buffer will not be passed to the driver
> +until the request itself is queued. Also, the driver will apply any
> +settings associated with the request for this buffer. This field will
> +be ignored unless the ``V4L2_BUF_FLAG_REQUEST_FD`` flag is set.
> +If the device does not support requests, then ``EPERM`` will be returned.
> +If requests are supported but an invalid request FD is given, then
> +``ENOENT`` will be returned.
> +
> +.. caution::
> +   It is not allowed to mix queuing requests with queuing buffers directly.
> +   ``EPERM`` will be returned if the first buffer was queued directly and
> +   you next try to queue a request, or vice versa.

"and then the application tries to queue a request, or"

> +
> +   For :ref:`memory-to-memory devices <codec>` you can specify the
> +   ``request_fd`` only for output buffers, not for capture buffers. Attempting
> +   to specify this for a capture buffer will result in an ``EPERM`` error.
> +
>  Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
>  (capturing) or displayed (output) buffer from the driver's outgoing
>  queue. They just set the ``type``, ``memory`` and ``reserved`` fields of
> @@ -153,3 +172,14 @@ EPIPE
>      ``VIDIOC_DQBUF`` returns this on an empty capture queue for mem2mem
>      codecs if a buffer with the ``V4L2_BUF_FLAG_LAST`` was already
>      dequeued and no new buffers are expected to become available.
> +
> +EPERM
> +    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
> +    support requests. Or the first buffer was queued via a request, but
> +    now you try to queue it directly. It is not permitted to mix the two APIs.

Ditto (avoid "you").

Best regards,
Tomasz
