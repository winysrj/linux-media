Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:36337 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932509AbbELOlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 10:41:42 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>
Subject: [PATCH] v4l2-compliance: test SELECTION only for the supported buf_type
Date: Tue, 12 May 2015 16:41:35 +0200
Message-ID: <1431441695-26404-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

testBasicSelection defines which of capture and output supports crop
(resp. compose).
testBasicCrop (resp. testBasicCompose) shall be run only for the
supported buf_type.

Change-Id: I0a81e826eb7bc8a318a9d833426d802fedce46c9
Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 utils/v4l2-compliance/v4l2-test-formats.cpp | 40 +++++++++++++++++------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance/v4l2-test-formats.cpp
index 1cffd65..23107c3 100644
--- a/utils/v4l2-compliance/v4l2-test-formats.cpp
+++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
@@ -1251,13 +1251,16 @@ static int testLegacyCrop(struct node *node)
 
 int testCropping(struct node *node)
 {
-	int ret = ENOTTY;
+	int retCap, retOut;
+
+	retCap = ENOTTY;
+	retOut = ENOTTY;
 
 	fail_on_test(testLegacyCrop(node));
 	if (node->can_capture && node->is_video)
-		ret = testBasicSelection(node, V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_SEL_TGT_CROP);
+		retCap = testBasicSelection(node, V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_SEL_TGT_CROP);
 	if (node->can_output && node->is_video)
-		ret = testBasicSelection(node, V4L2_BUF_TYPE_VIDEO_OUTPUT, V4L2_SEL_TGT_CROP);
+		retOut = testBasicSelection(node, V4L2_BUF_TYPE_VIDEO_OUTPUT, V4L2_SEL_TGT_CROP);
 	if ((!node->can_capture && !node->can_output) || !node->is_video) {
 		struct v4l2_selection sel = {
 			V4L2_BUF_TYPE_VIDEO_CAPTURE,
@@ -1269,14 +1272,15 @@ int testCropping(struct node *node)
 		fail_on_test(doioctl(node, VIDIOC_G_SELECTION, &sel) != ENOTTY);
 		fail_on_test(doioctl(node, VIDIOC_S_SELECTION, &sel) != ENOTTY);
 	}
-	if (ret)
-		return ret;
+	if (retCap && retOut)
+		return retCap;
 
-	if (node->can_capture)
+	if (!retCap)
 		fail_on_test(testBasicCrop(node, V4L2_BUF_TYPE_VIDEO_CAPTURE));
-	if (node->can_output)
+	if (!retOut)
 		fail_on_test(testBasicCrop(node, V4L2_BUF_TYPE_VIDEO_OUTPUT));
-	return ret;
+
+	return 0;
 }
 
 static int testBasicCompose(struct node *node, unsigned type)
@@ -1321,12 +1325,15 @@ static int testBasicCompose(struct node *node, unsigned type)
 
 int testComposing(struct node *node)
 {
-	int ret = ENOTTY;
+	int retCap, retOut;
+
+	retCap = ENOTTY;
+	retOut = ENOTTY;
 
 	if (node->can_capture && node->is_video)
-		ret = testBasicSelection(node, V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_SEL_TGT_COMPOSE);
+		retCap = testBasicSelection(node, V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_SEL_TGT_COMPOSE);
 	if (node->can_output && node->is_video)
-		ret = testBasicSelection(node, V4L2_BUF_TYPE_VIDEO_OUTPUT, V4L2_SEL_TGT_COMPOSE);
+		retOut = testBasicSelection(node, V4L2_BUF_TYPE_VIDEO_OUTPUT, V4L2_SEL_TGT_COMPOSE);
 	if ((!node->can_capture && !node->can_output) || !node->is_video) {
 		struct v4l2_selection sel = {
 			V4L2_BUF_TYPE_VIDEO_OUTPUT,
@@ -1338,14 +1345,15 @@ int testComposing(struct node *node)
 		fail_on_test(doioctl(node, VIDIOC_G_SELECTION, &sel) != ENOTTY);
 		fail_on_test(doioctl(node, VIDIOC_S_SELECTION, &sel) != ENOTTY);
 	}
-	if (ret)
-		return ret;
+	if (retCap && retOut)
+		return retCap;
 
-	if (node->can_capture)
+	if (retCap)
 		fail_on_test(testBasicCompose(node, V4L2_BUF_TYPE_VIDEO_CAPTURE));
-	if (node->can_output)
+	if (retOut)
 		fail_on_test(testBasicCompose(node, V4L2_BUF_TYPE_VIDEO_OUTPUT));
-	return ret;
+
+	return 0;
 }
 
 static int testBasicScaling(struct node *node, const struct v4l2_format &cur)
-- 
1.9.1

