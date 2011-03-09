Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:52696 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab1CINoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 08:44:54 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2 3/8] ARM: S5PV310: Add memory map support for MFC v5.1
Date: Wed,  9 Mar 2011 22:16:02 +0900
Message-Id: <1299676567-14194-4-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
References: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds memroy map support for MFC v5.1.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/mach-s5pv310/include/mach/map.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/include/mach/map.h b/arch/arm/mach-s5pv310/include/mach/map.h
index 74d4006..fa7866a 100644
--- a/arch/arm/mach-s5pv310/include/mach/map.h
+++ b/arch/arm/mach-s5pv310/include/mach/map.h
@@ -73,6 +73,8 @@
 #define S5PV310_PA_SROMC		(0x12570000)
 #define S5P_PA_SROMC			S5PV310_PA_SROMC
 
+#define S5PV310_PA_MFC			0x13400000
+
 /* S/PDIF */
 #define S5PV310_PA_SPDIF	0xE1100000
 
@@ -145,5 +147,6 @@
 #define S3C_PA_WDT			S5PV310_PA_WATCHDOG
 #define S5P_PA_MIPI_CSIS0		S5PV310_PA_MIPI_CSIS0
 #define S5P_PA_MIPI_CSIS1		S5PV310_PA_MIPI_CSIS1
+#define S5P_PA_MFC			S5PV310_PA_MFC
 
 #endif /* __ASM_ARCH_MAP_H */
-- 
1.7.1

