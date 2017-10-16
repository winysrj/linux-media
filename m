Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:52941 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750914AbdJPKBJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 06:01:09 -0400
Subject: Re: [RFC PATCH 2/9] [media] v4l2-core: add core jobs API support
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20170928095027.127173-1-acourbot@chromium.org>
 <20170928095027.127173-3-acourbot@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e602666f-cde2-3c77-3ad1-f6f800a4bfdd@xs4all.nl>
Date: Mon, 16 Oct 2017 12:01:01 +0200
MIME-Version: 1.0
In-Reply-To: <20170928095027.127173-3-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2017 11:50 AM, Alexandre Courbot wrote:
> Add core support code for jobs API. This manages the life cycle of jobs
> and creation of a jobs queue, as well as the interface for job states.
> 
> It also exposes the user-space jobs API.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/v4l2-core/Makefile            |   3 +-
>  drivers/media/v4l2-core/v4l2-dev.c          |   6 +
>  drivers/media/v4l2-core/v4l2-jobqueue-dev.c | 173 +++++++
>  drivers/media/v4l2-core/v4l2-jobqueue.c     | 764 ++++++++++++++++++++++++++++
>  include/media/v4l2-dev.h                    |   4 +
>  include/media/v4l2-fh.h                     |   4 +
>  include/media/v4l2-job-state.h              |  75 +++
>  include/media/v4l2-jobqueue-dev.h           |  24 +
>  include/media/v4l2-jobqueue.h               |  54 ++
>  include/uapi/linux/v4l2-jobs.h              |  40 ++
>  include/uapi/linux/videodev2.h              |   2 +
>  11 files changed, 1148 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-jobqueue-dev.c
>  create mode 100644 drivers/media/v4l2-core/v4l2-jobqueue.c
>  create mode 100644 include/media/v4l2-job-state.h
>  create mode 100644 include/media/v4l2-jobqueue-dev.h
>  create mode 100644 include/media/v4l2-jobqueue.h
>  create mode 100644 include/uapi/linux/v4l2-jobs.h
> 
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index 098ad5fd5231..a717bb8f1a25 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -6,7 +6,8 @@ tuner-objs	:=	tuner-core.o
>  
>  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
>  			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
> -			v4l2-async.o
> +			v4l2-async.o v4l2-jobqueue.o v4l2-jobqueue-dev.o
> +
>  ifeq ($(CONFIG_COMPAT),y)
>    videodev-objs += v4l2-compat-ioctl32.o
>  endif
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 5a7063886c93..fb229b671b9d 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -30,6 +30,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-jobqueue-dev.h>
>  
>  #define VIDEO_NUM_DEVICES	256
>  #define VIDEO_NAME              "video4linux"
> @@ -1058,6 +1059,10 @@ static int __init videodev_init(void)
>  		return -EIO;
>  	}
>  
> +	ret = v4l2_jobqueue_device_init();
> +	if (ret < 0)
> +		printk(KERN_WARNING "video_dev: channel initialization failed\n");
> +
>  	return 0;
>  }
>  
> @@ -1065,6 +1070,7 @@ static void __exit videodev_exit(void)
>  {
>  	dev_t dev = MKDEV(VIDEO_MAJOR, 0);
>  
> +	v4l2_jobqueue_device_exit();
>  	class_unregister(&video_class);
>  	unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
>  }
> diff --git a/drivers/media/v4l2-core/v4l2-jobqueue-dev.c b/drivers/media/v4l2-core/v4l2-jobqueue-dev.c
> new file mode 100644
> index 000000000000..688c4ba275a6
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-jobqueue-dev.c
> @@ -0,0 +1,173 @@
> +/*
> +    V4L2 job queue device
> +
> +    Copyright (C) 2017  The Chromium project
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> + */
> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-jobqueue.h>
> +#include <uapi/linux/v4l2-jobs.h>
> +
> +#define CLASS_NAME "v4l2_jobqueue"
> +#define DEVICE_NAME "v4l2_jobqueue"
> +
> +static int major;
> +static struct class *jobqueue_class;
> +static struct device *jobqueue_device;
> +
> +static int v4l2_jobqueue_device_open(struct inode *inode, struct file *filp)
> +{
> +	struct v4l2_jobqueue *jq;
> +
> +	jq = v4l2_jobqueue_new();
> +	if (IS_ERR(jq))
> +		return PTR_ERR(jq);
> +
> +	filp->private_data = jq;
> +
> +	return 0;
> +}
> +
> +static int v4l2_jobqueue_device_release(struct inode *inode, struct file *filp)
> +{
> +	struct v4l2_jobqueue *jq = filp->private_data;
> +
> +	return v4l2_jobqueue_del(jq);
> +}
> +
> +static long v4l2_jobqueue_ioctl_init(struct file *filp, void *arg)
> +{
> +	struct v4l2_jobqueue *jq = filp->private_data;
> +	struct v4l2_jobqueue_init *cinit = arg;
> +
> +	return v4l2_jobqueue_init(jq, cinit);
> +}
> +
> +static long v4l2_jobqueue_device_ioctl_qjob(struct file *filp, void *arg)
> +{
> +	struct v4l2_jobqueue *jq = filp->private_data;
> +
> +	return v4l2_jobqueue_qjob(jq);
> +}
> +
> +static long v4l2_jobqueue_device_ioctl_dqjob(struct file *filp, void *arg)
> +{
> +	struct v4l2_jobqueue *jq = filp->private_data;
> +
> +	return v4l2_jobqueue_dqjob(jq);
> +}
> +
> +static long v4l2_jobqueue_device_ioctl_export_job(struct file *filp, void *arg)
> +{
> +	struct v4l2_jobqueue *jq = filp->private_data;
> +	struct v4l2_jobqueue_job *job = arg;
> +
> +	return v4l2_jobqueue_export_job(jq, job);
> +}
> +
> +static long v4l2_jobqueue_device_ioctl_import_job(struct file *filp, void *arg)
> +{
> +	struct v4l2_jobqueue *jq = filp->private_data;
> +	struct v4l2_jobqueue_job *job = arg;
> +
> +	return v4l2_jobqueue_import_job(jq, job);
> +}
> +
> +static long v4l2_jobqueue_device_do_ioctl(struct file *filp, unsigned int cmd,
> +					  void *arg)
> +{
> +	switch (cmd) {
> +		case VIDIOC_JOBQUEUE_INIT:
> +			return v4l2_jobqueue_ioctl_init(filp, arg);
> +
> +		case VIDIOC_JOBQUEUE_QJOB:
> +			return v4l2_jobqueue_device_ioctl_qjob(filp, arg);
> +
> +		case VIDIOC_JOBQUEUE_DQJOB:
> +			return v4l2_jobqueue_device_ioctl_dqjob(filp, arg);
> +
> +		case VIDIOC_JOBQUEUE_EXPORT_JOB:
> +			return v4l2_jobqueue_device_ioctl_export_job(filp, arg);
> +
> +		case VIDIOC_JOBQUEUE_IMPORT_JOB:
> +			return v4l2_jobqueue_device_ioctl_import_job(filp, arg);

There really is no need for these stub functions, just inline them for each
case.

> +
> +		default:
> +			pr_err("Invalid ioctl!\n");
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static long v4l2_jobqueue_device_ioctl(struct file *filp, unsigned int cmd,
> +				       unsigned long arg)
> +{
> +	return video_usercopy(filp, cmd, arg, v4l2_jobqueue_device_do_ioctl);
> +}
> +
> +static const struct file_operations v4l2_jobqueue_devnode_fops = {
> +	.owner = THIS_MODULE,
> +	.open = v4l2_jobqueue_device_open,
> +	.unlocked_ioctl = v4l2_jobqueue_device_ioctl,
> +#ifdef CONFIG_COMPAT
> +	/* TODO */
> +	/* .compat_ioctl = jobqueue_compat_ioctl, */
> +#endif
> +	.release = v4l2_jobqueue_device_release,
> +};
> +
> +int __init v4l2_jobqueue_device_init(void)
> +{
> +	/* Set to error value so v4l2_jobqueue_device_exit does nothing if we
> +	 * don't initialize properly */
> +	jobqueue_device = ERR_PTR(-EINVAL);
> +
> +	major = register_chrdev(0, DEVICE_NAME, &v4l2_jobqueue_devnode_fops);
> +	if (major < 0) {
> +		pr_err("unable to allocate major\n");
> +		return major;
> +	}
> +
> +	jobqueue_class = class_create(THIS_MODULE, CLASS_NAME);
> +	if (IS_ERR(jobqueue_class)) {
> +		pr_err("cannot create class\n");
> +		unregister_chrdev(major, DEVICE_NAME);
> +		return PTR_ERR(jobqueue_class);
> +	}
> +
> +	jobqueue_device = device_create(jobqueue_class, NULL, MKDEV(major, 0),
> +					NULL, DEVICE_NAME);
> +	if (IS_ERR(jobqueue_device)) {
> +		pr_err("cannot create device\n");
> +		class_destroy(jobqueue_class);
> +		unregister_chrdev(major, DEVICE_NAME);
> +		return PTR_ERR(jobqueue_device);
> +	}
> +
> +	return 0;
> +}
> +
> +void __exit v4l2_jobqueue_device_exit(void)
> +{
> +	if (IS_ERR(jobqueue_device))
> +		return;
> +
> +	device_destroy(jobqueue_class, MKDEV(major, 0));
> +	class_destroy(jobqueue_class);
> +	unregister_chrdev(major, DEVICE_NAME);
> +}

<snip>

> diff --git a/drivers/media/v4l2-core/v4l2-jobqueue.c b/drivers/media/v4l2-core/v4l2-jobqueue.c
> new file mode 100644
> index 000000000000..36d2dd48b086
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-jobqueue.c
> @@ -0,0 +1,764 @@
> +/*
> +    V4L2 job queue implementation
> +
> +    Copyright (C) 2017  The Chromium project
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> + */
> +
> +#include <linux/compat.h>
> +#include <linux/export.h>
> +#include <linux/string.h>
> +#include <linux/file.h>
> +#include <linux/list.h>
> +#include <linux/kref.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/workqueue.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-jobqueue.h>
> +#include <media/v4l2-job-state.h>
> +#include <uapi/linux/v4l2-jobs.h>
> +
> +/* Limited by the size of atomic_t to track devices that completed a job */
> +#define V4L2_JOBQUEUE_MAX_DEVICES sizeof(atomic_t)
> +
> +/*
> + * State of all managed devices for a given job
> + */
> +struct v4l2_job {
> +	struct kref refcount;
> +	struct v4l2_jobqueue *jq;
> +	/* node in v4l2_jobqueue's queued_jobs or completed_jobs */
> +	struct list_head node;
> +	/* global list of existing jobs for this queue */
> +	struct list_head jobs_list;
> +	/* mask of devices that completed this job */
> +	atomic_t completed;
> +	/* fd exported to user-space */
> +	int fd;
> +	enum v4l2_job_status status;
> +
> +	/* per-device states */
> +	struct v4l2_job_state *state[0];
> +};
> +
> +/*
> + * A job queue manages the job flow for a given set of devices, applies their
> + * state, and activates them in lockstep.
> + *
> + * A job goes through the following stages through its life:
> + *
> + * * current_job: the job has been created and is waiting to be queued. S_CTRL
> + *   will apply to it. Once queued, it is pushed into
> + * * queued_jobs: a queue of jobs to be processed in sequential order. The head
> + *   of this list becomes the
> + * * active_job: the job currently being processed by the hardware. Once
> + *   completed, the next job in queued_job becomes active, and the previous
> + *   active job goes into
> + * * completed_jobs: a list of completed jobs waiting to be dequeued by
> + *   user-space. As user-space called the DQJOB ioctl, the head becomes the
> + * * dequeued_job: the job on which G_CTRL will be performed on. A job stays
> + *   in this state until another one is dequeued, at which point it is deleted.
> + */
> +struct v4l2_jobqueue {
> +	/* List of all jobs created for this queue, regardless of state */
> +	struct list_head jobs_list;
> +	/*
> +	 * Job that user-space is currently preparing, to be added to
> +	 * queued_jobs upon QJOB ioctl.
> +	 */
> +	struct v4l2_job *current_job;
> +
> +	/* List of jobs that are ready to be processed */
> +	struct list_head queued_jobs;
> +
> +	/* Job that is currently processed by the devices */
> +	struct v4l2_job *active_job;

Shouldn't this be a list as well? I interpret 'active job' as being a
job that is passed to the various drivers that need to process it.

Just as with video buffers where the hardware may need a minimum of
buffers before it can start the DMA (min_buffers_needed), so the same
is true for jobs. E.g. a driver may have to look ahead by a few frames
to see what changes are requested. Some changes (esp. sensor related)
can take a few frames before they take effect and the hardware has to
be programmed ahead of time.

It would make more sense if this was a list of active jobs. It would
likely also solve the TODOs you have in the code w.r.t. min_buffers_needed:
after STREAMON you'd just queue the jobs to the active list, and also
queue any associated buffers. Once the minimum number of buffers has been
reached the DMA is started.

> +
> +	/* List of completed jobs, ready to be dequeued */
> +	struct list_head completed_jobs;
> +
> +	/* Job that has last been dequeued and can be queried by user-space */
> +	struct v4l2_job *dequeued_job;
> +
> +	/* Projects the *_job[s] lists/pointers above */
> +	struct mutex lock;
> +	struct work_struct job_complete_work;
> +
> +	wait_queue_head_t done_wq;
> +
> +	unsigned int nb_devs;
> +	struct {
> +		struct file *f;
> +		struct v4l2_job_state_handler *state_handler;
> +	} *devs;
> +};

<snip>

> diff --git a/include/uapi/linux/v4l2-jobs.h b/include/uapi/linux/v4l2-jobs.h
> new file mode 100644
> index 000000000000..2cba4d20e62f
> --- /dev/null
> +++ b/include/uapi/linux/v4l2-jobs.h
> @@ -0,0 +1,40 @@
> +/*
> + * V4L2 jobs API
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __LINUX_V4L2_JOBS_H
> +#define __LINUX_V4L2_JOBS_H
> +
> +#ifndef __KERNEL__
> +#include <stdint.h>
> +#endif
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +struct v4l2_jobqueue_init {
> +	__u32 nb_devs;
> +	__s32 *fd;
> +};
> +
> +struct v4l2_jobqueue_job {
> +	__s32 fd;
> +};
> +
> +#define VIDIOC_JOBQUEUE_IOCTL_START	0x80

Why this offset?

> +
> +#define VIDIOC_JOBQUEUE_INIT		_IOW('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x00, struct v4l2_jobqueue_init)
> +#define VIDIOC_JOBQUEUE_QJOB		_IO('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x01)
> +#define VIDIOC_JOBQUEUE_DQJOB		_IO('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x02)
> +#define VIDIOC_JOBQUEUE_EXPORT_JOB	_IOR('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x03, struct v4l2_jobqueue_job)
> +#define VIDIOC_JOBQUEUE_IMPORT_JOB	_IOW('|', VIDIOC_JOBQUEUE_IOCTL_START + 0x03, struct v4l2_jobqueue_job)
> +
> +#endif
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 45cf7359822c..7f43e97cf461 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1591,6 +1591,8 @@ struct v4l2_ext_controls {
>  #define V4L2_CTRL_MAX_DIMS	  (4)
>  #define V4L2_CTRL_WHICH_CUR_VAL   0
>  #define V4L2_CTRL_WHICH_DEF_VAL   0x0f000000
> +#define V4L2_CTRL_WHICH_CURJOB_VAL   0x0e000000
> +#define V4L2_CTRL_WHICH_DEQJOB_VAL   0x0d000000
>  
>  enum v4l2_ctrl_type {
>  	V4L2_CTRL_TYPE_INTEGER	     = 1,
> 

Regards,

	Hans
