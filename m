Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40514 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752459AbdDDOVs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 10:21:48 -0400
Received: from avalon.localnet (unknown [109.134.82.53])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 2F9DE20046
        for <linux-media@vger.kernel.org>; Tue,  4 Apr 2017 16:21:21 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.12] Renesas R-Car VSP1 changes
Date: Tue, 04 Apr 2017 17:22:31 +0300
Message-ID: <2693141.llBgeEXWgs@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 7ca0ef3da09888b303991edb80cd0283ee64=
1c9e:

  Merge tag 'v4.11-rc5' into patchwork (2017-04-04 11:11:43 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to b116ebc56310945bde34f49380ca5501f723769d=
:

  v4l: vsp1: Add HGT support (2017-04-04 17:19:51 +0300)


The pull request contains assorted cleanup and fixes, followed by rotat=
ion and=20
histogram support including the corresponding V4L2 API documentation=20=

enhancements.

----------------------------------------------------------------
Kieran Bingham (5):
      v4l: vsp1: Fix format-info documentation
      v4l: vsp1: Prevent multiple streamon race commencing pipeline ear=
ly
      v4l: vsp1: Remove redundant pipe->dl usage from drm
      v4l: vsp1: Fix struct vsp1_drm documentation
      v4l: vsp1: Register pipe with output WPF

Laurent Pinchart (11):
      v4l: vsp1: Fix RPF/WPF U/V order in 3-planar formats on Gen3
      v4l: vsp1: Fix multi-line comment style
      v4l: vsp1: Disable HSV formats on Gen3 hardware
      v4l: Clearly document interactions between formats, controls and =
buffers
      v4l: vsp1: wpf: Implement rotation support
      v4l: Add metadata buffer type and format
      v4l: vsp1: Add histogram support
      v4l: vsp1: Support histogram generators in pipeline configuration=

      v4l: vsp1: Fix HGO and HGT routing register addresses
      v4l: Define a pixel format for the R-Car VSP1 1-D histogram engin=
e
      v4l: vsp1: Add HGO support

Niklas S=F6derlund (2):
      v4l: Define a pixel format for the R-Car VSP1 2-D histogram engin=
e
      v4l: vsp1: Add HGT support

Shailendra Verma (1):
      v4l: vsp1: Clean up file handle in open() error path

 Documentation/media/uapi/v4l/buffer.rst               | 113 +++++
 Documentation/media/uapi/v4l/dev-meta.rst             |  62 +++
 Documentation/media/uapi/v4l/devices.rst              |   1 +
 Documentation/media/uapi/v4l/meta-formats.rst         |  16 +
 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst | 168 +++++++
 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst | 120 +++++
 Documentation/media/uapi/v4l/pixfmt.rst               |   1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst      |   3 +
 Documentation/media/videodev2.h.rst.exceptions        |   2 +
 drivers/media/platform/Kconfig                        |   1 +
 drivers/media/platform/vsp1/Makefile                  |   1 +
 drivers/media/platform/vsp1/vsp1.h                    |   6 +
 drivers/media/platform/vsp1/vsp1_bru.c                |  27 +-
 drivers/media/platform/vsp1/vsp1_dl.c                 |  27 +-
 drivers/media/platform/vsp1/vsp1_drm.c                |  42 +-
 drivers/media/platform/vsp1/vsp1_drm.h                |   2 +-
 drivers/media/platform/vsp1/vsp1_drv.c                |  82 +++-
 drivers/media/platform/vsp1/vsp1_entity.c             | 163 ++++++-
 drivers/media/platform/vsp1/vsp1_entity.h             |   8 +-
 drivers/media/platform/vsp1/vsp1_hgo.c                | 228 +++++++++
 drivers/media/platform/vsp1/vsp1_hgo.h                |  45 ++
 drivers/media/platform/vsp1/vsp1_hgt.c                | 222 +++++++++
 drivers/media/platform/vsp1/vsp1_hgt.h                |  42 ++
 drivers/media/platform/vsp1/vsp1_histo.c              | 646 ++++++++++=
+++++++
 drivers/media/platform/vsp1/vsp1_histo.h              |  84 ++++
 drivers/media/platform/vsp1/vsp1_hsit.c               |   3 +-
 drivers/media/platform/vsp1/vsp1_lif.c                |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.c               |  59 ++-
 drivers/media/platform/vsp1/vsp1_pipe.h               |   9 +-
 drivers/media/platform/vsp1/vsp1_regs.h               |  33 +-
 drivers/media/platform/vsp1/vsp1_rpf.c                |  54 ++-
 drivers/media/platform/vsp1/vsp1_rwpf.c               |  11 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h               |   7 +-
 drivers/media/platform/vsp1/vsp1_sru.c                |   3 +-
 drivers/media/platform/vsp1/vsp1_uds.c                |   3 +-
 drivers/media/platform/vsp1/vsp1_video.c              |  85 +++-
 drivers/media/platform/vsp1/vsp1_wpf.c                | 224 ++++++---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c         |  19 +
 drivers/media/v4l2-core/v4l2-dev.c                    |  16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                  |  36 ++
 drivers/media/v4l2-core/videobuf2-v4l2.c              |   3 +
 include/media/v4l2-ioctl.h                            |  17 +
 include/trace/events/v4l2.h                           |   1 +
 include/uapi/linux/videodev2.h                        |  17 +
 44 files changed, 2527 insertions(+), 191 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst
 create mode 100644 Documentation/media/uapi/v4l/meta-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.r=
st
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.r=
st
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h

--=20
Regards,

Laurent Pinchart
