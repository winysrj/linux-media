Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37836 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752086AbeEGMcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:32:24 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id EFE98634C50
        for <linux-media@vger.kernel.org>; Mon,  7 May 2018 15:32:22 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fFfJW-0003gi-O6
        for linux-media@vger.kernel.org; Mon, 07 May 2018 15:32:22 +0300
Date: Mon, 7 May 2018 15:32:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.18] Sensor driver patches
Message-ID: <20180507123222.5h5a6bp6reetdtdh@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a regular bunch of sensor and lens driver patches for 4.18. Fixes,
cleanups and preparation for new functionality (imx274 and ov5640) as well
as DT bindings and a new driver for ov7251 and imx258 camera sensors and
dw9807 voice coil.

Please pull.


The following changes since commit f10379aad39e9da8bc7d1822e251b5f0673067ef:

  media: include/video/omapfb_dss.h: use IS_ENABLED() (2018-05-05 11:45:51 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.18-3

for you to fetch changes up to 67f76c65e94ff3923e184870a37bd52e6a02d7af:

  media: imx258: Add imx258 camera sensor driver (2018-05-07 13:22:26 +0300)

----------------------------------------------------------------
Akinobu Mita (2):
      media: ov2640: make set_fmt() work in power-down mode
      media: ov2640: make s_ctrl() work in power-down mode

Alan Chiang (2):
      media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil
      media: dw9807: Add dw9807 vcm driver

Colin Ian King (1):
      media: smiapp: fix timeout checking in smiapp_read_nvm

Jason Chen (1):
      media: imx258: Add imx258 camera sensor driver

Luca Ceresoli (6):
      media: imx274: document reset delays more clearly
      media: imx274: fix typo in comment
      media: imx274: slightly simplify code
      media: imx274: remove unused data from struct imx274_frmfmt
      media: imx274: rename and reorder register address definitions
      media: imx274: remove non-indexed pointers from mode_table

Maxime Ripard (5):
      media: ov5640: Don't force the auto exposure state at start time
      media: ov5640: Init properly the SCLK dividers
      media: ov5640: Change horizontal and vertical resolutions name
      media: ov5640: Add horizontal and vertical totals
      media: ov5640: Program the visible resolution

Mylène Josserand (1):
      media: ov5640: Add light frequency control

Sakari Ailus (1):
      ov5640: Use dev_fwnode() to obtain device's fwnode

Todor Tomov (3):
      media: ov5645: Fix write_reg return code
      dt-bindings: media: Binding document for OV7251 camera sensor
      media: Add a driver for the ov7251 camera sensor

 .../bindings/media/i2c/dongwoon,dw9807.txt         |    9 +
 .../devicetree/bindings/media/i2c/ov7251.txt       |   52 +
 MAINTAINERS                                        |   14 +
 drivers/media/i2c/Kconfig                          |   33 +
 drivers/media/i2c/Makefile                         |    3 +
 drivers/media/i2c/dw9807.c                         |  329 +++++
 drivers/media/i2c/imx258.c                         | 1320 +++++++++++++++++
 drivers/media/i2c/imx274.c                         |   74 +-
 drivers/media/i2c/ov2640.c                         |  112 +-
 drivers/media/i2c/ov5640.c                         |  257 ++--
 drivers/media/i2c/ov5645.c                         |    6 +-
 drivers/media/i2c/ov7251.c                         | 1503 ++++++++++++++++++++
 drivers/media/i2c/smiapp/smiapp-core.c             |   11 +-
 13 files changed, 3543 insertions(+), 180 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7251.txt
 create mode 100644 drivers/media/i2c/dw9807.c
 create mode 100644 drivers/media/i2c/imx258.c
 create mode 100644 drivers/media/i2c/ov7251.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
