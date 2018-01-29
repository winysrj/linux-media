Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56565 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750959AbeA2QD7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 11:03:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 6/8] v4l2: document the request API interface
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180126060216.147918-1-acourbot@chromium.org>
 <20180126060216.147918-7-acourbot@chromium.org>
Message-ID: <eab05349-30ac-f023-75b1-4bb5512cb892@xs4all.nl>
Date: Mon, 29 Jan 2018 17:03:53 +0100
MIME-Version: 1.0
In-Reply-To: <20180126060216.147918-7-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/26/2018 07:02 AM, Alexandre Courbot wrote:
> Document how the request API can be used along with the existing V4L2
> interface.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  Documentation/media/uapi/v4l/buffer.rst      |  10 +-
>  Documentation/media/uapi/v4l/common.rst      |   1 +
>  Documentation/media/uapi/v4l/request-api.rst | 194 +++++++++++++++++++++++++++
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst |  21 +++
>  4 files changed, 223 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/request-api.rst
> 
> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> index ae6ee73f151c..9d082784081d 100644
> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst
> @@ -301,10 +301,14 @@ struct v4l2_buffer
>  	elements in the ``planes`` array. The driver will fill in the
>  	actual number of valid elements in that array.
>      * - __u32
> -      - ``reserved2``
> +      - ``request_fd``
>        -
> -      - A place holder for future extensions. Drivers and applications
> -	must set this to 0.
> +      - The file descriptor of the request associated with this buffer.
> +	user-space can set this when calling :ref:`VIDIOC_QBUF`, and drivers
> +	will return the request used when processing a buffer (if any) upon
> +	:ref:`VIDIOC_DQBUF`.
> +
> +	A value of 0 means the buffer is not associated with any request.
>      * - __u32
>        - ``reserved``
>        -
> diff --git a/Documentation/media/uapi/v4l/common.rst b/Documentation/media/uapi/v4l/common.rst
> index 13f2ed3fc5a6..a4aa0059d45a 100644
> --- a/Documentation/media/uapi/v4l/common.rst
> +++ b/Documentation/media/uapi/v4l/common.rst
> @@ -44,3 +44,4 @@ applicable to all devices.
>      crop
>      selection-api
>      streaming-par
> +    request-api
> diff --git a/Documentation/media/uapi/v4l/request-api.rst b/Documentation/media/uapi/v4l/request-api.rst
> new file mode 100644
> index 000000000000..a758a5fd3ca0
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/request-api.rst
> @@ -0,0 +1,194 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _media-request-api:
> +
> +Request API
> +===========
> +
> +The Request API has been designed to allow V4L2 to deal with requirements of
> +modern IPs (stateless codecs, MIPI cameras, ...) and APIs (Android Codec v2).
> +One such requirement is the ability for devices belonging to the same pipeline
> +to reconfigure and collaborate closely on a per-frame basis. Another is
> +efficient support of stateless codecs, which need per-frame controls to be set
> +asynchronously in order to be efficiently used.
> +
> +Supporting these features without the Request API is possible but terribly
> +inefficient: user-space would have to flush all activity on the media pipeline,
> +reconfigure it for the next frame, queue the buffers to be processed with that
> +configuration, and wait until they are all available for dequeing before
> +considering the next frame. This defeats the purpose of having buffer queues
> +since in practice only one buffer would be queued at a time.
> +
> +The Request API allows a specific configuration of the pipeline (media
> +controller topology + controls for each device) to be associated with specific
> +buffers. The parameters are applied by each participating device as buffers
> +associated to a request flow in. This allows user-space to schedule several
> +tasks ("requests") with different parameters in advance, knowing that the
> +parameters will be applied when needed to get the expected result. Controls
> +values at the time of request completion are also available for reading.
> +
> +Usage
> +=====
> +
> +The Request API is used on top of standard media controller and V4L2 calls,
> +which are augmented with an extra ``request_fd`` parameter. All operations on
> +requests themselves are performed using the command parameter of the
> +:c:func:`MEDIA_IOC_REQUEST_CMD` ioctl.
> +
> +Allocation
> +----------
> +
> +User-space allocates requests using the ``MEDIA_REQ_CMD_ALLOC`` command on
> +an opened media device. This returns a file descriptor representing the
> +request. Typically, several such requests will be allocated.
> +
> +Request Preparation
> +-------------------
> +
> +Standard V4L2 ioctls can then receive a request file descriptor to express the
> +fact that the ioctl is part of said request, and is not to be applied
> +immediately. V4L2 ioctls supporting this are :c:func:`VIDIOC_S_EXT_CTRLS` and
> +:c:func:`VIDIOC_QBUF`. Controls set with a request parameter are stored instead
> +of being immediately applied, and queued buffers will block the buffer queue
> +until the request becomes active.
> +
> +RFC Note: currently several buffers can be queued to the same queue with the
> +same request. The request parameters will be only be applied when processing
> +the first buffer. Does it make more sense to allow at most one buffer per
> +request per queue instead?

