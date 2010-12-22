Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38392 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0LVMMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 07:12:47 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>
Subject: [PATCH 2/9] ARM: S5PV310: Add clock support for MFC v5.1
Date: Wed, 22 Dec 2010 20:54:38 +0900
Message-Id: <1293018885-15239-3-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1293018885-15239-2-git-send-email-jtp.park@samsung.com>
References: <1293018885-15239-1-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-2-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch adds clock support for MFC v5.1.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
---
 arch/arm/mach-s5pv310/clock.c                   |   68 +++++++++++++++++++++++
 arch/arm/mach-s5pv310/include/mach/regs-clock.h |    3 +
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/clock.c b/arch/arm/mach-s5pv310/clock.c
index a109bc1..158ccd0 100644
--- a/arch/arm/mach-s5pv310/clock.c
+++ b/arch/arm/mach-s5pv310/clock.c
@@ -56,6 +56,11 @@ static int s5pv310_clksrc_mask_cam_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKSRC_MASK_CAM, clk, enable);
 }
 
+static int s5pv310_clk_ip_mfc_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_MFC, clk, enable);
+}
+
 static int s5pv310_clksrc_mask_lcd0_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(S5P_CLKSRC_MASK_LCD0, clk, enable);
@@ -422,6 +427,11 @@ static struct clk init_clocks_disable[] = {
 		.enable		= s5pv310_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 3),
 	}, {
+		.name		= "mfc",
+		.id		= -1,
+		.enable		= s5pv310_clk_ip_mfc_ctrl,
+		.ctrlbit	= (1 << 0),
+	}, {
 		.name		= "fimd0",
 		.id		= -1,
 		.enable		= s5pv310_clk_ip_lcd0_ctrl,
@@ -613,6 +623,54 @@ static struct clksrc_sources clkset_group = {
 	.nr_sources	= ARRAY_SIZE(clkset_group_list),
 };
 
+static struct clk *clkset_mout_mfc0_list[] = {
+	[0] = &clk_mout_mpll.clk,
+	[1] = &clk_sclk_apll.clk,
+};
+
+static struct clksrc_sources clkset_mout_mfc0 = {
+	.sources	= clkset_mout_mfc0_list,
+	.nr_sources	= ARRAY_SIZE(clkset_mout_mfc0_list),
+};
+
+static struct clksrc_clk clk_mout_mfc0 = {
+	.clk	= {
+		.name		= "mout_mfc0",
+		.id		= -1,
+	},
+	.sources	= &clkset_mout_mfc0,
+	.reg_src	= { .reg = S5P_CLKSRC_MFC, .shift = 0, .size = 1 },
+};
+
+static struct clk *clkset_mout_mfc1_list[] = {
+	[0] = &clk_mout_epll.clk,
+	[1] = &clk_sclk_vpll.clk,
+};
+
+static struct clksrc_sources clkset_mout_mfc1 = {
+	.sources	= clkset_mout_mfc1_list,
+	.nr_sources	= ARRAY_SIZE(clkset_mout_mfc1_list),
+};
+
+static struct clksrc_clk clk_mout_mfc1 = {
+	.clk	= {
+		.name		= "mout_mfc1",
+		.id		= -1,
+	},
+	.sources	= &clkset_mout_mfc1,
+	.reg_src	= { .reg = S5P_CLKSRC_MFC, .shift = 4, .size = 1 },
+};
+
+static struct clk *clkset_mout_mfc_list[] = {
+	[0] = &clk_mout_mfc0.clk,
+	[1] = &clk_mout_mfc1.clk,
+};
+
+static struct clksrc_sources clkset_mout_mfc = {
+	.sources	= clkset_mout_mfc_list,
+	.nr_sources	= ARRAY_SIZE(clkset_mout_mfc_list),
+};
+
 static struct clk *clkset_mout_g2d0_list[] = {
 	[0] = &clk_mout_mpll.clk,
 	[1] = &clk_sclk_apll.clk,
@@ -844,6 +902,14 @@ static struct clksrc_clk clksrcs[] = {
 		.reg_div = { .reg = S5P_CLKDIV_CAM, .shift = 12, .size = 4 },
 	}, {
 		.clk		= {
+			.name		= "sclk_mfc",
+			.id		= -1,
+		},
+		.sources = &clkset_mout_mfc,
+		.reg_src = { .reg = S5P_CLKSRC_MFC, .shift = 8, .size = 1 },
+		.reg_div = { .reg = S5P_CLKDIV_MFC, .shift = 0, .size = 4 },
+	}, {
+		.clk		= {
 			.name		= "sclk_fimd0",
 			.id		= -1,
 			.enable		= s5pv310_clksrc_mask_lcd0_ctrl,
@@ -988,6 +1054,8 @@ static struct clksrc_clk *sysclks[] = {
 	&clk_dout_mmc2,
 	&clk_dout_mmc3,
 	&clk_dout_mmc4,
+	&clk_mout_mfc0,
+	&clk_mout_mfc1,
 };
 
 void __init_or_cpufreq s5pv310_setup_clocks(void)
diff --git a/arch/arm/mach-s5pv310/include/mach/regs-clock.h b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
index f1028ca..0222aff 100644
--- a/arch/arm/mach-s5pv310/include/mach/regs-clock.h
+++ b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
@@ -27,6 +27,7 @@
 #define S5P_CLKSRC_TOP0			S5P_CLKREG(0x0C210)
 #define S5P_CLKSRC_TOP1			S5P_CLKREG(0x0C214)
 #define S5P_CLKSRC_CAM			S5P_CLKREG(0x0C220)
+#define S5P_CLKSRC_MFC			S5P_CLKREG(0x0C228)
 #define S5P_CLKSRC_IMAGE		S5P_CLKREG(0x0C230)
 #define S5P_CLKSRC_LCD0			S5P_CLKREG(0x0C234)
 #define S5P_CLKSRC_LCD1			S5P_CLKREG(0x0C238)
@@ -36,6 +37,7 @@
 
 #define S5P_CLKDIV_TOP			S5P_CLKREG(0x0C510)
 #define S5P_CLKDIV_CAM			S5P_CLKREG(0x0C520)
+#define S5P_CLKDIV_MFC			S5P_CLKREG(0x0C528)
 #define S5P_CLKDIV_IMAGE		S5P_CLKREG(0x0C530)
 #define S5P_CLKDIV_LCD0			S5P_CLKREG(0x0C534)
 #define S5P_CLKDIV_LCD1			S5P_CLKREG(0x0C538)
@@ -59,6 +61,7 @@
 #define S5P_CLKSRC_MASK_PERIL1		S5P_CLKREG(0x0C354)
 
 #define S5P_CLKGATE_IP_CAM		S5P_CLKREG(0x0C920)
+#define S5P_CLKGATE_IP_MFC		S5P_CLKREG(0x0C928)
 #define S5P_CLKGATE_IP_IMAGE		S5P_CLKREG(0x0C930)
 #define S5P_CLKGATE_IP_LCD0		S5P_CLKREG(0x0C934)
 #define S5P_CLKGATE_IP_LCD1		S5P_CLKREG(0x0C938)
-- 
1.6.2.5

