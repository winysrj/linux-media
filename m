Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:58696 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752019AbeAPLCu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 06:02:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH 0/2] imx074/mt9t031: deprecate soc_camera sensors
Date: Tue, 16 Jan 2018 12:02:43 +0100
Message-Id: <20180116110245.9456-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These two sensor drivers in drivers/media/i2c/soc_camera are not
used anymore. Move them to staging in preparation of being deleted
once the soc_camera framework is removed. Unless someone steps up
to do the conversion to a proper V4L2 subdev driver.

Regards,

	Hans

Hans Verkuil (2):
  imx074: deprecate, move to staging
  mt9t031: deprecate, move to staging

 drivers/media/i2c/soc_camera/Kconfig                         | 12 ------------
 drivers/media/i2c/soc_camera/Makefile                        |  2 --
 drivers/staging/media/Kconfig                                |  4 ++++
 drivers/staging/media/Makefile                               |  2 ++
 drivers/staging/media/imx074/Kconfig                         |  5 +++++
 drivers/staging/media/imx074/Makefile                        |  1 +
 drivers/staging/media/imx074/TODO                            |  5 +++++
 .../{media/i2c/soc_camera => staging/media/imx074}/imx074.c  |  0
 drivers/staging/media/mt9t031/Kconfig                        | 11 +++++++++++
 drivers/staging/media/mt9t031/Makefile                       |  1 +
 drivers/staging/media/mt9t031/TODO                           |  5 +++++
 .../i2c/soc_camera => staging/media/mt9t031}/mt9t031.c       |  0
 12 files changed, 34 insertions(+), 14 deletions(-)
 create mode 100644 drivers/staging/media/imx074/Kconfig
 create mode 100644 drivers/staging/media/imx074/Makefile
 create mode 100644 drivers/staging/media/imx074/TODO
 rename drivers/{media/i2c/soc_camera => staging/media/imx074}/imx074.c (100%)
 create mode 100644 drivers/staging/media/mt9t031/Kconfig
 create mode 100644 drivers/staging/media/mt9t031/Makefile
 create mode 100644 drivers/staging/media/mt9t031/TODO
 rename drivers/{media/i2c/soc_camera => staging/media/mt9t031}/mt9t031.c (100%)

-- 
2.15.1