I think we should initially limit us to at most one buffer per queue per
request. If you don't want to make changes just queue a buffer without a
request fd, or possibly with an empty request (that needs to be defined!).

> +
> +Request Submission
> +------------------
> +
> +Once the parameters and buffers of the request are specified, it can be
> +submitted with the ``MEDIA_REQ_CMD_SUBMIT`` command. This will make the buffers
> +associated to the request available to their driver, which can then apply the
> +saved controls as buffers are processed. A submitted request cannot be used
> +with further :c:func:`VIDIOC_S_EXT_CTRLS` and :c:func:`VIDIOC_QBUF` ioctls.

I'd just keep this more general:

"A request cannot be modified anymore once it has been submitted."

> +
> +If several devices are part of the request, individual drivers may synchronize
> +so the requested pipeline's topology is applied before the buffers are
> +processed. This is at the discretion of the drivers and is not a requirement.
> +
> +Buffers queued without an associated request after a request-bound buffer will
> +be processed using the state of the hardware at the time of the request
> +completion. All the same, controls set without a request are applied
> +immediately, regardless of whether a request is in use or not.

Ah, OK. I agree.

> +
> +User-space can ``poll()`` a request FD in order to wait until the request
> +completes. A request is considered complete once all its associated buffers are
> +available for dequeing. Note that user-space does not need to wait for the
> +request to complete to dequeue its buffers: buffers that are available halfway
> +through a request can be dequeued independently of the request's state.
> +
> +A completed request includes the state of all devices that had queued buffers
> +associated with it at the time of the request completion. User-space can query
> +that state by calling :c:func:`VIDIOC_G_EXT_CTRLS` with the request FD.
> +
> +Recycling and Destruction
> +-------------------------
> +
> +Finally, completed request can either be discarded or be reused. Calling
> +``close()`` on a request FD will make that FD unusable, freeing the request if
> +it is not referenced elsewhere. The ``MEDIA_REQ_CMD_REINIT`` command will clear
> +a request's state and make it available again. No state is retained by this
> +operation: the request is as if it had just been allocated via
> +``MEDIA_REQ_CMD_ALLOC``.
> +
> +RFC Note: Since requests are represented by FDs themselves, the
> +``MEDIA_REQ_CMD_SUBMIT`` and ``MEDIA_REQ_CMD_REININT`` commands can be performed
> +on the request FD instead of the media device. This means the media device would
> +only need to manage ``MEDIA_REQ_CMD_ALLOC``, which could be turned into an
> +ioctl, while ``MEDIA_REQ_CMD_SUBMIT`` and ``MEDIA_REQ_CMD_REININT`` would
> +become ioctls on the request itself. This has the advantage of allowing
> +receivers of a request FD to submit the request, and also decouples requests
> +from the media device - a scenario that makes sense for stateless codecs where
> +the media device is not really useful.

I think allowing SUBMIT/REINIT to operate directly on the request fd makes sense.

A few questions that I haven't seen answered here:

- can I reinit a request if it hasn't yet been submitted? Or can this only be
  done on completed requests?
- can I reinit (or perhaps also alloc) a request based on an existing request?
  (sort of a clone operation). I can't remember what we decided in the Prague
  meeting, sorry about that.
- a request effectively contains the things you want to change, so anything not
  explicitly set in the request will have what value? This should be the current
  hardware value with any changes specified in preceding requests on top.
- add an RFC note that requests do not have to complete in the same order that they
  were queued. A codec driver can (at least in theory) hold on to a buffer
  containing a key frame until that frame is no longer needed. But this also
  relates to the fences support, so let's keep this an RFC for now until that
  patch series has been merged.
- how do we know that the request API is supported by a driver? I think we
  wanted a new capability for that?
- it is allowed to query the values of a submitted request, or will that return
  -EBUSY while it is not completed? I see no reason not to allow it.
- what happens when a value inside a request can't be applied? (e.g. due to a
  hardware error or some other unusual situation).

> +
> +Example for a Codec Device
> +--------------------------
> +
> +Codecs are single-node V4L2 devices providing one OUTPUT queue (for user-space
> +to provide input buffers) and one CAPTURE queue (to retrieve processed data).
> +
> +In this use-case, request API is used to associate specific controls to be
> +applied by the driver before processing a buffer from the OUTPUT queue. When
> +retrieving a buffer from a capture queue, user-space can then identify which
> +request, if any, produced it by looking at the request_fd field of the dequeued
> +v4l2_buffer.

I'd start with the code to allocate a request.

