Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57491 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750829AbaLQJeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 04:34:07 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 10F2960093
	for <linux-media@vger.kernel.org>; Wed, 17 Dec 2014 11:34:03 +0200 (EET)
Date: Wed, 17 Dec 2014 11:33:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.20] Smiapp OF support
Message-ID: <20141217093331.GF17565@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Besides a few cleanups, this set adds OF support for the smiapp driver.

Please pull.

The following changes since commit e272d95f8c0544cff55c485a10828b063c8e417c:

  [media] rcar_vin: Fix interrupt enable in progressive (2014-12-12 10:29:40 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-dt

for you to fetch changes up to 7f6de94da4bd82c80b7346a0e651fb99f3269361:

  smiapp: Fully probe the device in probe (2014-12-17 11:28:52 +0200)

----------------------------------------------------------------
Sakari Ailus (12):
      smiapp: Remove FSF's address from the license header
      smiapp: List include/uapi/linux/smiapp.h in MAINTAINERS
      smiapp-pll: include linux/device.h in smiapp-pll.c, not in smiapp-pll.h
      smiapp: Use types better suitable for DT
      smiapp: Don't give the source sub-device a temporary name
      smiapp: Register async subdev
      smiapp: The sensor only needs a single clock, name may be NULL
      of: v4l: Document link-frequencies property in video-interfaces.txt
      of: smiapp: Add documentation
      smiapp: Obtain device information from the Device Tree if OF node exists
      smiapp: Split sub-device initialisation off from the registered callback
      smiapp: Fully probe the device in probe

 .../devicetree/bindings/media/i2c/nokia,smia.txt   |   63 +++++
 .../devicetree/bindings/media/video-interfaces.txt |    3 +
 MAINTAINERS                                        |    2 +
 drivers/media/i2c/smiapp-pll.c                     |    7 +-
 drivers/media/i2c/smiapp-pll.h                     |    8 -
 drivers/media/i2c/smiapp/smiapp-core.c             |  283 ++++++++++++++++----
 drivers/media/i2c/smiapp/smiapp-limits.c           |    6 -
 drivers/media/i2c/smiapp/smiapp-limits.h           |    6 -
 drivers/media/i2c/smiapp/smiapp-quirk.c            |    6 -
 drivers/media/i2c/smiapp/smiapp-quirk.h            |    6 -
 drivers/media/i2c/smiapp/smiapp-reg-defs.h         |    6 -
 drivers/media/i2c/smiapp/smiapp-reg.h              |    6 -
 drivers/media/i2c/smiapp/smiapp-regs.c             |    6 -
 drivers/media/i2c/smiapp/smiapp-regs.h             |    6 -
 drivers/media/i2c/smiapp/smiapp.h                  |    6 -
 include/media/smiapp.h                             |   10 +-
 16 files changed, 299 insertions(+), 131 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
