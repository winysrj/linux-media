Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:35651 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaDORgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 13:36:37 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/5] exynos4-is: Remove support for non-dt platforms
Date: Tue, 15 Apr 2014 19:34:30 +0200
Message-id: <1397583272-28295-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1397583272-28295-1-git-send-email-s.nawrocki@samsung.com>
References: <1397583272-28295-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All platforms supported by this driver are going to get device tree
support in this kernel release so remove code that would have been
actually not used any more.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/video4linux/fimc.txt                 |   30 --
 MAINTAINERS                                        |    1 -
 drivers/media/platform/exynos4-is/Kconfig          |    3 +-
 drivers/media/platform/exynos4-is/common.c         |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-reg.c       |    2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  329 ++------------------
 drivers/media/platform/exynos4-is/media-dev.h      |    6 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   43 +--
 include/linux/platform_data/mipi-csis.h            |   28 --
 include/media/{s5p_fimc.h => exynos-fimc.h}        |   21 --
 16 files changed, 50 insertions(+), 427 deletions(-)
 delete mode 100644 include/linux/platform_data/mipi-csis.h
 rename include/media/{s5p_fimc.h => exynos-fimc.h} (87%)

diff --git a/Documentation/video4linux/fimc.txt b/Documentation/video4linux/fimc.txt
index 7d6e160..e0c6b8b 100644
--- a/Documentation/video4linux/fimc.txt
+++ b/Documentation/video4linux/fimc.txt
@@ -140,39 +140,9 @@ You can either grep through the kernel log to find relevant information, i.e.
 or retrieve the information from /dev/media? with help of the media-ctl tool:
 # media-ctl -p
 
-6. Platform support
-===================
-
-The machine code (arch/arm/plat-samsung and arch/arm/mach-*) must select
-following options:
-
-CONFIG_S5P_DEV_FIMC0       mandatory
-CONFIG_S5P_DEV_FIMC1  \
-CONFIG_S5P_DEV_FIMC2  |    optional
-CONFIG_S5P_DEV_FIMC3  |
-CONFIG_S5P_SETUP_FIMC /
-CONFIG_S5P_DEV_CSIS0  \    optional for MIPI-CSI interface
-CONFIG_S5P_DEV_CSIS1  /
-
-Except that, relevant s5p_device_fimc? should be registered in the machine code
-in addition to a "s5p-fimc-md" platform device to which the media device driver
-is bound.  The "s5p-fimc-md" device instance is required even if only mem-to-mem
-operation is used.
-
-The description of sensor(s) attached to FIMC/MIPI-CSIS camera inputs should be
-passed as the "s5p-fimc-md" device platform_data.  The platform data structure
-is defined in file include/media/s5p_fimc.h.
-
 7. Build
 ========
 
-This driver depends on following config options:
-PLAT_S5P,
-PM_RUNTIME,
-I2C,
-REGULATOR,
-VIDEO_V4L2_SUBDEV_API,
-
 If the driver is built as a loadable kernel module (CONFIG_VIDEO_SAMSUNG_S5P_FIMC=m)
 two modules are created (in addition to the core v4l2 modules): s5p-fimc.ko and
 optional s5p-csis.ko (MIPI-CSI receiver subdev).
diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1..e2f5dfe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7641,7 +7641,6 @@ L:	linux-media@vger.kernel.org
 Q:	https://patchwork.linuxtv.org/project/linux-media/list/
 S:	Supported
 F:	drivers/media/platform/exynos4-is/
-F:	include/media/s5p_fimc.h
 
 SAMSUNG S3C24XX/S3C64XX SOC SERIES CAMIF DRIVER
 M:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index e1b2ceb..5dcaa0a 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_SAMSUNG_EXYNOS4_IS
 	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on (PLAT_S5P || ARCH_EXYNOS)
+	depends on OF && COMMON_CLK
 	help
 	  Say Y here to enable camera host interface devices for
 	  Samsung S5P and EXYNOS SoC series.
@@ -17,7 +18,7 @@ config VIDEO_S5P_FIMC
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	select MFD_SYSCON if OF
+	select MFD_SYSCON
 	select VIDEO_EXYNOS4_IS_COMMON
 	help
 	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC camera host
