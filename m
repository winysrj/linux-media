Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43856 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751416AbdAYOPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 09:15:23 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 8F9EF60098
        for <linux-media@vger.kernel.org>; Wed, 25 Jan 2017 16:08:15 +0200 (EET)
Date: Wed, 25 Jan 2017 16:07:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.11] Add et8ek8 driver
Message-ID: <20170125140745.GH7139@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request adds the sensor et8ek8 driver which is used on the Nokia
N900. Please pull.


The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git et8ek8

for you to fetch changes up to 1d26b93d5341d36cdd45b4d801f85d6c35128385:

  mark myself as mainainer for camera on N900 (2017-01-25 15:49:45 +0200)

----------------------------------------------------------------
Pavel Machek (3):
      media: et8ek8: add device tree binding documentation
      media: Driver for Toshiba et8ek8 5MP sensor
      mark myself as mainainer for camera on N900

 .../bindings/media/i2c/toshiba,et8ek8.txt          |   48 +
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |    1 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/et8ek8/Kconfig                   |    6 +
 drivers/media/i2c/et8ek8/Makefile                  |    2 +
 drivers/media/i2c/et8ek8/et8ek8_driver.c           | 1515 ++++++++++++++++++++
 drivers/media/i2c/et8ek8/et8ek8_mode.c             |  587 ++++++++
 drivers/media/i2c/et8ek8/et8ek8_reg.h              |   96 ++
 9 files changed, 2264 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
 create mode 100644 drivers/media/i2c/et8ek8/Kconfig
 create mode 100644 drivers/media/i2c/et8ek8/Makefile
 create mode 100644 drivers/media/i2c/et8ek8/et8ek8_driver.c
 create mode 100644 drivers/media/i2c/et8ek8/et8ek8_mode.c
 create mode 100644 drivers/media/i2c/et8ek8/et8ek8_reg.h

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
