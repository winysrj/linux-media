Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38360 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732735AbeHNRIP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:08:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv18 00/35] Request API
Date: Tue, 14 Aug 2018 16:20:12 +0200
Message-Id: <20180814142047.93856-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

This is version 18 of the Request API series. The intention is that
this will become a topic branch in preparation of merging this for
4.20 together with the cedrus staging driver.

I incorporated Mauro's review comments and a review comment from
Ezequiel in v18.

The main change is that I reverted back to a simple int argument for the
MEDIA_IOC_REQUEST_ALLOC ioctl. Mauro prefers it and I think he is right.
It was what we had originally as well.

Besides all the review comments I also fixed a bug. See:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg134311.html

And sparse warned me about a poll prototype change, so the
media_request_poll() was slightly changed (use of EPOLL* instead of POLL*
and a __poll_t return type).

I also split up the old patch 17/34 into three patches: the first just
moves a function up in the source, the second replaces 'if' statements
with a switch, and the third is the actual patch that does the real
work. There is now much less noise in that patch and it should be much easier
to review.

Finally the RFC debugfs patch has been dropped from this series.

This patch series is also available here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv18

The patched v4l2-compliance (and rebased to the latest v4l-utils
as well) is available here:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=request

To avoid having to do a full review again I made a diff between
v17 and v18 that is much easier to understand. I added it below
the line (note that the removal of the debugfs patch is not included
in this diff, it's not useful).

Regards,

	Hans

Alexandre Courbot (2):
  Documentation: v4l: document request API
  videodev2.h: add request_fd field to v4l2_ext_controls

Hans Verkuil (32):
  uapi/linux/media.h: add request API
  media-request: implement media requests
  media-request: add media_request_get_by_fd
  media-request: add media_request_object_find
  v4l2-device.h: add v4l2_device_supports_requests() helper
  v4l2-dev: lock req_queue_mutex
  v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
  v4l2-ctrls: prepare internal structs for request API
  v4l2-ctrls: alloc memory for p_req
  v4l2-ctrls: use ref in helper instead of ctrl
  v4l2-ctrls: add core request support
  v4l2-ctrls: support g/s_ext_ctrls for requests
  v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/ctrl_find functions
  videobuf2-v4l2: move __fill_v4l2_buffer() function
  videobuf2-v4l2: replace if by switch in __fill_vb2_buffer()
  vb2: store userspace data in vb2_v4l2_buffer
  davinci_vpfe: remove bogus vb2->state check
  vb2: drop VB2_BUF_STATE_PREPARED, use bool prepared/synced instead
  videodev2.h: Add request_fd field to v4l2_buffer
  vb2: add init_buffer buffer op
  videobuf2-core: embed media_request_object
  videobuf2-core: integrate with media requests
  videobuf2-v4l2: integrate with media requests
  videobuf2-core: add request helper functions
  videobuf2-v4l2: add vb2_request_queue/validate helpers
  videobuf2-core: add uses_requests/qbuf flags
  videobuf2-v4l2: refuse qbuf if queue uses requests or vv.
  v4l2-mem2mem: add vb2_m2m_request_queue
  vim2m: use workqueue
  vim2m: support requests
  vivid: add mc
  vivid: add request support

Sakari Ailus (1):
  media: doc: Add media-request.h header to documentation build

 Documentation/media/kapi/mc-core.rst          |   2 +
 .../media/uapi/mediactl/media-controller.rst  |   1 +
 .../media/uapi/mediactl/media-funcs.rst       |   6 +
 .../uapi/mediactl/media-ioc-request-alloc.rst |  65 +++
 .../uapi/mediactl/media-request-ioc-queue.rst |  82 +++
 .../mediactl/media-request-ioc-reinit.rst     |  51 ++
 .../media/uapi/mediactl/request-api.rst       | 245 ++++++++
 .../uapi/mediactl/request-func-close.rst      |  48 ++
 .../uapi/mediactl/request-func-ioctl.rst      |  67 +++
 .../media/uapi/mediactl/request-func-poll.rst |  77 +++
 Documentation/media/uapi/v4l/buffer.rst       |  21 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  53 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  32 +-
 .../media/videodev2.h.rst.exceptions          |   1 +
 drivers/media/Makefile                        |   3 +-
 .../media/common/videobuf2/videobuf2-core.c   | 262 +++++++--
 .../media/common/videobuf2/videobuf2-v4l2.c   | 508 +++++++++++-----
 drivers/media/dvb-core/dvb_vb2.c              |   5 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c     |   5 +-
 drivers/media/media-device.c                  |  24 +-
 drivers/media/media-request.c                 | 489 ++++++++++++++++
 drivers/media/pci/bt8xx/bttv-driver.c         |   2 +-
 drivers/media/pci/cx23885/cx23885-417.c       |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c       |   2 +-
 drivers/media/pci/cx88/cx88-video.c           |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c   |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c     |   2 +-
 .../media/platform/exynos4-is/fimc-capture.c  |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c    |   4 +-
 drivers/media/platform/rcar-vin/rcar-core.c   |   2 +-
 drivers/media/platform/rcar_drif.c            |   2 +-
 .../media/platform/s3c-camif/camif-capture.c  |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |   4 +-
 .../media/platform/soc_camera/soc_camera.c    |   7 +-
 drivers/media/platform/vim2m.c                |  49 +-
 drivers/media/platform/vivid/vivid-core.c     |  69 +++
 drivers/media/platform/vivid/vivid-core.h     |   8 +
 drivers/media/platform/vivid/vivid-ctrls.c    |  46 +-
 .../media/platform/vivid/vivid-kthread-cap.c  |  12 +
 .../media/platform/vivid/vivid-kthread-out.c  |  12 +
 drivers/media/platform/vivid/vivid-sdr-cap.c  |  16 +
 drivers/media/platform/vivid/vivid-vbi-cap.c  |  10 +
 drivers/media/platform/vivid/vivid-vbi-out.c  |  10 +
 drivers/media/platform/vivid/vivid-vid-cap.c  |  10 +
 drivers/media/platform/vivid/vivid-vid-out.c  |  10 +
 drivers/media/usb/cpia2/cpia2_v4l.c           |   2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c       |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |   4 +-
 drivers/media/usb/msi2500/msi2500.c           |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |   2 +-
 drivers/media/usb/uvc/uvc_queue.c             |   5 +-
 drivers/media/usb/uvc/uvc_v4l2.c              |   3 +-
 drivers/media/usb/uvc/uvcvideo.h              |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  14 +-
 drivers/media/v4l2-core/v4l2-ctrls.c          | 541 +++++++++++++++++-
 drivers/media/v4l2-core/v4l2-dev.c            |  18 +-
 drivers/media/v4l2-core/v4l2-device.c         |   3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  44 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  67 ++-
 drivers/media/v4l2-core/v4l2-subdev.c         |   9 +-
 .../staging/media/davinci_vpfe/vpfe_video.c   |   7 +-
 drivers/staging/media/imx/imx-media-dev.c     |   2 +-
 drivers/staging/media/imx/imx-media-fim.c     |   2 +-
 drivers/staging/media/omap4iss/iss_video.c    |   3 +-
 drivers/usb/gadget/function/uvc_queue.c       |   2 +-
 include/media/media-device.h                  |  29 +
 include/media/media-request.h                 | 386 +++++++++++++
 include/media/v4l2-ctrls.h                    | 123 +++-
 include/media/v4l2-device.h                   |  11 +
 include/media/v4l2-mem2mem.h                  |   4 +
 include/media/videobuf2-core.h                |  62 +-
 include/media/videobuf2-v4l2.h                |  20 +-
 include/uapi/linux/media.h                    |   8 +
 include/uapi/linux/videodev2.h                |  14 +-
 75 files changed, 3369 insertions(+), 363 deletions(-)
 create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
 create mode 100644 Documentation/media/uapi/mediactl/request-api.rst
 create mode 100644 Documentation/media/uapi/mediactl/request-func-close.rst
 create mode 100644 Documentation/media/uapi/mediactl/request-func-ioctl.rst
 create mode 100644 Documentation/media/uapi/mediactl/request-func-poll.rst
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

-- 
2.18.0

Diff between v17 and v18:

-----------------------------------------------------------------
diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
index 11dcc14ca0bd..34434e2b3918 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
@@ -1,4 +1,4 @@
-.. SPDX-License-Identifier: GPL-2.0
+.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 
 .. _media_ioc_request_alloc:
 
@@ -15,7 +15,7 @@ MEDIA_IOC_REQUEST_ALLOC - Allocate a request
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, MEDIA_IOC_REQUEST_ALLOC, struct media_request_alloc *argp )
+.. c:function:: int ioctl( int fd, MEDIA_IOC_REQUEST_ALLOC, int *argp )
     :name: MEDIA_IOC_REQUEST_ALLOC
 
 
