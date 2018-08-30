Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60588 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728506AbeH3PR7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 11:17:59 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 0D677634C7D
        for <linux-media@vger.kernel.org>; Thu, 30 Aug 2018 14:16:20 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fvKvz-0000wv-Qc
        for linux-media@vger.kernel.org; Thu, 30 Aug 2018 14:16:19 +0300
Date: Thu, 30 Aug 2018 14:16:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Sensor and Intel CIO2 driver cleanups, fixes
Message-ID: <20180830111619.d2xtfith2apl4d2i@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a few cleanups and fixes for sensor and Intel CIO2 CSI-2 receiver
drivers.

Please pull.


The following changes since commit 3799eca51c5be3cd76047a582ac52087373b54b3:

  media: camss: add missing includes (2018-08-29 14:02:06 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.20-1

for you to fetch changes up to 4d99425e4b2a34e00a4d79ed5526524548288568:

  media: ov5640: fix mode change regression (2018-08-30 14:14:20 +0300)

----------------------------------------------------------------
Akinobu Mita (2):
      media: ov772x: use SCCB regmap
      media: ov9650: use SCCB regmap

Alexey Khoroshilov (1):
      media: ov772x: Disable clk on error path

Hugues Fruchet (1):
      media: ov5640: fix mode change regression

Sakari Ailus (2):
      ov5670, ov13858: Use pm_runtime_idle
      i2c: Fix pm_runtime_get_if_in_use() usage in sensor drivers

zhong jiang (1):
      media: ipu3-cio2: Use dma_zalloc_coherent to replace dma_alloc_coherent + memset

 drivers/media/i2c/Kconfig                |   2 +
 drivers/media/i2c/ov13858.c              |  12 +-
 drivers/media/i2c/ov2685.c               |   2 +-
 drivers/media/i2c/ov5640.c               |  21 +++-
 drivers/media/i2c/ov5670.c               |  12 +-
 drivers/media/i2c/ov5695.c               |   2 +-
 drivers/media/i2c/ov772x.c               | 193 +++++++++++++------------------
 drivers/media/i2c/ov7740.c               |   2 +-
 drivers/media/i2c/ov9650.c               | 157 ++++++++++++-------------
 drivers/media/pci/intel/ipu3/ipu3-cio2.c |   6 +-
 10 files changed, 184 insertions(+), 225 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
