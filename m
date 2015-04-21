Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39106 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbbDUNFZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:05:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 07/15] v4l2-ctrls: implement delete request(s)
Date: Tue, 21 Apr 2015 14:58:50 +0200
Message-Id: <1429621138-17213-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 42 ++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |  1 +
 2 files changed, 43 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 93c51cc..43fb3c2 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3566,6 +3566,48 @@ unlock:
 }
 EXPORT_SYMBOL(v4l2_ctrl_apply_request);
 
+int v4l2_ctrl_delete_request(struct v4l2_ctrl_handler *hdl, unsigned request)
+{
+	struct v4l2_ctrl_ref *ref;
+	unsigned i;
+
+	if (hdl == NULL || request == 0)
+		return -EINVAL;
+
+	mutex_lock(hdl->lock);
+
+	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
+		struct v4l2_ctrl *master;
+
+		if (ref->ctrl->max_reqs == 0)
+			continue;
+		master = ref->ctrl->cluster[0];
+		if (ref->ctrl != master)
+			continue;
+		if (master->handler != hdl)
+			v4l2_ctrl_lock(master);
+		for (i = 0; i < master->ncontrols; i++) {
+			struct v4l2_ctrl *ctrl = master->cluster[i];
+			struct v4l2_ctrl_req *req;
+
+			if (ctrl == NULL || ctrl->request_lists == NULL)
+				continue;
+
+			if (request == 0) {
+				free_requests(ctrl);
+				continue;
+			}
+			req = get_request(ctrl, request);
+			if (req)
+				del_request(ctrl, req);
+		}
+		if (master->handler != hdl)
+			v4l2_ctrl_unlock(master);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_ctrl_delete_request);
+
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
 {
 	if (ctrl == NULL)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 2d188a2..324db6d 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -810,6 +810,7 @@ static inline void v4l2_ctrl_s_max_reqs(struct v4l2_ctrl *ctrl, u16 max_reqs)
 }
 
 int v4l2_ctrl_apply_request(struct v4l2_ctrl_handler *hdl, unsigned request);
+int v4l2_ctrl_delete_request(struct v4l2_ctrl_handler *hdl, unsigned request);
 
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
-- 
2.1.4

