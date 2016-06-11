Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36775 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbcFKPkD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2016 11:40:03 -0400
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	mchehab@osg.samsung.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH v3 0/2] media: add et8ek8 camera sensor driver and documentation
Date: Sat, 11 Jun 2016 18:39:51 +0300
Message-Id: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds driver for Toshiba et8ek8 camera sensor found in Nokia N900

Changes from v2:

 - fix build when CONFIG_PM is not defined

Changes from v1:

 - driver and documentation split into separate patches
 - removed custom controls
 - code changed according to the comments on v1

Ivaylo Dimitrov (2):
  media: Driver for Toshiba et8ek8 5MP sensor
  media: et8ek8: Add documentation

 .../bindings/media/i2c/toshiba,et8ek8.txt          |   50 +
 drivers/media/i2c/Kconfig                          |    1 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/et8ek8/Kconfig                   |    6 +
 drivers/media/i2c/et8ek8/Makefile                  |    2 +
 drivers/media/i2c/et8ek8/et8ek8_driver.c           | 1593 ++++++++++++++++++++
 drivers/media/i2c/et8ek8/et8ek8_mode.c             |  590 ++++++++
 drivers/media/i2c/et8ek8/et8ek8_reg.h              |   96 ++
 8 files changed, 2339 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
 create mode 100644 drivers/media/i2c/et8ek8/Kconfig
 create mode 100644 drivers/media/i2c/et8ek8/Makefile
 create mode 100644 drivers/media/i2c/et8ek8/et8ek8_driver.c
 create mode 100644 drivers/media/i2c/et8ek8/et8ek8_mode.c
 create mode 100644 drivers/media/i2c/et8ek8/et8ek8_reg.h

-- 
1.9.1

