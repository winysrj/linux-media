Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:37827 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbeIDMW4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 08:22:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 09/10] media-request: EPERM -> EACCES/EBUSY
Date: Tue,  4 Sep 2018 09:58:49 +0200
Message-Id: <20180904075850.2406-10-hverkuil@xs4all.nl>
In-Reply-To: <20180904075850.2406-1-hverkuil@xs4all.nl>
References: <20180904075850.2406-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If requests are not supported by the driver, then return EACCES, not
EPERM.

If you attempt to mix queueing buffers directly and using requests,
then EBUSY is returned instead of EPERM: once a specific queueing mode
has been chosen the queue is 'busy' if you attempt the other mode
(i.e. direct queueing vs via a request).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../uapi/mediactl/media-request-ioc-queue.rst  |  9 ++++-----
 .../media/uapi/mediactl/request-api.rst        |  4 ++--
 Documentation/media/uapi/v4l/buffer.rst        |  2 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst      |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-qbuf.rst   | 18 ++++++++++--------
 .../media/common/videobuf2/videobuf2-core.c    |  2 +-
 .../media/common/videobuf2/videobuf2-v4l2.c    |  9 ++++++---
 drivers/media/media-request.c                  |  4 ++--
 include/media/media-request.h                  |  6 +++---
 9 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
index d4f8119e0643..dbf635ae9b2b 100644
--- a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
@@ -49,7 +49,7 @@ exception is the ``EIO`` error which signals a fatal error that requires
 the application to stop streaming to reset the hardware state.
 
 It is not allowed to mix queuing requests with queuing buffers directly
-(without a request). ``EPERM`` will be returned if the first buffer was
+(without a request). ``EBUSY`` will be returned if the first buffer was
 queued directly and you next try to queue a request, or vice versa.
 
 A request must contain at least one buffer, otherwise this ioctl will
@@ -63,10 +63,9 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EBUSY
-    The request was already queued.
-EPERM
-    The application queued the first buffer directly, but later attempted
-    to use a request. It is not permitted to mix the two APIs.
+    The request was already queued or the application queued the first
+    buffer directly, but later attempted to use a request. It is not permitted
+    to mix the two APIs.
 ENOENT
     The request did not contain any buffers. All requests are required
     to have at least one buffer. This can also be returned if required
diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
index 0b9da58b01e3..aeb8d00934a4 100644
--- a/Documentation/media/uapi/mediactl/request-api.rst
+++ b/Documentation/media/uapi/mediactl/request-api.rst
@@ -64,7 +64,7 @@ request cannot be modified anymore.
 .. caution::
    For :ref:`memory-to-memory devices <codec>` you can use requests only for
    output buffers, not for capture buffers. Attempting to add a capture buffer
-   to a request will result in an ``EPERM`` error.
+   to a request will result in an ``EACCES`` error.
 
 If the request contains parameters for multiple entities, individual drivers may
 synchronize so the requested pipeline's topology is applied before the buffers
@@ -77,7 +77,7 @@ perfect atomicity may not be possible due to hardware limitations.
    whichever method is used first locks this in place until
    :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called or the device is
    :ref:`closed <func-close>`. Attempts to directly queue a buffer when earlier
