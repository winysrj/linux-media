Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:56864 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbdI1Jv2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:51:28 -0400
Received: by mail-pg0-f51.google.com with SMTP id 7so654777pgd.13
        for <linux-media@vger.kernel.org>; Thu, 28 Sep 2017 02:51:28 -0700 (PDT)
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
Subject: [RFC PATCH 9/9] [media] document jobs API
Date: Thu, 28 Sep 2017 18:50:27 +0900
Message-Id: <20170928095027.127173-10-acourbot@chromium.org>
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
References: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Still a work-in-progress, but hopefully conveys the general idea.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 Documentation/media/intro.rst                      |   2 +
 Documentation/media/media_uapi.rst                 |   1 +
 Documentation/media/uapi/jobs/jobs-api.rst         |  23 +++
 Documentation/media/uapi/jobs/jobs-example.rst     |  69 ++++++++
 Documentation/media/uapi/jobs/jobs-intro.rst       |  61 +++++++
 Documentation/media/uapi/jobs/jobs-queue.rst       |  73 ++++++++
 Documentation/media/uapi/jobs/jobs-queue.svg       | 192 +++++++++++++++++++++
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |   6 +
 8 files changed, 427 insertions(+)
 create mode 100644 Documentation/media/uapi/jobs/jobs-api.rst
 create mode 100644 Documentation/media/uapi/jobs/jobs-example.rst
 create mode 100644 Documentation/media/uapi/jobs/jobs-intro.rst
 create mode 100644 Documentation/media/uapi/jobs/jobs-queue.rst
 create mode 100644 Documentation/media/uapi/jobs/jobs-queue.svg

diff --git a/Documentation/media/intro.rst b/Documentation/media/intro.rst
index 9ce2e23a0236..e39a9dd3444a 100644
--- a/Documentation/media/intro.rst
+++ b/Documentation/media/intro.rst
@@ -38,6 +38,8 @@ divided into five parts.
 
 5. The :ref:`fifth part <cec>` covers the CEC (Consumer Electronics Control) API.
 
+6. The :ref:`sixth part <jobsapi>` covers the jobs API.
+
 It should also be noted that a media device may also have audio components, like
 mixers, PCM capture, PCM playback, etc, which are controlled via ALSA API.  For
 additional information and for the latest development code, see:
diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index fd8ebe002cd2..254e3d085abc 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -27,5 +27,6 @@ License".
     uapi/rc/remote_controllers
     uapi/mediactl/media-controller
     uapi/cec/cec-api
+    uapi/jobs/jobs-api
     uapi/gen-errors
     uapi/fdl-appendix
