Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53273 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754980AbdCKJb6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 04:31:58 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 1/2] libv4lconvert: make it clear about the criteria for needs_conversion
Date: Sat, 11 Mar 2017 06:31:47 -0300
Message-Id: <f389eeb8826caf429b0948469bb7ce48f5276851.1489224702.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While there is already a comment about the always_needs_conversion
logic at libv4lconvert, the comment is not clear enough. Also,
the decision of needing a conversion or not is actually at the
supported_src_pixfmts[] table.

Improve the comments to make it clearer about what criteria should be
used with regards to exposing formats to userspace.

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 lib/libv4lconvert/libv4lconvert.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index da718918b030..2718446ff239 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -74,8 +74,15 @@ const struct libv4l_dev_ops *v4lconvert_get_default_dev_ops()
 static void v4lconvert_get_framesizes(struct v4lconvert_data *data,
 		unsigned int pixelformat, int index);
 
-/* Note for proper functioning of v4lconvert_enum_fmt the first entries in
-   supported_src_pixfmts must match with the entries in supported_dst_pixfmts */
+/*
+ * Notes:
+ * 1) for proper functioning of v4lconvert_enum_fmt the first entries in
+ *    supported_src_pixfmts must match with the entries in
+ *    supported_dst_pixfmts.
+ * 2) The field needs_conversion should be zero, *except* for device-specific
+ *    formats, where it doesn't make sense for applications to have their
+ *    own decoders.
+ */
 #define SUPPORTED_DST_PIXFMTS \
 	/* fourcc			bpp	rgb	yuv	needs      */ \
 	/*					rank	rank	conversion */ \
@@ -175,9 +182,13 @@ struct v4lconvert_data *v4lconvert_create_with_dev_ops(int fd, void *dev_ops_pri
 	int i, j;
 	struct v4lconvert_data *data = calloc(1, sizeof(struct v4lconvert_data));
 	struct v4l2_capability cap;
-	/* This keeps tracks of devices which have only formats for which apps
-	   most likely will need conversion and we can thus safely add software
-	   processing controls without a performance impact. */
+	/*
+	 * This keeps tracks of device-specific formats for which apps most
+	 * likely don't know. If all a driver can offer are proprietary
+	 * formats, a conversion is needed anyway. We can thus safely
+	 * add software processing controls without much concern about a
+	 * performance impact.
+	 */
 	int always_needs_conversion = 1;
 
 	if (!data) {
-- 
2.9.3
