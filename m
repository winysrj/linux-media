Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:59391 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbDJUaZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 16:30:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] exynos4_is: exynos4-fimc requires i2c
Date: Fri, 10 Apr 2015 22:30:14 +0200
Message-ID: <19181630.veBMiO50KX@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without i2c, we can get a build error:

drivers/media/platform/exynos4-is/fimc-is-i2c.c: In function 'fimc_is_i2c_probe':
drivers/media/platform/exynos4-is/fimc-is-i2c.c:58:8: error: implicit declaration of function 'i2c_add_adapter' [-Werror=implicit-function-declaration]

The dependency already exists for exynos-fimc-lite and s5p-fimc,
but is missing for exynos4-fimc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index b7b2e472240a..40423c6c5324 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -57,6 +57,7 @@ endif
 
 config VIDEO_EXYNOS4_FIMC_IS
 	tristate "EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver"
+	depends on I2C
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	depends on OF

