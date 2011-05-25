Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3185 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab1EYNeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/11] v4l2-ctrls: simplify event subscription.
Date: Wed, 25 May 2011 15:33:52 +0200
Message-Id: <2993c04b0ba330b3f634e281a6b50ee8cd7e6f7c.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   31 +++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h       |   25 +++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index e2a7ac7..9807a20 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -831,6 +831,22 @@ int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_init);
 
+/* Count the number of controls */
+unsigned v4l2_ctrl_handler_cnt(struct v4l2_ctrl_handler *hdl)
+{
+	struct v4l2_ctrl_ref *ref;
+	unsigned cnt = 0;
+
+	if (hdl == NULL)
+		return 0;
+	mutex_lock(&hdl->lock);
+	list_for_each_entry(ref, &hdl->ctrl_refs, node)
+		cnt++;
+	mutex_unlock(&hdl->lock);
+	return cnt;
+}
+EXPORT_SYMBOL(v4l2_ctrl_handler_cnt);
+
 /* Free all controls and control refs */
 void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 {
@@ -1999,3 +2015,18 @@ void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh)
 	v4l2_ctrl_unlock(ctrl);
 }
 EXPORT_SYMBOL(v4l2_ctrl_del_fh);
+
+int v4l2_ctrl_sub_fh(struct v4l2_fh *fh, struct v4l2_event_subscription *sub,
+		     unsigned n)
+{
+	int ret = 0;
+
+	if (!fh->events)
+		ret = v4l2_event_init(fh);
+	if (!ret)
+		ret = v4l2_event_alloc(fh, n);
+	if (!ret)
+		ret = v4l2_event_subscribe(fh, sub);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_ctrl_sub_fh);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 2b99f29..e2b9053 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -252,6 +252,14 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
 			   unsigned nr_of_controls_hint);
 
+/** v4l2_ctrl_handler_cnt() - Count the number of controls in the handler.
+  * @hdl:	The control handler.
+  *
+  * Returns the number of controls referenced by this handler.
+  * Returns 0 if @hdl == NULL.
+  */
+unsigned v4l2_ctrl_handler_cnt(struct v4l2_ctrl_handler *hdl);
+
 /** v4l2_ctrl_handler_free() - Free all controls owned by the handler and free
   * the control list.
   * @hdl:	The control handler.
@@ -446,11 +454,28 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
   */
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
+/* Internal helper functions that deal with control events. */
 void v4l2_ctrl_add_fh(struct v4l2_ctrl_handler *hdl,
 		struct v4l2_ctrl_fh *ctrl_fh,
 		struct v4l2_event_subscription *sub);
 void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh);
 
+/** v4l2_ctrl_sub_fh() - Helper function that subscribes a control event.
+  * @fh:	The file handler that subscribed the control event.
+  * @sub:	The event to subscribe (type must be V4L2_EVENT_CTRL).
+  * @n:		How many events should be allocated? (Passed to v4l2_event_alloc).
+  *		Recommended to set to twice the number of controls plus whatever
+  *		is needed for other events.
+  *
+  * A helper function that initializes the fh for events, allocates the
+  * list of events and subscribes the control event.
+  *
+  * Typically called in the handler of VIDIOC_SUBSCRIBE_EVENT in the
+  * V4L2_EVENT_CTRL case.
+  */
+int v4l2_ctrl_sub_fh(struct v4l2_fh *fh, struct v4l2_event_subscription *sub,
+		     unsigned n);
+
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
-- 
1.7.1

