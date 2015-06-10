Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] media/v4l2-ctrls: Code cleanout validate_new()
Date: Wed, 10 Jun 2015 15:38:29 +0200
Message-id: <1433943509-8782-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

We can simplify the code removing the if().

v4l2_ctr_new sets ctrls->elems to 1 when !ctrl->is_ptr.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e3a3468002e6..b6b7dcc1b77d 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1678,21 +1678,6 @@ static int validate_new(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr p_new)
 	unsigned idx;
 	int err = 0;
 
-	if (!ctrl->is_ptr) {
-		switch (ctrl->type) {
-		case V4L2_CTRL_TYPE_INTEGER:
-		case V4L2_CTRL_TYPE_INTEGER_MENU:
-		case V4L2_CTRL_TYPE_MENU:
-		case V4L2_CTRL_TYPE_BITMASK:
-		case V4L2_CTRL_TYPE_BOOLEAN:
-		case V4L2_CTRL_TYPE_BUTTON:
-		case V4L2_CTRL_TYPE_CTRL_CLASS:
-		case V4L2_CTRL_TYPE_INTEGER64:
-			return ctrl->type_ops->validate(ctrl, 0, p_new);
-		default:
-			break;
-		}
-	}
 	for (idx = 0; !err && idx < ctrl->elems; idx++)
 		err = ctrl->type_ops->validate(ctrl, idx, p_new);
 	return err;
-- 
2.1.4
