Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22671 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab1CaNQZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 09:16:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 31 Mar 2011 15:16:08 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 12/12] ARM: S5PC110: Added CMA regions to Aquila and Goni	boards
In-reply-to: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
	Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>
Message-id: <1301577368-16095-13-git-send-email-m.szyprowski@samsung.com>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This commit adds CMA memory regions to Aquila and Goni boards.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/mach-aquila.c |   31 +++++++++++++++++++++++++++++++
 arch/arm/mach-s5pv210/mach-goni.c   |   31 +++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
index 4e1d8ff..de3c41f 100644
--- a/arch/arm/mach-s5pv210/mach-aquila.c
+++ b/arch/arm/mach-s5pv210/mach-aquila.c
@@ -21,6 +21,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/cma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -642,6 +643,35 @@ static void __init aquila_sound_init(void)
 	__raw_writel(__raw_readl(S5P_OTHERS) | (0x3 << 8), S5P_OTHERS);
 }
 
+static void __init aquila_reserve(void)
+{
+	static struct cma_region regions[] = {
+		{
+			.name		= "fw",
+			.size		=  16 << 20,
+			.alignment	= 128 << 10,
+			.start		= 0x32000000,
+		},
+		{
+			.name		= "b1",
+			.size		=  32 << 20,
+			.start		= 0x33000000,
+		},
+		{
+			.name		= "b2",
+			.size		=  32 << 20,
+			.start		= 0x44000000,
+		},
+		{ }
+	};
+
+	static const char map[] __initconst =
+		"s5p-mfc/f=fw;s5p-mfc/a=b1;s5p-mfc/b=b2;*=b1,b2";
+
+	cma_set_defaults(regions, map);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init aquila_map_io(void)
 {
 	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
@@ -683,4 +713,5 @@ MACHINE_START(AQUILA, "Aquila")
 	.map_io		= aquila_map_io,
 	.init_machine	= aquila_machine_init,
 	.timer		= &s5p_timer,
+	.reserve	= aquila_reserve,
 MACHINE_END
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 31d5aa7..24f3f5c 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -26,6 +26,7 @@
 #include <linux/input.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
+#include <linux/cma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -833,6 +834,35 @@ static void __init goni_sound_init(void)
 	__raw_writel(__raw_readl(S5P_OTHERS) | (0x3 << 8), S5P_OTHERS);
 }
 
+static void __init goni_reserve(void)
+{
+	static struct cma_region regions[] = {
+		{
+			.name		= "fw",
+			.size		=  16 << 20,
+			.alignment	= 128 << 10,
+			.start		= 0x31000000,
+		},
+		{
+			.name		= "b1",
+			.size		=  32 << 20,
+			.start		= 0x33000000,
+		},
+		{
+			.name		= "b2",
+			.size		=  32 << 20,
+			.start		= 0x44000000,
+		},
+		{ }
+	};
+
+	static const char map[] __initconst =
+		"s5p-mfc/f=fw;s5p-mfc/a=b1;s5p-mfc/b=b2;*=b1,b2";
+
+	cma_set_defaults(regions, map);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init goni_map_io(void)
 {
 	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
@@ -893,4 +923,5 @@ MACHINE_START(GONI, "GONI")
 	.map_io		= goni_map_io,
 	.init_machine	= goni_machine_init,
 	.timer		= &s5p_timer,
+	.reserve	= goni_reserve,
 MACHINE_END
-- 
1.7.1.569.g6f426
