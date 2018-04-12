Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:33549 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeDLIvX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 04:51:23 -0400
Received: by mail-ua0-f176.google.com with SMTP id q26so2976345uab.0
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 01:51:23 -0700 (PDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com. [209.85.213.53])
        by smtp.gmail.com with ESMTPSA id r35sm736172uai.0.2018.04.12.01.51.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Apr 2018 01:51:21 -0700 (PDT)
Received: by mail-vk0-f53.google.com with SMTP id q198so2783927vke.3
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 01:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-25-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-25-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 12 Apr 2018 08:51:10 +0000
Message-ID: <CAAFQd5CgD18irnZJ9xA6wOVYoNOWZX9hXXhJ+eP+Fqe2-ajyCA@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 24/29] Documentation: v4l: document request API
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 9, 2018 at 11:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
[snip]
> @@ -514,6 +517,11 @@ Buffer Flags
>          streaming may continue as normal and the buffer may be reused
>          normally. Drivers set this flag when the ``VIDIOC_DQBUF`` ioctl is
>          called.
> +    * .. _`V4L2-BUF-FLAG-IN-REQUEST`:
> +
> +      - ``V4L2_BUF_FLAG_IN_REQUEST``
> +      - 0x00000080
> +      - This buffer is part of a request the hasn't been queued yet.

typo: s/the hasn't/that hasn't/

[snip]
> +Usage
> +=====
> +
> +The Request API is used on top of standard media controller and V4L2
calls,
> +which are augmented with an extra ``request_fd`` parameter. Request
themselves
> +are allocated from either a supporting V4L2 device node, or a supporting
media
> +controller node. The origin of requests determine their scope: requests
> +allocated from a V4L2 device node can only act on that device, whereas
requests
> +allocated from a media controller node can control the whole pipeline of
the
> +controller.

Current patch set doesn't support allocating requests from V4L2 device
nodes.

> +
> +Request Allocation
> +------------------
> +
> +User-space allocates requests using the ``VIDIOC_NEW_REQUEST`` (for V4L2
device

VIDIOC_NEW_REQUEST doesn't exist in current patch set. (We should add this
bit to documentation, when we add respective functionality.)

> +requests) or ``MEDIA_IOC_NEW_REQUEST`` (for media controller requests)
on an

s/MEDIA_IOC_NEW_REQUEST/MEDIA_IOC_REQUEST_ALLOC/

> +opened device or media node. This returns a file descriptor representing
the
> +request. Typically, several such requests will be allocated.
> +
> +Request Preparation
> +-------------------
> +
> +Standard V4L2 ioctls can then receive a request file descriptor to
express the
> +fact that the ioctl is part of said request, and is not to be applied
> +immediately. V4L2 ioctls supporting this are
:c:func:`VIDIOC_S_EXT_CTRLS` and
> +:c:func:`VIDIOC_QBUF`. Controls set with a request parameter are stored
instead
> +of being immediately applied, and queued buffers not enter the regular
buffer
> +queue until the request is submitted. Only one buffer can be queued to a
given
> +queue for a given request.
> +
> +Request Submission
> +------------------
> +
> +Once the parameters and buffers of the request are specified, it can be
> +submitted by calling the ``MEDIA_REQUEST_IOC_SUBMIT`` ioctl on the
request FD.

s/MEDIA_REQUEST_IOC_SUBMIT/MEDIA_REQUEST_IOC_QUEUE/

> +This will make the buffers associated to the request available to their
driver,
> +which can then apply the saved controls as buffers are processed. A
submitted
> +request cannot be modified anymore.
> +
> +If several devices are part of the request, individual drivers may
synchronize
> +so the requested pipeline's topology is applied before the buffers are
> +processed. This is at the discretion of media controller drivers and is
not a
> +requirement.
> +
> +Buffers queued without an associated request after a request-bound
buffer will
> +be processed using the state of the hardware at the time of the request
> +completion. All the same, controls set without a request are applied
> +immediately, regardless of whether a request is in use or not.
> +
> +User-space can ``poll()`` a request FD in order to wait until the request
> +completes. A request is considered complete once all its associated
buffers are
> +available for dequeing. Note that user-space does not need to wait for
the
> +request to complete to dequeue its buffers: buffers that are available
halfway
> +through a request can be dequeued independently of the request's state.
> +
> +A completed request includes the state of all devices that had queued
buffers

Why storing state is gated on queued buffers? Perhaps more like "all
devices, which had their state affected by the request"?

