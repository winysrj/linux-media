Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:49768 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3ADU76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 15:59:58 -0500
Received: by mail-vc0-f170.google.com with SMTP id fl11so17071773vcb.1
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 12:59:57 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/15] v4l2-ctrls: add a notify callback.
Date: Fri,  4 Jan 2013 15:59:35 -0500
Message-Id: <1357333186-8466-6-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes platform/bridge drivers need to be notified when a control from
a sub-device changes value. In order to support this a notify callback was
added.

djh - fix merge conflict in v4l2-ctrls.c

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 Documentation/video4linux/v4l2-controls.txt |   22 ++++++++++++++--------
 drivers/media/v4l2-core/v4l2-ctrls.c        |   18 ++++++++++++++++++
 include/media/v4l2-ctrls.h                  |   25 +++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index cfe52c7..676f873 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -715,14 +715,20 @@ a control of this type whenever the first control belonging to a new control
 class is added.
 
 
-Proposals for Extensions
-========================
+Adding Notify Callbacks
+=======================
+
+Sometimes the platform or bridge driver needs to be notified when a control
+from a sub-device driver changes. You can set a notify callback by calling
+this function:
 
-Some ideas for future extensions to the spec:
+void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl,
+	void (*notify)(struct v4l2_ctrl *ctrl, void *priv), void *priv);
 
-1) Add a V4L2_CTRL_FLAG_HEX to have values shown as hexadecimal instead of
-decimal. Useful for e.g. video_mute_yuv.
+Whenever the give control changes value the notify callback will be called
+with a pointer to the control and the priv pointer that was passed with
+v4l2_ctrl_notify. Note that the control's handler lock is held when the
+notify function is called.
 
-2) It is possible to mark in the controls array which controls have been
-successfully written and which failed by for example adding a bit to the
-control ID. Not sure if it is worth the effort, though.
+There can be only one notify function per control handler. Any attempt
+to set another notify function will cause a WARN_ON.
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index f6ee201..fa02363 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1204,6 +1204,8 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		send_event(fh, ctrl,
 			(changed ? V4L2_EVENT_CTRL_CH_VALUE : 0) |
 			(update_inactive ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
+		if (ctrl->call_notify && changed && ctrl->handler->notify)
+			ctrl->handler->notify(ctrl, ctrl->handler->notify_priv);
 	}
 }
 
@@ -2725,6 +2727,22 @@ int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl_int64);
 
+void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
+{
+	if (ctrl == NULL)
+		return;
+	if (notify == NULL) {
+		ctrl->call_notify = 0;
+		return;
+	}
+	if (WARN_ON(ctrl->handler->notify && ctrl->handler->notify != notify))
+		return;
+	ctrl->handler->notify = notify;
+	ctrl->handler->notify_priv = priv;
+	ctrl->call_notify = 1;
+}
+EXPORT_SYMBOL(v4l2_ctrl_notify);
+
 static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned elems)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(sev->fh->ctrl_handler, sev->id);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 9650911..c4cc041 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -53,6 +53,8 @@ struct v4l2_ctrl_ops {
 	int (*s_ctrl)(struct v4l2_ctrl *ctrl);
 };
 
+typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
+
 /** struct v4l2_ctrl - The control structure.
   * @node:	The list node.
   * @ev_subs:	The list of control event subscriptions.
@@ -72,6 +74,8 @@ struct v4l2_ctrl_ops {
   *		set this flag directly.
   * @has_volatiles: If set, then one or more members of the cluster are volatile.
   *		Drivers should never touch this flag.
+  * @call_notify: If set, then call the handler's notify function whenever the
+  *		control's value changes.
   * @manual_mode_value: If the is_auto flag is set, then this is the value
   *		of the auto control that determines if that control is in
   *		manual mode. So if the value of the auto control equals this
@@ -119,6 +123,7 @@ struct v4l2_ctrl {
 	unsigned int is_private:1;
 	unsigned int is_auto:1;
 	unsigned int has_volatiles:1;
+	unsigned int call_notify:1;
 	unsigned int manual_mode_value:8;
 
 	const struct v4l2_ctrl_ops *ops;
@@ -177,6 +182,10 @@ struct v4l2_ctrl_ref {
   *		control is needed multiple times, so this is a simple
   *		optimization.
   * @buckets:	Buckets for the hashing. Allows for quick control lookup.
+  * @notify:	A notify callback that is called whenever the control changes value.
+  *		Note that the handler's lock is held when the notify function
+  *		is called!
+  * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
   * @nr_of_buckets: Total number of buckets in the array.
   * @error:	The error code of the first failed control addition.
   */
@@ -187,6 +196,8 @@ struct v4l2_ctrl_handler {
 	struct list_head ctrl_refs;
 	struct v4l2_ctrl_ref *cached;
 	struct v4l2_ctrl_ref **buckets;
+	v4l2_ctrl_notify_fnc notify;
+	void *notify_priv;
 	u16 nr_of_buckets;
 	int error;
 };
@@ -525,6 +536,20 @@ static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
 	mutex_unlock(ctrl->handler->lock);
 }
 
+/** v4l2_ctrl_notify() - Function to set a notify callback for a control.
+  * @ctrl:	The control.
+  * @notify:	The callback function.
+  * @priv:	The callback private handle, passed as argument to the callback.
+  *
+  * This function sets a callback function for the control. If @ctrl is NULL,
+  * then it will do nothing. If @notify is NULL, then the notify callback will
+  * be removed.
+  *
+  * There can be only one notify. If another already exists, then a WARN_ON
+  * will be issued and the function will do nothing.
+  */
+void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv);
+
 /** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
   * @ctrl:	The control.
   *
-- 
1.7.9.5

