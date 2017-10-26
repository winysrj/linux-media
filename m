Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40366 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751009AbdJZJAp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 05:00:45 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 55905600E1
        for <linux-media@vger.kernel.org>; Thu, 26 Oct 2017 12:00:44 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e7e1r-00032Q-On
        for linux-media@vger.kernel.org; Thu, 26 Oct 2017 12:00:43 +0300
Date: Thu, 26 Oct 2017 12:00:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 for 4.15] Imx274 driver
Message-ID: <20171026090042.c2wsyvmvmpvxqiwu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the imx274 driver, this time with the MAINTAINERS entry. A few minor
fixes have been done as well in error handling.

Please pull.


The following changes since commit 61065fc3e32002ba48aa6bc3816c1f6f9f8daf55:

  Merge commit '3728e6a255b5' into patchwork (2017-10-17 17:22:20 -0700)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-2

for you to fetch changes up to 9bcabda990b45147819a1fe38e8e6181a0f474c3:

  imx274: Add MAINTAINERS entry (2017-10-26 11:37:22 +0300)

----------------------------------------------------------------
Leon Luo (2):
      imx274: device tree binding file
      imx274: V4l2 driver for Sony imx274 CMOS sensor

Sakari Ailus (1):
      imx274: Add MAINTAINERS entry

 .../devicetree/bindings/media/i2c/imx274.txt       |   33 +
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |    7 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/imx274.c                         | 1810 ++++++++++++++++++++
 5 files changed, 1859 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imx274.txt
 create mode 100644 drivers/media/i2c/imx274.c


-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
