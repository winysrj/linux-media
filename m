Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46152 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbeHOTGS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 15:06:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv18 01/35] Documentation: v4l: document request API
Date: Wed, 15 Aug 2018 19:14:19 +0300
Message-ID: <2183957.pVXMYXPWuc@avalon>
In-Reply-To: <20180814142047.93856-2-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl> <20180814142047.93856-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday, 14 August 2018 17:20:13 EEST Hans Verkuil wrote:
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
>  .../uapi/mediactl/media-ioc-request-alloc.rst |  65 +++++
>  .../uapi/mediactl/media-request-ioc-queue.rst |  82 ++++++
>  .../mediactl/media-request-ioc-reinit.rst     |  51 ++++
>  .../media/uapi/mediactl/request-api.rst       | 245 ++++++++++++++++++
>  .../uapi/mediactl/request-func-close.rst      |  48 ++++
>  .../uapi/mediactl/request-func-ioctl.rst      |  67 +++++
>  .../media/uapi/mediactl/request-func-poll.rst |  77 ++++++
>  Documentation/media/uapi/v4l/buffer.rst       |  21 +-
>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  53 +++-
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  32 ++-
>  .../media/videodev2.h.rst.exceptions          |   1 +
>  13 files changed, 739 insertions(+), 10 deletions(-)
>  create mode 100644
> Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst create mode
> 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst create
> mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
> create mode 100644 Documentation/media/uapi/mediactl/request-api.rst create
> mode 100644 Documentation/media/uapi/mediactl/request-func-close.rst create
> mode 100644 Documentation/media/uapi/mediactl/request-func-ioctl.rst create
> mode 100644 Documentation/media/uapi/mediactl/request-func-poll.rst
> 
> diff --git a/Documentation/media/uapi/mediactl/media-controller.rst
> b/Documentation/media/uapi/mediactl/media-controller.rst index
> 0eea4f9a07d5..66aff38cd499 100644
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
> diff --git a/Documentation/media/uapi/mediactl/media-funcs.rst
> b/Documentation/media/uapi/mediactl/media-funcs.rst index
> 076856501cdb..260f9dcadcde 100644
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
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst new file
> mode 100644
> index 000000000000..34434e2b3918
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> @@ -0,0 +1,65 @@
> +.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH
> no-invariant-sections +
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
> +.. c:function:: int ioctl( int fd, MEDIA_IOC_REQUEST_ALLOC, int *argp )
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
> +    Pointer to an integer.
> +
> +
> +Description
> +===========
> +
> +If the media device supports :ref:`requests <media-request-api>`, then
> +this ioctl can be used to allocate a request. If it is not supported, then
> +``errno`` is set to ``ENOTTY``. A request is accessed through a file
> descriptor +that is returned in ``*argp``.
> +
> +If the request was successfully allocated, then the request file descriptor
> +can be passed to the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
> +:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
> +:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
> +:ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctls.

As with the media controller API, the request API isn't V4L2-specific, but can 
be used by subsystems that use the media controller API, such as V4L2. The 
above paragraph is correct, but I wouldn't list V4L2-specific ioctls in the MC 
API documentation. Instead, you could state that the request file descriptor 
can be passed to subsystem APIs that are request-aware, without detailing 
which ones. The documentation of the above V4L2 ioctls will contain detailed 
information.

> +In addition, the request can be queued by calling
> +:ref:`MEDIA_REQUEST_IOC_QUEUE` and re-initialized by calling
> +:ref:`MEDIA_REQUEST_IOC_REINIT`.
> +
> +Finally, the file descriptor can be :ref:`polled <request-func-poll>` to
> wait
> +for the request to complete.
> +
> +The request will remain allocated until all the file descriptors associated
> +with it are closed by :ref:`close() <request-func-close>` and the driver
> no
> +longer uses the request internally.

I think it would be useful here to refer to the appropriate section of 
Documentation/media/uapi/mediactl/request-api.rst for more information about 
request life time management.

