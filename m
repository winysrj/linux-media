Return-path: <mchehab@pedra>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56397 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1DDLwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:52:24 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p34BqDrn001853
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 11:52:23 GMT
Received: from cobaltpc1.rd.tandberg.com (cobaltpc1.rd.tandberg.com [10.47.3.155])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p34BqDdP009325
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 13:52:14 +0200
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 9/9] v4l2-ctrls: add new SEND_INITIAL flag to force an initial event.
Date: Mon,  4 Apr 2011 13:51:54 +0200
Message-Id: <ac7379a780ef077caaea23b7fe844d66e9783f70.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
References: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   25 ++++++++++++++++++++++++-
 drivers/media/video/v4l2-event.c |    2 +-
 include/linux/videodev2.h        |    5 ++++-
 include/media/v4l2-ctrls.h       |    4 +++-
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 122c6da..e6fa9be 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1912,10 +1912,33 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
-void v4l2_ctrl_add_fh(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_fh *ctrl_fh)
+void v4l2_ctrl_add_fh(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_fh *ctrl_fh,
+		struct v4l2_event_subscription *sub)
 {
 	v4l2_ctrl_lock(ctrl);
 	list_add_tail(&ctrl_fh->node, &ctrl->fhs);
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
 	v4l2_ctrl_unlock(ctrl);
 }
 EXPORT_SYMBOL(v4l2_ctrl_add_fh);
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 9b503aa..06608e7 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -293,7 +293,7 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 
 	/* v4l2_ctrl_add_fh uses a mutex, so do this outside the spin lock */
 	if (!found_ev && ctrl)
-		v4l2_ctrl_add_fh(ctrl, ctrl_fh);
+		v4l2_ctrl_add_fh(ctrl, ctrl_fh, sub);
 
 	kfree(sev);
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index eb56685..2a20dd9 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1827,10 +1827,13 @@ struct v4l2_event {
 	__u32				reserved[8];
 };
 
+#define V4L2_EVENT_SUB_FL_SEND_INITIAL (1 << 0)
+
 struct v4l2_event_subscription {
 	__u32				type;
 	__u32				id;
-	__u32				reserved[6];
+	__u32				flags;
+	__u32				reserved[5];
 };
 
 /*
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index e6917f4..27714c9 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -30,6 +30,7 @@ struct v4l2_ctrl_handler;
 struct v4l2_ctrl;
 struct video_device;
 struct v4l2_subdev;
+struct v4l2_event_subscription;
 struct v4l2_fh;
 
 /** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
@@ -445,7 +446,8 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
   */
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
-void v4l2_ctrl_add_fh(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_fh *ctrl_fh);
+void v4l2_ctrl_add_fh(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_fh *ctrl_fh,
+		struct v4l2_event_subscription *sub);
 void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh);
 
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
-- 
1.7.1

