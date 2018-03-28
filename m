Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:37339 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753355AbeC1OBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 10:01:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH 24/29] Documentation: v4l: document request API
Date: Wed, 28 Mar 2018 16:01:35 +0200
Message-Id: <20180328140140.42096-8-hverkuil@xs4all.nl>
In-Reply-To: <20180328140140.42096-1-hverkuil@xs4all.nl>
References: <20180328140140.42096-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexandre Courbot <acourbot@chromium.org>

Document the request API for V4L2 devices, and amend the documentation
of system calls influenced by it.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 Documentation/media/uapi/v4l/buffer.rst            |  19 +-
 Documentation/media/uapi/v4l/common.rst            |   1 +
 Documentation/media/uapi/v4l/request-api.rst       | 199 +++++++++++++++++++++
 Documentation/media/uapi/v4l/user-func.rst         |   1 +
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  22 ++-
 .../media/uapi/v4l/vidioc-new-request.rst          |  64 +++++++
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |   8 +
 7 files changed, 308 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/request-api.rst
 create mode 100644 Documentation/media/uapi/v4l/vidioc-new-request.rst

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index e2c85ddc990b..e23eae12905c 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -306,10 +306,13 @@ struct v4l2_buffer
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
+	:ref:`VIDIOC_QBUF` and :ref:`VIDIOC_PREPARE_BUF` and ignored by other
+	ioctls.
 
 
 
@@ -514,6 +517,11 @@ Buffer Flags
 	streaming may continue as normal and the buffer may be reused
 	normally. Drivers set this flag when the ``VIDIOC_DQBUF`` ioctl is
 	called.
+    * .. _`V4L2-BUF-FLAG-IN-REQUEST`:
+
+      - ``V4L2_BUF_FLAG_IN_REQUEST``
+      - 0x00000080
+      - This buffer is part of a request the hasn't been queued yet.
     * .. _`V4L2-BUF-FLAG-KEYFRAME`:
 
       - ``V4L2_BUF_FLAG_KEYFRAME``
@@ -589,6 +597,11 @@ Buffer Flags
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
diff --git a/Documentation/media/uapi/v4l/common.rst b/Documentation/media/uapi/v4l/common.rst
index 13f2ed3fc5a6..a4aa0059d45a 100644
--- a/Documentation/media/uapi/v4l/common.rst
+++ b/Documentation/media/uapi/v4l/common.rst
@@ -44,3 +44,4 @@ applicable to all devices.
     crop
     selection-api
     streaming-par
