Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42721 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1EXAe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 20:34:57 -0400
From: Jeongtae Park <jtp.park@samsung.com>
To: Jeongtae Park <jtp.park@samsung.com>, linux-media@vger.kernel.org
Cc: jaeryul.oh@samsung.com, jonghun.han@samsung.com,
	june.bae@samsung.com, janghyuck.kim@samsung.com,
	younglak1004.kim@samsung.com, m.szyprowski@samsung.com,
	Jeongtae Park <jtp.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/4] v4l2: Apply control events patch series
Date: Tue, 24 May 2011 09:28:38 +0900
Message-Id: <1306196920-15467-3-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1306196920-15467-1-git-send-email-jtp.park@samsung.com>
References: <1306196920-15467-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch apply control event patch series by Hans Verkuil.
This is only merge-down version of contorl event patches
for MFC working branch.
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/mfc_v8

You can be found the original patches below message
http://www.spinics.net/lists/linux-media/msg31010.html
or
http://git.linuxtv.org/hverkuil/v4l-utils.git?a=shortlog;h=refs/heads/core

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/video/cx2341x.c        |   58 +++++++++------
 drivers/media/video/saa7115.c        |    3 +-
 drivers/media/video/v4l2-common.c    |    3 +
 drivers/media/video/v4l2-ctrls.c     |  137 +++++++++++++++++++++++++++-------
 drivers/media/video/v4l2-event.c     |  128 +++++++++++++++++++++++---------
 drivers/media/video/v4l2-fh.c        |    6 +-
 drivers/media/video/v4l2-ioctl.c     |   36 +++++++--
 drivers/media/video/videobuf2-core.c |   16 +---
 drivers/media/video/vivi.c           |   63 +++++++++++++++-
 include/linux/videodev2.h            |   29 +++++++-
 include/media/v4l2-ctrls.h           |   47 +++++++-----
 include/media/v4l2-event.h           |    2 +
 include/media/v4l2-fh.h              |    2 +
 13 files changed, 396 insertions(+), 134 deletions(-)

diff --git a/drivers/media/video/cx2341x.c b/drivers/media/video/cx2341x.c
index 103ef6b..2781889 100644
--- a/drivers/media/video/cx2341x.c
+++ b/drivers/media/video/cx2341x.c
@@ -1307,6 +1307,12 @@ static int cx2341x_try_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
+static void cx2341x_activate(struct v4l2_ctrl *ctrl, bool activate)
+{
+	v4l2_ctrl_flags(ctrl, V4L2_CTRL_FLAG_INACTIVE,
+			activate ? 0 : V4L2_CTRL_FLAG_INACTIVE);
+}
+
 static int cx2341x_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	static const int mpeg_stream_type[] = {
@@ -1380,10 +1386,10 @@ static int cx2341x_s_ctrl(struct v4l2_ctrl *ctrl)
 			int is_ac3 = hdl->audio_encoding->val ==
 						V4L2_MPEG_AUDIO_ENCODING_AC3;
 
-			v4l2_ctrl_activate(hdl->audio_ac3_bitrate, is_ac3);
-			v4l2_ctrl_activate(hdl->audio_l2_bitrate, !is_ac3);
+			cx2341x_activate(hdl->audio_ac3_bitrate, is_ac3);
+			cx2341x_activate(hdl->audio_l2_bitrate, !is_ac3);
 		}
