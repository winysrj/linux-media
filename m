Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46415 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbbIUQDZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 12:03:25 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2] media: v4l2-ctrls: Fix 64bit support in get_ctrl()
Date: Mon, 21 Sep 2015 11:03:21 -0500
Message-ID: <1442851401-10864-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When trying to use v4l2_ctrl_g_ctrl_int64() to retrieve a
V4L2_CTRL_TYPE_INTEGER64 type value the internal helper function
get_ctrl() would prematurely exits because for this control type
the 'is_int' flag is not set. This would result in v4l2_ctrl_g_ctrl_int64
always returning 0.
Also v4l2_ctrl_g_ctrl_int64() is reading and returning the 32bit value
member instead of the 64bit version, so fixing that as well.

This patch extend the condition check to allow V4L2_CTRL_TYPE_INTEGER64
type to continue processing instead of exiting.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6b7dcc1b77d..6f1a8a6cc149 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2884,7 +2884,7 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
 	 * cur_to_user() calls below would need to be modified not to access
 	 * userspace memory when called from get_ctrl().
 	 */
-	if (!ctrl->is_int)
+	if (!ctrl->is_int && ctrl->type != V4L2_CTRL_TYPE_INTEGER64)
 		return -EINVAL;
 
 	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
@@ -2942,9 +2942,9 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl)
 
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
-	c.value = 0;
+	c.value64 = 0;
 	get_ctrl(ctrl, &c);
-	return c.value;
+	return c.value64;
 }
 EXPORT_SYMBOL(v4l2_ctrl_g_ctrl_int64);
 
-- 
1.8.5.1

