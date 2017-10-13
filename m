Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35516 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751339AbdJMWXs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 18:23:48 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 81BF7600EE
        for <linux-media@vger.kernel.org>; Sat, 14 Oct 2017 01:23:46 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e38Mr-00031i-UO
        for linux-media@vger.kernel.org; Sat, 14 Oct 2017 01:23:46 +0300
Date: Sat, 14 Oct 2017 01:23:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] More sensor driver patches
Message-ID: <20171013222345.x33ft5s7qspolf3k@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the second set of sensor driver patches for 4.15.

Please pull.


The following changes since commit 8382e556b1a2f30c4bf866f021b33577a64f9ebf:

  Simplify major/minor non-dynamic logic (2017-10-11 15:32:11 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-2

for you to fetch changes up to 5164fc93c2d8c2e9a2de1461bfba9d6b2911ce9e:

  imx274: V4l2 driver for Sony imx274 CMOS sensor (2017-10-14 01:06:10 +0300)

----------------------------------------------------------------
Leon Luo (2):
      imx274: device tree binding file
      imx274: V4l2 driver for Sony imx274 CMOS sensor

 .../devicetree/bindings/media/i2c/imx274.txt       |   33 +
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/imx274.c                         | 1811 ++++++++++++++++++++
 4 files changed, 1853 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imx274.txt
 create mode 100644 drivers/media/i2c/imx274.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
