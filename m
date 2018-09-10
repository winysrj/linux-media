Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39327 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727488AbeIJN1x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 09:27:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20 (request_api branch)] Add Allwinner cedrus
 decoder driver
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Message-ID: <8c00abfd-3f15-eab5-7d0b-5a4f7580d1f0@xs4all.nl>
Date: Mon, 10 Sep 2018 10:34:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the cedrus Allwinner decoder driver. It is for the request_api topic
branch, but it assumes that this pull request is applied first:
https://patchwork.linuxtv.org/patch/51889/

The last two patches could optionally be squashed with the main driver patch:
they fix COMPILE_TEST issues. I decided not to squash them and leave the choice
to you.

This won't fully fix the COMPILE_TEST problems, for that another patch is needed:

https://lore.kernel.org/patchwork/patch/983848/

But that's going through another subsystem.

Many, many thanks go to Paul for working on this, trying to keep up to date with
the Request API changes at the same time. It was a pleasure working with you on
this!

Regards,

	Hans

The following changes since commit 051dfd971de1317626d322581546257b748ebde1:

  media-request: update documentation (2018-09-04 11:34:57 +0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cedrus

for you to fetch changes up to e035b190fac3735e5f9d3c96cee5afc82aa1a94d:

  media: cedrus: Select the sunxi SRAM driver in Kconfig (2018-09-10 10:22:07 +0200)

----------------------------------------------------------------
Paul Kocialkowski (13):
      media: videobuf2-core: Rework and rename helper for request buffer count
      media: v4l: Add definitions for MPEG-2 slice format and metadata
      media: v4l: Add definition for the Sunxi tiled NV12 format
      dt-bindings: media: Document bindings for the Cedrus VPU driver
      media: platform: Add Cedrus VPU decoder driver
      ARM: dts: sun5i: Add Video Engine and reserved memory nodes
      ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
      ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes
      ARM: dts: sun8i-h3: Add Video Engine and reserved memory nodes
      media: cedrus: Fix error reporting in request validation
      media: cedrus: Add TODO file with tasks to complete before unstaging
      media: cedrus: Wrap PHYS_PFN_OFFSET with ifdef and add dedicated comment
      media: cedrus: Select the sunxi SRAM driver in Kconfig

 Documentation/devicetree/bindings/media/cedrus.txt |  54 +++++
 Documentation/media/uapi/v4l/extended-controls.rst | 176 ++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |  16 ++
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |  15 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  14 +-
 Documentation/media/videodev2.h.rst.exceptions     |   2 +
 MAINTAINERS                                        |   7 +
 arch/arm/boot/dts/sun5i.dtsi                       |  26 +++
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  26 +++
 arch/arm/boot/dts/sun8i-a33.dtsi                   |  26 +++
 arch/arm/boot/dts/sun8i-h3.dtsi                    |  25 +++
 drivers/media/common/videobuf2/videobuf2-core.c    |  18 +-
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  63 ++++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
 drivers/staging/media/Kconfig                      |   2 +
 drivers/staging/media/Makefile                     |   1 +
 drivers/staging/media/sunxi/Kconfig                |  15 ++
 drivers/staging/media/sunxi/Makefile               |   1 +
 drivers/staging/media/sunxi/cedrus/Kconfig         |  14 ++
 drivers/staging/media/sunxi/cedrus/Makefile        |   3 +
 drivers/staging/media/sunxi/cedrus/TODO            |   7 +
 drivers/staging/media/sunxi/cedrus/cedrus.c        | 431 +++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h        | 165 +++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |  70 +++++++
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h    |  27 +++
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c     | 327 +++++++++++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_hw.h     |  30 +++
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c  | 237 +++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h   | 233 +++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  | 544 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_video.h  |  30 +++
 include/media/v4l2-ctrls.h                         |  18 +-
 include/media/videobuf2-core.h                     |   4 +-
 include/uapi/linux/v4l2-controls.h                 |  65 ++++++
 include/uapi/linux/videodev2.h                     |   6 +
 36 files changed, 2679 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cedrus.txt
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
