Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36231 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbbKKL6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 06:58:39 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dimitrios Katsaros <patcherwork@gmail.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] v4l2-core/v4l2-ctrls: Filter NOOP CH_RANGE events
Date: Wed, 11 Nov 2015 12:58:34 +0100
Message-Id: <1447243114-1011-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If modify_range is called but no range is changed, do not send the
CH_RANGE event.

Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 4a1d9fdd14bb..f9c0e8150bd1 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3300,7 +3300,8 @@ EXPORT_SYMBOL(v4l2_ctrl_notify);
 int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 			s64 min, s64 max, u64 step, s64 def)
 {
-	bool changed;
+	bool value_changed;
+	bool range_changed = false;
 	int ret;
 
 	lockdep_assert_held(ctrl->handler->lock);
@@ -3324,10 +3325,14 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	default:
 		return -EINVAL;
 	}
-	ctrl->minimum = min;
-	ctrl->maximum = max;
-	ctrl->step = step;
-	ctrl->default_value = def;
+	if ((ctrl->minimum != min) || (ctrl->maximum != max) ||
+		(ctrl->step != step) || ctrl->default_value != def) {
+		range_changed = true;
+		ctrl->minimum = min;
+		ctrl->maximum = max;
+		ctrl->step = step;
+		ctrl->default_value = def;
+	}
 	cur_to_new(ctrl);
 	if (validate_new(ctrl, ctrl->p_new)) {
 		if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
@@ -3337,12 +3342,12 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	}
 
 	if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
-		changed = *ctrl->p_new.p_s64 != *ctrl->p_cur.p_s64;
+		value_changed = *ctrl->p_new.p_s64 != *ctrl->p_cur.p_s64;
 	else
-		changed = *ctrl->p_new.p_s32 != *ctrl->p_cur.p_s32;
-	if (changed)
+		value_changed = *ctrl->p_new.p_s32 != *ctrl->p_cur.p_s32;
+	if (value_changed)
 		ret = set_ctrl(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
-	else
+	else if (range_changed)
 		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
 	return ret;
 }
-- 
2.6.2

