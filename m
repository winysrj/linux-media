Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:32949 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751340AbdGQI6q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 04:58:46 -0400
Received: by mail-wr0-f173.google.com with SMTP id a10so8115212wrd.0
        for <linux-media@vger.kernel.org>; Mon, 17 Jul 2017 01:58:46 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 3/4] venus: fix compile-test build on non-qcom ARM platform
Date: Mon, 17 Jul 2017 11:56:49 +0300
Message-Id: <20170717085650.12185-4-stanimir.varbanov@linaro.org>
In-Reply-To: <20170717085650.12185-1-stanimir.varbanov@linaro.org>
References: <20170717085650.12185-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

If QCOM_MDT_LOADER is enabled, but ARCH_QCOM is not, we run into
a build error:

ERROR: "qcom_mdt_load" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
ERROR: "qcom_mdt_get_size" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!

This changes the 'select' statement again, so we only try to enable
those symbols when the drivers will actually get built, and explicitly
test for QCOM_MDT_LOADER to be enabled before calling into it.

Fixes: 76724b30f222 ("[media] media: venus: enable building with COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/Kconfig               | 4 ++--
 drivers/media/platform/qcom/venus/firmware.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 1313cd533436..fb1fa0b82077 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -475,8 +475,8 @@ config VIDEO_QCOM_VENUS
 	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
-	select QCOM_MDT_LOADER if (ARM || ARM64)
-	select QCOM_SCM if (ARM || ARM64)
+	select QCOM_MDT_LOADER if ARCH_QCOM
+	select QCOM_SCM if ARCH_QCOM
 	select VIDEOBUF2_DMA_SG
 	select V4L2_MEM2MEM_DEV
 	---help---
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index d6d9560c1c19..521d4b36c090 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -38,7 +38,7 @@ int venus_boot(struct device *dev, const char *fwname)
 	void *mem_va;
 	int ret;
 
-	if (!qcom_scm_is_available())
+	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) || !qcom_scm_is_available())
 		return -EPROBE_DEFER;
 
 	node = of_parse_phandle(dev->of_node, "memory-region", 0);
-- 
2.11.0
