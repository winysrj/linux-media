Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43818 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbeJ3WrK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 18:47:10 -0400
Date: Tue, 30 Oct 2018 10:53:28 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.20-rc1] new experimental media request API
Message-ID: <20181030105328.0667ec68@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-2

For a new media API: the request API

This API is needed to support device drivers that can dynamically
change their parameters for each new frame. The latest versions of 
Google camera and codec HAL depends on such feature.

At this stage, it supports only stateless codecs.

It has been discussed for a long time (at least over the last 3-4
years), and we finally reached to something that seem to work.

This series contain both the API and core changes required to support it
and a new m2m decoder driver (cedrus).

As the current API is still experimental, the only real driver using it
(cedrus) was added at staging[1]. We intend to keep it there for a while,
in order to test the API. Only when we're sure that this API works
for other cases (like encoders), we'll move this driver out of staging
and set the API into a stone.

[1] We added support for the vivid virtual driver (used only for testing)
to it too, as it makes easier to test the API for the ones that don't have
the cedrus hardware.


Thanks!
Mauro


The following changes since commit d842a7cf938b6e0f8a1aa9f1aec0476c9a599310:

  media: adv7842: enable reduced fps detection (2018-08-31 10:03:51 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-2

for you to fetch changes up to e4183d3256e3cd668e899d06af66da5aac3a51af:

  media: dt-bindings: Document the Rockchip VPU bindings (2018-10-05 07:00:43 -0400)

----------------------------------------------------------------
media updates for v4.20-rc1

----------------------------------------------------------------
Alexandre Courbot (2):
      media: Documentation: v4l: document request API
      media: videodev2.h: add request_fd field to v4l2_ext_controls

Ezequiel Garcia (1):
      media: dt-bindings: Document the Rockchip VPU bindings

Hans Verkuil (44):
      media: uapi/linux/media.h: add request API
      media: media-request: implement media requests
      media: media-request: add media_request_get_by_fd
      media: media-request: add media_request_object_find
      media: v4l2-device.h: add v4l2_device_supports_requests() helper
      media: v4l2-dev: lock req_queue_mutex
      media: v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
      media: v4l2-ctrls: prepare internal structs for request API
      media: v4l2-ctrls: alloc memory for p_req
      media: v4l2-ctrls: use ref in helper instead of ctrl
      media: v4l2-ctrls: add core request support
      media: v4l2-ctrls: support g/s_ext_ctrls for requests
      media: v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/ctrl_find functions
      media: videobuf2-v4l2: move __fill_v4l2_buffer() function
      media: videobuf2-v4l2: replace if by switch in __fill_vb2_buffer()
      media: vb2: store userspace data in vb2_v4l2_buffer
      media: davinci_vpfe: remove bogus vb2->state check
      media: vb2: drop VB2_BUF_STATE_PREPARED, use bool prepared/synced instead
      media: videodev2.h: Add request_fd field to v4l2_buffer
      media: vb2: add init_buffer buffer op
      media: videobuf2-core: embed media_request_object
      media: videobuf2-core: integrate with media requests
      media: videobuf2-v4l2: integrate with media requests
      media: videobuf2-core: add request helper functions
      media: videobuf2-v4l2: add vb2_request_queue/validate helpers
      media: videobuf2-core: add uses_requests/qbuf flags
      media: videobuf2-v4l2: refuse qbuf if queue uses requests or vv.
      media: v4l2-mem2mem: add vb2_m2m_request_queue
      media: vim2m: use workqueue
      media: vim2m: support requests
      media: vivid: add mc
      media: vivid: add request support
      media: media-request: return -EINVAL for invalid request_fds
      media: v4l2-ctrls: return -EACCES if request wasn't completed
      media: buffer.rst: only set V4L2_BUF_FLAG_REQUEST_FD for QBUF
      media: videodev2.h: add new capabilities for buffer types
      media: vb2: set reqbufs/create_bufs capabilities
      media: media-request: add media_request_(un)lock_for_access
      media: v4l2-ctrls: use media_request_(un)lock_for_access
      media: v4l2-ctrls: improve media_request_(un)lock_for_update
      media: media-request: EPERM -> EACCES/EBUSY
      media: media-request: update documentation
      media: v4l2-compat-ioctl32.c: add missing documentation for a field
      media: v4l2-ctrls.c: initialize an error return code with zero

Paul Kocialkowski (5):
      media: videobuf2-core: Rework and rename helper for request buffer count
      media: v4l: Add definitions for MPEG-2 slice format and metadata
      media: v4l: Add definition for the Sunxi tiled NV12 format
      media: dt-bindings: media: Document bindings for the Cedrus VPU driver
      media: platform: Add Cedrus VPU decoder driver

Sakari Ailus (1):
      media: doc: Add media-request.h header to documentation build

 Documentation/devicetree/bindings/media/cedrus.txt |  54 ++
 .../devicetree/bindings/media/rockchip-vpu.txt     |  29 +
 Documentation/media/kapi/mc-core.rst               |   2 +
 .../media/uapi/mediactl/media-controller.rst       |   1 +
 Documentation/media/uapi/mediactl/media-funcs.rst  |   6 +
 .../uapi/mediactl/media-ioc-request-alloc.rst      |  66 +++
 .../uapi/mediactl/media-request-ioc-queue.rst      |  78 +++
 .../uapi/mediactl/media-request-ioc-reinit.rst     |  51 ++
 Documentation/media/uapi/mediactl/request-api.rst  | 252 +++++++++
 .../media/uapi/mediactl/request-func-close.rst     |  49 ++
 .../media/uapi/mediactl/request-func-ioctl.rst     |  67 +++
 .../media/uapi/mediactl/request-func-poll.rst      |  77 +++
 Documentation/media/uapi/v4l/buffer.rst            |  29 +-
 Documentation/media/uapi/v4l/extended-controls.rst | 176 ++++++
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |  16 +
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |  15 +-
 .../media/uapi/v4l/vidioc-create-bufs.rst          |  14 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  59 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  37 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  14 +-
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |  42 +-
 Documentation/media/videodev2.h.rst.exceptions     |   3 +
 MAINTAINERS                                        |   7 +
 drivers/media/Makefile                             |   3 +-
 drivers/media/common/videobuf2/videobuf2-core.c    | 260 +++++++--
 drivers/media/common/videobuf2/videobuf2-v4l2.c    | 528 ++++++++++++------
 drivers/media/dvb-core/dvb_vb2.c                   |   5 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   5 +-
 drivers/media/media-device.c                       |  24 +-
 drivers/media/media-request.c                      | 501 +++++++++++++++++
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
 drivers/media/platform/vim2m.c                     |  50 +-
 drivers/media/platform/vivid/vivid-core.c          |  74 +++
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
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  19 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               | 612 ++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-dev.c                 |  18 +-
 drivers/media/v4l2-core/v4l2-device.c              |   3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  50 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  67 ++-
 drivers/media/v4l2-core/v4l2-subdev.c              |   9 +-
 drivers/staging/media/Kconfig                      |   2 +
 drivers/staging/media/Makefile                     |   1 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   7 +-
 drivers/staging/media/imx/imx-media-dev.c          |   2 +-
 drivers/staging/media/imx/imx-media-fim.c          |   2 +-
 drivers/staging/media/omap4iss/iss_video.c         |   3 +-
 drivers/staging/media/sunxi/Kconfig                |  15 +
 drivers/staging/media/sunxi/Makefile               |   1 +
 drivers/staging/media/sunxi/cedrus/Kconfig         |  14 +
 drivers/staging/media/sunxi/cedrus/Makefile        |   3 +
 drivers/staging/media/sunxi/cedrus/TODO            |   7 +
 drivers/staging/media/sunxi/cedrus/cedrus.c        | 431 +++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h        | 167 ++++++
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |  70 +++
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h    |  27 +
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c     | 327 +++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_hw.h     |  30 +
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c  | 246 +++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h   | 235 ++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  | 542 ++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_video.h  |  30 +
 drivers/usb/gadget/function/uvc_queue.c            |   2 +-
 include/media/media-device.h                       |  29 +
 include/media/media-request.h                      | 442 +++++++++++++++
 include/media/v4l2-ctrls.h                         | 141 ++++-
 include/media/v4l2-device.h                        |  11 +
 include/media/v4l2-mem2mem.h                       |   4 +
 include/media/videobuf2-core.h                     |  64 ++-
 include/media/videobuf2-v4l2.h                     |  20 +-
 include/uapi/linux/media.h                         |   8 +
 include/uapi/linux/v4l2-controls.h                 |  65 +++
 include/uapi/linux/videodev2.h                     |  33 +-
 102 files changed, 6166 insertions(+), 385 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cedrus.txt
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
 create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
 create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
 create mode 100644 Documentation/media/uapi/mediactl/request-api.rst
 create mode 100644 Documentation/media/uapi/mediactl/request-func-close.rst
 create mode 100644 Documentation/media/uapi/mediactl/request-func-ioctl.rst
 create mode 100644 Documentation/media/uapi/mediactl/request-func-poll.rst
 create mode 100644 drivers/media/media-request.c
 create mode 100644 drivers/staging/media/sunxi/Kconfig
 create mode 100644 drivers/staging/media/sunxi/Makefile
 create mode 100644 drivers/staging/media/sunxi/cedrus/Kconfig
 create mode 100644 drivers/staging/media/sunxi/cedrus/Makefile
 create mode 100644 drivers/staging/media/sunxi/cedrus/TODO
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_regs.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.h
 create mode 100644 include/media/media-request.h
