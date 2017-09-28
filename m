Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:45147 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752661AbdI1JvJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:51:09 -0400
Received: by mail-pf0-f176.google.com with SMTP id z84so613650pfi.2
        for <linux-media@vger.kernel.org>; Thu, 28 Sep 2017 02:51:09 -0700 (PDT)
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
Subject: [RFC PATCH 2/9] [media] v4l2-core: add core jobs API support
Date: Thu, 28 Sep 2017 18:50:20 +0900
Message-Id: <20170928095027.127173-3-acourbot@chromium.org>
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
References: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add core support code for jobs API. This manages the life cycle of jobs
and creation of a jobs queue, as well as the interface for job states.

It also exposes the user-space jobs API.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/Makefile            |   3 +-
 drivers/media/v4l2-core/v4l2-dev.c          |   6 +
 drivers/media/v4l2-core/v4l2-jobqueue-dev.c | 173 +++++++
 drivers/media/v4l2-core/v4l2-jobqueue.c     | 764 ++++++++++++++++++++++++++++
 include/media/v4l2-dev.h                    |   4 +
 include/media/v4l2-fh.h                     |   4 +
 include/media/v4l2-job-state.h              |  75 +++
 include/media/v4l2-jobqueue-dev.h           |  24 +
 include/media/v4l2-jobqueue.h               |  54 ++
 include/uapi/linux/v4l2-jobs.h              |  40 ++
 include/uapi/linux/videodev2.h              |   2 +
 11 files changed, 1148 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-jobqueue-dev.c
 create mode 100644 drivers/media/v4l2-core/v4l2-jobqueue.c
 create mode 100644 include/media/v4l2-job-state.h
 create mode 100644 include/media/v4l2-jobqueue-dev.h
 create mode 100644 include/media/v4l2-jobqueue.h
 create mode 100644 include/uapi/linux/v4l2-jobs.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 098ad5fd5231..a717bb8f1a25 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -6,7 +6,8 @@ tuner-objs	:=	tuner-core.o
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
 			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
-			v4l2-async.o
+			v4l2-async.o v4l2-jobqueue.o v4l2-jobqueue-dev.o
+
 ifeq ($(CONFIG_COMPAT),y)
   videodev-objs += v4l2-compat-ioctl32.o
 endif
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 5a7063886c93..fb229b671b9d 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -30,6 +30,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-jobqueue-dev.h>
 
 #define VIDEO_NUM_DEVICES	256
 #define VIDEO_NAME              "video4linux"
@@ -1058,6 +1059,10 @@ static int __init videodev_init(void)
 		return -EIO;
 	}
 
+	ret = v4l2_jobqueue_device_init();
+	if (ret < 0)
+		printk(KERN_WARNING "video_dev: channel initialization failed\n");
+
 	return 0;
 }
 
@@ -1065,6 +1070,7 @@ static void __exit videodev_exit(void)
 {
 	dev_t dev = MKDEV(VIDEO_MAJOR, 0);
 
+	v4l2_jobqueue_device_exit();
 	class_unregister(&video_class);
 	unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
 }
