Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35507 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752574AbdLKS2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 13:28:03 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v6 2/6] [media] v4l: add 'unordered' flag to format description ioctl
Date: Mon, 11 Dec 2017 16:27:37 -0200
Message-Id: <20171211182741.29712-3-gustavo@padovan.org>
In-Reply-To: <20171211182741.29712-1-gustavo@padovan.org>
References: <20171211182741.29712-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

For explicit synchronization it important for userspace to know if the
format being used by the driver can deliver the buffers back to userspace
in the same order they were queued with QBUF.

Ordered streams fits nicely in a pipeline with DRM for example, where
ordered buffer are expected.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst | 3 +++
 include/uapi/linux/videodev2.h                   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 019c513df217..368115f44fc0 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -116,6 +116,9 @@ one until ``EINVAL`` is returned.
       - This format is not native to the device but emulated through
 	software (usually libv4l2), where possible try to use a native
 	format instead for better performance.
+    * - ``V4L2_FMT_FLAG_UNORDERED``
+      - 0x0004
+      - This is a format that doesn't guarantee timely order of frames.
 
 
 Return Value
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1c095b5a99c5..a8ea632c14f0 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -709,6 +709,7 @@ struct v4l2_fmtdesc {
 
 #define V4L2_FMT_FLAG_COMPRESSED 0x0001
 #define V4L2_FMT_FLAG_EMULATED   0x0002
+#define V4L2_FMT_FLAG_UNORDERED  0x0004
 
 	/* Frame Size and frame rate enumeration */
 /*
-- 
2.13.6