diff --git a/drivers/media/platform/exynos4-is/common.c b/drivers/media/platform/exynos4-is/common.c
index 0ec210b..0eb34ec 100644
--- a/drivers/media/platform/exynos4-is/common.c
+++ b/drivers/media/platform/exynos4-is/common.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/module.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 #include "common.h"
 
 /* Called with the media graph mutex held or entity->stream_count > 0. */
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 1790fb4..6c75c6c 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -27,7 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-mediabus.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 
 #define dbg(fmt, args...) \
 	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index e92b4e1..3846613 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 
 #include "common.h"
 #include "media-dev.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index 4dc55a1..b99be09 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -24,7 +24,7 @@
 #include <media/videobuf2-core.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 
 extern int fimc_isp_debug;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index d0dc7ee..bc3ec7d 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -12,7 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 
 #include "fimc-lite-reg.h"
 #include "fimc-lite.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 3ad660b..9527e36 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 
 #include "common.h"
 #include "fimc-core.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 7428b2d..ea19dc7 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -23,7 +23,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 
 #define FIMC_LITE_DRV_NAME	"exynos-fimc-lite"
 #define FLITE_CLK_NAME		"flite"
diff --git a/drivers/media/platform/exynos4-is/fimc-reg.c b/drivers/media/platform/exynos4-is/fimc-reg.c
index 1db8cb4..2d77fd8 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -13,7 +13,7 @@
 #include <linux/io.h>
 #include <linux/regmap.h>
 
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 #include "media-dev.h"
 
 #include "fimc-reg.h"
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 002abbf..0b64ec8 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-of.h>
 #include <media/media-device.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 
 #include "media-dev.h"
 #include "fimc-core.h"
@@ -39,10 +39,6 @@
 #include "fimc-lite.h"
 #include "mipi-csis.h"
 
-static int __fimc_md_set_camclk(struct fimc_md *fmd,
-				struct fimc_source_info *si,
-				bool on);
-
 /* Set up image sensor subdev -> FIMC capture node notifications. */
 static void __setup_sensor_notification(struct fimc_md *fmd,
 					struct v4l2_subdev *sensor,
@@ -226,17 +222,10 @@ static int __fimc_pipeline_open(struct exynos_media_pipeline *ep,
 			return ret;
 	}
 
-	ret = fimc_md_set_camclk(sd, true);
-	if (ret < 0)
-		goto err_wbclk;
-
 	ret = fimc_pipeline_s_power(p, 1);
 	if (!ret)
 		return 0;
 
-	fimc_md_set_camclk(sd, false);
-
-err_wbclk:
 	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP])
 		clk_disable_unprepare(fmd->wbclk[CLK_IDX_WB_B]);
 
@@ -262,7 +251,6 @@ static int __fimc_pipeline_close(struct exynos_media_pipeline *ep)
 	}
 
 	ret = fimc_pipeline_s_power(p, 0);
-	fimc_md_set_camclk(sd, false);
 
 	fmd = entity_to_fimc_mdev(&sd->entity);
 
@@ -340,75 +328,14 @@ static void fimc_md_pipelines_free(struct fimc_md *fmd)
 	}
 }
 
