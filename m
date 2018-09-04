Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:53917 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbeIDMWx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 08:22:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv4 01/10] media-request: return -EINVAL for invalid request_fds
Date: Tue,  4 Sep 2018 09:58:41 +0200
Message-Id: <20180904075850.2406-2-hverkuil@xs4all.nl>
In-Reply-To: <20180904075850.2406-1-hverkuil@xs4all.nl>
References: <20180904075850.2406-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Instead of returning -ENOENT when a request_fd was not found (VIDIOC_QBUF
and VIDIOC_G/S/TRY_EXT_CTRLS), we now return -EINVAL. This is in line
with what we do when invalid dmabuf fds are passed to e.g. VIDIOC_QBUF.

Also document that EINVAL is returned for invalid m.fd values, we never
documented that.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 Documentation/media/uapi/v4l/buffer.rst        |  4 ++--
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst      | 18 ++++++++----------
 Documentation/media/uapi/v4l/vidioc-qbuf.rst   | 12 +++++-------
 drivers/media/media-request.c                  |  6 ++++--
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index dd0065a95ea0..35c2fadd10de 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -313,8 +313,8 @@ struct v4l2_buffer
 	queued to that request. This is set by the user when calling
 	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
 	If the device does not support requests, then ``EPERM`` will be returned.
-	If requests are supported but an invalid request FD is given, then
-	``ENOENT`` will be returned.
+	If requests are supported but an invalid request file descriptor is
+	given, then ``EINVAL`` will be returned.
 
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 771fd1161277..9c56a9b6e98a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -101,8 +101,8 @@ then the controls are not applied immediately when calling
 :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, but instead are applied by
 the driver for the buffer associated with the same request.
 If the device does not support requests, then ``EPERM`` will be returned.
-If requests are supported but an invalid request FD is given, then
-``ENOENT`` will be returned.
+If requests are supported but an invalid request file descriptor is given,
+then ``EINVAL`` will be returned.
 
 An attempt to call :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` for a
 request that has already been queued will result in an ``EBUSY`` error.
@@ -301,8 +301,8 @@ still cause this situation.
       - File descriptor of the request to be used by this operation. Only
 	valid if ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``.
 	If the device does not support requests, then ``EPERM`` will be returned.
-	If requests are supported but an invalid request FD is given, then
-	``ENOENT`` will be returned.
+	If requests are supported but an invalid request file descriptor is
+	given, then ``EINVAL`` will be returned.
     * - __u32
       - ``reserved``\ [1]
       - Reserved for future extensions.
@@ -378,11 +378,13 @@ appropriately. The generic error codes are described at the
 
 EINVAL
     The struct :c:type:`v4l2_ext_control` ``id`` is
-    invalid, the struct :c:type:`v4l2_ext_controls`
+    invalid, or the struct :c:type:`v4l2_ext_controls`
     ``which`` is invalid, or the struct
     :c:type:`v4l2_ext_control` ``value`` was
     inappropriate (e.g. the given menu index is not supported by the
-    driver). This error code is also returned by the
+    driver), or the ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL``
+    but the given ``request_fd`` was invalid.
+    This error code is also returned by the
     :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctls if two or
     more control values are in conflict.
 
@@ -409,7 +411,3 @@ EACCES
 EPERM
     The ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL`` but the
     device does not support requests.
-
-ENOENT
-    The ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL`` but the
-    the given ``request_fd`` was invalid.
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 0e415f2551b2..7bff69c15452 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -105,8 +105,8 @@ until the request itself is queued. Also, the driver will apply any
 settings associated with the request for this buffer. This field will
 be ignored unless the ``V4L2_BUF_FLAG_REQUEST_FD`` flag is set.
 If the device does not support requests, then ``EPERM`` will be returned.
-If requests are supported but an invalid request FD is given, then
-``ENOENT`` will be returned.
+If requests are supported but an invalid request file descriptor is given,
+then ``EINVAL`` will be returned.
 
 .. caution::
    It is not allowed to mix queuing requests with queuing buffers directly.
@@ -152,7 +152,9 @@ EAGAIN
 EINVAL
     The buffer ``type`` is not supported, or the ``index`` is out of
     bounds, or no buffers have been allocated yet, or the ``userptr`` or
-    ``length`` are invalid.
+    ``length`` are invalid, or the ``V4L2_BUF_FLAG_REQUEST_FD`` flag was
+    set but the the given ``request_fd`` was invalid, or ``m.fd`` was
+    an invalid DMABUF file descriptor.
 
 EIO
     ``VIDIOC_DQBUF`` failed due to an internal error. Can also indicate
@@ -179,7 +181,3 @@ EPERM
     the application now tries to queue it directly, or vice versa (it is
     not permitted to mix the two APIs). Or an attempt is made to queue a
     CAPTURE buffer to a request for a :ref:`memory-to-memory device <codec>`.
-
-ENOENT
-    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the the given
-    ``request_fd`` was invalid.
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 4b0ce8fde7c9..4cee67e6657e 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -244,7 +244,7 @@ media_request_get_by_fd(struct media_device *mdev, int request_fd)
 
 	filp = fget(request_fd);
 	if (!filp)
-		return ERR_PTR(-ENOENT);
+		goto err_no_req_fd;
 
 	if (filp->f_op != &request_fops)
 		goto err_fput;
@@ -268,7 +268,9 @@ media_request_get_by_fd(struct media_device *mdev, int request_fd)
 err_fput:
 	fput(filp);
 
-	return ERR_PTR(-ENOENT);
+err_no_req_fd:
+	dev_dbg(mdev->dev, "cannot find request_fd %d\n", request_fd);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(media_request_get_by_fd);
 
-- 
2.18.0
