Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43988 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3CKTBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:01:22 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 10/11] s5p-fimc: Remove dependency on fimc-core.h in
 fimc-lite driver
Date: Mon, 11 Mar 2013 20:00:25 +0100
Message-id: <1363028426-2771-11-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
References: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drop fimc-lite.h header inclusion to make the exynos-fimc-lite
module independent on other modules. Move struct fimc_fmt
declaration to the driver's private headers as it is used in
multiple modules.

Reported-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-core.h |   32 -------------------------
 drivers/media/platform/s5p-fimc/fimc-lite.c |    1 -
 drivers/media/platform/s5p-fimc/fimc-lite.h |    3 +--
 include/media/s5p_fimc.h                    |   34 +++++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index d95aa66..6e2fa1a 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -40,7 +40,6 @@
 #define DMA_MIN_SIZE		8
 #define FIMC_CAMIF_MAX_HEIGHT	0x2000
 #define FIMC_MAX_JPEG_BUF_SIZE	(10 * SZ_1M)
-#define FIMC_MAX_PLANES		3
 #define FIMC_PIX_LIMITS_MAX	6
 #define FIMC_DEF_MIN_SIZE	16
 #define FIMC_DEF_HEIGHT_ALIGN	2
@@ -138,37 +137,6 @@ enum fimc_color_fmt {
 #define	FIMC_COLOR_RANGE_NARROW		(1 << 3)
 
 /**
- * struct fimc_fmt - the driver's internal color format data
- * @mbus_code: Media Bus pixel code, -1 if not applicable
- * @name: format description
- * @fourcc: the fourcc code for this format, 0 if not applicable
- * @color: the corresponding fimc_color_fmt
- * @memplanes: number of physically non-contiguous data planes
- * @colplanes: number of physically contiguous data planes
- * @depth: per plane driver's private 'number of bits per pixel'
- * @mdataplanes: bitmask indicating meta data plane(s), (1 << plane_no)
- * @flags: flags indicating which operation mode format applies to
- */
-struct fimc_fmt {
-	enum v4l2_mbus_pixelcode mbus_code;
-	char	*name;
-	u32	fourcc;
-	u32	color;
-	u16	memplanes;
-	u16	colplanes;
-	u8	depth[VIDEO_MAX_PLANES];
-	u16	mdataplanes;
-	u16	flags;
-#define FMT_FLAGS_CAM		(1 << 0)
-#define FMT_FLAGS_M2M_IN	(1 << 1)
-#define FMT_FLAGS_M2M_OUT	(1 << 2)
-#define FMT_FLAGS_M2M		(1 << 1 | 1 << 2)
-#define FMT_HAS_ALPHA		(1 << 3)
-#define FMT_FLAGS_COMPRESSED	(1 << 4)
-#define FMT_FLAGS_WRITEBACK	(1 << 5)
-};
-
-/**
  * struct fimc_dma_offset - pixel offset information for DMA
  * @y_h:	y value horizontal offset
  * @y_v:	y value vertical offset
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 97050ee..412fcb8 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -32,7 +32,6 @@
 #include <media/s5p_fimc.h>
 
 #include "fimc-mdevice.h"
-#include "fimc-core.h"
 #include "fimc-lite.h"
 #include "fimc-lite-reg.h"
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
index 7085761..4c234508 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.h
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
@@ -20,12 +20,11 @@
 
 #include <media/media-entity.h>
 #include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
 #include <media/s5p_fimc.h>
 
-#include "fimc-core.h"
-
 #define FIMC_LITE_DRV_NAME	"exynos-fimc-lite"
 #define FLITE_CLK_NAME		"flite"
 #define FIMC_LITE_MAX_DEVS	2
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index e2434bb..2363aff 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -13,6 +13,7 @@
 #define S5P_FIMC_H_
 
 #include <media/media-entity.h>
+#include <media/v4l2-mediabus.h>
 
 /*
  * Enumeration of data inputs to the camera subsystem.
@@ -93,6 +94,39 @@ struct s5p_platform_fimc {
  */
 #define S5P_FIMC_TX_END_NOTIFY _IO('e', 0)
 
+#define FIMC_MAX_PLANES	3
+
+/**
+ * struct fimc_fmt - color format data structure
+ * @mbus_code: media bus pixel code, -1 if not applicable
+ * @name: format description
+ * @fourcc: fourcc code for this format, 0 if not applicable
+ * @color: the driver's private color format id
+ * @memplanes: number of physically non-contiguous data planes
+ * @colplanes: number of physically contiguous data planes
+ * @depth: per plane driver's private 'number of bits per pixel'
+ * @mdataplanes: bitmask indicating meta data plane(s), (1 << plane_no)
+ * @flags: flags indicating which operation mode format applies to
+ */
+struct fimc_fmt {
+	enum v4l2_mbus_pixelcode mbus_code;
+	char	*name;
+	u32	fourcc;
+	u32	color;
+	u16	memplanes;
+	u16	colplanes;
+	u8	depth[FIMC_MAX_PLANES];
+	u16	mdataplanes;
+	u16	flags;
+#define FMT_FLAGS_CAM		(1 << 0)
+#define FMT_FLAGS_M2M_IN	(1 << 1)
+#define FMT_FLAGS_M2M_OUT	(1 << 2)
+#define FMT_FLAGS_M2M		(1 << 1 | 1 << 2)
+#define FMT_HAS_ALPHA		(1 << 3)
+#define FMT_FLAGS_COMPRESSED	(1 << 4)
+#define FMT_FLAGS_WRITEBACK	(1 << 5)
+};
+
 enum fimc_subdev_index {
 	IDX_SENSOR,
 	IDX_CSIS,
-- 
1.7.9.5

