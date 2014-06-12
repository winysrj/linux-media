Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1114 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbaFLLyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 09/34] v4l2-ctrls: compare values only once.
Date: Thu, 12 Jun 2014 13:52:41 +0200
Message-Id: <763a4135151e0ab0ccef6b9abbb2a6c1618d028f.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When setting a control the control's new value is compared to the current
value twice: once by new_to_cur(), once by cluster_changed(). Not a big
deal when dealing with simple values, but it can be a problem when dealing
with compound types or arrays. So fix this: cluster_changed() sets the
has_changed flag, which is used by new_to_cur() instead of having to do
another compare.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 17 +++++++++++------
 include/media/v4l2-ctrls.h           |  3 +++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e7e0bea..1b4d37c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1424,8 +1424,11 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 
 	if (ctrl == NULL)
 		return;
-	changed = !ctrl->type_ops->equal(ctrl, ctrl->p_cur, ctrl->p_new);
-	ptr_to_ptr(ctrl, ctrl->p_new, ctrl->p_cur);
+
+	/* has_changed is set by cluster_changed */
+	changed = ctrl->has_changed;
+	if (changed)
+		ptr_to_ptr(ctrl, ctrl->p_new, ctrl->p_cur);
 
 	if (ch_flags & V4L2_EVENT_CTRL_CH_FLAGS) {
 		/* Note: CH_FLAGS is only set for auto clusters. */
@@ -1462,17 +1465,19 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
    value that differs from the current value. */
 static int cluster_changed(struct v4l2_ctrl *master)
 {
-	int diff = 0;
+	bool changed = false;
 	int i;
 
-	for (i = 0; !diff && i < master->ncontrols; i++) {
+	for (i = 0; i < master->ncontrols; i++) {
 		struct v4l2_ctrl *ctrl = master->cluster[i];
 
 		if (ctrl == NULL)
 			continue;
-		diff = !ctrl->type_ops->equal(ctrl, ctrl->p_cur, ctrl->p_new);
+		ctrl->has_changed = !ctrl->type_ops->equal(ctrl,
+						ctrl->p_cur, ctrl->p_new);
+		changed |= ctrl->has_changed;
 	}
-	return diff;
+	return changed;
 }
 
 /* Control range checking */
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index ddd9fdf..a38bd55 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -96,6 +96,8 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @is_new:	Set when the user specified a new value for this control. It
   *		is also set when called from v4l2_ctrl_handler_setup. Drivers
   *		should never set this flag.
+  * @has_changed: Set when the current value differs from the new value. Drivers
+  *		should never use this flag.
   * @is_private: If set, then this control is private to its handler and it
   *		will not be added to any other handlers. Drivers can set
   *		this flag.
@@ -158,6 +160,7 @@ struct v4l2_ctrl {
 	unsigned int done:1;
 
 	unsigned int is_new:1;
+	unsigned int has_changed:1;
 	unsigned int is_private:1;
 	unsigned int is_auto:1;
 	unsigned int is_int:1;
-- 
2.0.0.rc0

