Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:56039 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbdFSO4e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:56:34 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 10/19] media: camss: Enable building
Date: Mon, 19 Jun 2017 17:48:30 +0300
Message-Id: <1497883719-12410-11-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Makefile and update platform/Kconfig and platform/Makefile
to enable building of the QCom CAMSS driver.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/Kconfig                  |  6 ++++++
 drivers/media/platform/Makefile                 |  2 ++
 drivers/media/platform/qcom/camss-8x16/Makefile | 11 +++++++++++
 3 files changed, 19 insertions(+)
 create mode 100644 drivers/media/platform/qcom/camss-8x16/Makefile

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 041cb80..cf69c41 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -100,6 +100,12 @@ config VIDEO_PXA27x
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
+config VIDEO_QCOM_CAMSS
+	tristate "Qualcomm 8x16 V4L2 Camera Subsystem driver"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
+	select VIDEOBUF2_DMA_SG
+
 config VIDEO_S3C_CAMIF
 	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 63303d6..f083b8a 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -77,3 +77,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
 obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
+
+obj-$(CONFIG_VIDEO_QCOM_CAMSS)		+= qcom/camss-8x16/
diff --git a/drivers/media/platform/qcom/camss-8x16/Makefile b/drivers/media/platform/qcom/camss-8x16/Makefile
new file mode 100644
index 0000000..4a6b08f
--- /dev/null
+++ b/drivers/media/platform/qcom/camss-8x16/Makefile
@@ -0,0 +1,11 @@
+# Makefile for Qualcomm CAMSS driver
+
+qcom-camss-objs += \
+		camss.o \
+		csid.o \
+		csiphy.o \
+		ispif.o \
+		vfe.o \
+		video.o \
+
+obj-$(CONFIG_VIDEO_QCOM_CAMSS) += qcom-camss.o
-- 
1.9.1
