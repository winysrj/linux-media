Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38640 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1CCPNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 10:13:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org
Subject: [PATCH] v4l2-ctrls: Add transaction support
Date: Thu,  3 Mar 2011 16:13:33 +0100
Message-Id: <1299165213-14014-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some hardware supports controls transactions. For instance, the MT9T001
sensor can optionally shadow registers that influence the output image,
allowing the host to explicitly control the shadow process.

To support such hardware, drivers need to be notified when a control
transation is about to start and when it has finished. Add begin() and
commit() callback functions to the v4l2_ctrl_handler structure to
support such notifications.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-ctrls.c |   42 +++++++++++++++++++++++++++++++++++--
 include/media/v4l2-ctrls.h       |    8 +++++++
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 2412f08..d0e6265 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1264,13 +1264,22 @@ EXPORT_SYMBOL(v4l2_ctrl_handler_log_status);
 int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 {
 	struct v4l2_ctrl *ctrl;
+	unsigned int count = 0;
 	int ret = 0;
 
 	if (hdl == NULL)
 		return 0;
 	mutex_lock(&hdl->lock);
-	list_for_each_entry(ctrl, &hdl->ctrls, node)
+	list_for_each_entry(ctrl, &hdl->ctrls, node) {
 		ctrl->done = false;
+		count++;
+	}
+
+	if (hdl->begin) {
+		ret = hdl->begin(hdl, count == 1);
+		if (ret)
+			goto done;
+	}
 
 	list_for_each_entry(ctrl, &hdl->ctrls, node) {
 		struct v4l2_ctrl *master = ctrl->cluster[0];
@@ -1298,6 +1307,11 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 			if (master->cluster[i])
 				master->cluster[i]->done = true;
 	}
+
+	if (hdl->commit)
+		hdl->commit(hdl, ret != 0);
+
+done:
 	mutex_unlock(&hdl->lock);
 	return ret;
 }
@@ -1717,6 +1731,12 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			return -EBUSY;
 	}
 
+	if (set && hdl->begin) {
+		ret = hdl->begin(hdl, cs->count == 1);
+		if (ret)
+			return ret;
+	}
+
 	for (i = 0; !ret && i < cs->count; i++) {
 		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
 		struct v4l2_ctrl *master = ctrl->cluster[0];
@@ -1747,6 +1767,10 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		v4l2_ctrl_unlock(ctrl);
 		cluster_done(i, cs, helpers);
 	}
+
+	if (set && hdl->commit)
+		hdl->commit(hdl, ret == 0);
+
 	return ret;
 }
 
@@ -1842,8 +1866,20 @@ static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 	ctrl->val = *val;
 	ctrl->is_new = 1;
 	ret = try_or_set_control_cluster(master, false);
-	if (!ret)
-		ret = try_or_set_control_cluster(master, true);
+	if (ret)
+		goto done;
+
+	if (master->handler->begin) {
+		ret = master->handler->begin(master->handler, true);
+		if (ret)
+			goto done;
+	}
+
+	ret = try_or_set_control_cluster(master, true);
+	if (master->handler->commit)
+		master->handler->commit(master->handler, ret != 0);
+
+done:
 	*val = ctrl->cur.val;
 	v4l2_ctrl_unlock(ctrl);
 	return ret;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 97d0638..29acffc 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -157,6 +157,12 @@ struct v4l2_ctrl_ref {
   * @buckets:	Buckets for the hashing. Allows for quick control lookup.
   * @nr_of_buckets: Total number of buckets in the array.
   * @error:	The error code of the first failed control addition.
+  * @begin:	Begin a control set transaction. Called before the first control
+  *		in a group is set. The single argument is true if the group
+  *		contains a single control, and false otherwise.
+  * @commit:	End a control set transaction. Called after the last control
+  * 		in a group is set. The rollback argument is true if an error
+  * 		occured when setting the controls, and false otherwise.
   */
 struct v4l2_ctrl_handler {
 	struct mutex lock;
@@ -166,6 +172,8 @@ struct v4l2_ctrl_handler {
 	struct v4l2_ctrl_ref **buckets;
 	u16 nr_of_buckets;
 	int error;
+	int (*begin)(struct v4l2_ctrl_handler *hdl, bool single);
+	void (*commit)(struct v4l2_ctrl_handler *hdl, bool rollback);
 };
 
 /** struct v4l2_ctrl_config - Control configuration structure.
-- 
Regards,

Laurent Pinchart

