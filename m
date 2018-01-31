Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33622 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbeAaKZB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 05:25:01 -0500
Received: by mail-pg0-f68.google.com with SMTP id u1so9690658pgr.0
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 02:25:01 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv2 00/17] Request API, take three
Date: Wed, 31 Jan 2018 19:24:18 +0900
Message-Id: <20180131102427.207721-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a quickly-put together revision that includes and uses Hans' work to
use v4l2_ctrl_handler as the request state holder for V4L2 devices. Although
minor fixes have also been applied, there are still a few comments from the
previous revision that are left unaddressed. I wanted to give Hans something
to play with before he forgets what he had in mind for controls. ;)

Changelog since v1:
* Integrate Hans control framework patches so S_EXT_CTRLS and G_EXT_CTRLS now
  work with requests
* Only allow one buffer at a time for a given request in the buffer queue
* Applied comments related to documentation and document control ioctls
* Minor small fixes

I have also updated the very basic program that demonstrates the use of the
request API on vim2m:

https://gist.github.com/Gnurou/dbc3776ed97ea7d4ce6041ea15eb0438

It does not do much, but gives a practical idea of how requests should be used.

Alexandre Courbot (9):
  media: add request API core and UAPI
  media: videobuf2: add support for requests
  media: vb2: add support for requests in QBUF ioctl
  v4l2: add request API support
  videodev2.h: add request_fd field to v4l2_ext_controls
  v4l2-ctrls: support requests in EXT_CTRLS ioctls
  v4l2: document the request API interface
  media: vim2m: add media device
  media: vim2m: add request support

Hans Verkuil (7):
  videodev2.h: Add request_fd field to v4l2_buffer
  v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
  v4l2-ctrls: prepare internal structs for request API
  v4l2-ctrls: add core request API
  v4l2-ctrls: use ref in helper instead of ctrl
  v4l2-ctrls: support g/s_ext_ctrls for requests
  v4l2-ctrls: add v4l2_ctrl_request_setup

Laurent Pinchart (1):
  media: Document the media request API

 Documentation/media/uapi/mediactl/media-funcs.rst  |   1 +
 .../media/uapi/mediactl/media-ioc-request-cmd.rst  | 141 ++++++++++
 Documentation/media/uapi/v4l/buffer.rst            |  10 +-
 Documentation/media/uapi/v4l/common.rst            |   1 +
 Documentation/media/uapi/v4l/request-api.rst       | 236 ++++++++++++++++
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  16 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  21 ++
 drivers/media/Makefile                             |   3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   5 +-
 drivers/media/media-device.c                       |   7 +
 drivers/media/media-request-mgr.c                  | 105 +++++++
 drivers/media/media-request.c                      | 311 +++++++++++++++++++++
 drivers/media/pci/bt8xx/bttv-driver.c              |   2 +-
 drivers/media/pci/cx23885/cx23885-417.c            |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   2 +-
 drivers/media/pci/cx88/cx88-video.c                |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   3 +-
 drivers/media/platform/rcar_drif.c                 |   2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   3 +-
 drivers/media/platform/vim2m.c                     |  79 ++++++
 drivers/media/platform/vivid/vivid-ctrls.c         |  42 +--
 drivers/media/usb/cpia2/cpia2_v4l.c                |   2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/msi2500/msi2500.c                |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   2 +-
 drivers/media/v4l2-core/Makefile                   |   2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   7 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               | 238 ++++++++++++++--
 drivers/media/v4l2-core/v4l2-device.c              |   3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               | 125 ++++++++-
 drivers/media/v4l2-core/v4l2-request.c             |  54 ++++
 drivers/media/v4l2-core/videobuf2-core.c           | 133 ++++++++-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  31 +-
 drivers/staging/media/imx/imx-media-dev.c          |   2 +-
 drivers/staging/media/imx/imx-media-fim.c          |   2 +-
 include/media/media-device.h                       |   3 +
 include/media/media-entity.h                       |   9 +
 include/media/media-request-mgr.h                  |  73 +++++
 include/media/media-request.h                      | 186 ++++++++++++
 include/media/v4l2-ctrls.h                         |  17 +-
 include/media/v4l2-request.h                       |  34 +++
 include/media/videobuf2-core.h                     |  15 +-
 include/media/videobuf2-v4l2.h                     |   2 +
 include/uapi/linux/media.h                         |  10 +
 include/uapi/linux/videodev2.h                     |   6 +-
 49 files changed, 1881 insertions(+), 85 deletions(-)
 create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-cmd.rst
 create mode 100644 Documentation/media/uapi/v4l/request-api.rst
 create mode 100644 drivers/media/media-request-mgr.c
 create mode 100644 drivers/media/media-request.c
 create mode 100644 drivers/media/v4l2-core/v4l2-request.c
 create mode 100644 include/media/media-request-mgr.h
 create mode 100644 include/media/media-request.h
 create mode 100644 include/media/v4l2-request.h

-- 
2.16.0.rc1.238.g530d649a79-goog
