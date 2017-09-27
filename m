Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33395
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752352AbdI0VrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 00/17] V4L cleanups and documentation improvements
Date: Wed, 27 Sep 2017 18:46:43 -0300
Message-Id: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is meant to improve V4L documentation. It touches
some files at the tree doing some cleanup, in order to simplify
the source code.

Mauro Carvalho Chehab (17):
  media: tuner-types: add kernel-doc markups for struct tunertype
  media: v4l2-common: get rid of v4l2_routing dead struct
  media: v4l2-common: get rid of struct v4l2_discrete_probe
  media: v4l2-common.h: document ancillary functions
  media: v4l2-device.h: document ancillary macros
  media: v4l2-dv-timings.h: convert comment into kernel-doc markup
  media: v4l2-event.rst: improve events description
  media: v4l2-ioctl.h: convert debug macros into enum and document
  media: cec-pin.h: convert comments for cec_pin_state into kernel-doc
  media: rc-core.rst: add an introduction for RC core
  media: rc-core.h: minor adjustments at rc_driver_type doc
  media: v4l2-fwnode.h: better describe bus union at fwnode endpoint
    struct
  media: v4l2-async: simplify v4l2_async_subdev structure
  media: v4l2-async: better describe match union at async match struct
  media: v4l2-ctrls: document nested members of structs
  media: videobuf2-core: improve kernel-doc markups
  media: media-entity.h: add kernel-doc markups for nested structs

 Documentation/media/kapi/rc-core.rst           |  77 ++++++++
 Documentation/media/kapi/v4l2-event.rst        |  64 +++++--
 drivers/media/platform/am437x/am437x-vpfe.c    |   6 +-
 drivers/media/platform/atmel/atmel-isc.c       |   2 +-
 drivers/media/platform/atmel/atmel-isi.c       |   2 +-
 drivers/media/platform/davinci/vpif_capture.c  |   4 +-
 drivers/media/platform/exynos4-is/media-dev.c  |   4 +-
 drivers/media/platform/omap3isp/isp.c          |   4 +-
 drivers/media/platform/pxa_camera.c            |   2 +-
 drivers/media/platform/qcom/camss-8x16/camss.c |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c    |   8 +-
 drivers/media/platform/rcar_drif.c             |   4 +-
 drivers/media/platform/soc_camera/soc_camera.c |   2 +-
 drivers/media/platform/stm32/stm32-dcmi.c      |   2 +-
 drivers/media/platform/ti-vpe/cal.c            |   2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c   |   9 +-
 drivers/media/platform/xilinx/xilinx-vipp.c    |   2 +-
 drivers/media/v4l2-core/v4l2-async.c           |   4 +-
 drivers/media/v4l2-core/v4l2-common.c          |  27 +--
 drivers/staging/media/imx/imx-media-dev.c      |   8 +-
 include/media/cec-pin.h                        |  81 ++++++---
 include/media/media-entity.h                   |   5 +
 include/media/rc-core.h                        |   4 +-
 include/media/tuner-types.h                    |  15 ++
 include/media/v4l2-async.h                     |  43 ++++-
 include/media/v4l2-common.h                    | 130 +++++++++++---
 include/media/v4l2-ctrls.h                     |  11 +-
 include/media/v4l2-device.h                    | 238 +++++++++++++++++++++----
 include/media/v4l2-dv-timings.h                |  14 +-
 include/media/v4l2-event.h                     |  34 ----
 include/media/v4l2-fwnode.h                    |  13 +-
 include/media/v4l2-ioctl.h                     |  33 ++--
 include/media/videobuf2-core.h                 |  59 +++---
 33 files changed, 660 insertions(+), 255 deletions(-)

-- 
2.13.5
