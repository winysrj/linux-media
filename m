Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:57048 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726319AbeIDMWx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 08:22:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv4 03/10] buffer.rst: only set V4L2_BUF_FLAG_REQUEST_FD for QBUF
Date: Tue,  4 Sep 2018 09:58:43 +0200
Message-Id: <20180904075850.2406-4-hverkuil@xs4all.nl>
In-Reply-To: <20180904075850.2406-1-hverkuil@xs4all.nl>
References: <20180904075850.2406-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Document that V4L2_BUF_FLAG_REQUEST_FD should only be used with
VIDIOC_QBUF and cleared otherwise.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 Documentation/media/uapi/v4l/buffer.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 35c2fadd10de..1865cd5b9d3c 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -312,6 +312,8 @@ struct v4l2_buffer
         and flag ``V4L2_BUF_FLAG_REQUEST_FD`` is set, then the buffer will be
 	queued to that request. This is set by the user when calling
 	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
+	Applications should not set ``V4L2_BUF_FLAG_REQUEST_FD`` for any ioctls
+	other than :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`.
 	If the device does not support requests, then ``EPERM`` will be returned.
 	If requests are supported but an invalid request file descriptor is
 	given, then ``EINVAL`` will be returned.
-- 
2.18.0