-		v4l2_ctrl_activate(hdl->audio_mode_extension,
+		cx2341x_activate(hdl->audio_mode_extension,
 			hdl->audio_mode->val == V4L2_MPEG_AUDIO_MODE_JOINT_STEREO);
 		if (cx2341x_neq(hdl->audio_sampling_freq) &&
 		    hdl->ops && hdl->ops->s_audio_sampling_freq)
@@ -1413,9 +1419,9 @@ static int cx2341x_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (err)
 			return err;
 
-		v4l2_ctrl_activate(hdl->video_bitrate_mode,
+		cx2341x_activate(hdl->video_bitrate_mode,
 			hdl->video_encoding->val != V4L2_MPEG_VIDEO_ENCODING_MPEG_1);
-		v4l2_ctrl_activate(hdl->video_bitrate_peak,
+		cx2341x_activate(hdl->video_bitrate_peak,
 			hdl->video_bitrate_mode->val != V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
 		if (cx2341x_neq(hdl->video_encoding) &&
 		    hdl->ops && hdl->ops->s_video_encoding)
@@ -1441,18 +1447,18 @@ static int cx2341x_s_ctrl(struct v4l2_ctrl *ctrl)
 
 		active_filter = hdl->video_spatial_filter_mode->val !=
 				V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_AUTO;
-		v4l2_ctrl_activate(hdl->video_spatial_filter, active_filter);
-		v4l2_ctrl_activate(hdl->video_luma_spatial_filter_type, active_filter);
-		v4l2_ctrl_activate(hdl->video_chroma_spatial_filter_type, active_filter);
+		cx2341x_activate(hdl->video_spatial_filter, active_filter);
+		cx2341x_activate(hdl->video_luma_spatial_filter_type, active_filter);
+		cx2341x_activate(hdl->video_chroma_spatial_filter_type, active_filter);
 		active_filter = hdl->video_temporal_filter_mode->val !=
 				V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_AUTO;
-		v4l2_ctrl_activate(hdl->video_temporal_filter, active_filter);
+		cx2341x_activate(hdl->video_temporal_filter, active_filter);
 		active_filter = hdl->video_median_filter_type->val !=
 				V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_OFF;
-		v4l2_ctrl_activate(hdl->video_luma_median_filter_bottom, active_filter);
-		v4l2_ctrl_activate(hdl->video_luma_median_filter_top, active_filter);
-		v4l2_ctrl_activate(hdl->video_chroma_median_filter_bottom, active_filter);
-		v4l2_ctrl_activate(hdl->video_chroma_median_filter_top, active_filter);
+		cx2341x_activate(hdl->video_luma_median_filter_bottom, active_filter);
+		cx2341x_activate(hdl->video_luma_median_filter_top, active_filter);
+		cx2341x_activate(hdl->video_chroma_median_filter_bottom, active_filter);
+		cx2341x_activate(hdl->video_chroma_median_filter_top, active_filter);
 		return 0;
 	}
 
@@ -1711,16 +1717,24 @@ int cx2341x_handler_setup(struct cx2341x_handler *cxhdl)
 }
 EXPORT_SYMBOL(cx2341x_handler_setup);
 
+static void cx2341x_grab(struct v4l2_ctrl *ctrl, bool busy)
+{
+	v4l2_ctrl_flags(ctrl, V4L2_CTRL_FLAG_GRABBED,
+			busy ? V4L2_CTRL_FLAG_GRABBED : 0);
+}
+
 void cx2341x_handler_set_busy(struct cx2341x_handler *cxhdl, int busy)
 {
-	v4l2_ctrl_grab(cxhdl->audio_sampling_freq, busy);
-	v4l2_ctrl_grab(cxhdl->audio_encoding, busy);
-	v4l2_ctrl_grab(cxhdl->audio_l2_bitrate, busy);
-	v4l2_ctrl_grab(cxhdl->audio_ac3_bitrate, busy);
-	v4l2_ctrl_grab(cxhdl->stream_vbi_fmt, busy);
-	v4l2_ctrl_grab(cxhdl->stream_type, busy);
-	v4l2_ctrl_grab(cxhdl->video_bitrate_mode, busy);
-	v4l2_ctrl_grab(cxhdl->video_bitrate, busy);
-	v4l2_ctrl_grab(cxhdl->video_bitrate_peak, busy);
+	mutex_lock(&cxhdl->hdl.lock);
+	cx2341x_grab(cxhdl->audio_sampling_freq, busy);
+	cx2341x_grab(cxhdl->audio_encoding, busy);
+	cx2341x_grab(cxhdl->audio_l2_bitrate, busy);
+	cx2341x_grab(cxhdl->audio_ac3_bitrate, busy);
+	cx2341x_grab(cxhdl->stream_vbi_fmt, busy);
+	cx2341x_grab(cxhdl->stream_type, busy);
+	cx2341x_grab(cxhdl->video_bitrate_mode, busy);
+	cx2341x_grab(cxhdl->video_bitrate, busy);
+	cx2341x_grab(cxhdl->video_bitrate_peak, busy);
+	mutex_unlock(&cxhdl->hdl.lock);
 }
 EXPORT_SYMBOL(cx2341x_handler_set_busy);
diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index 0db9092..ae4b299 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -793,7 +793,8 @@ static int saa711x_s_ctrl(struct v4l2_ctrl *ctrl)
 			saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, state->gain->val);
 		else
 			saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, state->gain->val | 0x80);
-		v4l2_ctrl_activate(state->gain, !state->agc->val);
+		v4l2_ctrl_flags(state->gain, V4L2_CTRL_FLAG_INACTIVE,
+				state->agc->val ? V4L2_CTRL_FLAG_INACTIVE : 0);
 		break;
 
 	default:
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 06b9f9f..5c6100f 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -105,6 +105,9 @@ int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
 		    menu_items[ctrl->value][0] == '\0')
 			return -EINVAL;
 	}
+	if (qctrl->type == V4L2_CTRL_TYPE_BITMASK &&
+			(ctrl->value & ~qctrl->maximum))
+		return -ERANGE;
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_ctrl_check);
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 2412f08..e6fa9be 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -23,6 +23,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-dev.h>
 
 /* Internal temporary helper struct, one for each v4l2_ext_control */
@@ -537,6 +538,16 @@ static bool type_is_int(const struct v4l2_ctrl *ctrl)
 	}
 }
 
