Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:60142 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752871AbdF0PE0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 11:04:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [media] venus: fix compile-test build on non-qcom ARM platform
Date: Tue, 27 Jun 2017 17:02:48 +0200
Message-Id: <20170627150310.719212-3-arnd@arndb.de>
In-Reply-To: <20170627150310.719212-1-arnd@arndb.de>
References: <20170627150310.719212-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If QCOM_MDT_LOADER is enabled, but ARCH_QCOM is not, we run into
a build error:

ERROR: "qcom_mdt_load" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
ERROR: "qcom_mdt_get_size" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!

This changes the 'select' statement again, so we only try to enable
those symbols when the drivers will actually get built.

Fixes: 76724b30f222 ("[media] media: venus: enable building with COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index cb2f31cd0088..635c53e61f8a 100644
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
-- 
2.9.0