@@ -26,7 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <media-func-open>`.
 
 ``argp``
-    Pointer to struct :c:type:`media_request_alloc`.
+    Pointer to an integer.
 
 
 Description
@@ -35,7 +35,7 @@ Description
 If the media device supports :ref:`requests <media-request-api>`, then
 this ioctl can be used to allocate a request. If it is not supported, then
 ``errno`` is set to ``ENOTTY``. A request is accessed through a file descriptor
-that is returned in struct :c:type:`media_request_alloc`.
+that is returned in ``*argp``.
 
 If the request was successfully allocated, then the request file descriptor
 can be passed to the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
@@ -54,19 +54,6 @@ The request will remain allocated until all the file descriptors associated
 with it are closed by :ref:`close() <request-func-close>` and the driver no
 longer uses the request internally.
 
-.. c:type:: media_request_alloc
-
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
-.. flat-table:: struct media_request_alloc
-    :header-rows:  0
-    :stub-columns: 0
-    :widths:       1 1 2
-
-    *  -  __s32
-       -  ``fd``
-       -  The file descriptor of the request.
-
 Return Value
 ============
 
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
index 86a341cbc59e..d4f8119e0643 100644
--- a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
@@ -1,4 +1,4 @@
-.. SPDX-License-Identifier: GPL-2.0
+.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 
 .. _media_request_ioc_queue:
 
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
index 7ede0584a0d7..febe888494c8 100644
--- a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
@@ -1,4 +1,4 @@
-.. SPDX-License-Identifier: GPL-2.0
+.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 
 .. _media_request_ioc_reinit:
 
diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
index 5d1c4674d4bb..0b9da58b01e3 100644
--- a/Documentation/media/uapi/mediactl/request-api.rst
+++ b/Documentation/media/uapi/mediactl/request-api.rst
@@ -1,4 +1,4 @@
-.. -*- coding: utf-8; mode: rst -*-
+.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 
 .. _media-request-api:
 
@@ -55,8 +55,8 @@ Request Submission
 ------------------
 
 Once the parameters and buffers of the request are specified, it can be
-queued by calling :ref:`MEDIA_REQUEST_IOC_QUEUE` on the request FD. A request
-must contain at least one buffer, otherwise ``ENOENT`` is returned.
+queued by calling :ref:`MEDIA_REQUEST_IOC_QUEUE` on the request file descriptor.
+A request must contain at least one buffer, otherwise ``ENOENT`` is returned.
 This will make the buffers associated to the request available to their driver,
 which can then apply the associated controls as buffers are processed. A queued
 request cannot be modified anymore.
@@ -73,11 +73,12 @@ perfect atomicity may not be possible due to hardware limitations.
 
 .. caution::
 
-   It is not allowed to mix queuing requests with directly queuing buffers: whichever
-   method is used first locks this in place until :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
-   is called or the device is :ref:`closed <func-close>`. Attempts to
-   directly queue a buffer when earlier a buffer was queued via a request or
-   vice versa will result in an ``EPERM`` error.
+   It is not allowed to mix queuing requests with directly queuing buffers:
+   whichever method is used first locks this in place until
+   :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called or the device is
+   :ref:`closed <func-close>`. Attempts to directly queue a buffer when earlier
+   a buffer was queued via a request or vice versa will result in an ``EPERM``
+   error.
 
 Controls can still be set without a request and are applied immediately,
 regardless of whether a request is in use or not.
@@ -87,18 +88,18 @@ regardless of whether a request is in use or not.
    Setting the same control through a request and also directly can lead to
    undefined behavior!
 
-User-space can :ref:`poll() <request-func-poll>` a request FD in order to
-wait until the request completes. A request is considered complete once all its
-associated buffers are available for dequeuing and all the associated controls
-have been updated with the values at the time of completion. Note that user-space
-does not need to wait for the request to complete to dequeue its buffers: buffers
-that are available halfway through a request can be dequeued independently of the
-request's state.
+User-space can :ref:`poll() <request-func-poll>` a request file descriptor in
+order to wait until the request completes. A request is considered complete
+once all its associated buffers are available for dequeuing and all the
+associated controls have been updated with the values at the time of completion.
+Note that user-space does not need to wait for the request to complete to
+dequeue its buffers: buffers that are available halfway through a request can
+be dequeued independently of the request's state.
 
 A completed request contains the state of the request at the time of the
 request completion. User-space can query that state by calling
-:ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with the request FD.
-Calling :ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` for a
+:ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with the request file
+descriptor. Calling :ref:`ioctl VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` for a
 request that has been queued but not yet completed will return ``EBUSY``
 since the control values might be changed at any time by the driver while the
 request is in flight.
