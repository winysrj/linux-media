Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8840 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751947AbdBMNah (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 08:30:37 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 7/8] v4l: Improve header file ordering
Date: Mon, 13 Feb 2017 15:28:15 +0200
Message-Id: <1486992496-21078-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1486992496-21078-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1486992496-21078-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve header file ordering and remove a few duplicates and unnecessary
headers for drivers the header file ordering of which was adversely
affected by V4L2 OF to V4L2 fwnode API changes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/adv7604.c                   |  4 ++--
 drivers/media/i2c/s5c73m3/s5c73m3-core.c      |  4 ++--
 drivers/media/i2c/s5k5baf.c                   |  2 +-
 drivers/media/i2c/tc358743.c                  |  2 +-
 drivers/media/i2c/tvp514x.c                   | 10 +++++-----
 drivers/media/platform/atmel/atmel-isc.c      |  2 +-
 drivers/media/platform/exynos4-is/media-dev.c |  4 ++--
 drivers/media/platform/pxa_camera.c           |  2 +-
 drivers/media/platform/soc_camera/atmel-isi.c |  2 +-
 drivers/media/platform/ti-vpe/cal.c           |  7 ++-----
 10 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 9281e54..f821da5 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -40,12 +40,12 @@
 #include <linux/workqueue.h>
 #include <linux/regmap.h>
 
-#include <media/i2c/adv7604.h>
 #include <media/cec.h>
+#include <media/i2c/adv7604.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-dv-timings.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-fwnode.h>
 
 static int debug;
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index f434fb2..aa2f034 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -30,13 +30,13 @@
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 #include <linux/videodev2.h>
+#include <media/i2c/s5c73m3.h>
 #include <media/media-entity.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-mediabus.h>
-#include <media/i2c/s5c73m3.h>
-#include <media/v4l2-fwnode.h>
 
 #include "s5c73m3.h"
 
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 962051b..5eafc05 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -28,9 +28,9 @@
 #include <media/media-entity.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-mediabus.h>
-#include <media/v4l2-fwnode.h>
 
 static int debug;
 module_param(debug, int, 0644);
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 6a1b428..87c84c1 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -38,12 +38,12 @@
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
 #include <linux/hdmi.h>
+#include <media/i2c/tc358743.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-fwnode.h>
-#include <media/i2c/tc358743.h>
 
 #include "tc358743_regs.h"
 
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index ad2df99..92ac4ad 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -34,14 +34,14 @@
 #include <linux/of.h>
 #include <linux/of_graph.h>
 
+#include <media/i2c/tvp514x.h>
+#include <media/media-entity.h>
 #include <media/v4l2-async.h>
-#include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-mediabus.h>
-#include <media/v4l2-fwnode.h>
 #include <media/v4l2-ctrls.h>
-#include <media/i2c/tvp514x.h>
-#include <media/media-entity.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
+#include <media/v4l2-mediabus.h>
 
 #include "tvp514x_regs.h"
 
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 7af92e7..db97445 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -38,9 +38,9 @@
 #include <linux/videodev2.h>
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-image-sizes.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 #include <media/videobuf2-dma-contig.h>
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4a1808c..50bbd98 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -27,11 +27,11 @@
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <media/drv-intf/exynos-fimc.h>
+#include <media/media-device.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fwnode.h>
-#include <media/media-device.h>
-#include <media/drv-intf/exynos-fimc.h>
 
 #include "media-dev.h"
 #include "fimc-core.h"
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 1ad4cf9..69b06c6 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -39,8 +39,8 @@
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
 #include <media/v4l2-fwnode.h>
+#include <media/v4l2-ioctl.h>
 
 #include <media/videobuf2-dma-sg.h>
 
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index f9f2ad6..2640468 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -24,8 +24,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
-#include <media/soc_camera.h>
 #include <media/drv-intf/soc_mediabus.h>
+#include <media/soc_camera.h>
 #include <media/v4l2-fwnode.h>
 #include <media/videobuf2-dma-contig.h>
 
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index f72f541..5870f1e 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -21,17 +21,14 @@
 #include <linux/of_device.h>
 #include <linux/of_graph.h>
 
-#include <media/v4l2-fwnode.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
-#include <media/v4l2-event.h>
-#include <media/v4l2-common.h>
+#include <media/v4l2-fwnode.h>
+#include <media/v4l2-ioctl.h>
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 #include "cal_regs.h"
-- 
2.7.4
