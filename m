Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4498 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaAFOVk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 14/27] v4l2-ctrls: compare values only once.
Date: Mon,  6 Jan 2014 15:21:13 +0100
Message-Id: <1389018086-15903-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When setting a control the control's new value is compared to the current
value twice: once by new_to_store(), once by cluster_changed(). Not a big
deal when dealing with simple values, but it can be a problem when dealing
with compound types or matrices. So fix this: cluster_changed() sets the
has_changed flag, which is used by new_to_store() instead of having to do
another compare.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 16 ++++++++++------
 include/media/v4l2-ctrls.h           |  3 +++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 66724b7..a1c5e3e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1389,8 +1389,10 @@ static void new_to_store(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flag
 
 	if (ctrl == NULL)
 		return;
-	changed = !ctrl->type_ops->equal(ctrl, store, ctrl->new);
-	ptr_to_ptr(ctrl, ctrl->new, store);
+
+	changed = ctrl->has_changed;
+	if (changed)
+		ptr_to_ptr(ctrl, ctrl->new, store);
 
 	if (ch_flags & V4L2_EVENT_CTRL_CH_FLAGS) {
 		/* Note: CH_FLAGS is only set for auto clusters. */
@@ -1436,17 +1438,19 @@ static void store_to_new(struct v4l2_ctrl *ctrl, unsigned store)
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
-		diff = !ctrl->type_ops->equal(ctrl, ctrl->stores[0], ctrl->new);
+		ctrl->has_changed = !ctrl->type_ops->equal(ctrl,
+						ctrl->stores[0], ctrl->new);
+		changed |= ctrl->has_changed;
 	}
-	return diff;
+	return changed;
 }
 
 /* Control range checking */
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 2b9b2da..9ce740d 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -99,6 +99,8 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @is_new:	Set when the user specified a new value for this control. It
   *		is also set when called from v4l2_ctrl_handler_setup. Drivers
   *		should never set this flag.
+  * @has_changed: Set when the current value differs from the new value. Drivers
+  *		should never use this flag.
   * @is_private: If set, then this control is private to its handler and it
   *		will not be added to any other handlers. Drivers can set
   *		this flag.
@@ -165,6 +167,7 @@ struct v4l2_ctrl {
 	unsigned int done:1;
 
 	unsigned int is_new:1;
+	unsigned int has_changed:1;
 	unsigned int is_private:1;
 	unsigned int is_auto:1;
 	unsigned int is_int:1;
-- 
1.8.5.2