-/*
- * Sensor subdevice helper functions
- */
-static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
-						struct fimc_source_info *si)
-{
-	struct i2c_adapter *adapter;
-	struct v4l2_subdev *sd = NULL;
-
-	if (!si || !fmd)
-		return NULL;
-	/*
-	 * If FIMC bus type is not Writeback FIFO assume it is same
-	 * as sensor_bus_type.
-	 */
-	si->fimc_bus_type = si->sensor_bus_type;
-
-	adapter = i2c_get_adapter(si->i2c_bus_num);
-	if (!adapter) {
-		v4l2_warn(&fmd->v4l2_dev,
-			  "Failed to get I2C adapter %d, deferring probe\n",
-			  si->i2c_bus_num);
-		return ERR_PTR(-EPROBE_DEFER);
-	}
-	sd = v4l2_i2c_new_subdev_board(&fmd->v4l2_dev, adapter,
-						si->board_info, NULL);
-	if (IS_ERR_OR_NULL(sd)) {
-		i2c_put_adapter(adapter);
-		v4l2_warn(&fmd->v4l2_dev,
-			  "Failed to acquire subdev %s, deferring probe\n",
-			  si->board_info->type);
-		return ERR_PTR(-EPROBE_DEFER);
-	}
-	v4l2_set_subdev_hostdata(sd, si);
-	sd->grp_id = GRP_ID_SENSOR;
-
-	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
-		  sd->name);
-	return sd;
-}
-
-static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct i2c_adapter *adapter;
-
-	if (!client || client->dev.of_node)
-		return;
-
-	v4l2_device_unregister_subdev(sd);
-
-	adapter = client->adapter;
-	i2c_unregister_device(client);
-	if (adapter)
-		i2c_put_adapter(adapter);
-}
-
-#ifdef CONFIG_OF
 /* Parse port node and register as a sub-device any sensor specified there. */
 static int fimc_md_parse_port_node(struct fimc_md *fmd,
 				   struct device_node *port,
 				   unsigned int index)
 {
+	struct fimc_source_info *pd = &fmd->sensor[index].pdata;
 	struct device_node *rem, *ep, *np;
-	struct fimc_source_info *pd;
 	struct v4l2_of_endpoint endpoint;
-	u32 val;
-
-	pd = &fmd->sensor[index].pdata;
 
 	/* Assume here a port node can have only one endpoint node. */
 	ep = of_get_next_child(port, NULL);
@@ -428,20 +355,6 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 							ep->full_name);
 		return 0;
 	}
-	if (!of_property_read_u32(rem, "samsung,camclk-out", &val))
-		pd->clk_id = val;
-
-	if (!of_property_read_u32(rem, "clock-frequency", &val))
-		pd->clk_frequency = val;
-	else
-		pd->clk_frequency = DEFAULT_SENSOR_CLK_FREQ;
-
-	if (pd->clk_frequency == 0) {
-		v4l2_err(&fmd->v4l2_dev, "Wrong clock frequency at node %s\n",
-			 rem->full_name);
-		of_node_put(rem);
-		return -EINVAL;
-	}
 
 	if (fimc_input_is_parallel(endpoint.base.port)) {
 		if (endpoint.bus_type == V4L2_MBUS_PARALLEL)
@@ -488,14 +401,26 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 }
 
 /* Register all SoC external sub-devices */
