Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbeJSTtZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 15:49:25 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] media: rename soc_camera I2C drivers
Date: Fri, 19 Oct 2018 07:43:36 -0400
Message-Id: <3e42194ffb936ec9d0a4d361f06c6a4b0e88173f.1539949382.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those drivers are part of the legacy SoC camera framework.
They're being converted to not use it, but sometimes we're
keeping both legacy any new driver.

This time, for example, we have two drivers on media with
the same name: ov772x. That's bad.

So, in order to prevent that to happen, let's prepend the SoC
legacy drivers with soc_.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/i2c/soc_camera/Makefile          | 18 +++++++++---------
 .../soc_camera/{mt9m001.c => soc_mt9m001.c}    |  0
 .../soc_camera/{mt9t112.c => soc_mt9t112.c}    |  0
 .../soc_camera/{mt9v022.c => soc_mt9v022.c}    |  0
 .../i2c/soc_camera/{ov5642.c => soc_ov5642.c}  |  0
 .../i2c/soc_camera/{ov772x.c => soc_ov772x.c}  |  0
 .../i2c/soc_camera/{ov9640.c => soc_ov9640.c}  |  0
 .../i2c/soc_camera/{ov9740.c => soc_ov9740.c}  |  0
 .../{rj54n1cb0c.c => soc_rj54n1cb0c.c}         |  0
 .../i2c/soc_camera/{tw9910.c => soc_tw9910.c}  |  0
 10 files changed, 9 insertions(+), 9 deletions(-)
 rename drivers/media/i2c/soc_camera/{mt9m001.c => soc_mt9m001.c} (100%)
 rename drivers/media/i2c/soc_camera/{mt9t112.c => soc_mt9t112.c} (100%)
 rename drivers/media/i2c/soc_camera/{mt9v022.c => soc_mt9v022.c} (100%)
 rename drivers/media/i2c/soc_camera/{ov5642.c => soc_ov5642.c} (100%)
 rename drivers/media/i2c/soc_camera/{ov772x.c => soc_ov772x.c} (100%)
 rename drivers/media/i2c/soc_camera/{ov9640.c => soc_ov9640.c} (100%)
 rename drivers/media/i2c/soc_camera/{ov9740.c => soc_ov9740.c} (100%)
 rename drivers/media/i2c/soc_camera/{rj54n1cb0c.c => soc_rj54n1cb0c.c} (100%)
 rename drivers/media/i2c/soc_camera/{tw9910.c => soc_tw9910.c} (100%)

diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
index 8c7770f62997..09ae483b96ef 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
-obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
-obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
-obj-$(CONFIG_SOC_CAMERA_OV5642)		+= ov5642.o
-obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
-obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
-obj-$(CONFIG_SOC_CAMERA_OV9740)		+= ov9740.o
-obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
-obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
+obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= soc_mt9m001.o
+obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= soc_mt9t112.o
+obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= soc_mt9v022.o
+obj-$(CONFIG_SOC_CAMERA_OV5642)		+= soc_ov5642.o
+obj-$(CONFIG_SOC_CAMERA_OV772X)		+= soc_ov772x.o
+obj-$(CONFIG_SOC_CAMERA_OV9640)		+= soc_ov9640.o
+obj-$(CONFIG_SOC_CAMERA_OV9740)		+= soc_ov9740.o
+obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= soc_rj54n1cb0c.o
+obj-$(CONFIG_SOC_CAMERA_TW9910)		+= soc_tw9910.o
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/soc_mt9m001.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/mt9m001.c
rename to drivers/media/i2c/soc_camera/soc_mt9m001.c
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/soc_mt9t112.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/mt9t112.c
rename to drivers/media/i2c/soc_camera/soc_mt9t112.c
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/soc_mt9v022.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/mt9v022.c
rename to drivers/media/i2c/soc_camera/soc_mt9v022.c
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/soc_ov5642.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/ov5642.c
rename to drivers/media/i2c/soc_camera/soc_ov5642.c
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/soc_ov772x.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/ov772x.c
rename to drivers/media/i2c/soc_camera/soc_ov772x.c
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/soc_ov9640.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/ov9640.c
rename to drivers/media/i2c/soc_camera/soc_ov9640.c
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/soc_ov9740.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/ov9740.c
rename to drivers/media/i2c/soc_camera/soc_ov9740.c
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/rj54n1cb0c.c
rename to drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/soc_tw9910.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/tw9910.c
rename to drivers/media/i2c/soc_camera/soc_tw9910.c
-- 
2.17.1
