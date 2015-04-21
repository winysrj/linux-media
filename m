Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:42069 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbbDUNFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:05:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 14/15] v4l2-ctrls: add REQ_KEEP flag
Date: Tue, 21 Apr 2015 14:58:57 +0200
Message-Id: <1429621138-17213-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Experimental: I am still not certain whether this is desired or not.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c  | 28 ++++++++++++++++++++--------
 drivers/media/v4l2-core/v4l2-ioctl.c  |  9 ++++++++-
 drivers/media/v4l2-core/v4l2-subdev.c | 11 ++++++++++-
 include/media/v4l2-ctrls.h            |  3 +++
 include/media/v4l2-fh.h               |  3 +++
 include/uapi/linux/videodev2.h        |  4 ++++
 6 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d262e2e..480bdb6 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2693,6 +2693,8 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 	if (req) {
 		if (ctrl_req->applied)
 			qc->flags |= V4L2_CTRL_FLAG_REQ_APPLIED;
+		if (ctrl_req->keep)
+			qc->flags |= V4L2_CTRL_FLAG_REQ_KEEP;
 	}
 	qc->max_reqs = ctrl->max_reqs;
 	qc->type = ctrl->type;
@@ -3148,7 +3150,7 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl_int64);
    copied to the current value on a set.
    Must be called with ctrl->handler->lock held. */
 static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
-			      u16 request, bool set, u32 ch_flags)
+			      u16 request, bool keep, bool set, u32 ch_flags)
 {
 	bool update_flag;
 	int ret;
@@ -3172,6 +3174,8 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
 				if (ret)
 					return ret;
 			}
+			if (set)
+				req->keep = keep;
 		}
 		ctrl->request = req;
 		if (!ctrl->is_new) {
@@ -3272,14 +3276,17 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
 	unsigned request = 0;
+	bool keep = false;
 	unsigned i, j;
 	int ret;
 
 	cs->error_idx = cs->count;
-	if (V4L2_CTRL_ID2CLASS(cs->ctrl_class))
+	if (V4L2_CTRL_ID2CLASS(cs->ctrl_class)) {
 		cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
-	else
+	} else {
 		request = cs->request;
+		keep = set && (cs->request & V4L2_CTRL_REQ_FL_KEEP);
+	}
 
 	if (hdl == NULL || request > USHRT_MAX)
 		return -EINVAL;
@@ -3351,7 +3358,8 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_cluster(fh, master, request, set, 0);
+			ret = try_or_set_cluster(fh, master, request,
+						 keep, set, 0);
 
 		/* Copy the new values back to userspace. */
 		if (!ret) {
@@ -3423,7 +3431,7 @@ static int set_ctrl(struct v4l2_fh *fh, unsigned request,
 		update_from_auto_cluster(master);
 
 	ctrl->is_new = 1;
-	return try_or_set_cluster(fh, master, request, true, ch_flags);
+	return try_or_set_cluster(fh, master, request, false, true, ch_flags);
 }
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
@@ -3517,6 +3525,7 @@ int v4l2_ctrl_apply_request(struct v4l2_ctrl_handler *hdl, unsigned request)
 	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
 		struct v4l2_ctrl *master;
 		bool apply_request = false;
+		bool keep = false;
 
 		if (ref->ctrl->max_reqs == 0)
 			continue;
@@ -3535,9 +3544,11 @@ int v4l2_ctrl_apply_request(struct v4l2_ctrl_handler *hdl, unsigned request)
 			if (ctrl->request == NULL)
 				continue;
 			found_request = true;
-			if (!ctrl->request->applied) {
+			if (ctrl->request->keep || !ctrl->request->applied) {
 				request_to_new(master->cluster[i]);
 				apply_request = true;
+				if (ctrl->request->keep)
+					keep = true;
 				ctrl->request->applied = 1;
 			}
 		}
@@ -3548,7 +3559,8 @@ int v4l2_ctrl_apply_request(struct v4l2_ctrl_handler *hdl, unsigned request)
 		}
 
 		/*
-		 * Skip if it is a request that has already been applied.
+		 * Skip if it is a one-off request that has already been
+		 * applied.
 		 */
 		if (!apply_request)
 			goto unlock;
@@ -3569,7 +3581,7 @@ int v4l2_ctrl_apply_request(struct v4l2_ctrl_handler *hdl, unsigned request)
 				update_from_auto_cluster(master);
 		}
 
