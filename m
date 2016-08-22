Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44531 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753485AbcHVJhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 05:37:31 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id AD915180456
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 11:37:25 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Add touch API and atmel_mxt_ts/synaptics drivers
 (v2)
Message-ID: <512b4ae8-719d-56ff-3d17-1bc2e7815ab9@xs4all.nl>
Date: Mon, 22 Aug 2016 11:37:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for /dev/v4l-touchX devices.

Regards,

	Hans

Changes since v1:

Updated the sur40 patch to fix a compiler error.


The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git touch

for you to fetch changes up to 29064fa6376528929d1aa560f6faa7bddc333d69:

  Documentation: add support for V4L touch devices (2016-08-22 11:29:22 +0200)

----------------------------------------------------------------
Nick Dyer (11):
      Input: atmel_mxt_ts - update MAINTAINERS email address
      v4l2-core: Add support for touch devices
      Input: atmel_mxt_ts - add support for T37 diagnostic data
      Input: atmel_mxt_ts - output diagnostic debug via V4L2 device
      Input: atmel_mxt_ts - read touchscreen size
      Input: atmel_mxt_ts - handle diagnostic data orientation
      Input: atmel_mxt_ts - add diagnostic data support for mXT1386
      Input: atmel_mxt_ts - add support for reference data
      Input: synaptics-rmi4 - add support for F54 diagnostics
      Input: sur40 - use new V4L2 touch input type
      Documentation: add support for V4L touch devices

 Documentation/media/kapi/v4l2-dev.rst             |   1 +
 Documentation/media/uapi/mediactl/media-types.rst |  24 +-
 Documentation/media/uapi/v4l/dev-touch.rst        |  56 ++++
 Documentation/media/uapi/v4l/devices.rst          |   1 +
 Documentation/media/uapi/v4l/pixfmt-tch-td08.rst  |  80 ++++++
 Documentation/media/uapi/v4l/pixfmt-tch-td16.rst  | 111 ++++++++
 Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst  |  78 ++++++
 Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst  | 110 ++++++++
 Documentation/media/uapi/v4l/pixfmt.rst           |   1 +
 Documentation/media/uapi/v4l/tch-formats.rst      |  18 ++
 Documentation/media/uapi/v4l/vidioc-enuminput.rst |   8 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst  |   8 +
 Documentation/media/videodev2.h.rst.exceptions    |   2 +
 MAINTAINERS                                       |   6 +-
 drivers/input/rmi4/Kconfig                        |  11 +
 drivers/input/rmi4/Makefile                       |   1 +
 drivers/input/rmi4/rmi_bus.c                      |   3 +
 drivers/input/rmi4/rmi_driver.h                   |   1 +
 drivers/input/rmi4/rmi_f54.c                      | 756 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/touchscreen/Kconfig                 |   8 +
 drivers/input/touchscreen/atmel_mxt_ts.c          | 520 ++++++++++++++++++++++++++++++++++
 drivers/input/touchscreen/sur40.c                 | 124 ++++++---
 drivers/media/media-entity.c                      |   2 +
 drivers/media/v4l2-core/v4l2-dev.c                |  14 +-
 drivers/media/v4l2-core/v4l2-ioctl.c              |  36 ++-
 include/media/v4l2-dev.h                          |   4 +-
 include/uapi/linux/media.h                        |   1 +
 include/uapi/linux/videodev2.h                    |   9 +
 28 files changed, 1942 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-touch.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-td08.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-td16.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst
 create mode 100644 Documentation/media/uapi/v4l/tch-formats.rst
 create mode 100644 drivers/input/rmi4/rmi_f54.c
