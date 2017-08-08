Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40298 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752365AbdHHNa6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:30:58 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 11/21] media: camss: Enable building
Date: Tue,  8 Aug 2017 16:30:08 +0300
Message-Id: <1502199018-28250-12-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Makefile and update platform/Kconfig and platform/Makefile
to enable building of the QCom CAMSS driver.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/Kconfig                  |  7 +++++++
 drivers/media/platform/Makefile                 |  2 ++
 drivers/media/platform/qcom/camss-8x16/Makefile | 11 +++++++++++
 3 files changed, 20 insertions(+)
 create mode 100644 drivers/media/platform/qcom/camss-8x16/Makefile

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 0c741d1..f8263e4 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -110,6 +110,13 @@ config VIDEO_PXA27x
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
+config VIDEO_QCOM_CAMSS
+	tristate "Qualcomm 8x16 V4L2 Camera Subsystem driver"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
+	select VIDEOBUF2_DMA_SG
+	select V4L2_FWNODE
+
 config VIDEO_S3C_CAMIF
 	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 9beadc7..10c099c 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -85,4 +85,6 @@ obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
 
+obj-$(CONFIG_VIDEO_QCOM_CAMSS)		+= qcom/camss-8x16/
+
 obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
diff --git a/drivers/media/platform/qcom/camss-8x16/Makefile b/drivers/media/platform/qcom/camss-8x16/Makefile
new file mode 100644
index 0000000..3c4024f
--- /dev/null
+++ b/drivers/media/platform/qcom/camss-8x16/Makefile
@@ -0,0 +1,11 @@
+# Makefile for Qualcomm CAMSS driver
+
+qcom-camss-objs += \
+		camss.o \
+		camss-csid.o \
+		camss-csiphy.o \
+		camss-ispif.o \
+		camss-vfe.o \
+		camss-video.o \
+
+obj-$(CONFIG_VIDEO_QCOM_CAMSS) += qcom-camss.o
-- 
2.7.4
