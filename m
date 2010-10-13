Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29354 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab0JMLJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 07:09:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 13 Oct 2010 13:09:18 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/4] MFC: Add MFC 5.1 driver to plat-s5p
In-reply-to: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1286968160-10629-3-git-send-email-k.debski@samsung.com>
References: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add platform support for Multi Format Codec 5.1 is a module available
on S5PC110 and S5PC210 Samsung SoCs. Hardware is capable of handling
a range of video codecs and this driver provides V4L2 interface for
video decoding.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/clock.c             |    6 ++++
 arch/arm/mach-s5pv210/include/mach/map.h  |    4 +++
 arch/arm/plat-s5p/Kconfig                 |    5 ++++
 arch/arm/plat-s5p/Makefile                |    1 +
 arch/arm/plat-s5p/dev-mfc5.c              |   37 +++++++++++++++++++++++++++++
 arch/arm/plat-samsung/include/plat/devs.h |    2 +
 6 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-s5p/dev-mfc5.c

diff --git a/arch/arm/mach-s5pv210/clock.c b/arch/arm/mach-s5pv210/clock.c
index d562670..0717a07 100644
--- a/arch/arm/mach-s5pv210/clock.c
+++ b/arch/arm/mach-s5pv210/clock.c
@@ -294,6 +294,12 @@ static struct clk init_clocks_disable[] = {
 		.enable		= s5pv210_clk_ip0_ctrl,
 		.ctrlbit	= (1 << 26),
 	}, {
+		.name		= "mfc",
+		.id		= -1,
+		.parent		= &clk_pclk_psys.clk,
+		.enable		= s5pv210_clk_ip0_ctrl,
+		.ctrlbit	= (1 << 16),
+	}, {
 		.name		= "otg",
 		.id		= -1,
 		.parent		= &clk_hclk_psys.clk,
diff --git a/arch/arm/mach-s5pv210/include/mach/map.h b/arch/arm/mach-s5pv210/include/mach/map.h
index 586652f..9960d50 100644
--- a/arch/arm/mach-s5pv210/include/mach/map.h
+++ b/arch/arm/mach-s5pv210/include/mach/map.h
@@ -104,6 +104,9 @@
 #define S5PV210_PA_DMC0		(0xF0000000)
 #define S5PV210_PA_DMC1		(0xF1400000)
 
+/* MFC */
+#define S5PV210_PA_MFC		(0xF1700000)
+
 /* compatibiltiy defines. */
 #define S3C_PA_UART		S5PV210_PA_UART
 #define S3C_PA_HSMMC0		S5PV210_PA_HSMMC(0)
@@ -120,6 +123,7 @@
 #define S5P_PA_FIMC0		S5PV210_PA_FIMC0
 #define S5P_PA_FIMC1		S5PV210_PA_FIMC1
 #define S5P_PA_FIMC2		S5PV210_PA_FIMC2
+#define S5P_PA_MFC		S5PV210_PA_MFC
 
 #define SAMSUNG_PA_ADC		S5PV210_PA_ADC
 #define SAMSUNG_PA_CFCON	S5PV210_PA_CFCON
diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 65dbfa8..a1918fc 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -5,6 +5,11 @@
 #
 # Licensed under GPLv2
 
+config S5P_DEV_MFC
+	bool
+	help
+	  Compile in platform device definitions for MFC 
+	  
 config PLAT_S5P
 	bool
 	depends on (ARCH_S5P64X0 || ARCH_S5P6442 || ARCH_S5PC100 || ARCH_S5PV210 || ARCH_S5PV310)
diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
index de65238..d1d1ea9 100644
--- a/arch/arm/plat-s5p/Makefile
+++ b/arch/arm/plat-s5p/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_PM)		+= pm.o
 obj-$(CONFIG_PM)		+= irq-pm.o
 
 # devices
+obj-$(CONFIG_S5P_DEV_MFC)	+= dev-mfc5.o
 
 obj-$(CONFIG_S5P_DEV_FIMC0)	+= dev-fimc0.o
 obj-$(CONFIG_S5P_DEV_FIMC1)	+= dev-fimc1.o
diff --git a/arch/arm/plat-s5p/dev-mfc5.c b/arch/arm/plat-s5p/dev-mfc5.c
new file mode 100644
index 0000000..c06ea97
--- /dev/null
+++ b/arch/arm/plat-s5p/dev-mfc5.c
@@ -0,0 +1,37 @@
+/* Base S3C64XX mfc resource and device definitions */
+
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/ioport.h>
+
+#include <mach/map.h>
+#include <plat/map-base.h>
+#include <plat/devs.h>
+#include <plat/irqs.h>
+
+/* MFC controller */
+static struct resource s5p_mfc_resource[] = {
+	[0] = {
+		.start  = S5P_PA_MFC,
+		.end    = S5P_PA_MFC + SZ_64K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_MFC,
+		.end    = IRQ_MFC,
+		.flags  = IORESOURCE_IRQ,
+	}
+};
+
+struct platform_device s5p_device_mfc5 = {
+	.name          = "s5p-mfc5",
+	.id            = -1,
+	.num_resources = ARRAY_SIZE(s5p_mfc_resource),
+	.resource      = s5p_mfc_resource,
+};
+
+EXPORT_SYMBOL(s5p_device_mfc5);
+
+
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index 71bcc0f..39948de 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -118,6 +118,8 @@ extern struct platform_device s5p_device_fimc0;
 extern struct platform_device s5p_device_fimc1;
 extern struct platform_device s5p_device_fimc2;
 
+extern struct platform_device s5p_device_mfc5;
+
 /* s3c2440 specific devices */
 
 #ifdef CONFIG_CPU_S3C2440
-- 
1.6.3.3

