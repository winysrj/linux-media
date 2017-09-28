Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:56146 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbdI1JvN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:51:13 -0400
Received: by mail-pf0-f169.google.com with SMTP id r71so601823pfe.12
        for <linux-media@vger.kernel.org>; Thu, 28 Sep 2017 02:51:13 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 4/9] [media] v4l2-ctrls: add support for jobs API
Date: Thu, 28 Sep 2017 18:50:22 +0900
Message-Id: <20170928095027.127173-5-acourbot@chromium.org>
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
References: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add generic support for jobs in the control framework by handling the
new V4L2_CTRL_WHICH_*JOB_VAL which values. This calls the state handler
callbacks in such a case and takes care of control management for
drivers with jobs API support.

Note: this is a very simple and naive way to manage controls in jobs.
Doing this properly will probably require more changes to the control
framework, but the current form is enough to demonstrate the general
ideas.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 50 ++++++++++++++++++++++++++++++++----
 include/media/v4l2-ctrls.h           |  6 +++++
 2 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index dd1db678718c..fcc644a83cf0 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -27,6 +27,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-job-state.h>
 
 #define has_op(master, op) \
 	(master->ops && master->ops->op)
@@ -1603,8 +1604,14 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 
 	/* has_changed is set by cluster_changed */
 	changed = ctrl->has_changed;
-	if (changed)
+	if (changed) {
+		struct v4l2_job_state_handler *state = ctrl->handler->state_handler;
+
+		if (state && state->ops->ctrl_changed)
+			state->ops->ctrl_changed(state, ctrl);
+
 		ptr_to_ptr(ctrl, ctrl->p_new, ctrl->p_cur);
+	}
 
 	if (ch_flags & V4L2_EVENT_CTRL_CH_FLAGS) {
 		/* Note: CH_FLAGS is only set for auto clusters. */
@@ -2738,6 +2745,8 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		if (cs->which &&
 		    cs->which != V4L2_CTRL_WHICH_DEF_VAL &&
+		    cs->which != V4L2_CTRL_WHICH_CURJOB_VAL &&
+		    cs->which != V4L2_CTRL_WHICH_DEQJOB_VAL &&
 		    V4L2_CTRL_ID2WHICH(id) != cs->which)
 			return -EINVAL;
 
@@ -2817,7 +2826,9 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
    whether there are any controls at all. */
 static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
 {
-	if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL)
+	if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL ||
+	    which == V4L2_CTRL_WHICH_CURJOB_VAL ||
+	    which == V4L2_CTRL_WHICH_DEQJOB_VAL)
 		return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
 	return find_ref_lock(hdl, which | 1) ? 0 : -EINVAL;
 }
@@ -2829,11 +2840,14 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
+	struct v4l2_job_state_handler *state;
 	int ret;
 	int i, j;
-	bool def_value;
+	bool def_value, job_value;
 
 	def_value = (cs->which == V4L2_CTRL_WHICH_DEF_VAL);
+	job_value = (cs->which == V4L2_CTRL_WHICH_DEQJOB_VAL ||
+		     cs->which == V4L2_CTRL_WHICH_CURJOB_VAL);
 
 	cs->error_idx = cs->count;
 	cs->which = V4L2_CTRL_ID2WHICH(cs->which);
@@ -2841,6 +2855,10 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	if (hdl == NULL)
 		return -EINVAL;
 
+	state = hdl->state_handler;
+	if (!state && job_value)
+		return -EINVAL;
+
 	if (cs->count == 0)
 		return class_check(hdl, cs->which);
 
@@ -2874,18 +2892,20 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		v4l2_ctrl_lock(master);
 
 		/* g_volatile_ctrl will update the new control values */
-		if (!def_value &&
+		if (!def_value && !job_value &&
 		    ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
 		    (master->has_volatiles && !is_cur_manual(master)))) {
 			for (j = 0; j < master->ncontrols; j++)
 				cur_to_new(master->cluster[j]);
 			ret = call_op(master, g_volatile_ctrl);
 			ctrl_to_user = new_to_user;
+		} else if (job_value) {
+			ret = state->ops->g_ctrl(state, master->id, cs->controls + i, cs->which);
 		}
 		/* If OK, then copy the current (for non-volatile controls)
 		   or the new (for volatile controls) control values to the
 		   caller */
-		if (!ret) {
+		if (!ret && !job_value) {
 			u32 idx = i;
 
 			do {
@@ -3008,6 +3028,7 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
 	/* Don't set if there is no change */
 	if (ret || !set || !cluster_changed(master))
 		return ret;
+
 	ret = call_op(master, s_ctrl);
 	if (ret)
 		return ret;
@@ -3082,6 +3103,8 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
+	struct v4l2_job_state_handler *state;
+	bool job_value;
 	unsigned i, j;
 	int ret;
 
@@ -3096,6 +3119,14 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	if (hdl == NULL)
 		return -EINVAL;
 
+	if (cs->which == V4L2_CTRL_WHICH_DEQJOB_VAL)
+		return -EINVAL;
+
+	job_value = (cs->which == V4L2_CTRL_WHICH_CURJOB_VAL);
+	state = hdl->state_handler;
+	if (!state && job_value)
+		return -EINVAL;
+
 	if (cs->count == 0)
 		return class_check(hdl, cs->which);
 
@@ -3121,6 +3152,15 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		master = helpers[i].mref->ctrl;
 		v4l2_ctrl_lock(master);
 
+		if (job_value) {
+			ret = state->ops->s_ctrl(state, cs->controls + idx);
+			v4l2_ctrl_unlock(master);
+			if (ret)
+				return ret;
+			continue;
+		}
+
+
 		/* Reset the 'is_new' flags of the cluster */
 		for (j = 0; j < master->ncontrols; j++)
 			if (master->cluster[j])
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 2d2aed56922f..da3eb69d1af1 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -21,8 +21,11 @@
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 
+#include <media/v4l2-jobqueue.h>
+
 /* forward references */
 struct file;
+struct v4l2_job_state_handler;
 struct v4l2_ctrl_handler;
 struct v4l2_ctrl_helper;
 struct v4l2_ctrl;
@@ -72,6 +75,7 @@ struct v4l2_ctrl_ops {
 	int (*s_ctrl)(struct v4l2_ctrl *ctrl);
 };
 
+
 /**
  * struct v4l2_ctrl_type_ops - The control type operations that the driver
  *			       has to provide.
@@ -257,6 +261,7 @@ struct v4l2_ctrl_ref {
  *	controls: both the controls owned by the handler and those inherited
  *	from other handlers.
  *
+ * @state_handler: State handler to use when jobs API is in use.
  * @_lock:	Default for "lock".
  * @lock:	Lock to control access to this handler and its controls.
  *		May be replaced by the user right after init.
@@ -275,6 +280,7 @@ struct v4l2_ctrl_ref {
  * @error:	The error code of the first failed control addition.
  */
 struct v4l2_ctrl_handler {
+	struct v4l2_job_state_handler *state_handler;
 	struct mutex _lock;
 	struct mutex *lock;
 	struct list_head ctrls;
-- 
2.14.2.822.g60be5d43e6-goog
