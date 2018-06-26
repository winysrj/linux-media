Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42446 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935854AbeFZO0V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 10:26:21 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 71A7C634C7E
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2018 17:26:19 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fXovD-0000rn-6p
        for linux-media@vger.kernel.org; Tue, 26 Jun 2018 17:26:19 +0300
Date: Tue, 26 Jun 2018 17:26:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 for 4.19] Sensor, lens and ISP driver patches
Message-ID: <20180626142618.5xdvhs7bibtiskcm@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the usual bunch of sensor, lens and ISP driver patches. In
particular, there are new drivers for ov2680 sensor and dw9807 VCM lens
controller part.

Since v1, I took out Arnd's Cadence patches since they need to go to the
fixes branch instead (see:
<URL:https://patchwork.linuxtv.org/patch/50464/>), as well as the ov2680
driver for addressing compile issues.

There are also a few additional patches for making the
v4l2_find_nearest_size sparse-friendly and ov5640 improvements.

Please pull.


The following changes since commit f2809d20b9250c675fca8268a0f6274277cca7ff:

  media: omap2: fix compile-testing with FB_OMAP2=m (2018-06-05 09:56:56 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.19-1.1

for you to fetch changes up to eba3bcf150fb59461e9ebe1c16c233680e1334bf:

  media: ov5640: fix frame interval enumeration (2018-06-26 17:07:02 +0300)

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

Arnd Bergmann (1):
      media: omap3isp: fix warning for !CONFIG_PM

Hugues Fruchet (1):
      media: ov5640: fix frame interval enumeration

Javier Martinez Canillas (1):
      media: omap3isp: zero-initialize the isp cam_xclk{a,b} initial data

Philipp Puschmann (1):
      media: ov5640: adjust xclk_max

Sakari Ailus (1):
      v4l-common: Make v4l2_find_nearest_size more sparse-friendly

Yong Zhi (1):
      MAINTAINERS: Update entry for Intel IPU3 cio2 driver

 .../bindings/media/i2c/dongwoon,dw9807.txt         |   9 +
 MAINTAINERS                                        |  10 +
 arch/sh/boards/mach-migor/setup.c                  |   7 +-
 drivers/media/i2c/Kconfig                          |  10 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/dw9807.c                         | 329 +++++++++++++++++++
 drivers/media/i2c/ov5640.c                         |  36 +--
 drivers/media/i2c/ov772x.c                         | 353 +++++++++++++++------
 drivers/media/i2c/soc_camera/ov772x.c              |   2 +-
 drivers/media/platform/omap3isp/isp.c              |   6 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   2 +
 include/media/v4l2-common.h                        |   2 +-
 12 files changed, 647 insertions(+), 120 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
 create mode 100644 drivers/media/i2c/dw9807.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
