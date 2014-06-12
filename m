Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53730 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933533AbaFLQKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 12:10:22 -0400
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 1340A60095
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 19:10:21 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] v4l: ctrls: Move control lock/unlock above the control access functions
Date: Thu, 12 Jun 2014 19:09:39 +0300
Message-Id: <1402589383-28165-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
References: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The v4l2_ctrl_{,un}lock will be needed elsewhere. Define them before the
functions that perform operations on controls.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/v4l2-ctrls.h |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 16f7f26..2d17819 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -307,6 +307,24 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
   */
 void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl);
 
+/** v4l2_ctrl_lock() - Helper function to lock the handler
+  * associated with the control.
+  * @ctrl:	The control to lock.
+  */
+static inline void v4l2_ctrl_lock(struct v4l2_ctrl *ctrl)
+{
+	mutex_lock(ctrl->handler->lock);
+}
+
+/** v4l2_ctrl_unlock() - Helper function to unlock the handler
+  * associated with the control.
+  * @ctrl:	The control to unlock.
+  */
+static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
+{
+	mutex_unlock(ctrl->handler->lock);
+}
+
 /** v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls belonging
   * to the handler to initialize the hardware to the current control values.
   * @hdl:	The control handler.
@@ -562,24 +580,6 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
 int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 			s32 min, s32 max, u32 step, s32 def);
 
-/** v4l2_ctrl_lock() - Helper function to lock the handler
-  * associated with the control.
-  * @ctrl:	The control to lock.
-  */
-static inline void v4l2_ctrl_lock(struct v4l2_ctrl *ctrl)
-{
-	mutex_lock(ctrl->handler->lock);
-}
-
-/** v4l2_ctrl_unlock() - Helper function to unlock the handler
-  * associated with the control.
-  * @ctrl:	The control to unlock.
-  */
-static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
-{
-	mutex_unlock(ctrl->handler->lock);
-}
-
 /** v4l2_ctrl_notify() - Function to set a notify callback for a control.
   * @ctrl:	The control.
   * @notify:	The callback function.
-- 
1.7.10.4