> +Put into code, after obtaining a request, user-space can assign controls and one
> +OUTPUT buffer to it:
> +
> +	struct v4l2_buf buf;
> +	struct v4l2_ext_controls ctrls;
> +	...
> +	ctrls.request_fd = req_fd;
> +	...
> +	ioctl(codec_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
> +	...
> +	buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	buf.request_fd = req_fd;
> +	ioctl(codec_fd, VIDIOC_QBUF, &buf);
> +
> +Note that request_fd shall not be specified for CAPTURE buffers.

I know why, but the less experienced reader won't. So this needs some additional
explanation.

> +
> +Once the request is fully prepared, it can be submitted to the driver:
> +
> +	struct media_request_cmd cmd;
> +
> +	memset(&cmd, 0, sizeof(cmd));
> +	cmd.cmd = MEDIA_REQ_CMD_SUBMIT;
> +	cmd.fd = request_fd;
> +	ioctl(media_fd, MEDIA_IOC_REQUEST_CMD, &cmd);
> +
> +User-space can then lookup the request_fd field of dequeued capture buffers to
> +confirm which one has been produced by the request.
> +
> +	struct v4l2_buf buf;
> +
> +	memset(&buf, 0, sizeof(buf));
> +	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	ioctl(codec_fd, VIDIOC_DQBUF, &buf);
> +
> +	if (buf.request_fd == request_fd)
> +		...
> +

I'm not sure this is correct. You set the request for the OUTPUT buffer, so when
you dequeue the OUTPUT buffer, then the request_fd is set to the original request.
But this is the CAPTURE buffer, and that has no requests at all.

BTW, you also want to show an example of getting the control once the request is
completed (e.g. status information), probably with a polling example as well.

> +Example for a Simple Capture Device
> +-----------------------------------
> +
> +With a simple capture device, requests can be used to specify controls to apply
> +to a given CAPTURE buffer. The driver will apply these controls before producing
> +the marked CAPTURE buffer.
> +
> +	struct v4l2_buf buf;
> +	struct v4l2_ext_controls ctrls;
> +	...
> +	ctrls.request_fd = req_fd;
> +	...
> +	ioctl(camera_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
> +	...
> +	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	buf.request_fd = req_fd;
> +	ioctl(camera_fd, VIDIOC_QBUF, &buf);
> +
> +Once the request is fully prepared, it can be submitted to the driver:
> +
> +	struct media_request_cmd cmd;
> +
> +	memset(&cmd, 0, sizeof(cmd));
> +	cmd.cmd = MEDIA_REQ_CMD_SUBMIT;
> +	cmd.fd = request_fd;
> +	ioctl(media_fd, MEDIA_IOC_REQUEST_CMD, &cmd);
> +
> +User-space can then lookup the request_fd field of dequeued capture buffers to
> +confirm which one has been produced by the request.
> +
> +	struct v4l2_buf buf;
> +
> +	memset(&buf, 0, sizeof(buf));
> +	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	ioctl(camera_fd, VIDIOC_DQBUF, &buf);
> +
> +	if (buf.request_fd == request_fd)
> +		...
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index 9e448a4aa3aa..0cd596bd4cde 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -98,6 +98,12 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
>  :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
>  device is closed.
>  
> +For all buffer types, the ``request_fd`` field can be used when enqueing
> +to specify the file descriptor of a request, if requests are in use.
> +Setting it means that the buffer will not be passed to the driver until
> +the request itself is submitted. Also, the driver will apply any setting
> +associated with the request before processing the buffer.
> +
>  Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
>  (capturing) or displayed (output) buffer from the driver's outgoing
>  queue. They just set the ``type``, ``memory`` and ``reserved`` fields of
> @@ -115,6 +121,21 @@ queue. When the ``O_NONBLOCK`` flag was given to the
>  :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
>  immediately with an ``EAGAIN`` error code when no buffer is available.
>  
> +If a dequeued buffer was produced as the result of a request, then the
> +``request_fd`` field of :c:type:`v4l2_buffer` will be set to the file
> +descriptor of the request, regardless of whether the buffer was initially
> +queued with a request associated to it or not.
> +
> +RFC note: a request can be referenced by several FDs, especially if the
> +request is shared between different processes. Also a FD can be closed
> +after a request is submitted. In that case the FD does not make much sense.
> +Maybe it would be better to define request fd as
> +
> +    union { u32 request_fd; u32 request_id; }
> +
> +and use request_id when communicating a request to userspace so they can be
> +unambiguously referenced?

I don't think this is a problem. At least we never had this issue with e.g.
dmabuf either. The request_fd must be a valid request fd for the process that
calls the ioctl. If not the ioctl will return an error. If process A has a
request fd 10 and process B calls the ioctl with request_fd set to 10 but it
didn't actually allocate the request or receive the fd from process A (there
is a mechanism for that, although I've forgotten the details).

> +
>  The struct :c:type:`v4l2_buffer` structure is specified in
>  :ref:`buffer`.
>  
> 

Regards,

	Hans
