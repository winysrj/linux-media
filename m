Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51227 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726996AbeGRLQS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 07:16:18 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Various fixes
Message-ID: <a9296b29-09ad-9379-0786-de282b71abf2@xs4all.nl>
Date: Wed, 18 Jul 2018 12:38:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Various fixes. Please note that I re-added the 'Add support for STD ioctls on subdev nodes'
patch. It really is needed.

Regards,

	Hans

The following changes since commit 39fbb88165b2bbbc77ea7acab5f10632a31526e6:

  media: bpf: ensure bpf program is freed on detach (2018-07-13 11:07:29 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19m

for you to fetch changes up to 38630cde092e3fd66e18fc8752d7dd6b32947ca7:

  media: staging: tegra-vde: Replace debug messages with trace points (2018-07-18 12:15:18 +0200)

----------------------------------------------------------------
Dmitry Osipenko (1):
      media: staging: tegra-vde: Replace debug messages with trace points

Ezequiel Garcia (3):
      rcar_jpu: Remove unrequired wait in .job_abort
      s5p-g2d: Remove unrequired wait in .job_abort
      mem2mem: Make .job_abort optional

Hans Verkuil (1):
      videobuf2-core: check for q->error in vb2_core_qbuf()

Jacopo Mondi (9):
      sh: defconfig: migor: Update defconfig
      sh: defconfig: migor: Enable CEU and sensor drivers
      sh: defconfig: ecovec: Update defconfig
      sh: defconfig: ecovec: Enable CEU and video drivers
      sh: defconfig: se7724: Update defconfig
      sh: defconfig: se7724: Enable CEU and sensor driver
      sh: defconfig: ap325rxa: Update defconfig
      sh: defconfig: ap325rxa: Enable CEU and sensor driver
      sh: migor: Remove stale soc_camera include

Laurent Pinchart (1):
      v4l: rcar_fdp1: Enable compilation on Gen2 platforms

Neil Armstrong (1):
      media: platform: meson-ao-cec: make busy TX warning silent

Niklas Söderlund (1):
      v4l: Add support for STD ioctls on subdev nodes

Philipp Zabel (1):
      media: video-mux: fix compliance failures

 Documentation/media/uapi/v4l/vidioc-enumstd.rst  |  11 ++-
 Documentation/media/uapi/v4l/vidioc-g-std.rst    |  14 +++-
 Documentation/media/uapi/v4l/vidioc-querystd.rst |  11 ++-
 arch/sh/boards/mach-migor/setup.c                |   1 -
 arch/sh/configs/ap325rxa_defconfig               |  29 ++-----
 arch/sh/configs/ecovec24_defconfig               |  35 ++-------
 arch/sh/configs/migor_defconfig                  |  31 ++------
 arch/sh/configs/se7724_defconfig                 |  30 ++------
 drivers/media/common/videobuf2/videobuf2-core.c  |   5 ++
 drivers/media/platform/Kconfig                   |   2 +-
 drivers/media/platform/meson/ao-cec.c            |   2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c  |   5 --
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c     |   5 --
 drivers/media/platform/rcar_jpu.c                |  16 ----
 drivers/media/platform/rockchip/rga/rga.c        |   6 --
 drivers/media/platform/s5p-g2d/g2d.c             |  16 ----
 drivers/media/platform/s5p-g2d/g2d.h             |   1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c      |   7 --
 drivers/media/platform/video-mux.c               | 119 ++++++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-mem2mem.c           |   6 +-
 drivers/media/v4l2-core/v4l2-subdev.c            |  22 ++++++
 drivers/staging/media/tegra-vde/tegra-vde.c      | 221 +++++++++++++++++++++++++++++++-----------------------
 drivers/staging/media/tegra-vde/trace.h          |  98 ++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h                     |   2 +-
 include/uapi/linux/v4l2-subdev.h                 |   4 +
 25 files changed, 429 insertions(+), 270 deletions(-)
 create mode 100644 drivers/staging/media/tegra-vde/trace.h
