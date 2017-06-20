Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38083 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbdFTNOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 09:14:02 -0400
Received: by mail-wm0-f53.google.com with SMTP id u195so19818966wmd.1
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 06:14:01 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2] media: venus: enable building with COMPILE_TEST
Date: Tue, 20 Jun 2017 16:13:50 +0300
Message-Id: <1497964430-28310-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We want all media drivers to build with COMPILE_TEST, as the
Coverity instance we use on Kernel works only for x86. Also,
our test workflow relies on it, in order to identify git
bisect breakages.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
Changes since v1:
 - select QCOM_MDT_LOADER and QCOM_SCM conditionally.

 drivers/media/platform/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 6027dbd4e04d..b7381a4722e2 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -467,8 +467,9 @@ config VIDEO_TI_VPE_DEBUG
 config VIDEO_QCOM_VENUS
 	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
-	depends on ARCH_QCOM && IOMMU_DMA
-	select QCOM_MDT_LOADER
+	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
+	select QCOM_MDT_LOADER if (ARM || ARM64)
+	select QCOM_SCM if (ARM || ARM64)
 	select VIDEOBUF2_DMA_SG
 	select V4L2_MEM2MEM_DEV
 	---help---
-- 
2.7.4
