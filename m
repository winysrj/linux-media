Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41794 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751002AbeEVKl5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 06:41:57 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 11FB3634C85
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 13:41:56 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fL4jr-0001ZE-T1
        for linux-media@vger.kernel.org; Tue, 22 May 2018 13:41:55 +0300
Date: Tue, 22 May 2018 13:41:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.18] More sensor driver patches
Message-ID: <20180522104155.nfk5zwnghia43eci@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's another set of sensro driver patches for 4.18. There's DT support
for the ov772x sensors as well as a new driver for imx258.

Please pull.


The following changes since commit 8ed8bba70b4355b1ba029b151ade84475dd12991:

  media: imx274: remove non-indexed pointers from mode_table (2018-05-17 06:22:08 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.18-5

for you to fetch changes up to 3c42c667c9bf0857a25d829d4535db605de685ab:

  media: ov772x: create subdevice device node (2018-05-21 17:51:09 +0300)

----------------------------------------------------------------
Akinobu Mita (14):
      media: dt-bindings: ov772x: add device tree binding
      media: ov772x: correct setting of banding filter
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

Jason Chen (1):
      media: imx258: Add imx258 camera sensor driver

 .../devicetree/bindings/media/i2c/ov772x.txt       |   40 +
 MAINTAINERS                                        |    8 +
 arch/sh/boards/mach-migor/setup.c                  |    7 +-
 drivers/media/i2c/Kconfig                          |   11 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/imx258.c                         | 1320 ++++++++++++++++++++
 drivers/media/i2c/ov772x.c                         |  355 ++++--
 7 files changed, 1645 insertions(+), 97 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt
 create mode 100644 drivers/media/i2c/imx258.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
