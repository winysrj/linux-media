Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:32835 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbbIPJaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 05:30:55 -0400
Received: by lamp12 with SMTP id p12so123574480lam.0
        for <linux-media@vger.kernel.org>; Wed, 16 Sep 2015 02:30:53 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] v4l2-compliance: Basic support for array controls
Date: Wed, 16 Sep 2015 11:30:51 +0200
Message-Id: <1442395851-6789-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this patch:

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	fail: v4l2-test-controls.cpp(411): g_ctrl returned an error (22)
	test VIDIOC_G/S_CTRL: FAIL
	fail: v4l2-test-controls.cpp(637): g_ext_ctrls returned an error (28)
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 55 Private Controls: 0

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 utils/v4l2-compliance/v4l2-test-controls.cpp | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-test-controls.cpp b/utils/v4l2-compliance/v4l2-test-controls.cpp
index 526905eef183..eba32a9f7855 100644
--- a/utils/v4l2-compliance/v4l2-test-controls.cpp
+++ b/utils/v4l2-compliance/v4l2-test-controls.cpp
@@ -377,6 +377,9 @@ int testSimpleControls(struct node *node)
 	for (iter = node->controls.begin(); iter != node->controls.end(); ++iter) {
 		test_query_ext_ctrl &qctrl = iter->second;
 
+		if (qctrl.elems > 1)
+			continue;
+
 		info("checking control '%s' (0x%08x)\n", qctrl.name, qctrl.id);
 		ctrl.id = qctrl.id;
 		if (qctrl.type == V4L2_CTRL_TYPE_INTEGER64 ||
@@ -518,6 +521,10 @@ static int checkExtendedCtrl(struct v4l2_ext_control &ctrl, struct test_query_ex
 
 	if (ctrl.id != qctrl.id)
 		return fail("control id mismatch\n");
+
+	if (qctrl.elems > 1)
+		return 0;
+
 	switch (qctrl.type) {
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_INTEGER64:
@@ -620,7 +627,8 @@ int testExtendedControls(struct node *node)
 			ctrl.id = qctrl.id;
 			ctrl.value = qctrl.default_value;
 		} else {
-			if (ret != ENOSPC && qctrl.type == V4L2_CTRL_TYPE_STRING)
+			if (ret != ENOSPC &&
+				(qctrl.type == V4L2_CTRL_TYPE_STRING || qctrl.elems > 1 ))
 				return fail("did not check against size\n");
 			if (ret == ENOSPC && qctrl.type == V4L2_CTRL_TYPE_STRING) {
 				if (ctrls.error_idx != 0)
@@ -629,6 +637,10 @@ int testExtendedControls(struct node *node)
 				ctrl.size = qctrl.maximum + 1;
 				ret = doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls);
 			}
+			if (ret == ENOSPC && qctrl.elems > 1){
+				ctrl.ptr = new char[ctrl.size];
+				ret = doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls);
+			}
 			if (ret == EIO) {
 				warn("g_ext_ctrls returned EIO\n");
 				ret = 0;
@@ -668,7 +680,7 @@ int testExtendedControls(struct node *node)
 			if (checkExtendedCtrl(ctrl, qctrl))
 				return fail("s_ext_ctrls returned invalid control contents (%08x)\n", qctrl.id);
 		}
-		if (qctrl.type == V4L2_CTRL_TYPE_STRING)
+		if (qctrl.type == V4L2_CTRL_TYPE_STRING || qctrl.elems > 1)
 			delete [] ctrl.string;
 		ctrl.string = NULL;
 	}
@@ -708,6 +720,10 @@ int testExtendedControls(struct node *node)
 			ctrl.size = qctrl.maximum + 1;
 			ctrl.string = new char[ctrl.size];
 		}
+		if (qctrl.elems > 1){
+			ctrl.size = qctrl.elem_size * qctrl.elems;
+			ctrl.ptr = new char[ctrl.size];
+		}
 		ctrl.reserved2[0] = 0;
 		if (!ctrl_class)
 			ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
-- 
2.5.1

