Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:23082 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3DVOFh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:05:37 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00DRBTT5Q5I0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:05:35 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 03/12] exynos4-is: Remove redundant MODULE_DEVICE_TABLE entries
Date: Mon, 22 Apr 2013 16:03:38 +0200
Message-id: <1366639427-14253-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unneeded MODULE_DEVICE_TABLE(of,...) instances from files that
are linked into same module. This fixes following error when building
as a module:

LD [M]  drivers/media/platform/exynos4-is/s5p-fimc.o
drivers/media/platform/exynos4-is/fimc-is-sensor.o: In function `.LANCHOR1':
fimc-is-sensor.c:(.rodata+0x48): multiple definition of `__mod_of_device_table'
drivers/media/platform/exynos4-is/fimc-is.o:fimc-is.c:(.rodata+0x174): first defined here
drivers/media/platform/exynos4-is/fimc-is-i2c.o:(.rodata+0x5c): multiple definition of `__mod_of_device_table'
drivers/media/platform/exynos4-is/fimc-is.o:fimc-is.c:(.rodata+0x174): first defined here
make[4]: *** [drivers/media/platform/exynos4-is/exynos-fimc-is.o] Error 1

Also remove exporting fimc_is_(un)register_i2c_driver functions, it
is not needed since these functions should be called only from our
module.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |    3 ---
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |    1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
index 1ec6b3c..c397777 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
@@ -103,7 +103,6 @@ static const struct of_device_id fimc_is_i2c_of_match[] = {
 	{ .compatible = FIMC_IS_I2C_COMPATIBLE },
 	{ },
 };
-MODULE_DEVICE_TABLE(of, fimc_is_i2c_of_match);
 
 static struct platform_driver fimc_is_i2c_driver = {
 	.probe		= fimc_is_i2c_probe,
@@ -120,10 +119,8 @@ int fimc_is_register_i2c_driver(void)
 {
 	return platform_driver_register(&fimc_is_i2c_driver);
 }
-EXPORT_SYMBOL(fimc_is_register_i2c_driver);
 
 void fimc_is_unregister_i2c_driver(void)
 {
 	platform_driver_unregister(&fimc_is_i2c_driver);
 }
-EXPORT_SYMBOL(fimc_is_unregister_i2c_driver);
diff --git a/drivers/media/platform/exynos4-is/fimc-is-sensor.c b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
index 02b2719..6b3ea54 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-sensor.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
@@ -294,7 +294,6 @@ static const struct of_device_id fimc_is_sensor_of_match[] = {
 	},
 	{  }
 };
-MODULE_DEVICE_TABLE(of, fimc_is_sensor_of_match);
 
 static struct i2c_driver fimc_is_sensor_driver = {
 	.driver = {
-- 
1.7.9.5

