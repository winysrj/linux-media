Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:39769 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753651AbcKYPFg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 10:05:36 -0500
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bjorn.andersson@linaro.org, srinivas.kandagatla@linaro.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 10/10] media: camss: Add Makefiles and Kconfig files
Date: Fri, 25 Nov 2016 16:57:40 +0200
Message-Id: <1480085860-28330-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Makefiles and Kconfig files to build the camss driver.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/Kconfig             |  5 +++++
 drivers/media/platform/qcom/Makefile            |  1 +
 drivers/media/platform/qcom/camss-8x16/Makefile | 12 ++++++++++++
 3 files changed, 18 insertions(+)
 create mode 100644 drivers/media/platform/qcom/Kconfig
 create mode 100644 drivers/media/platform/qcom/Makefile
 create mode 100644 drivers/media/platform/qcom/camss-8x16/Makefile

diff --git a/drivers/media/platform/qcom/Kconfig b/drivers/media/platform/qcom/Kconfig
new file mode 100644
index 0000000..743ab88
--- /dev/null
+++ b/drivers/media/platform/qcom/Kconfig
@@ -0,0 +1,5 @@
+
+menuconfig VIDEO_QCOM_CAMSS
+	tristate "Qualcomm 8x16 V4L2 Camera Subsystem driver"
+	depends on ARCH_QCOM && VIDEO_V4L2
+	select VIDEOBUF2_DMA_CONTIG
diff --git a/drivers/media/platform/qcom/Makefile b/drivers/media/platform/qcom/Makefile
new file mode 100644
index 0000000..2d73819
--- /dev/null
+++ b/drivers/media/platform/qcom/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_QCOM_CAMSS)    += camss-8x16/
diff --git a/drivers/media/platform/qcom/camss-8x16/Makefile b/drivers/media/platform/qcom/camss-8x16/Makefile
new file mode 100644
index 0000000..839e5f6
--- /dev/null
+++ b/drivers/media/platform/qcom/camss-8x16/Makefile
@@ -0,0 +1,12 @@
+# Makefile for Qualcomm CAMSS driver
+
+ccflags-y += -Idrivers/media/platform/qcom/camss
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

