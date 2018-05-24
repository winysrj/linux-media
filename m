Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41729 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S970528AbeEXOqI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 10:46:08 -0400
Subject: Re: [PATCHv13 22/28] Documentation: v4l: document request API
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-23-hverkuil@xs4all.nl> <2851052.gK8z6gIKGK@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b9eb1dcf-efe1-4b74-10ae-e8a6a301544d@xs4all.nl>
Date: Thu, 24 May 2018 16:46:05 +0200
MIME-Version: 1.0
In-Reply-To: <2851052.gK8z6gIKGK@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/05/18 16:46, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Thursday, 3 May 2018 17:53:12 EEST Hans Verkuil wrote:
>> From: Alexandre Courbot <acourbot@chromium.org>
>>
>> Document the request API for V4L2 devices, and amend the documentation
>> of system calls influenced by it.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  .../media/uapi/mediactl/media-funcs.rst       |   3 +
>>  .../uapi/mediactl/media-ioc-request-alloc.rst |  71 ++++++
>>  .../uapi/mediactl/media-request-ioc-queue.rst |  46 ++++
>>  .../mediactl/media-request-ioc-reinit.rst     |  51 +++++
>>  Documentation/media/uapi/v4l/buffer.rst       |  18 +-
>>  Documentation/media/uapi/v4l/common.rst       |   1 +
>>  Documentation/media/uapi/v4l/request-api.rst  | 211 ++++++++++++++++++
>>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  25 ++-
>>  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |   7 +
>>  .../media/videodev2.h.rst.exceptions          |   1 +
>>  10 files changed, 428 insertions(+), 6 deletions(-)
>>  create mode 100644
>> Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst create mode
>> 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst create
>> mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
>> create mode 100644 Documentation/media/uapi/v4l/request-api.rst
> 
> I think I would have split documentation and included each part in the 
> corresponding API definition patch to make it easier to review the definition 
> and the documentation together, but that's not a big deal.
> 
> We might however still want to split this patch in two, with one part for the 
> media controller API and one part for the V4L2 API, as the request API on MC 
> isn't V4L2-dependent.
> 
>> diff --git a/Documentation/media/uapi/mediactl/media-funcs.rst
>> b/Documentation/media/uapi/mediactl/media-funcs.rst index
>> 076856501cdb..f4da9b3e17ec 100644
>> --- a/Documentation/media/uapi/mediactl/media-funcs.rst
>> +++ b/Documentation/media/uapi/mediactl/media-funcs.rst
>> @@ -16,3 +16,6 @@ Function Reference
>>      media-ioc-enum-entities
>>      media-ioc-enum-links
>>      media-ioc-setup-link
>> +    media-ioc-request-alloc
>> +    media-request-ioc-queue
>> +    media-request-ioc-reinit
> 
> Do we want to keep this alphabetically ordered ?

It isn't today. It is more ordered in the sequence you would use the
ioctls. I have no strong preference one way or another.

> 
>> diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
>> b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst new file
>> mode 100644
>> index 000000000000..d45a94c9e23c
>> --- /dev/null
>> +++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
>> @@ -0,0 +1,71 @@
>> +.. SPDX-License-Identifier: GPL-2.0-only
> 
> Documentation/process/license-rules.rst doesn't specify GPL-2.0-only, this 
> should be GPL-2.0. The comment applies to all other new files.

GPL-2.0-only should be a valid license in 4.18 (patches were posted to add this).
It's confusing since SPDX has deprecated GPL-2.0 in favor of GPL-2.0-only.

I'll keep this unless it is still illegal in 4.18.

> 
> This being said, GPL isn't really a documentation license, shouldn't we pick a 
> more appropriate license ?

All our docs are under GPL. I don't want to introduce something else.

