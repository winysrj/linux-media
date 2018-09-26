Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52924 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726638AbeIZOSA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 10:18:00 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id ED9FF634C7E
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2018 11:06:17 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1g54pt-0001Db-P1
        for linux-media@vger.kernel.org; Wed, 26 Sep 2018 11:06:17 +0300
Date: Wed, 26 Sep 2018 11:06:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] More fixes and cleanups for 4.20
Message-ID: <20180926080617.xbk5ctvzv4rzbm4o@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a few cleanups and fixes for 4.20. Sensor drivers as well as
sub-device crop target alignment with API documentation.

Please pull.


The following changes since commit 985cdcb08a0488558d1005139596b64d73bee267:

  media: ov5640: fix restore of last mode set (2018-09-17 15:33:38 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-7-sign

for you to fetch changes up to e5b39730005e5f6fd3346b6d27d55e9f57e35212:

  media: smiapp: Remove unused loop (2018-09-26 10:20:43 +0300)

----------------------------------------------------------------
no crop bounds on subdevs, ov5640 fix...

----------------------------------------------------------------
Hugues Fruchet (1):
      media: ov5640: use JPEG mode 3 for 720p

Ricardo Ribalda Delgado (1):
      media: smiapp: Remove unused loop

Sakari Ailus (2):
      v4l: i2c: Add a comment not to use static sub-device names in the future
      v4l: Remove support for crop default target in subdev drivers

 drivers/media/i2c/ak881x.c                         | 1 -
 drivers/media/i2c/m5mols/m5mols_core.c             | 1 +
 drivers/media/i2c/mt9m111.c                        | 1 -
 drivers/media/i2c/mt9t112.c                        | 6 ------
 drivers/media/i2c/noon010pc30.c                    | 1 +
 drivers/media/i2c/ov2640.c                         | 1 -
 drivers/media/i2c/ov5640.c                         | 2 +-
 drivers/media/i2c/ov6650.c                         | 1 -
 drivers/media/i2c/ov772x.c                         | 1 -
 drivers/media/i2c/rj54n1cb0c.c                     | 1 -
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 1 +
 drivers/media/i2c/s5k4ecgx.c                       | 1 +
 drivers/media/i2c/s5k6aa.c                         | 1 +
 drivers/media/i2c/smiapp/smiapp-core.c             | 4 +---
 drivers/media/i2c/soc_camera/mt9m001.c             | 1 -
 drivers/media/i2c/soc_camera/mt9t112.c             | 6 ------
 drivers/media/i2c/soc_camera/mt9v022.c             | 1 -
 drivers/media/i2c/soc_camera/ov5642.c              | 1 -
 drivers/media/i2c/soc_camera/ov772x.c              | 1 -
 drivers/media/i2c/soc_camera/ov9640.c              | 1 -
 drivers/media/i2c/soc_camera/ov9740.c              | 1 -
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          | 1 -
 drivers/media/i2c/tvp5150.c                        | 1 -
 drivers/media/platform/soc_camera/soc_scale_crop.c | 2 +-
 drivers/staging/media/imx074/imx074.c              | 1 -
 drivers/staging/media/mt9t031/mt9t031.c            | 1 -
 26 files changed, 8 insertions(+), 33 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
