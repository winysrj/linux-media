Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52184 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727333AbeJAOsM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 10:48:12 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 336C5634C7D
        for <linux-media@vger.kernel.org>; Mon,  1 Oct 2018 11:11:40 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1g6tIq-0000ux-13
        for linux-media@vger.kernel.org; Mon, 01 Oct 2018 11:11:40 +0300
Date: Mon, 1 Oct 2018 11:11:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Unlocked V4L2 control grab, imx{319, 355} drivers
Message-ID: <20181001081139.wo3ldnsl5eb75yze@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are drivers for Sony imx319 and imx355 sensors and an unlocked version
of v4l2_ctrl_grab() which is used by the driver.

Please pull.


The following changes since commit 985cdcb08a0488558d1005139596b64d73bee267:

  media: ov5640: fix restore of last mode set (2018-09-17 15:33:38 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-10-sign

for you to fetch changes up to d96444e7c6c6381e16d09c46feee46979ae3672b:

  media: add imx355 camera sensor driver (2018-10-01 10:30:40 +0300)

----------------------------------------------------------------
unlocked v4l2 ctrl grab, imx{319, 355}

----------------------------------------------------------------
Bingbu Cao (2):
      media: add imx319 camera sensor driver
      media: add imx355 camera sensor driver

Sakari Ailus (2):
      v4l: ctrl: Remove old documentation from v4l2_ctrl_grab
      v4l: ctrl: Provide unlocked variant of v4l2_ctrl_grab

 MAINTAINERS                          |   14 +
 drivers/media/i2c/Kconfig            |   22 +
 drivers/media/i2c/Makefile           |    2 +
 drivers/media/i2c/imx319.c           | 2558 ++++++++++++++++++++++++++++++++++
 drivers/media/i2c/imx355.c           | 1858 ++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c |   14 +-
 include/media/v4l2-ctrls.h           |   26 +-
 7 files changed, 4483 insertions(+), 11 deletions(-)
 create mode 100644 drivers/media/i2c/imx319.c
 create mode 100644 drivers/media/i2c/imx355.c

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
