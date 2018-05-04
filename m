Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54036 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbeEDUID (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 16:08:03 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v9 06/15] v4l: add unordered flag to format description ioctl
Date: Fri,  4 May 2018 17:06:03 -0300
Message-Id: <20180504200612.8763-7-ezequiel@collabora.com>
In-Reply-To: <20180504200612.8763-1-ezequiel@collabora.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

For explicit synchronization it important for userspace to know if the
format being used by the driver can deliver the buffers back to userspace
in the same order they were queued with QBUF.

Ordered streams fits nicely in a pipeline with DRM for example, where
ordered buffer are expected.

v2: Improve documentation (Hans)

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst | 7 +++++++
 include/uapi/linux/videodev2.h                   | 1 +
 2 files changed, 8 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 019c513df217..df8e039b9ac2 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -116,6 +116,13 @@ one until ``EINVAL`` is returned.
       - This format is not native to the device but emulated through
 	software (usually libv4l2), where possible try to use a native
 	format instead for better performance.
+    * - ``V4L2_FMT_FLAG_UNORDERED``
+      - 0x0004
+      - This format doesn't guarantee ordered buffer handling. I.e. the order
+	in which buffers are dequeued with
+	:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` may be different
+	from the order in which they were queued with
+	:ref:`VIDIOC_QBUF <VIDIOC_QBUF>`.
 
 
 Return Value
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 600877be5c22..a8842a5ca636 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -717,6 +717,7 @@ struct v4l2_fmtdesc {
 
 #define V4L2_FMT_FLAG_COMPRESSED 0x0001
 #define V4L2_FMT_FLAG_EMULATED   0x0002
+#define V4L2_FMT_FLAG_UNORDERED  0x0004
 
 	/* Frame Size and frame rate enumeration */
 /*
-- 
2.16.3
