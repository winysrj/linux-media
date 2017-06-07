Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:35361 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750730AbdFGGv1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 02:51:27 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Added max2175 and rcar_drif drivers
Message-ID: <b6a867fa-bccc-fc14-eb1a-226af5260099@xs4all.nl>
Date: Wed, 7 Jun 2017 08:51:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6fb05e0dd32e566facb96ea61a48c7488daa5ac3:

  [media] saa7164: fix double fetch PCIe access condition (2017-06-06 16:55:50 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git rcar-drif

for you to fetch changes up to 1607773131567986dac183aa30a20ecdba2de77e:

  media: platform: rcar_drif: Add DRIF support (2017-06-07 08:49:43 +0200)

----------------------------------------------------------------
Ramesh Shanmugasundaram (7):
      media: v4l2-ctrls: Reserve controls for MAX217X
      dt-bindings: media: Add MAX2175 binding description
      media: i2c: max2175: Add MAX2175 support
      media: Add new SDR formats PC16, PC18 & PC20
      doc_rst: media: New SDR formats PC16, PC18 & PC20
      dt-bindings: media: Add Renesas R-Car DRIF binding
      media: platform: rcar_drif: Add DRIF support

 Documentation/devicetree/bindings/media/i2c/max2175.txt  |   59 ++
 Documentation/devicetree/bindings/media/renesas,drif.txt |  176 ++++++
 Documentation/devicetree/bindings/property-units.txt     |    1 +
 Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst      |   55 ++
 Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst      |   55 ++
 Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst      |   54 ++
 Documentation/media/uapi/v4l/sdr-formats.rst             |    3 +
 Documentation/media/v4l-drivers/index.rst                |    1 +
 Documentation/media/v4l-drivers/max2175.rst              |   60 ++
 drivers/media/i2c/Kconfig                                |   12 +
 drivers/media/i2c/Makefile                               |    2 +
 drivers/media/i2c/max2175.c                              | 1448 +++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/max2175.h                              |  107 ++++
 drivers/media/platform/Kconfig                           |   25 +
 drivers/media/platform/Makefile                          |    1 +
 drivers/media/platform/rcar_drif.c                       | 1500 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c                     |    3 +
 include/uapi/linux/max2175.h                             |   28 +
 include/uapi/linux/v4l2-controls.h                       |    5 +
 include/uapi/linux/videodev2.h                           |    3 +
 20 files changed, 3598 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/max2175.txt
 create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
 create mode 100644 Documentation/media/v4l-drivers/max2175.rst
 create mode 100644 drivers/media/i2c/max2175.c
 create mode 100644 drivers/media/i2c/max2175.h
 create mode 100644 drivers/media/platform/rcar_drif.c
 create mode 100644 include/uapi/linux/max2175.h
