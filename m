Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44380 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729675AbeGQVpG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 17:45:06 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id D7805634C83
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2018 00:10:35 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ffXEx-0007YM-Lw
        for linux-media@vger.kernel.org; Wed, 18 Jul 2018 00:10:35 +0300
Date: Wed, 18 Jul 2018 00:10:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.19] More sensor and rcar-vin driver patches
Message-ID: <20180717211035.5j5birzh5bg6o4m4@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's another bunch of sensor and rcar-vin driver patches for 4.19. Apart
from the driver- and device-only patches, there's a definition of the
data-enable-active property in video-interfaces.txt as well as a patch that
replaces "sensor-level" in Kconfig documentation by "sensor" in sensor
driver descriptions.

Please pull.


The following changes since commit 39fbb88165b2bbbc77ea7acab5f10632a31526e6:

  media: bpf: ensure bpf program is freed on detach (2018-07-13 11:07:29 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.19-3

for you to fetch changes up to 291af76ffa482649dcce77f4aeac139cb806ab0b:

  v4l: i2c: Replace "sensor-level" by "sensor" (2018-07-17 17:27:40 +0300)

----------------------------------------------------------------
Hugues Fruchet (1):
      media: ov5640: do not change mode if format or frame interval is unchanged

Jacopo Mondi (7):
      dt-bindings: media: rcar-vin: Align Gen2 and Gen3
      dt-bindings: media: rcar-vin: Describe optional ep properties
      dt-bindings: media: Document data-enable-active property
      media: v4l2-fwnode: parse 'data-enable-active' prop
      dt-bindings: media: rcar-vin: Add 'data-enable-active'
      media: rcar-vin: Handle data-enable polarity
      media: i2c: ov7670: Put ep fwnode after use

Luca Ceresoli (1):
      media: smiapp: fix debug message

Sakari Ailus (2):
      smiapp: Set correct MODULE_LICENSE
      v4l: i2c: Replace "sensor-level" by "sensor"

Todor Tomov (1):
      media: ov5645: Supported external clock is 24MHz

 .../devicetree/bindings/media/rcar_vin.txt         | 29 ++++++++--
 .../devicetree/bindings/media/video-interfaces.txt |  2 +
 drivers/media/i2c/Kconfig                          | 62 +++++++++++-----------
 drivers/media/i2c/ov5640.c                         | 14 +++--
 drivers/media/i2c/ov5645.c                         | 13 ++---
 drivers/media/i2c/ov7670.c                         |  6 +--
 drivers/media/i2c/smiapp/smiapp-core.c             |  4 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |  5 ++
 drivers/media/v4l2-core/v4l2-fwnode.c              |  4 ++
 include/media/v4l2-mediabus.h                      |  2 +
 10 files changed, 89 insertions(+), 52 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