> +Return Value
> +============
> +
> +On success 0 is returned, on error -1 and the ``errno`` variable is set
> +appropriately. The generic error codes are described at the
> +:ref:`Generic Error Codes <gen-errors>` chapter.
> +
> +ENOTTY
> +    The driver has no support for requests.
> diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
> b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst new file
> mode 100644
> index 000000000000..d4f8119e0643
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
> @@ -0,0 +1,82 @@
> +.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH
> no-invariant-sections
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
> +common error codes. On error both the request and driver state are
> unchanged.
> +
> +Typically if you get an error here, then that means that the application
> +did something wrong and you have to fix the application.

Isn't that always the case ? :-)

> +Once a request is queued, then the driver is required to gracefully handle
> +errors that occur when the request is applied to the hardware. The
> +exception is the ``EIO`` error which signals a fatal error that requires
> +the application to stop streaming to reset the hardware state.

Queuing a request will validate it synchronously (possibly returning -EINVAL) 
and execute it asynchronously. The -EIO error signals a fatal error during 
execution of the request, how can it thus be returned from the queue ioctl ? I 
think the API definition is a bit vague in this area, we lack a detailed 
documentation of how errors at request execution time are handled.

> +It is not allowed to mix queuing requests with queuing buffers directly
> +(without a request). ``EPERM`` will be returned if the first buffer was
> +queued directly and you next try to queue a request, or vice versa.

Same comment as above, let's not include V4L2 concepts in the request API core 
documentation.

> +A request must contain at least one buffer, otherwise this ioctl will
> +return an ``ENOENT`` error.

And here too.

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
> +    The application queued the first buffer directly, but later attempted
> +    to use a request. It is not permitted to mix the two APIs.
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
> +    The hardware is in a bad state. To recover, the application needs to
> +    stop streaming to reset the hardware state and then try to restart
> +    streaming.

EPERM, ENOENT and EIO all refer to V4L2-specific concepts. They should be 
documented in a generic way.

For EPERM you can explain that the device was first use with the legacy 
subsystem API (feel free to propose a better word than legacy), preventing the 
use of requests. We don't have to detail here that it relates to buffers, that 
can be documented in the V4L2 documentation.

For ENOENT I wonder if we need that error code at all, isn't it enough to 
return -EINVAL when the request is invalid ? Having no buffer in a request 
makes it invalid, so the very broad definition of -EINVAL would cover it. If 
we want to differentiate the two cases then we should word EINVAL in a bit 
more specific way, and find a way to word ENONENT without referring to V4L2.

> diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
> b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst new file
> mode 100644
> index 000000000000..febe888494c8
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
> @@ -0,0 +1,51 @@
> +.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH
> no-invariant-sections +
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

How about errors when request_fd doesn't correspond to a request ? Do we need 
to care about permissions here, or is the fact that an application has got 
hold of a request fd always means that it has permissions to reinitialize it ? 
We haven't thought much about permission management yet, and I fear that if we 
document that no permission-related error can be returned, implementing 
permissions later will break the API.

> +Return Value
> +============
> +
> +On success 0 is returned, on error -1 and the ``errno`` variable is set
> +appropriately.
> +
> +EBUSY
> +    The request is queued but not yet completed.
> diff --git a/Documentation/media/uapi/mediactl/request-api.rst
> b/Documentation/media/uapi/mediactl/request-api.rst new file mode 100644
> index 000000000000..0b9da58b01e3
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/request-api.rst
> @@ -0,0 +1,245 @@
> +.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH
> no-invariant-sections +
> +.. _media-request-api:
> +
> +Request API
> +===========
> +
> +The Request API has been designed to allow V4L2 to deal with requirements
> of +modern devices (stateless codecs, complex camera pipelines, ...) and
> APIs +(Android Codec v2). One such requirement is the ability for devices
> belonging to +the same pipeline to reconfigure and collaborate closely on a
> per-frame basis. +Another is support of stateless codecs, which require
> controls to be applied +to specific frames (aka 'per-frame controls') in
> order to be used efficiently.
> +
> +Supporting these features without the Request API is not always possible
> and if +it is, it is terribly inefficient: user-space would have to flush
> all activity +on the media pipeline, reconfigure it for the next frame,
> queue the buffers to +be processed with that configuration, and wait until
> they are all available for +dequeuing before considering the next frame.
> This defeats the purpose of having +buffer queues since in practice only
> one buffer would be queued at a time.

I would mention here that while the request API has been developed for the 
aforementioned purposes, it is not limited to V4L2 and can be used by other 
subsystems.

