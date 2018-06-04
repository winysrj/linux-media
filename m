Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53953 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752594AbeFDLrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 29/35] Documentation: v4l: document request API
Date: Mon,  4 Jun 2018 13:46:42 +0200
Message-Id: <20180604114648.26159-30-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexandre Courbot <acourbot@chromium.org>

Document the request API for V4L2 devices, and amend the documentation
of system calls influenced by it.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/mediactl/media-controller.rst  |   1 +
 .../media/uapi/mediactl/media-funcs.rst       |   3 +
 .../uapi/mediactl/media-ioc-request-alloc.rst |  71 ++++++
 .../uapi/mediactl/media-request-ioc-queue.rst |  50 ++++
 .../mediactl/media-request-ioc-reinit.rst     |  51 ++++
 .../media/uapi/mediactl/request-api.rst       | 219 ++++++++++++++++++
 Documentation/media/uapi/v4l/buffer.rst       |  18 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  28 ++-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  11 +
 .../media/videodev2.h.rst.exceptions          |   1 +
 10 files changed, 447 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
 create mode 100644 Documentation/media/uapi/mediactl/request-api.rst

diff --git a/Documentation/media/uapi/mediactl/media-controller.rst b/Documentation/media/uapi/mediactl/media-controller.rst
index 0eea4f9a07d5..66aff38cd499 100644
--- a/Documentation/media/uapi/mediactl/media-controller.rst
+++ b/Documentation/media/uapi/mediactl/media-controller.rst
@@ -21,6 +21,7 @@ Part IV - Media Controller API
     media-controller-intro
     media-controller-model
     media-types
+    request-api
     media-funcs
     media-header
 
diff --git a/Documentation/media/uapi/mediactl/media-funcs.rst b/Documentation/media/uapi/mediactl/media-funcs.rst
index 076856501cdb..f4da9b3e17ec 100644
--- a/Documentation/media/uapi/mediactl/media-funcs.rst
+++ b/Documentation/media/uapi/mediactl/media-funcs.rst
@@ -16,3 +16,6 @@ Function Reference
     media-ioc-enum-entities
     media-ioc-enum-links
     media-ioc-setup-link