@@ -107,10 +108,11 @@ Recycling and Destruction
 -------------------------
 
 Finally, a completed request can either be discarded or be reused. Calling
-:ref:`close() <request-func-close>` on a request FD will make that FD unusable
-and the request will be freed once it is no longer in use by the kernel. That
-is, if the request is queued and then the FD is closed, then it won't be freed
-until the driver completed the request.
+:ref:`close() <request-func-close>` on a request file descriptor will make
+that file descriptor unusable and the request will be freed once it is no
+longer in use by the kernel. That is, if the request is queued and then the
+file descriptor is closed, then it won't be freed until the driver completed
+the request.
 
 The :ref:`MEDIA_REQUEST_IOC_REINIT` will clear a request's state and make it
 available again. No state is retained by this operation: the request is as
@@ -133,12 +135,10 @@ OUTPUT buffer to it:
 
 	struct v4l2_buffer buf;
 	struct v4l2_ext_controls ctrls;
-	struct media_request_alloc alloc = { 0 };
 	int req_fd;
 	...
-	if (ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &alloc))
+	if (ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &req_fd))
 		return errno;
-	req_fd = alloc.fd;
 	...
 	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
 	ctrls.request_fd = req_fd;
@@ -151,7 +151,7 @@ OUTPUT buffer to it:
 	if (ioctl(codec_fd, VIDIOC_QBUF, &buf))
 		return errno;
 
-Note that there is typically no need to use the Request API for CAPTURE buffers
+Note that it is not allowed to use the Request API for CAPTURE buffers
 since there are no per-frame settings to report there.
 
 Once the request is fully prepared, it can be queued to the driver:
@@ -164,7 +164,7 @@ Once the request is fully prepared, it can be queued to the driver:
 User-space can then either wait for the request to complete by calling poll() on
 its file descriptor, or start dequeuing CAPTURE buffers. Most likely, it will
 want to get CAPTURE buffers as soon as possible and this can be done using a