> +The Request API allows a specific configuration of the pipeline (media
> +controller topology + controls for each media entity)

I would say "configuration of each media entity" to avoid referring to a V4L2-
specific concept.

> to be associated with
> +specific buffers.

And here, as mentioned above, I think we should try to generalize the buffers 
concept. There are no buffers at the MC API level, and while I'm not totally 
opposed to introducing the concept at least for non-normative purposes, we 
need to document it properly in the MC API before using it.

> The parameters are applied by each participating device
> as +buffers associated to a request flow in.

s/associated to/associated with/

I had a bit of trouble parsing this sentence, but it might just be me.

> This allows user-space to
> schedule +several tasks ("requests") with different parameters in advance,
> knowing that +the parameters will be applied when needed to get the
> expected result. Control +values at the time of request completion are also
> available for reading.

As above, I would avoid mentioning the V4L2-specific control concept. It's 
particularly important here, as controls cover both the configuration 
parameters applied to the hardware for the request, but also possibly data 
extracted from the device (such as the exposure time for the sensor when 
working in auto-exposure mode for instance). It's an important feature of the 
API, which should be documented explicitly in my opinion.

> +Usage
> +=====
> +
> +The Request API is used on top of standard media controller and V4L2 calls,
> +which are augmented with an extra ``request_fd`` parameter. Requests
> themselves +are allocated from the supporting media controller node.

I'd like to word this differently (and I hope it won't turn into a 
controversial topic :-)), as I wouldn't mention V4L2 here as anything more 
than an example. How about the following ?

"The Request API extends the Media Controller API and cooperates with 
subsystem-specific APIs to support request usage. At the Media Controller 
level, requests are allocated from the supporting Media Controller device 
node. Their life cycle is then managed through the request file descriptors in 
an opaque way. Configuration data, buffer handles and processing results 
stored in requests are accessed through subsystem-specific APIs extended for 
request support, such as V4L2 APIs that take an explicit ``request_fd'' 
parameter."

I think this reflects better the three core principles behind the API design 
(allocation at the MC level, request life time management at the request FD 
level, controls and buffers at the V4L2 level). We can later extend this when 
we'll implement associating buffers and controls with a request in a single 
ioctl call.

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
> +Standard V4L2 ioctls can then receive a request file descriptor to express
> the +fact that the ioctl is part of said request, and is not to be applied
> +immediately. See :ref:`MEDIA_IOC_REQUEST_ALLOC` for a list of ioctls that
> +support this. Controls set with a ``request_fd`` parameter are stored
> instead +of being immediately applied, and buffers queued to a request do
> not enter the +regular buffer queue until the request itself is queued.

Here too I think we need to avoid being V4L2-specific.

> +Request Submission
> +------------------
> +
> +Once the parameters and buffers of the request are specified, it can be
> +queued by calling :ref:`MEDIA_REQUEST_IOC_QUEUE` on the request file
> descriptor. +A request must contain at least one buffer, otherwise
> ``ENOENT`` is returned. +This will make the buffers associated to the
> request available to their driver,

Doesn't the last sentence documents the implementation more than the API ?

> +which can then apply the associated
> controls as buffers are processed. A queued +request cannot be modified
> anymore.
> +
> +.. caution::
> +   For :ref:`memory-to-memory devices <codec>` you can use requests only
> for +   output buffers, not for capture buffers. Attempting to add a
> capture buffer +   to a request will result in an ``EPERM`` error.

This is V4L2-specific information, I'd move it to the V4L2 codec API 
documentation.

> +If the request contains parameters for multiple entities, individual
> drivers may +synchronize so the requested pipeline's topology is applied
> before the buffers +are processed. Media controller drivers do a best
> effort implementation since +perfect atomicity may not be possible due to
> hardware limitations.

I agree with this, but I think we need to think about what is required and 
what can be left as a best-effort implementation. Applying all controls 
atomically might not be possible, which I believe is acceptable, but failing 
to change the topology atomically would likely result in lots of possible 
issues, some of them very serious such as buffer overruns. I don't think that 
should be allowed.

