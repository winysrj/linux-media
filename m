Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:52223 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751195AbeDEK7M (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:59:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@google.com, hverkuil@xs4all.nl
Subject: [v4l-utils RFC 2/6] Make v4l-utils compile with request-related changes
Date: Thu,  5 Apr 2018 13:58:15 +0300
Message-Id: <1522925899-14073-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mostly remove zero reserved field checks.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 lib/libv4l2/libv4l2.c                        | 4 ++--
 utils/v4l2-compliance/v4l2-test-buffers.cpp  | 2 +-
 utils/v4l2-compliance/v4l2-test-controls.cpp | 4 ----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 2db25d1..47eadda 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -190,7 +190,7 @@ static int v4l2_map_buffers(int index)
 		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		buf.memory = V4L2_MEMORY_MMAP;
 		buf.index = i;
-		buf.reserved = buf.reserved2 = 0;
+		buf.reserved = buf.request_fd = 0;
 		result = devices[index].dev_ops->ioctl(
 				devices[index].dev_ops_priv,
 				devices[index].fd, VIDIOC_QUERYBUF, &buf);
@@ -579,7 +579,7 @@ static int v4l2_buffers_mapped(int index)
 			buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 			buf.memory = V4L2_MEMORY_MMAP;
 			buf.index = i;
-			buf.reserved = buf.reserved2 = 0;
+			buf.reserved = buf.request_fd = 0;
 			if (devices[index].dev_ops->ioctl(
 					devices[index].dev_ops_priv,
 					devices[index].fd, VIDIOC_QUERYBUF,
diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
index 9b0933e..a9e50b4 100644
--- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
+++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
@@ -196,7 +196,7 @@ int buffer::check(unsigned type, unsigned memory, unsigned index,
 	fail_on_test(g_memory() != memory);
 	fail_on_test(g_index() >= VIDEO_MAX_FRAME);
 	fail_on_test(g_index() != index);
-	fail_on_test(buf.reserved2 || buf.reserved);
+	fail_on_test(buf.request_fd || buf.reserved);
 	fail_on_test(timestamp != V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC &&
 		     timestamp != V4L2_BUF_FLAG_TIMESTAMP_COPY);
 	fail_on_test(timestamp_src != V4L2_BUF_FLAG_TSTAMP_SRC_SOE &&
diff --git a/utils/v4l2-compliance/v4l2-test-controls.cpp b/utils/v4l2-compliance/v4l2-test-controls.cpp
index 508daf0..b9a8978 100644
--- a/utils/v4l2-compliance/v4l2-test-controls.cpp
+++ b/utils/v4l2-compliance/v4l2-test-controls.cpp
@@ -589,8 +589,6 @@ int testExtendedControls(struct node *node)
 		return fail("field which changed\n");
 	if (ctrls.count)
 		return fail("field count changed\n");
-	if (check_0(ctrls.reserved, sizeof(ctrls.reserved)))
-		return fail("reserved not zeroed\n");
 
 	memset(&ctrls, 0, sizeof(ctrls));
 	ret = doioctl(node, VIDIOC_TRY_EXT_CTRLS, &ctrls);
@@ -602,8 +600,6 @@ int testExtendedControls(struct node *node)
 		return fail("field which changed\n");
 	if (ctrls.count)
 		return fail("field count changed\n");
-	if (check_0(ctrls.reserved, sizeof(ctrls.reserved)))
-		return fail("reserved not zeroed\n");
 
 	for (iter = node->controls.begin(); iter != node->controls.end(); ++iter) {
 		test_query_ext_ctrl &qctrl = iter->second;
-- 
2.7.4
