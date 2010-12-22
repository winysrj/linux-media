Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38378 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0LVMMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 07:12:47 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>
Subject: [PATCH 6/9] ARM: S5PV310: Add CMA support for MFC v5.1 on SMDKV310
Date: Wed, 22 Dec 2010 20:54:42 +0900
Message-Id: <1293018885-15239-7-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1293018885-15239-6-git-send-email-jtp.park@samsung.com>
References: <1293018885-15239-1-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-2-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-3-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-4-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-5-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-6-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch adds CMA support for MFC v5.1. It includes CMA region
definition and reserve callback addition.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
---
 arch/arm/mach-s5pv310/mach-smdkv310.c |   35 +++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/mach-smdkv310.c b/arch/arm/mach-s5pv310/mach-smdkv310.c
index e29df7f..bdc19ba 100644
--- a/arch/arm/mach-s5pv310/mach-smdkv310.c
+++ b/arch/arm/mach-s5pv310/mach-smdkv310.c
@@ -18,6 +18,9 @@
 #include <linux/smsc911x.h>
 #include <linux/io.h>
 #include <linux/lcd.h>
+#ifdef CONFIG_CMA
+#include <linux/cma.h>
+#endif
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -296,6 +299,35 @@ static void __init smdkv310_smsc911x_init(void)
 		     (0x1 << S5PV310_SROM_BCX__TACS__SHIFT), S5PV310_SROM_BC1);
 }
 
+static void __init smdkv310_reserve_cma(void)
+{
+	static struct cma_region regions[] = {
+		{
+			.name		= "fw",
+			.size		=   1 << 20,
+			{ .alignment	= 128 << 10 },
+			.start		= 0x42000000,
+		},
+		{
+			.name		= "b1",
+			.size		=  32 << 20,
+			.start		= 0x43000000,
+		},
+		{
+			.name		= "b2",
+			.size		=  16 << 20,
+			.start		= 0x51000000,
+		},
+		{}
+	};
+
+	static const char map[] __initconst =
+		"s5p-mfc/f=fw;s5p-mfc/a=b1;s5p-mfc/b=b2;*=b1,b2";
+
+	cma_set_defaults(regions, map);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init smdkv310_map_io(void)
 {
 	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
@@ -326,4 +358,7 @@ MACHINE_START(SMDKV310, "SMDKV310")
 	.map_io		= smdkv310_map_io,
 	.init_machine	= smdkv310_machine_init,
 	.timer		= &s5pv310_timer,
+#ifdef CONFIG_CMA
+	.reserve	= &smdkv310_reserve_cma,
+#endif
 MACHINE_END
-- 
1.6.2.5