> +
> +.. caution::
> +
> +   It is not allowed to mix queuing requests with directly queuing buffers:
> +   whichever method is used first locks this in place until
> +   :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called or the device is
> +   :ref:`closed <func-close>`. Attempts to directly queue a buffer when
> earlier +   a buffer was queued via a request or vice versa will result in
> an ``EPERM`` +   error.

We agree on this too, but as explained above in my comment to the EPERM error 
code, I think we should rephrase it not to make it V4L2-specific.

> +Controls can still be set without a request and are applied immediately,
> +regardless of whether a request is in use or not.
> +
> +.. caution::
> +
> +   Setting the same control through a request and also directly can lead to
> +   undefined behavior!

Same comment here :-) Additionally, "can lead to undefined behaviour" is too 
vague I think. If it's not allowed, we must document that, and state that it 
"results in undefined behaviour". I'm also concerned that applications would 
still try to set controls directly and through requests, being lucky that due 
to the current driver implementation it appears not to cause any malfunction, 
and later break when the driver or framework evolve. Would it be useful to 
reject that outright during request validation ?

> +User-space can :ref:`poll() <request-func-poll>` a request file descriptor
> in +order to wait until the request completes. A request is considered
> complete +once all its associated buffers are available for dequeuing and
> all the +associated controls have been updated with the values at the time
> of completion. +Note that user-space does not need to wait for the request
> to complete to +dequeue its buffers: buffers that are available halfway
> through a request can +be dequeued independently of the request's state.

V4L2-specific concepts here again. I'll stop repeating that comment as I think 
you got the point :-)

> +A completed request contains the state of the request at the time of the
> +request completion.

Do you mean the state of the device ?

And is this correct ? Thinking about the actual exposure time that can be read 
through the request, the value corresponds to the time the frame has been 
captured, which is different than the time of request completion.

