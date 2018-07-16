Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:44957 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeGPQQK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 12:16:10 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Mark Brown <broonie@kernel.org>, Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH -next v4 0/3] introduce SCCB regmap
Date: Tue, 17 Jul 2018 00:47:47 +0900
Message-Id: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset introduces Serial Camera Control Bus (SCCB) support for
regmap API and convert ov772x and ov9650 drivers to use it.

This patchset was previously submitted as "introduce SCCB helpers"
that provides three functions (sccb_is_available, sccb_read_byte, and
sccb_write_byte).  This time, the helpers are replaced by regmap API,
but internal code is not much changed from the previous version.

* v4
- Introduce SCCB regmap instead of helper functions,
  suggested by Sebastian Reichel
- Change ov772x driver to use regmap instead of helper functions
- Add register access conversion for ov9650 driver

* v3
- Rewrite the helpers based on the code provided by Wolfram
- Convert ov772x driver to use SCCB helpers

 v2
- Convert all helpers into static inline functions, and remove C source
  and Kconfig option.
- Acquire i2c adapter lock while issuing two requests for sccb_read_byte

Akinobu Mita (3):
  regmap: add SCCB support
  media: ov772x: use SCCB regmap
  media: ov9650: use SCCB regmap

 drivers/base/regmap/Kconfig       |   4 +
 drivers/base/regmap/Makefile      |   1 +
 drivers/base/regmap/regmap-sccb.c | 128 +++++++++++++++++++++++++
 drivers/media/i2c/Kconfig         |   2 +
 drivers/media/i2c/ov772x.c        | 192 ++++++++++++++++----------------------
 drivers/media/i2c/ov9650.c        | 157 +++++++++++++++----------------
 include/linux/regmap.h            |  35 +++++++
 7 files changed, 326 insertions(+), 193 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-sccb.c

Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Rosin <peda@axentia.se>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
-- 
2.7.4
