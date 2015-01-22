Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60062 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbbAVOsS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 09:48:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: [PATCH 4/7] v4l2-ctrls: Export the standard control type operations
Date: Thu, 22 Jan 2015 16:48:43 +0200
Message-Id: <1421938126-17747-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers that implement custom control types need to implement the equal,
init, log and validate operations. Depending on the control type some of
those operations can use the standard control type implementation
provided by the v4l2 control framework. Export them to enable their
reuse.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 27 ++++++++++++++++-----------
 include/media/v4l2-ctrls.h           |  9 +++++++++
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ba996de..17f10d4 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1233,9 +1233,9 @@ static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
 			v4l2_event_queue_fh(sev->fh, &ev);
 }
 
-static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
-		      union v4l2_ctrl_ptr ptr1,
-		      union v4l2_ctrl_ptr ptr2)
+bool v4l2_ctrl_type_std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
+			      union v4l2_ctrl_ptr ptr1,
+			      union v4l2_ctrl_ptr ptr2)
 {
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_BUTTON:
@@ -1262,6 +1262,7 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 		return !memcmp(ptr1.p + idx, ptr2.p + idx, ctrl->elem_size);
 	}
 }
+EXPORT_SYMBOL_GPL(v4l2_ctrl_type_std_equal);
 
 static void std_init_one(const struct v4l2_ctrl *ctrl, u32 idx,
 			 union v4l2_ctrl_ptr ptr)
@@ -1301,7 +1302,8 @@ static void std_init_one(const struct v4l2_ctrl *ctrl, u32 idx,
 	}
 }
 
-static void std_init(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr ptr)
+void v4l2_ctrl_type_std_init(const struct v4l2_ctrl *ctrl,
+			     union v4l2_ctrl_ptr ptr)
 {
 	u32 idx;
 
@@ -1329,8 +1331,9 @@ static void std_init(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr ptr)
 		break;
 	}
 }
+EXPORT_SYMBOL_GPL(v4l2_ctrl_type_std_init);
 
-static void std_log(const struct v4l2_ctrl *ctrl)
+void v4l2_ctrl_type_std_log(const struct v4l2_ctrl *ctrl)
 {
 	union v4l2_ctrl_ptr ptr = ctrl->p_cur;
 
@@ -1387,6 +1390,7 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 		break;
 	}
 }
+EXPORT_SYMBOL_GPL(v4l2_ctrl_type_std_log);
 
 /*
  * Round towards the closest legal value. Be careful when we are
@@ -1410,8 +1414,8 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 })
 
 /* Validate a new control */
-static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
-			union v4l2_ctrl_ptr ptr)
+int v4l2_ctrl_type_std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
+				union v4l2_ctrl_ptr ptr)
 {
 	size_t len;
 	u64 offset;
@@ -1485,12 +1489,13 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		return -EINVAL;
 	}
 }
+EXPORT_SYMBOL_GPL(v4l2_ctrl_type_std_validate);
 
 static const struct v4l2_ctrl_type_ops std_type_ops = {
-	.equal = std_equal,
-	.init = std_init,
-	.log = std_log,
-	.validate = std_validate,
+	.equal = v4l2_ctrl_type_std_equal,
+	.init = v4l2_ctrl_type_std_init,
+	.log = v4l2_ctrl_type_std_log,
+	.validate = v4l2_ctrl_type_std_validate,
 };
 
 /* Helper function: copy the given control value back to the caller */
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index a7280e9..71067fb 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -93,6 +93,15 @@ struct v4l2_ctrl_type_ops {
 			union v4l2_ctrl_ptr ptr);
 };
 
+bool v4l2_ctrl_type_std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
+			      union v4l2_ctrl_ptr ptr1,
+			      union v4l2_ctrl_ptr ptr2);
+void v4l2_ctrl_type_std_init(const struct v4l2_ctrl *ctrl,
+			     union v4l2_ctrl_ptr ptr);
+void v4l2_ctrl_type_std_log(const struct v4l2_ctrl *ctrl);
+int v4l2_ctrl_type_std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
+				union v4l2_ctrl_ptr ptr);
+
 typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
 
 /** struct v4l2_ctrl - The control structure.
-- 
2.0.5

