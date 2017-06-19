Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56879 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750982AbdFSRBM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 13:01:12 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v5 02/12] [media] vimc: Move common code from the core
Date: Mon, 19 Jun 2017 14:00:11 -0300
Message-Id: <1497891629-1562-3-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
References: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove helper functions from vimc-core and add it in vimc-common to
clean up the core.

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v5: None
Changes in v4: None
Changes in v3:
[media] vimc: Move common code from the core
	- This is a new patch in the series

Changes in v2: None


---
 drivers/media/platform/vimc/Makefile               |   2 +-
 drivers/media/platform/vimc/vimc-capture.h         |   2 +-
 drivers/media/platform/vimc/vimc-common.c          | 221 +++++++++++++++++++++
 .../platform/vimc/{vimc-core.h => vimc-common.h}   |   7 +-
 drivers/media/platform/vimc/vimc-core.c            | 205 +------------------
 drivers/media/platform/vimc/vimc-sensor.h          |   2 +-
 6 files changed, 229 insertions(+), 210 deletions(-)
 create mode 100644 drivers/media/platform/vimc/vimc-common.c
 rename drivers/media/platform/vimc/{vimc-core.h => vimc-common.h} (96%)

diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platform/vimc/Makefile
index c45195e..6b6ddf4 100644
--- a/drivers/media/platform/vimc/Makefile
+++ b/drivers/media/platform/vimc/Makefile
@@ -1,3 +1,3 @@
-vimc-objs := vimc-core.o vimc-capture.o vimc-sensor.o
+vimc-objs := vimc-core.o vimc-capture.o vimc-common.o vimc-sensor.o
 
 obj-$(CONFIG_VIDEO_VIMC) += vimc.o
diff --git a/drivers/media/platform/vimc/vimc-capture.h b/drivers/media/platform/vimc/vimc-capture.h
index 581a813..7e5c707 100644
--- a/drivers/media/platform/vimc/vimc-capture.h
+++ b/drivers/media/platform/vimc/vimc-capture.h
@@ -18,7 +18,7 @@
 #ifndef _VIMC_CAPTURE_H_
 #define _VIMC_CAPTURE_H_
 
-#include "vimc-core.h"
+#include "vimc-common.h"
 
 struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
 					const char *const name,
diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
new file mode 100644
index 0000000..42f779a
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -0,0 +1,221 @@
+/*
+ * vimc-common.c Virtual Media Controller Driver
+ *
+ * Copyright (C) 2015-2017 Helen Koike <helen.fornazier@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include "vimc-common.h"
+
+static const struct vimc_pix_map vimc_pix_map_list[] = {
+	/* TODO: add all missing formats */
+
+	/* RGB formats */
+	{
+		.code = MEDIA_BUS_FMT_BGR888_1X24,
+		.pixelformat = V4L2_PIX_FMT_BGR24,
+		.bpp = 3,
+	},
+	{
+		.code = MEDIA_BUS_FMT_RGB888_1X24,
+		.pixelformat = V4L2_PIX_FMT_RGB24,
+		.bpp = 3,
+	},
+	{
+		.code = MEDIA_BUS_FMT_ARGB8888_1X32,
+		.pixelformat = V4L2_PIX_FMT_ARGB32,
+		.bpp = 4,
+	},
+
+	/* Bayer formats */
+	{
+		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SBGGR8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGBRG8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGRBG8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SRGGB8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SBGGR10_1X10,
+		.pixelformat = V4L2_PIX_FMT_SBGGR10,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG10_1X10,
+		.pixelformat = V4L2_PIX_FMT_SGBRG10,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG10_1X10,
+		.pixelformat = V4L2_PIX_FMT_SGRBG10,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB10_1X10,
+		.pixelformat = V4L2_PIX_FMT_SRGGB10,
+		.bpp = 2,
+	},
+
+	/* 10bit raw bayer a-law compressed to 8 bits */
+	{
+		.code = MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SBGGR10ALAW8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGBRG10ALAW8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGRBG10ALAW8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SRGGB10ALAW8,
+		.bpp = 1,
+	},
+
+	/* 10bit raw bayer DPCM compressed to 8 bits */
+	{
+		.code = MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SBGGR10DPCM8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGBRG10DPCM8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8,
+		.pixelformat = V4L2_PIX_FMT_SRGGB10DPCM8,
+		.bpp = 1,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SBGGR12_1X12,
+		.pixelformat = V4L2_PIX_FMT_SBGGR12,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGBRG12_1X12,
+		.pixelformat = V4L2_PIX_FMT_SGBRG12,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SGRBG12_1X12,
+		.pixelformat = V4L2_PIX_FMT_SGRBG12,
+		.bpp = 2,
+	},
+	{
+		.code = MEDIA_BUS_FMT_SRGGB12_1X12,
+		.pixelformat = V4L2_PIX_FMT_SRGGB12,
+		.bpp = 2,
+	},
+};
+
+const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vimc_pix_map_list); i++) {
+		if (vimc_pix_map_list[i].code == code)
+			return &vimc_pix_map_list[i];
+	}
+	return NULL;
+}
+
+const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vimc_pix_map_list); i++) {
+		if (vimc_pix_map_list[i].pixelformat == pixelformat)
+			return &vimc_pix_map_list[i];
+	}
+	return NULL;
+}
+
+int vimc_propagate_frame(struct media_pad *src, const void *frame)
+{
+	struct media_link *link;
+
+	if (!(src->flags & MEDIA_PAD_FL_SOURCE))
+		return -EINVAL;
+
+	/* Send this frame to all sink pads that are direct linked */
+	list_for_each_entry(link, &src->entity->links, list) {
+		if (link->source == src &&
+		    (link->flags & MEDIA_LNK_FL_ENABLED)) {
+			struct vimc_ent_device *ved = NULL;
+			struct media_entity *entity = link->sink->entity;
+
+			if (is_media_entity_v4l2_subdev(entity)) {
+				struct v4l2_subdev *sd =
+					container_of(entity, struct v4l2_subdev,
+						     entity);
+				ved = v4l2_get_subdevdata(sd);
+			} else if (is_media_entity_v4l2_video_device(entity)) {
+				struct video_device *vdev =
+					container_of(entity,
+						     struct video_device,
+						     entity);
+				ved = video_get_drvdata(vdev);
+			}
+			if (ved && ved->process_frame)
+				ved->process_frame(ved, link->sink, frame);
+		}
+	}
+
+	return 0;
+}
+
+/* Helper function to allocate and initialize pads */
+struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
+{
+	struct media_pad *pads;
+	unsigned int i;
+
+	/* Allocate memory for the pads */
+	pads = kcalloc(num_pads, sizeof(*pads), GFP_KERNEL);
+	if (!pads)
+		return ERR_PTR(-ENOMEM);
+
+	/* Initialize the pads */
+	for (i = 0; i < num_pads; i++) {
+		pads[i].index = i;
+		pads[i].flags = pads_flag[i];
+	}
+
+	return pads;
+}
diff --git a/drivers/media/platform/vimc/vimc-core.h b/drivers/media/platform/vimc/vimc-common.h
similarity index 96%
rename from drivers/media/platform/vimc/vimc-core.h
rename to drivers/media/platform/vimc/vimc-common.h
index 4525d23..00d3da4 100644
--- a/drivers/media/platform/vimc/vimc-core.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -1,5 +1,5 @@
 /*
- * vimc-core.h Virtual Media Controller Driver
+ * vimc-ccommon.h Virtual Media Controller Driver
  *
  * Copyright (C) 2015-2017 Helen Koike <helen.fornazier@gmail.com>
  *
@@ -15,10 +15,11 @@
  *
  */
 
-#ifndef _VIMC_CORE_H_
-#define _VIMC_CORE_H_
+#ifndef _VIMC_COMMON_H_
+#define _VIMC_COMMON_H_
 
 #include <linux/slab.h>
+#include <media/media-device.h>
 #include <media/v4l2-device.h>
 
 /**
diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index bc107da..afc79e2 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -22,7 +22,7 @@
 #include <media/v4l2-device.h>
 
 #include "vimc-capture.h"
-#include "vimc-core.h"
+#include "vimc-common.h"
 #include "vimc-sensor.h"
 
 #define VIMC_PDEV_NAME "vimc"
@@ -197,189 +197,6 @@ static const struct vimc_pipeline_config pipe_cfg = {
 
 /* -------------------------------------------------------------------------- */
 
