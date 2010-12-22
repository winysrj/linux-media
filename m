Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38375 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0LVMMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 07:12:47 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>
Subject: [PATCH 3/9] ARM: S5PV310: Add memory map support for MFC v5.1
Date: Wed, 22 Dec 2010 20:54:39 +0900
Message-Id: <1293018885-15239-4-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1293018885-15239-3-git-send-email-jtp.park@samsung.com>
References: <1293018885-15239-1-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-2-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-3-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch adds memroy map support for MFC v5.1.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
---
 arch/arm/mach-s5pv310/include/mach/map.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/include/mach/map.h b/arch/arm/mach-s5pv310/include/mach/map.h
index 419a468..172fb27 100644
--- a/arch/arm/mach-s5pv310/include/mach/map.h
+++ b/arch/arm/mach-s5pv310/include/mach/map.h
@@ -60,6 +60,8 @@
 
 #define S5PV310_PA_SROMC		(0x12570000)
 
+#define S5PV310_PA_MFC			(0x13400000)
+
 #define S5PV310_PA_UART			(0x13800000)
 
 #define S5P_PA_UART(x)			(S5PV310_PA_UART + ((x) * S3C_UART_OFFSET))
@@ -95,6 +97,7 @@
 #define S3C_PA_IIC7			S5PV310_PA_IIC(7)
 #define S3C_PA_RTC			S5PV310_PA_RTC
 #define S3C_PA_WDT			S5PV310_PA_WATCHDOG
+#define S5P_PA_MFC			S5PV310_PA_MFC
 
 #define S5PV310_PA_LCD			(0x11C00000)
 #define S5P_PA_LCD			S5PV310_PA_LCD
-- 
1.6.2.5

