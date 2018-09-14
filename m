Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:47952 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727803AbeINRuL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 13:50:11 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20 (request_api branch)] Add Allwinner cedrus
 decoder driver (v2)
Message-ID: <b47510c2-8840-c0c6-0aff-e93fcd0c07ca@xs4all.nl>
Date: Fri, 14 Sep 2018 14:35:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the cedrus Allwinner decoder driver. It is for the request_api topic
branch.

Note that there is a COMPILE_TEST issue with sram functions, for that another patch
is needed:

https://lore.kernel.org/patchwork/patch/983848/

But that's going through another subsystem and is already queued up for 4.20.

The first two patches fix two trivial sparse and smatch issues.

Many, many thanks go to Paul for working on this, trying to keep up to date with
the Request API changes at the same time. It was a pleasure working with you on
this!

I'm now using a signed tag, let me know if this works or not.

Regards,

	Hans

The following changes since commit d4215edbd4b170b207b0e5a1d8ae42fb49f5c470:

  media: media-request: update documentation (2018-09-11 09:58:43 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-cedrus

for you to fetch changes up to 615ba78ac81ce76edf5ae84981e404fd4eee3ee0:

  media: platform: Add Cedrus VPU decoder driver (2018-09-14 14:27:45 +0200)

----------------------------------------------------------------
Tag cedrus branch

----------------------------------------------------------------
Hans Verkuil (2):
      v4l2-compat-ioctl32.c: fix sparse warning
      v4l2-ctrls.c: fix smatch error

Paul Kocialkowski (5):
      media: videobuf2-core: Rework and rename helper for request buffer count
      media: v4l: Add definitions for MPEG-2 slice format and metadata
      media: v4l: Add definition for the Sunxi tiled NV12 format
      dt-bindings: media: Document bindings for the Cedrus VPU driver
      media: platform: Add Cedrus VPU decoder driver

 Documentation/devicetree/bindings/media/cedrus.txt |  54 +++++++
 Documentation/media/uapi/v4l/extended-controls.rst | 176 ++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |  16 ++
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |  15 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  14 +-
 Documentation/media/videodev2.h.rst.exceptions     |   2 +
 MAINTAINERS                                        |   7 +
 drivers/media/common/videobuf2/videobuf2-core.c    |  18 +--
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |   2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   1 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |  65 +++++++-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
 drivers/staging/media/Kconfig                      |   2 +
 drivers/staging/media/Makefile                     |   1 +
 drivers/staging/media/sunxi/Kconfig                |  15 ++
 drivers/staging/media/sunxi/Makefile               |   1 +
 drivers/staging/media/sunxi/cedrus/Kconfig         |  14 ++
 drivers/staging/media/sunxi/cedrus/Makefile        |   3 +
 drivers/staging/media/sunxi/cedrus/TODO            |   7 +
 drivers/staging/media/sunxi/cedrus/cedrus.c        | 431 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h        | 167 +++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |  70 +++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h    |  27 ++++
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c     | 327 ++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_hw.h     |  30 ++++
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c  | 246 ++++++++++++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h   | 235 +++++++++++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  | 542 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus_video.h  |  30 ++++
 include/media/v4l2-ctrls.h                         |  18 ++-
 include/media/videobuf2-core.h                     |   4 +-
 include/uapi/linux/v4l2-controls.h                 |  65 ++++++++
 include/uapi/linux/videodev2.h                     |   6 +
 33 files changed, 2589 insertions(+), 24 deletions(-)
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
