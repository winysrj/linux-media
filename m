Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64666 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759326Ab1CDL0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 06:26:43 -0500
Date: Fri, 04 Mar 2011 12:26:21 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [RFC/PATCH v7 4/5] s5pv310: Enable MFC on universal_c210 board
In-reply-to: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1299237982-31687-5-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch enables MFC 5.1 on the universal_c210 board. Multi Format
Codec 5.1 is capable of handling a range of video codecs.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv310/Kconfig               |    1 +
 arch/arm/mach-s5pv310/mach-universal_c210.c |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/Kconfig b/arch/arm/mach-s5pv310/Kconfig
index c850086..6f83817 100644
--- a/arch/arm/mach-s5pv310/Kconfig
+++ b/arch/arm/mach-s5pv310/Kconfig
@@ -107,6 +107,7 @@ config MACH_UNIVERSAL_C210
 	select S5PV310_SETUP_SDHCI
 	select S3C_DEV_I2C1
 	select S3C_DEV_I2C5
+	select S5P_DEV_MFC
 	select S5PV310_DEV_PD
 	select S5PV310_DEV_SYSMMU
 	select S5PV310_SETUP_I2C1
diff --git a/arch/arm/mach-s5pv310/mach-universal_c210.c b/arch/arm/mach-s5pv310/mach-universal_c210.c
index f153895..ce88262 100644
--- a/arch/arm/mach-s5pv310/mach-universal_c210.c
+++ b/arch/arm/mach-s5pv310/mach-universal_c210.c
@@ -827,6 +827,10 @@ static struct platform_device *universal_devices[] __initdata = {
 	&s5pv310_device_sysmmu[S5P_SYSMMU_FIMC1],
 	&s5pv310_device_sysmmu[S5P_SYSMMU_FIMC2],
 	&s5pv310_device_sysmmu[S5P_SYSMMU_FIMC3],
+	&s5p_device_mfc,
+	&s5pv310_device_pd[PD_MFC],
+	&s5pv310_device_sysmmu[S5P_SYSMMU_MFC_L],
+	&s5pv310_device_sysmmu[S5P_SYSMMU_MFC_R],
 
 	/* Universal Devices */
 	&universal_gpio_keys,
@@ -862,6 +866,10 @@ static void __init universal_machine_init(void)
 	s5pv310_device_sysmmu[S5P_SYSMMU_FIMC1].dev.parent = &s5pv310_device_pd[PD_CAM].dev;
 	s5pv310_device_sysmmu[S5P_SYSMMU_FIMC2].dev.parent = &s5pv310_device_pd[PD_CAM].dev;
 	s5pv310_device_sysmmu[S5P_SYSMMU_FIMC3].dev.parent = &s5pv310_device_pd[PD_CAM].dev;
+	
+	s5p_device_mfc.dev.parent = &s5pv310_device_pd[PD_MFC].dev;
+	s5pv310_device_sysmmu[S5P_SYSMMU_MFC_L].dev.parent = &s5pv310_device_pd[PD_MFC].dev;
+	s5pv310_device_sysmmu[S5P_SYSMMU_MFC_R].dev.parent = &s5pv310_device_pd[PD_MFC].dev;
 }
 
 MACHINE_START(UNIVERSAL_C210, "UNIVERSAL_C210")
-- 
1.6.3.3
