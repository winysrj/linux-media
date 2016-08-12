Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47092 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750708AbcHLH7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 03:59:46 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 2D5886009F
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2016 10:59:43 +0300 (EEST)
Date: Fri, 12 Aug 2016 10:59:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.9] ad5820 lens driver
Message-ID: <20160812075912.GW3182@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These two patches add support for the ad5820 lens found e.g. in the N900.

Please pull.


The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ad5820

for you to fetch changes up to 28439c96ba81e71d9b7dfb276172def0e06d34b2:

  ad5820: Add driver for auto-focus coil (2016-08-11 13:38:45 +0300)

----------------------------------------------------------------
Pavel Machek (2):
      dt/bindings: device tree description for AD5820 camera auto-focus coil
      ad5820: Add driver for auto-focus coil

 .../devicetree/bindings/media/i2c/ad5820.txt       |  19 ++
 drivers/media/i2c/Kconfig                          |   7 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/ad5820.c                         | 380
 +++++++++++++++++++++
 4 files changed, 407 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ad5820.txt
 create mode 100644 drivers/media/i2c/ad5820.c

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