> +associated with it at the time of the request completion. User-space can
query
> +that state by calling :c:func:`VIDIOC_G_EXT_CTRLS` with the request FD.
> +
> +Recycling and Destruction
> +-------------------------
> +
> +Finally, completed request can either be discarded or be reused. Calling
> +``close()`` on a request FD will make that FD unusable, freeing the
request if
> +it is not referenced elsewhere. The ``MEDIA_REQUEST_IOC_SUBMIT`` ioctl
will
> +clear a request's state and make it available again. No state is
retained by
> +this operation: the request is as if it had just been allocated.
> +
> +Example for a M2M Device
> +------------------------
> +
> +M2M devices are single-node V4L2 devices providing one OUTPUT queue (for
> +user-space
> +to provide input buffers) and one CAPTURE queue (to retrieve processed
data).
> +They are perfectly symetric, i.e. one buffer of input will produce one
buffer of
> +output. These devices are commonly used for frame processors or stateless
> +codecs.
> +
> +In this use-case, the request API can be used to associate specific
controls to
> +be applied by the driver before processing an OUTPUT buffer, allowing
user-space
> +to queue many such buffers in advance. It can also take advantage of
requests'
> +ability to capture the state of controls when the request completes to
read back
> +information that may be subject to change.
> +
> +Put into code, after obtaining a request, user-space can assign controls
and one
> +OUTPUT buffer to it:
> +
> +       struct v4l2_buf buf;

struct v4l2_buffer

> +       struct v4l2_ext_controls ctrls;
> +       struct media_request_new new = { 0 };

struct media_request_alloc

> +       int req_fd;
> +       ...
> +       ioctl(media_fd, VIDIOC_NEW_REQUEST, &new);

s/VIDIOC_NEW_REQUEST/MEDIA_IOC_REQUEST_ALLOC/

> +       req_fd = new.fd;
> +       ...
> +       ctrls.request_fd = req_fd;

ctrls.which = V4L2_CTRL_WHICH_REQUEST;