> User-space can query that state by calling
> +:ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with the request file
> +descriptor. Calling :ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`
> for a +request that has been queued but not yet completed will return
> ``EBUSY`` +since the control values might be changed at any time by the
> driver while the +request is in flight.
> +
> +Recycling and Destruction
> +-------------------------
> +
> +Finally, a completed request can either be discarded or be reused. Calling
> +:ref:`close() <request-func-close>` on a request file descriptor will make
> +that file descriptor unusable and the request will be freed once it is no
> +longer in use by the kernel. That is, if the request is queued and then the
> +file descriptor is closed, then it won't be freed until the driver
> completed +the request.

I think we should document more explicitly that requests are reference-
counted. The above makes it sound that closing one FD will be enough, while 
there could be other FDs referring to the same request that will keep it 
alive. I'd explain that each FD holds a reference to the request, that drivers 
can hold references to requests internally for different purposes (there 
certainly will be a reference held when the request is queued, until it 
completes), and that requests are freed when all references are released.

Now thinking out loud, drivers could be tempted to hold references to previous 
requests when they need to retain past state information for future purposes. 
This would cause issues when requests are reinitialized for obvious reasons. 
We should disallow it somewhere (I'd say in the documentation of the reference 
get/put functions). If we want to allow drivers to retain past state after 
completion of the request one option would be to decouple request and state 
objects and reference-counting them both separately. I haven't looked at the 
implementation yet, maybe this is already done :-)

> +
> +The :ref:`MEDIA_REQUEST_IOC_REINIT` will clear a request's state and make
> it +available again. No state is retained by this operation: the request is
> as +if it had just been allocated.
> +
> +Example for a Codec Device
> +--------------------------

Those two examples should be moved to the V4L2 documentation.

> +For use-cases such as :ref:`codecs <codec>`, the request API can be used
> +to associate specific controls to
> +be applied by the driver for the OUTPUT buffer, allowing user-space
> +to queue many such buffers in advance. It can also take advantage of
> requests' +ability to capture the state of controls when the request
> completes to read back +information that may be subject to change.
> +
> +Put into code, after obtaining a request, user-space can assign controls
> and one +OUTPUT buffer to it:
> +
> +.. code-block:: c
> +
> +	struct v4l2_buffer buf;
> +	struct v4l2_ext_controls ctrls;
> +	int req_fd;
> +	...
> +	if (ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &req_fd))
> +		return errno;
> +	...
> +	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
> +	ctrls.request_fd = req_fd;
> +	if (ioctl(codec_fd, VIDIOC_S_EXT_CTRLS, &ctrls))
> +		return errno;
> +	...
> +	buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;
> +	buf.request_fd = req_fd;
> +	if (ioctl(codec_fd, VIDIOC_QBUF, &buf))
> +		return errno;
> +
> +Note that it is not allowed to use the Request API for CAPTURE buffers
> +since there are no per-frame settings to report there.

Is that true for both encoders and decoders (as the section just mentions 
codecs) ?

> +Once the request is fully prepared, it can be queued to the driver:
> +
> +.. code-block:: c
> +
> +	if (ioctl(req_fd, MEDIA_REQUEST_IOC_QUEUE))
> +		return errno;
> +
> +User-space can then either wait for the request to complete by calling
> poll() on +its file descriptor, or start dequeuing CAPTURE buffers. Most
> likely, it will +want to get CAPTURE buffers as soon as possible and this
> can be done using a +regular :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`:
> +
> +.. code-block:: c
> +
> +	struct v4l2_buffer buf;
> +
> +	memset(&buf, 0, sizeof(buf));
> +	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	if (ioctl(codec_fd, VIDIOC_DQBUF, &buf))
> +		return errno;
> +
> +Note that this example assumes for simplicity that for every OUTPUT buffer
> +there will be one CAPTURE buffer, but this does not have to be the case.
> +
> +We can then, after ensuring that the request is completed via polling the
> +request file descriptor, query control values at the time of its completion
> via +a call to :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
> +This is particularly useful for volatile controls for which we want to
> +query values as soon as the capture buffer is produced.
> +
> +.. code-block:: c
> +
> +	struct pollfd pfd = { .events = POLLPRI, .fd = req_fd };
> +	poll(&pfd, 1, -1);
> +	...
> +	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
> +	ctrls.request_fd = req_fd;
> +	if (ioctl(codec_fd, VIDIOC_G_EXT_CTRLS, &ctrls))
> +		return errno;
> +
> +Once we don't need the request anymore, we can either recycle it for reuse
> with +:ref:`MEDIA_REQUEST_IOC_REINIT`...
> +
> +.. code-block:: c
> +
> +	if (ioctl(req_fd, MEDIA_REQUEST_IOC_REINIT))
> +		return errno;
> +
> +... or close its file descriptor to completely dispose of it.
> +
> +.. code-block:: c
> +
> +	close(req_fd);
> +
> +Example for a Simple Capture Device
> +-----------------------------------
> +
> +With a simple capture device, requests can be used to specify controls to
> apply +for a given CAPTURE buffer.
> +
> +.. code-block:: c
> +
> +	struct v4l2_buffer buf;
> +	struct v4l2_ext_controls ctrls;
> +	int req_fd;
> +	...
> +	if (ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &req_fd))
> +		return errno;
> +	...
> +	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
> +	ctrls.request_fd = req_fd;
> +	if (ioctl(camera_fd, VIDIOC_S_EXT_CTRLS, &ctrls))
> +		return errno;
> +	...
> +	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;
> +	buf.request_fd = req_fd;
> +	if (ioctl(camera_fd, VIDIOC_QBUF, &buf))
> +		return errno;
> +
> +Once the request is fully prepared, it can be queued to the driver:
> +
> +.. code-block:: c
> +
> +	if (ioctl(req_fd, MEDIA_REQUEST_IOC_QUEUE))
> +		return errno;
> +
> +User-space can then dequeue buffers, wait for the request completion, query
> +controls and recycle the request as in the M2M example above.
> diff --git a/Documentation/media/uapi/mediactl/request-func-close.rst
> b/Documentation/media/uapi/mediactl/request-func-close.rst new file mode
> 100644
> index 000000000000..b5c78683840b
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/request-func-close.rst
> @@ -0,0 +1,48 @@
> +.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH
> no-invariant-sections +
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
> +
> +Description
> +===========
> +
> +Closes the request file descriptor. Resources associated with the request
> +are freed once all file descriptors associated with the request are closed
> +and the driver has completed the request.

