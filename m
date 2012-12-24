Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35726 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LXMyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 07:54:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com
Subject: [PATCH v2 1/2] v4l2-compliance: Print invalid return codes in control tests
Date: Mon, 24 Dec 2012 13:55:41 +0100
Message-Id: <1356353742-17327-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/v4l2-compliance/v4l2-test-controls.cpp |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-test-controls.cpp b/utils/v4l2-compliance/v4l2-test-controls.cpp
index 27c0117..2e03551 100644
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
@@ -352,7 +352,7 @@ int testSimpleControls(struct node *node)
 			ctrl.id = iter->id;
 			ctrl.value = iter->default_value;
 		} else if (ret)
-			return fail("g_ctrl returned an error\n");
+			return fail("g_ctrl returned an error (%d)\n", ret);
 		else if (checkSimpleCtrl(ctrl, *iter))
 			return fail("invalid control %08x\n", iter->id);
 		
@@ -417,7 +417,7 @@ int testSimpleControls(struct node *node)
 				if (!valid && !ret)
 					return fail("could set invalid menu item %d\n", i);
 				if (ret && ret != EINVAL)
-					return fail("setting invalid menu item returned wrong error\n");
+					return fail("setting invalid menu item returned wrong error (%d)\n", ret);
 			}
 		} else {
 			// at least min, max and default values should work
@@ -581,7 +581,7 @@ int testExtendedControls(struct node *node)
 			if (ctrls.error_idx != 0)
 				return fail("invalid error index read only control\n");
 		} else if (ret) {
-			return fail("try_ext_ctrls returned an error\n");
+			return fail("try_ext_ctrls returned an error (%d)\n", ret);
 		}
 		
 		// Try to set the current value (or the default value for write only controls)
@@ -597,7 +597,7 @@ int testExtendedControls(struct node *node)
 				ret = 0;
 			}
 			if (ret)
-				return fail("s_ext_ctrls returned an error\n");
+				return fail("s_ext_ctrls returned an error (%d)\n", ret);
 		
 			if (checkExtendedCtrl(ctrl, *iter))
 				return fail("s_ext_ctrls returned invalid control contents (%08x)\n", iter->id);
-- 
1.7.8.6

