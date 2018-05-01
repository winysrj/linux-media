Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:60087 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751677AbeEAJAx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 May 2018 05:00:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv12 PATCH 00/29] Request API
Date: Tue,  1 May 2018 11:00:22 +0200
Message-Id: <20180501090051.9321-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

This is version 12 of the Request API series.

The main changes compared to v11 are:

- Improve locking (more about that below)
- Split req_queue into req_validate and req_queue
- Add vb2_m2m_request_queue() helper
- Merge v11 patches 3-5 into one (splitting it up was too confusing)
- Incorporated all (?) v11 comments, except for debug_str: it wasn't
  quite clear to me what I should do there.
- Renamed WHICH_REQUEST to WHICH_REQUEST_VAL for consistency.
- Attempting to queue or reinit a request that is in use will now
  return -EBUSY instead of -EINVAL.
- Added a final RFC patch to ease debugging: it exposes a debugfs
  file that shows how many requests and request objects are in use.
  I don't think this will be merged as I am not really happy about
  it. It's good enough for now, though.

This series has been tested with vim2m, vivid and the cedrus driver.

Regarding locking:

There are two request locks used: req_queue_mutex (part of media_device)
ensures high-level serialization of queueing/reiniting and canceling
requests. It serializes STREAMON/OFF, TRY/S_EXT_CTRLS, close() and
MEDIA_REQUEST_IOC_QUEUE. This is the top-level lock and should be taken
before any others.

The lock spin_lock in struct media_request protects that structure and
should be held for a short time only.

Note that VIDIOC_QBUF/VIDIOC_PREPARE_BUF do not take this mutex: when
a buffer is queued/prepared for a request they will add it to the
request by calling media_request_object_bind(), and that returns an
error if the request is in the wrong state. It is serialized via the
spin_lock which in this specific case is sufficient.

When MEDIA_REQUEST_IOC_QUEUE is called it will validate and queue both
control handlers and vb2 buffers. For control handlers the control handler
lock will be taken, for vb2 buffers the vb2_queue lock will be taken.
This requires that the lock field in vb2_queue is set, which is checked in
videobuf2-v4l2.c.

TODO/Remarks:

1) Still some missing documentation. It's better than v11, but still
   not complete.

2) No VIDIOC_REQUEST_ALLOC 'shortcut' ioctl. I don't think we should
   add this in the initial version due to the fact that it is somewhat
   controversial. It can always be added later.

3) vim2m: the media topology is a bit bogus, this needs to be fixed
   (i.e. a proper HW entity should be added). But for now it is
   good enough for testing. In addition as suggested by Tomasz the
   timer can be replaced by delayed_work.

4) Review copyright/authorship lines. I'm not sure if everything is
   correct. Alexandre, Sakari, if you see something that is not
   right in this respect, just let me know!

5) For the next patch series I plan to drop the 'RFC' tag, except for
   the last debugfs patch.

Everything seemed to slip nicely into place while working on this,
so I hope this is finally an implementation that we can proceed to
upstream and build upon for complex camera pipelines in the future.

This patch series is also available here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv12

Regards,

	Hans


Alexandre Courbot (2):
  videodev2.h: add request_fd field to v4l2_ext_controls
  Documentation: v4l: document request API

Hans Verkuil (27):
  v4l2-device.h: always expose mdev
  uapi/linux/media.h: add request API
  media-request: implement media requests
  v4l2-dev: lock req_queue_mutex
  media-request: add media_request_find
  media-request: add media_request_object_find
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
  videobuf2-core: add vb2_core_request_has_buffers
  videobuf2-v4l2: add vb2_request_queue/validate helpers
  videobuf2-v4l2: export request_fd
  v4l2-mem2mem: add vb2_m2m_request_queue
  media: vim2m: add media device
  vim2m: use workqueue
  vim2m: support requests
  vivid: add mc
  vivid: add request support
  RFC: media-requests: add debugfs node

 Documentation/media/uapi/v4l/buffer.rst       |  19 +-
 Documentation/media/uapi/v4l/common.rst       |   1 +
 Documentation/media/uapi/v4l/request-api.rst  | 218 ++++++++
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  25 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |   8 +
 .../media/videodev2.h.rst.exceptions          |   1 +
 drivers/media/Makefile                        |   3 +-
 .../media/common/videobuf2/videobuf2-core.c   | 204 +++++--
 .../media/common/videobuf2/videobuf2-v4l2.c   | 456 ++++++++++------
 drivers/media/dvb-core/dvb_vb2.c              |   5 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c     |   5 +-
 drivers/media/media-device.c                  |  54 ++
 drivers/media/media-devnode.c                 |  17 +
 drivers/media/media-request.c                 | 492 +++++++++++++++++
 drivers/media/pci/bt8xx/bttv-driver.c         |   2 +-
 drivers/media/pci/cx23885/cx23885-417.c       |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c       |   2 +-
 drivers/media/pci/cx88/cx88-video.c           |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c   |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c     |   2 +-
 .../media/platform/exynos4-is/fimc-capture.c  |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c    |   4 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c   |   3 +-
 drivers/media/platform/rcar_drif.c            |   2 +-
 .../media/platform/s3c-camif/camif-capture.c  |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |   4 +-
 .../media/platform/soc_camera/soc_camera.c    |   7 +-
 drivers/media/platform/vim2m.c                |  83 ++-
 drivers/media/platform/vivid/vivid-core.c     |  69 +++
 drivers/media/platform/vivid/vivid-core.h     |   8 +
 drivers/media/platform/vivid/vivid-ctrls.c    |  46 +-
 .../media/platform/vivid/vivid-kthread-cap.c  |  12 +
 .../media/platform/vivid/vivid-kthread-out.c  |  12 +
 drivers/media/platform/vivid/vivid-sdr-cap.c  |   8 +
 drivers/media/platform/vivid/vivid-vbi-cap.c  |   2 +
 drivers/media/platform/vivid/vivid-vbi-out.c  |   2 +
 drivers/media/platform/vivid/vivid-vid-cap.c  |   2 +
 drivers/media/platform/vivid/vivid-vid-out.c  |   2 +
 drivers/media/usb/cpia2/cpia2_v4l.c           |   2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c       |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |   4 +-
 drivers/media/usb/msi2500/msi2500.c           |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |   2 +-
 drivers/media/usb/uvc/uvc_queue.c             |   5 +-
 drivers/media/usb/uvc/uvc_v4l2.c              |   3 +-
 drivers/media/usb/uvc/uvcvideo.h              |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  14 +-
 drivers/media/v4l2-core/v4l2-ctrls.c          | 496 +++++++++++++++++-
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
 include/media/media-device.h                  |  28 +
 include/media/media-devnode.h                 |   4 +
 include/media/media-request.h                 | 228 ++++++++
 include/media/v4l2-ctrls.h                    |  45 +-
 include/media/v4l2-device.h                   |   4 +-
 include/media/v4l2-mem2mem.h                  |   4 +
 include/media/videobuf2-core.h                |  38 +-
 include/media/videobuf2-v4l2.h                |  20 +-
 include/uapi/linux/media.h                    |  12 +
 include/uapi/linux/videodev2.h                |  14 +-
 69 files changed, 2519 insertions(+), 330 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/request-api.rst
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

-- 
2.17.0
