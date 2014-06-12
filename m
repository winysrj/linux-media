Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53729 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933675AbaFLQKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 12:10:22 -0400
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id EA72E60093
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 19:10:20 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] v4l: ctrls: Provide an unlocked variant of v4l2_ctrl_modify_range()
Date: Thu, 12 Jun 2014 19:09:40 +0300
Message-Id: <1402589383-28165-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
References: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Drivers may use the v4l2_ctrl_modify_range() internally as part of other
operations that need to be both serialised using a driver's lock which can
also be used to serialise access to the control handler. Provide an unlocked
version of the function, __v4l2_ctrl_modify_range() which then may be used
by drivers for the purpose.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |   10 +++++-----
 include/media/v4l2-ctrls.h           |   18 ++++++++++++++++--
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 55c6832..7324ef0 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2886,12 +2886,14 @@ void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void
 }
 EXPORT_SYMBOL(v4l2_ctrl_notify);
 
-int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
-			s32 min, s32 max, u32 step, s32 def)
+int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
+			     s32 min, s32 max, u32 step, s32 def)
 {
 	int ret = check_range(ctrl->type, min, max, step, def);
 	struct v4l2_ext_control c;
 
+	lockdep_assert_held(ctrl->handler->lock);
+
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_BOOLEAN:
@@ -2904,7 +2906,6 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	default:
 		return -EINVAL;
 	}
-	v4l2_ctrl_lock(ctrl);
 	ctrl->minimum = min;
 	ctrl->maximum = max;
 	ctrl->step = step;
@@ -2916,10 +2917,9 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 		ret = set_ctrl(NULL, ctrl, &c, V4L2_EVENT_CTRL_CH_RANGE);
 	else
 		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
-	v4l2_ctrl_unlock(ctrl);
 	return ret;
 }
-EXPORT_SYMBOL(v4l2_ctrl_modify_range);
+EXPORT_SYMBOL(__v4l2_ctrl_modify_range);
 
 static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned elems)
 {
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 2d17819..371c4f1 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -560,6 +560,11 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
   */
 void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
 
+
+/** __v4l2_ctrl_modify_range() - Unlocked variant of v4l2_ctrl_modify_range() */
+int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
+			     s32 min, s32 max, u32 step, s32 def);
+
 /** v4l2_ctrl_modify_range() - Update the range of a control.
   * @ctrl:	The control to update.
   * @min:	The control's minimum value.
@@ -577,8 +582,17 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
   * This function assumes that the control handler is not locked and will
   * take the lock itself.
   */
-int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
-			s32 min, s32 max, u32 step, s32 def);
+static inline int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
+					 s32 min, s32 max, u32 step, s32 def)
+{
+	int rval;
+
+	v4l2_ctrl_lock(ctrl);
+	rval = __v4l2_ctrl_modify_range(ctrl, min, max, step, def);
+	v4l2_ctrl_unlock(ctrl);
+
+	return rval;
+}
 
 /** v4l2_ctrl_notify() - Function to set a notify callback for a control.
   * @ctrl:	The control.
-- 
1.7.10.4