+static void send_event(struct v4l2_ctrl *ctrl, struct v4l2_event *ev)
+{
+	struct v4l2_ctrl_fh *pos;
+
+	ev->id = ctrl->id;
+	list_for_each_entry(pos, &ctrl->fhs, node) {
+		v4l2_event_queue_fh(pos->fh, ev);
+	}
+}
+
 /* Helper function: copy the current control value back to the caller */
 static int cur_to_user(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl)
@@ -626,20 +637,38 @@ static int new_to_user(struct v4l2_ext_control *c,
 /* Copy the new value to the current value. */
 static void new_to_cur(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_event ev;
+	bool changed = false;
+
 	if (ctrl == NULL)
 		return;
 	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_BUTTON:
+		changed = true;
+		ev.u.ctrl_ch_value.value = 0;
+		break;
 	case V4L2_CTRL_TYPE_STRING:
 		/* strings are always 0-terminated */
+		changed = strcmp(ctrl->string, ctrl->cur.string);
 		strcpy(ctrl->cur.string, ctrl->string);
+		ev.u.ctrl_ch_value.value64 = 0;
 		break;
 	case V4L2_CTRL_TYPE_INTEGER64:
+		changed = ctrl->val64 != ctrl->cur.val64;
 		ctrl->cur.val64 = ctrl->val64;
+		ev.u.ctrl_ch_value.value64 = ctrl->val64;
 		break;
 	default:
+		changed = ctrl->val != ctrl->cur.val;
 		ctrl->cur.val = ctrl->val;
+		ev.u.ctrl_ch_value.value = ctrl->val;
 		break;
 	}
+	if (changed) {
+		ev.type = V4L2_EVENT_CTRL_CH_VALUE;
+		ev.u.ctrl_ch_value.type = ctrl->type;
+		send_event(ctrl, &ev);
+	}
 }
 
 /* Copy the current value to the new value */
@@ -726,6 +755,10 @@ static int validate_new(struct v4l2_ctrl *ctrl)
 			return -EINVAL;
 		return 0;
 
+	case V4L2_CTRL_TYPE_BITMASK:
+		ctrl->val &= ctrl->maximum;
+		return 0;
+
 	case V4L2_CTRL_TYPE_BUTTON:
 	case V4L2_CTRL_TYPE_CTRL_CLASS:
 		ctrl->val64 = 0;
@@ -780,6 +813,7 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 {
 	struct v4l2_ctrl_ref *ref, *next_ref;
 	struct v4l2_ctrl *ctrl, *next_ctrl;
+	struct v4l2_ctrl_fh *ctrl_fh, *next_ctrl_fh;
 
 	if (hdl == NULL || hdl->buckets == NULL)
 		return;
@@ -793,6 +827,10 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 	/* Free all controls owned by the handler */
 	list_for_each_entry_safe(ctrl, next_ctrl, &hdl->ctrls, node) {
 		list_del(&ctrl->node);
+		list_for_each_entry_safe(ctrl_fh, next_ctrl_fh, &ctrl->fhs, node) {
+			list_del(&ctrl_fh->node);
+			kfree(ctrl_fh);
+		}
 		kfree(ctrl);
 	}
 	kfree(hdl->buckets);
@@ -962,13 +1000,17 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 
 	/* Sanity checks */
 	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
-	    max < min ||
 	    (type == V4L2_CTRL_TYPE_INTEGER && step == 0) ||
+	    (type == V4L2_CTRL_TYPE_BITMASK && max == 0) ||
 	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
 	    (type == V4L2_CTRL_TYPE_STRING && max == 0)) {
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
+	if (type != V4L2_CTRL_TYPE_BITMASK && max < min) {
+		handler_set_err(hdl, -ERANGE);
+		return NULL;
+	}
 	if ((type == V4L2_CTRL_TYPE_INTEGER ||
 	     type == V4L2_CTRL_TYPE_MENU ||
 	     type == V4L2_CTRL_TYPE_BOOLEAN) &&
@@ -976,6 +1018,10 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
+	if (type == V4L2_CTRL_TYPE_BITMASK && ((def & ~max) || min || step)) {
+		handler_set_err(hdl, -ERANGE);
+		return NULL;
+	}
 
 	if (type == V4L2_CTRL_TYPE_BUTTON)
 		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -991,6 +1037,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	}
 
 	INIT_LIST_HEAD(&ctrl->node);
+	INIT_LIST_HEAD(&ctrl->fhs);
 	ctrl->handler = hdl;
 	ctrl->ops = ops;
 	ctrl->id = id;
@@ -1158,40 +1205,28 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 }
 EXPORT_SYMBOL(v4l2_ctrl_cluster);
 
