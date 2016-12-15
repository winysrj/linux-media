Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37282 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756798AbcLORY3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 12:24:29 -0500
Received: by mail-wm0-f49.google.com with SMTP id t79so56625349wmt.0
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2016 09:24:05 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 9/9] media: venus: enable building of Venus video driver
Date: Thu, 15 Dec 2016 19:22:24 +0200
Message-Id: <1481822544-29900-10-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1481822544-29900-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1481822544-29900-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds Venus driver Makefile and changes v4l2 platform
Makefile/Kconfig in order to enable building of the driver.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/Kconfig             | 13 +++++++++++++
 drivers/media/platform/Makefile            |  2 ++
 drivers/media/platform/qcom/venus/Makefile | 14 ++++++++++++++
 3 files changed, 29 insertions(+)
 create mode 100644 drivers/media/platform/qcom/venus/Makefile

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index d944421e392d..e0b2d53d37b8 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -379,6 +379,19 @@ config VIDEO_TI_VPE_DEBUG
 	---help---
 	  Enable debug messages on VPE driver.
 
+config VIDEO_QCOM_VENUS
+	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on ARCH_QCOM && OF
+	depends on IOMMU_DMA && QCOM_VENUS_PIL
+	select VIDEOBUF2_DMA_SG
+	select V4L2_MEM2MEM_DEV
+	---help---
+	  This is a V4L2 driver for Qualcomm Venus video accelerator
+	  hardware. It accelerates encoding and decoding operations
+	  on various Qualcomm SoCs.
+	  To compile this driver as a module choose m here.
+
 endif # V4L_MEM2MEM_DRIVERS
 
 # TI VIDEO PORT Helper Modules
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 5b3cb271d2b8..d88a4e1eb850 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -69,3 +69,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
 obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
+
+obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
diff --git a/drivers/media/platform/qcom/venus/Makefile b/drivers/media/platform/qcom/venus/Makefile
new file mode 100644
index 000000000000..8c4ef27e30fe
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/Makefile
@@ -0,0 +1,14 @@
+# Makefile for Qualcomm Venus driver
+
+venus-objs += 	core.o \
+		helpers.o \
+		vdec.o \
+		vdec_ctrls.o \
+		venc.o \
+		venc_ctrls.o \
+		hfi_venus.o \
+		hfi_msgs.o \
+		hfi_cmds.o \
+		hfi.o \
+
+obj-$(CONFIG_VIDEO_QCOM_VENUS) += venus.o
-- 
2.7.4

