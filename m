Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2722 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaIUOss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:48:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/11] v4l2-ctrls: add function to apply a configuration store.
Date: Sun, 21 Sep 2014 16:48:23 +0200
Message-Id: <1411310909-32825-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drivers need to be able to select a specific store. Add a new function that can
be used to apply a given store.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 61 ++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |  2 ++
 2 files changed, 63 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index df0f3ee..e5dccf2 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1610,6 +1610,17 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
 	ptr_to_ptr(ctrl, ctrl->p_cur, ctrl->p_new);
 }
 
+static void store_to_new(struct v4l2_ctrl *ctrl, unsigned store)
+{
+	if (ctrl == NULL)
+		return;
+	if (store)
+		ptr_to_ptr(ctrl, ctrl->p_stores[store - 1], ctrl->p_new);
+	else
+		ptr_to_ptr(ctrl, ctrl->p_cur, ctrl->p_new);
+	ctrl->is_new = true;
+}
+
 /* Return non-zero if one or more of the controls in the cluster has a new
    value that differs from the current value. */
 static int cluster_changed(struct v4l2_ctrl *master)
@@ -3368,6 +3379,56 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
 
+int v4l2_ctrl_apply_store(struct v4l2_ctrl_handler *hdl, unsigned store)
+{
+	struct v4l2_ctrl_ref *ref;
+	bool found_store = false;
+	unsigned i;
+
+	if (hdl == NULL || store == 0)
+		return -EINVAL;
+
+	mutex_lock(hdl->lock);
+
+	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
+		struct v4l2_ctrl *master;
+
+		if (store > ref->ctrl->nr_of_stores)
+			continue;
+		found_store = true;
+		master = ref->ctrl->cluster[0];
+		if (ref->ctrl != master)
+			continue;
+		if (master->handler != hdl)
+			v4l2_ctrl_lock(master);
+		for (i = 0; i < master->ncontrols; i++)
+			store_to_new(master->cluster[i], store);
+
+		/* For volatile autoclusters that are currently in auto mode
+		   we need to discover if it will be set to manual mode.
+		   If so, then we have to copy the current volatile values
+		   first since those will become the new manual values (which
+		   may be overwritten by explicit new values from this set
+		   of controls). */
+		if (master->is_auto && master->has_volatiles &&
+						!is_cur_manual(master)) {
+			s32 new_auto_val = *master->p_stores[store - 1].p_s32;
+
+			/* If the new value == the manual value, then copy
+			   the current volatile values. */
+			if (new_auto_val == master->manual_mode_value)
+				update_from_auto_cluster(master);
+		}
+
+		try_or_set_cluster(NULL, master, 0, true, 0);
+		if (master->handler != hdl)
+			v4l2_ctrl_unlock(master);
+	}
+	mutex_unlock(hdl->lock);
+	return found_store ? 0 : -EINVAL;
+}
+EXPORT_SYMBOL(v4l2_ctrl_apply_store);
+
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
 {
 	if (ctrl == NULL)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 4c31688..713980a 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -777,6 +777,8 @@ static inline void v4l2_ctrl_can_store(struct v4l2_ctrl *ctrl)
 	ctrl->can_store = true;
 }
 
+int v4l2_ctrl_apply_store(struct v4l2_ctrl_handler *hdl, unsigned store);
+
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
 void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
-- 
2.1.0

