Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52528 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753652AbeBSUgF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 15:36:05 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 78E20600C7
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 22:36:03 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ensAN-0004KB-2e
        for linux-media@vger.kernel.org; Mon, 19 Feb 2018 22:36:03 +0200
Date: Mon, 19 Feb 2018 22:36:02 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 for 4.17] Sensor and lens driver patches
Message-ID: <20180219203602.cnvm7pudb35minmn@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the first pile of sensor and lens driver patches for 4.17.

The most noteworthy parts are perhaps

- moving unmaintained imx074 and mt9t031 SoC camera drivers to staging in
  hope someone would start looking after them,

- add DT bindings and driver upport for the bindings for ov9650, ov7670,
  ov5695 and ov2685 sensors and

- JPEG support for ov5640.

The rest are related or random fixes.

since v1:

- Select V4L2_FWNODE for ov7670

Please pull.


The following changes since commit 29422737017b866d4a51014cc7522fa3a99e8852:

  media: rc: get start time just before calling driver tx (2018-02-14 14:17:21 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.17-1

for you to fetch changes up to 4c2de036e83693d29e21b945f0ae9f6f697fa478:

  media: ov5640: fix framerate update (2018-02-19 13:02:13 +0200)

----------------------------------------------------------------
Akinobu Mita (3):
      media: MAINTAINERS: add entry for ov9650 driver
      media: ov9650: add device tree binding
      media: ov9650: support device tree probing

Chiranjeevi Rapolu (1):
      media: ov13858: Avoid possible null first frame

Gustavo A. R. Silva (2):
      ov13858: Use false for boolean value
      i2c: ov9650: fix potential integer overflow in __ov965x_set_frame_interval

Hans Verkuil (2):
      imx074: deprecate, move to staging
      mt9t031: deprecate, move to staging

Hugues Fruchet (5):
      media: ov5640: add JPEG support
      media: ov5640: add error trace in case of i2c read failure
      media: ov5640: various typo & style fixes
      media: ov5640: fix virtual_channel parameter permissions
      media: ov5640: fix framerate update

Jacopo Mondi (2):
      media: dt-bindings: Add OF properties to ov7670
      v4l2: i2c: ov7670: Implement OF mbus configuration

Sakari Ailus (1):
      ov2685: Assign ret in default case in s_ctrl callback

Shunqian Zheng (4):
      dt-bindings: media: Add bindings for OV5695
      media: ov5695: add support for OV5695 sensor
      dt-bindings: media: Add bindings for OV2685
      media: ov2685: add support for OV2685 sensor

 .../devicetree/bindings/media/i2c/ov2685.txt       |   41 +
 .../devicetree/bindings/media/i2c/ov5695.txt       |   41 +
 .../devicetree/bindings/media/i2c/ov7670.txt       |   16 +-
 .../devicetree/bindings/media/i2c/ov9650.txt       |   36 +
 MAINTAINERS                                        |   24 +
 drivers/media/i2c/Kconfig                          |   23 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ov13858.c                        |    6 +-
 drivers/media/i2c/ov2685.c                         |  846 ++++++++++++
 drivers/media/i2c/ov5640.c                         |   99 +-
 drivers/media/i2c/ov5695.c                         | 1399 ++++++++++++++++++++
 drivers/media/i2c/ov7670.c                         |   98 +-
 drivers/media/i2c/ov9650.c                         |  134 +-
 drivers/media/i2c/soc_camera/Kconfig               |   12 -
 drivers/media/i2c/soc_camera/Makefile              |    2 -
 drivers/staging/media/Kconfig                      |    4 +
 drivers/staging/media/Makefile                     |    2 +
 drivers/staging/media/imx074/Kconfig               |    5 +
 drivers/staging/media/imx074/Makefile              |    1 +
 drivers/staging/media/imx074/TODO                  |    5 +
 .../soc_camera => staging/media/imx074}/imx074.c   |    0
 drivers/staging/media/mt9t031/Kconfig              |   11 +
 drivers/staging/media/mt9t031/Makefile             |    1 +
 drivers/staging/media/mt9t031/TODO                 |    5 +
 .../soc_camera => staging/media/mt9t031}/mt9t031.c |    0
 25 files changed, 2718 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2685.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5695.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt
 create mode 100644 drivers/media/i2c/ov2685.c
 create mode 100644 drivers/media/i2c/ov5695.c
 create mode 100644 drivers/staging/media/imx074/Kconfig
 create mode 100644 drivers/staging/media/imx074/Makefile
 create mode 100644 drivers/staging/media/imx074/TODO
 rename drivers/{media/i2c/soc_camera => staging/media/imx074}/imx074.c (100%)
 create mode 100644 drivers/staging/media/mt9t031/Kconfig
 create mode 100644 drivers/staging/media/mt9t031/Makefile
 create mode 100644 drivers/staging/media/mt9t031/TODO
 rename drivers/{media/i2c/soc_camera => staging/media/mt9t031}/mt9t031.c (100%)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
