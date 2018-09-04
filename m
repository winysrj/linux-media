Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:36877 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726335AbeIDMW4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 08:22:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 10/10] media-request: update documentation
Date: Tue,  4 Sep 2018 09:58:50 +0200
Message-Id: <20180904075850.2406-11-hverkuil@xs4all.nl>
In-Reply-To: <20180904075850.2406-1-hverkuil@xs4all.nl>
References: <20180904075850.2406-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Various clarifications and readability improvements based on
Laurent Pinchart's review of the documentation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 .../uapi/mediactl/media-ioc-request-alloc.rst |  3 +-
 .../uapi/mediactl/media-request-ioc-queue.rst |  7 +--
 .../media/uapi/mediactl/request-api.rst       | 51 +++++++++++--------
 .../uapi/mediactl/request-func-close.rst      |  1 +
 .../media/uapi/mediactl/request-func-poll.rst |  2 +-
 Documentation/media/uapi/v4l/buffer.rst       | 14 +++--
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  5 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  5 +-
 8 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
index 34434e2b3918..0f8b31874002 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
@@ -52,7 +52,8 @@ for the request to complete.
 
 The request will remain allocated until all the file descriptors associated
 with it are closed by :ref:`close() <request-func-close>` and the driver no
-longer uses the request internally.
+longer uses the request internally. See also
+:ref:`here <media-request-life-time>` for more information.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
index dbf635ae9b2b..6dd2d7fea714 100644
--- a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
@@ -40,9 +40,6 @@ Other errors can be returned if the contents of the request contained
 invalid or inconsistent data, see the next section for a list of
 common error codes. On error both the request and driver state are unchanged.
 
-Typically if you get an error here, then that means that the application
-did something wrong and you have to fix the application.
-
 Once a request is queued, then the driver is required to gracefully handle
 errors that occur when the request is applied to the hardware. The
 exception is the ``EIO`` error which signals a fatal error that requires
@@ -68,8 +65,8 @@ EBUSY
     to mix the two APIs.
 ENOENT
     The request did not contain any buffers. All requests are required
-    to have at least one buffer. This can also be returned if required
-    controls are missing.
+    to have at least one buffer. This can also be returned if some required
+    configuration is missing in the request.
 ENOMEM
     Out of memory when allocating internal data structures for this
     request.
diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
index aeb8d00934a4..5f4a23029c48 100644
--- a/Documentation/media/uapi/mediactl/request-api.rst
+++ b/Documentation/media/uapi/mediactl/request-api.rst
@@ -12,6 +12,9 @@ the same pipeline to reconfigure and collaborate closely on a per-frame basis.
 Another is support of stateless codecs, which require controls to be applied
 to specific frames (aka 'per-frame controls') in order to be used efficiently.
 
+While the initial use-case was V4L2, it can be extended to other subsystems
+as well, as long as they use the media controller.
+
 Supporting these features without the Request API is not always possible and if
 it is, it is terribly inefficient: user-space would have to flush all activity
 on the media pipeline, reconfigure it for the next frame, queue the buffers to
@@ -20,19 +23,23 @@ dequeuing before considering the next frame. This defeats the purpose of having
 buffer queues since in practice only one buffer would be queued at a time.
 
 The Request API allows a specific configuration of the pipeline (media
-controller topology + controls for each media entity) to be associated with
-specific buffers. The parameters are applied by each participating device as
-buffers associated to a request flow in. This allows user-space to schedule
-several tasks ("requests") with different parameters in advance, knowing that
-the parameters will be applied when needed to get the expected result. Control
-values at the time of request completion are also available for reading.
+controller topology + configuration for each media entity) to be associated with
+specific buffers. This allows user-space to schedule several tasks ("requests")
+with different configurations in advance, knowing that the configuration will be
+applied when needed to get the expected result. Configuration values at the time
+of request completion are also available for reading.
 
 Usage
 =====
 
-The Request API is used on top of standard media controller and V4L2 calls,
-which are augmented with an extra ``request_fd`` parameter. Requests themselves
-are allocated from the supporting media controller node.
+The Request API extends the Media Controller API and cooperates with
+subsystem-specific APIs to support request usage. At the Media Controller
+level, requests are allocated from the supporting Media Controller device
+node. Their life cycle is then managed through the request file descriptors in
+an opaque way. Configuration data, buffer handles and processing results
+stored in requests are accessed through subsystem-specific APIs extended for
+request support, such as V4L2 APIs that take an explicit ``request_fd``
+parameter.
 
 Request Allocation
 ------------------
@@ -47,29 +54,27 @@ Request Preparation
 Standard V4L2 ioctls can then receive a request file descriptor to express the
 fact that the ioctl is part of said request, and is not to be applied
 immediately. See :ref:`MEDIA_IOC_REQUEST_ALLOC` for a list of ioctls that
-support this. Controls set with a ``request_fd`` parameter are stored instead
-of being immediately applied, and buffers queued to a request do not enter the
-regular buffer queue until the request itself is queued.
+support this. Configurations set with a ``request_fd`` parameter are stored
+instead of being immediately applied, and buffers queued to a request do not
+enter the regular buffer queue until the request itself is queued.
 
 Request Submission
 ------------------
 
-Once the parameters and buffers of the request are specified, it can be
+Once the configuration and buffers of the request are specified, it can be
 queued by calling :ref:`MEDIA_REQUEST_IOC_QUEUE` on the request file descriptor.
 A request must contain at least one buffer, otherwise ``ENOENT`` is returned.
