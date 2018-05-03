Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:51497 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751174AbeECOxW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 10:53:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv13 00/28] Request API
Date: Thu,  3 May 2018 16:52:50 +0200
Message-Id: <20180503145318.128315-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

This is version 13 of the Request API series.

The main changes compared to v12 are:

- Replaced media_request_cancel with a new vb2 op buf_request_complete
- No longer allow adding a prepared buffer to a request (see TODO below)
- Updated and reviewed the documentation
- Incorporated comments from Sakari
- Added missing kerneldoc documentation

This series has been tested with vim2m and vivid.

Regarding locking:

There are two request locks used: req_queue_mutex (part of media_device)
ensures high-level serialization of queueing/reiniting and canceling
requests. It serializes STREAMON/OFF, TRY/S_EXT_CTRLS, close() and
MEDIA_REQUEST_IOC_QUEUE. This is the top-level lock and should be taken
before any others.

The lock spin_lock in struct media_request protects that structure and
should be held for a short time only.

Note that VIDIOC_QBUF does not take this mutex: when
a buffer is queued for a request it will add it to the
request by calling media_request_object_bind(), and that returns an
error if the request is in the wrong state. It is serialized via the
spin_lock which in this specific case is sufficient.

When MEDIA_REQUEST_IOC_QUEUE is called it will validate and queue both
control handlers and vb2 buffers. For control handlers the control handler
lock will be taken, for vb2 buffers the vb2_queue lock will be taken.
This requires that the lock field in vb2_queue is set, which is checked in
videobuf2-v4l2.c.

TODO/Remarks:

1) vim2m: the media topology is a bit bogus, this needs to be fixed
   (i.e. a proper HW entity should be added). But for now it is
   good enough for testing. In addition as suggested by Tomasz the
   timer can be replaced by delayed_work.

2) It should be possible to queue an already prepared buffer to a
   request (VIDIOC_PREPARE_BUF, then VIDIOC_QBUF to a request).
   I ran out of time for this as it got a bit hairy in vb2. For
   now this is simply not allowed, which is fine for stateless
   codecs. I plan on adding support for this when I have a bit more
   time to see what the correct approach is. It's not impossible
   that this has to be postponed until the fence code is in as well.

Everything seemed to slip nicely into place while working on this,
so I hope this is finally an implementation that we can proceed to
upstream and build upon for complex camera pipelines in the future.

This patch series is also available here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv13

Regards,

	Hans


Alexandre Courbot (2):
  videodev2.h: add request_fd field to v4l2_ext_controls
  Documentation: v4l: document request API

Hans Verkuil (26):
  v4l2-device.h: always expose mdev
  uapi/linux/media.h: add request API
  media-request: implement media requests
  media-request: add media_request_get_by_fd
  media-request: add media_request_object_find
  v4l2-dev: lock req_queue_mutex
  v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
  v4l2-ctrls: prepare internal structs for request API
  v4l2-ctrls: alloc memory for p_req
  v4l2-ctrls: use ref in helper instead of ctrl
  v4l2-ctrls: add core request support
  v4l2-ctrls: support g/s_ext_ctrls for requests
  videodev2.h: Add request_fd field to v4l2_buffer
  vb2: store userspace data in vb2_v4l2_buffer
  videobuf2-core: embed media_request_object
  videobuf2-core: integrate with media requests
  videobuf2-v4l2: integrate with media requests
  videobuf2-core: add request helper functions
  videobuf2-v4l2: add vb2_request_queue/validate helpers
  v4l2-mem2mem: add vb2_m2m_request_queue
  media: vim2m: add media device
  vim2m: use workqueue
  vim2m: support requests
  vivid: add mc
  vivid: add request support
  RFC: media-requests: add debugfs node

 .../media/uapi/mediactl/media-funcs.rst       |   3 +
 .../uapi/mediactl/media-ioc-request-alloc.rst |  71 +++
 .../uapi/mediactl/media-request-ioc-queue.rst |  46 ++
 .../mediactl/media-request-ioc-reinit.rst     |  51 ++
 Documentation/media/uapi/v4l/buffer.rst       |  18 +-
 Documentation/media/uapi/v4l/common.rst       |   1 +
 Documentation/media/uapi/v4l/request-api.rst  | 211 ++++++++
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  25 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |   7 +
 .../media/videodev2.h.rst.exceptions          |   1 +
 drivers/media/Makefile                        |   3 +-
 .../media/common/videobuf2/videobuf2-core.c   | 184 +++++--
 .../media/common/videobuf2/videobuf2-v4l2.c   | 457 ++++++++++------
 drivers/media/dvb-core/dvb_vb2.c              |   5 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c     |   5 +-
 drivers/media/media-device.c                  |  55 ++
 drivers/media/media-devnode.c                 |  17 +
 drivers/media/media-request.c                 | 469 +++++++++++++++++
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
 drivers/media/platform/vim2m.c                |  91 +++-
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
 drivers/media/v4l2-core/v4l2-ctrls.c          | 486 +++++++++++++++++-
 drivers/media/v4l2-core/v4l2-dev.c            |  37 +-
 drivers/media/v4l2-core/v4l2-device.c         |   3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  22 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  40 +-
 drivers/media/v4l2-core/v4l2-subdev.c         |   9 +-
 .../staging/media/davinci_vpfe/vpfe_video.c   |   3 +-
 drivers/staging/media/imx/imx-media-dev.c     |   2 +-
 drivers/staging/media/imx/imx-media-fim.c     |   2 +-
 drivers/staging/media/omap4iss/iss_video.c    |   3 +-
 drivers/usb/gadget/function/uvc_queue.c       |   2 +-
 include/media/media-device.h                  |  27 +
 include/media/media-devnode.h                 |   4 +
 include/media/media-request.h                 | 293 +++++++++++
 include/media/v4l2-ctrls.h                    |  45 +-
 include/media/v4l2-device.h                   |   4 +-
 include/media/v4l2-mem2mem.h                  |   4 +
 include/media/videobuf2-core.h                |  39 +-
 include/media/videobuf2-v4l2.h                |  20 +-
 include/uapi/linux/media.h                    |  12 +
 include/uapi/linux/videodev2.h                |  14 +-
 73 files changed, 2747 insertions(+), 325 deletions(-)
 create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
 create mode 100644 Documentation/media/uapi/v4l/request-api.rst
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

-- 
2.17.0