+    media-ioc-request-alloc
+    media-request-ioc-queue
+    media-request-ioc-reinit
diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
new file mode 100644
index 000000000000..d45a94c9e23c
--- /dev/null
+++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
@@ -0,0 +1,71 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+.. _media_ioc_request_alloc:
+
+*****************************
+ioctl MEDIA_IOC_REQUEST_ALLOC
+*****************************
+
+Name
+====
+
+MEDIA_IOC_REQUEST_ALLOC - Allocate a request
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, MEDIA_IOC_REQUEST_ALLOC, struct media_request_alloc *argp )
+    :name: MEDIA_IOC_REQUEST_ALLOC
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <media-func-open>`.
+
+``argp``
+
+
+Description
+===========
+
+If the media device supports :ref:`requests <media-request-api>`, then
+this ioctl can be used to allocate a request. A request is accessed through
+a file descriptor that is returned in struct :c:type:`media_request_alloc`.
+
+If the request was successfully allocated, then the request file descriptor
+can be passed to :ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>`,
+:ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
+:ref:`ioctl VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
+:ref:`ioctl VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
+
+In addition, the request can be queued by calling
+:ref:`MEDIA_REQUEST_IOC_QUEUE` and re-initialized by calling
+:ref:`MEDIA_REQUEST_IOC_REINIT`.
+
+Finally, the file descriptor can be polled to wait for the request to
+complete.
+
+To free the request the file descriptor has to be closed.
+
+.. c:type:: media_request_alloc
+
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
+.. flat-table:: struct media_request_alloc
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    *  -  __s32
+       -  ``fd``
+       -  The file descriptor of the request.
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
new file mode 100644
index 000000000000..d3bac7b70422
--- /dev/null
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
@@ -0,0 +1,50 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+.. _media_request_ioc_queue:
+
+*****************************
+ioctl MEDIA_REQUEST_IOC_QUEUE
+*****************************
+
+Name
+====
+
+MEDIA_REQUEST_IOC_QUEUE - Queue a request
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int request_fd, MEDIA_REQUEST_IOC_QUEUE )
+    :name: MEDIA_REQUEST_IOC_QUEUE
+
+
+Arguments
+=========
+
+``request_fd``
+    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
+
+
+Description
+===========
+
+If the media device supports :ref:`requests <media-request-api>`, then
+this request ioctl can be used to queue a previously allocated request.
+
+If the request was successfully queued, then the file descriptor can be
+polled to wait for the request to complete.
+
+If the request was already queued before, then '`EBUSY'` is returned.
+Other errors can be returned if the contents of the request contained
+invalid or inconsistent data.
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+EBUSY
+    The request was already queued.
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
new file mode 100644
index 000000000000..7cbb7eb5d73e
--- /dev/null
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
@@ -0,0 +1,51 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+.. _media_request_ioc_reinit:
+
+******************************
+ioctl MEDIA_REQUEST_IOC_REINIT
+******************************
+
+Name
+====
+
+MEDIA_REQUEST_IOC_REINIT - Re-initialize a request
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int request_fd, MEDIA_REQUEST_IOC_REINIT )
+    :name: MEDIA_REQUEST_IOC_REINIT
+
+
+Arguments
+=========
+
+``request_fd``
+    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
+
+Description
+===========
+
+If the media device supports :ref:`requests <media-request-api>`, then
+this request ioctl can be used to re-initialize a previously allocated
+request.
+
+Re-initializing a request will clear any existing data from the request.
+This avoids having to close() a completed request and allocate a new
+request. Instead the completed request can just be re-initialized and
+it is ready to be used again.
+
+A request can only be re-initialized if it either has not been queued
+yet, or if it was queued and completed.
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+EBUSY
+    The request is queued but not yet completed.
diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
new file mode 100644
index 000000000000..4d10f18181a4
--- /dev/null
+++ b/Documentation/media/uapi/mediactl/request-api.rst
@@ -0,0 +1,219 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _media-request-api:
+
+Request API
+===========
+
+The Request API has been designed to allow V4L2 to deal with requirements of
+modern devices (stateless codecs, complex camera pipelines, ...) and APIs
+(Android Codec v2). One such requirement is the ability for devices belonging to
+the same pipeline to reconfigure and collaborate closely on a per-frame basis.
+Another is efficient support of stateless codecs, which need per-frame controls
+to be set synchronously in order to be used efficiently.
+
+Supporting these features without the Request API is not always possible and if
+it is, it is terribly inefficient: user-space would have to flush all activity
+on the media pipeline, reconfigure it for the next frame, queue the buffers to
+be processed with that configuration, and wait until they are all available for
+dequeuing before considering the next frame. This defeats the purpose of having
+buffer queues since in practice only one buffer would be queued at a time.
+
+The Request API allows a specific configuration of the pipeline (media
+controller topology + controls for each media entity) to be associated with
+specific buffers. The parameters are applied by each participating device as
+buffers associated to a request flow in. This allows user-space to schedule
+several tasks ("requests") with different parameters in advance, knowing that
+the parameters will be applied when needed to get the expected result. Control
+values at the time of request completion are also available for reading.
+
+Usage
+=====
+
+The Request API is used on top of standard media controller and V4L2 calls,
+which are augmented with an extra ``request_fd`` parameter. Requests themselves
+are allocated from the supporting media controller node.
+
+Request Allocation
+------------------
+
+User-space allocates requests using :ref:`MEDIA_IOC_REQUEST_ALLOC`
+for the media device node. This returns a file descriptor representing the
+request. Typically, several such requests will be allocated.
+
+Request Preparation
+-------------------
+
+Standard V4L2 ioctls can then receive a request file descriptor to express the
+fact that the ioctl is part of said request, and is not to be applied
+immediately. See :ref:`MEDIA_IOC_REQUEST_ALLOC` for a list of ioctls that
+support this. Controls set with a ``request_fd`` parameter are stored instead
+of being immediately applied, and buffers queued to a request do not enter the
+regular buffer queue until the request itself is queued.
+
+Request Submission
+------------------
+
+Once the parameters and buffers of the request are specified, it can be
+queued by calling :ref:`MEDIA_REQUEST_IOC_QUEUE` on the request FD.
+This will make the buffers associated to the request available to their driver,
+which can then apply the associated controls as buffers are processed. A queued
+request cannot be modified anymore.
+
+If the request contains parameters for multiple entities, individual drivers may
+synchronize so the requested pipeline's topology is applied before the buffers
+are processed. Media controller drivers do a best effort implementation since
+perfect atomicity may not be possible due to hardware limitations.
+
+Once buffers are added to a request for the first time it is no longer possible
+to queue non-request buffers of that buffer type until
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called.
+
+Controls can still be set without a request and are applied immediately,
+regardless of whether a request is in use or not. Setting the same control
+through a request and directly can lead to undefined behavior!
+
+User-space can ``poll()`` a request FD in order to wait until the request
+completes. A request is considered complete once all its associated buffers are
+available for dequeuing and all the associated controls have been updated with
+the values at the time of completion. Note that user-space does not need to wait
+for the request to complete to dequeue its buffers: buffers that are available
+halfway through a request can be dequeued independently of the request's state.
+
+A completed request contains the state of the request at the time of the
+request completion. User-space can query that state by calling
+:ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with the request FD.
+
+Recycling and Destruction
+-------------------------
+
+Finally, completed request can either be discarded or be reused. Calling
+``close()`` on a request FD will make that FD unusable, freeing the request if
+it is not in use by the kernel. That is, if the request is queued and then the
+FD is closed, then it won't be freed until the driver completed the request.
+
+The :ref:`MEDIA_REQUEST_IOC_REINIT` will clear a request's state and make it
+available again. No state is retained by this operation: the request is as
+if it had just been allocated.
+
+Example for a Memory-to-Memory Device
+-------------------------------------
+
+M2M devices are single-node V4L2 devices providing one OUTPUT queue (for
+user-space to provide input buffers) and one CAPTURE queue (to retrieve
+processed data). These devices are commonly used for frame processors or
+stateless codecs.
+
+In this use-case, the request API can be used to associate specific controls to
+be applied by the driver for the OUTPUT buffer, allowing user-space
+to queue many such buffers in advance. It can also take advantage of requests'
+ability to capture the state of controls when the request completes to read back
+information that may be subject to change.
+
+Put into code, after obtaining a request, user-space can assign controls and one
+OUTPUT buffer to it:
+
+.. code-block:: c
+
+	struct v4l2_buffer buf;
+	struct v4l2_ext_controls ctrls;
+	struct media_request_alloc alloc = { 0 };
+	int req_fd;
+	...
+	ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &alloc);
+	req_fd = alloc.fd;
+	...
+	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
+	ctrls.request_fd = req_fd;
+	ioctl(codec_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+	...
+	buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;
+	buf.request_fd = req_fd;
+	ioctl(codec_fd, VIDIOC_QBUF, &buf);
+
+Note that there is typically no need to use the Request API for CAPTURE buffers
+since there are no per-frame settings to report there.
+
+Once the request is fully prepared, it can be queued to the driver:
+
+.. code-block:: c
+
+	ioctl(req_fd, MEDIA_REQUEST_IOC_QUEUE);
+
+User-space can then either wait for the request to complete by calling poll() on
+its file descriptor, or start dequeuing CAPTURE buffers. Most likely, it will
+want to get CAPTURE buffers as soon as possible and this can be done using a
+regular DQBUF:
+
+.. code-block:: c
+
+	struct v4l2_buffer buf;
+
+	memset(&buf, 0, sizeof(buf));
+	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ioctl(codec_fd, VIDIOC_DQBUF, &buf);
+
+Note that this example assumes for simplicity that for every OUTPUT buffer
+there will be one CAPTURE buffer, but this does not have to be the case.
+
+We can then, after ensuring that the request is completed via polling the
+request FD, query control values at the time of its completion via an
+annotated call to G_EXT_CTRLS. This is particularly useful for volatile controls
+for which we want to query values as soon as the capture buffer is produced.
+
+.. code-block:: c
+
+	struct pollfd pfd = { .events = POLLPRI, .fd = request_fd };
+	poll(&pfd, 1, -1);
+	...
+	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
+	ctrls.request_fd = req_fd;
+	ioctl(codec_fd, VIDIOC_G_EXT_CTRLS, &ctrls);
+
+Once we don't need the request anymore, we can either recycle it for reuse with
+:ref:`MEDIA_REQUEST_IOC_REINIT`...
+
+.. code-block:: c
+
+	ioctl(req_fd, MEDIA_REQUEST_IOC_REINIT);
+
+... or close its file descriptor to completely dispose of it.
+
+.. code-block:: c
+
+	close(req_fd);
+
+Example for a Simple Capture Device
+-----------------------------------
+
+With a simple capture device, requests can be used to specify controls to apply
+for a given CAPTURE buffer.
+
+.. code-block:: c
+
+	struct v4l2_buffer buf;
+	struct v4l2_ext_controls ctrls;
+	struct media_request_alloc alloc = { 0 };
+	int req_fd;
+	...
+	ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &alloc);
+	req_fd = alloc.fd;
+	...
+	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
+	ctrls.request_fd = req_fd;
+	ioctl(camera_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+	...
+	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	buf.flags |= V4L2_BUF_FLAG_REQUEST_FD;
+	buf.request_fd = req_fd;
+	ioctl(camera_fd, VIDIOC_QBUF, &buf);
+
+Once the request is fully prepared, it can be queued to the driver:
+
+.. code-block:: c
+
+	ioctl(req_fd, MEDIA_REQUEST_IOC_QUEUE);
+
+User-space can then dequeue buffers, wait for the request completion, query
+controls and recycle the request as in the M2M example above.
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index e2c85ddc990b..8059fc0ed520 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -306,10 +306,12 @@ struct v4l2_buffer
       - A place holder for future extensions. Drivers and applications
 	must set this to 0.
     * - __u32
-      - ``reserved``
+      - ``request_fd``
       -
-      - A place holder for future extensions. Drivers and applications
-	must set this to 0.
+      - The file descriptor of the request to queue the buffer to. If specified
+        and flag ``V4L2_BUF_FLAG_REQUEST_FD`` is set, then the buffer will be
+	queued to that request. This is set by the user when calling
+	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
 
 
 
@@ -514,6 +516,11 @@ Buffer Flags
 	streaming may continue as normal and the buffer may be reused
 	normally. Drivers set this flag when the ``VIDIOC_DQBUF`` ioctl is
 	called.
+    * .. _`V4L2-BUF-FLAG-IN-REQUEST`:
+
+      - ``V4L2_BUF_FLAG_IN_REQUEST``
+      - 0x00000080
+      - This buffer is part of a request that hasn't been queued yet.
     * .. _`V4L2-BUF-FLAG-KEYFRAME`:
 
       - ``V4L2_BUF_FLAG_KEYFRAME``
@@ -589,6 +596,11 @@ Buffer Flags
 	the format. Any Any subsequent call to the
 	:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
 	but return an ``EPIPE`` error code.
+    * .. _`V4L2-BUF-FLAG-REQUEST-FD`:
+
+      - ``V4L2_BUF_FLAG_REQUEST_FD``
+      - 0x00800000
+      - The ``request_fd`` field contains a valid file descriptor.
     * .. _`V4L2-BUF-FLAG-TIMESTAMP-MASK`:
 
       - ``V4L2_BUF_FLAG_TIMESTAMP_MASK``
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 2011c2b2ee67..3d0e861ad4a1 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -95,6 +95,22 @@ appropriate. In the first case the new value is set in struct
 is inappropriate (e.g. the given menu index is not supported by the menu
 control), then this will also result in an ``EINVAL`` error code error.
 
+If ``request_fd`` is set to a not-yet-queued :ref:`request <media-request-api>`
+file descriptor and ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``,
+then the controls are not applied immediately when calling
+:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, but instead are applied by
+the driver for the buffer associated with the same request.
+
+An attempt to call :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` for a
+request that has already been queued will result in an ``EBUSY`` error.
+
+If ``request_fd`` is specified and ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``
+during a call to :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, then the
+returned values will be the values currently set for the request (or the
+hardware value if none is set) if the request has not yet completed, or the
+values of the controls at the time of request completion if it has already
+completed.
+
 The driver will only set/get these controls if all control values are
 correct. This prevents the situation where only some of the controls
 were set/get. Only low-level errors (e. g. a failed i2c command) can
