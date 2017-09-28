Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:54876 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752485AbdI1JvQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:51:16 -0400
Received: by mail-pg0-f51.google.com with SMTP id c137so656039pga.11
        for <linux-media@vger.kernel.org>; Thu, 28 Sep 2017 02:51:16 -0700 (PDT)
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
Subject: [RFC PATCH 5/9] [media] v4l2-job: add generic jobs ops
Date: Thu, 28 Sep 2017 18:50:23 +0900
Message-Id: <20170928095027.127173-6-acourbot@chromium.org>
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
References: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a generic state handler that records controls to be set for a given
job and applies them once the job is scheduled, while also allowing said
controls to be read back once the job is dequeued.

This implementation can be used as-is for most drivers, with only drivers
with specific needs needing to provide an alternative implementation.

Note: this is still very early, but should do the job to demonstrate the
jobs API feasibility. Amongst the current limitations:

- We use v4l2_ext_control to store controls, which expects user-space
pointers. As a consequence only integer controls are supported at the
moment.
- No support for try_ctrl yet.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/Makefile           |   3 +-
 drivers/media/v4l2-core/v4l2-job-generic.c | 394 +++++++++++++++++++++++++++++
 include/media/v4l2-job-generic.h           |  47 ++++
 3 files changed, 443 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-job-generic.c
 create mode 100644 include/media/v4l2-job-generic.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index a717bb8f1a25..ee09e1f29129 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -6,7 +6,8 @@ tuner-objs	:=	tuner-core.o
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
 			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
-			v4l2-async.o v4l2-jobqueue.o v4l2-jobqueue-dev.o
+			v4l2-async.o v4l2-jobqueue.o v4l2-jobqueue-dev.o \
+			v4l2-job-generic.o
 
 ifeq ($(CONFIG_COMPAT),y)
   videodev-objs += v4l2-compat-ioctl32.o
