Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbeDOELt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 00:11:49 -0400
Subject: Re: [RFCv3 15/17] v4l2: document the request API interface
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180207014821.164536-1-acourbot@chromium.org>
 <20180207014821.164536-16-acourbot@chromium.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a14c4ea7-1a74-d9da-9aaa-62c6bd792f87@infradead.org>
Date: Sat, 14 Apr 2018 21:11:43 -0700
MIME-Version: 1.0
In-Reply-To: <20180207014821.164536-16-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

A few comments below...

On 02/06/2018 05:48 PM, Alexandre Courbot wrote:
> Document how the request API can be used along with the existing V4L2
> interface.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  Documentation/media/uapi/v4l/buffer.rst            |  10 +-
>  Documentation/media/uapi/v4l/common.rst            |   1 +
>  Documentation/media/uapi/v4l/request-api.rst       | 236 +++++++++++++++++++++
>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  16 +-
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  21 ++
>  5 files changed, 280 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/request-api.rst


> diff --git a/Documentation/media/uapi/v4l/request-api.rst b/Documentation/media/uapi/v4l/request-api.rst
> new file mode 100644
> index 000000000000..4c61a0dbe3a9
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/request-api.rst
> @@ -0,0 +1,236 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _media-request-api:
> +
> +Request API
> +===========
> +
> +The Request API has been designed to allow V4L2 to deal with requirements of
> +modern devices (stateless codecs, MIPI cameras, ...) and APIs (Android Codec
> +v2). One such requirement is the ability for devices belonging to the same
> +pipeline to reconfigure and collaborate closely on a per-frame basis. Another is
> +efficient support of stateless codecs, which need per-frame controls to be set
> +asynchronously in order to be efficiently used.

                           to be used efficiently.

> +
> +Supporting these features without the Request API is possible but terribly
> +inefficient: user-space would have to flush all activity on the media pipeline,
> +reconfigure it for the next frame, queue the buffers to be processed with that
> +configuration, and wait until they are all available for dequeing before

"dequeing" should be dequeueing or dequeuing.

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
> +Request Allocation
> +------------------
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
> +
> +Request Submission
> +------------------
> +
> +Once the parameters and buffers of the request are specified, it can be
> +submitted with the ``MEDIA_REQ_CMD_SUBMIT`` command. This will make the buffers
> +associated to the request available to their driver, which can then apply the
> +saved controls as buffers are processed. A submitted request cannot be modified
> +anymore.
> +
> +If several devices are part of the request, individual drivers may synchronize
> +so the requested pipeline's topology is applied before the buffers are
> +processed. This is at the discretion of the drivers and is not a requirement.
> +
> +Buffers queued without an associated request after a request-bound buffer will
> +be processed using the state of the hardware at the time of the request
> +completion. All the same, controls set without a request are applied
> +immediately, regardless of whether a request is in use or not.
> +
> +User-space can ``poll()`` a request FD in order to wait until the request
> +completes. A request is considered complete once all its associated buffers are
> +available for dequeing. Note that user-space does not need to wait for the

s/dequeing/dequeu[e]ing/

> +request to complete to dequeue its buffers: buffers that are available halfway
> +through a request can be dequeued independently of the request's state.
> +
> +A completed request includes the state of all devices that had queued buffers
> +associated with it at the time of the request completion. User-space can query
> +that state by calling :c:func:`VIDIOC_G_EXT_CTRLS` with the request FD.
> +
> +RFC Note: requests are currently processed in buffer order, meaning that they
> +do not necessarily start being processed in the order of their submission. Also,
> +requests do not need to complete by processing order: a driver can decide to
> +hold the buffer associated to a request in order to process the few next ones,
> +which will result in the first request completing after the others.
> +
> +Recycling and Destruction
> +-------------------------

[snip]

> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index 9e448a4aa3aa..d7fea37f32e7 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -98,6 +98,12 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
>  :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
>  device is closed.
>  
> +For all buffer types, the ``request_fd`` field can be used when enqueing

Looks like "enqueing" should be enqueueing or enqueuing.

> +to specify the file descriptor of a request, if requests are in use.
> +Setting it means that the buffer will not be passed to the driver until
> +the request itself is submitted. Also, the driver will apply any setting
> +associated with the request before processing the buffer.
> +
>  Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
>  (capturing) or displayed (output) buffer from the driver's outgoing
>  queue. They just set the ``type``, ``memory`` and ``reserved`` fields of


-- 
~Randy
