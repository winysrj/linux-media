Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48530 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932516AbeFKMvR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 08:51:17 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 06824634C83
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2018 15:51:16 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fSMHz-0001OC-Oz
        for linux-media@vger.kernel.org; Mon, 11 Jun 2018 15:51:15 +0300
Date: Mon, 11 Jun 2018 15:51:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.19] Sensor, lens and ISP driver patches
Message-ID: <20180611125115.zevzd73vurbimqsm@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the usual bunch of sensor, lens and ISP driver patches. In
particular, there are new drivers for ov2680 sensor and dw9807 VCM lens
controller part.

Please pull.


The following changes since commit f2809d20b9250c675fca8268a0f6274277cca7ff:

  media: omap2: fix compile-testing with FB_OMAP2=m (2018-06-05 09:56:56 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.19-1

for you to fetch changes up to 4fdefee7567a2e1f6ae09ca3e184851062bc3fa5:

  media: soc_camera: ov772x: correct setting of banding filter (2018-06-11 15:45:57 +0300)

----------------------------------------------------------------
Akinobu Mita (14):
      media: ov772x: allow i2c controllers without I2C_FUNC_PROTOCOL_MANGLING
      media: ov772x: add checks for register read errors
      media: ov772x: add media controller support
      media: ov772x: use generic names for reset and powerdown gpios
      media: ov772x: omit consumer ID when getting clock reference
      media: ov772x: support device tree probing
      media: ov772x: handle nested s_power() calls
      media: ov772x: reconstruct s_frame_interval()
      media: ov772x: use v4l2_ctrl to get current control value
      media: ov772x: avoid accessing registers under power saving mode
      media: ov772x: make set_fmt() and s_frame_interval() return -EBUSY while streaming
      media: ov772x: create subdevice device node
      media: s3c-camif: ignore -ENOIOCTLCMD from v4l2_subdev_call for s_power
      media: soc_camera: ov772x: correct setting of banding filter

Alan Chiang (2):
      media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil
      media: dw9807: Add dw9807 vcm driver

Arnd Bergmann (3):
      media: omap3isp: fix warning for !CONFIG_PM
      media: v4l: cadence: include linux/slab.h
      media: v4l: cadence: add VIDEO_V4L2 dependency

Javier Martinez Canillas (1):
      media: omap3isp: zero-initialize the isp cam_xclk{a,b} initial data

Rui Miguel Silva (2):
      media: ov2680: dt: Add bindings for OV2680
      media: ov2680: Add Omnivision OV2680 sensor driver

Yong Zhi (1):
      MAINTAINERS: Update entry for Intel IPU3 cio2 driver

 .../bindings/media/i2c/dongwoon,dw9807.txt         |    9 +
 .../devicetree/bindings/media/i2c/ov2680.txt       |   46 +
 MAINTAINERS                                        |   10 +
 arch/sh/boards/mach-migor/setup.c                  |    7 +-
 drivers/media/i2c/Kconfig                          |   22 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/dw9807.c                         |  329 ++++++
 drivers/media/i2c/ov2680.c                         | 1169 ++++++++++++++++++++
 drivers/media/i2c/ov772x.c                         |  353 ++++--
 drivers/media/i2c/soc_camera/ov772x.c              |    2 +-
 drivers/media/platform/cadence/Kconfig             |    2 +
 drivers/media/platform/cadence/cdns-csi2rx.c       |    1 +
 drivers/media/platform/cadence/cdns-csi2tx.c       |    1 +
 drivers/media/platform/omap3isp/isp.c              |    6 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    2 +
 15 files changed, 1861 insertions(+), 100 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt
 create mode 100644 drivers/media/i2c/dw9807.c
 create mode 100644 drivers/media/i2c/ov2680.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
