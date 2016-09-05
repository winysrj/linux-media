Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44436 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755836AbcIEMAm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 08:00:42 -0400
Received: from avalon.localnet (dfj612yywbrz---v8rgfy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:120b:a9ff:fe3c:7148])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 5381820006
        for <linux-media@vger.kernel.org>; Mon,  5 Sep 2016 14:00:16 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.9] VSP1 changes
Date: Mon, 05 Sep 2016 15:01:09 +0300
Message-ID: <2347015.yuKncsMtlK@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit fb6609280db902bd5d34445fba1c926e95e63914:

  [media] dvb_frontend: Use memdup_user() rather than duplicating its 
implementation (2016-08-24 17:20:45 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to a9a30bf86ed6af1fc2efefc98f0760f44fd859d9:

  v4l: vsp1: Add R8A7792 VSP1V support (2016-09-05 11:38:22 +0300)

----------------------------------------------------------------
Laurent Pinchart (8):
      v4l: Add metadata buffer type and format
      v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine
      v4l: vsp1: Add HGO support
      v4l: vsp1: Don't create HGO entity when the userspace API is disabled
      v4l: vsp1: Report device model and rev through media device information
      v4l: vsp1: Fix tri-planar format support through DRM API
      v4l: rcar-fcp: Keep the coding style consistent
      v4l: rcar-fcp: Don't force users to check for disabled FCP support

Sergei Shtylyov (1):
      v4l: vsp1: Add R8A7792 VSP1V support

 Documentation/media/uapi/v4l/buffer.rst               |   8 +
 Documentation/media/uapi/v4l/dev-meta.rst             |  63 ++++
 Documentation/media/uapi/v4l/devices.rst              |   1 +
 Documentation/media/uapi/v4l/meta-formats.rst         |  15 +
 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst | 170 +++++++++
 Documentation/media/uapi/v4l/pixfmt.rst               |   1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst      |  14 +-
 Documentation/media/videodev2.h.rst.exceptions        |   2 +
 drivers/media/platform/Kconfig                        |   1 +
 drivers/media/platform/rcar-fcp.c                     |   8 +-
 drivers/media/platform/vsp1/Makefile                  |   1 +
 drivers/media/platform/vsp1/vsp1.h                    |   5 +
 drivers/media/platform/vsp1/vsp1_drm.c                |   8 +-
 drivers/media/platform/vsp1/vsp1_drv.c                |  85 ++++-
 drivers/media/platform/vsp1/vsp1_entity.c             | 136 ++++++-
 drivers/media/platform/vsp1/vsp1_entity.h             |   7 +-
 drivers/media/platform/vsp1/vsp1_hgo.c                | 501 +++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgo.h                |  50 +++
 drivers/media/platform/vsp1/vsp1_histo.c              | 324 +++++++++++++++++
 drivers/media/platform/vsp1/vsp1_histo.h              |  69 ++++
 drivers/media/platform/vsp1/vsp1_pipe.c               |  22 +-
 drivers/media/platform/vsp1/vsp1_pipe.h               |   2 +
 drivers/media/platform/vsp1/vsp1_regs.h               |  26 +-
 drivers/media/platform/vsp1/vsp1_video.c              |  22 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c         |  19 +
 drivers/media/v4l2-core/v4l2-dev.c                    |  16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                  |  35 ++
 drivers/media/v4l2-core/videobuf2-v4l2.c              |   3 +
 include/media/rcar-fcp.h                              |   2 +-
 include/media/v4l2-ioctl.h                            |  17 +
 include/media/vsp1.h                                  |   2 +-
 include/trace/events/v4l2.h                           |   1 +
 include/uapi/linux/videodev2.h                        |  16 +
 33 files changed, 1588 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst
 create mode 100644 Documentation/media/uapi/v4l/meta-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h

-- 
Regards,

Laurent Pinchart

