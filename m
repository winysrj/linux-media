Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:50356 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdF3QNf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 12:13:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v2] [media] venus: fix compile-test build on non-qcom ARM platform
Date: Fri, 30 Jun 2017 18:12:41 +0200
Message-Id: <20170630161325.82128-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If QCOM_MDT_LOADER is enabled, but ARCH_QCOM is not, we run into
a build error:

ERROR: "qcom_mdt_load" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
ERROR: "qcom_mdt_get_size" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!

This changes the 'select' statement again, so we only try to enable
those symbols when the drivers will actually get built, and explicitly
test for QCOM_MDT_LOADER to be enabled before calling into it.

Fixes: 76724b30f222 ("[media] media: venus: enable building with COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: add required IS_ENABLED() check
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
index 76edb9f60311..3794b9e3250b 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -40,7 +40,7 @@ int venus_boot(struct device *parent, struct device *fw_dev, const char *fwname)
 	void *mem_va;
 	int ret;
 
-	if (!qcom_scm_is_available())
+	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) || !qcom_scm_is_available())
 		return -EPROBE_DEFER;
 
 	fw_dev->parent = parent;
-- 
2.9.0
