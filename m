Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51257 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbeHXLze (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:55:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 2/5] v4l2-ctrls: return -EACCES if request wasn't completed
Date: Fri, 24 Aug 2018 10:21:53 +0200
Message-Id: <20180824082156.6986-3-hverkuil@xs4all.nl>
In-Reply-To: <20180824082156.6986-1-hverkuil@xs4all.nl>
References: <20180824082156.6986-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

For now (this might be relaxed in the future) we do not allow getting
controls from a request that isn't completed. In that case we return
-EACCES. Update the documentation accordingly.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst      | 18 +++++++++---------
 drivers/media/v4l2-core/v4l2-ctrls.c           |  5 ++---
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 9c56a9b6e98a..ad8908ce3095 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -107,13 +107,12 @@ then ``EINVAL`` will be returned.
 An attempt to call :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` for a
 request that has already been queued will result in an ``EBUSY`` error.
 
-If ``request_fd`` is specified and ``which`` is set to ``V4L2_CTRL_WHICH_REQUEST_VAL``
-during a call to :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, then the
-returned values will be the values currently set for the request (or the
-hardware value if none is set) if the request has not yet been queued, or the
-values of the controls at the time of request completion if it has already
-completed. Attempting to get controls while the request has been queued but
-not yet completed will result in an ``EBUSY`` error.
+If ``request_fd`` is specified and ``which`` is set to
+``V4L2_CTRL_WHICH_REQUEST_VAL`` during a call to
+:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, then it will return the
+values of the controls at the time of request completion.
+If the request is not yet completed, then this will result in an
+``EACCES`` error.
 
 The driver will only set/get these controls if all control values are
 correct. This prevents the situation where only some of the controls
@@ -405,8 +404,9 @@ ENOSPC
     and this error code is returned.
 
 EACCES
-    Attempt to try or set a read-only control or to get a write-only
-    control.
+    Attempt to try or set a read-only control, or to get a write-only
+    control, or to get a control from a request that has not yet been
+    completed.
 
 EPERM
     The ``which`` field was set to ``V4L2_CTRL_WHICH_REQUEST_VAL`` but the
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index a197b60183f5..ccaf3068de6d 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3301,10 +3301,9 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
 		if (IS_ERR(req))
 			return PTR_ERR(req);
 
-		if (req->state != MEDIA_REQUEST_STATE_IDLE &&
-		    req->state != MEDIA_REQUEST_STATE_COMPLETE) {
+		if (req->state != MEDIA_REQUEST_STATE_COMPLETE) {
 			media_request_put(req);
-			return -EBUSY;
+			return -EACCES;
 		}
 
 		obj = v4l2_ctrls_find_req_obj(hdl, req, false);
-- 
2.18.0
