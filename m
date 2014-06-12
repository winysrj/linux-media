Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53717 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753035AbaFLQJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 12:09:53 -0400
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 63E8260095
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 19:09:51 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] v4l: ctrls: Unlocked variants of v4l2_ctrl_s_ctrl{,_int64}()
Date: Thu, 12 Jun 2014 19:09:42 +0300
Message-Id: <1402589383-28165-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
References: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Implement unlocked variants of v4l2_ctrl_s_ctrl() and
v4l2_ctrl_s_ctrl_int64(). As drivers need to set controls as they access
driver internal state elsewhere than in the control framework unlocked
variants of these functions become handy.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |   26 ++++++++++++++++++++------
 include/media/v4l2-ctrls.h           |   27 +++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 7324ef0..36228b4 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2848,27 +2848,41 @@ int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *control)
 }
 EXPORT_SYMBOL(v4l2_subdev_s_ctrl);
 
-int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
+int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 {
 	struct v4l2_ext_control c;
+	int rval;
+
+	lockdep_assert_held(ctrl->handler->lock);
 
 	/* It's a driver bug if this happens. */
 	WARN_ON(!type_is_int(ctrl));
 	c.value = val;
-	return set_ctrl_lock(NULL, ctrl, &c);
+	rval = set_ctrl(NULL, ctrl, &c, 0);
+	if (!rval)
+		cur_to_user(&c, ctrl);
+
+	return rval;
 }
-EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
+EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl);
 
-int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
+int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 {
 	struct v4l2_ext_control c;
+	int rval;
+
+	lockdep_assert_held(ctrl->handler->lock);
 
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
 	c.value64 = val;
-	return set_ctrl_lock(NULL, ctrl, &c);
+	rval = set_ctrl(NULL, ctrl, &c, 0);
+	if (!rval)
+		cur_to_user(&c, ctrl);
+
+	return rval;
 }
-EXPORT_SYMBOL(v4l2_ctrl_s_ctrl_int64);
+EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_int64);
 
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
 {
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 371c4f1..00c1778 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -619,6 +619,8 @@ void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void
   */
 s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
 
+/** __v4l2_ctrl_s_ctrl() - Unlocked variant of v4l2_ctrl_s_ctrl(). */
+int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 /** v4l2_ctrl_s_ctrl() - Helper function to set the control's value from within a driver.
   * @ctrl:	The control.
   * @val:	The new value.
@@ -629,7 +631,16 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
   *
   * This function is for integer type controls only.
   */
-int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
+static inline int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
+{
+	int rval;
+
+	v4l2_ctrl_lock(ctrl);
+	rval = __v4l2_ctrl_s_ctrl(ctrl, val);
+	v4l2_ctrl_unlock(ctrl);
+
+	return rval;
+}
 
 /** v4l2_ctrl_g_ctrl_int64() - Helper function to get a 64-bit control's value from within a driver.
   * @ctrl:	The control.
@@ -642,6 +653,9 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
   */
 s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl);
 
+/** __v4l2_ctrl_s_ctrl_int64() - Unlocked variant of v4l2_ctrl_s_ctrl_int64(). */
+int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val);
+
 /** v4l2_ctrl_s_ctrl_int64() - Helper function to set a 64-bit control's value from within a driver.
   * @ctrl:	The control.
   * @val:	The new value.
@@ -652,7 +666,16 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl);
   *
   * This function is for 64-bit integer type controls only.
   */
-int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val);
+static inline int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
+{
+	int rval;
+
+	v4l2_ctrl_lock(ctrl);
+	rval = __v4l2_ctrl_s_ctrl_int64(ctrl, val);
+	v4l2_ctrl_unlock(ctrl);
+
+	return rval;
+}
 
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
-- 
1.7.10.4

