Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:58763 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750922AbeEUIzO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v14 00/36] Request API
Date: Mon, 21 May 2018 11:54:25 +0300
Message-Id: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

Here are my changes over v13 set Hans posted earlier. The changes since
v13 include:

- Request state is made enum again. This change was motivated by
  complicated locking scheme in which it was not obvious which locks would
  need to be acquired and when. In some cases the atomic operation may be
  replaced by a regular read operation.

- Add a new "updating" state to tell the request is being updated. The request
  state is changes to this state when its controls are being set, or a
  video buffer is being associated with it. There's update count, so
  multiple updates may take place simultaneously. This also means that the
  drivers may not use this mechanism to serialise access to their own data
  structures.

- Document v4l2_ctrl_request_setup and v4l2_ctrl_request_queue.

- Add media-request.h to Media documentation build.

Hans: Some patches are intended to be merged to the patches they precede.
I didn't do that since I thought they'd be more easily reviewed
separately. I've also changed the patch "v4l2-dev: lock req_queue_mutex" a
little, as described above.

In order to protect applying the requests (controls in particular),
setting the control value from user space need to be prevented if there
are requests pending for that video device. This is missing from the set.

I've also provided further comments on v13 on the list and I believe
others have given comments, too, so this isn't meant to be a set that
could be merged yet.

Hans's v13 and this set, both based on a recent media tree master, may be
found here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=reqv13>
<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=reqv14>


Alexandre Courbot (2):
  videodev2.h: add request_fd field to v4l2_ext_controls
  Documentation: v4l: document request API

Hans Verkuil (25):
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

Sakari Ailus (9):
  media-request: Make request state an enum
  media-request: Add support for updating request objects optimally
  media-request: Add a sanity check for the media request state
  media: doc: Add media-request.h header to documentation build
  v4l2-ctrls: Add documentation for control request support functions
  v4l2-ctrls: Lock the request for updating during S_EXT_CTRLS
  videobuf2-v4l2: Lock the media request for update for QBUF
  videobuf2-core: Make request state an enum
  v4l: m2m: Simplify exiting the function in v4l2_m2m_try_schedule

 Documentation/media/kapi/mc-core.rst               |   2 +
 Documentation/media/uapi/mediactl/media-funcs.rst  |   3 +
 .../uapi/mediactl/media-ioc-request-alloc.rst      |  71 +++
 .../uapi/mediactl/media-request-ioc-queue.rst      |  46 ++
 .../uapi/mediactl/media-request-ioc-reinit.rst     |  51 +++
 Documentation/media/uapi/v4l/buffer.rst            |  18 +-
 Documentation/media/uapi/v4l/common.rst            |   1 +
 Documentation/media/uapi/v4l/request-api.rst       | 211 +++++++++
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  25 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |   7 +
 Documentation/media/videodev2.h.rst.exceptions     |   1 +
 drivers/media/Makefile                             |   3 +-
 drivers/media/common/videobuf2/videobuf2-core.c    | 192 ++++++--
 drivers/media/common/videobuf2/videobuf2-v4l2.c    | 460 ++++++++++++-------
 drivers/media/dvb-core/dvb_vb2.c                   |   5 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   5 +-
 drivers/media/media-device.c                       |  55 +++
 drivers/media/media-devnode.c                      |  17 +
 drivers/media/media-request.c                      | 473 +++++++++++++++++++
 drivers/media/pci/bt8xx/bttv-driver.c              |   2 +-
 drivers/media/pci/cx23885/cx23885-417.c            |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   2 +-
 drivers/media/pci/cx88/cx88-video.c                |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   4 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   2 +-
 drivers/media/platform/rcar_drif.c                 |   2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   4 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   7 +-
 drivers/media/platform/vim2m.c                     |  91 +++-
 drivers/media/platform/vivid/vivid-core.c          |  69 +++
 drivers/media/platform/vivid/vivid-core.h          |   8 +
 drivers/media/platform/vivid/vivid-ctrls.c         |  46 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |  12 +
 drivers/media/platform/vivid/vivid-kthread-out.c   |  12 +
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  16 +
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  10 +
 drivers/media/platform/vivid/vivid-vbi-out.c       |  10 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |  10 +
 drivers/media/platform/vivid/vivid-vid-out.c       |  10 +
 drivers/media/usb/cpia2/cpia2_v4l.c                |   2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/msi2500/msi2500.c                |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   5 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   3 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  14 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               | 499 +++++++++++++++++++--
 drivers/media/v4l2-core/v4l2-dev.c                 |  36 +-
 drivers/media/v4l2-core/v4l2-device.c              |   3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  22 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  62 ++-
 drivers/media/v4l2-core/v4l2-subdev.c              |   9 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   3 +-
 drivers/staging/media/imx/imx-media-dev.c          |   2 +-
 drivers/staging/media/imx/imx-media-fim.c          |   2 +-
 drivers/staging/media/omap4iss/iss_video.c         |   3 +-
 drivers/usb/gadget/function/uvc_queue.c            |   2 +-
 include/media/media-device.h                       |  27 ++
 include/media/media-devnode.h                      |   4 +
 include/media/media-request.h                      | 349 ++++++++++++++
 include/media/v4l2-ctrls.h                         |  71 ++-
 include/media/v4l2-mem2mem.h                       |   4 +
 include/media/videobuf2-core.h                     |  39 +-
 include/media/videobuf2-v4l2.h                     |  20 +-
 include/uapi/linux/media.h                         |  12 +
 include/uapi/linux/videodev2.h                     |  14 +-
 73 files changed, 2869 insertions(+), 332 deletions(-)
 create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
 create mode 100644 Documentation/media/uapi/v4l/request-api.rst
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

-- 
2.11.0