-/* Activate/deactivate a control. */
-void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
+void v4l2_ctrl_flags(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags)
 {
+	struct v4l2_event ev;
+
 	if (ctrl == NULL)
 		return;
-
-	if (!active)
-		/* set V4L2_CTRL_FLAG_INACTIVE */
-		set_bit(4, &ctrl->flags);
-	else
-		/* clear V4L2_CTRL_FLAG_INACTIVE */
-		clear_bit(4, &ctrl->flags);
+	ctrl->flags = (ctrl->flags & ~clear_flags) | set_flags;
+	ev.u.ctrl_ch_state.flags = ctrl->flags;
+	ev.type = V4L2_EVENT_CTRL_CH_STATE;
+	send_event(ctrl, &ev);
 }
-EXPORT_SYMBOL(v4l2_ctrl_activate);
+EXPORT_SYMBOL(v4l2_ctrl_flags);
 
-/* Grab/ungrab a control.
-   Typically used when streaming starts and you want to grab controls,
-   preventing the user from changing them.
-
-   Just call this and the framework will block any attempts to change
-   these controls. */
-void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
+void v4l2_ctrl_flags_lock(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags)
 {
 	if (ctrl == NULL)
 		return;
-
-	if (grabbed)
-		/* set V4L2_CTRL_FLAG_GRABBED */
-		set_bit(1, &ctrl->flags);
-	else
-		/* clear V4L2_CTRL_FLAG_GRABBED */
-		clear_bit(1, &ctrl->flags);
+	v4l2_ctrl_lock(ctrl);
+	v4l2_ctrl_flags(ctrl, clear_flags, set_flags);
+	v4l2_ctrl_unlock(ctrl);
 }
-EXPORT_SYMBOL(v4l2_ctrl_grab);
+EXPORT_SYMBOL(v4l2_ctrl_flags_lock);
 
 /* Log the control name and value */
 static void log_ctrl(const struct v4l2_ctrl *ctrl,
@@ -1217,6 +1252,9 @@ static void log_ctrl(const struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_MENU:
 		printk(KERN_CONT "%s", ctrl->qmenu[ctrl->cur.val]);
 		break;
+	case V4L2_CTRL_TYPE_BITMASK:
+		printk(KERN_CONT "0x%x", ctrl->cur.val);
+		break;
 	case V4L2_CTRL_TYPE_INTEGER64:
 		printk(KERN_CONT "%lld", ctrl->cur.val64);
 		break;
@@ -1873,3 +1911,50 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 	return set_ctrl(ctrl, &val);
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
+
+void v4l2_ctrl_add_fh(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_fh *ctrl_fh,
+		struct v4l2_event_subscription *sub)
+{
+	v4l2_ctrl_lock(ctrl);
+	list_add_tail(&ctrl_fh->node, &ctrl->fhs);
+	if (sub->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL) {
+		struct v4l2_event ev;
+
+		ev.type = sub->type;
+		ev.id = ctrl->id;
+		switch (ev.type) {
+		case V4L2_EVENT_CTRL_CH_VALUE:
+			/* TODO: shouldn't be done for write-only or button/ctrl_class
+			   controls. */
+			if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
+				ev.u.ctrl_ch_value.value64 = ctrl->cur.val64;
+			else
+				ev.u.ctrl_ch_value.value = ctrl->cur.val;
+			v4l2_event_queue_fh(ctrl_fh->fh, &ev);
+			break;
+		case V4L2_EVENT_CTRL_CH_STATE:
+			ev.u.ctrl_ch_state.flags = ctrl->flags;
+			v4l2_event_queue_fh(ctrl_fh->fh, &ev);
+		default:
+			break;
+		}
+	}
+	v4l2_ctrl_unlock(ctrl);
+}
+EXPORT_SYMBOL(v4l2_ctrl_add_fh);
+
+void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh)
+{
+	struct v4l2_ctrl_fh *pos;
+
+	v4l2_ctrl_lock(ctrl);
+	list_for_each_entry(pos, &ctrl->fhs, node) {
+		if (pos->fh == fh) {
+			list_del(&pos->node);
+			kfree(pos);
+			break;
+		}
+	}
+	v4l2_ctrl_unlock(ctrl);
+}
+EXPORT_SYMBOL(v4l2_ctrl_del_fh);
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 69fd343..06608e7 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -25,10 +25,13 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-ctrls.h>
 
 #include <linux/sched.h>
 #include <linux/slab.h>
 
+static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
+
 int v4l2_event_init(struct v4l2_fh *fh)
 {
 	fh->events = kzalloc(sizeof(*fh->events), GFP_KERNEL);
@@ -91,7 +94,7 @@ void v4l2_event_free(struct v4l2_fh *fh)
 
 	list_kfree(&events->free, struct v4l2_kevent, list);
 	list_kfree(&events->available, struct v4l2_kevent, list);
-	list_kfree(&events->subscribed, struct v4l2_subscribed_event, list);
+	v4l2_event_unsubscribe_all(fh);
 
 	kfree(events);
 	fh->events = NULL;
@@ -154,9 +157,9 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 }
 EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
 
-/* Caller must hold fh->event->lock! */
+/* Caller must hold fh->vdev->fh_lock! */
 static struct v4l2_subscribed_event *v4l2_event_subscribed(
-	struct v4l2_fh *fh, u32 type)
+		struct v4l2_fh *fh, u32 type, u32 id)
 {
 	struct v4l2_events *events = fh->events;
 	struct v4l2_subscribed_event *sev;
@@ -164,13 +167,46 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 	assert_spin_locked(&fh->vdev->fh_lock);
 
 	list_for_each_entry(sev, &events->subscribed, list) {
-		if (sev->type == type)
+		if (sev->type == type && sev->id == id)
 			return sev;
 	}
 
 	return NULL;
 }
 