-		try_or_set_cluster(NULL, master, 0, true, 0);
+		try_or_set_cluster(NULL, master, 0, keep, true, 0);
 
 unlock:
 		if (master->handler != hdl)
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 44c33f3..503354a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1833,8 +1833,11 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler) {
-		if (vfh->request && p->request == 0)
+		if (vfh->request && p->request == 0) {
 			p->request = vfh->request;
+			if (vfh->flags & V4L2_FH_FL_KEEP)
+				p->request |= V4L2_CTRL_REQ_FL_KEEP;
+		}
 		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
 	}
 	if (vfd->ctrl_handler)
@@ -1988,6 +1991,10 @@ static int v4l_request_cmd(const struct v4l2_ioctl_ops *ops,
 		if (p->request == 0)
 			return -EINVAL;
 		vfh->request = p->request;
+		if (p->flags & V4L2_REQ_CMD_BEGIN_FL_KEEP)
+			vfh->flags |= V4L2_FH_FL_KEEP;
+		else
+			vfh->flags &= ~V4L2_FH_FL_KEEP;
 		break;
 	case V4L2_REQ_CMD_END:
 		vfh->request = 0;
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 7113b95..5fe41c9 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -212,14 +212,19 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 		if (vfh->request && p->request == 0)
 			p->request = vfh->request;
+		else if (p->request > USHRT_MAX)
+			return -EINVAL;
 		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
 	}
 
 	case VIDIOC_S_EXT_CTRLS: {
 		struct v4l2_ext_controls *p = arg;
 
-		if (vfh->request && p->request == 0)
+		if (vfh->request && p->request == 0) {
 			p->request = vfh->request;
+			if (vfh->flags & V4L2_FH_FL_KEEP)
+				p->request |= V4L2_CTRL_REQ_FL_KEEP;
+		}
 		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
 	}
 
@@ -256,6 +261,10 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			if (p->request == 0)
 				return -EINVAL;
 			vfh->request = p->request;
+			if (p->flags & V4L2_REQ_CMD_BEGIN_FL_KEEP)
+				vfh->flags |= V4L2_FH_FL_KEEP;
+			else
+				vfh->flags &= ~V4L2_FH_FL_KEEP;
 			break;
 		case V4L2_REQ_CMD_END:
 			vfh->request = 0;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index efba887..7a028e0 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -36,6 +36,8 @@ struct v4l2_subscribed_event;
 struct v4l2_fh;
 struct poll_table_struct;
 
+#define V4L2_CTRL_REQ_FL_KEEP (1UL << 31)
+
 /** union v4l2_ctrl_ptr - A pointer to a control value.
  * @p_s32:	Pointer to a 32-bit signed value.
  * @p_s64:	Pointer to a 64-bit signed value.
@@ -95,6 +97,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
 struct v4l2_ctrl_req {
 	struct list_head node;
 	u32 request;
+	unsigned keep:1;
 	unsigned applied:1;
 	union v4l2_ctrl_ptr ptr;
 };
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 652202f..bee0754 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -33,6 +33,8 @@
 struct video_device;
 struct v4l2_ctrl_handler;
 
+#define V4L2_FH_FL_KEEP	(1 << 0)
+
 struct v4l2_fh {
 	struct list_head	list;
 	struct video_device	*vdev;
@@ -46,6 +48,7 @@ struct v4l2_fh {
 	unsigned int		navailable;
 	u32			sequence;
 	u16			request;
+	u16			flags;
 
 #if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
 	struct v4l2_m2m_ctx	*m2m_ctx;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index f3164f6..b2cbf3f 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1472,6 +1472,7 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
 #define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x0200
 #define V4L2_CTRL_FLAG_REQ_APPLIED	0x0400
+#define V4L2_CTRL_FLAG_REQ_KEEP		0x0800
 
 /*  Query flags, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
@@ -2091,6 +2092,9 @@ struct v4l2_create_buffers {
 #define V4L2_REQ_CMD_APPLY	(3)
 #define V4L2_REQ_CMD_QUEUE	(4)
 
+/* Flag for V4L2_REQ_CMD_BEGIN */
+#define V4L2_REQ_CMD_BEGIN_FL_KEEP	(1 << 0)
+
 struct v4l2_request_cmd {
 	__u32 cmd;
 	__u16 request;
-- 
2.1.4

