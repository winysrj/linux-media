Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46984 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752326AbdFMTzj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 15:55:39 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Add video-mux, ov5640 and i.MX media staging
 driver
Message-ID: <e52a521e-2c39-ad85-50dd-6313f87daf0f@xs4all.nl>
Date: Tue, 13 Jun 2017 21:55:33 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's been a long road, but the i.MX6 platform now has a proper driver. There
are a few relatively minor issues remaining (see the TODO file) before it
can be moved out of staging.

I want to thank Steve and Philipp for their hard work!

Regards,

	Hans

The following changes since commit 47f910f0e0deb880c2114811f7ea1ec115a19ee4:

   [media] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev (2017-06-08 16:55:25 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git imx6

for you to fetch changes up to 5f19bcc69f4e351ab6700214e4f8f3d71807d4e2:

   MAINTAINERS: add entry for Freescale i.MX media driver (2017-06-13 21:48:28 +0200)

----------------------------------------------------------------
Marek Vasut (1):
       media: imx: Drop warning upon multiple S_STREAM disable calls

Philipp Zabel (7):
       dt-bindings: Add bindings for video-multiplexer device
       add mux and video interface bridge entity functions
       platform: add video-multiplexer subdevice driver
       MAINTAINERS: add maintainer entry for video multiplexer v4l2 subdevice driver
       media: imx: csi: increase burst size for YUV formats
       media: imx: csi: add frame skipping support
       media: imx: csi: add sink selection rectangles

Russell King (3):
       media: imx: csi: add support for bayer formats
       media: imx: csi: add frame size/interval enumeration
       media: imx: capture: add frame sizes/interval enumeration

Steve Longerbeam (14):
       dt/bindings: Add bindings for OV5640
       add Omnivision OV5640 sensor driver
       MAINTAINERS: add entry for OV5640 sensor driver
       dt-bindings: Add bindings for i.MX media driver
       media: Add userspace header file for i.MX
       media: Add i.MX media core driver
       media: imx: Add a TODO file
       media: imx: Add Capture Device Interface
       media: imx: Add CSI subdev driver
       media: imx: Add VDIC subdev driver
       media: imx: Add IC subdev drivers
       media: imx: Add MIPI CSI-2 Receiver subdev driver
       media: imx: set and propagate default field, colorimetry
       MAINTAINERS: add entry for Freescale i.MX media driver

  Documentation/devicetree/bindings/media/i2c/ov5640.txt |   45 +
  Documentation/devicetree/bindings/media/imx.txt        |   53 +
  Documentation/devicetree/bindings/media/video-mux.txt  |   60 ++
  Documentation/media/uapi/mediactl/media-types.rst      |   21 +
  Documentation/media/v4l-drivers/imx.rst                |  614 ++++++++++++
  MAINTAINERS                                            |   25 +
  drivers/media/i2c/Kconfig                              |   10 +
  drivers/media/i2c/Makefile                             |    1 +
  drivers/media/i2c/ov5640.c                             | 2344 ++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/platform/Kconfig                         |    7 +
  drivers/media/platform/Makefile                        |    2 +
  drivers/media/platform/video-mux.c                     |  334 +++++++
  drivers/staging/media/Kconfig                          |    2 +
  drivers/staging/media/Makefile                         |    1 +
  drivers/staging/media/imx/Kconfig                      |   21 +
  drivers/staging/media/imx/Makefile                     |   12 +
  drivers/staging/media/imx/TODO                         |   23 +
  drivers/staging/media/imx/imx-ic-common.c              |  113 +++
  drivers/staging/media/imx/imx-ic-prp.c                 |  518 ++++++++++
  drivers/staging/media/imx/imx-ic-prpencvf.c            | 1309 +++++++++++++++++++++++++
  drivers/staging/media/imx/imx-ic.h                     |   38 +
  drivers/staging/media/imx/imx-media-capture.c          |  775 +++++++++++++++
  drivers/staging/media/imx/imx-media-csi.c              | 1817 ++++++++++++++++++++++++++++++++++
  drivers/staging/media/imx/imx-media-dev.c              |  667 +++++++++++++
  drivers/staging/media/imx/imx-media-fim.c              |  494 ++++++++++
  drivers/staging/media/imx/imx-media-internal-sd.c      |  349 +++++++
  drivers/staging/media/imx/imx-media-of.c               |  270 +++++
  drivers/staging/media/imx/imx-media-utils.c            |  896 +++++++++++++++++
  drivers/staging/media/imx/imx-media-vdic.c             | 1009 +++++++++++++++++++
  drivers/staging/media/imx/imx-media.h                  |  325 ++++++
  drivers/staging/media/imx/imx6-mipi-csi2.c             |  698 +++++++++++++
  include/linux/imx-media.h                              |   29 +
  include/media/imx.h                                    |   15 +
  include/uapi/linux/media.h                             |    6 +
  include/uapi/linux/v4l2-controls.h                     |    4 +
  35 files changed, 12907 insertions(+)
  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
  create mode 100644 Documentation/devicetree/bindings/media/imx.txt
  create mode 100644 Documentation/devicetree/bindings/media/video-mux.txt
  create mode 100644 Documentation/media/v4l-drivers/imx.rst
  create mode 100644 drivers/media/i2c/ov5640.c
  create mode 100644 drivers/media/platform/video-mux.c
  create mode 100644 drivers/staging/media/imx/Kconfig
  create mode 100644 drivers/staging/media/imx/Makefile
  create mode 100644 drivers/staging/media/imx/TODO
  create mode 100644 drivers/staging/media/imx/imx-ic-common.c
  create mode 100644 drivers/staging/media/imx/imx-ic-prp.c
  create mode 100644 drivers/staging/media/imx/imx-ic-prpencvf.c
  create mode 100644 drivers/staging/media/imx/imx-ic.h
  create mode 100644 drivers/staging/media/imx/imx-media-capture.c
  create mode 100644 drivers/staging/media/imx/imx-media-csi.c
  create mode 100644 drivers/staging/media/imx/imx-media-dev.c
  create mode 100644 drivers/staging/media/imx/imx-media-fim.c
  create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
  create mode 100644 drivers/staging/media/imx/imx-media-of.c
  create mode 100644 drivers/staging/media/imx/imx-media-utils.c
  create mode 100644 drivers/staging/media/imx/imx-media-vdic.c
  create mode 100644 drivers/staging/media/imx/imx-media.h
  create mode 100644 drivers/staging/media/imx/imx6-mipi-csi2.c
  create mode 100644 include/linux/imx-media.h
  create mode 100644 include/media/imx.h