+static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
+		const struct timespec *ts)
+{
+	struct v4l2_events *events = fh->events;
+	struct v4l2_subscribed_event *sev;
+	struct v4l2_kevent *kev;
+
+	/* Are we subscribed? */
+	sev = v4l2_event_subscribed(fh, ev->type, ev->id);
+	if (sev == NULL)
+		return;
+
+	/* Increase event sequence number on fh. */
+	events->sequence++;
+
+	/* Do we have any free events? */
+	if (list_empty(&events->free))
+		return;
+
+	/* Take one and fill it. */
+	kev = list_first_entry(&events->free, struct v4l2_kevent, list);
+	kev->event.type = ev->type;
+	kev->event.u = ev->u;
+	kev->event.id = ev->id;
+	kev->event.timestamp = *ts;
+	kev->event.sequence = events->sequence;
+	list_move_tail(&kev->list, &events->available);
+
+	events->navailable++;
+
+	wake_up_all(&events->wait);
+}
+
 void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 {
 	struct v4l2_fh *fh;
@@ -182,37 +218,26 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 
 	list_for_each_entry(fh, &vdev->fh_list, list) {
-		struct v4l2_events *events = fh->events;
-		struct v4l2_kevent *kev;
-
-		/* Are we subscribed? */
-		if (!v4l2_event_subscribed(fh, ev->type))
-			continue;
-
-		/* Increase event sequence number on fh. */
-		events->sequence++;
-
-		/* Do we have any free events? */
-		if (list_empty(&events->free))
-			continue;
-
-		/* Take one and fill it. */
-		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
-		kev->event.type = ev->type;
-		kev->event.u = ev->u;
-		kev->event.timestamp = timestamp;
-		kev->event.sequence = events->sequence;
-		list_move_tail(&kev->list, &events->available);
-
-		events->navailable++;
-
-		wake_up_all(&events->wait);
+		__v4l2_event_queue_fh(fh, ev, &timestamp);
 	}
 
 	spin_unlock_irqrestore(&vdev->fh_lock, flags);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_queue);
 
