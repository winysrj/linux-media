Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51436 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751862AbeFHOjv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Jun 2018 10:39:51 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Convert last soc-camera users, rcar fixes,
 subdev std support
Message-ID: <37763018-a00b-806f-82b6-41835b2ea3ec@xs4all.nl>
Date: Fri, 8 Jun 2018 16:39:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull requests converts the last users of soc-camera (thanks, Jacopo!),
has a few rcar fixes and adds support for SDTV to v4l2-subdev (HDTV was
supported, but not SDTV).

Regards,

	Hans

The following changes since commit f2809d20b9250c675fca8268a0f6274277cca7ff:

  media: omap2: fix compile-testing with FB_OMAP2=m (2018-06-05 09:56:56 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19b

for you to fetch changes up to eae1c8802533c940e2a6ca55db4b3aa0a3d0759f:

  v4l: Add support for STD ioctls on subdev nodes (2018-06-08 16:38:43 +0200)

----------------------------------------------------------------
Jacopo Mondi (5):
      media: i2c: Copy rj54n1cb0c soc_camera sensor driver
      media: i2c: rj54n1: Remove soc_camera dependencies
      arch: sh: kfr2r09: Use new renesas-ceu camera driver
      arch: sh: ms7724se: Use new renesas-ceu camera driver
      arch: sh: ap325rxa: Use new renesas-ceu camera driver

Niklas Söderlund (6):
      media: dt-bindings: media: rcar_vin: add support for r8a77965
      dt-bindings: media: rcar_vin: fix style for ports and endpoints
      rcar-vin: sync which hardware buffer to start capture from
      media: rcar-vin: enable support for r8a77965
      v4l2-ioctl: create helper to fill in v4l2_standard for ENUMSTD
      v4l: Add support for STD ioctls on subdev nodes

 Documentation/devicetree/bindings/media/rcar_vin.txt |   21 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst      |   11 +-
 Documentation/media/uapi/v4l/vidioc-g-std.rst        |   14 +-
 Documentation/media/uapi/v4l/vidioc-querystd.rst     |   11 +-
 MAINTAINERS                                          |    8 +
 arch/sh/boards/mach-ap325rxa/setup.c                 |  282 +++------
 arch/sh/boards/mach-kfr2r09/setup.c                  |  217 ++++---
 arch/sh/boards/mach-se/7724/setup.c                  |  120 ++--
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c               |    2 +-
 drivers/media/i2c/Kconfig                            |   11 +
 drivers/media/i2c/Makefile                           |    1 +
 drivers/media/i2c/rj54n1cb0c.c                       | 1437 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-core.c          |   48 ++
 drivers/media/platform/rcar-vin/rcar-dma.c           |   16 +-
 drivers/media/platform/rcar-vin/rcar-vin.h           |    2 +
 drivers/media/v4l2-core/v4l2-ioctl.c                 |   66 ++-
 drivers/media/v4l2-core/v4l2-subdev.c                |   22 +
 include/media/v4l2-ioctl.h                           |   15 +-
 include/uapi/linux/v4l2-subdev.h                     |    4 +
 19 files changed, 1895 insertions(+), 413 deletions(-)
 create mode 100644 drivers/media/i2c/rj54n1cb0c.c