> +       ioctl(codec_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
> +       ...
> +       buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;

buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;

> +       buf.request_fd = req_fd;
> +       ioctl(codec_fd, VIDIOC_QBUF, &buf);
> +
> +Note that request_fd does not need to be specified for CAPTURE buffers:
since
> +there is symetry between the OUTPUT and CAPTURE queues, and requests are
> +processed in order of submission, we can know which CAPTURE buffer
corresponds
> +to which request.
> +
> +Once the request is fully prepared, it can be submitted to the driver:
> +
> +       ioctl(request_fd, MEDIA_REQUEST_IOC_SUBMIT, NULL);

s/MEDIA_REQUEST_IOC_SUBMIT/MEDIA_REQUEST_IOC_QUEUE/

> +
> +User-space can then either wait for the request to complete by calling
poll() on
> +its file descriptor, or start dequeuing CAPTURE buffers. Most likely, it
will
> +want to get CAPTURE buffers as soon as possible and this can be done
using a
> +regular DQBUF:
> +
> +       struct v4l2_buf buf;

struct v4l2_buffer

> +
> +       memset(&buf, 0, sizeof(buf));
> +       buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       ioctl(codec_fd, VIDIOC_DQBUF, &buf);
> +
> +We can then, after ensuring that the request is completed via polling the
> +request FD, query control values at the time of its completion via an
> +annotated call to G_EXT_CTRLS. This is particularly useful for volatile
controls
> +for which we want to query values as soon as the capture buffer is
produced.
> +
> +       struct pollfd pfd = { .events = POLLIN, .fd = request_fd };
> +       poll(&pfd, 1, -1);
> +       ...
> +       ctrls.request_fd = req_fd;

ctrls.which = V4L2_CTRL_WHICH_REQUEST;

> +       ioctl(codec_fd, VIDIOC_G_EXT_CTRLS, &ctrls);
> +
> +Once we don't need the request anymore, we can either recycle it for
reuse with
> +MEDIA_REQUEST_IOC_REINIT...
> +
> +       ioctl(request, MEDIA_REQUEST_IOC_REINIT, NULL);
> +
> +... or close its file descriptor to completely dispose of it.
> +
> +       close(request_fd);
> +
> +Example for a Simple Capture Device
> +-----------------------------------
> +
> +With a simple capture device, requests can be used to specify controls
to apply
> +to a given CAPTURE buffer. The driver will apply these controls before
producing
> +the marked CAPTURE buffer.
> +
> +       struct v4l2_buf buf;

struct v4l2_buffer

> +       struct v4l2_ext_controls ctrls;
> +       struct media_request_new new = { 0 };

struct media_request_alloc

> +       int req_fd;
> +       ...
> +       ioctl(camera_fd, VIDIOC_NEW_REQUEST, &new);
> +       req_fd = new.fd;
> +       ...
> +       ctrls.request_fd = req_fd;
> +       ioctl(camera_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
> +       ...
> +       buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       buf.request_fd = req_fd;

buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;

> +       ioctl(camera_fd, VIDIOC_QBUF, &buf);
> +
> +Once the request is fully prepared, it can be submitted to the driver:
> +
> +       ioctl(req_fd, MEDIA_REQUEST_IOC_SUBMIT, &cmd);

s/MEDIA_REQUEST_IOC_SUBMIT/MEDIA_REQUEST_IOC_QUEUE/

> +
> +User-space can then dequeue buffers, wait for the request completion,
query
> +controls and recycle the request as in the M2M example above.
> diff --git a/Documentation/media/uapi/v4l/user-func.rst
b/Documentation/media/uapi/v4l/user-func.rst
> index 3e0413b83a33..2c8238a2b188 100644
> --- a/Documentation/media/uapi/v4l/user-func.rst
> +++ b/Documentation/media/uapi/v4l/user-func.rst
> @@ -53,6 +53,7 @@ Function Reference
>       vidioc-g-std
>       vidioc-g-tuner
>       vidioc-log-status
> +    vidioc-new-request
>       vidioc-overlay
>       vidioc-prepare-buf
>       vidioc-qbuf
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> index 2011c2b2ee67..d31ef86c7caa 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> @@ -95,6 +95,17 @@ appropriate. In the first case the new value is set in
struct
>   is inappropriate (e.g. the given menu index is not supported by the menu
>   control), then this will also result in an ``EINVAL`` error code error.

> +If ``request_fd`` is set to a not-submitted request file descriptor,
then the

...and ``which`` is set to V4L2_CTRL_WHICH_REQUEST

> +controls are not applied immediately when calling
> +:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, but instead are applied
right
> +before the driver starts processing a buffer associated to the same
request.
> +
> +If ``request_fd`` is specified during a call to
> +:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, then the returned values
will

...and ``which`` is set to V4L2_CTRL_WHICH_REQUEST

> +be the values currently set for the request (or the hardware value if
none is
> +set) if the request has not yet completed, or the values of the controls
at the
> +time of request completion if it has already completed.
> +
>   The driver will only set/get these controls if all control values are
>   correct. This prevents the situation where only some of the controls
>   were set/get. Only low-level errors (e. g. a failed i2c command) can
> @@ -209,8 +220,10 @@ still cause this situation.
>         - ``which``
>         - Which value of the control to get/set/try.
>          ``V4L2_CTRL_WHICH_CUR_VAL`` will return the current value of the
> -       control and ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
> -       value of the control.
> +       control, ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
> +       value of the control and ``V4L2_CTRL_WHICH_REQUEST`` indicates
that
> +       these controls have to be retrieved from a request or tried/set
for
> +       a request.

>          .. note::

> @@ -272,8 +285,11 @@ still cause this situation.
>          then you can call :ref:`VIDIOC_TRY_EXT_CTRLS
<VIDIOC_G_EXT_CTRLS>` to try to discover the
>          actual control that failed the validation step. Unfortunately,
>          there is no ``TRY`` equivalent for :ref:`VIDIOC_G_EXT_CTRLS
<VIDIOC_G_EXT_CTRLS>`.
> +    * - __s32
> +      - ``request_fd``
> +       File descriptor of the request to be used by this operation (0 if
none).

-1 if none? Or maybe just say, valid only if ``which`` is
V4L2_CTRL_WHICH_REQUEST?

>       * - __u32
> -      - ``reserved``\ [2]
> +      - ``reserved``\ [1]
>         - Reserved for future extensions.

>          Drivers and applications must set the array to zero.
> diff --git a/Documentation/media/uapi/v4l/vidioc-new-request.rst
b/Documentation/media/uapi/v4l/vidioc-new-request.rst
> new file mode 100644
> index 000000000000..0038287f7d16
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/vidioc-new-request.rst

This whole file added here should probably be moved out to a separate patch
that adds documentation after we add the functionality.

Best regards,
Tomasz
