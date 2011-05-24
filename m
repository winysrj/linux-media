Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42724 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1EXAe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 20:34:56 -0400
From: Jeongtae Park <jtp.park@samsung.com>
To: Jeongtae Park <jtp.park@samsung.com>, linux-media@vger.kernel.org
Cc: jaeryul.oh@samsung.com, jonghun.han@samsung.com,
	june.bae@samsung.com, janghyuck.kim@samsung.com,
	younglak1004.kim@samsung.com, m.szyprowski@samsung.com,
	Jeongtae Park <jtp.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 3/4] v4l2-ctrls: add support for per-buffer control
Date: Tue, 24 May 2011 09:28:39 +0900
Message-Id: <1306196920-15467-4-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1306196920-15467-1-git-send-email-jtp.park@samsung.com>
References: <1306196920-15467-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds is_bufferable member to v4l2_ctrl structure and
v4l2_ctrl_p_ctrl() to support per-buffer control.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/video/v4l2-ctrls.c |   17 +++++++++++++++++
 include/media/v4l2-ctrls.h       |   18 ++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index e6fa9be..4664f6f 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1100,6 +1100,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 	if (ctrl) {
 		ctrl->is_private = cfg->is_private;
 		ctrl->is_volatile = cfg->is_volatile;
+		ctrl->is_bufferable = cfg->is_bufferable;
 	}
 	return ctrl;
 }
@@ -1641,6 +1642,11 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 	if (ctrl->is_volatile && master->ops->g_volatile_ctrl)
 		ret = master->ops->g_volatile_ctrl(master);
 	*val = ctrl->cur.val;
+	if (ctrl->is_bufferable) {
+		if (!ctrl->is_new)
+			ret = -EINVAL;
+		ctrl->is_new = 0;
+	}
 	v4l2_ctrl_unlock(master);
 	return ret;
 }
@@ -1672,6 +1678,14 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl)
 }
 EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
 
+int v4l2_ctrl_p_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
+{
+	/* It's a driver bug if this happens. */
+	WARN_ON(!type_is_int(ctrl));
+	return get_ctrl(ctrl, val);
+}
+EXPORT_SYMBOL(v4l2_ctrl_p_ctrl);
+
 
 /* Core function that calls try/s_ctrl and ensures that the new value is
    copied to the current value on a set.
@@ -1872,6 +1886,9 @@ static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 
 	v4l2_ctrl_lock(ctrl);
 
+	if (ctrl->is_bufferable && ctrl->is_new)
+		printk(KERN_WARNING "overwrite unused control value");
+
 	/* Reset the 'is_new' flags of the cluster */
 	for (i = 0; i < master->ncontrols; i++)
 		if (master->cluster[i])
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 27714c9..34e69d1 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -67,6 +67,7 @@ struct v4l2_ctrl_ops {
   *		control's current value cannot be cached and needs to be
   *		retrieved through the g_volatile_ctrl op. Drivers can set
   *		this flag.
+  * @is_bufferable: If set, then this control use to handle per-buffer control.
   * @ops:	The control ops.
   * @id:	The control ID.
   * @name:	The control name.
@@ -108,6 +109,7 @@ struct v4l2_ctrl {
 	unsigned int is_new:1;
 	unsigned int is_private:1;
 	unsigned int is_volatile:1;
+	unsigned int is_bufferable:1;
 
 	const struct v4l2_ctrl_ops *ops;
 	u32 id;
@@ -201,6 +203,7 @@ struct v4l2_ctrl_fh {
   * @is_volatile: If set, then this control is volatile. This means that the
   *		control's current value cannot be cached and needs to be
   *		retrieved through the g_volatile_ctrl op.
+  * @is_bufferable: If set, then this control use to handle per-buffer control.
   */
 struct v4l2_ctrl_config {
 	const struct v4l2_ctrl_ops *ops;
@@ -216,6 +219,7 @@ struct v4l2_ctrl_config {
 	const char * const *qmenu;
 	unsigned int is_private:1;
 	unsigned int is_volatile:1;
+	unsigned int is_bufferable:1;
 };
 
 /** v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
@@ -434,6 +438,20 @@ static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
   */
 s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
 
+/** v4l2_ctrl_p_ctrl() - Helper function to pick the control's value from within a driver.
+  * @ctrl:	The control.
+  * @val:	The new value.
+  *
+  * This picks the control's new value safely by going through the control
+  * framework. This function will lock the control's handler, so it cannot be
+  * used from within the &v4l2_ctrl_ops functions. If control has bufferable flag,
+  * this returns valid value when control has new value. If not, It will return error value.
+  * After the execution of this operation control's is_new flag reset to 0.
+  *
+  * This function is for integer type controls only.
+  */
+int v4l2_ctrl_p_ctrl(struct v4l2_ctrl *ctrl, s32 *val);
+
 /** v4l2_ctrl_s_ctrl() - Helper function to set the control's value from within a driver.
   * @ctrl:	The control.
   * @val:	The new value.
-- 
1.7.1

