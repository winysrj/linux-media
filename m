Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:34468 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754410AbdEIPhM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 11:37:12 -0400
Received: by mail-wr0-f179.google.com with SMTP id l9so4232434wre.1
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 08:37:06 -0700 (PDT)
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
Subject: [PATCH v9 9/9] media: venus: enable building of Venus video driver
Date: Tue,  9 May 2017 18:36:01 +0300
Message-Id: <1494344161-28131-10-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1494344161-28131-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1494344161-28131-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds Venus driver Makefile and changes v4l2 platform
Makefile/Kconfig in order to enable building of the driver.

Note that in this initial version the COMPILE_TEST-ing is not
supported because the drivers specific to ARM builds are still
in process of enabling the aforementioned compile testing.
Once that disadvantage is fixed the Venus driver compile testing
will be possible with follow-up changes.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/Kconfig             | 13 +++++++++++++
 drivers/media/platform/Makefile            |  2 ++
 drivers/media/platform/qcom/venus/Makefile | 11 +++++++++++
 3 files changed, 26 insertions(+)
 create mode 100644 drivers/media/platform/qcom/venus/Makefile

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ac026ee1ca07..fd33f3ec828d 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -448,6 +448,19 @@ config VIDEO_TI_VPE_DEBUG
 	---help---
 	  Enable debug messages on VPE driver.
 
+config VIDEO_QCOM_VENUS
+	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on ARCH_QCOM && IOMMU_DMA
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
index 63303d63c64c..c49de824af16 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -77,3 +77,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
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
