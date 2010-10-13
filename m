Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29354 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0JMLJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 07:09:29 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 13 Oct 2010 13:09:20 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 4/4] s5pc110: Enable MFC 5.1 on Goni
In-reply-to: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1286968160-10629-5-git-send-email-k.debski@samsung.com>
References: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Multi Format Codec 5.1 is a module available on S5PC110 and S5PC210
Samsung SoCs. Hardware is capable of handling a range of video codecs.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig     |    1 +
 arch/arm/mach-s5pv210/mach-goni.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index 862f239..b5e3a39 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -85,6 +85,7 @@ config MACH_GONI
 	select S3C_DEV_I2C1
 	select S3C_DEV_I2C2
 	select S3C_DEV_USB_HSOTG
+	select S5P_DEV_MFC
 	select S5P_DEV_ONENAND
 	select SAMSUNG_DEV_KEYPAD
 	select S5PV210_SETUP_FB_24BPP
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 3602d16..cc5cdad 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -648,6 +648,7 @@ static struct platform_device *goni_devices[] __initdata = {
 	&goni_i2c_gpio_pmic,
 	&mmc2_fixed_voltage,
 	&goni_device_gpiokeys,
+	&s5p_device_mfc5,
 	&s5p_device_fimc0,
 	&s5p_device_fimc1,
 	&s5p_device_fimc2,
-- 
1.6.3.3