> 
>> +
>> +.. _media_ioc_request_alloc:
>> +
>> +*****************************
>> +ioctl MEDIA_IOC_REQUEST_ALLOC
>> +*****************************
>> +
>> +Name
>> +====
>> +
>> +MEDIA_IOC_REQUEST_ALLOC - Allocate a request
>> +
>> +
>> +Synopsis
>> +========
>> +
>> +.. c:function:: int ioctl( int fd, MEDIA_IOC_REQUEST_ALLOC, struct
>> media_request_alloc *argp )
>> +    :name: MEDIA_IOC_REQUEST_ALLOC
>> +
>> +
>> +Arguments
>> +=========
>> +
>> +``fd``
>> +    File descriptor returned by :ref:`open() <media-func-open>`.
>> +
>> +``argp``
>> +
>> +
>> +Description
>> +===========
>> +
>> +If the media device supports :ref:`requests <media-request-api>`, then
>> +this ioctl can be used to allocate a request. A request is accessed through
>> +a file descriptor that is returned in struct
>> :c:type:`media_request_alloc`.
>> +
>> +If the request was successfully allocated, then the request file descriptor
>> +can be passed to :ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>`,
>> +:ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
>> +:ref:`ioctl VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
>> +:ref:`ioctl VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
> 
> Conceptually speaking, shouldn't we refrain from referencing the V4L2 API from 
> the MC API ?

Strictly speaking, yes, but I think it makes sense to be practical here and
give the reader links to the ioctls that can actually be used with requests.
That way there is no need to hunt around for this information.

I'm keeping this for now.

> 
>> +In addition, the request can be queued by calling
>> +:ref:`MEDIA_REQUEST_IOC_QUEUE` and re-initialized by calling
>> +:ref:`MEDIA_REQUEST_IOC_REINIT`.
>> +
>> +Finally, the file descriptor can be polled to wait for the request to
>> +complete.
>> +
>> +To free the request the file descriptor has to be closed.
>> +
>> +.. c:type:: media_request_alloc
>> +
>> +.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
>> +
>> +.. flat-table:: struct media_request_alloc
>> +    :header-rows:  0
>> +    :stub-columns: 0
>> +    :widths:       1 1 2
>> +
>> +    *  -  __s32
>> +       -  ``fd``
>> +       -  The file descriptor of the request.
>> +
>> +Return Value
>> +============
>> +
>> +On success 0 is returned, on error -1 and the ``errno`` variable is set
>> +appropriately. The generic error codes are described at the
>> +:ref:`Generic Error Codes <gen-errors>` chapter.
>> diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
>> b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst new file
>> mode 100644
>> index 000000000000..79f745a3d663
>> --- /dev/null
>> +++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
>> @@ -0,0 +1,46 @@
>> +.. SPDX-License-Identifier: GPL-2.0-only
>> +
>> +.. _media_request_ioc_queue:
>> +
>> +*****************************
>> +ioctl MEDIA_REQUEST_IOC_QUEUE
>> +*****************************
>> +
>> +Name
>> +====
>> +
>> +MEDIA_REQUEST_IOC_QUEUE - Queue a request
>> +
>> +
>> +Synopsis
>> +========
>> +
>> +.. c:function:: int ioctl( int request_fd, MEDIA_REQUEST_IOC_QUEUE )
>> +    :name: MEDIA_REQUEST_IOC_QUEUE
>> +
>> +
>> +Arguments
>> +=========
>> +
>> +``request_fd``
>> +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
>> +
>> +
>> +Description
>> +===========
>> +
>> +If the media device supports :ref:`requests <media-request-api>`, then
>> +this request ioctl can be used to queue a previously allocated request.
>> +
>> +If the request was successfully queued, then the file descriptor can be
>> +polled to wait for the request to complete.
> 
> This says nothing about what queuing a request actually does :-) Neither does 
> it document why it could fail.

It links to the main request API chapter, which explains this in detail.
I don't think it is useful to repeat that information.

I added a bit about the error codes.

> 
>> +Return Value
>> +============
>> +
>> +On success 0 is returned, on error -1 and the ``errno`` variable is set
>> +appropriately. The generic error codes are described at the
>> +:ref:`Generic Error Codes <gen-errors>` chapter.
>> +
>> +EBUSY
>> +    The request was already queued.
>> diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
>> b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst new file
>> mode 100644
>> index 000000000000..7cbb7eb5d73e
>> --- /dev/null
>> +++ b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
>> @@ -0,0 +1,51 @@
>> +.. SPDX-License-Identifier: GPL-2.0-only
>> +
>> +.. _media_request_ioc_reinit:
>> +
>> +******************************
>> +ioctl MEDIA_REQUEST_IOC_REINIT
>> +******************************
>> +
>> +Name
>> +====
>> +
>> +MEDIA_REQUEST_IOC_REINIT - Re-initialize a request
>> +
>> +
>> +Synopsis
>> +========
>> +
>> +.. c:function:: int ioctl( int request_fd, MEDIA_REQUEST_IOC_REINIT )
>> +    :name: MEDIA_REQUEST_IOC_REINIT
>> +
>> +
>> +Arguments
>> +=========
>> +
>> +``request_fd``
>> +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
> 
> I was expecting an argument to this ioctl, with a reference to another request 
> (and I expected the same reference for the MEDIA_IOC_REQUEST_ALLOC ioctl). I 
> think this topic has been discussed several times in the past, but possibly 
> not in venues where everybody was present, so I'll detail the problem here.
> 
> The idea behind this version of the request API is to split request handling 
> in three parts:
> 
> 1. A request is allocated (MEDIA_IOC_REQUEST_ALLOC) or an existing request is 
> re-initialized (MEDIA_REQUEST_IOC_REINIT). At that point the request contains 
> no property (control, format, ...) to be modified.
> 
> 2. The request is filled with properties to be modified using existing V4L2 
> ioctls (VIDIOC_S_EXT_CTRLS, VIDIOC_SUBDEV_S_FMT, VIDIOC_SUBDEV_S_SELECTION, 
> ..). The current implementation supports controls only, with support for 
> formats and selection rectangles to be added later.
> 
> 3. The request is queued with MEDIA_REQUEST_IOC_QUEUE.
> 
> As usual the devil is in the details, and the details of the second step in 
> particular.
> 
> The idea behind splitting request handling in those three steps is to reuse 
> existing V4L2 ioctls as much as possible, and to keep the existing semantics 
> of those ioctls. I believe this isn't possible with the proposed 
> MEDIA_IOC_REQUEST_ALLOC and MEDIA_REQUEST_IOC_REINIT ioctls, neither for 
> controls nor for formats or selection rectangles, although the problem is more 
> limited for controls. I will thus take formats and selection rectangles to 
> explain where the problem lies.
> 
> The S_FMT and S_SELECTION semantics on subdevs (and, for that matter, on video 
> nodes too) is that those ioctls don't fail when passed parameters invalid for 
> the device, but return a valid configuration as close as possible to the 
> requested one. This allows implementing negotiation of formats and selection 
> rectangles through an iterative process that involves back-and-forth calls 
> between user space and kernel space until the application finds a usable 
> configuration accepted by the driver, or until it decides to fail because such 
> a configuration doesn't exist. (As a reminder, such negotiation is needed 
> because it was deemed impossible to create a proper API that would expose all 
> device constraints in a static way.)
> 
> Formats and selection rectangles are propagated within subdevs from sink pads 
> to source pads by the driver. Sink formats and selection rectangles thus 
> influence the result of negotiation on source pads. For instance, on a scaler 
> subdev that can't perform format conversion, the format on the source pad will 
> be dictated by the format on the sink pad. In order to implement S_FMT on the 
> source pad the kernel driver thus needs context information to get the format 
> on the sink pad.
> 
> Without the request API this is easy. The context is either stored in the 
> driver-specific device structure (for active formats) or in the file handle 
> (for try formats). With the proposed request API, however, we have no such 
> context: the requests are created empty (or re-initialized to be empty). 
> Kernel drivers can access the active state of the device, or the state of 
> previously queued requests, but can't access the state of prepared but not yet 
> queued requests.

Indeed, this is also the case for controls. When you first bind a control
handler to a request it will contain the current HW values for any controls
there were never explicitly set for the request. When you queue the request
it will link to the first request in the existing queue that sets the control
or the current HW value if there wasn't any.

I did think of using the handle of a previous request, but then you have to
make a full clone of all the data in the request you passed in, but that
might be a lot of data and that is something I'd like to avoid.

> My proposal to solve this was to link requests by specifying the handle of a 
> previous request to the MEDIA_IOC_REQUEST_ALLOC and MEDIA_REQUEST_IOC_REINIT 
> ioctls. That way kernel drivers would know in which order requests will be 
> queued, and would be able to access the correct context information to 
> implement the existing semantics of the S_FMT and S_SELECTION ioctls (as well 
> as being able to implement the G_FMT and G_SELECTION ioctls). Note that the 
> problem isn't limited to format and selection rectangles, similar problems can 
> exist when multiple controls are related, such as auto and manual controls.
> 
> This would result in a more complex API and a more complex request lifetime 
> management, as well as a more complex semantics of the request API. While I 
> thought this was unavoidable, I came to reconsider my position on this topic, 
> and I believe that the current request API proposal is acceptable in that 
> regard, provided that we agree that the existing semantics of the S_FMT and 
> S_SELECTION ioctls won't need to be implemented for requests as it won't be 
> possible to do so. The reason that prompted me to change my mind is that I 
> believe the API would be simpler to define and simpler to use if we dropped 
> that semantics, and required applications to create requests that are fully 
> valid instead of trying to mangle the content of a request the same way we do 
> for format and selection rectangle negotiation. Obviously, negotiation is 
> still needed in order for applications to find a valid configuration, but we 
> have the V4L2_SUBDEV_FORMAT_TRY API for that that, in conjunction with the 
> S_FMT and S_SELECTION ioctls, can be used to negotiate a configuration. The 
> negotiated configuration could then be set in a request, and would be 
> guaranteed to be valid.

One other option might be to implement a MEDIA_REQUEST_IOC_TRY ioctl. It will
'try' the request against the current tip of the request queue and the driver
can modify the data. If OK, then the application can call IOC_QUEUE to
actually queue the request. Internally IOC_TRY would just call req_validate
with a 'bool try' argument set to true.

I'm not sure if it worth the effort, but it would at least be possible.

> 
> To summarize this detailed explanation, I am fine with the 
> MEDIA_IOC_REQUEST_ALLOC and MEDIA_REQUEST_IOC_REINIT ioctls not providing a 
> way to link requests, and thus making the API simpler, if we acknowledge that 
> the S_FMT and S_SELECTION ioctls won't be possible to implement with their 
> current semantics and agree not to implement format and selection rectangle 
> negotiation on requests.

I agree.

> What I want to avoid is merging the MEDIA_IOC_REQUEST_ALLOC and 
> MEDIA_REQUEST_IOC_REINIT ioctls as they are proposed today, and having to 
> modify their semantics by adding request linking in the future. That should 
> significantly change the semantics of the request API which could be very 
> difficult to do without breaking userspace, and extending the API while 
> keeping support for the current semantics would result in additional 
> complexity that I'm not willing to accept. If anyone think that request 
> linking, needed if we want to access entity state from the existing V4L2 
> subdev ioctl handlers, is desired, then it needs to be built in the API from 
> the start.
> 
>> +Description
>> +===========
>> +
>> +If the media device supports :ref:`requests <media-request-api>`, then
>> +this request ioctl can be used to re-initialize a previously allocated
>> +request.
>> +
>> +Re-initializing a request will clear any existing data from the request.
>> +This avoids having to close() a completed request and allocate a new
>> +request. Instead the completed request can just be re-initialized and
>> +it is ready to be used again.
>> +
>> +A request can only be re-initialized if it either has not been queued
>> +yet, or if it was queued and completed.
>> +
>> +Return Value
>> +============
>> +
>> +On success 0 is returned, on error -1 and the ``errno`` variable is set
>> +appropriately. The generic error codes are described at the
>> +:ref:`Generic Error Codes <gen-errors>` chapter.
>> +
>> +EBUSY
>> +    The request is queued but not yet completed.
>> diff --git a/Documentation/media/uapi/v4l/buffer.rst
>> b/Documentation/media/uapi/v4l/buffer.rst index e2c85ddc990b..8059fc0ed520
>> 100644
>> --- a/Documentation/media/uapi/v4l/buffer.rst
>> +++ b/Documentation/media/uapi/v4l/buffer.rst
>> @@ -306,10 +306,12 @@ struct v4l2_buffer
>>        - A place holder for future extensions. Drivers and applications
>>  	must set this to 0.
>>      * - __u32
>> -      - ``reserved``
>> +      - ``request_fd``
>>        -
>> -      - A place holder for future extensions. Drivers and applications
>> -	must set this to 0.
>> +      - The file descriptor of the request to queue the buffer to. If
>> specified
>> +        and flag ``V4L2_BUF_FLAG_REQUEST_FD`` is set, then the buffer will
>> be
>> +	queued to that request. This is set by the user when calling
>> +	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
> 
> Do we need that flag ? Isn't enough to just set the request_fd field ?

Yes, it is needed. 0 is a valid fd, and applications currently set this
field to 0. So we need a flag to signal the presence of an fd.

> 
>> @@ -514,6 +516,11 @@ Buffer Flags
>>  	streaming may continue as normal and the buffer may be reused
>>  	normally. Drivers set this flag when the ``VIDIOC_DQBUF`` ioctl is
>>  	called.
>> +    * .. _`V4L2-BUF-FLAG-IN-REQUEST`:
>> +
>> +      - ``V4L2_BUF_FLAG_IN_REQUEST``
>> +      - 0x00000080
>> +      - This buffer is part of a request that hasn't been queued yet.
> 
> What is this used for ? I don't see it being explained in the documentation.

I'll improve this. It is set if the buffer was added to a request but
the request itself hasn't been queued yet. It's a status flag.

That said, I need to make some changes to vb2 since there are some problems
with combining VIDIOC_BUF_PREPARE and requests.

> 
>>      * .. _`V4L2-BUF-FLAG-KEYFRAME`:
>>
>>        - ``V4L2_BUF_FLAG_KEYFRAME``
>> @@ -589,6 +596,11 @@ Buffer Flags
>>  	the format. Any Any subsequent call to the
>>
>>  	:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
>>
>>  	but return an ``EPIPE`` error code.
>> +    * .. _`V4L2-BUF-FLAG-REQUEST-FD`:
>> +
>> +      - ``V4L2_BUF_FLAG_REQUEST_FD``
>> +      - 0x00800000
>> +      - The ``request_fd`` field contains a valid file descriptor.
>>      * .. _`V4L2-BUF-FLAG-TIMESTAMP-MASK`:
>>
>>        - ``V4L2_BUF_FLAG_TIMESTAMP_MASK``
>> diff --git a/Documentation/media/uapi/v4l/common.rst
>> b/Documentation/media/uapi/v4l/common.rst index 13f2ed3fc5a6..a4aa0059d45a
>> 100644
>> --- a/Documentation/media/uapi/v4l/common.rst
>> +++ b/Documentation/media/uapi/v4l/common.rst
>> @@ -44,3 +44,4 @@ applicable to all devices.
>>      crop
>>      selection-api
>>      streaming-par
>> +    request-api
>> diff --git a/Documentation/media/uapi/v4l/request-api.rst
>> b/Documentation/media/uapi/v4l/request-api.rst new file mode 100644
>> index 000000000000..0ce75b254956
>> --- /dev/null
>> +++ b/Documentation/media/uapi/v4l/request-api.rst
>> @@ -0,0 +1,211 @@
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _media-request-api:
>> +
>> +Request API
>> +===========
>> +
>> +The Request API has been designed to allow V4L2 to deal with requirements
>> of +modern devices (stateless codecs, MIPI cameras, ...) and APIs (Android
> 
> I wouldn't call this MIPI cameras. In this context MIPI only defines the bus 
> between the camera sensor and the ISP or bridge, so it's quite irrelevant. 
> "ISP-based cameras" might be a better term, although some ISP-based cameras 
> could still offer a high-level API that doesn't require or even benefit from 
> the use of requests.
> 
>> Codec +v2). One such requirement is the ability for devices belonging to
>> the same +pipeline to reconfigure and collaborate closely on a per-frame
>> basis. Another is +efficient support of stateless codecs, which need
>> per-frame controls to be set +asynchronously in order to be used
>> efficiently.
> 
> Do you really mean asynchronously ? I thought the purpose of the request API 
> with codecs was to set controls synchronously with frames.

Right.

> 
>> +Supporting these features without the Request API is possible but terribly
>> +inefficient: user-space would have to flush all activity on the media
>> pipeline, +reconfigure it for the next frame, queue the buffers to be
>> processed with that +configuration, and wait until they are all available
>> for dequeuing before +considering the next frame. This defeats the purpose
>> of having buffer queues +since in practice only one buffer would be queued
>> at a time.
> 
> It's not even always possible. For memory to memory devices such a behaviour 
> might be possible, but for camera devices in general you don't have the option 
> of stopping and reconfiguring the hardware as frames are continuously captured 
> by the sensor.
> 
>> +The Request API allows a specific configuration of the pipeline (media
>> +controller topology + controls for each device) to be associated with
> 
> Should we mention formats too ?

Not supported at the moment. But yes, this will have to be added in the
future.

 Should we use "entity" instead of "device" as
> this documents an MC-based API ?

Yes, that's better.

> 
>> specific +buffers. The parameters are applied by each participating device
>> as buffers +associated to a request flow in. This allows user-space to
>> schedule several +tasks ("requests") with different parameters in advance,
>> knowing that the +parameters will be applied when needed to get the
>> expected result. Control +values at the time of request completion are also
>> available for reading.
>> +
>> +Usage
>> +=====
>> +
>> +The Request API is used on top of standard media controller and V4L2 calls,
>> +which are augmented with an extra ``request_fd`` parameter. Requests
>> themselves +are allocated from the supporting media controller node.
> 
> I'd like it if we could document the request API in the MC documentation for 
> the overall concept, and then have a V4L2-specific documentation that explains 
> how the request API is used with V4L2.

I agree, it should be moved.

> 
>> +
>> +Request Allocation
>> +------------------
>> +
>> +User-space allocates requests using :ref:`MEDIA_IOC_REQUEST_ALLOC`
>> +for the media device node. This returns a file descriptor representing the
>> +request. Typically, several such requests will be allocated.
>> +
>> +Request Preparation
>> +-------------------
>> +
>> +Standard V4L2 ioctls can then receive a request file descriptor to express
>> the +fact that the ioctl is part of said request, and is not to be applied
>> +immediately. See :ref:`MEDIA_IOC_REQUEST_ALLOC` for a list of ioctls that
>> +support this.
> 
> As explained above in the documentation of MEDIA_IOC_REQUEST_ALLOC, I would 
> rather list the ioctls explicitly here, as MEDIA_IOC_REQUEST_ALLOC is really 
> not V4L2-specific.
> 
>> Controls set with a ``request_fd`` parameter are stored
>> instead +of being immediately applied, and buffers queued to a request do
>> not enter the +regular buffer queue until the request itself is queued.
>> +
>> +Request Submission
>> +------------------
>> +
>> +Once the parameters and buffers of the request are specified, it can be
>> +queued by calling :ref:`MEDIA_REQUEST_IOC_QUEUE` on the request FD.
>> +This will make the buffers associated to the request available to their
>> driver, +which can then apply the associated controls as buffers are
>> processed. A queued +request cannot be modified anymore.
>> +
>> +If several devices are part of the request, individual drivers may
> 
> I'd write "If parameters for multiple entities are part of the request", or 
> "If the request contains parameters for multiple entities".
> 
>> synchronize +so the requested pipeline's topology is applied before the
>> buffers are +processed. This is at the discretion of media controller
>> drivers and is not a +requirement.
> 
> One of the main purposes of the request API is to support atomic 
> configuration. Saying that it's simply optional defeats that purpose. I agree 
> that atomicity can't be achieved in all cases, and that there will often be a 
> best-effort approach, but for hardware devices that support atomic 
> configuration I think applications need to be able to rely on the driver 
> implementing that feature. I would thus put a bit more pressure on drivers 
> than just saying it's fully optional.

I agree, I made the change ('best effort implementation').

> 
>> +Buffers queued without an associated request after a request-bound buffer
>> will +be processed using the state of the hardware at the time of the
>> request +completion.
> 
> I'm not sure to follow that, could you explain in a bit more details ? Also, 
> even more than for controls (see below), I really want to know about use cases 
> for mixing buffers in and outside of requests for the same buffer queue before 
> accepting it.

In v15 I prohibit queueing buffers directly once requests are used. I see no
use-case for mixing these modes and it is too messy.

> 
> I also would like to see a detailed description of what happens when buffers 
> are queued in a request for one queue and outside of requests for another 
> queue (for example in the case of codecs), for both capture and output queues.

See my RFC (specific to m2m devices at the moment):

https://www.mail-archive.com/linux-media@vger.kernel.org/msg132202.html

> 
>> All the same, controls set without a request are applied +immediately,
>> regardless of whether a request is in use or not.
> 
> This will be tricky to implement, and will potentially generate side effects 
> difficult to handle, and difficult to debug. I understand that this is a 
> requirement for codecs, but I don't know the exact use case(s), so I can't 
> comment on whether this is the right approach. While I don't necessarily 
> reject this feature on principle, I first want to know more about the use 
> case(s) before accepting it. If we end up needing it, we'll have to better 
> document it, by clearly specifying what is allowed and what isn't (for 
> instance, we might decide to allow setting control asynchronously only when 
> they're not simultaneously modified through a queued request), as well as the 
> exact behaviour that applications can expect in the allowed cases.

I discussed this in my previous reply.

> 
>> +User-space can ``poll()`` a request FD in order to wait until the request
>> +completes. A request is considered complete once all its associated buffers
>> are +available for dequeuing and all the associated controls have been
>> updated with +the values at the time of completion. Note that user-space
>> does not need to wait +for the request to complete to dequeue its buffers:
>> buffers that are available +halfway through a request can be dequeued
>> independently of the request's state.
>> +
>> +A completed request contains the state of the request at the time of the
>> +request completion. User-space can query that state by calling
>> +:ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with the request FD.
>> +
>> +Recycling and Destruction
>> +-------------------------
>> +
>> +Finally, completed request can either be discarded or be reused. Calling
>> +``close()`` on a request FD will make that FD unusable, freeing the request
>> if +it is not referenced elsewhere.
> 
> Where else can it be referenced ? Does this only refer to the ability to 
> duplicate FDs or share them with other processes ? If so, I would document 
> that requests are freed when all file descriptors that refer to them are 
> closed, not when close() is called on one file descriptor.

I rephrased this. It referred to the kernel still having a reference to it.
I.e. if you queue a request, then close it, then the kernel still is using
it until the request is completed. Only then is it freed.

> 
>> The :ref:`MEDIA_REQUEST_IOC_REINIT`
>> will +clear a request's state and make it available again. No state is
>> retained by +this operation: the request is as if it had just been
>> allocated.
>> +
>> +Example for a Memory-to-Memory Device
>> +-------------------------------------
>> +
>> +M2M devices are single-node V4L2 devices providing one OUTPUT queue (for
>> +user-space to provide input buffers) and one CAPTURE queue (to retrieve
>> +processed data). These devices are commonly used for frame processors or
>> +stateless codecs.
>> +
>> +In this use-case, the request API can be used to associate specific
>> controls to +be applied by the driver before processing an OUTPUT buffer,
> 
> As commented below, I would explain that the controls are applied for the 
> buffer, not before processing it.

Done.

> 
>> allowing user-space +to queue many such buffers in advance. It can also
>> take advantage of requests' +ability to capture the state of controls when
>> the request completes to read back +information that may be subject to
>> change.
>> +
>> +Put into code, after obtaining a request, user-space can assign controls
>> and one +OUTPUT buffer to it:
>> +
>> +.. code-block:: c
>> +
>> +	struct v4l2_buffer buf;
>> +	struct v4l2_ext_controls ctrls;
>> +	struct media_request_alloc alloc = { 0 };
>> +	int req_fd;
>> +	...
>> +	ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &alloc);
>> +	req_fd = alloc.fd;
>> +	...
>> +	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
>> +	ctrls.request_fd = req_fd;
>> +	ioctl(codec_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
>> +	...
>> +	buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> +	buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;
>> +	buf.request_fd = req_fd;
>> +	ioctl(codec_fd, VIDIOC_QBUF, &buf);
>> +
>> +Note that there is typically no need to use the Request API for CAPTURE
>> buffers +since there are per-frame settings to report there.
> 
> Do you mean since there are no per-frame settings to report there ?

Indeed. Fixed.

> 
>> +Once the request is fully prepared, it can be queued to the driver:
>> +
>> +.. code-block:: c
>> +
>> +	ioctl(req_fd, MEDIA_REQUEST_IOC_QUEUE);
>> +
>> +User-space can then either wait for the request to complete by calling
>> poll() on +its file descriptor, or start dequeuing CAPTURE buffers. Most
>> likely, it will +want to get CAPTURE buffers as soon as possible and this
>> can be done using a +regular DQBUF:
>> +
>> +.. code-block:: c
>> +
>> +	struct v4l2_buffer buf;
>> +
>> +	memset(&buf, 0, sizeof(buf));
>> +	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	ioctl(codec_fd, VIDIOC_DQBUF, &buf);
> 
> The above explanation makes it sounds like waiting for the request to complete 
> will ensure that a capture buffer is available, and that's not necessarily the 
> case. There isn't always a guarantee that one output buffer will result in one 
> and only one capture buffer being filled.

I've made a note of this in the documentation.

> 
>> +We can then, after ensuring that the request is completed via polling the
>> +request FD, query control values at the time of its completion via an
>> +annotated call to G_EXT_CTRLS. This is particularly useful for volatile
>> controls +for which we want to query values as soon as the capture buffer
>> is produced. +
>> +.. code-block:: c
>> +
>> +	struct pollfd pfd = { .events = POLLPRI, .fd = request_fd };
>> +	poll(&pfd, 1, -1);
>> +	...
>> +	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
>> +	ctrls.request_fd = req_fd;
>> +	ioctl(codec_fd, VIDIOC_G_EXT_CTRLS, &ctrls);
>> +
>> +Once we don't need the request anymore, we can either recycle it for reuse
>> with +:ref:`MEDIA_REQUEST_IOC_REINIT`...
>> +
>> +.. code-block:: c
>> +
>> +	ioctl(req_fd, MEDIA_REQUEST_IOC_REINIT);
>> +
>> +... or close its file descriptor to completely dispose of it.
>> +
>> +.. code-block:: c
>> +
>> +	close(req_fd);
>> +
>> +Example for a Simple Capture Device
>> +-----------------------------------
>> +
>> +With a simple capture device, requests can be used to specify controls to
>> apply +to a given CAPTURE buffer. The driver will apply these controls
>> before producing +the marked CAPTURE buffer.
> 
> As explained below I think we should be a bit more precise with the wording 
> here.
> 
>> +.. code-block:: c
>> +
>> +	struct v4l2_buffer buf;
>> +	struct v4l2_ext_controls ctrls;
>> +	struct media_request_alloc alloc = { 0 };
>> +	int req_fd;
>> +	...
>> +	ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &alloc);
>> +	req_fd = alloc.fd;
>> +	...
>> +	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
>> +	ctrls.request_fd = req_fd;
>> +	ioctl(camera_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
>> +	...
>> +	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;
>> +	buf.request_fd = req_fd;
>> +	ioctl(camera_fd, VIDIOC_QBUF, &buf);
>> +
>> +Once the request is fully prepared, it can be queued to the driver:
>> +
>> +.. code-block:: c
>> +
>> +	ioctl(req_fd, MEDIA_REQUEST_IOC_QUEUE);
>> +
>> +User-space can then dequeue buffers, wait for the request completion, query
>> +controls and recycle the request as in the M2M example above.
>> diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
>> b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst index
>> 2011c2b2ee67..8f788c444347 100644
>> --- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
>> @@ -95,6 +95,19 @@ appropriate. In the first case the new value is set in
>> struct is inappropriate (e.g. the given menu index is not supported by the
>> menu control), then this will also result in an ``EINVAL`` error code
>> error.
>>
>> +If ``request_fd`` is set to a not-submitted request file descriptor and
>> +``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``, then the
>> +controls are not applied immediately when calling
>> +:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, but instead are applied
>> right +before the driver starts processing a buffer associated to the same
>> request. +
> 
> Please see my related comments below for VIDIOC_QBUF.
> 
> What happens if which is set to V4L2_CTRL_WHICH_REQUEST_VAL and the request is 
> already queued ?

EBUSY will be returned.

> 
>> +If ``request_fd`` is specified and ``which`` is set to
>> ``V4L2_CTRL_WHICH_REQUEST_VAL`` +during a call to :ref:`VIDIOC_G_EXT_CTRLS
>> <VIDIOC_G_EXT_CTRLS>`, then the +returned values will be the values
>> currently set for the request (or the +hardware value if none is set)
> 
> Do we really have a need for returning the hardware value ? That seems a bit 
> random to me, wouldn't it be better to return an error instead ?

It gets very confusing if you have to remember which controls you set in the
request and which you didn't. This simply returns the value that will be set
when this request is applied. If none of the queued requests ever set this
control, then it will fall back to the hardware value.

> 
>> if the request has not yet completed, or the +values of the controls at the
>> time of request completion if it has already +completed.
>> +
>>  The driver will only set/get these controls if all control values are
>>  correct. This prevents the situation where only some of the controls
>>  were set/get. Only low-level errors (e. g. a failed i2c command) can
>> @@ -209,8 +222,10 @@ still cause this situation.
>>        - ``which``
>>        - Which value of the control to get/set/try.
>>  	``V4L2_CTRL_WHICH_CUR_VAL`` will return the current value of the
>> -	control and ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
>> -	value of the control.
>> +	control, ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
>> +	value of the control and ``V4L2_CTRL_WHICH_REQUEST_VAL`` indicates that
>> +	these controls have to be retrieved from a request or tried/set for
>> +	a request.
>>
>>  	.. note::
>>
>> @@ -272,8 +287,12 @@ still cause this situation.
>>  	then you can call :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` to try
>> to discover the actual control that failed the validation step.
>> Unfortunately,
>>  	there is no ``TRY`` equivalent for :ref:`VIDIOC_G_EXT_CTRLS
>> <VIDIOC_G_EXT_CTRLS>`. +    * - __s32
>> +      - ``request_fd``
>> +	File descriptor of the request to be used by this operation. Only
>> +	valid if ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``.
>>      * - __u32
>> -      - ``reserved``\ [2]
>> +      - ``reserved``\ [1]
>>        - Reserved for future extensions.
>>
>>  	Drivers and applications must set the array to zero.
>> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>> b/Documentation/media/uapi/v4l/vidioc-qbuf.rst index
>> 9e448a4aa3aa..c9f55d8340d1 100644
>> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>> @@ -98,6 +98,13 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF
>> <VIDIOC_STREAMON>` or
>>  :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
>>
>>  device is closed.
>>
>> +The ``request_fd`` field can be used when queuing to specify the file
>> +descriptor of a request, if requests are in use. Setting it means that the
>> +buffer will not be passed to the driver until the request itself is queued.
>> +Also, the driver will apply any setting associated with the request before
>> +processing the buffer.
> 
> I think we should be more precise with the wording, here and above in the 
> documentation. From an API point of view, we need to guarantee that the 
> settings from the request are used to process the image capture in the buffer, 
> or the image output from the buffer. Drivers don't process buffers other than 
> queuing them to the hardware, so saying that the driver will apply settings 
> before processing the buffer is a bit vague in my opinion, and also possibly 
> not very accurate depending on the hardware.
> 
> Saying that controls are applied right before the buffer is processed by the 
> driver is inaccurate : for example exposure time might need several frames to 
> take effect, and might thus need to be applied a few frames before the buffer 
> is queued to the hardware for capture. The other way around is possible too : 
> the hardware might support a buffer queue but have no queue for controls. 
> Controls would then need to be applied a few frames after the buffer is queued 
> to the hardware in order to take effect for the right buffer.
> 
> We're specifying an API that carries very strong semantics across multiple 
> components and multiple objects, so I think it's very important to be as 
> precise as possible.

I've rephrased it to say:

"the driver will apply any settings associated with the request for this buffer."

It leaves the 'when' out of it, just that it has be applied 'for' this buffer.

I think your suggestion for this phrase makes a lot of sense.

> 
>> This field will be ignored unless the
>> +``V4L2_BUF_FLAG_REQUEST_FD`` flag is set.
>> +
>>  Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
>>  (capturing) or displayed (output) buffer from the driver's outgoing
>>  queue. They just set the ``type``, ``memory`` and ``reserved`` fields of
>> diff --git a/Documentation/media/videodev2.h.rst.exceptions
>> b/Documentation/media/videodev2.h.rst.exceptions index
>> a5cb0a8686ac..5a5a1c772053 100644
>> --- a/Documentation/media/videodev2.h.rst.exceptions
>> +++ b/Documentation/media/videodev2.h.rst.exceptions
>> @@ -514,6 +514,7 @@ ignore define V4L2_CTRL_DRIVER_PRIV
>>  ignore define V4L2_CTRL_MAX_DIMS
>>  ignore define V4L2_CTRL_WHICH_CUR_VAL
>>  ignore define V4L2_CTRL_WHICH_DEF_VAL
>> +ignore define V4L2_CTRL_WHICH_REQUEST_VAL
>>  ignore define V4L2_OUT_CAP_CUSTOM_TIMINGS
>>  ignore define V4L2_CID_MAX_CTRLS
> 

Thanks for all the feedback!

Regards,

	Hans