-regular DQBUF:
+regular :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`:
 
 .. code-block:: c
 
@@ -179,8 +179,8 @@ Note that this example assumes for simplicity that for every OUTPUT buffer
 there will be one CAPTURE buffer, but this does not have to be the case.
 
 We can then, after ensuring that the request is completed via polling the
-request FD, query control values at the time of its completion via a
-call to :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
+request file descriptor, query control values at the time of its completion via
+a call to :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
 This is particularly useful for volatile controls for which we want to
 query values as soon as the capture buffer is produced.
 
@@ -218,12 +218,10 @@ for a given CAPTURE buffer.
 
 	struct v4l2_buffer buf;
 	struct v4l2_ext_controls ctrls;
-	struct media_request_alloc alloc = { 0 };
 	int req_fd;
 	...
-	if (ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &alloc))
+	if (ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &req_fd))
 		return errno;
-	req_fd = alloc.fd;
 	...
 	ctrls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
 	ctrls.request_fd = req_fd;
diff --git a/Documentation/media/uapi/mediactl/request-func-close.rst b/Documentation/media/uapi/mediactl/request-func-close.rst
index 2dd9958f9b0e..b5c78683840b 100644
--- a/Documentation/media/uapi/mediactl/request-func-close.rst
+++ b/Documentation/media/uapi/mediactl/request-func-close.rst
@@ -1,5 +1,4 @@
-.. SPDX-License-Identifier: GPL-2.0
-.. -*- coding: utf-8; mode: rst -*-
+.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 
 .. _request-func-close:
 
diff --git a/Documentation/media/uapi/mediactl/request-func-ioctl.rst b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
index 33cadfd6a90b..ff7b072a6999 100644
--- a/Documentation/media/uapi/mediactl/request-func-ioctl.rst
+++ b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
@@ -1,5 +1,4 @@
-.. SPDX-License-Identifier: GPL-2.0
-.. -*- coding: utf-8; mode: rst -*-
+.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 
 .. _request-func-ioctl:
 
diff --git a/Documentation/media/uapi/mediactl/request-func-poll.rst b/Documentation/media/uapi/mediactl/request-func-poll.rst
index 206d8660d25a..70cc9d406a9f 100644
--- a/Documentation/media/uapi/mediactl/request-func-poll.rst
+++ b/Documentation/media/uapi/mediactl/request-func-poll.rst
@@ -1,5 +1,4 @@
-.. SPDX-License-Identifier: GPL-2.0
-.. -*- coding: utf-8; mode: rst -*-
+.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 
 .. _request-func-poll:
 
@@ -28,10 +27,10 @@ Arguments
 =========
 
 ``ufds``
-   List of FD events to be watched
+   List of file descriptor events to be watched
 
 ``nfds``
-   Number of FD events at the \*ufds array
+   Number of file descriptor events at the \*ufds array
 
 ``timeout``
    Timeout to wait for events
@@ -74,4 +73,5 @@ appropriately:
     The call was interrupted by a signal.
 
 ``EINVAL``
-    The ``nfds`` argument is greater than ``OPEN_MAX``.
+    The ``nfds`` value exceeds the ``RLIMIT_NOFILE`` value. Use
+    ``getrlimit()`` to obtain this value.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index c592074be273..771fd1161277 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -130,13 +130,15 @@ still cause this situation.
 .. flat-table:: struct v4l2_ext_control
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 3
+    :widths:       1 1 1 2
 
     * - __u32
       - ``id``
+      -
       - Identifies the control, set by the application.
     * - __u32
       - ``size``
+      -
       - The total size in bytes of the payload of this control. This is
 	normally 0, but for pointer controls this should be set to the
 	size of the memory containing the payload, or that will receive
@@ -153,43 +155,51 @@ still cause this situation.
 	   *length* of the string may well be much smaller.
     * - __u32
       - ``reserved2``\ [1]
+      -
       - Reserved for future extensions. Drivers and applications must set
 	the array to zero.
-    * - union {
+    * - union
       - (anonymous)
-    * - __s32
+    * -
+      - __s32
       - ``value``
       - New value or current value. Valid if this control is not of type
 	``V4L2_CTRL_TYPE_INTEGER64`` and ``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is
 	not set.
-    * - __s64
+    * -
+      - __s64
       - ``value64``
       - New value or current value. Valid if this control is of type
 	``V4L2_CTRL_TYPE_INTEGER64`` and ``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is
 	not set.
-    * - char *
+    * -
+      - char *
       - ``string``
       - A pointer to a string. Valid if this control is of type
 	``V4L2_CTRL_TYPE_STRING``.
-    * - __u8 *
+    * -
+      - __u8 *
       - ``p_u8``
       - A pointer to a matrix control of unsigned 8-bit values. Valid if
 	this control is of type ``V4L2_CTRL_TYPE_U8``.
-    * - __u16 *
+    * -
+      - __u16 *
       - ``p_u16``
       - A pointer to a matrix control of unsigned 16-bit values. Valid if
 	this control is of type ``V4L2_CTRL_TYPE_U16``.
-    * - __u32 *
+    * -
+      - __u32 *
       - ``p_u32``
       - A pointer to a matrix control of unsigned 32-bit values. Valid if
 	this control is of type ``V4L2_CTRL_TYPE_U32``.
-    * - void *
+    * -
+      - void *
       - ``ptr``
       - A pointer to a compound type which can be an N-dimensional array
 	and/or a compound type (the control's type is >=
 	``V4L2_CTRL_COMPOUND_TYPES``). Valid if
 	``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is set for this control.
-    * - }
+
 
 .. tabularcolumns:: |p{4.0cm}|p{2.2cm}|p{2.1cm}|p{8.2cm}|
 
@@ -200,11 +210,12 @@ still cause this situation.
 .. flat-table:: struct v4l2_ext_controls
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 3
+    :widths:       1 1 2 1
 
-    * - union {
+    * - union
       - (anonymous)
-    * - __u32
+    * -
+      - __u32
       - ``ctrl_class``
       - The control class to which all controls belong, see
 	:ref:`ctrl-class`. Drivers that use a kernel framework for
@@ -213,7 +224,8 @@ still cause this situation.
 	support this can be tested by setting ``ctrl_class`` to 0 and
 	calling :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with a ``count`` of 0. If that
 	succeeds, then the driver supports this feature.
-    * - __u32
+    * -
+      - __u32
       - ``which``
       - Which value of the control to get/set/try.
 	``V4L2_CTRL_WHICH_CUR_VAL`` will return the current value of the
@@ -238,7 +250,6 @@ still cause this situation.
 	by setting ctrl_class to ``V4L2_CTRL_WHICH_CUR_VAL`` and calling
 	VIDIOC_TRY_EXT_CTRLS with a count of 0. If that fails, then the
 	driver does not support ``V4L2_CTRL_WHICH_CUR_VAL``.
-    * - }
     * - __u32
       - ``count``
       - The number of controls in the controls array. May also be zero.
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 5d7946ec80d8..2dc3fc935f87 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1515,7 +1515,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		if (ret)
 			return ret;
 		ret = media_request_object_bind(req, &vb2_core_req_ops,
-						q, &vb->req_obj);
+						q, true, &vb->req_obj);
 		media_request_unlock_for_update(req);
 		if (ret)
 			return ret;
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 1b2351986230..a70df16d68f1 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -1108,6 +1108,12 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
 }
 EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
 
+/*
+ * Note that this function is called during validation time and
+ * thus the req_queue_mutex is held to ensure no request objects
+ * can be added or deleted while validating. So there is no need
+ * to protect the objects list.
+ */
 int vb2_request_validate(struct media_request *req)
 {
 	struct media_request_object *obj;
@@ -1139,16 +1145,17 @@ void vb2_request_queue(struct media_request *req)
 {
 	struct media_request_object *obj, *obj_safe;
 
-	/* Queue all non-buffer objects */
+	/*
+	 * Queue all objects. Note that buffer objects are at the end of the
+	 * objects list, after all other object types. Once buffer objects
+	 * are queued, the driver might delete them immediately (if the driver
+	 * processes the buffer at once), so we have to use
+	 * list_for_each_entry_safe() to handle the case where the object we
+	 * queue is deleted.
+	 */
 	list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
-		if (obj->ops->queue && !vb2_request_object_is_buffer(obj))
+		if (obj->ops->queue)
 			obj->ops->queue(obj);
-
-	/* Queue all buffer objects */
-	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
-		if (obj->ops->queue && vb2_request_object_is_buffer(obj))
-			obj->ops->queue(obj);
-	}
 }
 EXPORT_SYMBOL_GPL(vb2_request_queue);
 
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 28a891b53886..7049e77d2115 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -379,18 +379,18 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
 }
 
 static long media_device_request_alloc(struct media_device *mdev,
-				       struct media_request_alloc *alloc)
+				       int *alloc_fd)
 {
 	if (!mdev->ops || !mdev->ops->req_validate || !mdev->ops->req_queue)
 		return -ENOTTY;
 
-	return media_request_alloc(mdev, alloc);
+	return media_request_alloc(mdev, alloc_fd);
 }
 
 static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
 {
-	/* All media IOCTLs are _IOWR() */
-	if (copy_from_user(karg, uarg, _IOC_SIZE(cmd)))
+	if ((_IOC_DIR(cmd) & _IOC_WRITE) &&
+	    copy_from_user(karg, uarg, _IOC_SIZE(cmd)))
 		return -EFAULT;
 
 	return 0;
@@ -398,8 +398,8 @@ static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
 
 static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
 {
-	/* All media IOCTLs are _IOWR() */
-	if (copy_to_user(uarg, karg, _IOC_SIZE(cmd)))
+	if ((_IOC_DIR(cmd) & _IOC_READ) &&
+	    copy_to_user(uarg, karg, _IOC_SIZE(cmd)))
 		return -EFAULT;
 
 	return 0;
@@ -691,7 +691,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity);
 
-#ifdef CONFIG_DEBUG_FS
+#if IS_ENABLED(CONFIG_DEBUG_FS) && IS_ENABLED(CONFIG_VIDEO_ADV_DEBUG)
 /*
  * Log the state of media requests.
  * Very useful for debugging.
@@ -730,6 +730,7 @@ void media_device_init(struct media_device *mdev)
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
 
+	atomic_set(&mdev->request_id, 0);
 	atomic_set(&mdev->num_requests, 0);
 	atomic_set(&mdev->num_request_objects, 0);
 
@@ -784,7 +785,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 
 	dev_dbg(mdev->dev, "Media device registered\n");
 
-#ifdef CONFIG_DEBUG_FS
+#if IS_ENABLED(CONFIG_DEBUG_FS) && IS_ENABLED(CONFIG_VIDEO_ADV_DEBUG)
 	if (!media_top_dir)
 		return 0;
 
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 8ba97a9c4bf1..3292b8b3746f 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Media device request objects
  *
@@ -89,23 +89,23 @@ static int media_request_close(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static unsigned int media_request_poll(struct file *filp,
-				       struct poll_table_struct *wait)
+static __poll_t media_request_poll(struct file *filp,
+				   struct poll_table_struct *wait)
 {
 	struct media_request *req = filp->private_data;
 	unsigned long flags;
-	unsigned int ret = 0;
+	__poll_t ret = 0;
 
-	if (!(poll_requested_events(wait) & POLLPRI))
+	if (!(poll_requested_events(wait) & EPOLLPRI))
 		return 0;
 
 	spin_lock_irqsave(&req->lock, flags);
 	if (req->state == MEDIA_REQUEST_STATE_COMPLETE) {
-		ret = POLLPRI;
+		ret = EPOLLPRI;
 		goto unlock;
 	}
 	if (req->state != MEDIA_REQUEST_STATE_QUEUED) {
-		ret = POLLERR;
+		ret = EPOLLERR;
 		goto unlock;
 	}
 
@@ -144,6 +144,7 @@ static long media_request_ioctl_queue(struct media_request *req)
 		dev_dbg(mdev->dev,
 			"request: unable to queue %s, request in state %s\n",
 			req->debug_str, media_request_state_str(state));
+		media_request_put(req);
 		mutex_unlock(&mdev->req_queue_mutex);
 		return -EBUSY;
 	}
@@ -272,12 +273,10 @@ media_request_get_by_fd(struct media_device *mdev, int request_fd)
 }
 EXPORT_SYMBOL_GPL(media_request_get_by_fd);
 
-int media_request_alloc(struct media_device *mdev,
-			struct media_request_alloc *alloc)
+int media_request_alloc(struct media_device *mdev, int *alloc_fd)
 {
 	struct media_request *req;
 	struct file *filp;
-	char comm[TASK_COMM_LEN];
 	int fd;
 	int ret;
 
@@ -314,11 +313,10 @@ int media_request_alloc(struct media_device *mdev,
 	init_waitqueue_head(&req->poll_wait);
 	req->updating_count = 0;
 
-	alloc->fd = fd;
+	*alloc_fd = fd;
 
-	get_task_comm(comm, current);
-	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
-		 comm, fd);
+	snprintf(req->debug_str, sizeof(req->debug_str), "%u:%d",
+		 atomic_inc_return(&mdev->request_id), fd);
 	atomic_inc(&mdev->num_requests);
 	dev_dbg(mdev->dev, "request: allocated %s\n", req->debug_str);
 
@@ -391,7 +389,7 @@ EXPORT_SYMBOL_GPL(media_request_object_init);
 
 int media_request_object_bind(struct media_request *req,
 			      const struct media_request_object_ops *ops,
-			      void *priv,
+			      void *priv, bool is_buffer,
 			      struct media_request_object *obj)
 {
 	unsigned long flags;
@@ -410,7 +408,10 @@ int media_request_object_bind(struct media_request *req,
 	obj->priv = priv;
 	obj->mdev = req->mdev;
 
-	list_add_tail(&obj->list, &req->objects);
+	if (is_buffer)
+		list_add_tail(&obj->list, &req->objects);
+	else
+		list_add(&obj->list, &req->objects);
 	req->num_incomplete_objects++;
 	ret = 0;
 	atomic_inc(&obj->mdev->num_request_objects);
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 3b8df2c9d24a..5423f0dd0821 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -379,17 +379,15 @@ static void device_run(void *priv)
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
-	/* Apply request controls if needed */
-	if (src_buf->vb2_buf.req_obj.req)
-		v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
-					&ctx->hdl);
+	/* Apply request controls if any */
+	v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
+				&ctx->hdl);
 
 	device_process(ctx, src_buf, dst_buf);
 
-	/* Complete request controls if needed */
-	if (src_buf->vb2_buf.req_obj.req)
-		v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
-					&ctx->hdl);
+	/* Complete request controls if any */
+	v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
+				   &ctx->hdl);
 
 	/* Run delayed work, which simulates a hardware irq  */
 	schedule_delayed_work(&dev->work_run, msecs_to_jiffies(ctx->transtime));
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 2a30be824491..a197b60183f5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2064,7 +2064,7 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	u32 id = ctrl->id;
 	u32 class_ctrl = V4L2_CTRL_ID2WHICH(id) | 1;
 	int bucket = id % hdl->nr_of_buckets;	/* which bucket to use */
-	unsigned int sz_extra = 0;
+	unsigned int size_extra_req = 0;
 
 	if (ctrl_ref)
 		*ctrl_ref = NULL;
@@ -2082,13 +2082,13 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 		return hdl->error;
 
 	if (allocate_req)
-		sz_extra = ctrl->elems * ctrl->elem_size;
-	new_ref = kzalloc(sizeof(*new_ref) + sz_extra, GFP_KERNEL);
+		size_extra_req = ctrl->elems * ctrl->elem_size;
+	new_ref = kzalloc(sizeof(*new_ref) + size_extra_req, GFP_KERNEL);
 	if (!new_ref)
 		return handler_set_err(hdl, -ENOMEM);
 	new_ref->ctrl = ctrl;
 	new_ref->from_other_dev = from_other_dev;
-	if (sz_extra)
+	if (size_extra_req)
 		new_ref->p_req.p = &new_ref[1];
 
 	if (ctrl->handler == hdl) {
@@ -3011,7 +3011,7 @@ static int v4l2_ctrl_request_bind(struct media_request *req,
 
 	if (!ret) {
 		ret = media_request_object_bind(req, &req_ops,
-						from, &hdl->req_obj);
+						from, false, &hdl->req_obj);
 		if (!ret)
 			list_add_tail(&hdl->requests, &from->requests);
 	}
@@ -3165,8 +3165,8 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
 }
 
 /* Get extended controls. Allocates the helpers array if needed. */
-int __v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
-		       struct v4l2_ext_controls *cs)
+static int v4l2_g_ext_ctrls_common(struct v4l2_ctrl_handler *hdl,
+				   struct v4l2_ext_controls *cs)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -3317,7 +3317,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
 				   req_obj);
 	}
 
-	ret = __v4l2_g_ext_ctrls(hdl, cs);
+	ret = v4l2_g_ext_ctrls_common(hdl, cs);
 
 	if (obj)
 		media_request_object_put(obj);
@@ -3511,9 +3511,9 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
 }
 
 /* Try or try-and-set controls */
-static int __try_set_ext_ctrls(struct v4l2_fh *fh,
-			       struct v4l2_ctrl_handler *hdl,
-			       struct v4l2_ext_controls *cs, bool set)
+static int try_set_ext_ctrls_common(struct v4l2_fh *fh,
+				    struct v4l2_ctrl_handler *hdl,
+				    struct v4l2_ext_controls *cs, bool set)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -3659,7 +3659,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
 				   req_obj);
 	}
 
-	ret = __try_set_ext_ctrls(fh, hdl, cs, set);
+	ret = try_set_ext_ctrls_common(fh, hdl, cs, set);
 
 	if (obj) {
 		media_request_unlock_for_update(obj->req);
@@ -3788,6 +3788,11 @@ void v4l2_ctrl_request_complete(struct media_request *req,
 	if (!req || !main_hdl)
 		return;
 
+	/*
+	 * Note that it is valid if nothing was found. It means
+	 * that this request doesn't have any controls and so just
+	 * wants to leave the controls unchanged.
+	 */
 	obj = media_request_object_find(req, &req_ops, main_hdl);
 	if (!obj)
 		return;
@@ -3842,6 +3847,11 @@ void v4l2_ctrl_request_setup(struct media_request *req,
 	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
 		return;
 
+	/*
+	 * Note that it is valid if nothing was found. It means
+	 * that this request doesn't have any controls and so just
+	 * wants to leave the controls unchanged.
+	 */
 	obj = media_request_object_find(req, &req_ops, main_hdl);
 	if (!obj)
 		return;
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 53018e4a4c78..feb749aaaa42 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -450,14 +450,15 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	 * operation, and that should not be mixed with queueing a new
 	 * request at the same time.
 	 */
-	if (v4l2_device_supports_requests(vdev->v4l2_dev))
-		mutex_lock(&vdev->v4l2_dev->mdev->req_queue_mutex);
-
-	if (vdev->fops->release)
-		ret = vdev->fops->release(filp);
-
-	if (v4l2_device_supports_requests(vdev->v4l2_dev))
-		mutex_unlock(&vdev->v4l2_dev->mdev->req_queue_mutex);
+	if (vdev->fops->release) {
+		if (v4l2_device_supports_requests(vdev->v4l2_dev)) {
+			mutex_lock(&vdev->v4l2_dev->mdev->req_queue_mutex);
+			ret = vdev->fops->release(filp);
+			mutex_unlock(&vdev->v4l2_dev->mdev->req_queue_mutex);
+		} else {
+			ret = vdev->fops->release(filp);
+		}
+	}
 
 	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
 		dprintk("%s: release\n",
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 030c6a8ac0a2..d7806db222d8 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -958,27 +958,31 @@ void vb2_m2m_request_queue(struct media_request *req)
 	struct media_request_object *obj, *obj_safe;
 	struct v4l2_m2m_ctx *m2m_ctx = NULL;
 
-	/* Queue all non-buffer objects */
-	list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
-		if (obj->ops->queue && !vb2_request_object_is_buffer(obj))
-			obj->ops->queue(obj);
-
-	/* Queue all buffer objects */
+	/*
+	 * Queue all objects. Note that buffer objects are at the end of the
+	 * objects list, after all other object types. Once buffer objects
+	 * are queued, the driver might delete them immediately (if the driver
+	 * processes the buffer at once), so we have to use
+	 * list_for_each_entry_safe() to handle the case where the object we
+	 * queue is deleted.
+	 */
 	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
 		struct v4l2_m2m_ctx *m2m_ctx_obj;
 		struct vb2_buffer *vb;
 
-		if (!obj->ops->queue || !vb2_request_object_is_buffer(obj))
+		if (!obj->ops->queue)
 			continue;
 
-		/* Sanity checks */
-		vb = container_of(obj, struct vb2_buffer, req_obj);
-		WARN_ON(!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type));
-		m2m_ctx_obj = container_of(vb->vb2_queue,
-					   struct v4l2_m2m_ctx,
-					   out_q_ctx.q);
-		WARN_ON(m2m_ctx && m2m_ctx_obj != m2m_ctx);
-		m2m_ctx = m2m_ctx_obj;
+		if (vb2_request_object_is_buffer(obj)) {
+			/* Sanity checks */
+			vb = container_of(obj, struct vb2_buffer, req_obj);
+			WARN_ON(!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type));
+			m2m_ctx_obj = container_of(vb->vb2_queue,
+						   struct v4l2_m2m_ctx,
+						   out_q_ctx.q);
+			WARN_ON(m2m_ctx && m2m_ctx_obj != m2m_ctx);
+			m2m_ctx = m2m_ctx_obj;
+		}
 
 		/*
 		 * The buffer we queue here can in theory be immediately
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 2de0606938d4..00291e4086d9 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -64,6 +64,12 @@ struct media_entity_notify {
  *	       as such internally in the driver and any related buffers
  *	       must eventually return to vb2 with state VB2_BUF_STATE_ERROR.
  *	       The req_queue_mutex lock is held when this op is called.
+ *	       It is important that vb2 buffer objects are queued last after
+ *	       all other object types are queued: queueing a buffer kickstarts
+ *	       the request processing, so all other objects related to the
+ *	       request (and thus the buffer) must be available to the driver.
+ *	       And once a buffer is queued, then the driver can complete
+ *	       or delete objects from the request before req_queue exits.
  */
 struct media_device_ops {
 	int (*link_notify)(struct media_link *link, u32 flags,
@@ -108,6 +114,7 @@ struct media_device_ops {
  * @ops:	Operation handler callbacks
  * @req_queue_mutex: Serialise the MEDIA_REQUEST_IOC_QUEUE ioctl w.r.t.
  *		     other operations that stop or start streaming.
+ * @request_id: Used to generate unique request IDs
  * @num_requests: number of associated requests
  * @num_request_objects: number of associated request objects
  * @media_dir:	DebugFS media directory
@@ -184,6 +191,7 @@ struct media_device {
 	const struct media_device_ops *ops;
 
 	struct mutex req_queue_mutex;
+	atomic_t request_id;
 	atomic_t num_requests;
 	atomic_t num_request_objects;
 
diff --git a/include/media/media-request.h b/include/media/media-request.h
index 76727d4a89c3..c913b998c88c 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Media device request objects
  *
@@ -165,12 +165,12 @@ media_request_get_by_fd(struct media_device *mdev, int request_fd);
  * media_request_alloc - Allocate the media request
  *
  * @mdev: Media device this request belongs to
- * @alloc: Store the request's file descriptor in this struct
+ * @alloc_fd: Store the request's file descriptor in this int
  *
- * Allocated the media request and put the fd in @alloc->fd.
+ * Allocated the media request and put the fd in @alloc_fd.
  */
 int media_request_alloc(struct media_device *mdev,
-			struct media_request_alloc *alloc);
+			int *alloc_fd);
 
 #else
 
@@ -292,6 +292,7 @@ void media_request_object_init(struct media_request_object *obj);
  * @req: The media request
  * @ops: The object ops for this object
  * @priv: A driver-specific priv pointer associated with this object
+ * @is_buffer: Set to true if the object a buffer object.
  * @obj: The object
  *
  * Bind this object to the request and set the ops and priv values of
@@ -301,10 +302,16 @@ void media_request_object_init(struct media_request_object *obj);
  * point in time, otherwise the request will never complete. When the
  * request is released all completed objects will be unbound by the
  * request core code.
+ *
+ * Buffer objects will be added to the end of the request's object
+ * list, non-buffer objects will be added to the front of the list.
+ * This ensures that all buffer objects are at the end of the list
+ * and that all non-buffer objects that they depend on are processed
+ * first.
  */
 int media_request_object_bind(struct media_request *req,
 			      const struct media_request_object_ops *ops,
-			      void *priv,
+			      void *priv, bool is_buffer,
 			      struct media_request_object *obj);
 
 /**
@@ -362,7 +369,7 @@ static inline void media_request_object_init(struct media_request_object *obj)
 
 static inline int media_request_object_bind(struct media_request *req,
 			       const struct media_request_object_ops *ops,
-			       void *priv,
+			       void *priv, bool is_buffer,
 			       struct media_request_object *obj)
 {
 	return 0;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 29e9d94e230c..53ca4df0c353 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1125,6 +1125,11 @@ void v4l2_ctrl_request_complete(struct media_request *req,
  *
  * If the request is not in state VALIDATING or QUEUED, then this function
  * will always return NULL.
+ *
+ * Note that in state VALIDATING the req_queue_mutex is held, so
+ * no objects can be added or deleted from the request.
+ *
+ * In state QUEUED it is the driver that will have to ensure this.
  */
 struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_request *req,
 					struct v4l2_ctrl_handler *parent);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index daffdf259fce..881f53b38b26 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -254,8 +254,12 @@ struct vb2_buffer {
 	/* private: internal use only
 	 *
 	 * state:		current buffer state; do not change
-	 * synced:		this buffer has been synced
-	 * prepared:		this buffer has been prepared
+	 * synced:		this buffer has been synced for DMA, i.e. the
+	 *			'prepare' memop was called. It is cleared again
+	 *			after the 'finish' memop is called.
+	 * prepared:		this buffer has been prepared, i.e. the
+	 *			buf_prepare op was called. It is cleared again
+	 *			after the 'buf_finish' op is called.
 	 * queued_entry:	entry on the queued buffers list, which holds
 	 *			all buffers queued from userspace
 	 * done_entry:		entry on the list that stores all buffers ready
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index cf77f00a0f2d..e5d0c5c611b5 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -364,16 +364,12 @@ struct media_v2_topology {
 
 /* ioctls */
 
-struct __attribute__ ((packed)) media_request_alloc {
-	__s32 fd;
-};
-
 #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
-#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_alloc)
+#define MEDIA_IOC_REQUEST_ALLOC	_IOR ('|', 0x05, int)
 
 /*
  * These ioctls are called on the request file descriptor as returned