+    request-api
diff --git a/Documentation/media/uapi/v4l/request-api.rst b/Documentation/media/uapi/v4l/request-api.rst
new file mode 100644
index 000000000000..0c1f2896e197
--- /dev/null
+++ b/Documentation/media/uapi/v4l/request-api.rst
@@ -0,0 +1,199 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _media-request-api:
+
+Request API
+===========
+
+The Request API has been designed to allow V4L2 to deal with requirements of
+modern devices (stateless codecs, MIPI cameras, ...) and APIs (Android Codec
+v2). One such requirement is the ability for devices belonging to the same
+pipeline to reconfigure and collaborate closely on a per-frame basis. Another is
+efficient support of stateless codecs, which need per-frame controls to be set
+asynchronously in order to be efficiently used.
+
+Supporting these features without the Request API is possible but terribly
+inefficient: user-space would have to flush all activity on the media pipeline,
+reconfigure it for the next frame, queue the buffers to be processed with that
+configuration, and wait until they are all available for dequeing before
+considering the next frame. This defeats the purpose of having buffer queues
+since in practice only one buffer would be queued at a time.
+
+The Request API allows a specific configuration of the pipeline (media
+controller topology + controls for each device) to be associated with specific
+buffers. The parameters are applied by each participating device as buffers
+associated to a request flow in. This allows user-space to schedule several
+tasks ("requests") with different parameters in advance, knowing that the
+parameters will be applied when needed to get the expected result. Controls
+values at the time of request completion are also available for reading.
+
+Usage
+=====
+
+The Request API is used on top of standard media controller and V4L2 calls,
+which are augmented with an extra ``request_fd`` parameter. Request themselves
+are allocated from either a supporting V4L2 device node, or a supporting media
+controller node. The origin of requests determine their scope: requests
+allocated from a V4L2 device node can only act on that device, whereas requests
+allocated from a media controller node can control the whole pipeline of the
+controller.
+
+Request Allocation
+------------------
+
+User-space allocates requests using the ``VIDIOC_NEW_REQUEST`` (for V4L2 device
+requests) or ``MEDIA_IOC_NEW_REQUEST`` (for media controller requests) on an
+opened device or media node. This returns a file descriptor representing the
+request. Typically, several such requests will be allocated.
+
+Request Preparation
+-------------------
+
+Standard V4L2 ioctls can then receive a request file descriptor to express the
+fact that the ioctl is part of said request, and is not to be applied
+immediately. V4L2 ioctls supporting this are :c:func:`VIDIOC_S_EXT_CTRLS` and
+:c:func:`VIDIOC_QBUF`. Controls set with a request parameter are stored instead
+of being immediately applied, and queued buffers not enter the regular buffer
+queue until the request is submitted. Only one buffer can be queued to a given
+queue for a given request.
+
+Request Submission
+------------------
+
+Once the parameters and buffers of the request are specified, it can be
+submitted by calling the ``MEDIA_REQUEST_IOC_SUBMIT`` ioctl on the request FD.
+This will make the buffers associated to the request available to their driver,
+which can then apply the saved controls as buffers are processed. A submitted
+request cannot be modified anymore.
+
+If several devices are part of the request, individual drivers may synchronize
+so the requested pipeline's topology is applied before the buffers are
+processed. This is at the discretion of media controller drivers and is not a
+requirement.
+
+Buffers queued without an associated request after a request-bound buffer will
+be processed using the state of the hardware at the time of the request
+completion. All the same, controls set without a request are applied
+immediately, regardless of whether a request is in use or not.
+
+User-space can ``poll()`` a request FD in order to wait until the request
+completes. A request is considered complete once all its associated buffers are
+available for dequeing. Note that user-space does not need to wait for the
+request to complete to dequeue its buffers: buffers that are available halfway
+through a request can be dequeued independently of the request's state.
+
+A completed request includes the state of all devices that had queued buffers
+associated with it at the time of the request completion. User-space can query
+that state by calling :c:func:`VIDIOC_G_EXT_CTRLS` with the request FD.
+
+Recycling and Destruction
+-------------------------
+
+Finally, completed request can either be discarded or be reused. Calling
+``close()`` on a request FD will make that FD unusable, freeing the request if
+it is not referenced elsewhere. The ``MEDIA_REQUEST_IOC_SUBMIT`` ioctl will
+clear a request's state and make it available again. No state is retained by
+this operation: the request is as if it had just been allocated.
+
+Example for a M2M Device
+------------------------
+
+M2M devices are single-node V4L2 devices providing one OUTPUT queue (for
+user-space
+to provide input buffers) and one CAPTURE queue (to retrieve processed data).
+They are perfectly symetric, i.e. one buffer of input will produce one buffer of
+output. These devices are commonly used for frame processors or stateless
+codecs.
+
+In this use-case, the request API can be used to associate specific controls to
+be applied by the driver before processing an OUTPUT buffer, allowing user-space
+to queue many such buffers in advance. It can also take advantage of requests'
+ability to capture the state of controls when the request completes to read back
+information that may be subject to change.
+
+Put into code, after obtaining a request, user-space can assign controls and one
+OUTPUT buffer to it:
+
+	struct v4l2_buf buf;
+	struct v4l2_ext_controls ctrls;
+	struct media_request_new new = { 0 };
+	int req_fd;
+	...
+	ioctl(media_fd, VIDIOC_NEW_REQUEST, &new);
+	req_fd = new.fd;
+	...
+	ctrls.request_fd = req_fd;
+	ioctl(codec_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+	...
+	buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	buf.request_fd = req_fd;
+	ioctl(codec_fd, VIDIOC_QBUF, &buf);
+
+Note that request_fd does not need to be specified for CAPTURE buffers: since
+there is symetry between the OUTPUT and CAPTURE queues, and requests are
+processed in order of submission, we can know which CAPTURE buffer corresponds
+to which request.
+
+Once the request is fully prepared, it can be submitted to the driver:
+
+	ioctl(request_fd, MEDIA_REQUEST_IOC_SUBMIT, NULL);
+
+User-space can then either wait for the request to complete by calling poll() on
+its file descriptor, or start dequeuing CAPTURE buffers. Most likely, it will
+want to get CAPTURE buffers as soon as possible and this can be done using a
+regular DQBUF:
+
+	struct v4l2_buf buf;
+
+	memset(&buf, 0, sizeof(buf));
+	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ioctl(codec_fd, VIDIOC_DQBUF, &buf);
+
+We can then, after ensuring that the request is completed via polling the
+request FD, query control values at the time of its completion via an
+annotated call to G_EXT_CTRLS. This is particularly useful for volatile controls
+for which we want to query values as soon as the capture buffer is produced.
+
+	struct pollfd pfd = { .events = POLLIN, .fd = request_fd };
+	poll(&pfd, 1, -1);
+	...
+	ctrls.request_fd = req_fd;
+	ioctl(codec_fd, VIDIOC_G_EXT_CTRLS, &ctrls);
+
+Once we don't need the request anymore, we can either recycle it for reuse with
+MEDIA_REQUEST_IOC_REINIT...
+
+	ioctl(request, MEDIA_REQUEST_IOC_REINIT, NULL);
+
+... or close its file descriptor to completely dispose of it.
+
+	close(request_fd);
+
+Example for a Simple Capture Device
+-----------------------------------
+
+With a simple capture device, requests can be used to specify controls to apply
+to a given CAPTURE buffer. The driver will apply these controls before producing
+the marked CAPTURE buffer.
+
+	struct v4l2_buf buf;
+	struct v4l2_ext_controls ctrls;
+	struct media_request_new new = { 0 };
+	int req_fd;
+	...
+	ioctl(camera_fd, VIDIOC_NEW_REQUEST, &new);
+	req_fd = new.fd;
+	...
+	ctrls.request_fd = req_fd;
+	ioctl(camera_fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+	...
+	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	buf.request_fd = req_fd;
+	ioctl(camera_fd, VIDIOC_QBUF, &buf);
+
+Once the request is fully prepared, it can be submitted to the driver:
+
+	ioctl(req_fd, MEDIA_REQUEST_IOC_SUBMIT, &cmd);
+
+User-space can then dequeue buffers, wait for the request completion, query
+controls and recycle the request as in the M2M example above.
diff --git a/Documentation/media/uapi/v4l/user-func.rst b/Documentation/media/uapi/v4l/user-func.rst
index 3e0413b83a33..2c8238a2b188 100644
--- a/Documentation/media/uapi/v4l/user-func.rst
+++ b/Documentation/media/uapi/v4l/user-func.rst
@@ -53,6 +53,7 @@ Function Reference
     vidioc-g-std
     vidioc-g-tuner
     vidioc-log-status
+    vidioc-new-request
     vidioc-overlay
     vidioc-prepare-buf
     vidioc-qbuf
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 2011c2b2ee67..b756884bd88b 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -95,6 +95,17 @@ appropriate. In the first case the new value is set in struct
 is inappropriate (e.g. the given menu index is not supported by the menu
 control), then this will also result in an ``EINVAL`` error code error.
 
+If ``request_fd`` is set to a not-submitted request file descriptor, then the
+controls are not applied immediately when calling
+:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_S_EXT_CTRLS>`, but instead are applied right
+before the driver starts processing a buffer associated to the same request.
+
+If ``request_fd`` is specified during a call to
+:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, then the returned values will
+be the values currently set for the request (or the hardware value if none is
+set) if the request has not yet completed, or the values of the controls at the
+time of request completion if it has already completed.
+
 The driver will only set/get these controls if all control values are
 correct. This prevents the situation where only some of the controls
 were set/get. Only low-level errors (e. g. a failed i2c command) can
@@ -209,8 +220,10 @@ still cause this situation.
       - ``which``
       - Which value of the control to get/set/try.
 	``V4L2_CTRL_WHICH_CUR_VAL`` will return the current value of the
-	control and ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
-	value of the control.
+	control, ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
+	value of the control and ``V4L2_CTRL_WHICH_REQUEST`` indicates that
+	these controls have to be retrieved from a request or tried/set for
+	a request.
 
 	.. note::
 
@@ -272,8 +285,11 @@ still cause this situation.
 	then you can call :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` to try to discover the
 	actual control that failed the validation step. Unfortunately,
 	there is no ``TRY`` equivalent for :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
+    * - __s32
+      - ``request_fd``
+	File descriptor of the request to be used by this operation (0 if none).
     * - __u32
-      - ``reserved``\ [2]
+      - ``reserved``\ [1]
       - Reserved for future extensions.
 
 	Drivers and applications must set the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-new-request.rst b/Documentation/media/uapi/v4l/vidioc-new-request.rst
new file mode 100644
index 000000000000..0038287f7d16
--- /dev/null
+++ b/Documentation/media/uapi/v4l/vidioc-new-request.rst
@@ -0,0 +1,64 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDIOC_NEW_REQUEST:
+
+************************
+ioctl VIDIOC_NEW_REQUEST
+************************
+
+Name
+====
+
+VIDIOC_NEW_REQUEST - Allocate a request for given video device.
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, VIDIOC_NEW_REQUEST, struct media_request_new *argp )
+    :name: VIDIOC_NEW_REQUEST
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <func-open>`.
+
+``argp``
+    Pointer to struct :c:type:`media_request_new`.
+
+
+Description
+===========
+
+Applications call the ``VIDIOC_NEW_REQUEST`` ioctl to allocate a new request for a given V4L2 video device. The request will only be valid in the scope of the device that allocated it and cannot be used to coordinate multiple devices.
+
+Applications can also check whether requests are supported by a given device by calling this ioctl with the MEDIA_REQUEST_FLAG_TEST bit of :c:type:`media_request_new`'s ``flags`` set. Doing so will not allocate a new request, but will return 0 is request allocation is supported by the device, or -1 and set ``errno`` to ENOTTY if they are not.
+
+.. c:type:: media_request_new
+
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
+.. flat-table:: struct media_request_new
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``flags``
+      - Flags for this request creation. If ``MEDIA_REQUEST_FLAG_TEST`` is set, then no request is created and the call only checks for request availability. Written by the application.
+    * - __s32
+      - ``fd``
+      - File descriptor referencing the created request. Written by the kernel.
+
+Return Value
+============
+
+On success 0 is returned, and the ``fd`` field of ``argp`` is set to a file descriptor referencing the request. User-space can use this file descriptor to mention the request in other system calls, perform ``MEDIA_REQUEST_IOC_SUBMIT`` and ``MEDIA_REQUEST_IOC_REINIT`` ioctls on it, and close it to discard the request.
+
+On error -1 is returned and the ``errno`` variable is set appropriately.  The
+generic error codes are described in the :ref:`Generic Error Codes <gen-errors>`
+chapter.
+
+ENOTTY
+    The device does not support the use of requests or request support is not built into the kernel.
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 9e448a4aa3aa..6246f1888583 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -98,6 +98,14 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
 :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
 device is closed.
 
+The ``request_fd`` field can be used when queuing to specify the file
+descriptor of a request, if requests are in use. Setting it means that the
+buffer will not be passed to the driver until the request itself is submitted.
+Also, the driver will apply any setting associated with the request before
+processing the buffer. Only one buffer per queue can be assigned that way to
+a request. This field will be ignored unless the ``V4L2_BUF_FLAG_REQUEST_FD``
+flag is set.
+
 Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
 (capturing) or displayed (output) buffer from the driver's outgoing
 queue. They just set the ``type``, ``memory`` and ``reserved`` fields of
-- 
2.15.1
