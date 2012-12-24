Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35728 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2LXMyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 07:54:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com
Subject: [PATCH v2 2/2] v4l2-compliance: Print invalid error_idx values in control tests
Date: Mon, 24 Dec 2012 13:55:42 +0100
Message-Id: <1356353742-17327-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1356353742-17327-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1356353742-17327-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/v4l2-compliance/v4l2-test-controls.cpp |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-test-controls.cpp b/utils/v4l2-compliance/v4l2-test-controls.cpp
index 2e03551..70b8aba 100644
--- a/utils/v4l2-compliance/v4l2-test-controls.cpp
+++ b/utils/v4l2-compliance/v4l2-test-controls.cpp
@@ -614,7 +614,7 @@ int testExtendedControls(struct node *node)
 	if (ret != EINVAL)
 		return fail("g_ext_ctrls accepted invalid control ID\n");
 	if (ctrls.error_idx != ctrls.count)
-		return fail("g_ext_ctrls(0) invalid error_idx\n");
+		return fail("g_ext_ctrls(0) invalid error_idx %u\n", ctrls.error_idx);
 	ctrl.id = 0;
 	ctrl.size = 0;
 	ctrl.value = 0;
@@ -622,12 +622,12 @@ int testExtendedControls(struct node *node)
 	if (ret != EINVAL)
 		return fail("try_ext_ctrls accepted invalid control ID\n");
 	if (ctrls.error_idx != 0)
-		return fail("try_ext_ctrls(0) invalid error_idx\n");
+		return fail("try_ext_ctrls(0) invalid error_idx %u\n", ctrls.error_idx);
 	ret = doioctl(node, VIDIOC_S_EXT_CTRLS, &ctrls);
 	if (ret != EINVAL)
 		return fail("s_ext_ctrls accepted invalid control ID\n");
 	if (ctrls.error_idx != ctrls.count)
-		return fail("s_ext_ctrls(0) invalid error_idx\n");
+		return fail("s_ext_ctrls(0) invalid error_idx %u\n", ctrls.error_idx);
 
 	for (iter = node->controls.begin(); iter != node->controls.end(); ++iter) {
 		struct v4l2_ext_control ctrl;
-- 
1.7.8.6