-static int fimc_md_of_sensors_register(struct fimc_md *fmd,
-				       struct device_node *np)
+static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 {
 	struct device_node *parent = fmd->pdev->dev.of_node;
 	struct device_node *node, *ports;
 	int index = 0;
 	int ret;
 
+	/*
+	 * Runtime resume one of the FIMC entities to make sure
+	 * the sclk_cam clocks are not globally disabled.
+	 */
+	if (!fmd->pmf)
+		return -ENXIO;
+
+	ret = pm_runtime_get_sync(fmd->pmf);
+	if (ret < 0)
+		return ret;
+
+	fmd->num_sensors = 0;
+
 	/* Attach sensors linked to MIPI CSI-2 receivers */
 	for_each_available_child_of_node(parent, node) {
 		struct device_node *port;
@@ -509,14 +434,14 @@ static int fimc_md_of_sensors_register(struct fimc_md *fmd,
 
 		ret = fimc_md_parse_port_node(fmd, port, index);
 		if (ret < 0)
-			return ret;
+			goto rpm_put;
 		index++;
 	}
 
 	/* Attach sensors listed in the parallel-ports node */
 	ports = of_get_child_by_name(parent, "parallel-ports");
 	if (!ports)
-		return 0;
+		goto rpm_put;
 
 	for_each_child_of_node(ports, node) {
 		ret = fimc_md_parse_port_node(fmd, node, index);
@@ -524,8 +449,9 @@ static int fimc_md_of_sensors_register(struct fimc_md *fmd,
 			break;
 		index++;
 	}
-
-	return 0;
+rpm_put:
+	pm_runtime_put(fmd->pmf);
+	return ret;
 }
 
 static int __of_get_csis_id(struct device_node *np)
@@ -538,68 +464,10 @@ static int __of_get_csis_id(struct device_node *np)
 	of_property_read_u32(np, "reg", &reg);
 	return reg - FIMC_INPUT_MIPI_CSI2_0;
 }
-#else
-#define fimc_md_of_sensors_register(fmd, np) (-ENOSYS)
-#define __of_get_csis_id(np) (-ENOSYS)
-#endif
-
-static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
-{
-	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
-	struct device_node *of_node = fmd->pdev->dev.of_node;
-	int num_clients = 0;
-	int ret, i;
-
-	/*
-	 * Runtime resume one of the FIMC entities to make sure
-	 * the sclk_cam clocks are not globally disabled.
-	 */
-	if (!fmd->pmf)
-		return -ENXIO;
-
-	ret = pm_runtime_get_sync(fmd->pmf);
-	if (ret < 0)
-		return ret;
-
-	if (of_node) {
-		fmd->num_sensors = 0;
-		ret = fimc_md_of_sensors_register(fmd, of_node);
-	} else if (pdata) {
-		WARN_ON(pdata->num_clients > ARRAY_SIZE(fmd->sensor));
-		num_clients = min_t(u32, pdata->num_clients,
-				    ARRAY_SIZE(fmd->sensor));
-		fmd->num_sensors = num_clients;
-
-		for (i = 0; i < num_clients; i++) {
-			struct fimc_sensor_info *si = &fmd->sensor[i];
-			struct v4l2_subdev *sd;
-
-			si->pdata = pdata->source_info[i];
-			ret = __fimc_md_set_camclk(fmd, &si->pdata, true);
-			if (ret)
-				break;
-			sd = fimc_md_register_sensor(fmd, &si->pdata);
-			ret = __fimc_md_set_camclk(fmd, &si->pdata, false);
-
-			if (IS_ERR(sd)) {
-				si->subdev = NULL;
-				ret = PTR_ERR(sd);
-				break;
-			}
-			si->subdev = sd;
-			if (ret)
-				break;
-		}
-	}
-
-	pm_runtime_put(fmd->pmf);
-	return ret;
-}
 
 /*
  * MIPI-CSIS, FIMC and FIMC-LITE platform devices registration.
  */
-
 static int register_fimc_lite_entity(struct fimc_md *fmd,
 				     struct fimc_lite *fimc_lite)
 {
@@ -756,35 +624,9 @@ dev_unlock:
 	return ret;
 }
 
-static int fimc_md_pdev_match(struct device *dev, void *data)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	int plat_entity = -1;
-	int ret;
-	char *p;
-
-	if (!get_device(dev))
-		return -ENODEV;
-
-	if (!strcmp(pdev->name, CSIS_DRIVER_NAME)) {
-		plat_entity = IDX_CSIS;
-	} else {
-		p = strstr(pdev->name, "fimc");
-		if (p && *(p + 4) == 0)
-			plat_entity = IDX_FIMC;
-	}
-
-	if (plat_entity >= 0)
-		ret = fimc_md_register_platform_entity(data, pdev,
-						       plat_entity);
-	put_device(dev);
-	return 0;
-}
-
 /* Register FIMC, FIMC-LITE and CSIS media entities */
