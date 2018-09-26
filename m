Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60796 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbeI0Dh5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 23:37:57 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 96BFF634C7D
        for <linux-media@vger.kernel.org>; Thu, 27 Sep 2018 00:23:02 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1g5HGw-0001J7-A9
        for linux-media@vger.kernel.org; Thu, 27 Sep 2018 00:23:02 +0300
Date: Thu, 27 Sep 2018 00:23:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Unlocked control grab and imx319 driver
Message-ID: <20180926212302.yk3f5k7hqhp6vufl@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a driver for Sony imx319 sensor and an unlocked version of
v4l2_ctrl_grab() which is used by the driver.

Please pull.


The following changes since commit 985cdcb08a0488558d1005139596b64d73bee267:

  media: ov5640: fix restore of last mode set (2018-09-17 15:33:38 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-8-sign-2

for you to fetch changes up to 0e5924d5c0051228a59adffa1e48777f9ebd60de:

  media: add imx319 camera sensor driver (2018-09-27 00:19:40 +0300)

----------------------------------------------------------------
v4l2_ctrl_grab and imx319

----------------------------------------------------------------
Bingbu Cao (1):
      media: add imx319 camera sensor driver

Sakari Ailus (2):
      v4l: ctrl: Remove old documentation from v4l2_ctrl_grab
      v4l: ctrl: Provide unlocked variant of v4l2_ctrl_grab

 MAINTAINERS                          |    7 +
 drivers/media/i2c/Kconfig            |   11 +
 drivers/media/i2c/Makefile           |    1 +
 drivers/media/i2c/imx319.c           | 2558 ++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c |   14 +-
 include/media/v4l2-ctrls.h           |   26 +-
 6 files changed, 2606 insertions(+), 11 deletions(-)
 create mode 100644 drivers/media/i2c/imx319.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
