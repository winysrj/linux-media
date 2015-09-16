Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37736 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbIPW6Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 18:58:24 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
Subject: [Patch] media: v4l2-ctrls: Fix 64bit support in get_ctrl()
Date: Wed, 16 Sep 2015 17:58:19 -0500
Message-ID: <1442444299-25054-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When trying to use v4l2_ctrl_g_ctrl_int64() to retrieve a
V4L2_CTRL_TYPE_INTEGER64 type value the internal helper function
get_ctrl() would prematurely exits because for this control type
the 'is_int' flag is not set. This would result in v4l2_ctrl_g_ctrl_int64
always returning 0.

This patch extend the condition check to allow V4L2_CTRL_TYPE_INTEGER64
type to continue processing instead of exiting.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6b7dcc1b77d..989919c44c2f 100644
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
-- 
1.8.5.1

