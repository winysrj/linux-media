Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51540 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752245AbbBYMeL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 07:34:11 -0500
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 3D1796009C
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 14:34:08 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 1/3] v4l: Add an unlocked variant of v4l2_grab_ctrl()
Date: Wed, 25 Feb 2015 14:33:25 +0200
Message-Id: <1424867607-4082-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi>
References: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Commonly the control mutex is shared with the rest of the driver, which
already holds the mutex when accessing the control framework. Add
unlocked v4l2_grab_ctrl(), __v4l2_grab_ctrl() for this purpose.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |    6 ++----
 include/media/v4l2-ctrls.h           |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 45c5b47..a80bc9f 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2344,14 +2344,13 @@ EXPORT_SYMBOL(v4l2_ctrl_activate);
 
    Just call this and the framework will block any attempts to change
    these controls. */
-void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
+void __v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
 {
 	bool old;
 
 	if (ctrl == NULL)
 		return;
 
-	v4l2_ctrl_lock(ctrl);
 	if (grabbed)
 		/* set V4L2_CTRL_FLAG_GRABBED */
 		old = test_and_set_bit(1, &ctrl->flags);
@@ -2360,9 +2359,8 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
 		old = test_and_clear_bit(1, &ctrl->flags);
 	if (old != grabbed)
 		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_FLAGS);
-	v4l2_ctrl_unlock(ctrl);
 }
-EXPORT_SYMBOL(v4l2_ctrl_grab);
+EXPORT_SYMBOL(__v4l2_ctrl_grab);
 
 /* Log the control name and value */
 static void log_ctrl(const struct v4l2_ctrl *ctrl,
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 911f3e5..b50d1dd 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -607,6 +607,9 @@ struct v4l2_ctrl *v4l2_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
   */
 void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
 
+/** __v4l2_ctrl_grab() - Unlocked variant of v4l2_ctrl_grab() */
+void __v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
+
 /** v4l2_ctrl_grab() - Mark the control as grabbed or not grabbed.
   * @ctrl:	The control to (de)activate.
   * @grabbed:	True if the control should become grabbed.
@@ -620,7 +623,15 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
   * This function assumes that the control handler is not locked and will
   * take the lock itself.
   */
-void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
+static inline void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
+{
+	if (!ctrl)
+		return;
+
+	v4l2_ctrl_lock(ctrl);
+	__v4l2_ctrl_grab(ctrl, grabbed);
+	v4l2_ctrl_unlock(ctrl);
+}
 
 
 /** __v4l2_ctrl_modify_range() - Unlocked variant of v4l2_ctrl_modify_range() */
-- 
1.7.10.4