@@ -209,8 +225,10 @@ still cause this situation.
       - ``which``
       - Which value of the control to get/set/try.
 	``V4L2_CTRL_WHICH_CUR_VAL`` will return the current value of the
-	control and ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
-	value of the control.
+	control, ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
+	value of the control and ``V4L2_CTRL_WHICH_REQUEST_VAL`` indicates that
+	these controls have to be retrieved from a request or tried/set for
+	a request.
 
 	.. note::
 
@@ -272,8 +290,12 @@ still cause this situation.
 	then you can call :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` to try to discover the
 	actual control that failed the validation step. Unfortunately,
 	there is no ``TRY`` equivalent for :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
+    * - __s32
+      - ``request_fd``
+	File descriptor of the request to be used by this operation. Only
+	valid if ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``.
     * - __u32
-      - ``reserved``\ [2]
+      - ``reserved``\ [1]
       - Reserved for future extensions.
 
 	Drivers and applications must set the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 9e448a4aa3aa..7ac99be1dd48 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -98,6 +98,17 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
 :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
 device is closed.
 
+The ``request_fd`` field can be used when queuing to specify the file
+descriptor of a :ref:`request <media-request-api>`, if requests are
+in use. Setting it means that the buffer will not be passed to the driver
+until the request itself is queued. Also, the driver will apply any
+settings associated with the request for this buffer. This field will
+be ignored unless the ``V4L2_BUF_FLAG_REQUEST_FD`` flag is set.
+
+For :ref:`memory-to-memory devices <codec>` you can specify the
+``request_fd`` only for output buffers, not for capture buffers. Attempting
+to specify this for a capture buffer will result in an ``EINVAL`` error.
+
 Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
 (capturing) or displayed (output) buffer from the driver's outgoing
 queue. They just set the ``type``, ``memory`` and ``reserved`` fields of
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index a5cb0a8686ac..5a5a1c772053 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -514,6 +514,7 @@ ignore define V4L2_CTRL_DRIVER_PRIV
 ignore define V4L2_CTRL_MAX_DIMS
 ignore define V4L2_CTRL_WHICH_CUR_VAL
 ignore define V4L2_CTRL_WHICH_DEF_VAL
+ignore define V4L2_CTRL_WHICH_REQUEST_VAL
 ignore define V4L2_OUT_CAP_CUSTOM_TIMINGS
 ignore define V4L2_CID_MAX_CTRLS
 
-- 
2.17.0
