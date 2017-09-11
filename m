Return-path: <linux-media-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:41164 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdIKMfj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 08:35:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Todor Tomov <todor.tomov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] media: platform: VIDEO_QCOM_CAMSS should depend on HAS_DMA
Date: Mon, 11 Sep 2017 14:35:36 +0200
Message-Id: <1505133336-25767-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If NO_DMA=y:

    warning: (TOUCHSCREEN_SUR40 && VIDEO_TW68 && VIDEO_CX23885 && VIDEO_CX25821 && VIDEO_CX88 && VIDEO_SAA7134 && VIDEO_COBALT && VIDEO_QCOM_CAMSS) selects VIDEOBUF2_DMA_SG which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)

and

    ERROR: "bad_dma_ops" [drivers/media/v4l2-core/videobuf2-dma-sg.ko] undefined!
    ERROR: "bad_dma_ops" [drivers/media/platform/qcom/camss-8x16/qcom-camss.ko] undefined!

VIDEO_QCOM_CAMSS selects VIDEOBUF2_DMA_SG, which bypasses its dependency
on HAS_DMA.  Make VIDEO_QCOM_CAMSS depend on HAS_DMA to fix this.

Fixes: f5c074947f56533c ("media: camss: Enable building")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 7e7cc49b86740009..3c4f7fa7b9d8ea06 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -112,7 +112,7 @@ config VIDEO_PXA27x
 
 config VIDEO_QCOM_CAMSS
 	tristate "Qualcomm 8x16 V4L2 Camera Subsystem driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select V4L2_FWNODE
-- 
2.7.4
