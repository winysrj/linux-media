Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53014 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729728AbeKFVFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 16:05:42 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id AC704634C83
        for <linux-media@vger.kernel.org>; Tue,  6 Nov 2018 13:40:53 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gJzj3-0002K2-Fs
        for linux-media@vger.kernel.org; Tue, 06 Nov 2018 13:40:53 +0200
Date: Tue, 6 Nov 2018 13:40:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Sensor and ISP driver patches for 4.21
Message-ID: <20181106114053.5i4e25dkfjnroqpg@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a few sensor and ISP driver patches for 4.21, plus a documentation
fix. The noteworthy change in the sea of bugfixes is the imx214 driver.

Please pull.


The following changes since commit dafb7f9aef2fd44991ff1691721ff765a23be27b:

  v4l2-controls: add a missing include (2018-11-02 06:36:32 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.21-1-sign

for you to fetch changes up to aaa886f8404b6ae39aad984c8b826c092ebe0092:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 13:33:19 +0200)

----------------------------------------------------------------
Patches or 4.21

----------------------------------------------------------------
Chiranjeevi Rapolu (1):
      media: ov13858: Check for possible null pointer

Julia Lawall (2):
      media: ov5645: constify v4l2_ctrl_ops structure
      media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure

Rajmohan Mani (1):
      media: intel-ipu3: cio2: Remove redundant definitions

Ricardo Ribalda Delgado (2):
      imx214: device tree binding
      imx214: Add imx214 camera sensor driver

Sakari Ailus (4):
      media: docs: Document metadata format in struct v4l2_format
      omap3isp: Unregister media device as first
      ipu3-cio2: Unregister device nodes first, then release resources
      ipu3-cio2: Use cio2_queues_exit

 .../devicetree/bindings/media/i2c/sony,imx214.txt  |   53 +
 Documentation/media/uapi/v4l/dev-meta.rst          |    2 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |    5 +
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |   12 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/imx214.c                         | 1118 ++++++++++++++++++++
 drivers/media/i2c/ov13858.c                        |    6 +-
 drivers/media/i2c/ov5645.c                         |    2 +-
 drivers/media/i2c/ov7740.c                         |    4 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |    6 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |    2 -
 drivers/media/platform/omap3isp/isp.c              |    3 +-
 13 files changed, 1209 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/sony,imx214.txt
 create mode 100644 drivers/media/i2c/imx214.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
