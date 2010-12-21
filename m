Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45843 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123Ab0LUJzr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 04:55:47 -0500
Date: Tue, 21 Dec 2010 10:55:18 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [RFC/PATCH v5 4/4] s5pv210: Enable MFC on Goni
In-reply-to: <1292925318-2911-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1292925318-2911-5-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1292925318-2911-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch enables MFC 5.1 on Goni board. Multi Format Codec 5.1 is capable
of handling a range of video codecs.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig     |    1 +
 arch/arm/mach-s5pv210/mach-goni.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index c45a1b7..43f408d 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -85,6 +85,7 @@ config MACH_GONI
 	select S3C_DEV_HSMMC2
 	select S3C_DEV_I2C1
 	select S3C_DEV_I2C2
+	select S5P_DEV_MFC
 	select S3C_DEV_USB_HSOTG
 	select S5P_DEV_ONENAND
 	select SAMSUNG_DEV_KEYPAD
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 8d19ead..553a60e 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -810,6 +810,7 @@ static struct platform_device *goni_devices[] __initdata = {
 	&goni_i2c_gpio5,
 	&mmc2_fixed_voltage,
 	&goni_device_gpiokeys,
+	&s5p_device_mfc,
 	&s5p_device_fimc0,
 	&s5p_device_fimc1,
 	&s5p_device_fimc2,
@@ -857,7 +858,7 @@ static void __init goni_reserve(void)
 	};
 
 	static const char map[] __initconst =
-		"s5p-mfc5/f=fw;s5p-mfc5/a=b1;s5p-mfc5/b=b2;*=b1,b2";
+		"s5p-mfc/f=fw;s5p-mfc/a=b1;s5p-mfc/b=b2;*=b1,b2";
 
 	cma_set_defaults(regions, map);
 	cma_early_regions_reserve(NULL);
-- 
1.6.3.3

