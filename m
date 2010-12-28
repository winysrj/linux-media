Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20175 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0L1RDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:25 -0500
Date: Tue, 28 Dec 2010 18:03:12 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 07/15] [media] s5p-fimc: Rename s3c_fimc* to s5p_fimc*
In-reply-to: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-8-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Change s3c_fimc.h header file name to s5p_fimc.h, replace s3c_fimc_*
names with s5p_fimc_*. s3c_fimc need to be reserved for S3C series
and s5p-fimc driver will not cover CAMIF devices in S3C SoC series.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   16 ++++----
 drivers/media/video/s5p-fimc/fimc-core.h    |   10 ++--
 drivers/media/video/s5p-fimc/fimc-reg.c     |    8 ++--
 include/media/s3c_fimc.h                    |   60 ---------------------------
 include/media/s5p_fimc.h                    |   60 +++++++++++++++++++++++++++
 5 files changed, 77 insertions(+), 77 deletions(-)
 delete mode 100644 include/media/s3c_fimc.h
 create mode 100644 include/media/s5p_fimc.h

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 4e4441f..431ec8e 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -33,7 +33,7 @@
 #include "fimc-core.h"
 
 static struct v4l2_subdev *fimc_subdev_register(struct fimc_dev *fimc,
-					    struct s3c_fimc_isp_info *isp_info)
+					    struct s5p_fimc_isp_info *isp_info)
 {
 	struct i2c_adapter *i2c_adap;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
@@ -86,8 +86,8 @@ static void fimc_subdev_unregister(struct fimc_dev *fimc)
 static int fimc_subdev_attach(struct fimc_dev *fimc, int index)
 {
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
-	struct s3c_platform_fimc *pdata = fimc->pdata;
-	struct s3c_fimc_isp_info *isp_info;
+	struct s5p_platform_fimc *pdata = fimc->pdata;
+	struct s5p_fimc_isp_info *isp_info;
 	struct v4l2_subdev *sd;
 	int i;
 
@@ -115,7 +115,7 @@ static int fimc_subdev_attach(struct fimc_dev *fimc, int index)
 
 static int fimc_isp_subdev_init(struct fimc_dev *fimc, int index)
 {
-	struct s3c_fimc_isp_info *isp_info;
+	struct s5p_fimc_isp_info *isp_info;
 	int ret;
 
 	ret = fimc_subdev_attach(fimc, index);
@@ -209,7 +209,7 @@ static int start_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct s3c_fimc_isp_info *isp_info;
+	struct s5p_fimc_isp_info *isp_info;
 	int ret;
 
 	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
@@ -558,8 +558,8 @@ static int fimc_cap_enum_input(struct file *file, void *priv,
 				     struct v4l2_input *i)
 {
 	struct fimc_ctx *ctx = priv;
-	struct s3c_platform_fimc *pldata = ctx->fimc_dev->pdata;
-	struct s3c_fimc_isp_info *isp_info;
+	struct s5p_platform_fimc *pldata = ctx->fimc_dev->pdata;
+	struct s5p_fimc_isp_info *isp_info;
 
 	if (i->index >= FIMC_MAX_CAMIF_CLIENTS)
 		return -EINVAL;
@@ -578,7 +578,7 @@ static int fimc_cap_s_input(struct file *file, void *priv,
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct s3c_platform_fimc *pdata = fimc->pdata;
+	struct s5p_platform_fimc *pdata = fimc->pdata;
 
 	if (fimc_capture_active(ctx->fimc_dev))
 		return -EBUSY;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 1f1beaa..6431d1a 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -21,7 +21,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-mediabus.h>
-#include <media/s3c_fimc.h>
+#include <media/s5p_fimc.h>
 
 #include "regs-fimc.h"
 
@@ -422,7 +422,7 @@ struct fimc_dev {
 	spinlock_t			slock;
 	struct mutex			lock;
 	struct platform_device		*pdev;
-	struct s3c_platform_fimc	*pdata;
+	struct s5p_platform_fimc	*pdata;
 	struct samsung_fimc_variant	*variant;
 	int				id;
 	struct clk			*clock[NUM_FIMC_CLOCKS];
@@ -584,12 +584,12 @@ void fimc_hw_set_input_addr(struct fimc_dev *fimc, struct fimc_addr *paddr);
 void fimc_hw_set_output_addr(struct fimc_dev *fimc, struct fimc_addr *paddr,
 			     int index);
 int fimc_hw_set_camera_source(struct fimc_dev *fimc,
-			      struct s3c_fimc_isp_info *cam);
+			      struct s5p_fimc_isp_info *cam);
 int fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f);
 int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
-				struct s3c_fimc_isp_info *cam);
+				struct s5p_fimc_isp_info *cam);
 int fimc_hw_set_camera_type(struct fimc_dev *fimc,
-			    struct s3c_fimc_isp_info *cam);
+			    struct s5p_fimc_isp_info *cam);
 
 /* -----------------------------------------------------*/
 /* fimc-core.c */
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 5ed8f06..ae33bc1 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -13,7 +13,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <mach/map.h>
-#include <media/s3c_fimc.h>
+#include <media/s5p_fimc.h>
 
 #include "fimc-core.h"
 
@@ -532,7 +532,7 @@ void fimc_hw_set_output_addr(struct fimc_dev *dev,
 }
 
 int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
-				struct s3c_fimc_isp_info *cam)
+				struct s5p_fimc_isp_info *cam)
 {
 	u32 cfg = readl(fimc->regs + S5P_CIGCTRL);
 
@@ -557,7 +557,7 @@ int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
 }
 
 int fimc_hw_set_camera_source(struct fimc_dev *fimc,
-			      struct s3c_fimc_isp_info *cam)
+			      struct s5p_fimc_isp_info *cam)
 {
 	struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
 	u32 cfg = 0;
@@ -624,7 +624,7 @@ int fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f)
 }
 
 int fimc_hw_set_camera_type(struct fimc_dev *fimc,
-			    struct s3c_fimc_isp_info *cam)
+			    struct s5p_fimc_isp_info *cam)
 {
 	u32 cfg, tmp;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
diff --git a/include/media/s3c_fimc.h b/include/media/s3c_fimc.h
deleted file mode 100644
index ca1b673..0000000
--- a/include/media/s3c_fimc.h
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Samsung S5P SoC camera interface driver header
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd
- * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef S3C_FIMC_H_
-#define S3C_FIMC_H_
-
-enum cam_bus_type {
-	FIMC_ITU_601 = 1,
-	FIMC_ITU_656,
-	FIMC_MIPI_CSI2,
-	FIMC_LCD_WB, /* FIFO link from LCD mixer */
-};
-
-#define FIMC_CLK_INV_PCLK	(1 << 0)
-#define FIMC_CLK_INV_VSYNC	(1 << 1)
-#define FIMC_CLK_INV_HREF	(1 << 2)
-#define FIMC_CLK_INV_HSYNC	(1 << 3)
-
-struct i2c_board_info;
-
-/**
- * struct s3c_fimc_isp_info - image sensor information required for host
- *			      interace configuration.
- *
- * @board_info: pointer to I2C subdevice's board info
- * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
- * @i2c_bus_num: i2c control bus id the sensor is attached to
- * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
- * @bus_width: camera data bus width in bits
- * @flags: flags defining bus signals polarity inversion (High by default)
- */
-struct s3c_fimc_isp_info {
-	struct i2c_board_info *board_info;
-	enum cam_bus_type bus_type;
-	u16 i2c_bus_num;
-	u16 mux_id;
-	u16 bus_width;
-	u16 flags;
-};
-
-
-#define FIMC_MAX_CAMIF_CLIENTS	2
-
-/**
- * struct s3c_platform_fimc - camera host interface platform data
- *
- * @isp_info: properties of camera sensor required for host interface setup
- */
-struct s3c_platform_fimc {
-	struct s3c_fimc_isp_info *isp_info[FIMC_MAX_CAMIF_CLIENTS];
-};
-#endif /* S3C_FIMC_H_ */
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
new file mode 100644
index 0000000..eb8793f
--- /dev/null
+++ b/include/media/s5p_fimc.h
@@ -0,0 +1,60 @@
+/*
+ * Samsung S5P SoC camera interface driver header
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd
+ * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef S5P_FIMC_H_
+#define S5P_FIMC_H_
+
+enum cam_bus_type {
+	FIMC_ITU_601 = 1,
+	FIMC_ITU_656,
+	FIMC_MIPI_CSI2,
+	FIMC_LCD_WB, /* FIFO link from LCD mixer */
+};
+
+#define FIMC_CLK_INV_PCLK	(1 << 0)
+#define FIMC_CLK_INV_VSYNC	(1 << 1)
+#define FIMC_CLK_INV_HREF	(1 << 2)
+#define FIMC_CLK_INV_HSYNC	(1 << 3)
+
+struct i2c_board_info;
+
+/**
+ * struct s5p_fimc_isp_info - image sensor information required for host
+ *			      interace configuration.
+ *
+ * @board_info: pointer to I2C subdevice's board info
+ * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
+ * @i2c_bus_num: i2c control bus id the sensor is attached to
+ * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
+ * @bus_width: camera data bus width in bits
+ * @flags: flags defining bus signals polarity inversion (High by default)
+ */
+struct s5p_fimc_isp_info {
+	struct i2c_board_info *board_info;
+	enum cam_bus_type bus_type;
+	u16 i2c_bus_num;
+	u16 mux_id;
+	u16 bus_width;
+	u16 flags;
+};
+
+
+#define FIMC_MAX_CAMIF_CLIENTS	2
+
+/**
+ * struct s5p_platform_fimc - camera host interface platform data
+ *
+ * @isp_info: properties of camera sensor required for host interface setup
+ */
+struct s5p_platform_fimc {
+	struct s5p_fimc_isp_info *isp_info[FIMC_MAX_CAMIF_CLIENTS];
+};
+#endif /* S5P_FIMC_H_ */
-- 
1.7.2.3