diff --git a/drivers/media/v4l2-core/v4l2-jobqueue-dev.c b/drivers/media/v4l2-core/v4l2-jobqueue-dev.c
new file mode 100644
index 000000000000..688c4ba275a6
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-jobqueue-dev.c
@@ -0,0 +1,173 @@
+/*
+    V4L2 job queue device
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
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-jobqueue.h>
+#include <uapi/linux/v4l2-jobs.h>
+
+#define CLASS_NAME "v4l2_jobqueue"
+#define DEVICE_NAME "v4l2_jobqueue"
+
+static int major;
+static struct class *jobqueue_class;
+static struct device *jobqueue_device;
+
+static int v4l2_jobqueue_device_open(struct inode *inode, struct file *filp)
+{
+	struct v4l2_jobqueue *jq;
+
+	jq = v4l2_jobqueue_new();
+	if (IS_ERR(jq))
+		return PTR_ERR(jq);
+
+	filp->private_data = jq;
+
+	return 0;
+}
+
+static int v4l2_jobqueue_device_release(struct inode *inode, struct file *filp)
+{
+	struct v4l2_jobqueue *jq = filp->private_data;
+
+	return v4l2_jobqueue_del(jq);
+}
+
+static long v4l2_jobqueue_ioctl_init(struct file *filp, void *arg)
+{
+	struct v4l2_jobqueue *jq = filp->private_data;
+	struct v4l2_jobqueue_init *cinit = arg;
+
+	return v4l2_jobqueue_init(jq, cinit);
+}
+
+static long v4l2_jobqueue_device_ioctl_qjob(struct file *filp, void *arg)
+{
+	struct v4l2_jobqueue *jq = filp->private_data;
+
+	return v4l2_jobqueue_qjob(jq);
+}
+
+static long v4l2_jobqueue_device_ioctl_dqjob(struct file *filp, void *arg)
+{
+	struct v4l2_jobqueue *jq = filp->private_data;
+
+	return v4l2_jobqueue_dqjob(jq);
+}
+
+static long v4l2_jobqueue_device_ioctl_export_job(struct file *filp, void *arg)
+{
+	struct v4l2_jobqueue *jq = filp->private_data;
+	struct v4l2_jobqueue_job *job = arg;
+
+	return v4l2_jobqueue_export_job(jq, job);
+}
+
+static long v4l2_jobqueue_device_ioctl_import_job(struct file *filp, void *arg)
+{
+	struct v4l2_jobqueue *jq = filp->private_data;
+	struct v4l2_jobqueue_job *job = arg;
+
+	return v4l2_jobqueue_import_job(jq, job);
+}
+
+static long v4l2_jobqueue_device_do_ioctl(struct file *filp, unsigned int cmd,
+					  void *arg)
+{
+	switch (cmd) {
+		case VIDIOC_JOBQUEUE_INIT:
+			return v4l2_jobqueue_ioctl_init(filp, arg);
+
+		case VIDIOC_JOBQUEUE_QJOB:
+			return v4l2_jobqueue_device_ioctl_qjob(filp, arg);
+
+		case VIDIOC_JOBQUEUE_DQJOB:
+			return v4l2_jobqueue_device_ioctl_dqjob(filp, arg);
+
+		case VIDIOC_JOBQUEUE_EXPORT_JOB:
+			return v4l2_jobqueue_device_ioctl_export_job(filp, arg);
+
+		case VIDIOC_JOBQUEUE_IMPORT_JOB:
+			return v4l2_jobqueue_device_ioctl_import_job(filp, arg);
+
+		default:
+			pr_err("Invalid ioctl!\n");
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static long v4l2_jobqueue_device_ioctl(struct file *filp, unsigned int cmd,
+				       unsigned long arg)
+{
+	return video_usercopy(filp, cmd, arg, v4l2_jobqueue_device_do_ioctl);
+}
+
+static const struct file_operations v4l2_jobqueue_devnode_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_jobqueue_device_open,
+	.unlocked_ioctl = v4l2_jobqueue_device_ioctl,
+#ifdef CONFIG_COMPAT
+	/* TODO */
+	/* .compat_ioctl = jobqueue_compat_ioctl, */
+#endif
+	.release = v4l2_jobqueue_device_release,
+};
+
+int __init v4l2_jobqueue_device_init(void)
+{
+	/* Set to error value so v4l2_jobqueue_device_exit does nothing if we
+	 * don't initialize properly */
+	jobqueue_device = ERR_PTR(-EINVAL);
+
+	major = register_chrdev(0, DEVICE_NAME, &v4l2_jobqueue_devnode_fops);
+	if (major < 0) {
+		pr_err("unable to allocate major\n");
+		return major;
+	}
+
+	jobqueue_class = class_create(THIS_MODULE, CLASS_NAME);
+	if (IS_ERR(jobqueue_class)) {
+		pr_err("cannot create class\n");
+		unregister_chrdev(major, DEVICE_NAME);
+		return PTR_ERR(jobqueue_class);
+	}
+
+	jobqueue_device = device_create(jobqueue_class, NULL, MKDEV(major, 0),
+					NULL, DEVICE_NAME);
+	if (IS_ERR(jobqueue_device)) {
+		pr_err("cannot create device\n");
+		class_destroy(jobqueue_class);
+		unregister_chrdev(major, DEVICE_NAME);
+		return PTR_ERR(jobqueue_device);
+	}
+
+	return 0;
+}
+
+void __exit v4l2_jobqueue_device_exit(void)
+{
+	if (IS_ERR(jobqueue_device))
+		return;
+
+	device_destroy(jobqueue_class, MKDEV(major, 0));
+	class_destroy(jobqueue_class);
+	unregister_chrdev(major, DEVICE_NAME);
+}
diff --git a/drivers/media/v4l2-core/v4l2-jobqueue.c b/drivers/media/v4l2-core/v4l2-jobqueue.c
new file mode 100644
index 000000000000..36d2dd48b086
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-jobqueue.c
@@ -0,0 +1,764 @@
+/*
+    V4L2 job queue implementation
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
+#include <linux/compat.h>
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/file.h>
+#include <linux/list.h>
+#include <linux/kref.h>
+#include <linux/anon_inodes.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-jobqueue.h>
+#include <media/v4l2-job-state.h>
+#include <uapi/linux/v4l2-jobs.h>
+
+/* Limited by the size of atomic_t to track devices that completed a job */
+#define V4L2_JOBQUEUE_MAX_DEVICES sizeof(atomic_t)
+
+/*
+ * State of all managed devices for a given job
+ */
+struct v4l2_job {
+	struct kref refcount;
+	struct v4l2_jobqueue *jq;
+	/* node in v4l2_jobqueue's queued_jobs or completed_jobs */
+	struct list_head node;
+	/* global list of existing jobs for this queue */
+	struct list_head jobs_list;
+	/* mask of devices that completed this job */
+	atomic_t completed;
+	/* fd exported to user-space */
+	int fd;
+	enum v4l2_job_status status;
+
+	/* per-device states */
+	struct v4l2_job_state *state[0];
+};
+
+/*
+ * A job queue manages the job flow for a given set of devices, applies their
+ * state, and activates them in lockstep.
+ *
+ * A job goes through the following stages through its life:
+ *
+ * * current_job: the job has been created and is waiting to be queued. S_CTRL
+ *   will apply to it. Once queued, it is pushed into
+ * * queued_jobs: a queue of jobs to be processed in sequential order. The head
+ *   of this list becomes the
+ * * active_job: the job currently being processed by the hardware. Once
+ *   completed, the next job in queued_job becomes active, and the previous
+ *   active job goes into
+ * * completed_jobs: a list of completed jobs waiting to be dequeued by
+ *   user-space. As user-space called the DQJOB ioctl, the head becomes the
+ * * dequeued_job: the job on which G_CTRL will be performed on. A job stays
+ *   in this state until another one is dequeued, at which point it is deleted.
+ */
+struct v4l2_jobqueue {
+	/* List of all jobs created for this queue, regardless of state */
+	struct list_head jobs_list;
+	/*
+	 * Job that user-space is currently preparing, to be added to
+	 * queued_jobs upon QJOB ioctl.
+	 */
+	struct v4l2_job *current_job;
+
+	/* List of jobs that are ready to be processed */
+	struct list_head queued_jobs;
+
+	/* Job that is currently processed by the devices */
+	struct v4l2_job *active_job;
+
+	/* List of completed jobs, ready to be dequeued */
+	struct list_head completed_jobs;
+
+	/* Job that has last been dequeued and can be queried by user-space */
+	struct v4l2_job *dequeued_job;
+
+	/* Projects the *_job[s] lists/pointers above */
+	struct mutex lock;
+	struct work_struct job_complete_work;
+
+	wait_queue_head_t done_wq;
+
+	unsigned int nb_devs;
+	struct {
+		struct file *f;
+		struct v4l2_job_state_handler *state_handler;
+	} *devs;
+};
+
+static bool v4l2_jobqueue_is_locked(struct v4l2_jobqueue *jq)
+{
+	return mutex_is_locked(&jq->lock);
+}
+
+static void v4l2_jobqueue_free_job(struct v4l2_job *job)
+{
+	struct v4l2_jobqueue *jq = job->jq;
+	int i;
+
+	for (i = 0; i < jq->nb_devs; i++) {
+		struct v4l2_job_state_handler *hdl = jq->devs[i].state_handler;
+		if (job->state[i])
+			hdl->ops->job_free(hdl, job->state[i]);
+	}
+	kfree(job);
+}
+
+/*
+ * Must be called with jobqueue lock held
+ */
+static void v4l2_jobqueue_delete_job(struct kref *ref)
+{
+	struct v4l2_job *job = container_of(ref, struct v4l2_job, refcount);
+
+	list_del(&job->jobs_list);
+
+	   v4l2_jobqueue_free_job(job);
+}
+
+/*
+ * Must be called with the jobqueue lock acquired
+ */
+static void job_get(struct v4l2_job *job)
+{
+	kref_get(&job->refcount);
+}
+
+/*
+ * Must be called with the jobqueue lock acquired
+ */
+static int job_put(struct v4l2_job *job)
+{
+	return kref_put(&job->refcount, v4l2_jobqueue_delete_job);
+}
+
+/*
+ * Move a job from one state to another in the jobqueue state machine, making
+ * extensive sanity tests.
+ *
+ * jobqueue lock must be held when this function is called.
+ */
+static void jobqueue_set_job_state(struct v4l2_job *job,
+				   enum v4l2_job_status status)
+{
+	struct v4l2_jobqueue *jq = job->jq;
+	int i;
+
+	BUG_ON(!v4l2_jobqueue_is_locked(jq));
+
+	/* Sanity checks & jobqueue state update */
+	switch (status) {
+	case CURRENT:
+		BUG_ON(job->status != OUT_OF_QUEUE);
+		BUG_ON(jq->current_job != NULL);
+		jq->current_job = job;
+		break;
+	case QUEUED:
+		BUG_ON(job->status != CURRENT);
+		BUG_ON(jq->current_job != job);
+		jq->current_job = NULL;
+		list_add_tail(&job->node, &jq->queued_jobs);
+		break;
+	case ACTIVE:
+		BUG_ON(job->status != QUEUED);
+		BUG_ON(jq->active_job != NULL);
+		BUG_ON(list_first_entry_or_null(&jq->queued_jobs,
+						struct v4l2_job, node) != job);
+		list_del(&job->node);
+		jq->active_job = job;
+		break;
+	case COMPLETED:
+		BUG_ON(job->status != ACTIVE);
+		BUG_ON(jq->active_job != job);
+		jq->active_job = NULL;
+		list_add_tail(&job->node, &jq->completed_jobs);
+		break;
+	case DEQUEUED:
+		BUG_ON(job->status != COMPLETED);
+		BUG_ON(jq->dequeued_job != NULL);
+		BUG_ON(list_first_entry_or_null(&jq->completed_jobs,
+						struct v4l2_job, node) != job);
+		list_del(&job->node);
+		jq->dequeued_job = job;
+		break;
+	case OUT_OF_QUEUE:
+		BUG_ON(job->status != DEQUEUED);
+		BUG_ON(jq->dequeued_job != job);
+		jq->dequeued_job = NULL;
+		break;
+	};
+
+	job->status = status;
+
+	for (i = 0; i < jq->nb_devs; i++) {
+		struct v4l2_job_state_handler *hdl = jq->devs[i].state_handler;
+		struct v4l2_job_state *state = job->state[i];
+
+		switch (status) {
+		case CURRENT:
+			hdl->current_state = state;
+			break;
+		case ACTIVE:
+			hdl->active_state = state;
+			break;
+		case DEQUEUED:
+			hdl->dequeued_state = state;
+			break;
+		default:
+			break;
+		}
+
+		if (hdl->ops->state_changed)
+			hdl->ops->state_changed(hdl, state, status);
+	}
+}
+
+/*
+ * jobqueue lock must be held by caller
+ */
+static int v4l2_jobqueue_new_job(struct v4l2_jobqueue *jq)
+{
+	struct v4l2_job *job;
+	int i;
+
+	BUG_ON(!v4l2_jobqueue_is_locked(jq));
+
+	if (jq->current_job)
+		return -EBUSY;
+
+	job = kzalloc(sizeof(*job) + sizeof(job->state[0]) * jq->nb_devs,
+		      GFP_KERNEL);
+	if (job == NULL)
+		return -ENOMEM;
+
+	list_add(&job->jobs_list, &jq->jobs_list);
+	kref_init(&job->refcount);
+	job->jq = jq;
+	job->status = OUT_OF_QUEUE;
+	job->fd = -1;
+	atomic_set(&job->completed, 0);
+	for (i = 0; i < jq->nb_devs; i++) {
+		struct v4l2_job_state_handler *hdl = jq->devs[i].state_handler;
+		struct v4l2_job_state *state;
+
+		state = hdl->ops->job_new(hdl);
+		job->state[i] = state;
+		if (IS_ERR(state)) {
+			         v4l2_jobqueue_free_job(job);
+			return PTR_ERR(state);
+		}
+		state->job = job;
+	}
+
+	jobqueue_set_job_state(job, CURRENT);
+
+	return 0;
+}
+
+/*
+ * Prepare the next queued job for streaming.
+ *
+ * jobqueue lock must be held by the caller.
+ */
+static void v4l2_jobqueue_prepare_streaming(struct v4l2_jobqueue *jq)
+{
+	struct v4l2_job *job;
+
+	BUG_ON(!v4l2_jobqueue_is_locked(jq));
+
+	/* Already streaming */
+	if (jq->active_job)
+		return;
+
+	job = list_first_entry_or_null(&jq->queued_jobs, struct v4l2_job, node);
+	/* No job ready to be streamed */
+	if (!job)
+		return;
+	jobqueue_set_job_state(job, ACTIVE);
+}
+
+/*
+ * Asks all devices to start processing the prepared job
+ *
+ */
+static void v4l2_jobqueue_start_streaming(struct v4l2_jobqueue *jq)
+{
+	int ret;
+	int i;
+
+	/* No job ready to be streamed */
+	if (!jq->active_job)
+		return;
+
+	/*
+	 * TODO move what follows into a worker?
+	 */
+
+	/* Set the desired state on all devices */
+	for (i = 0; i < jq->nb_devs; i++) {
+		struct v4l2_job_state_handler *handler;
+
+		handler = jq->devs[i].state_handler;
+		ret = handler->ops->job_apply(handler);
+		/* TODO proper cleanup and reporting after error */
+		if (ret < 0) {
+			pr_err("error while setting job queue parameters!\n");
+			return;
+		}
+	}
+
+	/* Start streaming on all devices */
+	for (i = 0; i < jq->nb_devs; i++) {
+		struct v4l2_job_state_handler *handler;
+
+		handler = jq->devs[i].state_handler;
+
+		if (handler->process_active_job)
+			handler->process_active_job(jq->devs[i].state_handler);
+	}
+}
+
+static void v4l2_jobqueue_job_complete(struct work_struct *work)
+{
+	struct v4l2_jobqueue *jq = container_of(work, struct v4l2_jobqueue,
+						job_complete_work);
+
+	v4l2_jobqueue_lock(jq);
+
+	jobqueue_set_job_state(jq->active_job, COMPLETED);
+	wake_up(&jq->done_wq);
+
+	v4l2_jobqueue_prepare_streaming(jq);
+
+	v4l2_jobqueue_unlock(jq);
+
+	/* see if we can perform the next job */
+	v4l2_jobqueue_start_streaming(jq);
+}
+
+struct v4l2_jobqueue *v4l2_jobqueue_new(void)
+{
+	struct v4l2_jobqueue *jq;
+
+	jq = kzalloc(sizeof(*jq), GFP_KERNEL);
+	if (jq == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&jq->jobs_list);
+	INIT_LIST_HEAD(&jq->queued_jobs);
+	INIT_LIST_HEAD(&jq->completed_jobs);
+	mutex_init(&jq->lock);
+	init_waitqueue_head(&jq->done_wq);
+	INIT_WORK(&jq->job_complete_work, v4l2_jobqueue_job_complete);
+
+	return jq;
+}
+EXPORT_SYMBOL(v4l2_jobqueue_new);
+
+int v4l2_jobqueue_del(struct v4l2_jobqueue *jq)
+{
+	struct v4l2_job *job, *_job_t;
+	int i;
+
+	v4l2_jobqueue_lock(jq);
+
+	if (jq->current_job != NULL) {
+		job_put(jq->current_job);
+		jq->current_job = NULL;
+	}
+
+	/* Clean all pending jobs */
+	list_for_each_entry_safe(job, _job_t, &jq->queued_jobs, node) {
+		pr_warn("Deleting pending queued job\n");
+		list_del(&job->node);
+		job_put(job);
+	}
+
+	/* Wait for active job to complete, if any */
+	while (jq->active_job != NULL) {
+		v4l2_jobqueue_unlock(jq);
+		wait_event(jq->done_wq, jq->active_job == NULL);
+		cancel_work_sync(&jq->job_complete_work);
+		v4l2_jobqueue_lock(jq);
+	}
+
+	/* Clean all completed jobs */
+	list_for_each_entry_safe(job, _job_t, &jq->completed_jobs, node) {
+		pr_warn("Deleting pending completed job\n");
+		list_del(&job->node);
+		job_put(job);
+	}
+
+	/* Delete currently dequeued job, if any */
+	if (jq->dequeued_job != NULL) {
+		job = jq->dequeued_job;
+		jobqueue_set_job_state(job, OUT_OF_QUEUE);
+		job_put(job);
+	}
+
+	/* No job should exist anymore */
+	WARN_ON(jq->dequeued_job);
+	WARN_ON(!list_empty(&jq->completed_jobs));
+	WARN_ON(jq->active_job);
+	WARN_ON(!list_empty(&jq->queued_jobs));
+	WARN_ON(jq->current_job);
+
+	/*
+	 * must invalidate all fds exported to user-space, otherwise users
+	 * may do funny things with them, or they will be automatically closed
+	 * when the process exits
+	 *
+	 * TODO improve this. We can still enter a race if jobqueue_release_job
+	 * if called right before we set private_data to NULL. Unfortunately
+	 * we also cannot use fput() here the call to release is asynchronous.
+	 */
+	if (!list_empty(&jq->jobs_list)) {
+		pr_warn("Exported jobs still exist, removing them\n");
+		list_for_each_entry_safe(job, _job_t, &jq->jobs_list, jobs_list)
+			v4l2_jobqueue_free_job(job);
+	}
+
+	v4l2_jobqueue_unlock(jq);
+
+	for (i = 0; i < jq->nb_devs; i++) {
+		jq->devs[i].state_handler->jobqueue = NULL;
+		fput(jq->devs[i].f);
+	}
+	kfree(jq->devs);
+	kfree(jq);
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_jobqueue_del);
+
+int v4l2_jobqueue_init(struct v4l2_jobqueue *jq,
+		       struct v4l2_jobqueue_init *cinit)
+{
+	int ret;
+	int i;
+
+	if (cinit->nb_devs > V4L2_JOBQUEUE_MAX_DEVICES)
+		return -ENOSPC;
+
+	jq->devs = kzalloc(sizeof(jq->devs[0]) * cinit->nb_devs, GFP_KERNEL);
+	if (!jq->devs) {
+		pr_err("error: out of memory\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < cinit->nb_devs; i++) {
+		struct file *f;
+		struct video_device *vdev;
+		struct v4l2_fh *fh;
+		struct v4l2_job_state_handler *handler;
+		struct v4l2_ctrl_handler *ctrl_handler;
+
+		f = fget(cinit->fd[i]);
+		jq->devs[i].f = f;
+		if (!v4l2_is_v4l2_file(f)) {
+			pr_err("error: passed fd is not v4l2 device!\n");
+			ret = -EINVAL;
+			goto error;
+		}
+
+		fh = f->private_data;
+		vdev = video_devdata(f);
+
+		ctrl_handler = fh ? fh->ctrl_handler : vdev->ctrl_handler;
+		if (!ctrl_handler) {
+			pr_err("error: no control handler in device!\n");
+			ret = -EINVAL;
+			goto error;
+		}
+
+		if (fh)
+			handler = fh->state_handler;
+
+		if (!handler && vdev)
+			handler = vdev->state_handler;
+
+		if (!handler) {
+			pr_err("error: no state handler in device!\n");
+			ret = -EINVAL;
+			goto error;
+		}
+		handler->jobqueue = jq;
+		jq->devs[0].state_handler = handler;
+	}
+
+	jq->nb_devs = cinit->nb_devs;
+
+	/* Create first job */
+	v4l2_jobqueue_lock(jq);
+	ret = v4l2_jobqueue_new_job(jq);
+	v4l2_jobqueue_unlock(jq);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	jq->nb_devs = 0;
+	for (i = 0; i < cinit->nb_devs; i++)
+		if (jq->devs[i].f)
+			fput(jq->devs[i].f);
+	kfree(jq->devs);
+	jq->devs = NULL;
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_jobqueue_init);
+
+void v4l2_jobqueue_lock(struct v4l2_jobqueue *jq)
+{
+	mutex_lock(&jq->lock);
+}
+EXPORT_SYMBOL(v4l2_jobqueue_lock);
+
+void v4l2_jobqueue_unlock(struct v4l2_jobqueue *jq)
+{
+	mutex_unlock(&jq->lock);
+}
+EXPORT_SYMBOL(v4l2_jobqueue_unlock);
+
+void v4l2_jobqueue_job_finish(struct v4l2_job_state_handler *handler)
+{
+	struct v4l2_job_state *state = handler->active_state;
+	struct v4l2_job *job;
+	struct v4l2_jobqueue *jq;
+	unsigned int finished_mask;
+	int pos;
+
+	BUG_ON(!state);
+
+	job = state->job;
+	jq = job->jq;
+	pos = state - job->state[0];
+	finished_mask = BIT(jq->nb_devs) - 1;
+
+	handler->ops->job_complete(handler);
+	handler->active_state = NULL;
+
+	/* have all devices completed? */
+	if (!atomic_add_return(BIT(pos), &job->completed) != finished_mask)
+		schedule_work(&jq->job_complete_work);
+}
+EXPORT_SYMBOL(v4l2_jobqueue_job_finish);
+
+int v4l2_jobqueue_qjob(struct v4l2_jobqueue *jq)
+{
+	bool start_streaming;
+	int ret = 0;
+
+	v4l2_jobqueue_lock(jq);
+
+	if (jq->current_job == NULL) {
+		/* This should never happen */
+		pr_err("no current job at the moment!\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	jobqueue_set_job_state(jq->current_job, QUEUED);
+
+	start_streaming = (jq->active_job == NULL);
+
+	v4l2_jobqueue_prepare_streaming(jq);
+
+	v4l2_jobqueue_unlock(jq);
+
+	v4l2_jobqueue_lock(jq);
+
+	ret = v4l2_jobqueue_new_job(jq);
+	if (ret < 0)
+		goto out;
+
+out:
+	v4l2_jobqueue_unlock(jq);
+
+	if (ret == 0 && start_streaming)
+		v4l2_jobqueue_start_streaming(jq);
+
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_jobqueue_qjob);
+
+int v4l2_jobqueue_dqjob(struct v4l2_jobqueue *jq)
+{
+	struct v4l2_job *job = NULL;
+	struct v4l2_job *old_job;
+	int ret;
+
+	v4l2_jobqueue_lock(jq);
+
+	while (true) {
+		job = list_first_entry_or_null(&jq->completed_jobs,
+					       struct v4l2_job, node);
+		if (job)
+			break;
+
+		v4l2_jobqueue_unlock(jq);
+		ret = wait_event_interruptible(jq->done_wq,
+					      !list_empty(&jq->completed_jobs));
+		if (ret)
+			return ret;
+		v4l2_jobqueue_lock(jq);
+	}
+
+	old_job = jq->dequeued_job;
+	if (old_job)
+		jobqueue_set_job_state(old_job, OUT_OF_QUEUE);
+
+	jobqueue_set_job_state(job, DEQUEUED);
+
+	v4l2_jobqueue_unlock(jq);
+
+	/* dispose of reference to previous job */
+	if (old_job)
+		job_put(old_job);
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_jobqueue_dqjob);
+
+static int v4l2_jobqueue_release_job(struct inode *inode, struct file *filp)
+{
+	struct v4l2_job *job = filp->private_data;
+	struct v4l2_jobqueue *jq = job->jq;
+
+	/* This can happen if a job queue is closed before all its exported
+	 * jobs. In that case the job becomes inactive until its fd finally
+	 * gets closed */
+	if (job == NULL)
+		return 0;
+
+	v4l2_jobqueue_lock(jq);
+
+	job->fd = -1;
+	job_put(job);
+
+	v4l2_jobqueue_unlock(jq);
+
+	return 0;
+}
+
+static const struct file_operations v4l2_jobqueue_job_ops = {
+	.owner = THIS_MODULE,
+	.release = v4l2_jobqueue_release_job,
+};
+
+int v4l2_jobqueue_export_job(struct v4l2_jobqueue *jq,
+			     struct v4l2_jobqueue_job *export_job)
+{
+	struct v4l2_job *job = jq->current_job;
+	int fd;
+	int i;
+
+	v4l2_jobqueue_lock(jq);
+
+	if (job->fd >= 0) {
+		v4l2_jobqueue_unlock(jq);
+		pr_warn("job already exported!\n");
+		return -EBUSY;
+	}
+
+	/* Sanity check that all devices support export */
+	for (i = 0; i < jq->nb_devs; i++) {
+		if (!jq->devs[i].state_handler->ops->job_export) {
+			v4l2_jobqueue_unlock(jq);
+			pr_warn("some devices do not support job export\n");
+			return -ENOTSUPP;
+		}
+	}
+
+	for (i = 0; i < jq->nb_devs; i++) {
+		struct v4l2_job_state_handler *hdl = jq->devs[i].state_handler;
+		int ret;
+
+		ret = hdl->ops->job_export(hdl);
+		if (ret < 0) {
+			v4l2_jobqueue_unlock(jq);
+			pr_warn("job export failed\n");
+			return ret;
+		}
+	}
+
+	fd = anon_inode_getfd("v4l2", &v4l2_jobqueue_job_ops, job, O_CLOEXEC);
+	if (fd < 0) {
+		v4l2_jobqueue_unlock(jq);
+		return fd;
+	}
+
+	export_job->fd = job->fd = fd;
+	job_get(job);
+
+	v4l2_jobqueue_unlock(jq);
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_jobqueue_export_job);
+
+int v4l2_jobqueue_import_job(struct v4l2_jobqueue *jq,
+			     struct v4l2_jobqueue_job *import_job)
+{
+	struct v4l2_job *current_job = NULL;
+	struct v4l2_job *job;
+	struct file *f = fget(import_job->fd);
+
+	if (!f)
+		return -EINVAL;
+
+	/* Is this fd legit? */
+	if (f->f_op != &v4l2_jobqueue_job_ops)
+		return -EINVAL;
+
+	job = f->private_data;
+	fput(f);
+
+	/* Does the job actually belong to us? */
+	if (job->jq != jq) {
+		pr_err("job belongs to a different queue!\n");
+		return -EINVAL;
+	}
+
+	v4l2_jobqueue_lock(jq);
+
+	/* Cannot import a job that is not out of queue */
+	if (job->status != OUT_OF_QUEUE) {
+		pr_err("job is already in the queue!\n");
+		v4l2_jobqueue_unlock(jq);
+		return -EBUSY;
+	}
+
+	job_get(job);
+	current_job = jq->current_job;
+	jq->current_job = NULL;
+	jobqueue_set_job_state(job, CURRENT);
+
+	v4l2_jobqueue_unlock(jq);
+	if (current_job)
+		job_put(current_job);
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_jobqueue_import_job);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index b73d646980da..a1558d9bf309 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -38,6 +38,7 @@ struct v4l2_ioctl_callbacks;
 struct video_device;
 struct v4l2_device;
 struct v4l2_ctrl_handler;
+struct v4l2_job_state_handler;
 
 /* Flag to mark the video_device struct as registered.
    Drivers can clear this flag if they want to block all future
@@ -184,6 +185,8 @@ struct v4l2_file_operations {
  * @dev_parent: pointer to &struct device parent
  * @ctrl_handler: Control handler associated with this device node.
  *	 May be NULL.
+ * @state_handler: State handler associated with this device node.
+ *	 May be NULL.
  * @queue: &struct vb2_queue associated with this device node. May be NULL.
  * @prio: pointer to &struct v4l2_prio_state with device's Priority state.
  *	 If NULL, then v4l2_dev->prio will be used.
@@ -229,6 +232,7 @@ struct video_device
 	struct device *dev_parent;
 
 	struct v4l2_ctrl_handler *ctrl_handler;
+	struct v4l2_job_state_handler *state_handler;
 
 	struct vb2_queue *queue;
 
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 0b0757090c04..ea86d713a59a 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -28,6 +28,7 @@
 
 struct video_device;
 struct v4l2_ctrl_handler;
+struct v4l2_job_state_handler;
 
 /**
  * struct v4l2_fh - Describes a V4L2 file handler
@@ -35,6 +36,8 @@ struct v4l2_ctrl_handler;
  * @list: list of file handlers
  * @vdev: pointer to &struct video_device
  * @ctrl_handler: pointer to &struct v4l2_ctrl_handler
+ * @state_handler: pointer to &struct v4l2_job_state_handler, may be NULL if
+ *                 jobs API not supported by this device.
  * @prio: priority of the file handler, as defined by &enum v4l2_priority
  *
  * @wait: event' s wait queue
@@ -48,6 +51,7 @@ struct v4l2_fh {
 	struct list_head	list;
 	struct video_device	*vdev;
 	struct v4l2_ctrl_handler *ctrl_handler;
+	struct v4l2_job_state_handler *state_handler;
 	enum v4l2_priority	prio;
 
 	/* Events */
diff --git a/include/media/v4l2-job-state.h b/include/media/v4l2-job-state.h
new file mode 100644
index 000000000000..42048e8d11a8
--- /dev/null
+++ b/include/media/v4l2-job-state.h
@@ -0,0 +1,75 @@
+/*
+    V4L2 job states interface
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
+#ifndef _V4L2_JOB_STATE_H
+#define _V4L2_JOB_STATE_H
+
+struct v4l2_jobqueue;
+struct v4l2_job_state_handler;
+struct v4l2_ext_control;
+struct v4l2_job;
+struct v4l2_ctrl;
+
+enum v4l2_job_status;
+
+struct v4l2_job_state {
+	struct v4l2_job *job;
+};
+
+struct v4l2_job_state_handler_ops {
+	/* Allocate a new job state for this device */
+	struct v4l2_job_state *(*job_new)(struct v4l2_job_state_handler *hdl);
+	/* Free a previously allocated job state */
+	void (*job_free)(struct v4l2_job_state_handler *hdl,
+			 struct v4l2_job_state *state);
+	/* Apply current job state */
+	int (*job_apply)(struct v4l2_job_state_handler *hdl);
+	/* Signal that the device has completed its part of the job */
+	void (*job_complete)(struct v4l2_job_state_handler *hdl);
+	/* Prepare the current job for being exported */
+	int (*job_export)(struct v4l2_job_state_handler *hdl);
+
+	/* Set control the the current state */
+	int (*s_ctrl)(struct v4l2_job_state_handler *hdl,
+		      struct v4l2_ext_control *c);
+	/* Get control from the dequeued state */
+	int (*g_ctrl)(struct v4l2_job_state_handler *hdl, u32 ctrl_id,
+		      struct v4l2_ext_control *c, u32 which);
+
+	/* Called whenever the HW value of a non-volatile control is changed */
+	void (*ctrl_changed)(struct v4l2_job_state_handler *hdl,
+			     struct v4l2_ctrl *ctrl);
+	/* Called whenever a job has moved in the job queue */
+	void (*state_changed)(struct v4l2_job_state_handler *hdl,
+			      struct v4l2_job_state *state,
+		       enum v4l2_job_status status);
+};
+
+/*
+ * Manages the state of one particular device. Contains pointers to the
+ * current, active and dequeued state that are updated by the jobs framework
+ */
+struct v4l2_job_state_handler {
+	struct v4l2_jobqueue *jobqueue;
+	const struct v4l2_job_state_handler_ops *ops;
+	void (*process_active_job)(struct v4l2_job_state_handler *hdl);
+	struct v4l2_job_state *current_state;
+	struct v4l2_job_state *active_state;
+	struct v4l2_job_state *dequeued_state;
+};
+
+#endif
diff --git a/include/media/v4l2-jobqueue-dev.h b/include/media/v4l2-jobqueue-dev.h
new file mode 100644
index 000000000000..9c3dcff72563
--- /dev/null
+++ b/include/media/v4l2-jobqueue-dev.h
@@ -0,0 +1,24 @@
+/*
+    V4L2 jobqueue device
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
+#ifndef _V4L2_JOBQUEUE_DEV_H_
+#define _V4L2_JOBQUEUE_DEV_H
+
+int v4l2_jobqueue_device_init(void);
+void v4l2_jobqueue_device_exit(void);
+
+#endif
diff --git a/include/media/v4l2-jobqueue.h b/include/media/v4l2-jobqueue.h
new file mode 100644
index 000000000000..a294042b7c13
--- /dev/null
+++ b/include/media/v4l2-jobqueue.h
@@ -0,0 +1,54 @@
+/*
+    V4L2 jobqueue support header.
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
+#ifndef _V4L2_JOBQUEUE_H
+#define _V4L2_JOBQUEUE_H
+
+struct v4l2_jobqueue;
+struct v4l2_job_state_handler;
+
+#include <uapi/linux/v4l2-jobs.h>
+
+enum v4l2_job_status {
+	CURRENT,
+	QUEUED,
+	ACTIVE,
+	COMPLETED,
+	DEQUEUED,
+	OUT_OF_QUEUE,
+};
+
+/* Jobqueue device interface */
+struct v4l2_jobqueue *v4l2_jobqueue_new(void);
+int v4l2_jobqueue_del(struct v4l2_jobqueue *jq);
+
+/* Ioctls support */
+int v4l2_jobqueue_init(struct v4l2_jobqueue *jq,
+		       struct v4l2_jobqueue_init *init);
+int v4l2_jobqueue_qjob(struct v4l2_jobqueue *jq);
+int v4l2_jobqueue_dqjob(struct v4l2_jobqueue *jq);
+int v4l2_jobqueue_export_job(struct v4l2_jobqueue *jq,
+			     struct v4l2_jobqueue_job *job);
+int v4l2_jobqueue_import_job(struct v4l2_jobqueue *jq,
+			     struct v4l2_jobqueue_job *job);
+
+/* Driver/state handler interface */
+void v4l2_jobqueue_job_finish(struct v4l2_job_state_handler *hdl);
+void v4l2_jobqueue_lock(struct v4l2_jobqueue *jq);
+void v4l2_jobqueue_unlock(struct v4l2_jobqueue *jq);
+
+#endif
diff --git a/include/uapi/linux/v4l2-jobs.h b/include/uapi/linux/v4l2-jobs.h
new file mode 100644
index 000000000000..2cba4d20e62f
--- /dev/null
+++ b/include/uapi/linux/v4l2-jobs.h
@@ -0,0 +1,40 @@
+/*
+ * V4L2 jobs API
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LINUX_V4L2_JOBS_H
+#define __LINUX_V4L2_JOBS_H
+
+#ifndef __KERNEL__
+#include <stdint.h>
+#endif
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+struct v4l2_jobqueue_init {
+	__u32 nb_devs;
+	__s32 *fd;
+};
+
+struct v4l2_jobqueue_job {
+	__s32 fd;
+};
+
+#define VIDIOC_JOBQUEUE_IOCTL_START	0x80
+
+#define VIDIOC_JOBQUEUE_INIT		_IOW('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x00, struct v4l2_jobqueue_init)
+#define VIDIOC_JOBQUEUE_QJOB		_IO('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x01)
+#define VIDIOC_JOBQUEUE_DQJOB		_IO('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x02)
+#define VIDIOC_JOBQUEUE_EXPORT_JOB	_IOR('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x03, struct v4l2_jobqueue_job)
+#define VIDIOC_JOBQUEUE_IMPORT_JOB	_IOW('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x03, struct v4l2_jobqueue_job)
+
+#endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 45cf7359822c..7f43e97cf461 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1591,6 +1591,8 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_MAX_DIMS	  (4)
 #define V4L2_CTRL_WHICH_CUR_VAL   0
 #define V4L2_CTRL_WHICH_DEF_VAL   0x0f000000
+#define V4L2_CTRL_WHICH_CURJOB_VAL   0x0e000000
+#define V4L2_CTRL_WHICH_DEQJOB_VAL   0x0d000000
 
 enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_INTEGER	     = 1,
-- 
2.14.2.822.g60be5d43e6-goog
