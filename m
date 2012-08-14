Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45176 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2HNExt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 00:53:49 -0400
Received: by ghrr11 with SMTP id r11so3939086ghr.19
        for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 21:53:48 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-fimc: Make FIMC-Lite dependent on S5P-FIMC
Date: Tue, 14 Aug 2012 10:22:03 +0530
Message-Id: <1344919923-16764-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-Lite driver accesses functions which are defined in files
attached to S5P_FIMC. Without this patch, if only FIMC-Lite is
selected, following errors are observed for missing symbols:

drivers/built-in.o: In function `fimc_md_create_links':
fimc-mdevice.c:641: undefined reference to `fimc_sensor_notify'
drivers/built-in.o: In function `fimc_md_link_notify':
fimc-mdevice.c:838: undefined reference to `fimc_ctrls_delete'
fimc-mdevice.c:854: undefined reference to `fimc_capture_ctrls_create'
drivers/built-in.o: In function `fimc_md_init':
fimc-mdevice.c:1018: undefined reference to `fimc_register_driver'
drivers/built-in.o: In function `fimc_md_exit':
fimc-mdevice.c:1028: undefined reference to `fimc_unregister_driver'
make: *** [vmlinux] Error 1

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/Kconfig b/drivers/media/video/s5p-fimc/Kconfig
index a564f7e..17a1f8d 100644
--- a/drivers/media/video/s5p-fimc/Kconfig
+++ b/drivers/media/video/s5p-fimc/Kconfig
@@ -35,7 +35,7 @@ if ARCH_EXYNOS
 
 config VIDEO_EXYNOS_FIMC_LITE
 	tristate "EXYNOS FIMC-LITE camera interface driver"
-	depends on I2C
+	depends on I2C && VIDEO_S5P_FIMC
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	  This is a V4L2 driver for Samsung EXYNOS4/5 SoC FIMC-LITE camera
-- 
1.7.4.1

