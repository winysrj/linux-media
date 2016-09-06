Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:41554 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755586AbcIFJEb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 05:04:31 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v6 03/14] media: mt9m111: move mt9m111 out of soc_camera
Date: Tue,  6 Sep 2016 11:04:13 +0200
Message-Id: <1473152664-5077-3-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
References: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the mt9m111 is now working as a standalone v4l2 subdevice sensor,
move it out of soc_camera directory and severe its dependency on
soc_camera.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/i2c/Kconfig                    | 7 +++++++
 drivers/media/i2c/Makefile                   | 1 +
 drivers/media/i2c/{soc_camera => }/mt9m111.c | 0
 drivers/media/i2c/soc_camera/Kconfig         | 7 +++++--
 drivers/media/i2c/soc_camera/Makefile        | 1 -
 5 files changed, 13 insertions(+), 3 deletions(-)
 rename drivers/media/i2c/{soc_camera => }/mt9m111.c (100%)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 92cc54401339..7f929336c409 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -578,6 +578,13 @@ config VIDEO_MT9M032
 	  This driver supports MT9M032 camera sensors from Aptina, monochrome
 	  models only.
 
+config VIDEO_MT9M111
+	tristate "mt9m111, mt9m112 and mt9m131 support"
+	depends on I2C && VIDEO_V4L2
+	help
+	  This driver supports MT9M111, MT9M112 and MT9M131 cameras from
+	  Micron/Aptina
+
 config VIDEO_MT9P031
 	tristate "Aptina MT9P031 support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 0216af0f9281..92773b2e6225 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
 obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
+obj-$(CONFIG_VIDEO_MT9M111) += mt9m111.o
 obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
 obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
 obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/mt9m111.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/mt9m111.c
rename to drivers/media/i2c/mt9m111.c
diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index 23d352f0adf0..7704bcf5cc25 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -14,11 +14,14 @@ config SOC_CAMERA_MT9M001
 	  and colour models.
 
 config SOC_CAMERA_MT9M111
-	tristate "mt9m111, mt9m112 and mt9m131 support"
+	tristate "legacy soc_camera mt9m111, mt9m112 and mt9m131 support"
 	depends on SOC_CAMERA && I2C
+	select VIDEO_MT9M111
 	help
 	  This driver supports MT9M111, MT9M112 and MT9M131 cameras from
-	  Micron/Aptina
+	  Micron/Aptina.
+	  This is the legacy configuration which shouldn't be used anymore,
+	  while VIDEO_MT9M111 should be used instead.
 
 config SOC_CAMERA_MT9T031
 	tristate "mt9t031 support"
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
index d0421feaa796..6f994f9353a0 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -1,6 +1,5 @@
 obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
-obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
-- 
2.1.4