A link to the corresponding request usage section would be useful here.

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
> diff --git a/Documentation/media/uapi/mediactl/request-func-ioctl.rst
> b/Documentation/media/uapi/mediactl/request-func-ioctl.rst new file mode
> 100644
> index 000000000000..ff7b072a6999
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
> @@ -0,0 +1,67 @@
> +.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH
> no-invariant-sections +
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
> +    The request ioctl command code as defined in the media.h header file,
> for +    example :ref:`MEDIA_REQUEST_IOC_QUEUE`.
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
> diff --git a/Documentation/media/uapi/mediactl/request-func-poll.rst
> b/Documentation/media/uapi/mediactl/request-func-poll.rst new file mode
> 100644
> index 000000000000..70cc9d406a9f
> --- /dev/null
> +++ b/Documentation/media/uapi/mediactl/request-func-poll.rst
> @@ -0,0 +1,77 @@
> +.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH
> no-invariant-sections +
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
> +.. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int
> timeout )
> +   :name: request-poll
> +
> +Arguments
> +=========
> +
> +``ufds``
> +   List of file descriptor events to be watched
> +
> +``nfds``
> +   Number of file descriptor events at the \*ufds array
> +
> +``timeout``
> +   Timeout to wait for events
> +
> +
> +Description
> +===========
> +
> +With the :c:func:`poll() <request-func-poll>` function applications can
> wait +for a request to complete.
> +
> +On success :c:func:`poll() <request-func-poll>` returns the number of file
> +descriptors that have been selected (that is, file descriptors for which
> the +``revents`` field of the respective struct :c:type:`pollfd`
> +is non-zero). Request file descriptor set the ``POLLPRI`` flag in
> ``revents`` +when the request was completed.  When the function times out
> it returns +a value of zero, on failure it returns -1 and the ``errno``
> variable is +set appropriately.
> +
> +Attempting to poll for a request that is completed or not yet queued will
> +set the ``POLLERR`` flag in ``revents``.

Why should a completed request set POLLERR, given that the purpose of poll() 
is to poll for completion ?

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
> +    The ``nfds`` value exceeds the ``RLIMIT_NOFILE`` value. Use
> +    ``getrlimit()`` to obtain this value.
> diff --git a/Documentation/media/uapi/v4l/buffer.rst
> b/Documentation/media/uapi/v4l/buffer.rst index e2c85ddc990b..dd0065a95ea0
> 100644

The V4L2 part should be split to a separate patch.

> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst
> @@ -306,10 +306,15 @@ struct v4l2_buffer
>        - A place holder for future extensions. Drivers and applications
>  	must set this to 0.
>      * - __u32
> -      - ``reserved``
> +      - ``request_fd``
>        -
> -      - A place holder for future extensions. Drivers and applications
> -	must set this to 0.
> +      - The file descriptor of the request to queue the buffer to. If
> specified +        and flag ``V4L2_BUF_FLAG_REQUEST_FD`` is set, then the
> buffer will be +	queued to that request.

"If specified" doesn't make much sense here, as 0 is a valid fd, so we can't 
detect whether the field is specified or not. We should rephrase this to 
explain that the flag tells whether the buffer should be added to a request, 
and in that case, the request_fd field contains the corresponding request file 
descriptor.

> This is set by the user when
> calling
> +	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.

Shouldn't other ioctls return an error when V4L2_BUF_FLAG_REQUEST_FD is set ?

> +	If the device does not support requests, then ``EPERM`` will be returned.
> +	If requests are supported but an invalid request FD is given, then
> +	``ENOENT`` will be returned.
> 
> 
> 
> @@ -514,6 +519,11 @@ Buffer Flags
>  	streaming may continue as normal and the buffer may be reused
>  	normally. Drivers set this flag when the ``VIDIOC_DQBUF`` ioctl is
>  	called.
> +    * .. _`V4L2-BUF-FLAG-IN-REQUEST`:
> +
> +      - ``V4L2_BUF_FLAG_IN_REQUEST``
> +      - 0x00000080
> +      - This buffer is part of a request that hasn't been queued yet.

I assume this will be cleared automatically when the request is queued. What's 
the use case for this flag ?

