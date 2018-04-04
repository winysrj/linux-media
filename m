Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:48975 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750842AbeDDNDC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Apr 2018 09:03:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] v4l: Add macros for printing V4L 4cc values
Date: Wed,  4 Apr 2018 16:02:10 +0300
Message-Id: <1522846930-2967-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two macros that facilitate printing V4L fourcc values with printf
family of functions. v4l2_fourcc_conv provides the printf conversion
specifier for printing formats and v4l2_fourcc_to_conv provides the actual
arguments for that conversion specifier.

These macros are useful in both user and kernel code, therefore put them
into videodev2.h.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/videodev2.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index caec178..93184929 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -82,6 +82,31 @@
 	((__u32)(a) | ((__u32)(b) << 8) | ((__u32)(c) << 16) | ((__u32)(d) << 24))
 #define v4l2_fourcc_be(a, b, c, d)	(v4l2_fourcc(a, b, c, d) | (1 << 31))
 
+/**
+ * v4l2_fourcc_conv - Printf fourcc conversion specifiers for V4L2 formats
+ *
+ * Use as part of the format string. The values are obtained using
+ * @v4l2_fourcc_to_conv macro.
+ *
+ * Example ("format" is the V4L2 pixelformat in __u32):
+ *
+ * printf("V4L2 format is: " v4l2_fourcc_conv "\n", v4l2_fourcc_to_conv(format);
+ */
+#define v4l2_fourcc_conv "%c%c%c%c%s"
+
+/**
+ * v4l2_fourcc_to_conv - Arguments for V4L2 fourcc format conversion
+ *
+ * @fourcc: V4L2 pixelformat, as in __u32
+ *
+ * Yields to a comma-separated list of arguments for printf that matches with
+ * conversion specifiers provided by @v4l2_fourcc_conv.
+ */
+#define v4l2_fourcc_to_conv(fourcc)					\
+	(fourcc) & 0x7f, ((fourcc) >> 8) & 0x7f, ((fourcc) >> 16) & 0x7f, \
+	((fourcc) >> 24) & 0x7f, (fourcc) & (1 << 31) ? "-BE" : ""
+
+
 /*
  *	E N U M S
  */
-- 
2.7.4
