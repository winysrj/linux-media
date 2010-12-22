Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38385 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab0LVMMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 07:12:47 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>
Subject: [PATCH 9/9] ARM: S5PV310: Add MFC v5.1 platform device support for SMDKV310
Date: Wed, 22 Dec 2010 20:54:45 +0900
Message-Id: <1293018885-15239-10-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1293018885-15239-9-git-send-email-jtp.park@samsung.com>
References: <1293018885-15239-1-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-2-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-3-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-4-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-5-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-6-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-7-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-8-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-9-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch adds MFC v5.1 platform device support for SMDKV310.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
---
 arch/arm/mach-s5pv310/Kconfig         |    1 +
 arch/arm/mach-s5pv310/mach-smdkv310.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/Kconfig b/arch/arm/mach-s5pv310/Kconfig
index d1296f4..0bbbe54 100644
--- a/arch/arm/mach-s5pv310/Kconfig
+++ b/arch/arm/mach-s5pv310/Kconfig
@@ -115,6 +115,7 @@ config MACH_SMDKV310
 	select S3C_DEV_HSMMC2
 	select S3C_DEV_HSMMC3
 	select S5PV310_SETUP_SDHCI
+	select S5P_DEV_MFC
 	help
 	  Machine support for Samsung SMDKV310
 
diff --git a/arch/arm/mach-s5pv310/mach-smdkv310.c b/arch/arm/mach-s5pv310/mach-smdkv310.c
index bdc19ba..15b2059 100644
--- a/arch/arm/mach-s5pv310/mach-smdkv310.c
+++ b/arch/arm/mach-s5pv310/mach-smdkv310.c
@@ -273,6 +273,9 @@ static struct platform_device *smdkv310_devices[] __initdata = {
 	&smdkv310_smsc911x,
 	&s5pv310_device_fb0,
 	&s3c_device_spi_gpio,
+#ifdef CONFIG_VIDEO_SAMSUNG_S5P_MFC
+	&s5p_device_mfc,
+#endif
 };
 
 static void __init smdkv310_smsc911x_init(void)
-- 
1.6.2.5

