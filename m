Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34455 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab2LXLlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 06:41:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com
Subject: [PATCH] v4l2-compliance: Print invalid return codes in control tests
Date: Mon, 24 Dec 2012 12:42:22 +0100
Message-Id: <1356349342-7501-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/v4l2-compliance/v4l2-test-controls.cpp |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-test-controls.cpp b/utils/v4l2-compliance/v4l2-test-controls.cpp
index 1a1dc96..e16d71d 100644
--- a/utils/v4l2-compliance/v4l2-test-controls.cpp
+++ b/utils/v4l2-compliance/v4l2-test-controls.cpp
@@ -153,7 +153,7 @@ static int checkQCtrl(struct node *node, struct test_queryctrl &qctrl)
 		qmenu.index = i;
 		ret = doioctl(node, VIDIOC_QUERYMENU, &qmenu);
 		if (ret && ret != EINVAL)
-			return fail("invalid QUERYMENU return code\n");
+			return fail("invalid QUERYMENU return code (%d)\n", ret);
 		if (ret)
 			continue;
 		if (i < qctrl.minimum || i > qctrl.maximum)
@@ -194,7 +194,7 @@ int testQueryControls(struct node *node)
 		if (ret == ENOTTY)
 			return ret;
 		if (ret && ret != EINVAL)
-			return fail("invalid queryctrl return code\n");
+			return fail("invalid queryctrl return code (%d)\n", ret);
 		if (ret)
 			break;
 		if (checkQCtrl(node, qctrl))
@@ -244,7 +244,7 @@ int testQueryControls(struct node *node)
 		qctrl.id = id;
 		ret = doioctl(node, VIDIOC_QUERYCTRL, &qctrl);
 		if (ret && ret != EINVAL)
-			return fail("invalid queryctrl return code\n");
+			return fail("invalid queryctrl return code (%d)\n", ret);
 		if (ret)
 			continue;
 		if (qctrl.id != id)
@@ -260,7 +260,7 @@ int testQueryControls(struct node *node)
 		qctrl.id = id;
 		ret = doioctl(node, VIDIOC_QUERYCTRL, &qctrl);
 		if (ret && ret != EINVAL)
-			return fail("invalid queryctrl return code\n");
+			return fail("invalid queryctrl return code (%d)\n", ret);
 		if (ret)
 			break;
 		if (qctrl.id != id)
-- 
Regards,

Laurent Pinchart