+void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev)
+{
+	unsigned long flags;
+	struct timespec timestamp;
+
+	ktime_get_ts(&timestamp);
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	__v4l2_event_queue_fh(fh, ev, &timestamp);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+}
+EXPORT_SYMBOL_GPL(v4l2_event_queue_fh);
+
 int v4l2_event_pending(struct v4l2_fh *fh)
 {
 	return fh->events->navailable;
@@ -223,7 +248,9 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 			 struct v4l2_event_subscription *sub)
 {
 	struct v4l2_events *events = fh->events;
-	struct v4l2_subscribed_event *sev;
+	struct v4l2_subscribed_event *sev, *found_ev;
+	struct v4l2_ctrl *ctrl = NULL;
+	struct v4l2_ctrl_fh *ctrl_fh = NULL;
 	unsigned long flags;
 
 	if (fh->events == NULL) {
@@ -231,15 +258,32 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 		return -ENOMEM;
 	}
 
+	if (sub->type == V4L2_EVENT_CTRL_CH_VALUE ||
+			sub->type == V4L2_EVENT_CTRL_CH_STATE) {
+		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
+		if (ctrl == NULL)
+			return -EINVAL;
+	}
+
 	sev = kmalloc(sizeof(*sev), GFP_KERNEL);
 	if (!sev)
 		return -ENOMEM;
+	if (ctrl) {
+		ctrl_fh = kzalloc(sizeof(*ctrl_fh), GFP_KERNEL);
+		if (!ctrl_fh) {
+			kfree(sev);
+			return -ENOMEM;
+		}
+		ctrl_fh->fh = fh;
+	}
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
-	if (v4l2_event_subscribed(fh, sub->type) == NULL) {
+	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
+	if (!found_ev) {
 		INIT_LIST_HEAD(&sev->list);
 		sev->type = sub->type;
+		sev->id = sub->id;
 
 		list_add(&sev->list, &events->subscribed);
 		sev = NULL;
@@ -247,6 +291,10 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
+	/* v4l2_ctrl_add_fh uses a mutex, so do this outside the spin lock */
+	if (!found_ev && ctrl)
+		v4l2_ctrl_add_fh(ctrl, ctrl_fh, sub);
+
 	kfree(sev);
 
 	return 0;
@@ -256,6 +304,7 @@ EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
 static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
 {
 	struct v4l2_events *events = fh->events;
+	struct v4l2_event_subscription sub;
 	struct v4l2_subscribed_event *sev;
 	unsigned long flags;
 
@@ -265,11 +314,13 @@ static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
 		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 		if (!list_empty(&events->subscribed)) {
 			sev = list_first_entry(&events->subscribed,
-				       struct v4l2_subscribed_event, list);
-			list_del(&sev->list);
+					struct v4l2_subscribed_event, list);
+			sub.type = sev->type;
+			sub.id = sev->id;
 		}
 		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-		kfree(sev);
+		if (sev)
+			v4l2_event_unsubscribe(fh, &sub);
 	} while (sev);
 }
 
@@ -286,11 +337,18 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
-	sev = v4l2_event_subscribed(fh, sub->type);
+	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
 	if (sev != NULL)
 		list_del(&sev->list);
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+	if (sev->type == V4L2_EVENT_CTRL_CH_VALUE ||
+			sev->type == V4L2_EVENT_CTRL_CH_STATE) {
+		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
+
+		if (ctrl)
+			v4l2_ctrl_del_fh(ctrl, fh);
+	}
 
 	kfree(sev);
 
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 717f71e..c6aef84 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -32,6 +32,8 @@
 int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 {
 	fh->vdev = vdev;
+	/* Inherit from video_device. May be overridden by the driver. */
+	fh->ctrl_handler = vdev->ctrl_handler;
 	INIT_LIST_HEAD(&fh->list);
 	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
 	fh->prio = V4L2_PRIORITY_UNSET;
@@ -91,10 +93,8 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 {
 	if (fh->vdev == NULL)
 		return;
-
-	fh->vdev = NULL;
-
 	v4l2_event_free(fh);
+	fh->vdev = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 506edcc..75d475c 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1418,7 +1418,9 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_queryctrl *p = arg;
 
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_queryctrl(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_queryctrl(vfd->ctrl_handler, p);
 		else if (ops->vidioc_queryctrl)
 			ret = ops->vidioc_queryctrl(file, fh, p);
@@ -1438,7 +1440,9 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_control *p = arg;
 
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_g_ctrl(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_g_ctrl(vfd->ctrl_handler, p);
 		else if (ops->vidioc_g_ctrl)
 			ret = ops->vidioc_g_ctrl(file, fh, p);
@@ -1470,12 +1474,16 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls ctrls;
 		struct v4l2_ext_control ctrl;
 
-		if (!vfd->ctrl_handler &&
+		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
 			!ops->vidioc_s_ctrl && !ops->vidioc_s_ext_ctrls)
 			break;
 
 		dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
 
+		if (vfh && vfh->ctrl_handler) {
+			ret = v4l2_s_ctrl(vfh->ctrl_handler, p);
+			break;
+		}
 		if (vfd->ctrl_handler) {
 			ret = v4l2_s_ctrl(vfd->ctrl_handler, p);
 			break;
@@ -1501,7 +1509,9 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
 		else if (ops->vidioc_g_ext_ctrls && check_ext_ctrls(p, 0))
 			ret = ops->vidioc_g_ext_ctrls(file, fh, p);
@@ -1515,10 +1525,13 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (!vfd->ctrl_handler && !ops->vidioc_s_ext_ctrls)
+		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
+				!ops->vidioc_s_ext_ctrls)
 			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_s_ext_ctrls(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_s_ext_ctrls(vfd->ctrl_handler, p);
 		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_s_ext_ctrls(file, fh, p);
@@ -1529,10 +1542,13 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (!vfd->ctrl_handler && !ops->vidioc_try_ext_ctrls)
+		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
+				!ops->vidioc_try_ext_ctrls)
 			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_try_ext_ctrls(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
 		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_try_ext_ctrls(file, fh, p);
@@ -1542,7 +1558,9 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_querymenu *p = arg;
 
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_querymenu(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_querymenu(vfd->ctrl_handler, p);
 		else if (ops->vidioc_querymenu)
 			ret = ops->vidioc_querymenu(file, fh, p);
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 3ceacea..d76a81e 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1380,20 +1380,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && q->fileio == NULL) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
-			ret = __vb2_init_fileio(q, 1);
-			if (ret)
-				return POLLERR;
-		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
-			ret = __vb2_init_fileio(q, 0);
-			if (ret)
-				return POLLERR;
-			/*
-			 * Write to OUTPUT queue can be done immediately.
-			 */
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
+			return POLLIN | POLLRDNORM;
+		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
 			return POLLOUT | POLLWRNORM;
-		}
 	}
 
 	/*
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 2238a61..a8d91ce 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -32,6 +32,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-common.h>
 
 #define VIVI_MODULE_NAME "vivi"
@@ -174,6 +175,7 @@ struct vivi_dev {
 	struct v4l2_ctrl	   *int64;
 	struct v4l2_ctrl	   *menu;
 	struct v4l2_ctrl	   *string;
+	struct v4l2_ctrl	   *bitmask;
 
 	spinlock_t                 slock;
 	struct mutex		   mutex;
@@ -488,9 +490,10 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " volume %3d ", dev->volume->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
-	snprintf(str, sizeof(str), " int32 %d, int64 %lld ",
+	snprintf(str, sizeof(str), " int32 %d, int64 %lld, bitmask %08x ",
 			dev->int32->cur.val,
-			dev->int64->cur.val64);
+			dev->int64->cur.val64,
+			dev->bitmask->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " boolean %d, menu %s, string \"%s\" ",
 			dev->boolean->cur.val,
@@ -981,6 +984,18 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
+static int vidioc_subscribe_event(struct v4l2_fh *fh,
+				struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL_CH_VALUE:
+	case V4L2_EVENT_CTRL_CH_STATE:
+		return v4l2_event_subscribe(fh, sub);
+	default:
+		return -EINVAL;
+	}
+}
+
 /* --- controls ---------------------------------------------- */
 
 static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -996,6 +1011,25 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 	File operations for the device
    ------------------------------------------------------------------*/
 
+static int vivi_open(struct file *filp)
+{
+	int ret = v4l2_fh_open(filp);
+	struct v4l2_fh *fh;
+
+	if (ret)
+		return ret;
+	fh = filp->private_data;
+	ret = v4l2_event_init(fh);
+	if (ret)
+		goto rel_fh;
+	ret = v4l2_event_alloc(fh, 10);
+	if (!ret)
+		return ret;
+rel_fh:
+	v4l2_fh_release(filp);
+	return ret;
+}
+
 static ssize_t
 vivi_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
@@ -1010,10 +1044,17 @@ static unsigned int
 vivi_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_fh *fh = file->private_data;
 	struct vb2_queue *q = &dev->vb_vidq;
+	unsigned int res;
 
 	dprintk(dev, 1, "%s\n", __func__);
-	return vb2_poll(q, file, wait);
+	res = vb2_poll(q, file, wait);
+	if (v4l2_event_pending(fh))
+		res |= POLLPRI;
+	else
+		poll_wait(file, &fh->events->wait, wait);
+	return res;
 }
 
 static int vivi_close(struct file *file)
@@ -1117,9 +1158,20 @@ static const struct v4l2_ctrl_config vivi_ctrl_string = {
 	.step = 1,
 };
 
+static const struct v4l2_ctrl_config vivi_ctrl_bitmask = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 6,
+	.name = "Bitmask",
+	.type = V4L2_CTRL_TYPE_BITMASK,
+	.def = 0x80002000,
+	.min = 0,
+	.max = 0x80402010,
+	.step = 0,
+};
+
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
-	.open		= v4l2_fh_open,
+	.open		= vivi_open,
 	.release        = vivi_close,
 	.read           = vivi_read,
 	.poll		= vivi_poll,
@@ -1143,6 +1195,8 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device vivi_template = {
@@ -1219,6 +1273,7 @@ static int __init vivi_create_instance(int inst)
 	dev->boolean = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_boolean, NULL);
 	dev->menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_menu, NULL);
 	dev->string = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_string, NULL);
