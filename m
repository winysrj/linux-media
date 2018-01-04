Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60262 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752544AbeADKWl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 05:22:41 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 6E724600E6
        for <linux-media@vger.kernel.org>; Thu,  4 Jan 2018 12:22:40 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eX2fY-0004H8-1m
        for linux-media@vger.kernel.org; Thu, 04 Jan 2018 12:22:40 +0200
Date: Thu, 4 Jan 2018 12:22:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.16] More sensor driver patches
Message-ID: <20180104102239.ehd6cr7b4toa55ok@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the regular stash of sensor driver patches.

Please pull.


The following changes since commit d0c8f6ad8b381dd572576ac50b9696d4d31142bb:

  media: imx: fix breakages when compiling for arm (2017-12-29 14:55:41 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.16-2

for you to fetch changes up to 218f72b841c3fa3f08f99a55f246acef75ab2b43:

  media: ov5640: add support of RGB565 and YUYV formats (2018-01-03 22:19:17 +0200)

----------------------------------------------------------------
Akinobu Mita (4):
      media: mt9m111: create subdevice device node
      media: mt9m111: add media controller support
      media: mt9m111: document missing required clocks property
      media: mt9m111: add V4L2_CID_TEST_PATTERN control

Dan Carpenter (1):
      media: imx274: Silence uninitialized variable warning

Hugues Fruchet (5):
      media: ov5640: switch to gpiod_set_value_cansleep()
      media: ov5640: check chip id
      media: dt-bindings: ov5640: refine CSI-2 and add parallel interface
      media: ov5640: add support of DVP parallel interface
      media: ov5640: add support of RGB565 and YUYV formats

Wenyou Yang (2):
      media: ov7740: Document device tree bindings
      media: i2c: Add the ov7740 image sensor driver

 .../devicetree/bindings/media/i2c/mt9m111.txt      |    4 +
 .../devicetree/bindings/media/i2c/ov5640.txt       |   46 +-
 .../devicetree/bindings/media/i2c/ov7740.txt       |   47 +
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/imx274.c                         |    2 +-
 drivers/media/i2c/mt9m111.c                        |   51 +-
 drivers/media/i2c/ov5640.c                         |  325 +++++-
 drivers/media/i2c/ov7740.c                         | 1216 ++++++++++++++++++++
 10 files changed, 1658 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7740.txt
 create mode 100644 drivers/media/i2c/ov7740.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