diff --git a/Documentation/media/uapi/jobs/jobs-api.rst b/Documentation/media/uapi/jobs/jobs-api.rst
new file mode 100644
index 000000000000..3a7aa8568e93
--- /dev/null
+++ b/Documentation/media/uapi/jobs/jobs-api.rst
@@ -0,0 +1,23 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. include:: <isonum.txt>
+
+.. _jobsapi:
+
+##################
+Part VI - Jobs API
+##################
+
+This part describes the V4L2 Jobs API.
+
+.. class:: toc-title
+
+        Table of Contents
+
+.. toctree::
+    :maxdepth: 5
+    :numbered:
+
+    jobs-intro
+    jobs-queue
+    jobs-example
diff --git a/Documentation/media/uapi/jobs/jobs-example.rst b/Documentation/media/uapi/jobs/jobs-example.rst
new file mode 100644
index 000000000000..0b725dfb58bd
--- /dev/null
+++ b/Documentation/media/uapi/jobs/jobs-example.rst
@@ -0,0 +1,69 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _jobs-example:
+
+===========================================
+Example: Using the Jobs API for HDR capture
+===========================================
+
+HDR capturing involves taking two shots of the same image with different
+exposure settings. When using the V4L2 API, one must wait for the first shot to
+be completed before updating the exposure and taking the second one, introducing
+synchronization with user-space and potential delays for the second image.
+
+The Jobs API allows us to simply submit two jobs with different exposure
+parameters, and to dequeue their buffers to get the result.
+
+The following example shows how to do this on a capture device with the exposure
+control. It assumes that the capture device has already been opened and its
+format set. To keep the code simple this code does not handle errors.
+
+.. code-block:: c
+
+    struct v4l2_ext_control ctrl[1];
+    struct v4l2_ext_controls ctrls;
+    struct v4l2_jobqueue_init jq_init;
+    struct v4l2_buffer buf[2];
+    int jq_fd;
+
+    /* FD for the jobs queue */
+    jq_fd = open("/dev/v4l2_jobqueue");
+
+    /* Initialize the jobs queue */
+    jq_init.nb_devs = 1;
+    jq_init.fd[0] = capture_fd;
+    ioctl(jq_fd, VIDIOC_JOBQUEUE_INIT, &jq_init);
+
+    /* Prepare and submit the first capture job, low exposure */
+    ctrl[0].id = V4L2_CID_EXPOSURE;
+    ctrl[0].value = 32;
+    ctrls.which = V4L2_CTRL_WHICH_CURJOB_VAL;
+    ctrls.count = 1;
+    ctrsl.controls = ctrl;
+    ioctl(capture_fd, VICIOC_S_EXT_CTRLS, &ctrls);
+    ioctl(capture_fd, VIDIOC_QBUF, &buf[0]);
+    ioctl(jq_fd, VIDIOC_JOBQUEUE_QJOB, NULL);
+
+    /* Prepare and submit the second capture job, high exposure */
+    ctrl[0].id = V4L2_CID_EXPOSURE;
+    ctrl[0].value = 192;
+    ctrls.which = V4L2_CTRL_WHICH_CURJOB_VAL;
+    ctrls.count = 1;
+    ctrsl.controls = ctrl;
+    ioctl(capture_fd, VICIOC_S_EXT_CTRLS, &ctrls);
+    ioctl(capture_fd, VIDIOC_QBUF, &buf[1]);
+    ioctl(jq_fd, VIDIOC_JOBQUEUE_QJOB, NULL);
+
+    /* Dequeue buffers with the captured data */
+    ioctl(capture_fd, VIDIOC_DQBUF, &buf[0]);
+    ioctl(capture_fd, VIDIOC_DQBUF, &buf[1]);
+
+    /* Dequeue jobs and confirm exposure parameters */
+    ioctl(jq_fd, VIDIOC_JOBQUEUE_DQJOB, NULL);
+    ctrls.which = V4L2_CTRL_WHICH_DEQJOB_VAL
+    ioctl(fd, VIDIOC_G_EXT_CTRLS, &ctrls);
+    printf("Exposure for first capture: %d\n", ctrl[0].value);
+
+    ioctl(jq_fd, VIDIOC_JOBQUEUE_DQJOB, NULL);
+    ioctl(fd, VIDIOC_G_EXT_CTRLS, &ctrls);
+    printf("Exposure for second capture: %d\n", ctrl[0].value);
diff --git a/Documentation/media/uapi/jobs/jobs-intro.rst b/Documentation/media/uapi/jobs/jobs-intro.rst
new file mode 100644
index 000000000000..34d7efe5bcfb
--- /dev/null
+++ b/Documentation/media/uapi/jobs/jobs-intro.rst
@@ -0,0 +1,61 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _jobs-intro:
+
+============
+Introduction
+============
+
+The Jobs API allows to submit units of work ("jobs") to be processed
+cooperatively by a set of opened devices. The state of jobs can be set and
+queried independently from the actual hardware state, which means that
+user-space does not need to explicitly wait for a job to finish before
+submitting a new one with different parameters.
+
+The Jobs API is suitable for several workflows:
+
+- A set of devices need to cooperate on a given work, e.g. MIPI capture devices.
+In this case the Jobs API ensures that all devices are properly set up for
+processing the work.
+
+- Asynchronous submission of works with different parameters. Especially useful
+for stateless codecs, but can also facilitate capture use-cases like HDR where
+two frames with different exposures need to be captured as quickly as possible.
+
+- Quick switch between several states without having to explicitly reprogram
+them. A job can be kept in memory and be reapplied at a future time.
+
+A job's will usually be used as follows:
+
+1. The state of the job is defined using the standard V4L2 API: controls,
+formats, and other parameters are set, and buffers are queued on all devices
+that take part in the job.
+
+2. The job is queued. All set parameters are applied, and the queued buffers are
+processed.
+
+3. The job is dequeued. Output controls at the time of job completion can be
+read back. If another job is queued, it is processed.
+
+Jobs are submitted to a jobs queue which processes them in sequential order.
+Similarly to buffers, jobs must be dequeued and the state of the devices at the
+time of job completion can then be read back.
+
+The Jobs API extends the existing V4L2 API and slightly changes the behavior of
+some existing commands when in use. This part will describe the new APIs and how
+to use them.
+
+WARNING: This is a work-in-progress. Comments are welcome. Many pieces are
+missing, while some are subject to change. The list of missing pieces and open
+questions include notably:
+
+- No format or crop setting
+- No support for non-integer controls (this requires some rework of the control
+framework)
+- No support for media controller devices yet
+- No error reporting when something unexpected happens while a job is being
+processed
+- It is probably not desirable to have a /dev/v4l2_jobsqueue device node for
+managing jobs, but this makes testing easier at the moment.
+- Jobs should have identifiers to make them easier to identify by user-space
+- Dequeued buffers should carry the id of the job they were associated to
diff --git a/Documentation/media/uapi/jobs/jobs-queue.rst b/Documentation/media/uapi/jobs/jobs-queue.rst
new file mode 100644
index 000000000000..ecfc8dd46302
--- /dev/null
+++ b/Documentation/media/uapi/jobs/jobs-queue.rst
@@ -0,0 +1,73 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _jobs-queue:
+
+==============
+The Jobs Queue
+==============
+
+A jobs queue is instanciated from a set of already opened V4L2 devices, and
+controls their behavior with atomic (from the user perspective) units of work
+called jobs. User-space prepares a job by setting its desired state through
+controls and formats, queuing the buffers to be processed for the job, and
+finally queuing the job itself once it is ready. The hardware state will not be
+affected until the job is effectively processed.
+
+Figure :ref:`jobs-queue` shows the life cycle of jobs within the queue:
+
+.. kernel-figure:: jobs-queue.svg
+    :alt:   Life of a job inside the jobs queue
+    :align: center
+
+User-space creates a jobs queue by opening the jobs queue device and invoking
+the :c:func:`VIDIOC_JOBQUEUE_INIT` ioctl with the list of opened file
+descriptors of the devices being part of the new queue. After this, all the
+passed devices are ready to perform according to the jobs API semantics, and the
+opened jobs queue can accept queue and dequeue ioctls.
+
+Upon job queue creation, the first job is instanciated and ready to be prepared
+and queued (we refer to this as the "current job"). User-space prepares the job
+using variants of the regular V4L2 ioctls: for instance, in order to set
+controls on a job, one will invoke :c:func:`VIDIOC_S_EXT_CTRLS` with
+V4L2_CTRL_WHICH_CURJOB_VAL.
+
+The current job can be submitted using the :c:func:`VIDIOC_JOBQUEUE_QJOB` ioctl
+when it is ready. A new job is immediately created and becomes the new active
+job.
+
+Queued jobs are processed sequentially. As a job is processed, its parameters
+for every device that is part of the queue are applied, and all its buffers are
+processed. Once completed, the job is ready to be dequeued.
+
+Buffers can be dequeued independently of jobs. This allows a buffer that is
+produced in the middle of the pipeline to be dequeued and used before the entire
+job completes. However jobs **must** be dequeued at some point to avoid
+accumulation of completed jobs. This is done using the
+:c:func:`VIDIOC_JOBQUEUE_DQJOB` ioctl. User-space can then read the state of the
+dequeued job at the time of its completion. For instance, in order to read the
+values of controls at the time the dequeued job completed, one will invoke
+:c:func:`VIDIOC_QUERY_EXT_CTRL` with V4L2_CTRL_WHICH_DEQJOB_VAL.
+
+Note that regular, unmodified ioctls will continue working as usual: for
+instance, invoking :c:func:`VIDIOC_S_EXT_CTRLS` with V4L2_CTRL_WHICH_CUR_VAL
+will immediately change the value of submitted controls. The only difference
+when the jobs API is used is that buffers queued on devices that are part of a
+jobs queue are not processed until the current job of that queue is submitted.
+
+By default, jobs are purely sequential: a new job is created as soon as the
+current job is queued, and becomes the new current job. This new current job
+initially has an empty state, meaning that its expected state is the state of
+the previously queued job after it completes. Once a dequeued job is replaced by
+the next one, it is deleted.
+
+For some use-cases however, it may make sense to reapply the exact state of a
+previous job. The jobs API allows to do so using the
+:c:func:`VIDIOC_JOBQUEUE_EXPORT_JOB` and :c:func:`VIDIOC_JOBQUEUE_IMPORT_JOB`
+ioctls.
+
+:c:func:`VIDIOC_JOBQUEUE_EXPORT_JOB` returns a file descriptor that represents
+the current job, which will be preserved in memory until that file descriptor is
+closed. By passing that file descriptor to the
+:c:func:`VIDIOC_JOBQUEUE_IMPORT_JOB`, the current job is replaced by the job
+represented by the file descriptor. User-space can then tune the state of the
+job, queue new buffers, and submit the job to be processed again.
diff --git a/Documentation/media/uapi/jobs/jobs-queue.svg b/Documentation/media/uapi/jobs/jobs-queue.svg
new file mode 100644
index 000000000000..e6d9408fd1df
--- /dev/null
+++ b/Documentation/media/uapi/jobs/jobs-queue.svg
@@ -0,0 +1,192 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
+<svg width="33cm" height="23cm" viewBox="96 61 644 457" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
+  <text font-size="12.7998" style="fill: #000000;text-anchor:start;font-family:sans-serif;font-style:normal;font-weight:normal" x="198.6" y="319.8">
+    <tspan x="198.6" y="319.8"></tspan>
+  </text>
+  <g>
+    <rect style="fill: #a3d5eb" x="129.6" y="404" width="138" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="129.6" y="404" width="138" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="198.6" y="435.322">
+      <tspan x="198.6" y="435.322">Current</tspan>
+    </text>
+  </g>
+  <text font-size="12.7998" style="fill: #000000;text-anchor:start;font-family:sans-serif;font-style:normal;font-weight:normal" x="198.6" y="304.4">
+    <tspan x="198.6" y="304.4"></tspan>
+  </text>
+  <g>
+    <rect style="fill: #a3d5eb" x="129.6" y="262.6" width="138" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="129.6" y="262.6" width="138" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="198.6" y="293.922">
+      <tspan x="198.6" y="293.922"></tspan>
+    </text>
+  </g>
+  <text font-size="12.7998" style="fill: #000000;text-anchor:start;font-family:sans-serif;font-style:normal;font-weight:normal" x="198.6" y="289.1">
+    <tspan x="198.6" y="289.1"></tspan>
+  </text>
+  <g>
+    <rect style="fill: #a3d5eb" x="129.6" y="277.9" width="138" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="129.6" y="277.9" width="138" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="198.6" y="309.222">
+      <tspan x="198.6" y="309.222"></tspan>
+    </text>
+  </g>
+  <g>
+    <rect style="fill: #a3d5eb" x="129.6" y="293.3" width="138" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="129.6" y="293.3" width="138" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="198.6" y="324.622">
+      <tspan x="198.6" y="324.622">Queued</tspan>
+    </text>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="198.6" y1="404" x2="198.6" y2="357.3"/>
+    <polygon style="fill: #000000" points="203.6,357.3 198.6,347.3 193.6,357.3 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="203.6,357.3 198.6,347.3 193.6,357.3 "/>
+  </g>
+  <text font-size="12.7998" style="fill: #000000;text-anchor:start;font-family:sans-serif;font-style:normal;font-weight:normal" x="613.6" y="320.5">
+    <tspan x="613.6" y="320.5"></tspan>
+  </text>
+  <g>
+    <rect style="fill: #a3d5eb" x="544.6" y="404.7" width="138" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="544.6" y="404.7" width="138" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="613.6" y="436.022">
+      <tspan x="613.6" y="436.022">Dequeued</tspan>
+    </text>
+  </g>
+  <text font-size="12.7998" style="fill: #000000;text-anchor:start;font-family:sans-serif;font-style:normal;font-weight:normal" x="613.6" y="305.1">
+    <tspan x="613.6" y="305.1"></tspan>
+  </text>
+  <g>
+    <rect style="fill: #a3d5eb" x="544.6" y="263.3" width="138" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="544.6" y="263.3" width="138" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="613.6" y="294.622">
+      <tspan x="613.6" y="294.622"></tspan>
+    </text>
+  </g>
+  <text font-size="12.7998" style="fill: #000000;text-anchor:start;font-family:sans-serif;font-style:normal;font-weight:normal" x="613.6" y="289.8">
+    <tspan x="613.6" y="289.8"></tspan>
+  </text>
+  <g>
+    <rect style="fill: #a3d5eb" x="544.6" y="278.6" width="138" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="544.6" y="278.6" width="138" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="613.6" y="309.922">
+      <tspan x="613.6" y="309.922"></tspan>
+    </text>
+  </g>
+  <g>
+    <rect style="fill: #a3d5eb" x="544.6" y="294" width="138" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="544.6" y="294" width="138" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="613.6" y="325.322">
+      <tspan x="613.6" y="325.322">Completed</tspan>
+    </text>
+  </g>
+  <text font-size="12.7998" style="fill: #000000;text-anchor:start;font-family:sans-serif;font-style:normal;font-weight:normal" x="648.1" y="316.3">
+    <tspan x="648.1" y="316.3"></tspan>
+  </text>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="98" y1="480" x2="724.125" y2="480.75"/>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="613.6" y1="347" x2="613.6" y2="393.7"/>
+    <polygon style="fill: #000000" points="608.6,393.7 613.6,403.7 618.6,393.7 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="608.6,393.7 613.6,403.7 618.6,393.7 "/>
+  </g>
+  <text font-size="12.7998" style="fill: #000000;text-anchor:start;font-family:sans-serif;font-style:normal;font-weight:normal" x="101" y="515">
+    <tspan x="101" y="515">S_EXT_CTRL(WHICH_JOB_CUR_VAL)</tspan>
+  </text>
+  <text font-size="12.7998" style="fill: #000000;text-anchor:start;font-family:sans-serif;font-style:normal;font-weight:normal" x="518" y="515.187">
+    <tspan x="518" y="515.187">G_EXT_CTRL(WHICH_DEQJOB_VAL)</tspan>
+  </text>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="151.125" y1="495.293" x2="150.778" y2="470.292"/>
+    <polygon style="fill: #000000" points="155.777,470.222 150.639,460.293 145.778,470.361 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="155.777,470.222 150.639,460.293 145.778,470.361 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="175.991" y1="495.293" x2="175.644" y2="470.292"/>
+    <polygon style="fill: #000000" points="180.643,470.222 175.505,460.293 170.644,470.361 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="180.643,470.222 175.505,460.293 170.644,470.361 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="200.857" y1="495.293" x2="200.51" y2="470.292"/>
+    <polygon style="fill: #000000" points="205.51,470.222 200.371,460.293 195.511,470.361 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="205.51,470.222 200.371,460.293 195.511,470.361 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="225.723" y1="495.293" x2="225.376" y2="470.292"/>
+    <polygon style="fill: #000000" points="230.376,470.222 225.237,460.293 220.377,470.361 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="230.376,470.222 225.237,460.293 220.377,470.361 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="250.59" y1="495.293" x2="250.242" y2="470.292"/>
+    <polygon style="fill: #000000" points="255.242,470.222 250.104,460.293 245.243,470.361 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="255.242,470.222 250.104,460.293 245.243,470.361 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="565.187" y1="485.337" x2="564.84" y2="460.336"/>
+    <polygon style="fill: #000000" points="560.187,485.406 565.326,495.336 570.186,485.267 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="560.187,485.406 565.326,495.336 570.186,485.267 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="590.053" y1="485.337" x2="589.706" y2="460.336"/>
+    <polygon style="fill: #000000" points="585.054,485.406 590.192,495.336 595.053,485.267 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="585.054,485.406 590.192,495.336 595.053,485.267 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="614.919" y1="485.337" x2="614.572" y2="460.336"/>
+    <polygon style="fill: #000000" points="609.92,485.406 615.058,495.336 619.919,485.267 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="609.92,485.406 615.058,495.336 619.919,485.267 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="639.785" y1="485.337" x2="639.438" y2="460.336"/>
+    <polygon style="fill: #000000" points="634.786,485.406 639.924,495.336 644.785,485.267 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="634.786,485.406 639.924,495.336 644.785,485.267 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="664.652" y1="485.337" x2="664.304" y2="460.336"/>
+    <polygon style="fill: #000000" points="659.652,485.406 664.79,495.336 669.651,485.267 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="659.652,485.406 664.79,495.336 669.651,485.267 "/>
+  </g>
+  <g>
+    <rect style="fill: #a3d5eb" x="344.875" y="155.6" width="138" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="344.875" y="155.6" width="138" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="413.875" y="186.922">
+      <tspan x="413.875" y="186.922">Active</tspan>
+    </text>
+  </g>
+  <g>
+    <polyline style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="198.6,262.6 198.6,182.1 333.875,182.1 "/>
+    <polygon style="fill: #000000" points="333.875,187.1 343.875,182.1 333.875,177.1 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="333.875,187.1 343.875,182.1 333.875,177.1 "/>
+  </g>
+  <g>
+    <polyline style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="482.875,182.1 613.6,182.1 613.6,252.3 "/>
+    <polygon style="fill: #000000" points="608.6,252.3 613.6,262.3 618.6,252.3 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="608.6,252.3 613.6,262.3 618.6,252.3 "/>
+  </g>
+  <g>
+    <rect style="fill: #ffe283" x="289.125" y="62.6" width="249.5" height="53"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="289.125" y="62.6" width="249.5" height="53"/>
+    <text font-size="15.8042" style="fill: #000000;text-anchor:middle;font-family:sans-serif;font-style:normal;font-weight:normal" x="413.875" y="93.9222">
+      <tspan x="413.875" y="93.9222">Devices</tspan>
+    </text>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="369.34" y1="154.011" x2="368.992" y2="129.01"/>
+    <polygon style="fill: #000000" points="373.992,128.94 368.854,119.011 363.993,129.079 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="373.992,128.94 368.854,119.011 363.993,129.079 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="454.59" y1="154.011" x2="454.242" y2="129.01"/>
+    <polygon style="fill: #000000" points="459.242,128.94 454.104,119.011 449.243,129.079 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="459.242,128.94 454.104,119.011 449.243,129.079 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="397.423" y1="142.29" x2="397.076" y2="117.289"/>
+    <polygon style="fill: #000000" points="392.423,142.359 397.562,152.289 402.422,142.22 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="392.423,142.359 397.562,152.289 402.422,142.22 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="425.84" y1="142.29" x2="425.492" y2="117.289"/>
+    <polygon style="fill: #000000" points="420.84,142.359 425.978,152.289 430.839,142.22 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="420.84,142.359 425.978,152.289 430.839,142.22 "/>
+  </g>
+</svg>
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 5ab8d2ac27b9..035d5e29bd2e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -216,6 +216,12 @@ still cause this situation.
 	   You can only get the default value of the control,
 	   you cannot set or try it.
 
+	When the Jobs API is active ``V4L2_CTRL_WHICH_CURJOB_VAL`` will return or set the value of the current job, while ``V4L2_CTRL_WHICH_DEQJOB_VAL`` returns the value of the currently dequeued job.
+
+	.. note::
+
+	   It is invalid to try and set the value of the dequeued job.
+
 	For backwards compatibility you can also use a control class here
 	(see :ref:`ctrl-class`). In that case all controls have to
 	belong to that control class. This usage is deprecated, instead
-- 
2.14.2.822.g60be5d43e6-goog
