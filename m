Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38395 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0LVMMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 07:12:47 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>
Subject: [PATCH 8/9] ARM: S5PV310: Add MFC v5.1 platform device support for SMDKC210
Date: Wed, 22 Dec 2010 20:54:44 +0900
Message-Id: <1293018885-15239-9-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1293018885-15239-8-git-send-email-jtp.park@samsung.com>
References: <1293018885-15239-1-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-2-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-3-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-4-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-5-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-6-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-7-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-8-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch adds MFC v5.1 platform device support for SMDKC210.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
---
 arch/arm/mach-s5pv310/Kconfig         |    1 +
 arch/arm/mach-s5pv310/mach-smdkc210.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/Kconfig b/arch/arm/mach-s5pv310/Kconfig
index 7e5dfe3..d1296f4 100644
--- a/arch/arm/mach-s5pv310/Kconfig
+++ b/arch/arm/mach-s5pv310/Kconfig
@@ -86,6 +86,7 @@ config MACH_SMDKC210
 	select S5PV310_SETUP_SDHCI
 	select S5P_DEV_FB
 	select S5PV310_SETUP_FB
+	select S5P_DEV_MFC
 	help
 	  Machine support for Samsung SMDKC210
 	  S5PC210(MCP) is one of package option of S5PV310
diff --git a/arch/arm/mach-s5pv310/mach-smdkc210.c b/arch/arm/mach-s5pv310/mach-smdkc210.c
index 7de3092..81e338a 100644
--- a/arch/arm/mach-s5pv310/mach-smdkc210.c
+++ b/arch/arm/mach-s5pv310/mach-smdkc210.c
@@ -273,6 +273,9 @@ static struct platform_device *smdkc210_devices[] __initdata = {
 	&smdkc210_smsc911x,
 	&s5pv310_device_fb0,
 	&s3c_device_spi_gpio,
+#ifdef CONFIG_VIDEO_SAMSUNG_S5P_MFC
+	&s5p_device_mfc,
+#endif
 };
 
 static void __init smdkc210_smsc911x_init(void)
-- 
1.6.2.5

