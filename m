Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44418 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751351AbdGQWOZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:14:25 -0400
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 58333600BF
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 01:14:22 +0300 (EEST)
Received: from sailus by lanttu.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@iki.fi>)
        id 1dXEHX-0004zw-OF
        for linux-media@vger.kernel.org; Tue, 18 Jul 2017 01:14:23 +0300
Date: Tue, 18 Jul 2017 01:14:23 +0300
From: sakari.ailus@iki.fi
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] Sub-device driver patches plus a few others
Message-ID: <20170717221423.tpfz2jhv5xmu6l4q@lanttu.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the first set of sensor driver patches for 4.14, including the
ov5670 sensor driver. Additionally, there are a few fixes for the omap3isp
driver as well as a documentation fix long due.

Please pull.


The following changes since commit a3db9d60a118571e696b684a6e8c692a2b064941:

  Merge tag 'v4.13-rc1' into patchwork (2017-07-17 11:17:36 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.14

for you to fetch changes up to f7690b0b9d7e9e12a830a18d7b19b6026ac05ac7:

  i2c: Add Omnivision OV5670 5M sensor support (2017-07-18 00:00:13 +0300)

----------------------------------------------------------------
Chiranjeevi Rapolu (1):
      i2c: Add Omnivision OV5670 5M sensor support

Colin Ian King (1):
      smiapp: make various const arrays static

Pavel Machek (1):
      omap3isp: Return -EPROBE_DEFER if the required regulators can't be obtained

Ramiro Oliveira (1):
      MAINTAINERS: Change OV5647 Maintainer

Sakari Ailus (2):
      omap3isp: Ignore endpoints with invalid configuration
      docs-rst: v4l: Fix sink compose selection target documentation

Todor Tomov (3):
      ov5645: Set media entity function
      ov5645: Add control to export pixel clock frequency
      ov5645: Add control to export CSI2 link frequency

 Documentation/media/uapi/v4l/dev-subdev.rst |    2 +-
 MAINTAINERS                                 |    2 +-
 drivers/media/i2c/Kconfig                   |   12 +
 drivers/media/i2c/Makefile                  |    1 +
 drivers/media/i2c/ov5645.c                  |   49 +-
 drivers/media/i2c/ov5670.c                  | 2588 +++++++++++++++++++++++++++
 drivers/media/i2c/smiapp/smiapp-quirk.c     |    8 +-
 drivers/media/platform/omap3isp/isp.c       |   11 +-
 drivers/media/platform/omap3isp/ispccp2.c   |    5 +
 9 files changed, 2663 insertions(+), 15 deletions(-)
 create mode 100644 drivers/media/i2c/ov5670.c

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
