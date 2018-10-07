Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34978 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726207AbeJGUNJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 Oct 2018 16:13:09 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id CF06B634C8F
        for <linux-media@vger.kernel.org>; Sun,  7 Oct 2018 16:05:57 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1g98kv-0001Ch-Ia
        for linux-media@vger.kernel.org; Sun, 07 Oct 2018 16:05:57 +0300
Date: Sun, 7 Oct 2018 16:05:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Lens driver fixes, imx214 sensor driver
Message-ID: <20181007130557.dfjrfvv2tip2inpr@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This last pull for 4.20 contains dw9714 and dw9807 lens driver probe error
handling fixes and the Sony imx214 sensor driver. In other words, patches
that have roughly nil changes of breaking something.

Compile tested with and without both subdev uAPI and MC on x86-64, plus on
arm as well.

Please pull.


The following changes since commit 557c97b5133669297be561e6091da9ab6e488e65:

  media: cec: name for RC passthrough device does not need 'RC for' (2018-10-05 11:28:13 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-11-sign

for you to fetch changes up to a8f772a119afcc1dfabf4d8b7e258b9f90d2c561:

  imx214: Add imx214 camera sensor driver (2018-10-06 21:20:40 +0300)

----------------------------------------------------------------
dw9714 and dw9807 fixes; imx214 driver

----------------------------------------------------------------
Rajmohan Mani (1):
      media: dw9714: Fix error handling in probe function

Ricardo Ribalda Delgado (2):
      imx214: device tree binding
      imx214: Add imx214 camera sensor driver

Sakari Ailus (2):
      dw9714: Remove useless error message
      dw9807-vcm: Fix probe error handling

 .../devicetree/bindings/media/i2c/sony,imx214.txt  |   53 +
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |   12 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/dw9714.c                         |    5 +-
 drivers/media/i2c/dw9807-vcm.c                     |    3 +-
 drivers/media/i2c/imx214.c                         | 1118 ++++++++++++++++++++
 7 files changed, 1197 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/sony,imx214.txt
 create mode 100644 drivers/media/i2c/imx214.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