-#ifdef CONFIG_OF
-static int fimc_md_register_of_platform_entities(struct fimc_md *fmd,
-						 struct device_node *parent)
+static int fimc_md_register_platform_entities(struct fimc_md *fmd,
+					      struct device_node *parent)
 {
 	struct device_node *node;
 	int ret = 0;
@@ -818,9 +660,6 @@ static int fimc_md_register_of_platform_entities(struct fimc_md *fmd,
 
 	return ret;
 }
-#else
-#define fimc_md_register_of_platform_entities(fmd, node) (-ENOSYS)
-#endif
 
 static void fimc_md_unregister_entities(struct fimc_md *fmd)
 {
@@ -848,14 +687,6 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		v4l2_device_unregister_subdev(fmd->csis[i].sd);
 		fmd->csis[i].sd = NULL;
 	}
-	if (fmd->pdev->dev.of_node == NULL) {
-		for (i = 0; i < fmd->num_sensors; i++) {
-			if (fmd->sensor[i].subdev == NULL)
-				continue;
-			fimc_md_unregister_sensor(fmd->sensor[i].subdev);
-			fmd->sensor[i].subdev = NULL;
-		}
-	}
 
 	if (fmd->fimc_is)
 		v4l2_device_unregister_subdev(&fmd->fimc_is->isp.subdev);
@@ -1140,7 +971,7 @@ static void fimc_md_put_clocks(struct fimc_md *fmd)
 
 static int fimc_md_get_clocks(struct fimc_md *fmd)
 {
-	struct device *dev = NULL;
+	struct device *dev = &fmd->pdev->dev;
 	char clk_name[32];
 	struct clk *clock;
 	int i, ret = 0;
@@ -1148,16 +979,12 @@ static int fimc_md_get_clocks(struct fimc_md *fmd)
 	for (i = 0; i < FIMC_MAX_CAMCLKS; i++)
 		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
 
-	if (fmd->pdev->dev.of_node)
-		dev = &fmd->pdev->dev;
-
 	for (i = 0; i < FIMC_MAX_CAMCLKS; i++) {
 		snprintf(clk_name, sizeof(clk_name), "sclk_cam%u", i);
 		clock = clk_get(dev, clk_name);
 
 		if (IS_ERR(clock)) {
-			dev_err(&fmd->pdev->dev, "Failed to get clock: %s\n",
-								clk_name);
+			dev_err(dev, "Failed to get clock: %s\n", clk_name);
 			ret = PTR_ERR(clock);
 			break;
 		}
@@ -1191,86 +1018,6 @@ static int fimc_md_get_clocks(struct fimc_md *fmd)
 	return ret;
 }
 
-static int __fimc_md_set_camclk(struct fimc_md *fmd,
-				struct fimc_source_info *si,
-				bool on)
-{
-	struct fimc_camclk_info *camclk;
-	int ret = 0;
-
-	/*
-	 * When device tree is used the sensor drivers are supposed to
-	 * control the clock themselves. This whole function will be
-	 * removed once S5PV210 platform is converted to the device tree.
-	 */
-	if (fmd->pdev->dev.of_node)
-		return 0;
-
-	if (WARN_ON(si->clk_id >= FIMC_MAX_CAMCLKS) || !fmd || !fmd->pmf)
-		return -EINVAL;
-
-	camclk = &fmd->camclk[si->clk_id];
-
-	dbg("camclk %d, f: %lu, use_count: %d, on: %d",
-	    si->clk_id, si->clk_frequency, camclk->use_count, on);
-
-	if (on) {
-		if (camclk->use_count > 0 &&
-		    camclk->frequency != si->clk_frequency)
-			return -EINVAL;
-
-		if (camclk->use_count++ == 0) {
-			clk_set_rate(camclk->clock, si->clk_frequency);
-			camclk->frequency = si->clk_frequency;
-			ret = pm_runtime_get_sync(fmd->pmf);
-			if (ret < 0)
-				return ret;
-			ret = clk_prepare_enable(camclk->clock);
-			dbg("Enabled camclk %d: f: %lu", si->clk_id,
-			    clk_get_rate(camclk->clock));
-		}
-		return ret;
-	}
-
-	if (WARN_ON(camclk->use_count == 0))
-		return 0;
-
-	if (--camclk->use_count == 0) {
-		clk_disable_unprepare(camclk->clock);
-		pm_runtime_put(fmd->pmf);
-		dbg("Disabled camclk %d", si->clk_id);
-	}
-	return ret;
-}
-
-/**
- * fimc_md_set_camclk - peripheral sensor clock setup
- * @sd: sensor subdev to configure sclk_cam clock for
- * @on: 1 to enable or 0 to disable the clock
- *
- * There are 2 separate clock outputs available in the SoC for external
- * image processors. These clocks are shared between all registered FIMC
- * devices to which sensors can be attached, either directly or through
- * the MIPI CSI receiver. The clock is allowed here to be used by
- * multiple sensors concurrently if they use same frequency.
- * This function should only be called when the graph mutex is held.
- */
-int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
-{
-	struct fimc_source_info *si = v4l2_get_subdev_hostdata(sd);
-	struct fimc_md *fmd = entity_to_fimc_mdev(&sd->entity);
-
-	/*
-	 * If there is a clock provider registered the sensors will
-	 * handle their clock themselves, no need to control it on
-	 * the host interface side.
-	 */
-	if (fmd->clk_provider.num_clocks > 0)
-		return 0;
-
-	return __fimc_md_set_camclk(fmd, si, on);
-}
-
 static int __fimc_md_modify_pipeline(struct media_entity *entity, bool enable)
 {
 	struct exynos_video_entity *ve;
@@ -1429,7 +1176,6 @@ static int fimc_md_get_pinctrl(struct fimc_md *fmd)
 	return 0;
 }
 
-#ifdef CONFIG_OF
 static int cam_clk_prepare(struct clk_hw *hw)
 {
 	struct cam_clk *camclk = to_cam_clk(hw);
@@ -1521,10 +1267,6 @@ err:
 	fimc_md_unregister_clk_provider(fmd);
 	return ret;
 }
-#else
-#define fimc_md_register_clk_provider(fmd) (0)
-#define fimc_md_unregister_clk_provider(fmd)
-#endif
 
 static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 				 struct v4l2_subdev *subdev,
@@ -1588,8 +1330,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	spin_lock_init(&fmd->slock);
-	fmd->pdev = pdev;
 	INIT_LIST_HEAD(&fmd->pipelines);
+	fmd->pdev = pdev;
 
 	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
 		sizeof(fmd->media_dev.model));
@@ -1602,6 +1344,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
 
 	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
+	fmd->user_subdev_api = true;
 
 	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
@@ -1619,8 +1362,6 @@ static int fimc_md_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_md;
 
-	fmd->user_subdev_api = (dev->of_node != NULL);
-
 	ret = fimc_md_get_pinctrl(fmd);
 	if (ret < 0) {
 		if (ret != EPROBE_DEFER)
@@ -1633,22 +1374,16 @@ static int fimc_md_probe(struct platform_device *pdev)
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
-	if (dev->of_node)
-		ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
-	else
-		ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
-						fimc_md_pdev_match);
+	ret = fimc_md_register_platform_entities(fmd, dev->of_node);
 	if (ret) {
 		mutex_unlock(&fmd->media_dev.graph_mutex);
 		goto err_clk;
 	}
 
-	if (dev->platform_data || dev->of_node) {
-		ret = fimc_md_register_sensor_entities(fmd);
-		if (ret) {
-			mutex_unlock(&fmd->media_dev.graph_mutex);
-			goto err_m_ent;
-		}
+	ret = fimc_md_register_sensor_entities(fmd);
+	if (ret) {
+		mutex_unlock(&fmd->media_dev.graph_mutex);
+		goto err_m_ent;
 	}
 
 	mutex_unlock(&fmd->media_dev.graph_mutex);
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 58c4945..0321454 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -19,7 +19,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 
 #include "fimc-core.h"
 #include "fimc-lite.h"
@@ -94,9 +94,7 @@ struct fimc_sensor_info {
 };
 
 struct cam_clk {
-#ifdef CONFIG_COMMON_CLK
 	struct clk_hw hw;
-#endif
 	struct fimc_md *fmd;
 };
 #define to_cam_clk(_hw) container_of(_hw, struct cam_clk, hw)
@@ -144,9 +142,7 @@ struct fimc_md {
 
 	struct cam_clk_provider {
 		struct clk *clks[FIMC_MAX_CAMCLKS];
-#ifdef CONFIG_COMMON_CLK
 		struct clk_onecell_data clk_data;
-#endif
 		struct device_node *of_node;
 		struct cam_clk camclk[FIMC_MAX_CAMCLKS];
 		int num_clocks;
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index ddbbb81..e15df4c 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -22,14 +22,13 @@
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/phy/phy.h>
-#include <linux/platform_data/mipi-csis.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 #include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 
@@ -744,26 +743,6 @@ static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int s5pcsis_get_platform_data(struct platform_device *pdev,
-				     struct csis_state *state)
-{
-	struct s5p_platform_mipi_csis *pdata = pdev->dev.platform_data;
-
-	if (pdata == NULL) {
-		dev_err(&pdev->dev, "Platform data not specified\n");
-		return -EINVAL;
-	}
-
-	state->clk_frequency = pdata->clk_rate;
-	state->num_lanes = pdata->lanes;
-	state->hs_settle = pdata->hs_settle;
-	state->index = max(0, pdev->id);
-	state->max_num_lanes = state->index ? CSIS1_MAX_LANES :
-					      CSIS0_MAX_LANES;
-	return 0;
-}
-
-#ifdef CONFIG_OF
 static int s5pcsis_parse_dt(struct platform_device *pdev,
 			    struct csis_state *state)
 {
@@ -801,9 +780,6 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 
 	return 0;
 }
-#else
-#define s5pcsis_parse_dt(pdev, state) (-ENOSYS)
-#endif
 
 static const struct of_device_id s5pcsis_of_match[];
 
@@ -825,19 +801,14 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	spin_lock_init(&state->slock);
 	state->pdev = pdev;
 
-	if (dev->of_node) {
-		of_id = of_match_node(s5pcsis_of_match, dev->of_node);
-		if (WARN_ON(of_id == NULL))
-			return -EINVAL;
-
-		drv_data = of_id->data;
-		state->interrupt_mask = drv_data->interrupt_mask;
+	of_id = of_match_node(s5pcsis_of_match, dev->of_node);
+	if (WARN_ON(of_id == NULL))
+		return -EINVAL;
 
-		ret = s5pcsis_parse_dt(pdev, state);
-	} else {
-		ret = s5pcsis_get_platform_data(pdev, state);
-	}
+	drv_data = of_id->data;
+	state->interrupt_mask = drv_data->interrupt_mask;
 
+	ret = s5pcsis_parse_dt(pdev, state);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/linux/platform_data/mipi-csis.h b/include/linux/platform_data/mipi-csis.h
deleted file mode 100644
index c2fd902..0000000
--- a/include/linux/platform_data/mipi-csis.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
- *
- * Samsung S5P/Exynos SoC series MIPI CSIS device support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __PLAT_SAMSUNG_MIPI_CSIS_H_
-#define __PLAT_SAMSUNG_MIPI_CSIS_H_ __FILE__
-
-/**
- * struct s5p_platform_mipi_csis - platform data for S5P MIPI-CSIS driver
- * @clk_rate:    bus clock frequency
- * @wclk_source: CSI wrapper clock selection: 0 - bus clock, 1 - ext. SCLK_CAM
- * @lanes:       number of data lanes used
- * @hs_settle:   HS-RX settle time
- */
-struct s5p_platform_mipi_csis {
-	unsigned long clk_rate;
-	u8 wclk_source;
-	u8 lanes;
-	u8 hs_settle;
-};
-
-#endif /* __PLAT_SAMSUNG_MIPI_CSIS_H_ */
diff --git a/include/media/s5p_fimc.h b/include/media/exynos-fimc.h
similarity index 87%
rename from include/media/s5p_fimc.h
rename to include/media/exynos-fimc.h
index b975c28..aa44660 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/exynos-fimc.h
@@ -61,41 +61,20 @@ enum fimc_bus_type {
 #define GRP_ID_FLITE		(1 << 13)
 #define GRP_ID_FIMC_IS		(1 << 14)
 
-struct i2c_board_info;
-
 /**
  * struct fimc_source_info - video source description required for the host
  *			     interface configuration
  *
- * @board_info: pointer to I2C subdevice's board info
- * @clk_frequency: frequency of the clock the host interface provides to sensor
  * @fimc_bus_type: FIMC camera input type
  * @sensor_bus_type: image sensor bus type, MIPI, ITU-R BT.601 etc.
  * @flags: the parallel sensor bus flags defining signals polarity (V4L2_MBUS_*)
- * @i2c_bus_num: i2c control bus id the sensor is attached to
  * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
- * @clk_id: index of the SoC peripheral clock for sensors
  */
 struct fimc_source_info {
-	struct i2c_board_info *board_info;
-	unsigned long clk_frequency;
 	enum fimc_bus_type fimc_bus_type;
 	enum fimc_bus_type sensor_bus_type;
 	u16 flags;
-	u16 i2c_bus_num;
 	u16 mux_id;
-	u8 clk_id;
-};
-
-/**
- * struct s5p_platform_fimc - camera host interface platform data
- *
- * @source_info: properties of an image source for the host interface setup
- * @num_clients: the number of attached image sources
- */
-struct s5p_platform_fimc {
-	struct fimc_source_info *source_info;
-	int num_clients;
 };
 
 /*
-- 
1.7.9.5