-static const struct vimc_pix_map vimc_pix_map_list[] = {
-	/* TODO: add all missing formats */
-
-	/* RGB formats */
-	{
-		.code = MEDIA_BUS_FMT_BGR888_1X24,
-		.pixelformat = V4L2_PIX_FMT_BGR24,
-		.bpp = 3,
-	},
-	{
-		.code = MEDIA_BUS_FMT_RGB888_1X24,
-		.pixelformat = V4L2_PIX_FMT_RGB24,
-		.bpp = 3,
-	},
-	{
-		.code = MEDIA_BUS_FMT_ARGB8888_1X32,
-		.pixelformat = V4L2_PIX_FMT_ARGB32,
-		.bpp = 4,
-	},
-
-	/* Bayer formats */
-	{
-		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SBGGR8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGBRG8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SGBRG8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGRBG8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SGRBG8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SRGGB8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SRGGB8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SBGGR10_1X10,
-		.pixelformat = V4L2_PIX_FMT_SBGGR10,
-		.bpp = 2,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGBRG10_1X10,
-		.pixelformat = V4L2_PIX_FMT_SGBRG10,
-		.bpp = 2,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGRBG10_1X10,
-		.pixelformat = V4L2_PIX_FMT_SGRBG10,
-		.bpp = 2,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SRGGB10_1X10,
-		.pixelformat = V4L2_PIX_FMT_SRGGB10,
-		.bpp = 2,
-	},
-
-	/* 10bit raw bayer a-law compressed to 8 bits */
-	{
-		.code = MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SBGGR10ALAW8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SGBRG10ALAW8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SGRBG10ALAW8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SRGGB10ALAW8,
-		.bpp = 1,
-	},
-
-	/* 10bit raw bayer DPCM compressed to 8 bits */
-	{
-		.code = MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SBGGR10DPCM8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SGBRG10DPCM8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8,
-		.pixelformat = V4L2_PIX_FMT_SRGGB10DPCM8,
-		.bpp = 1,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SBGGR12_1X12,
-		.pixelformat = V4L2_PIX_FMT_SBGGR12,
-		.bpp = 2,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGBRG12_1X12,
-		.pixelformat = V4L2_PIX_FMT_SGBRG12,
-		.bpp = 2,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SGRBG12_1X12,
-		.pixelformat = V4L2_PIX_FMT_SGRBG12,
-		.bpp = 2,
-	},
-	{
-		.code = MEDIA_BUS_FMT_SRGGB12_1X12,
-		.pixelformat = V4L2_PIX_FMT_SRGGB12,
-		.bpp = 2,
-	},
-};
-
-const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(vimc_pix_map_list); i++) {
-		if (vimc_pix_map_list[i].code == code)
-			return &vimc_pix_map_list[i];
-	}
-	return NULL;
-}
-
-const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(vimc_pix_map_list); i++) {
-		if (vimc_pix_map_list[i].pixelformat == pixelformat)
-			return &vimc_pix_map_list[i];
-	}
-	return NULL;
-}
-
-int vimc_propagate_frame(struct media_pad *src, const void *frame)
-{
-	struct media_link *link;
-
-	if (!(src->flags & MEDIA_PAD_FL_SOURCE))
-		return -EINVAL;
-
-	/* Send this frame to all sink pads that are direct linked */
-	list_for_each_entry(link, &src->entity->links, list) {
-		if (link->source == src &&
-		    (link->flags & MEDIA_LNK_FL_ENABLED)) {
-			struct vimc_ent_device *ved = NULL;
-			struct media_entity *entity = link->sink->entity;
-
-			if (is_media_entity_v4l2_subdev(entity)) {
-				struct v4l2_subdev *sd =
-					container_of(entity, struct v4l2_subdev,
-						     entity);
-				ved = v4l2_get_subdevdata(sd);
-			} else if (is_media_entity_v4l2_video_device(entity)) {
-				struct video_device *vdev =
-					container_of(entity,
-						     struct video_device,
-						     entity);
-				ved = video_get_drvdata(vdev);
-			}
-			if (ved && ved->process_frame)
-				ved->process_frame(ved, link->sink, frame);
-		}
-	}
-
-	return 0;
-}
-
 static void vimc_device_unregister(struct vimc_device *vimc)
 {
 	unsigned int i;
@@ -396,26 +213,6 @@ static void vimc_device_unregister(struct vimc_device *vimc)
 	media_device_cleanup(&vimc->mdev);
 }
 
-/* Helper function to allocate and initialize pads */
-struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
-{
-	struct media_pad *pads;
-	unsigned int i;
-
-	/* Allocate memory for the pads */
-	pads = kcalloc(num_pads, sizeof(*pads), GFP_KERNEL);
-	if (!pads)
-		return ERR_PTR(-ENOMEM);
-
-	/* Initialize the pads */
-	for (i = 0; i < num_pads; i++) {
-		pads[i].index = i;
-		pads[i].flags = pads_flag[i];
-	}
-
-	return pads;
-}
-
 /*
  * TODO: remove this function when all the
  * entities specific code are implemented
diff --git a/drivers/media/platform/vimc/vimc-sensor.h b/drivers/media/platform/vimc/vimc-sensor.h
index 505310e..580dcec 100644
--- a/drivers/media/platform/vimc/vimc-sensor.h
+++ b/drivers/media/platform/vimc/vimc-sensor.h
@@ -18,7 +18,7 @@
 #ifndef _VIMC_SENSOR_H_
 #define _VIMC_SENSOR_H_
 
-#include "vimc-core.h"
+#include "vimc-common.h"
 
 struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
 					const char *const name,
-- 
2.7.4