+	dev->bitmask = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_bitmask, NULL);
 	if (hdl->error) {
 		ret = hdl->error;
 		goto unreg_dev;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 9394b59..df57435 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1047,6 +1047,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_INTEGER64     = 5,
 	V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
 	V4L2_CTRL_TYPE_STRING        = 7,
+	V4L2_CTRL_TYPE_BITMASK       = 8,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
@@ -1933,6 +1934,8 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_ALL				0
 #define V4L2_EVENT_VSYNC			1
 #define V4L2_EVENT_EOS				2
+#define V4L2_EVENT_CTRL_CH_VALUE		3
+#define V4L2_EVENT_CTRL_CH_STATE		4
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -1941,21 +1944,43 @@ struct v4l2_event_vsync {
 	__u8 field;
 } __attribute__ ((packed));
 
+/* Payload for V4L2_EVENT_CTRL_CH_VALUE */
+struct v4l2_event_ctrl_ch_value {
+	__u32 type;
+	union {
+		__s32 value;
+		__s64 value64;
+	};
+} __attribute__ ((packed));
+
+/* Payload for V4L2_EVENT_CTRL_CH_STATE */
+struct v4l2_event_ctrl_ch_state {
+	__u32 type;
+	__u32 flags;
+} __attribute__ ((packed));
+
 struct v4l2_event {
 	__u32				type;
 	union {
 		struct v4l2_event_vsync vsync;
+		struct v4l2_event_ctrl_ch_value ctrl_ch_value;
+		struct v4l2_event_ctrl_ch_state ctrl_ch_state;
 		__u8			data[64];
 	} u;
 	__u32				pending;
 	__u32				sequence;
 	struct timespec			timestamp;
-	__u32				reserved[9];
+	__u32				id;
+	__u32				reserved[8];
 };
 
+#define V4L2_EVENT_SUB_FL_SEND_INITIAL (1 << 0)
+
 struct v4l2_event_subscription {
 	__u32				type;
-	__u32				reserved[7];
+	__u32				id;
+	__u32				flags;
+	__u32				reserved[5];
 };
 
 /*
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 97d0638..27714c9 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -30,6 +30,8 @@ struct v4l2_ctrl_handler;
 struct v4l2_ctrl;
 struct video_device;
 struct v4l2_subdev;
+struct v4l2_event_subscription;
+struct v4l2_fh;
 
 /** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
   * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
@@ -97,6 +99,7 @@ struct v4l2_ctrl_ops {
 struct v4l2_ctrl {
 	/* Administrative fields */
 	struct list_head node;
+	struct list_head fhs;
 	struct v4l2_ctrl_handler *handler;
 	struct v4l2_ctrl **cluster;
 	unsigned ncontrols;
@@ -168,6 +171,11 @@ struct v4l2_ctrl_handler {
 	int error;
 };
 
+struct v4l2_ctrl_fh {
+	struct list_head node;
+	struct v4l2_fh *fh;
+};
+
 /** struct v4l2_ctrl_config - Control configuration structure.
   * @ops:	The control ops.
   * @id:	The control ID.
@@ -372,32 +380,30 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
   */
 struct v4l2_ctrl *v4l2_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
 
-/** v4l2_ctrl_activate() - Make the control active or inactive.
-  * @ctrl:	The control to (de)activate.
-  * @active:	True if the control should become active.
+/** v4l2_ctrl_flags() - Clear and set flags for a control.
+  * @ctrl:	The control whose flags should be changed.
+  * @clear_flags:	Mask out these flags.
+  * @set_flags:	Set these flags.
   *
-  * This sets or clears the V4L2_CTRL_FLAG_INACTIVE flag atomically.
-  * Does nothing if @ctrl == NULL.
-  * This will usually be called from within the s_ctrl op.
+  * This clears and sets flags. Does nothing if @ctrl == NULL.
+  * The V4L2_EVENT_CTRL_CH_STATE event will be generated afterwards.
   *
-  * This function can be called regardless of whether the control handler
-  * is locked or not.
+  * This function expects that the control handler is locked.
   */
-void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
+void v4l2_ctrl_flags(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags);
 
-/** v4l2_ctrl_grab() - Mark the control as grabbed or not grabbed.
-  * @ctrl:	The control to (de)activate.
-  * @grabbed:	True if the control should become grabbed.
+/** v4l2_ctrl_flags_lock() - Clear and set flags for a control.
+  * @ctrl:	The control whose flags should be changed.
+  * @clear_flags:	Mask out these flags.
+  * @set_flags:	Set these flags.
   *
-  * This sets or clears the V4L2_CTRL_FLAG_GRABBED flag atomically.
-  * Does nothing if @ctrl == NULL.
-  * This will usually be called when starting or stopping streaming in the
-  * driver.
+  * This clears and sets flags. Does nothing if @ctrl == NULL.
+  * The V4L2_EVENT_CTRL_CH_STATE event will be generated afterwards.
   *
-  * This function can be called regardless of whether the control handler
-  * is locked or not.
+  * This function expects that the control handler is unlocked and will lock
+  * it before changing flags.
   */
-void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
+void v4l2_ctrl_flags_lock(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags);
 
 /** v4l2_ctrl_lock() - Helper function to lock the handler
   * associated with the control.
@@ -440,6 +446,9 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
   */
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
+void v4l2_ctrl_add_fh(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_fh *ctrl_fh,
+		struct v4l2_event_subscription *sub);
+void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh);
 
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 3b86177..45e9c1e 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -40,6 +40,7 @@ struct v4l2_kevent {
 struct v4l2_subscribed_event {
 	struct list_head	list;
 	u32			type;
+	u32			id;
 };
 
 struct v4l2_events {
@@ -58,6 +59,7 @@ void v4l2_event_free(struct v4l2_fh *fh);
 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 		       int nonblocking);
 void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
+void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
 int v4l2_event_pending(struct v4l2_fh *fh);
 int v4l2_event_subscribe(struct v4l2_fh *fh,
 			 struct v4l2_event_subscription *sub);
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 0206aa5..d247111 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -30,11 +30,13 @@
 
 struct video_device;
 struct v4l2_events;
+struct v4l2_ctrl_handler;
 
 struct v4l2_fh {
 	struct list_head	list;
 	struct video_device	*vdev;
 	struct v4l2_events      *events; /* events, pending and subscribed */
+	struct v4l2_ctrl_handler *ctrl_handler;
 	enum v4l2_priority	prio;
 };
 
-- 
1.7.1

