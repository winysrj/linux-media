Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954B1C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E4652184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfCTOXL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:23:11 -0400
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40057 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbfCTOXL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:23:11 -0400
Received: from [IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e] ([IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 6c7Xhdh3SeXb86c7YhCpWG; Wed, 20 Mar 2019 15:23:08 +0100
Subject: [PATCH v5.1 3/2] media requests: return EBADR instead of EACCES
To:     linux-media@vger.kernel.org
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
References: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
 <20190320123305.5224-3-hverkuil-cisco@xs4all.nl>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <b5a3175c-ae01-0251-9b57-f24b2bbb3355@xs4all.nl>
Date:   Wed, 20 Mar 2019 15:23:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190320123305.5224-3-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDt/TvNy3vSWap8pqLC4FMDr/b+u7oLc6/PHsc6WT8ivKePPdyeCWfr65UMsi/YHiRX/zDYvEk4haR+sqcxBMkBmXSlXJfAlT41jMna4ZWpgoIbIYnHY
 IZAnO/YFUKi/8IrnGEluR+Kpb39vmpwczfgBn2N8DC4b9IhEKEPMNEAeMokkT2OLWwHGHnL3G8QeXlssxr0T6zsWup8Q7FkYusPAU32ZnwCNlbpU653w57bU
 TaWoXWsPvyGPO7TFH0rkfstF6ntgp70mtmf1suioX2C06BZUPwWYkjQ3rGjl+Fp8Yfg9qj2MdP6Na/UTsbQ72QS+vABttxX3DtMcMUZT/EI=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If requests are used when they shouldn't, or not used when they should, then
return EBADR (Invalid request descriptor) instead of EACCES.

The reason for this change is that EACCES has more to do with permissions
(not being the owner of the resource), but in this case the request file
descriptor is just wrong for the current mode of the device.

Update the documentation accordingly.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
index 1ad631e549fe..a74c82d95609 100644
--- a/Documentation/media/uapi/mediactl/request-api.rst
+++ b/Documentation/media/uapi/mediactl/request-api.rst
@@ -93,7 +93,7 @@ A queued request cannot be modified anymore.
 .. caution::
    For :ref:`memory-to-memory devices <mem2mem>` you can use requests only for
    output buffers, not for capture buffers. Attempting to add a capture buffer
-   to a request will result in an ``EACCES`` error.
+   to a request will result in an ``EBADR`` error.

 If the request contains configurations for multiple entities, individual drivers
 may synchronize so the requested pipeline's topology is applied before the
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 81ffdcb89057..b9a2e9dc707c 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -326,7 +326,7 @@ struct v4l2_buffer
 	Applications should not set ``V4L2_BUF_FLAG_REQUEST_FD`` for any ioctls
 	other than :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`.

-	If the device does not support requests, then ``EACCES`` will be returned.
+	If the device does not support requests, then ``EBADR`` will be returned.
 	If requests are supported but an invalid request file descriptor is
 	given, then ``EINVAL`` will be returned.

diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 5739c3676062..dbf7b445a27b 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -111,7 +111,7 @@ in use. Setting it means that the buffer will not be passed to the driver
 until the request itself is queued. Also, the driver will apply any
 settings associated with the request for this buffer. This field will
 be ignored unless the ``V4L2_BUF_FLAG_REQUEST_FD`` flag is set.
-If the device does not support requests, then ``EACCES`` will be returned.
+If the device does not support requests, then ``EBADR`` will be returned.
 If requests are supported but an invalid request file descriptor is given,
 then ``EINVAL`` will be returned.

@@ -125,7 +125,7 @@ then ``EINVAL`` will be returned.

    For :ref:`memory-to-memory devices <mem2mem>` you can specify the
    ``request_fd`` only for output buffers, not for capture buffers. Attempting
-   to specify this for a capture buffer will result in an ``EACCES`` error.
+   to specify this for a capture buffer will result in an ``EBADR`` error.

 Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
 (capturing) or displayed (output) buffer from the driver's outgoing
@@ -185,12 +185,10 @@ EPIPE
     codecs if a buffer with the ``V4L2_BUF_FLAG_LAST`` was already
     dequeued and no new buffers are expected to become available.

-EACCES
-    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
-    support requests for the given buffer type.
-
 EBADR
-    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was not set but the device requires
+    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
+    support requests for the given buffer type, or
+    the ``V4L2_BUF_FLAG_REQUEST_FD`` flag was not set but the device requires
     that the buffer is part of a request.

 EBUSY
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 84de18b30a95..b11a779e97b0 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -392,7 +392,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 		return 0;
 	} else if (!q->supports_requests) {
 		dprintk(1, "%s: queue does not support requests\n", opname);
-		return -EACCES;
+		return -EBADR;
 	} else if (q->uses_qbuf) {
 		dprintk(1, "%s: queue does not use requests\n", opname);
 		return -EBUSY;
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index eec2e2b2f6ec..ed87305b29f9 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -251,7 +251,7 @@ media_request_get_by_fd(struct media_device *mdev, int request_fd)

 	if (!mdev || !mdev->ops ||
 	    !mdev->ops->req_validate || !mdev->ops->req_queue)
-		return ERR_PTR(-EACCES);
+		return ERR_PTR(-EBADR);

 	filp = fget(request_fd);
 	if (!filp)
@@ -407,7 +407,7 @@ int media_request_object_bind(struct media_request *req,
 	int ret = -EBUSY;

 	if (WARN_ON(!ops->release))
-		return -EACCES;
+		return -EBADR;

 	spin_lock_irqsave(&req->lock, flags);

diff --git a/include/media/media-request.h b/include/media/media-request.h
index bd36d7431698..3cd25a2717ce 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -198,7 +198,7 @@ void media_request_put(struct media_request *req);
  * Get the request represented by @request_fd that is owned
  * by the media device.
  *
- * Return a -EACCES error pointer if requests are not supported
+ * Return a -EBADR error pointer if requests are not supported
  * by this driver. Return -EINVAL if the request was not found.
  * Return the pointer to the request if found: the caller will
  * have to call @media_request_put when it finished using the
@@ -231,7 +231,7 @@ static inline void media_request_put(struct media_request *req)
 static inline struct media_request *
 media_request_get_by_fd(struct media_device *mdev, int request_fd)
 {
-	return ERR_PTR(-EACCES);
+	return ERR_PTR(-EBADR);
 }

 #endif
