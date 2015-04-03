Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33785 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbbDCRNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:13:13 -0400
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: [PATCH 08/14] SH: use clkdev_add_table()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Ye59T-0001BR-KY@rmk-PC.arm.linux.org.uk>
Date: Fri, 03 Apr 2015 18:13:03 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have always had an efficient way of registering a table of clock
lookups - it's called clkdev_add_table().  However, some people seem
to really love writing inefficient and unnecessary code.

Convert SH to use the correct interface.

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/sh/kernel/cpu/sh4a/clock-sh7734.c | 3 +--
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c | 4 ++--
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c | 4 ++--
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c | 4 ++--
 arch/sh/kernel/cpu/sh4a/clock-shx3.c   | 4 ++--
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7734.c b/arch/sh/kernel/cpu/sh4a/clock-sh7734.c
index 1fdf1ee672de..7f54bf2f453d 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7734.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7734.c
@@ -246,8 +246,7 @@ int __init arch_clk_init(void)
 	for (i = 0; i < ARRAY_SIZE(main_clks); i++)
 		ret |= clk_register(main_clks[i]);
 
-	for (i = 0; i < ARRAY_SIZE(lookups); i++)
-		clkdev_add(&lookups[i]);
+	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 
 	if (!ret)
 		ret = sh_clk_div4_register(div4_clks, ARRAY_SIZE(div4_clks),
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7757.c b/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
index 9a28fdb36387..e40ec2c97ad1 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
@@ -141,8 +141,8 @@ int __init arch_clk_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(clks); i++)
 		ret |= clk_register(clks[i]);
-	for (i = 0; i < ARRAY_SIZE(lookups); i++)
-		clkdev_add(&lookups[i]);
+
+	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 
 	if (!ret)
 		ret = sh_clk_div4_register(div4_clks, ARRAY_SIZE(div4_clks),
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7785.c b/arch/sh/kernel/cpu/sh4a/clock-sh7785.c
index 17d0ea55a5a2..8eb6e62340c9 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7785.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7785.c
@@ -164,8 +164,8 @@ int __init arch_clk_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(clks); i++)
 		ret |= clk_register(clks[i]);
-	for (i = 0; i < ARRAY_SIZE(lookups); i++)
-		clkdev_add(&lookups[i]);
+
+	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 
 	if (!ret)
 		ret = sh_clk_div4_register(div4_clks, ARRAY_SIZE(div4_clks),
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7786.c b/arch/sh/kernel/cpu/sh4a/clock-sh7786.c
index bec2a83f1ba5..5e50e7ebeff0 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7786.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7786.c
@@ -179,8 +179,8 @@ int __init arch_clk_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(clks); i++)
 		ret |= clk_register(clks[i]);
-	for (i = 0; i < ARRAY_SIZE(lookups); i++)
-		clkdev_add(&lookups[i]);
+
+	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 
 	if (!ret)
 		ret = sh_clk_div4_register(div4_clks, ARRAY_SIZE(div4_clks),
diff --git a/arch/sh/kernel/cpu/sh4a/clock-shx3.c b/arch/sh/kernel/cpu/sh4a/clock-shx3.c
index 9a49a44f6f94..605221d1448a 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-shx3.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-shx3.c
@@ -138,8 +138,8 @@ int __init arch_clk_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(clks); i++)
 		ret |= clk_register(clks[i]);
-	for (i = 0; i < ARRAY_SIZE(lookups); i++)
-		clkdev_add(&lookups[i]);
+
+	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 
 	if (!ret)
 		ret = sh_clk_div4_register(div4_clks, ARRAY_SIZE(div4_clks),
-- 
1.8.3.1

