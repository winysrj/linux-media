Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36015 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754176AbdCMQia (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 12:38:30 -0400
Received: by mail-wm0-f49.google.com with SMTP id n11so44891255wma.1
        for <linux-media@vger.kernel.org>; Mon, 13 Mar 2017 09:38:29 -0700 (PDT)
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
Subject: [PATCH v7 9/9] media: venus: enable building of Venus video driver
Date: Mon, 13 Mar 2017 18:37:38 +0200
Message-Id: <1489423058-12492-10-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds Venus driver Makefile and changes v4l2 platform
Makefile/Kconfig in order to enable building of the driver.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/Kconfig             | 14 ++++++++++++++
 drivers/media/platform/Makefile            |  2 ++
 drivers/media/platform/qcom/venus/Makefile | 11 +++++++++++
 3 files changed, 27 insertions(+)
 create mode 100644 drivers/media/platform/qcom/venus/Makefile

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 53f6f12bff0d..8a6c3d664307 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -447,6 +447,20 @@ config VIDEO_TI_VPE_DEBUG
 	---help---
 	  Enable debug messages on VPE driver.
 
+config VIDEO_QCOM_VENUS
+	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on ARCH_QCOM && OF
+	depends on IOMMU_DMA
+	select QCOM_MDT_LOADER
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
index 8959f6e6692a..bd5cae68db8a 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -73,3 +73,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
 obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
+
+obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
diff --git a/drivers/media/platform/qcom/venus/Makefile b/drivers/media/platform/qcom/venus/Makefile
new file mode 100644
index 000000000000..0fe9afb83697
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/Makefile
@@ -0,0 +1,11 @@
+# Makefile for Qualcomm Venus driver
+
+venus-core-objs += core.o helpers.o firmware.o \
+		   hfi_venus.o hfi_msgs.o hfi_cmds.o hfi.o
+
+venus-dec-objs += vdec.o vdec_ctrls.o
+venus-enc-objs += venc.o venc_ctrls.o
+
+obj-$(CONFIG_VIDEO_QCOM_VENUS) += venus-core.o
+obj-$(CONFIG_VIDEO_QCOM_VENUS) += venus-dec.o
+obj-$(CONFIG_VIDEO_QCOM_VENUS) += venus-enc.o
-- 
2.7.4
