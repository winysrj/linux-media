Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:54295 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752507AbdJSQbg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 12:31:36 -0400
Received: by mail-pg0-f65.google.com with SMTP id l24so7612494pgu.11
        for <linux-media@vger.kernel.org>; Thu, 19 Oct 2017 09:31:36 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 0/4] media: don't clear V4L2_SUBDEV_FL_IS_I2C
Date: Fri, 20 Oct 2017 01:31:19 +0900
Message-Id: <1508430683-8674-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_i2c_subdev_init() sets V4L2_SUBDEV_FL_IS_I2C flag in the
subdev->flags.  But some drivers overwrite subdev->flags immediately after
calling v4l2_i2c_subdev_init().  So V4L2_SUBDEV_FL_IS_I2C is not set after
all.

This patch series fixes the problem for each driver.

Side note: According to the comment in v4l2_device_unregister(), this is
problematic only if the device is platform bus device.  Device tree or
ACPI based devices are not affected.

Akinobu Mita (4):
  media: adv7180: don't clear V4L2_SUBDEV_FL_IS_I2C
  media: max2175: don't clear V4L2_SUBDEV_FL_IS_I2C
  media: ov2640: don't clear V4L2_SUBDEV_FL_IS_I2C
  media: ov5640: don't clear V4L2_SUBDEV_FL_IS_I2C

 drivers/media/i2c/adv7180.c | 2 +-
 drivers/media/i2c/max2175.c | 2 +-
 drivers/media/i2c/ov2640.c  | 2 +-
 drivers/media/i2c/ov5640.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
-- 
2.7.4