-   a buffer was queued via a request or vice versa will result in an ``EPERM``
+   a buffer was queued via a request or vice versa will result in an ``EBUSY``
    error.
 
 Controls can still be set without a request and are applied immediately,
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 1865cd5b9d3c..58a6d7d336e6 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -314,7 +314,7 @@ struct v4l2_buffer
 	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
 	Applications should not set ``V4L2_BUF_FLAG_REQUEST_FD`` for any ioctls
 	other than :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`.
-	If the device does not support requests, then ``EPERM`` will be returned.
+	If the device does not support requests, then ``EACCES`` will be returned.
 	If requests are supported but an invalid request file descriptor is
 	given, then ``EINVAL`` will be returned.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index ad8908ce3095..54a999df5aec 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -100,7 +100,7 @@ file descriptor and ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``,
 then the controls are not applied immediately when calling
 :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, but instead are applied by
 the driver for the buffer associated with the same request.
-If the device does not support requests, then ``EPERM`` will be returned.
+If the device does not support requests, then ``EACCES`` will be returned.
 If requests are supported but an invalid request file descriptor is given,
 then ``EINVAL`` will be returned.
 
@@ -233,7 +233,7 @@ still cause this situation.
 	these controls have to be retrieved from a request or tried/set for
 	a request. In the latter case the ``request_fd`` field contains the
 	file descriptor of the request that should be used. If the device
-	does not support requests, then ``EPERM`` will be returned.
+	does not support requests, then ``EACCES`` will be returned.
 
 	.. note::
 
@@ -299,7 +299,7 @@ still cause this situation.
       - ``request_fd``
       - File descriptor of the request to be used by this operation. Only
 	valid if ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``.
-	If the device does not support requests, then ``EPERM`` will be returned.
+	If the device does not support requests, then ``EACCES`` will be returned.
 	If requests are supported but an invalid request file descriptor is
 	given, then ``EINVAL`` will be returned.
     * - __u32
@@ -408,6 +408,5 @@ EACCES
     control, or to get a control from a request that has not yet been
     completed.
 
-EPERM
-    The ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL`` but the
+    Or the ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL`` but the
     device does not support requests.
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 7bff69c15452..e619fc80a323 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -104,18 +104,18 @@ in use. Setting it means that the buffer will not be passed to the driver
 until the request itself is queued. Also, the driver will apply any
 settings associated with the request for this buffer. This field will
 be ignored unless the ``V4L2_BUF_FLAG_REQUEST_FD`` flag is set.
-If the device does not support requests, then ``EPERM`` will be returned.
+If the device does not support requests, then ``EACCES`` will be returned.
 If requests are supported but an invalid request file descriptor is given,
 then ``EINVAL`` will be returned.
 
 .. caution::
    It is not allowed to mix queuing requests with queuing buffers directly.
-   ``EPERM`` will be returned if the first buffer was queued directly and
+   ``EBUSY`` will be returned if the first buffer was queued directly and
    then the application tries to queue a request, or vice versa.
 
    For :ref:`memory-to-memory devices <codec>` you can specify the
    ``request_fd`` only for output buffers, not for capture buffers. Attempting
-   to specify this for a capture buffer will result in an ``EPERM`` error.
+   to specify this for a capture buffer will result in an ``EACCES`` error.
 
 Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
 (capturing) or displayed (output) buffer from the driver's outgoing
@@ -175,9 +175,11 @@ EPIPE
     codecs if a buffer with the ``V4L2_BUF_FLAG_LAST`` was already
     dequeued and no new buffers are expected to become available.
 
-EPERM
+EACCES
     The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
-    support requests. Or the first buffer was queued via a request, but
-    the application now tries to queue it directly, or vice versa (it is
-    not permitted to mix the two APIs). Or an attempt is made to queue a
-    CAPTURE buffer to a request for a :ref:`memory-to-memory device <codec>`.
+    support requests for the given buffer type.
+
+EBUSY
+    The first buffer was queued via a request, but the application now tries
+    to queue it directly, or vice versa (it is not permitted to mix the two
+    APIs).
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 2dc3fc935f87..cb86b02afd4a 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1495,7 +1495,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 	    (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
 	     q->uses_requests)) {
 		dprintk(1, "queue in wrong mode (qbuf vs requests)\n");
-		return -EPERM;
+		return -EBUSY;
 	}
 
 	if (req) {
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 2caaabd50532..6831a2eb1859 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -381,12 +381,15 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD)) {
 		if (q->uses_requests) {
 			dprintk(1, "%s: queue uses requests\n", opname);
-			return -EPERM;
+			return -EBUSY;
 		}
 		return 0;
-	} else if (q->uses_qbuf || !q->supports_requests) {
+	} else if (!q->supports_requests) {
+		dprintk(1, "%s: queue does not support requests\n", opname);
+		return -EACCES;
+	} else if (q->uses_qbuf) {
 		dprintk(1, "%s: queue does not use requests\n", opname);
-		return -EPERM;
+		return -EBUSY;
 	}
 
 	/*
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 414197645e09..4e9db1fed697 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -249,7 +249,7 @@ media_request_get_by_fd(struct media_device *mdev, int request_fd)
 
 	if (!mdev || !mdev->ops ||
 	    !mdev->ops->req_validate || !mdev->ops->req_queue)
-		return ERR_PTR(-EPERM);
+		return ERR_PTR(-EACCES);
 
 	filp = fget(request_fd);
 	if (!filp)
@@ -405,7 +405,7 @@ int media_request_object_bind(struct media_request *req,
 	int ret = -EBUSY;
 
 	if (WARN_ON(!ops->release))
-		return -EPERM;
+		return -EACCES;
 
 	spin_lock_irqsave(&req->lock, flags);
 
diff --git a/include/media/media-request.h b/include/media/media-request.h
index d8c8db89dbde..0ce75c35131f 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -198,8 +198,8 @@ void media_request_put(struct media_request *req);
  * Get the request represented by @request_fd that is owned
  * by the media device.
  *
- * Return a -EPERM error pointer if requests are not supported
- * by this driver. Return -ENOENT if the request was not found.
+ * Return a -EACCES error pointer if requests are not supported
+ * by this driver. Return -EINVAL if the request was not found.
  * Return the pointer to the request if found: the caller will
  * have to call @media_request_put when it finished using the
  * request.
@@ -231,7 +231,7 @@ static inline void media_request_put(struct media_request *req)
 static inline struct media_request *
 media_request_get_by_fd(struct media_device *mdev, int request_fd)
 {
-	return ERR_PTR(-EPERM);
+	return ERR_PTR(-EACCES);
 }
 
 #endif
-- 
2.18.0
