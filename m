Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:42122 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab2AJTO2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 14:14:28 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH 1/1] v4l: Ignore ctrl_class in the control framework
Date: Tue, 10 Jan 2012 21:14:22 +0200
Message-Id: <1326222862-15936-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Back in the old days there was probably a reason to require that controls
that are being used to access using VIDIOC_{TRY,G,S}_EXT_CTRLS belonged to
the same class. These days such reason does not exist, or at least cannot be
remembered, and concrete examples of the opposite can be seen: a single
(sub)device may well offer controls that belong to different classes and
there is no reason to deny changing them atomically.

This patch removes the check for v4l2_ext_controls.ctrl_class in the control
framework. The control framework issues the s_ctrl() op to the drivers
separately so changing the behaviour does not really change how this works
from the drivers' perspective.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/v4l2-ctrls.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index da1f4c2..fff3bb3 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1855,9 +1855,6 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		cs->error_idx = i;
 
-		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
-			return -EINVAL;
-
 		/* Old-style private controls are not allowed for
 		   extended controls */
 		if (id >= V4L2_CID_PRIVATE_BASE)
@@ -1918,13 +1915,10 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 }
 
 /* Handles the corner case where cs->count == 0. It checks whether the
-   specified control class exists. If that class ID is 0, then it checks
-   whether there are any controls at all. */
-static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
+   there are any controls at all. */
+static int handler_check(struct v4l2_ctrl_handler *hdl)
 {
-	if (ctrl_class == 0)
-		return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
-	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
+	return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
 }
 
 
@@ -1938,13 +1932,12 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	int i, j;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
 
 	if (hdl == NULL)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return handler_check(hdl);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
@@ -2160,13 +2153,12 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	int ret;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
 
 	if (hdl == NULL)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return handler_check(hdl);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
-- 
1.7.2.5

