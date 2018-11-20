Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34134 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726569AbeKTVBz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 16:01:55 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 894D9634C89
        for <linux-media@vger.kernel.org>; Tue, 20 Nov 2018 12:33:27 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gP3LT-0000uT-Ag
        for linux-media@vger.kernel.org; Tue, 20 Nov 2018 12:33:27 +0200
Date: Tue, 20 Nov 2018 12:33:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.21] Sensor and CSI driver patches
Message-ID: <20181120103327.dlakju3vybccpe55@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a bunch of sensor driver improvements as well as a driver for the
Allwinner CSI parallel bridge. Finally, a small uAPI documentation fix to
better document the metadata capture buffers.

Please pull.


The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.21-2-sign

for you to fetch changes up to 76bdfdc1cf59b13a204ff18d57549f635956050e:

  media: V3s: Add support for Allwinner CSI. (2018-11-20 12:31:04 +0200)

----------------------------------------------------------------
sensor + CSI patches for 4.21

----------------------------------------------------------------
Akinobu Mita (7):
      media: mt9m111: support log_status ioctl and event interface
      media: mt9m111: add V4L2_CID_COLORFX control
      media: ov2640: add V4L2_CID_TEST_PATTERN control
      media: ov2640: support log_status ioctl and event interface
      media: ov5640: support log_status ioctl and event interface
      media: ov7670: support log_status ioctl and event interface
      media: ov772x: support log_status ioctl and event interface

Chen, JasonX Z (1):
      media: imx258: remove test pattern map from driver

Nathan Chancellor (1):
      media: imx214: Remove unnecessary self assignment in for loop

Sakari Ailus (1):
      v4l: uAPI doc: Simplify NATIVE_SIZE selection target documentation

Yong Deng (2):
      dt-bindings: media: Add Allwinner V3s Camera Sensor Interface (CSI)
      media: V3s: Add support for Allwinner CSI.

 .../devicetree/bindings/media/sun6i-csi.txt        |  56 ++
 .../media/uapi/v4l/v4l2-selection-targets.rst      |   7 +-
 MAINTAINERS                                        |   8 +
 drivers/media/i2c/imx214.c                         |   2 +-
 drivers/media/i2c/imx258.c                         |  22 +-
 drivers/media/i2c/mt9m111.c                        |  44 +-
 drivers/media/i2c/ov2640.c                         |  21 +-
 drivers/media/i2c/ov5640.c                         |   7 +-
 drivers/media/i2c/ov7670.c                         |   6 +-
 drivers/media/i2c/ov772x.c                         |   7 +-
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/sunxi/sun6i-csi/Kconfig     |   9 +
 drivers/media/platform/sunxi/sun6i-csi/Makefile    |   3 +
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 912 +++++++++++++++++++++
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h | 135 +++
 .../media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h | 196 +++++
 .../media/platform/sunxi/sun6i-csi/sun6i_video.c   | 678 +++++++++++++++
 .../media/platform/sunxi/sun6i-csi/sun6i_video.h   |  38 +
 19 files changed, 2121 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Kconfig
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Makefile
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
