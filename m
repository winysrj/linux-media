Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44949 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdB1P5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 10:57:16 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Subject: [PATCH v3 0/8] R-Car VSP1 Histogram Support
Date: Tue, 28 Feb 2017 17:56:40 +0200
Message-Id: <20170228155648.12051-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series implements support for the Renesas R-Car VSP1 1-D and 2-D
histogram generators (HGO and HGT). It is based on top of the VSP1 rotation
patches and available for convenience at

        git://linuxtv.org/pinchartl/media.git vsp1-histogram-v3-20170228

The series starts with the implementation and documentation of the new V4L2
metadata API (1/8), followed by three VSP1 patches that add generic histogram
support to the driver (2/8 to 4/8). Patches 5/8 and 7/8 then add new pixel
formats for the R-Car VSP1 1-D and 2-D histograms, and patches 6/8 and 8/8
implement support for those histogram generators in the VSP1 driver.

Laurent Pinchart (6):
  v4l: Add metadata buffer type and format
  v4l: vsp1: Add histogram support
  v4l: vsp1: Support histogram generators in pipeline configuration
  v4l: vsp1: Fix HGO and HGT routing register addresses
  v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine
  v4l: vsp1: Add HGO support

Niklas Söderlund (2):
  v4l: Define a pixel format for the R-Car VSP1 2-D histogram engine
  v4l: vsp1: Add HGT support

 Documentation/media/uapi/v4l/buffer.rst            |   3 +
 Documentation/media/uapi/v4l/dev-meta.rst          |  62 ++
 Documentation/media/uapi/v4l/devices.rst           |   1 +
 Documentation/media/uapi/v4l/meta-formats.rst      |  16 +
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst        | 168 ++++++
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst        | 120 ++++
 Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   3 +
 Documentation/media/videodev2.h.rst.exceptions     |   2 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/vsp1/Makefile               |   1 +
 drivers/media/platform/vsp1/vsp1.h                 |   6 +
 drivers/media/platform/vsp1/vsp1_drm.c             |   2 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |  70 ++-
 drivers/media/platform/vsp1/vsp1_entity.c          | 154 ++++-
 drivers/media/platform/vsp1/vsp1_entity.h          |   8 +-
 drivers/media/platform/vsp1/vsp1_hgo.c             | 228 ++++++++
 drivers/media/platform/vsp1/vsp1_hgo.h             |  45 ++
 drivers/media/platform/vsp1/vsp1_hgt.c             | 222 +++++++
 drivers/media/platform/vsp1/vsp1_hgt.h             |  42 ++
 drivers/media/platform/vsp1/vsp1_histo.c           | 646 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_histo.h           |  84 +++
 drivers/media/platform/vsp1/vsp1_pipe.c            |  38 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |   4 +
 drivers/media/platform/vsp1/vsp1_regs.h            |  33 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  30 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  19 +
 drivers/media/v4l2-core/v4l2-dev.c                 |  16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  36 ++
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   3 +
 include/media/v4l2-ioctl.h                         |  17 +
 include/trace/events/v4l2.h                        |   1 +
 include/uapi/linux/videodev2.h                     |  17 +
 33 files changed, 2051 insertions(+), 48 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst
 create mode 100644 Documentation/media/uapi/v4l/meta-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h

-- 
Regards,

Laurent Pinchart