-This will make the buffers associated to the request available to their driver,
-which can then apply the associated controls as buffers are processed. A queued
-request cannot be modified anymore.
+A queued request cannot be modified anymore.
 
 .. caution::
    For :ref:`memory-to-memory devices <codec>` you can use requests only for
    output buffers, not for capture buffers. Attempting to add a capture buffer
    to a request will result in an ``EACCES`` error.
 
-If the request contains parameters for multiple entities, individual drivers may
-synchronize so the requested pipeline's topology is applied before the buffers
-are processed. Media controller drivers do a best effort implementation since
-perfect atomicity may not be possible due to hardware limitations.
+If the request contains configurations for multiple entities, individual drivers
+may synchronize so the requested pipeline's topology is applied before the
+buffers are processed. Media controller drivers do a best effort implementation
+since perfect atomicity may not be possible due to hardware limitations.
 
 .. caution::
 
@@ -96,14 +101,16 @@ Note that user-space does not need to wait for the request to complete to
 dequeue its buffers: buffers that are available halfway through a request can
 be dequeued independently of the request's state.
 
-A completed request contains the state of the request at the time of the
-request completion. User-space can query that state by calling
+A completed request contains the state of the device after the request was
+executed. User-space can query that state by calling
 :ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with the request file
 descriptor. Calling :ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` for a
 request that has been queued but not yet completed will return ``EBUSY``
 since the control values might be changed at any time by the driver while the
 request is in flight.
 
+.. _media-request-life-time:
+
 Recycling and Destruction
 -------------------------
 
diff --git a/Documentation/media/uapi/mediactl/request-func-close.rst b/Documentation/media/uapi/mediactl/request-func-close.rst
index b5c78683840b..098d7f2b9548 100644
--- a/Documentation/media/uapi/mediactl/request-func-close.rst
+++ b/Documentation/media/uapi/mediactl/request-func-close.rst
@@ -36,6 +36,7 @@ Description
 Closes the request file descriptor. Resources associated with the request
 are freed once all file descriptors associated with the request are closed
 and the driver has completed the request.
+See :ref:`here <media-request-life-time>` for more information.
 
 
 Return Value
diff --git a/Documentation/media/uapi/mediactl/request-func-poll.rst b/Documentation/media/uapi/mediactl/request-func-poll.rst
index 70cc9d406a9f..85191254f381 100644
--- a/Documentation/media/uapi/mediactl/request-func-poll.rst
+++ b/Documentation/media/uapi/mediactl/request-func-poll.rst
@@ -50,7 +50,7 @@ when the request was completed.  When the function times out it returns
 a value of zero, on failure it returns -1 and the ``errno`` variable is
 set appropriately.
 
-Attempting to poll for a request that is completed or not yet queued will
+Attempting to poll for a request that is not yet queued will
 set the ``POLLERR`` flag in ``revents``.
 
 
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 58a6d7d336e6..2e266d32470a 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -308,12 +308,18 @@ struct v4l2_buffer
     * - __u32
       - ``request_fd``
       -
-      - The file descriptor of the request to queue the buffer to. If specified
-        and flag ``V4L2_BUF_FLAG_REQUEST_FD`` is set, then the buffer will be
-	queued to that request. This is set by the user when calling
-	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
+      - The file descriptor of the request to queue the buffer to. If the flag
+        ``V4L2_BUF_FLAG_REQUEST_FD`` is set, then the buffer will be
+	queued to this request. If the flag is not set, then this field will
+	be ignored.
+
+	The ``V4L2_BUF_FLAG_REQUEST_FD`` flag and this field are only used by
+	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls that
+	take a :c:type:`v4l2_buffer` as argument.
+
 	Applications should not set ``V4L2_BUF_FLAG_REQUEST_FD`` for any ioctls
 	other than :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`.
+
 	If the device does not support requests, then ``EACCES`` will be returned.
 	If requests are supported but an invalid request file descriptor is
 	given, then ``EINVAL`` will be returned.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 54a999df5aec..d9930fe776cf 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -237,7 +237,7 @@ still cause this situation.
 
 	.. note::
 
-	   When using ``V4L2_CTRL_WHICH_DEF_VAL`` note that You can only
+	   When using ``V4L2_CTRL_WHICH_DEF_VAL`` be aware that you can only
 	   get the default value of the control, you cannot set or try it.
 
 	For backwards compatibility you can also use a control class here
@@ -382,7 +382,8 @@ EINVAL
     :c:type:`v4l2_ext_control` ``value`` was
     inappropriate (e.g. the given menu index is not supported by the
     driver), or the ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL``
-    but the given ``request_fd`` was invalid.
+    but the given ``request_fd`` was invalid or ``V4L2_CTRL_WHICH_REQUEST_VAL``
+    is not supported by the kernel.
     This error code is also returned by the
     :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctls if two or
     more control values are in conflict.
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index e619fc80a323..753b3b5946b1 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -111,7 +111,10 @@ then ``EINVAL`` will be returned.
 .. caution::
    It is not allowed to mix queuing requests with queuing buffers directly.
    ``EBUSY`` will be returned if the first buffer was queued directly and
-   then the application tries to queue a request, or vice versa.
+   then the application tries to queue a request, or vice versa. After
+   closing the file descriptor, calling
+   :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or calling :ref:`VIDIOC_REQBUFS`
+   the check for this will be reset.
 
    For :ref:`memory-to-memory devices <codec>` you can specify the
    ``request_fd`` only for output buffers, not for capture buffers. Attempting
-- 
2.18.0
