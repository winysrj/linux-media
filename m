Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3952 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaAFOVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 22/27] v4l2-ctrls: add ctrl64 event.
Date: Mon,  6 Jan 2014 15:21:21 +0100
Message-Id: <1389018086-15903-23-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The current control event is not able to handle the 64-bit ranges or the
config_store. Add a new extended event that is able to handle this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 61 ++++++++++++++++++++++++++++++------
 include/uapi/linux/videodev2.h       | 19 ++++++++++-
 2 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 8d6711e..0014324 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1091,8 +1091,10 @@ static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 change
 	ev->u.ctrl.flags = ctrl->flags;
 	if (ctrl->is_ptr)
 		ev->u.ctrl.value64 = 0;
-	else
+	else if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
 		ev->u.ctrl.value64 = *ctrl->cur.p_s64;
+	else
+		ev->u.ctrl.value = *ctrl->cur.p_s32;
 	ev->u.ctrl.minimum = ctrl->minimum;
 	ev->u.ctrl.maximum = ctrl->maximum;
 	if (ctrl->type == V4L2_CTRL_TYPE_MENU
@@ -1103,19 +1105,48 @@ static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 change
 	ev->u.ctrl.default_value = ctrl->default_value;
 }
 
+static void fill_event64(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 changes)
+{
+	memset(ev->reserved, 0, sizeof(ev->reserved));
+	ev->type = V4L2_EVENT_CTRL64;
+	ev->id = ctrl->id;
+	ev->u.ctrl64.changes = changes;
+	ev->u.ctrl64.type = ctrl->type;
+	ev->u.ctrl64.config_store = ctrl->cur_store;
+	ev->u.ctrl64.flags = ctrl->flags;
+	if (ctrl->is_ptr)
+		ev->u.ctrl64.value64 = 0;
+	else if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
+		ev->u.ctrl64.value64 = *ctrl->cur.p_s64;
+	else
+		ev->u.ctrl64.value = *ctrl->cur.p_s32;
+	ev->u.ctrl64.minimum = ctrl->minimum;
+	ev->u.ctrl64.maximum = ctrl->maximum;
+	if (ctrl->type == V4L2_CTRL_TYPE_MENU
+	    || ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU)
+		ev->u.ctrl64.step = 1;
+	else
+		ev->u.ctrl64.step = ctrl->step;
+	ev->u.ctrl64.default_value = ctrl->default_value;
+}
+
 static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
 {
 	struct v4l2_event ev;
+	struct v4l2_event ev64;
 	struct v4l2_subscribed_event *sev;
 
 	if (list_empty(&ctrl->ev_subs))
 		return;
 	fill_event(&ev, ctrl, changes);
+	fill_event64(&ev64, ctrl, changes);
 
 	list_for_each_entry(sev, &ctrl->ev_subs, node)
 		if (sev->fh != fh ||
-		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK))
+		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)) {
 			v4l2_event_queue_fh(sev->fh, &ev);
+			v4l2_event_queue_fh(sev->fh, &ev64);
+		}
 }
 
 static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
@@ -3239,13 +3270,23 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	ctrl->maximum = max;
 	ctrl->step = step;
 	ctrl->default_value = def;
-	c.value = *ctrl->cur.p_s32;
-	if (validate_new(ctrl, &c))
-		c.value = def;
-	if (c.value != *ctrl->cur.p_s32)
-		ret = set_ctrl(NULL, ctrl, &c, V4L2_EVENT_CTRL_CH_RANGE);
-	else
-		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
+	if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64) {
+		c.value64 = *ctrl->cur.p_s64;
+		if (validate_new(ctrl, &c))
+			c.value64 = def;
+		if (c.value64 != *ctrl->cur.p_s64)
+			ret = set_ctrl(NULL, ctrl, &c, V4L2_EVENT_CTRL_CH_RANGE);
+		else
+			send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
+	} else {
+		c.value = *ctrl->cur.p_s32;
+		if (validate_new(ctrl, &c))
+			c.value = def;
+		if (c.value != *ctrl->cur.p_s32)
+			ret = set_ctrl(NULL, ctrl, &c, V4L2_EVENT_CTRL_CH_RANGE);
+		else
+			send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
+	}
 	v4l2_ctrl_unlock(ctrl);
 	return ret;
 }
@@ -3324,7 +3365,7 @@ EXPORT_SYMBOL(v4l2_ctrl_log_status);
 int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
 				const struct v4l2_event_subscription *sub)
 {
-	if (sub->type == V4L2_EVENT_CTRL)
+	if (sub->type == V4L2_EVENT_CTRL || sub->type == V4L2_EVENT_CTRL64)
 		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
 	return -EINVAL;
 }
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 78aba44..afa335d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1773,6 +1773,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_EOS				2
 #define V4L2_EVENT_CTRL				3
 #define V4L2_EVENT_FRAME_SYNC			4
+#define V4L2_EVENT_CTRL64			5
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -1781,7 +1782,7 @@ struct v4l2_event_vsync {
 	__u8 field;
 } __attribute__ ((packed));
 
-/* Payload for V4L2_EVENT_CTRL */
+/* Payload for V4L2_EVENT_CTRL/V4L2_EVENT_CTRL64 */
 #define V4L2_EVENT_CTRL_CH_VALUE		(1 << 0)
 #define V4L2_EVENT_CTRL_CH_FLAGS		(1 << 1)
 #define V4L2_EVENT_CTRL_CH_RANGE		(1 << 2)
@@ -1800,6 +1801,21 @@ struct v4l2_event_ctrl {
 	__s32 default_value;
 };
 
+struct v4l2_event_ctrl64 {
+	__u32 changes;
+	__u32 type;
+	union {
+		__s32 value;
+		__s64 value64;
+	};
+	__u32 flags;
+	__u32 config_store;
+	__s64 minimum;
+	__s64 maximum;
+	__u64 step;
+	__s64 default_value;
+};
+
 struct v4l2_event_frame_sync {
 	__u32 frame_sequence;
 };
@@ -1809,6 +1825,7 @@ struct v4l2_event {
 	union {
 		struct v4l2_event_vsync		vsync;
 		struct v4l2_event_ctrl		ctrl;
+		struct v4l2_event_ctrl64	ctrl64;
 		struct v4l2_event_frame_sync	frame_sync;
 		__u8				data[64];
 	} u;
-- 
1.8.5.2

