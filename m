Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46529
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752134AbdIVVrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 17:47:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 8/8] media: v4l2-ioctl.h: convert debug macros into enum and document
Date: Fri, 22 Sep 2017 18:47:06 -0300
Message-Id: <28dfd60cbe16605062003e895532bfeddfcc6ebc.1506116720.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506116720.git.mchehab@s-opensource.com>
References: <cover.1506116720.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506116720.git.mchehab@s-opensource.com>
References: <cover.1506116720.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, there's no way to document #define foo <value>
with kernel-doc. So, convert it to an enum, and document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-ioctl.h | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index bd5312118013..136e2cffcf9e 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -588,20 +588,25 @@ struct v4l2_ioctl_ops {
 };
 
 
-/* v4l debugging and diagnostics */
-
-/* Device debug flags to be used with the video device debug attribute */
-
-/* Just log the ioctl name + error code */
-#define V4L2_DEV_DEBUG_IOCTL		0x01
-/* Log the ioctl name arguments + error code */
-#define V4L2_DEV_DEBUG_IOCTL_ARG	0x02
-/* Log the file operations open, release, mmap and get_unmapped_area */
-#define V4L2_DEV_DEBUG_FOP		0x04
-/* Log the read and write file operations and the VIDIOC_(D)QBUF ioctls */
-#define V4L2_DEV_DEBUG_STREAMING	0x08
-/* Log poll() */
-#define V4L2_DEV_DEBUG_POLL		0x10
+/**
+ * enum v4l2_debug_flags - Device debug flags to be used with the video
+ *	device debug attribute
+ *
+ * @V4L2_DEV_DEBUG_IOCTL:	Just log the ioctl name + error code.
+ * @V4L2_DEV_DEBUG_IOCTL_ARG:	Log the ioctl name arguments + error code.
+ * @V4L2_DEV_DEBUG_FOP:		Log the file operations and open, release,
+ *				mmap and get_unmapped_area syscalls.
+ * @V4L2_DEV_DEBUG_STREAMING:	Log the read and write syscalls and
+ *				:c:ref:`VIDIOC_[Q|DQ]BUFF <VIDIOC_QBUF>` ioctls.
+ * @V4L2_DEV_DEBUG_POLL:	Log poll syscalls.
+ */
+enum v4l2_debug_flags {
+	V4L2_DEV_DEBUG_IOCTL		= 0x01,
+	V4L2_DEV_DEBUG_IOCTL_ARG	= 0x02,
+	V4L2_DEV_DEBUG_FOP		= 0x04,
+	V4L2_DEV_DEBUG_STREAMING	= 0x08,
+	V4L2_DEV_DEBUG_POLL		= 0x10,
+};
 
 /*  Video standard functions  */
 
-- 
2.13.5
