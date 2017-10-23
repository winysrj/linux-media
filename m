Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:43278 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbdJWIfy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 04:35:54 -0400
Received: by mail-it0-f49.google.com with SMTP id k70so5207241itk.0
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 01:35:54 -0700 (PDT)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com. [209.85.214.52])
        by smtp.gmail.com with ESMTPSA id g81sm2999482ioe.50.2017.10.23.01.35.52
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Oct 2017 01:35:53 -0700 (PDT)
Received: by mail-it0-f52.google.com with SMTP id 72so5009657itk.3
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 01:35:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e602666f-cde2-3c77-3ad1-f6f800a4bfdd@xs4all.nl>
References: <20170928095027.127173-1-acourbot@chromium.org>
 <20170928095027.127173-3-acourbot@chromium.org> <e602666f-cde2-3c77-3ad1-f6f800a4bfdd@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 23 Oct 2017 17:35:31 +0900
Message-ID: <CAPBb6MVuhbwcef0M68+QugoWqr_Uw-voMhcUd4-b6URyaSbKYA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] [media] v4l2-core: add core jobs API support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Oct 16, 2017 at 7:01 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> +static long v4l2_jobqueue_device_do_ioctl(struct file *filp, unsigned int cmd,
>> +                                       void *arg)
>> +{
>> +     switch (cmd) {
>> +             case VIDIOC_JOBQUEUE_INIT:
>> +                     return v4l2_jobqueue_ioctl_init(filp, arg);
>> +
>> +             case VIDIOC_JOBQUEUE_QJOB:
>> +                     return v4l2_jobqueue_device_ioctl_qjob(filp, arg);
>> +
>> +             case VIDIOC_JOBQUEUE_DQJOB:
>> +                     return v4l2_jobqueue_device_ioctl_dqjob(filp, arg);
>> +
>> +             case VIDIOC_JOBQUEUE_EXPORT_JOB:
>> +                     return v4l2_jobqueue_device_ioctl_export_job(filp, arg);
>> +
>> +             case VIDIOC_JOBQUEUE_IMPORT_JOB:
>> +                     return v4l2_jobqueue_device_ioctl_import_job(filp, arg);
>
> There really is no need for these stub functions, just inline them for each
> case.

Indeed!

>> diff --git a/drivers/media/v4l2-core/v4l2-jobqueue.c b/drivers/media/v4l2-core/v4l2-jobqueue.c
>> new file mode 100644
>> index 000000000000..36d2dd48b086
>> --- /dev/null
>> +++ b/drivers/media/v4l2-core/v4l2-jobqueue.c
>> @@ -0,0 +1,764 @@
>> +/*
>> +    V4L2 job queue implementation
>> +
>> +    Copyright (C) 2017  The Chromium project
>> +
>> +    This program is free software; you can redistribute it and/or modify
>> +    it under the terms of the GNU General Public License as published by
>> +    the Free Software Foundation; either version 2 of the License, or
>> +    (at your option) any later version.
>> +
>> +    This program is distributed in the hope that it will be useful,
>> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +    GNU General Public License for more details.
>> +
>> + */
>> +
>> +#include <linux/compat.h>
>> +#include <linux/export.h>
>> +#include <linux/string.h>
>> +#include <linux/file.h>
>> +#include <linux/list.h>
>> +#include <linux/kref.h>
>> +#include <linux/anon_inodes.h>
>> +#include <linux/slab.h>
>> +#include <linux/mutex.h>
>> +#include <linux/workqueue.h>
>> +#include <media/v4l2-dev.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-jobqueue.h>
>> +#include <media/v4l2-job-state.h>
>> +#include <uapi/linux/v4l2-jobs.h>
>> +
>> +/* Limited by the size of atomic_t to track devices that completed a job */
>> +#define V4L2_JOBQUEUE_MAX_DEVICES sizeof(atomic_t)
>> +
>> +/*
>> + * State of all managed devices for a given job
>> + */
>> +struct v4l2_job {
>> +     struct kref refcount;
>> +     struct v4l2_jobqueue *jq;
>> +     /* node in v4l2_jobqueue's queued_jobs or completed_jobs */
>> +     struct list_head node;
>> +     /* global list of existing jobs for this queue */
>> +     struct list_head jobs_list;
>> +     /* mask of devices that completed this job */
>> +     atomic_t completed;
>> +     /* fd exported to user-space */
>> +     int fd;
>> +     enum v4l2_job_status status;
>> +
>> +     /* per-device states */
>> +     struct v4l2_job_state *state[0];
>> +};
>> +
>> +/*
>> + * A job queue manages the job flow for a given set of devices, applies their
>> + * state, and activates them in lockstep.
>> + *
>> + * A job goes through the following stages through its life:
>> + *
>> + * * current_job: the job has been created and is waiting to be queued. S_CTRL
>> + *   will apply to it. Once queued, it is pushed into
>> + * * queued_jobs: a queue of jobs to be processed in sequential order. The head
>> + *   of this list becomes the
>> + * * active_job: the job currently being processed by the hardware. Once
>> + *   completed, the next job in queued_job becomes active, and the previous
>> + *   active job goes into
>> + * * completed_jobs: a list of completed jobs waiting to be dequeued by
>> + *   user-space. As user-space called the DQJOB ioctl, the head becomes the
>> + * * dequeued_job: the job on which G_CTRL will be performed on. A job stays
>> + *   in this state until another one is dequeued, at which point it is deleted.
>> + */
>> +struct v4l2_jobqueue {
>> +     /* List of all jobs created for this queue, regardless of state */
>> +     struct list_head jobs_list;
>> +     /*
>> +      * Job that user-space is currently preparing, to be added to
>> +      * queued_jobs upon QJOB ioctl.
>> +      */
>> +     struct v4l2_job *current_job;
>> +
>> +     /* List of jobs that are ready to be processed */
>> +     struct list_head queued_jobs;
>> +
>> +     /* Job that is currently processed by the devices */
>> +     struct v4l2_job *active_job;
>
> Shouldn't this be a list as well? I interpret 'active job' as being a
> job that is passed to the various drivers that need to process it.
>
> Just as with video buffers where the hardware may need a minimum of
> buffers before it can start the DMA (min_buffers_needed), so the same
> is true for jobs. E.g. a driver may have to look ahead by a few frames
> to see what changes are requested. Some changes (esp. sensor related)
> can take a few frames before they take effect and the hardware has to
> be programmed ahead of time.

Regarding the number of queued frames, frames end up being queued into
the VB2 queue even if they are not passed to the driver, so I guess
the driver can still peek at forward frames through that mechanism.
Same can be done for the list of jobs themselves with the state change
listener.

> It would make more sense if this was a list of active jobs. It would
> likely also solve the TODOs you have in the code w.r.t. min_buffers_needed:
> after STREAMON you'd just queue the jobs to the active list, and also
> queue any associated buffers. Once the minimum number of buffers has been
> reached the DMA is started.

Mmm, but wouldn't that kind of defeat the idea of jobs as a single
unit of work if they needed to be grouped before being processed? I
need to think a bit more about that. Maybe we could pass the buffers
to the drivers prior to their job being scheduled, but I like the idea
of having VB2 managing the buffer's flow as it is easy to screw the
flow otherwise.

>> diff --git a/include/uapi/linux/v4l2-jobs.h b/include/uapi/linux/v4l2-jobs.h
>> new file mode 100644
>> index 000000000000..2cba4d20e62f
>> --- /dev/null
>> +++ b/include/uapi/linux/v4l2-jobs.h
>> @@ -0,0 +1,40 @@
>> +/*
>> + * V4L2 jobs API
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef __LINUX_V4L2_JOBS_H
>> +#define __LINUX_V4L2_JOBS_H
>> +
>> +#ifndef __KERNEL__
>> +#include <stdint.h>
>> +#endif
>> +#include <linux/ioctl.h>
>> +#include <linux/types.h>
>> +
>> +struct v4l2_jobqueue_init {
>> +     __u32 nb_devs;
>> +     __s32 *fd;
>> +};
>> +
>> +struct v4l2_jobqueue_job {
>> +     __s32 fd;
>> +};
>> +
>> +#define VIDIOC_JOBQUEUE_IOCTL_START  0x80
>
> Why this offset?

IIRC this is to avoid collision with other V4L2 ioctls that start at
offset 0. I have not thought this thoroughly however, just wanted to
have something that works for experimenting.

Thanks,
Alex.