diff --git a/drivers/media/v4l2-core/v4l2-job-generic.c b/drivers/media/v4l2-core/v4l2-job-generic.c
new file mode 100644
index 000000000000..ded6464e723a
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-job-generic.c
@@ -0,0 +1,394 @@
+/*
+    V4L2 generic jobs implementation
+
+    Copyright (C) 2017  The Chromium project
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+ */
+
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+
+#include <media/v4l2-job-generic.h>
+#include <media/v4l2-jobqueue.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-dev.h>
+#include <linux/videodev2.h>
+
+#define to_generic_state_handler(hdl) \
+	container_of(hdl, struct v4l2_generic_state_handler, base)
+
+struct v4l2_generic_job_state {
+	struct v4l2_job_state base;
+	struct list_head node;
+
+	int nr_ctrls;
+	struct v4l2_ext_control ctrls[0];
+};
+#define to_generic_job_state(job) \
+	container_of(job, struct v4l2_generic_job_state, base)
+
+/* TODO this is O(n). Find a better way to store/lookup controls */
+static struct v4l2_ext_control *
+v4l2_generic_job_find_control(struct v4l2_generic_job_state *job, u32 id)
+{
+	int i;
+
+	for (i = 0; i < job->nr_ctrls; i++)
+		if (job->ctrls[i].id == id)
+			return &job->ctrls[i];
+
+	return NULL;
+}
+
+static struct v4l2_job_state *
+v4l2_job_generic_job_new(struct v4l2_job_state_handler *_hdl)
+{
+	struct v4l2_generic_state_handler *hdl = to_generic_state_handler(_hdl);
+	struct v4l2_generic_job_state *ret;
+
+	ret = kzalloc(sizeof(*ret) + sizeof(ret->ctrls[0]) * hdl->nr_ctrls,
+		      GFP_KERNEL);
+	if (ret == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	return &ret->base;
+}
+
+static void v4l2_job_generic_job_free(struct v4l2_job_state_handler *hdl,
+					struct v4l2_job_state *_job)
+{
+	struct v4l2_generic_job_state *job = to_generic_job_state(_job);
+
+	kfree(job);
+}
+
+static int v4l2_job_generic_job_apply(struct v4l2_job_state_handler *_hdl)
+{
+	struct v4l2_generic_state_handler *hdl = to_generic_state_handler(_hdl);
+	struct v4l2_generic_job_state *job;
+	struct v4l2_ext_controls ctrls;
+	int ret;
+
+	job = to_generic_job_state(_hdl->active_state);
+
+	if (job->nr_ctrls == 0)
+		return 0;
+
+	ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
+	ctrls.count = job->nr_ctrls;
+	ctrls.controls = job->ctrls;
+
+	ret = v4l2_s_ext_ctrls(hdl->fh, hdl->ctrl_hdl, &ctrls);
+	if (ret) {
+		pr_err("Cannot set job controls: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int v4l2_job_generic_s_ctrl(struct v4l2_job_state_handler *_hdl,
+				   struct v4l2_ext_control *c)
+{
+	struct v4l2_generic_state_handler *hdl = to_generic_state_handler(_hdl);
+	struct v4l2_generic_job_state *job;
+	struct v4l2_ext_control *ctrl = NULL;
+
+	job = to_generic_job_state(_hdl->current_state);
+
+	ctrl = v4l2_generic_job_find_control(job, c->id);
+	if (!ctrl)
+		ctrl = &job->ctrls[job->nr_ctrls++];
+
+	/* This should never happen as we allocate exactly enough space for
+	 * all the controls of our device */
+	BUG_ON(job->nr_ctrls > hdl->nr_ctrls);
+
+	/* TODO manage pointers, do a try, etc */
+	ctrl->id = c->id;
+	ctrl->value = c->value;
+
+	return 0;
+}
+
+/*
+ * Try to read the control value from the passed job, then its parents, then
+ * the hardware if none has defined a state.
+ */
+static int
+v4l2_job_generic_g_ctrl_locked(struct v4l2_generic_state_handler *hdl,
+			       struct v4l2_generic_job_state *job, u32 ctrl_id,
+			       struct v4l2_ext_control *c, bool upward)
+{
+	struct v4l2_ext_control *ctrl;
+	struct list_head *node;
+
+	if (job == NULL || &job->base == hdl->base.active_state) {
+		struct v4l2_control ctrl = {
+			.id = ctrl_id,
+		};
+		int ret;
+
+		/* TODO terrible! */
+		mutex_unlock(hdl->ctrl_hdl->lock);
+		ret = v4l2_g_ctrl(hdl->ctrl_hdl, &ctrl);
+		mutex_lock(hdl->ctrl_hdl->lock);
+		if (ret < 0)
+			return ret;
+
+		c->value = ctrl.value;
+
+		return 0;
+	}
+
+	ctrl = v4l2_generic_job_find_control(job, ctrl_id);
+	if (ctrl) {
+		/* TODO handle pointers, etc. */
+		c->value = ctrl->value;
+		return 0;
+	}
+
+	if (upward)
+		node = job->node.prev;
+	else
+		node = job->node.next;
+
+	/* That was our last job, request hardware state */
+	if (node == &hdl->jobs)
+		job = NULL;
+	else
+		job = container_of(node, struct v4l2_generic_job_state, node);
+	return v4l2_job_generic_g_ctrl_locked(hdl, job, ctrl_id, c, upward);
+}
+
+static int
+v4l2_job_generic_g_ctrl(struct v4l2_job_state_handler *_hdl, u32 ctrl_id,
+			struct v4l2_ext_control *c, u32 which)
+{
+	struct v4l2_jobqueue *jq = _hdl->jobqueue;
+	struct v4l2_generic_state_handler *hdl = to_generic_state_handler(_hdl);
+	struct v4l2_job_state *_job;
+	struct v4l2_generic_job_state *job;
+	bool upward;
+	int ret;
+
+	if (which != V4L2_CTRL_WHICH_CURJOB_VAL &&
+	    which != V4L2_CTRL_WHICH_DEQJOB_VAL)
+		return -EINVAL;
+
+	v4l2_jobqueue_lock(jq);
+
+	if (which == V4L2_CTRL_WHICH_DEQJOB_VAL) {
+		_job = hdl->base.dequeued_state;
+		upward = true;
+	} else {
+		_job = hdl->base.current_state;
+		upward = false;
+	}
+	if (!_job) {
+		pr_err("No state to query controls from!\n");
+		return -EINVAL;
+	}
+
+	job = to_generic_job_state(_job);
+
+	ret = v4l2_job_generic_g_ctrl_locked(hdl, job, ctrl_id, c, upward);
+
+	v4l2_jobqueue_unlock(jq);
+
+	return ret;
+}
+
+static void v4l2_job_generic_job_complete(struct v4l2_job_state_handler *_hdl)
+{
+	struct v4l2_generic_state_handler *hdl = to_generic_state_handler(_hdl);
+	struct v4l2_generic_job_state *job;
+	struct v4l2_ext_controls cs;
+	struct v4l2_ext_control ctrls[hdl->nr_vol_ctrls];
+	int ret;
+	int i;
+
+	/* We need to update all volatile controls, if any */
+	if (hdl->nr_vol_ctrls == 0)
+		return;
+
+	job = to_generic_job_state(_hdl->active_state);
+
+	memset(job->ctrls, 0, sizeof(job->ctrls[0]) * hdl->nr_ctrls);
+
+	for (i = 0; i < hdl->nr_vol_ctrls; i++)
+		job->ctrls[i].id = hdl->ctrls_ids[i];
+
+	cs.which = V4L2_CTRL_WHICH_CUR_VAL;
+	cs.count = hdl->nr_vol_ctrls;
+	cs.controls = ctrls;
+
+	ret = v4l2_g_ext_ctrls(hdl->ctrl_hdl, &cs);
+	if (ret < 0) {
+		pr_err("Cannot read output controls: %d\n", ret);
+		return;
+	}
+
+	for (i = 0; i < cs.count; i++) {
+		ret = v4l2_job_generic_s_ctrl(_hdl, &ctrls[i]);
+		if (ret < 0)
+			pr_err("Cannot update volatile control value!\n");
+	}
+}
+
+static void v4l2_job_generic_state_changed(struct v4l2_job_state_handler *_hdl,
+					   struct v4l2_job_state *_job,
+					   enum v4l2_job_status status)
+{
+	struct v4l2_generic_state_handler *hdl = to_generic_state_handler(_hdl);
+	struct v4l2_generic_job_state *job = to_generic_job_state(_job);
+
+	switch (status) {
+	case CURRENT:
+		list_add(&job->node, &hdl->jobs);
+		break;
+	case COMPLETED:
+		hdl->last_completed = job;
+		break;
+	case OUT_OF_QUEUE:
+		list_del(&job->node);
+		if (hdl->last_completed == job)
+			hdl->last_completed = NULL;
+		break;
+	default:
+		break;
+	}
+}
+
+static void v4l2_job_generic_ctrl_changed(struct v4l2_job_state_handler *_hdl,
+					  struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_jobqueue *jq = _hdl->jobqueue;
+	struct v4l2_generic_state_handler *hdl = to_generic_state_handler(_hdl);
+	struct v4l2_generic_job_state *job;
+	struct v4l2_ext_control *ext_ctrl;
+
+	/* prevent the job queue from changing state */
+	v4l2_jobqueue_lock(jq);
+
+	job = hdl->last_completed;
+
+	if (!job)
+		goto out;
+
+	/* store the current value of the control into the job so it reflects
+	 * the state at the time it completed */
+	ext_ctrl = v4l2_generic_job_find_control(job, ctrl->id);
+	/* we already have a completion value stored, nothing to do */
+	if (ext_ctrl)
+		goto out;
+
+	ext_ctrl = &job->ctrls[job->nr_ctrls++];
+	ext_ctrl->id = ctrl->id;
+	ext_ctrl->value = ctrl->cur.val;
+
+out:
+	v4l2_jobqueue_unlock(jq);
+}
+
+static int v4l2_job_generic_job_export(struct v4l2_job_state_handler *_hdl)
+{
+	struct v4l2_generic_state_handler *hdl = to_generic_state_handler(_hdl);
+	struct v4l2_generic_job_state *job;
+	struct v4l2_ctrl_handler *ctrl_hdl = hdl->ctrl_hdl;
+	struct v4l2_ctrl *ctrl;
+
+	job = to_generic_job_state(_hdl->current_state);
+
+	/*
+	 * Read and store all controls, so the full state can be reapplied
+	 * when we reuse this state
+	 */
+	mutex_lock(ctrl_hdl->lock);
+
+	list_for_each_entry(ctrl, &ctrl_hdl->ctrls, node) {
+		/* dummy */
+		struct v4l2_ext_control c;
+
+		if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
+			continue;
+
+		c.id = ctrl->id;
+		/* get the current value either from the HW or a parent state */
+		v4l2_job_generic_g_ctrl_locked(hdl, job, ctrl->id, &c, false);
+		/* ... and store it */
+		v4l2_job_generic_s_ctrl(&hdl->base, &c);
+	}
+
+	mutex_unlock(ctrl_hdl->lock);
+
+	return 0;
+}
+
+static const struct v4l2_job_state_handler_ops v4l2_generic_job_ops = {
+	.job_new = v4l2_job_generic_job_new,
+	.job_free = v4l2_job_generic_job_free,
+	.job_apply = v4l2_job_generic_job_apply,
+	.job_complete = v4l2_job_generic_job_complete,
+	.job_export = v4l2_job_generic_job_export,
+
+	.s_ctrl = v4l2_job_generic_s_ctrl,
+	.g_ctrl = v4l2_job_generic_g_ctrl,
+
+	.state_changed = v4l2_job_generic_state_changed,
+	.ctrl_changed = v4l2_job_generic_ctrl_changed,
+};
+
+int v4l2_job_generic_init(struct v4l2_generic_state_handler *hdl,
+		    void (*process_active_job)(struct v4l2_job_state_handler *),
+		    struct v4l2_fh *fh, struct video_device *vdev)
+{
+	struct v4l2_ctrl *ctrl;
+	struct v4l2_ctrl_handler *ctrl_hdl;
+
+	hdl->base.process_active_job = process_active_job;
+
+	ctrl_hdl = fh ? fh->ctrl_handler : vdev->ctrl_handler;
+	ctrl_hdl->state_handler = &hdl->base;
+
+	if (fh)
+		fh->state_handler = &hdl->base;
+	else
+		vdev->state_handler = &hdl->base;
+
+	hdl->ctrl_hdl = ctrl_hdl;
+	hdl->fh = fh;
+	INIT_LIST_HEAD(&hdl->jobs);
+	hdl->base.ops = &v4l2_generic_job_ops;
+
+	mutex_lock(ctrl_hdl->lock);
+
+	/* Count how many controls we have to manage */
+	list_for_each_entry(ctrl, &ctrl_hdl->ctrls, node) {
+		/* Reserve permanent space for volatile controls */
+		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
+			if (hdl->nr_vol_ctrls >= V4L2_GENERIC_JOB_MAX_CTRLS)
+				return -ENOSPC;
+			hdl->ctrls_ids[hdl->nr_vol_ctrls++] = ctrl->id;
+		}
+
+		hdl->nr_ctrls++;
+	}
+
+	mutex_unlock(ctrl_hdl->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_job_generic_init);
diff --git a/include/media/v4l2-job-generic.h b/include/media/v4l2-job-generic.h
new file mode 100644
index 000000000000..5f6ee55d68e4
--- /dev/null
+++ b/include/media/v4l2-job-generic.h
@@ -0,0 +1,47 @@
+/*
+    V4L2 generic jobs support header.
+
+    Copyright (C) 2017  The Chromium project
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+ */
+
+#ifndef _V4L2_JOB_GENERIC_H
+#define _V4L2_JOB_GENERIC_H
+
+#include <media/v4l2-job-state.h>
+#include <linux/videodev2.h>
+#include <linux/list.h>
+
+struct video_device;
+struct v4l2_fh;
+struct v4l2_ctrl;
+struct v4l2_ctrl_handler;
+struct v4l2_generic_job_state;
+
+#define V4L2_GENERIC_JOB_MAX_CTRLS 32
+struct v4l2_generic_state_handler {
+	struct v4l2_job_state_handler base;
+	struct list_head jobs;
+	struct v4l2_ctrl_handler *ctrl_hdl;
+	struct v4l2_fh *fh;
+	struct v4l2_generic_job_state *last_completed;
+	unsigned int nr_ctrls;
+	unsigned int nr_vol_ctrls;
+	u32 ctrls_ids[V4L2_GENERIC_JOB_MAX_CTRLS];
+};
+
+int v4l2_job_generic_init(struct v4l2_generic_state_handler *handler,
+		    void (*process_active_job)(struct v4l2_job_state_handler *),
+		    struct v4l2_fh *fh, struct video_device *vdev);
+
+#endif
-- 
2.14.2.822.g60be5d43e6-goog
