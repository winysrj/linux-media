Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:12574 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3EIPhS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:37:18 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ0064BFE4WZF0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 May 2013 00:37:16 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, dh09.lee@samsung.com, a.hajda@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 03/13] exynos4-is: Move common functions to a separate module
Date: Thu, 09 May 2013 17:36:35 +0200
Message-id: <1368113805-20233-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
References: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a common module (exynos4-common.ko) that will hold common
functions used across video device and subdev drivers contained
in the .../exynos4-is directory.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/Kconfig     |    5 +++
 drivers/media/platform/exynos4-is/Makefile    |    2 ++
 drivers/media/platform/exynos4-is/common.c    |   41 +++++++++++++++++++++++++
 drivers/media/platform/exynos4-is/common.h    |   12 ++++++++
 drivers/media/platform/exynos4-is/fimc-lite.c |   29 ++---------------
 5 files changed, 63 insertions(+), 26 deletions(-)
 create mode 100644 drivers/media/platform/exynos4-is/common.c
 create mode 100644 drivers/media/platform/exynos4-is/common.h

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 6ff99b5..132b7d7 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -8,12 +8,16 @@ config VIDEO_SAMSUNG_EXYNOS4_IS
 
 if VIDEO_SAMSUNG_EXYNOS4_IS
 
+config VIDEO_EXYNOS4_COMMON
+       tristate
+
 config VIDEO_S5P_FIMC
 	tristate "S5P/EXYNOS4 FIMC/CAMIF camera interface driver"
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select MFD_SYSCON if OF
+	select VIDEO_EXYNOS4_COMMON
 	help
 	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC camera host
 	  interface and video postprocessor (FIMC) devices.
@@ -38,6 +42,7 @@ config VIDEO_EXYNOS_FIMC_LITE
 	tristate "EXYNOS FIMC-LITE camera interface driver"
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEO_EXYNOS4_COMMON
 	help
 	  This is a V4L2 driver for Samsung EXYNOS4/5 SoC FIMC-LITE camera
 	  host interface.
diff --git a/drivers/media/platform/exynos4-is/Makefile b/drivers/media/platform/exynos4-is/Makefile
index f25f463..095cc25 100644
--- a/drivers/media/platform/exynos4-is/Makefile
+++ b/drivers/media/platform/exynos4-is/Makefile
@@ -3,8 +3,10 @@ exynos-fimc-lite-objs += fimc-lite-reg.o fimc-lite.o
 exynos-fimc-is-objs := fimc-is.o fimc-isp.o fimc-is-sensor.o fimc-is-regs.o
 exynos-fimc-is-objs += fimc-is-param.o fimc-is-errno.o fimc-is-i2c.o
 s5p-csis-objs := mipi-csis.o
+exynos4-common-objs := common.o
 
 obj-$(CONFIG_VIDEO_S5P_MIPI_CSIS)	+= s5p-csis.o
 obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)	+= exynos-fimc-lite.o
 obj-$(CONFIG_VIDEO_EXYNOS4_FIMC_IS)	+= exynos-fimc-is.o
 obj-$(CONFIG_VIDEO_S5P_FIMC)		+= s5p-fimc.o
+obj-$(CONFIG_VIDEO_EXYNOS4_COMMON)	+= exynos4-common.o
diff --git a/drivers/media/platform/exynos4-is/common.c b/drivers/media/platform/exynos4-is/common.c
new file mode 100644
index 0000000..6720520
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/common.c
@@ -0,0 +1,41 @@
+/*
+ * Samsung S5P/EXYNOS4 SoC Camera Subsystem driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <media/s5p_fimc.h>
+#include "common.h"
+
+/* Called with the media graph mutex held or entity->stream_count > 0. */
+struct v4l2_subdev *fimc_find_remote_sensor(struct media_entity *entity)
+{
+	struct media_pad *pad = &entity->pads[0];
+	struct v4l2_subdev *sd;
+
+	while (pad->flags & MEDIA_PAD_FL_SINK) {
+		/* source pad */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+
+		if (sd->grp_id == GRP_ID_FIMC_IS_SENSOR ||
+		    sd->grp_id == GRP_ID_SENSOR)
+			return sd;
+		/* sink pad */
+		pad = &sd->entity.pads[0];
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(fimc_find_remote_sensor);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/exynos4-is/common.h b/drivers/media/platform/exynos4-is/common.h
new file mode 100644
index 0000000..3c39803
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/common.h
@@ -0,0 +1,12 @@
+/*
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+
+struct v4l2_subdev *fimc_find_remote_sensor(struct media_entity *entity);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index c57fa65..66480e7 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -32,6 +32,7 @@
 #include <media/videobuf2-dma-contig.h>
 #include <media/s5p_fimc.h>
 
+#include "common.h"
 #include "fimc-core.h"
 #include "fimc-lite.h"
 #include "fimc-lite-reg.h"
@@ -131,30 +132,6 @@ static const struct fimc_fmt *fimc_lite_find_format(const u32 *pixelformat,
 	return def_fmt;
 }
 
-/* Called with the media graph mutex held or @me stream_count > 0. */
-static struct v4l2_subdev *__find_remote_sensor(struct media_entity *me)
-{
-	struct media_pad *pad = &me->pads[0];
-	struct v4l2_subdev *sd;
-
-	while (pad->flags & MEDIA_PAD_FL_SINK) {
-		/* source pad */
-		pad = media_entity_remote_source(pad);
-		if (pad == NULL ||
-		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
-			break;
-
-		sd = media_entity_to_v4l2_subdev(pad->entity);
-
-		if (sd->grp_id == GRP_ID_FIMC_IS_SENSOR ||
-		    sd->grp_id == GRP_ID_SENSOR)
-			return sd;
-		/* sink pad */
-		pad = &sd->entity.pads[0];
-	}
-	return NULL;
-}
-
 static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 {
 	struct fimc_source_info *si;
@@ -830,7 +807,7 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 	if (ret < 0)
 		goto err_p_stop;
 
-	fimc->sensor = __find_remote_sensor(&fimc->subdev.entity);
+	fimc->sensor = fimc_find_remote_sensor(&fimc->subdev.entity);
 
 	ret = vb2_ioctl_streamon(file, priv, type);
 	if (!ret) {
@@ -1212,7 +1189,7 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 	 * The pipeline links are protected through entity.stream_count
 	 * so there is no need to take the media graph mutex here.
 	 */
-	fimc->sensor = __find_remote_sensor(&sd->entity);
+	fimc->sensor = fimc_find_remote_sensor(&sd->entity);
 
 	if (atomic_read(&fimc->out_path) != FIMC_IO_ISP)
 		return -ENOIOCTLCMD;
-- 
1.7.9.5

