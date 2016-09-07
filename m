Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38208 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965064AbcIGLpd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 07:45:33 -0400
Received: by mail-wm0-f44.google.com with SMTP id 1so27232949wmz.1
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 04:45:33 -0700 (PDT)
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
Subject: [PATCH v2 7/8] media: vidc: add Makefiles and Kconfig files
Date: Wed,  7 Sep 2016 14:37:08 +0300
Message-Id: <1473248229-5540-8-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Makefile and Kconfig files to build the video codec driver.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/Kconfig       |  8 ++++++++
 drivers/media/platform/qcom/Makefile      |  6 ++++++
 drivers/media/platform/qcom/vidc/Makefile | 15 +++++++++++++++
 3 files changed, 29 insertions(+)
 create mode 100644 drivers/media/platform/qcom/Kconfig
 create mode 100644 drivers/media/platform/qcom/Makefile
 create mode 100644 drivers/media/platform/qcom/vidc/Makefile

diff --git a/drivers/media/platform/qcom/Kconfig b/drivers/media/platform/qcom/Kconfig
new file mode 100644
index 000000000000..4bad5c0f68e4
--- /dev/null
+++ b/drivers/media/platform/qcom/Kconfig
@@ -0,0 +1,8 @@
+comment "Qualcomm V4L2 drivers"
+
+menuconfig QCOM_VIDC
+        tristate "Qualcomm V4L2 encoder/decoder driver"
+        depends on ARCH_QCOM && VIDEO_V4L2
+        depends on IOMMU_DMA
+        depends on QCOM_VENUS_PIL
+        select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/platform/qcom/Makefile b/drivers/media/platform/qcom/Makefile
new file mode 100644
index 000000000000..150892f6533b
--- /dev/null
+++ b/drivers/media/platform/qcom/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the QCOM spcific video device drivers
+# based on V4L2.
+#
+
+obj-$(CONFIG_QCOM_VIDC)     += vidc/
diff --git a/drivers/media/platform/qcom/vidc/Makefile b/drivers/media/platform/qcom/vidc/Makefile
new file mode 100644
index 000000000000..f8b5f9a438ee
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/Makefile
@@ -0,0 +1,15 @@
+# Makefile for Qualcomm vidc driver
+
+vidc-objs += \
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
+obj-$(CONFIG_QCOM_VIDC) += vidc.o
-- 
2.7.4

