Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48577 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752078AbdFMOT5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 10:19:57 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] (v2) Added max2175 and rcar_drif drivers
Message-ID: <20c76504-b8fa-f8a3-587e-1517181a7830@xs4all.nl>
Date: Tue, 13 Jun 2017 16:19:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since the previous pull request:

- made i2s control private
- add maintainers entries
- fix sparse/smatch errors
- slightly modified the code so we don't hit a regmap_read_poll_timeout macro
  bug (patches to fix that were posted separately, out of scope for media).

Regards,

	Hans

The following changes since commit 47f910f0e0deb880c2114811f7ea1ec115a19ee4:

  [media] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev (2017-06-08 16:55:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git rcar-drif

for you to fetch changes up to 1c226f355783196a85cfe4446b2817ea15fff2ea:

  MAINTAINERS: Add entry for R-Car DRIF & MAX2175 drivers (2017-06-13 15:52:39 +0200)

----------------------------------------------------------------
Ramesh Shanmugasundaram (8):
      media: v4l2-ctrls: Reserve controls for MAX217X
      dt-bindings: media: Add MAX2175 binding description
      media: i2c: max2175: Add MAX2175 support
      media: Add new SDR formats PC16, PC18 & PC20
      doc_rst: media: New SDR formats PC16, PC18 & PC20
      dt-bindings: media: Add Renesas R-Car DRIF binding
      media: platform: rcar_drif: Add DRIF support
      MAINTAINERS: Add entry for R-Car DRIF & MAX2175 drivers

 Documentation/devicetree/bindings/media/i2c/max2175.txt  |   59 ++++
 Documentation/devicetree/bindings/media/renesas,drif.txt |  176 ++++++++++
 Documentation/devicetree/bindings/property-units.txt     |    1 +
 Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst      |   55 ++++
 Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst      |   55 ++++
 Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst      |   54 +++
 Documentation/media/uapi/v4l/sdr-formats.rst             |    3 +
 Documentation/media/v4l-drivers/index.rst                |    1 +
 Documentation/media/v4l-drivers/max2175.rst              |   62 ++++
 MAINTAINERS                                              |   19 ++
 drivers/media/i2c/Kconfig                                |   12 +
 drivers/media/i2c/Makefile                               |    2 +
 drivers/media/i2c/max2175.c                              | 1453 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/max2175.h                              |  109 +++++++
 drivers/media/platform/Kconfig                           |   25 ++
 drivers/media/platform/Makefile                          |    1 +
 drivers/media/platform/rcar_drif.c                       | 1498 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c                     |    3 +
 include/uapi/linux/max2175.h                             |   28 ++
 include/uapi/linux/v4l2-controls.h                       |    5 +
 include/uapi/linux/videodev2.h                           |    3 +
 21 files changed, 3624 insertions(+)
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
