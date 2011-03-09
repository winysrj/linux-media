Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:52687 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213Ab1CINox (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 08:44:53 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2 8/8] ARM: S5PV310: Add MFC v5.1 platform device support for SMDKV310
Date: Wed,  9 Mar 2011 22:16:07 +0900
Message-Id: <1299676567-14194-9-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
References: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds MFC v5.1 platform device support for SMDKV310.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/mach-s5pv310/Kconfig         |    1 +
 arch/arm/mach-s5pv310/mach-smdkv310.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/Kconfig b/arch/arm/mach-s5pv310/Kconfig
index c87d7b4..ec39785 100644
--- a/arch/arm/mach-s5pv310/Kconfig
+++ b/arch/arm/mach-s5pv310/Kconfig
@@ -125,6 +125,7 @@ config MACH_SMDKV310
 	select S5PV310_DEV_PD
 	select S5PV310_SETUP_I2C1
 	select S5PV310_SETUP_SDHCI
+	select S5P_DEV_MFC
 	help
 	  Machine support for Samsung SMDKV310
 
diff --git a/arch/arm/mach-s5pv310/mach-smdkv310.c b/arch/arm/mach-s5pv310/mach-smdkv310.c
index b1cddbf..bc7dfd4 100644
--- a/arch/arm/mach-s5pv310/mach-smdkv310.c
+++ b/arch/arm/mach-s5pv310/mach-smdkv310.c
@@ -166,6 +166,9 @@ static struct platform_device *smdkv310_devices[] __initdata = {
 	&s5pv310_device_sysmmu,
 	&samsung_asoc_dma,
 	&smdkv310_smsc911x,
+#ifdef CONFIG_VIDEO_SAMSUNG_S5P_MFC
+	&s5p_device_mfc,
+#endif
 };
 
 static void __init smdkv310_smsc911x_init(void)
-- 
1.7.1

