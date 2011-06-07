Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1325 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab1FGPFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 14/18] v4l2-ctrls: simplify event subscription.
Date: Tue,  7 Jun 2011 17:05:19 +0200
Message-Id: <802aafb5bb2f6a0c35ba477b3ced7a070283ef64.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   27 +++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h       |   28 ++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 99987fe..bf649cf 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -862,6 +862,13 @@ int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_init);
 
+/* Count the number of controls */
+unsigned v4l2_ctrl_handler_cnt(const struct v4l2_ctrl_handler *hdl)
+{
+	return hdl ? hdl->nr_of_refs : 0;
+}
+EXPORT_SYMBOL(v4l2_ctrl_handler_cnt);
+
 /* Free all controls and control refs */
 void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 {
@@ -1013,6 +1020,7 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	   insertion is an O(1) operation. */
 	if (list_empty(&hdl->ctrl_refs) || id > node2id(hdl->ctrl_refs.prev)) {
 		list_add_tail(&new_ref->node, &hdl->ctrl_refs);
+		hdl->nr_of_refs++;
 		goto insert_in_hash;
 	}
 
@@ -2061,3 +2069,22 @@ void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh)
 	v4l2_ctrl_unlock(ctrl);
 }
 EXPORT_SYMBOL(v4l2_ctrl_del_fh);
+
+int v4l2_ctrl_subscribe_fh(struct v4l2_fh *fh,
+			struct v4l2_event_subscription *sub, unsigned n)
+{
+	struct v4l2_ctrl_handler *hdl = fh->ctrl_handler;
+	int ret = 0;
+
+	if (!fh->events)
+		ret = v4l2_event_init(fh);
+	if (!ret) {
+		if (v4l2_ctrl_handler_cnt(hdl) * 2 > n)
+			n = v4l2_ctrl_handler_cnt(hdl) * 2;
+		ret = v4l2_event_alloc(fh, n);
+	}
+	if (!ret)
+		ret = v4l2_event_subscribe(fh, sub);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_ctrl_subscribe_fh);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index c45bf40..72dafcf 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -169,6 +169,7 @@ struct v4l2_ctrl_ref {
   *		control is needed multiple times, so this is a simple
   *		optimization.
   * @buckets:	Buckets for the hashing. Allows for quick control lookup.
+  * @nr_of_refs: Total number of control references in the list.
   * @nr_of_buckets: Total number of buckets in the array.
   * @error:	The error code of the first failed control addition.
   */
@@ -178,6 +179,7 @@ struct v4l2_ctrl_handler {
 	struct list_head ctrl_refs;
 	struct v4l2_ctrl_ref *cached;
 	struct v4l2_ctrl_ref **buckets;
+	u16 nr_of_refs;
 	u16 nr_of_buckets;
 	int error;
 };
@@ -263,6 +265,14 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
 			   unsigned nr_of_controls_hint);
 
+/** v4l2_ctrl_handler_cnt() - Count the number of controls in the handler.
+  * @hdl:	The control handler.
+  *
+  * Returns the number of controls referenced by this handler.
+  * Returns 0 if @hdl == NULL.
+  */
+unsigned v4l2_ctrl_handler_cnt(const struct v4l2_ctrl_handler *hdl);
+
 /** v4l2_ctrl_handler_free() - Free all controls owned by the handler and free
   * the control list.
   * @hdl:	The control handler.
@@ -494,11 +504,29 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
   */
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
+/* Internal helper functions that deal with control events. */
 void v4l2_ctrl_add_fh(struct v4l2_ctrl_handler *hdl,
 		struct v4l2_ctrl_fh *ctrl_fh,
 		struct v4l2_event_subscription *sub);
 void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh);
 
+/** v4l2_ctrl_subscribe_fh() - Helper function that subscribes a control event.
+  * @fh:	The file handler that subscribed the control event.
+  * @sub:	The event to subscribe (type must be V4L2_EVENT_CTRL).
+  * @n:		How many events should be allocated? (Passed to v4l2_event_alloc).
+  *		Recommended to set to twice the number of controls plus whatever
+  *		is needed for other events. This function will set n to
+  *		max(n, 2 * v4l2_ctrl_handler_cnt(fh->ctrl_handler)).
+  *
+  * A helper function that initializes the fh for events, allocates the
+  * list of events and subscribes the control event.
+  *
+  * Typically called in the handler of VIDIOC_SUBSCRIBE_EVENT in the
+  * V4L2_EVENT_CTRL case.
+  */
+int v4l2_ctrl_subscribe_fh(struct v4l2_fh *fh,
+			struct v4l2_event_subscription *sub, unsigned n);
+
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
-- 
1.7.1

