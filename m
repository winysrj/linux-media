Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36717 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753572AbcKGRfl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 12:35:41 -0500
Received: by mail-wm0-f43.google.com with SMTP id p190so197624047wmp.1
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2016 09:34:41 -0800 (PST)
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
Subject: [PATCH v3 8/9] media: venus: add Makefiles and Kconfig files
Date: Mon,  7 Nov 2016 19:34:02 +0200
Message-Id: <1478540043-24558-9-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Makefile and Kconfig files to build the Venus video codec driver.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/Kconfig        |  7 +++++++
 drivers/media/platform/qcom/Makefile       |  1 +
 drivers/media/platform/qcom/venus/Makefile | 15 +++++++++++++++
 3 files changed, 23 insertions(+)
 create mode 100644 drivers/media/platform/qcom/Kconfig
 create mode 100644 drivers/media/platform/qcom/Makefile
 create mode 100644 drivers/media/platform/qcom/venus/Makefile

diff --git a/drivers/media/platform/qcom/Kconfig b/drivers/media/platform/qcom/Kconfig
new file mode 100644
index 000000000000..bf4d2fcce924
--- /dev/null
+++ b/drivers/media/platform/qcom/Kconfig
@@ -0,0 +1,7 @@
+
+menuconfig VIDEO_QCOM_VENUS
+        tristate "Qualcomm Venus V4L2 encoder/decoder driver"
+        depends on ARCH_QCOM && VIDEO_V4L2
+        depends on IOMMU_DMA
+        depends on QCOM_VENUS_PIL
+        select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/platform/qcom/Makefile b/drivers/media/platform/qcom/Makefile
new file mode 100644
index 000000000000..347c6c71c189
--- /dev/null
+++ b/drivers/media/platform/qcom/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_QCOM_VENUS)     += venus/
diff --git a/drivers/media/platform/qcom/venus/Makefile b/drivers/media/platform/qcom/venus/Makefile
new file mode 100644
index 000000000000..b6c486be386c
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/Makefile
@@ -0,0 +1,15 @@
+# Makefile for Qualcomm Venus driver
+
+venus-objs += \
+		core.o \
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