>      * .. _`V4L2-BUF-FLAG-KEYFRAME`:
> 
>        - ``V4L2_BUF_FLAG_KEYFRAME``
> @@ -589,6 +599,11 @@ Buffer Flags
>  	the format. Any Any subsequent call to the
> 
>  	:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
> 
>  	but return an ``EPIPE`` error code.
> +    * .. _`V4L2-BUF-FLAG-REQUEST-FD`:
> +
> +      - ``V4L2_BUF_FLAG_REQUEST_FD``
> +      - 0x00800000
> +      - The ``request_fd`` field contains a valid file descriptor.
>      * .. _`V4L2-BUF-FLAG-TIMESTAMP-MASK`:
> 
>        - ``V4L2_BUF_FLAG_TIMESTAMP_MASK``
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst index
> 2011c2b2ee67..771fd1161277 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
> @@ -95,6 +95,26 @@ appropriate. In the first case the new value is set in
> struct is inappropriate (e.g. the given menu index is not supported by the
> menu control), then this will also result in an ``EINVAL`` error code
> error.
> 
> +If ``request_fd`` is set to a not-yet-queued :ref:`request
> <media-request-api>` +file descriptor and ``which`` is set to
> ``V4L2_CTRL_WHICH_REQUEST_VAL``, +then the controls are not applied
> immediately when calling
> +:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, but instead are applied by
> +the driver for the buffer associated with the same request.

I think we need a general description of the request API usage in V4L2, 
similar in purpose to the description in request-api.rst. We need to clearly 
define there what "are applied [...] for a buffer" means. While it may appear 
straightforward to us as we've been working on this API for a long time, I 
don't think it does for a newcomer. Furthermore, there's a high chance we will 
realize we don't all understand it the same way once it will be written down 
:-)

> +If the device does not support requests, then ``EPERM`` will be returned.

What happens on older kernel that don't support the request API, do they 
return EPERM when which is set to V4L2_CTRL_WHICH_REQUEST_VAL ?

> +If requests are supported but an invalid request FD is given, then
> +``ENOENT`` will be returned.

By the way, posix defines EBADR as "Invalid request descriptor", I wonder 
whether it wouldn't be a better match.

