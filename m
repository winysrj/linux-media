Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:57194 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753505AbdCTJdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 05:33:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 8/9] staging/atomisp: add MEDIA_CONTROLLER dependency globally
Date: Mon, 20 Mar 2017 10:32:24 +0100
Message-Id: <20170320093225.1180723-8-arnd@arndb.de>
In-Reply-To: <20170320093225.1180723-1-arnd@arndb.de>
References: <20170320093225.1180723-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One i2c driver already gained a dependency, but the others are equally broken:

drivers/staging/media/atomisp/i2c/ap1302.c: In function 'ap1302_remove':
drivers/staging/media/atomisp/i2c/ap1302.c:1143:31: error: 'struct v4l2_subdev' has no member named 'entity'
drivers/staging/media/atomisp/i2c/mt9m114.c: In function 'mt9m114_remove':
drivers/staging/media/atomisp/i2c/mt9m114.c:1850:31: error: 'struct v4l2_subdev' has no member named 'entity'
drivers/staging/media/atomisp/i2c/gc0310.c: In function 'gc0310_remove':
drivers/staging/media/atomisp/i2c/gc0310.c:1372:31: error: 'struct v4l2_subdev' has no member named 'entity'
drivers/staging/media/atomisp/i2c/gc0310.c: In function 'gc0310_probe':
drivers/staging/media/atomisp/i2c/gc0310.c:1422:9: error: 'struct v4l2_subdev' has no member named 'entity'
drivers/staging/media/atomisp/i2c/ov2722.c: In function 'ov2722_remove':
drivers/staging/media/atomisp/i2c/ov2722.c:1253:31: error: 'struct v4l2_subdev' has no member named 'entity'

Let's just require MEDIA_CONTROLLER for all of them.

Fixes: dd1c0f278b0e ("staging: media: atomisp: fix build error in ov5693 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/Kconfig            | 2 +-
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index 97ffa2fc5384..f24ae1c8cc90 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig INTEL_ATOMISP
         bool "Enable support to Intel MIPI camera drivers"
-        depends on X86 && PCI && ACPI
+        depends on X86 && PCI && ACPI && MEDIA_CONTROLLER
         help
           Enable support for the Intel ISP2 camera interfaces and MIPI
           sensor drivers.
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
index 3954b8c65fd1..9fb1bffbe9b3 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_OV5693
        tristate "Omnivision ov5693 sensor support"
-       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+       depends on I2C && VIDEO_V4L2
        ---help---
          This is a Video4Linux2 sensor-level driver for the Micron
          ov5693 5 Mpixel camera.
-- 
2.9.0