> +
> +An attempt to call :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` for a
> +request that has already been queued will result in an ``EBUSY`` error.
> +
> +If ``request_fd`` is specified and ``which`` is set to
> ``V4L2_CTRL_WHICH_REQUEST_VAL`` +during a call to :ref:`VIDIOC_G_EXT_CTRLS
> <VIDIOC_G_EXT_CTRLS>`, then the +returned values will be the values
> currently set for the request (or the +hardware value if none is set) if
> the request has not yet been queued, or the +values of the controls at the
> time of request completion if it has already +completed.

I really need to look at this in details when reviewing the implementation, as 
I fear there will be lots of annoying details. In particular the behaviour of 
the ioctl before the request is queued worries me. Do we have a use case for 
that ?

> Attempting to get
> controls while the request has been queued but +not yet completed will
> result in an ``EBUSY`` error.
> +
>  The driver will only set/get these controls if all control values are
>  correct. This prevents the situation where only some of the controls
>  were set/get. Only low-level errors (e. g. a failed i2c command) can
> @@ -209,13 +229,17 @@ still cause this situation.
>        - ``which``
>        - Which value of the control to get/set/try.
>  	``V4L2_CTRL_WHICH_CUR_VAL`` will return the current value of the
> -	control and ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
> -	value of the control.
> +	control, ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
> +	value of the control and ``V4L2_CTRL_WHICH_REQUEST_VAL`` indicates that
> +	these controls have to be retrieved from a request or tried/set for
> +	a request. In the latter case the ``request_fd`` field contains the
> +	file descriptor of the request that should be used. If the device
> +	does not support requests, then ``EPERM`` will be returned.
> 
>  	.. note::
> 
> -	   You can only get the default value of the control,
> -	   you cannot set or try it.
> +	   When using ``V4L2_CTRL_WHICH_DEF_VAL`` note that You can only
> +	   get the default value of the control, you cannot set or try it.

I think there's a mistake here, you seem to have inserted something in front 
of the existing text without completing the change.

>  	For backwards compatibility you can also use a control class here
>  	(see :ref:`ctrl-class`). In that case all controls have to
> @@ -272,8 +296,15 @@ still cause this situation.
>  	then you can call :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` to try
> to discover the actual control that failed the validation step.
> Unfortunately,
>  	there is no ``TRY`` equivalent for :ref:`VIDIOC_G_EXT_CTRLS
> <VIDIOC_G_EXT_CTRLS>`.
> +    * - __s32
> +      - ``request_fd``
> +      - File descriptor of the request to be used by this operation. Only
> +	valid if ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``.
> +	If the device does not support requests, then ``EPERM`` will be returned.
> +	If requests are supported but an invalid request FD is given, then
> +	``ENOENT`` will be returned.
>      * - __u32
> -      - ``reserved``\ [2]
> +      - ``reserved``\ [1]
>        - Reserved for future extensions.
> 
>  	Drivers and applications must set the array to zero.
> @@ -362,7 +393,9 @@ ERANGE
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
> @@ -372,3 +405,11 @@ ENOSPC
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
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> b/Documentation/media/uapi/v4l/vidioc-qbuf.rst index
> 9e448a4aa3aa..0e415f2551b2 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -65,7 +65,7 @@ To enqueue a :ref:`memory mapped <mmap>` buffer
> applications set the with a pointer to this structure the driver sets the
>  ``V4L2_BUF_FLAG_MAPPED`` and ``V4L2_BUF_FLAG_QUEUED`` flags and clears
>  the ``V4L2_BUF_FLAG_DONE`` flag in the ``flags`` field, or it returns an
> -EINVAL error code.
> +``EINVAL`` error code.
> 
>  To enqueue a :ref:`user pointer <userp>` buffer applications set the
>  ``memory`` field to ``V4L2_MEMORY_USERPTR``, the ``m.userptr`` field to
> @@ -98,6 +98,25 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF
> <VIDIOC_STREAMON>` or
>  :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
> 
>  device is closed.
> 
> +The ``request_fd`` field can be used with the ``VIDIOC_QBUF`` ioctl to
> specify +the file descriptor of a :ref:`request <media-request-api>`, if
> requests are +in use. Setting it means that the buffer will not be passed
> to the driver +until the request itself is queued. Also, the driver will
> apply any +settings associated with the request for this buffer. This field
> will +be ignored unless the ``V4L2_BUF_FLAG_REQUEST_FD`` flag is set.
> +If the device does not support requests, then ``EPERM`` will be returned.
> +If requests are supported but an invalid request FD is given, then
> +``ENOENT`` will be returned.
> +
> +.. caution::
> +   It is not allowed to mix queuing requests with queuing buffers directly.
> +   ``EPERM`` will be returned if the first buffer was queued directly and
> +   then the application tries to queue a request, or vice versa.

How do drivers assert this constraint ? Is it per file handle ? Per device 
node ? If per device node, how is it reset ? i.e. if an application uses the 
device in request mode, closes and, and a legacy application tries to open and 
use it in normal mode, what happens ?

> +   For :ref:`memory-to-memory devices <codec>` you can specify the
> +   ``request_fd`` only for output buffers, not for capture buffers.
> Attempting +   to specify this for a capture buffer will result in an
> ``EPERM`` error. +

I think this should be documented in more details in a new V4L2 request API 
section, as noted above.

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
> +    the application now tries to queue it directly, or vice versa (it is
> +    not permitted to mix the two APIs). Or an attempt is made to queue a
> +    CAPTURE buffer to a request for a :ref:`memory-to-memory device
> <codec>`. +
> +ENOENT
> +    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the the given
> +    ``request_fd`` was invalid.
> diff --git a/Documentation/media/videodev2.h.rst.exceptions
> b/Documentation/media/videodev2.h.rst.exceptions index
> ca9f0edc579e..99256a2c003e 100644
> --- a/Documentation/media/videodev2.h.rst.exceptions
> +++ b/Documentation/media/videodev2.h.rst.exceptions
> @@ -514,6 +514,7 @@ ignore define V4L2_CTRL_DRIVER_PRIV
>  ignore define V4L2_CTRL_MAX_DIMS
>  ignore define V4L2_CTRL_WHICH_CUR_VAL
>  ignore define V4L2_CTRL_WHICH_DEF_VAL
> +ignore define V4L2_CTRL_WHICH_REQUEST_VAL
>  ignore define V4L2_OUT_CAP_CUSTOM_TIMINGS
>  ignore define V4L2_CID_MAX_CTRLS


-- 
Regards,

Laurent Pinchart
