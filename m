Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:41485 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751091AbbDQH3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2015 03:29:38 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Mikko Perttunen <mikko.perttunen@kapsi.fi>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shawn Guo <shawn.guo@linaro.org>,
	ascha Hauer <kernel@pengutronix.de>,
	David Brown <davidb@codeaurora.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Bryan Huntsman <bryanh@codeaurora.org>,
	Tony Lindgren <tony@atomide.com>,
	Paul Walmsley <paul@pwsan.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Viresh Kumar <viresh.linux@gmail.com>,
	=?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Peter De Schrijver <pdeschrijver@nvidia.com>,
	Prashant Gaikwad <pgaikwad@nvidia.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Alexandre Courbot <gnurou@gmail.com>,
	Tero Kristo <t-kristo@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Michal Simek <michal.simek@xilinx.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-mips@linux-mips.org, patches@opensource.wolfsonmicro.com,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, spear-devel@list.st.com,
	linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH 1/2] clk: change clk_ops' ->round_rate() prototype
Date: Fri, 17 Apr 2015 09:29:28 +0200
Message-Id: <1429255769-13639-2-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1429255769-13639-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1429255769-13639-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clock rates are stored in an unsigned long field, but ->round_rate()
(which returns a rounded rate from a requested one) returns a long
value (errors are reported using negative error codes), which can lead
to long overflow if the clock rate exceed 2Ghz.

Change ->round_rate() prototype to return 0 or an error code, and pass the
requested rate as a pointer so that it can be adjusted depending on
hardware capabilities.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
CC: Jonathan Corbet <corbet@lwn.net>
CC: Shawn Guo <shawn.guo@linaro.org>
CC: ascha Hauer <kernel@pengutronix.de>
CC: David Brown <davidb@codeaurora.org>
CC: Daniel Walker <dwalker@fifo99.com>
CC: Bryan Huntsman <bryanh@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>
CC: Paul Walmsley <paul@pwsan.com>
CC: Liviu Dudau <liviu.dudau@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>
CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Max Filippov <jcmvbkbc@gmail.com>
CC: Heiko Stuebner <heiko@sntech.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com> 
CC: Tomasz Figa <tomasz.figa@gmail.com>
CC: Barry Song <baohua@kernel.org>
CC: Viresh Kumar <viresh.linux@gmail.com>
CC: "Emilio López" <emilio@elopez.com.ar>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>
CC: Tero Kristo <t-kristo@ti.com>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-doc@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org
CC: linux-arm-msm@vger.kernel.org
CC: linux-omap@vger.kernel.org
CC: linux-mips@linux-mips.org
CC: patches@opensource.wolfsonmicro.com
CC: linux-rockchip@lists.infradead.org
CC: linux-samsung-soc@vger.kernel.org
CC: spear-devel@list.st.com
CC: linux-tegra@vger.kernel.org
CC: dri-devel@lists.freedesktop.org
CC: linux-media@vger.kernel.org
CC: rtc-linux@googlegroups.com

 Documentation/clk.txt                        |  4 +-
 arch/arm/mach-imx/clk-busy.c                 |  2 +-
 arch/arm/mach-imx/clk-cpu.c                  | 12 +++-
 arch/arm/mach-imx/clk-fixup-div.c            |  2 +-
 arch/arm/mach-imx/clk-pfd.c                  | 11 ++--
 arch/arm/mach-imx/clk-pllv2.c                |  8 ++-
 arch/arm/mach-imx/clk-pllv3.c                | 46 +++++++------
 arch/arm/mach-msm/clock-pcom.c               |  4 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c | 13 ++--
 arch/arm/mach-omap2/clkt_clksel.c            |  6 +-
 arch/arm/mach-omap2/clkt_dpll.c              | 21 +++---
 arch/arm/mach-omap2/clock.h                  |  4 +-
 arch/arm/mach-omap2/dpll3xxx.c               | 27 +++++---
 arch/arm/mach-omap2/dpll44xx.c               | 26 +++++---
 arch/arm/mach-vexpress/spc.c                 | 11 +++-
 arch/mips/alchemy/common/clock.c             | 13 ++--
 drivers/clk/at91/clk-h32mx.c                 | 24 ++++---
 drivers/clk/at91/clk-peripheral.c            | 31 +++++----
 drivers/clk/at91/clk-pll.c                   | 14 ++--
 drivers/clk/at91/clk-plldiv.c                | 22 ++++---
 drivers/clk/at91/clk-smd.c                   | 24 ++++---
 drivers/clk/at91/clk-usb.c                   | 34 ++++++----
 drivers/clk/clk-axi-clkgen.c                 |  5 +-
 drivers/clk/clk-cdce706.c                    | 46 ++++++-------
 drivers/clk/clk-composite.c                  | 23 ++++---
 drivers/clk/clk-divider.c                    | 16 +++--
 drivers/clk/clk-fixed-factor.c               |  7 +-
 drivers/clk/clk-fractional-divider.c         | 16 +++--
 drivers/clk/clk-highbank.c                   | 18 +++---
 drivers/clk/clk-si5351.c                     | 96 ++++++++++++++--------------
 drivers/clk/clk-si570.c                      | 14 ++--
 drivers/clk/clk-u300.c                       | 65 ++++++++++---------
 drivers/clk/clk-vt8500.c                     | 27 ++++----
 drivers/clk/clk-wm831x.c                     | 11 ++--
 drivers/clk/clk-xgene.c                      | 11 ++--
 drivers/clk/clk.c                            | 15 +++--
 drivers/clk/mmp/clk-frac.c                   | 14 ++--
 drivers/clk/mvebu/clk-corediv.c              |  7 +-
 drivers/clk/mvebu/clk-cpu.c                  |  9 +--
 drivers/clk/mxs/clk-div.c                    |  4 +-
 drivers/clk/mxs/clk-frac.c                   | 11 ++--
 drivers/clk/mxs/clk-ref.c                    | 11 ++--
 drivers/clk/qcom/clk-regmap-divider.c        |  4 +-
 drivers/clk/rockchip/clk-pll.c               | 13 ++--
 drivers/clk/samsung/clk-pll.c                | 13 ++--
 drivers/clk/shmobile/clk-div6.c              |  7 +-
 drivers/clk/shmobile/clk-rcar-gen2.c         |  9 +--
 drivers/clk/sirf/clk-common.c                | 18 +++---
 drivers/clk/spear/clk-aux-synth.c            | 10 ++-
 drivers/clk/spear/clk-frac-synth.c           | 10 ++-
 drivers/clk/spear/clk-gpt-synth.c            | 10 ++-
 drivers/clk/spear/clk-vco-pll.c              | 20 ++++--
 drivers/clk/st/clk-flexgen.c                 | 11 ++--
 drivers/clk/st/clkgen-fsyn.c                 | 21 +++---
 drivers/clk/st/clkgen-mux.c                  |  2 +-
 drivers/clk/sunxi/clk-factors.c              | 14 ++--
 drivers/clk/tegra/clk-audio-sync.c           |  8 +--
 drivers/clk/tegra/clk-divider.c              | 19 ++++--
 drivers/clk/tegra/clk-periph.c               |  4 +-
 drivers/clk/tegra/clk-pll.c                  | 39 ++++++-----
 drivers/clk/ti/clk-dra7-atl.c                |  9 +--
 drivers/clk/ti/composite.c                   |  4 +-
 drivers/clk/ti/divider.c                     |  9 +--
 drivers/clk/ux500/clk-prcmu.c                | 13 +++-
 drivers/clk/versatile/clk-icst.c             |  9 +--
 drivers/clk/versatile/clk-vexpress-osc.c     | 12 ++--
 drivers/clk/zynq/pll.c                       |  7 +-
 drivers/gpu/drm/imx/imx-tve.c                | 15 +++--
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c     |  7 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c |  7 +-
 drivers/media/platform/omap3isp/isp.c        |  6 +-
 drivers/rtc/rtc-hym8563.c                    | 14 ++--
 include/linux/clk-provider.h                 |  6 +-
 include/linux/clk/ti.h                       | 12 ++--
 74 files changed, 672 insertions(+), 475 deletions(-)

diff --git a/Documentation/clk.txt b/Documentation/clk.txt
index 0e4f90a..fca8b7a 100644
--- a/Documentation/clk.txt
+++ b/Documentation/clk.txt
@@ -68,8 +68,8 @@ the operations defined in clk.h:
 		int		(*is_enabled)(struct clk_hw *hw);
 		unsigned long	(*recalc_rate)(struct clk_hw *hw,
 						unsigned long parent_rate);
-		long		(*round_rate)(struct clk_hw *hw,
-						unsigned long rate,
+		int		(*round_rate)(struct clk_hw *hw,
+						unsigned long *rate,
 						unsigned long *parent_rate);
 		long		(*determine_rate)(struct clk_hw *hw,
 						unsigned long rate,
diff --git a/arch/arm/mach-imx/clk-busy.c b/arch/arm/mach-imx/clk-busy.c
index 4bb1bc4..f8c67e9 100644
--- a/arch/arm/mach-imx/clk-busy.c
+++ b/arch/arm/mach-imx/clk-busy.c
@@ -51,7 +51,7 @@ static unsigned long clk_busy_divider_recalc_rate(struct clk_hw *hw,
 	return busy->div_ops->recalc_rate(&busy->div.hw, parent_rate);
 }
 
-static long clk_busy_divider_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_busy_divider_round_rate(struct clk_hw *hw, unsigned long *rate,
 					unsigned long *prate)
 {
 	struct clk_busy_divider *busy = to_clk_busy_divider(hw);
diff --git a/arch/arm/mach-imx/clk-cpu.c b/arch/arm/mach-imx/clk-cpu.c
index aa1c345..f6af2d8 100644
--- a/arch/arm/mach-imx/clk-cpu.c
+++ b/arch/arm/mach-imx/clk-cpu.c
@@ -34,12 +34,18 @@ static unsigned long clk_cpu_recalc_rate(struct clk_hw *hw,
 	return clk_get_rate(cpu->div);
 }
 
-static long clk_cpu_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *prate)
+static int clk_cpu_round_rate(struct clk_hw *hw, unsigned long *rate,
+			      unsigned long *prate)
 {
 	struct clk_cpu *cpu = to_clk_cpu(hw);
+	long ret;
 
-	return clk_round_rate(cpu->pll, rate);
+	ret = clk_round_rate(cpu->pll, *rate);
+	if (ret < 0)
+		return ret;
+
+	*rate = ret;
+	return 0;
 }
 
 static int clk_cpu_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/arch/arm/mach-imx/clk-fixup-div.c b/arch/arm/mach-imx/clk-fixup-div.c
index 21db020..c2f4f00 100644
--- a/arch/arm/mach-imx/clk-fixup-div.c
+++ b/arch/arm/mach-imx/clk-fixup-div.c
@@ -48,7 +48,7 @@ static unsigned long clk_fixup_div_recalc_rate(struct clk_hw *hw,
 	return fixup_div->ops->recalc_rate(&fixup_div->divider.hw, parent_rate);
 }
 
-static long clk_fixup_div_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_fixup_div_round_rate(struct clk_hw *hw, unsigned long *rate,
 			       unsigned long *prate)
 {
 	struct clk_fixup_div *fixup_div = to_clk_fixup_div(hw);
diff --git a/arch/arm/mach-imx/clk-pfd.c b/arch/arm/mach-imx/clk-pfd.c
index 0b0f6f6..449fb7a 100644
--- a/arch/arm/mach-imx/clk-pfd.c
+++ b/arch/arm/mach-imx/clk-pfd.c
@@ -68,14 +68,14 @@ static unsigned long clk_pfd_recalc_rate(struct clk_hw *hw,
 	return tmp;
 }
 
-static long clk_pfd_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *prate)
+static int clk_pfd_round_rate(struct clk_hw *hw, unsigned long *rate,
+			      unsigned long *prate)
 {
 	u64 tmp = *prate;
 	u8 frac;
 
-	tmp = tmp * 18 + rate / 2;
-	do_div(tmp, rate);
+	tmp = tmp * 18 + *rate / 2;
+	do_div(tmp, *rate);
 	frac = tmp;
 	if (frac < 12)
 		frac = 12;
@@ -85,7 +85,8 @@ static long clk_pfd_round_rate(struct clk_hw *hw, unsigned long rate,
 	tmp *= 18;
 	do_div(tmp, frac);
 
-	return tmp;
+	*rate = tmp;
+	return 0;
 }
 
 static int clk_pfd_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/arch/arm/mach-imx/clk-pllv2.c b/arch/arm/mach-imx/clk-pllv2.c
index 20889d5..6b48bf5 100644
--- a/arch/arm/mach-imx/clk-pllv2.c
+++ b/arch/arm/mach-imx/clk-pllv2.c
@@ -180,14 +180,16 @@ static int clk_pllv2_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
-static long clk_pllv2_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_pllv2_round_rate(struct clk_hw *hw, unsigned long *rate,
 		unsigned long *prate)
 {
 	u32 dp_op, dp_mfd, dp_mfn;
 
-	__clk_pllv2_set_rate(rate, *prate, &dp_op, &dp_mfd, &dp_mfn);
-	return __clk_pllv2_recalc_rate(*prate, MXC_PLL_DP_CTL_DPDCK0_2_EN,
+	__clk_pllv2_set_rate(*rate, *prate, &dp_op, &dp_mfd, &dp_mfn);
+	*rate = __clk_pllv2_recalc_rate(*prate, MXC_PLL_DP_CTL_DPDCK0_2_EN,
 			dp_op, dp_mfd, dp_mfn);
+
+	return 0;
 }
 
 static int clk_pllv2_prepare(struct clk_hw *hw)
diff --git a/arch/arm/mach-imx/clk-pllv3.c b/arch/arm/mach-imx/clk-pllv3.c
index 641ebc5..4d8f4eb 100644
--- a/arch/arm/mach-imx/clk-pllv3.c
+++ b/arch/arm/mach-imx/clk-pllv3.c
@@ -104,13 +104,15 @@ static unsigned long clk_pllv3_recalc_rate(struct clk_hw *hw,
 	return (div == 1) ? parent_rate * 22 : parent_rate * 20;
 }
 
-static long clk_pllv3_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *prate)
+static int clk_pllv3_round_rate(struct clk_hw *hw, unsigned long *rate,
+				unsigned long *prate)
 {
 	unsigned long parent_rate = *prate;
 
-	return (rate >= parent_rate * 22) ? parent_rate * 22 :
-					    parent_rate * 20;
+	*rate = (*rate >= parent_rate * 22) ? parent_rate * 22 :
+					      parent_rate * 20;
+
+	return 0;
 }
 
 static int clk_pllv3_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -151,21 +153,23 @@ static unsigned long clk_pllv3_sys_recalc_rate(struct clk_hw *hw,
 	return parent_rate * div / 2;
 }
 
-static long clk_pllv3_sys_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *prate)
+static int clk_pllv3_sys_round_rate(struct clk_hw *hw, unsigned long *rate,
+				    unsigned long *prate)
 {
 	unsigned long parent_rate = *prate;
 	unsigned long min_rate = parent_rate * 54 / 2;
 	unsigned long max_rate = parent_rate * 108 / 2;
 	u32 div;
 
-	if (rate > max_rate)
-		rate = max_rate;
-	else if (rate < min_rate)
-		rate = min_rate;
-	div = rate * 2 / parent_rate;
+	if (*rate > max_rate)
+		*rate = max_rate;
+	else if (*rate < min_rate)
+		*rate = min_rate;
+	div = *rate * 2 / parent_rate;
 
-	return parent_rate * div / 2;
+	*rate = parent_rate * div / 2;
+
+	return 0;
 }
 
 static int clk_pllv3_sys_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -207,7 +211,7 @@ static unsigned long clk_pllv3_av_recalc_rate(struct clk_hw *hw,
 	return (parent_rate * div) + ((parent_rate / mfd) * mfn);
 }
 
-static long clk_pllv3_av_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_pllv3_av_round_rate(struct clk_hw *hw, unsigned long *rate,
 				    unsigned long *prate)
 {
 	unsigned long parent_rate = *prate;
@@ -217,18 +221,20 @@ static long clk_pllv3_av_round_rate(struct clk_hw *hw, unsigned long rate,
 	u32 mfn, mfd = 1000000;
 	s64 temp64;
 
-	if (rate > max_rate)
-		rate = max_rate;
-	else if (rate < min_rate)
-		rate = min_rate;
+	if (*rate > max_rate)
+		*rate = max_rate;
+	else if (*rate < min_rate)
+		*rate = min_rate;
 
-	div = rate / parent_rate;
-	temp64 = (u64) (rate - div * parent_rate);
+	div = *rate / parent_rate;
+	temp64 = (u64) (*rate - div * parent_rate);
 	temp64 *= mfd;
 	do_div(temp64, parent_rate);
 	mfn = temp64;
 
-	return parent_rate * div + parent_rate / mfd * mfn;
+	*rate = parent_rate * div + parent_rate / mfd * mfn;
+
+	return 0;
 }
 
 static int clk_pllv3_av_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index f5b69d7..118c288 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -109,11 +109,11 @@ static int pc_clk_is_enabled(struct clk_hw *hw)
 		return id;
 }
 
-static long pc_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+static int pc_clk_round_rate(struct clk_hw *hw, unsigned long *rate,
 			      unsigned long *p_rate)
 {
 	/* Not really supported; pc_clk_set_rate() does rounding on it's own. */
-	return rate;
+	return 0;
 }
 
 static struct clk_ops clk_ops_pcom = {
diff --git a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
index 85e0b0c0..2829a6f 100644
--- a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
+++ b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
@@ -71,8 +71,8 @@ unsigned long omap2_table_mpu_recalc(struct clk_hw *clk,
  * Some might argue L3-DDR, others ARM, others IVA. This code is simple and
  * just uses the ARM rates.
  */
-long omap2_round_to_table_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *parent_rate)
+int omap2_round_to_table_rate(struct clk_hw *hw, unsigned long *rate,
+			      unsigned long *parent_rate)
 {
 	const struct prcm_config *ptr;
 	long highest_rate;
@@ -88,10 +88,15 @@ long omap2_round_to_table_rate(struct clk_hw *hw, unsigned long rate,
 		highest_rate = ptr->mpu_speed;
 
 		/* Can check only after xtal frequency check */
-		if (ptr->mpu_speed <= rate)
+		if (ptr->mpu_speed <= *rate)
 			break;
 	}
-	return highest_rate;
+
+	if (highest_rate < 0)
+		return highest_rate;
+
+	*rate = highest_rate;
+	return 0;
 }
 
 /* Sets basic clocks based on the specified rate */
diff --git a/arch/arm/mach-omap2/clkt_clksel.c b/arch/arm/mach-omap2/clkt_clksel.c
index 7ee2610..b932276 100644
--- a/arch/arm/mach-omap2/clkt_clksel.c
+++ b/arch/arm/mach-omap2/clkt_clksel.c
@@ -385,13 +385,15 @@ unsigned long omap2_clksel_recalc(struct clk_hw *hw, unsigned long parent_rate)
  *
  * Returns the rounded clock rate or returns 0xffffffff on error.
  */
-long omap2_clksel_round_rate(struct clk_hw *hw, unsigned long target_rate,
+int omap2_clksel_round_rate(struct clk_hw *hw, unsigned long *target_rate,
 			unsigned long *parent_rate)
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
 	u32 new_div;
 
-	return omap2_clksel_round_rate_div(clk, target_rate, &new_div);
+	*target_rate = omap2_clksel_round_rate_div(clk, *target_rate,
+						   &new_div);
+	return 0;
 }
 
 /**
diff --git a/arch/arm/mach-omap2/clkt_dpll.c b/arch/arm/mach-omap2/clkt_dpll.c
index f251a14..7dac6b3 100644
--- a/arch/arm/mach-omap2/clkt_dpll.c
+++ b/arch/arm/mach-omap2/clkt_dpll.c
@@ -280,7 +280,7 @@ unsigned long omap2_get_dpll_rate(struct clk_hw_omap *clk)
  * (expensive) function again.  Returns ~0 if the target rate cannot
  * be rounded, or the rounded rate upon success.
  */
-long omap2_dpll_round_rate(struct clk_hw *hw, unsigned long target_rate,
+int omap2_dpll_round_rate(struct clk_hw *hw, unsigned long *target_rate,
 		unsigned long *parent_rate)
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
@@ -295,16 +295,16 @@ long omap2_dpll_round_rate(struct clk_hw *hw, unsigned long target_rate,
 	const char *clk_name;
 
 	if (!clk || !clk->dpll_data)
-		return ~0;
+		return -EINVAL;
 
 	dd = clk->dpll_data;
 
 	ref_rate = __clk_get_rate(dd->clk_ref);
 	clk_name = __clk_get_name(hw->clk);
 	pr_debug("clock: %s: starting DPLL round_rate, target rate %lu\n",
-		 clk_name, target_rate);
+		 clk_name, *target_rate);
 
-	scaled_rt_rp = target_rate / (ref_rate / DPLL_SCALE_FACTOR);
+	scaled_rt_rp = *target_rate / (ref_rate / DPLL_SCALE_FACTOR);
 	scaled_max_m = dd->max_multiplier * DPLL_SCALE_FACTOR;
 
 	dd->last_rounded_rate = 0;
@@ -330,7 +330,7 @@ long omap2_dpll_round_rate(struct clk_hw *hw, unsigned long target_rate,
 		if (m > scaled_max_m)
 			break;
 
-		r = _dpll_test_mult(&m, n, &new_rate, target_rate,
+		r = _dpll_test_mult(&m, n, &new_rate, *target_rate,
 				    ref_rate);
 
 		/* m can't be set low enough for this n - try with a larger n */
@@ -338,7 +338,7 @@ long omap2_dpll_round_rate(struct clk_hw *hw, unsigned long target_rate,
 			continue;
 
 		/* skip rates above our target rate */
-		delta = target_rate - new_rate;
+		delta = *target_rate - new_rate;
 		if (delta < 0)
 			continue;
 
@@ -357,14 +357,15 @@ long omap2_dpll_round_rate(struct clk_hw *hw, unsigned long target_rate,
 
 	if (prev_min_delta == LONG_MAX) {
 		pr_debug("clock: %s: cannot round to rate %lu\n",
-			 clk_name, target_rate);
-		return ~0;
+			 clk_name, *target_rate);
+		return -EINVAL;
 	}
 
 	dd->last_rounded_m = min_delta_m;
 	dd->last_rounded_n = min_delta_n;
-	dd->last_rounded_rate = target_rate - prev_min_delta;
+	dd->last_rounded_rate = *target_rate - prev_min_delta;
 
-	return dd->last_rounded_rate;
+	*target_rate = dd->last_rounded_rate;
+	return 0;
 }
 
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index a56742f..cfe41b7 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -194,8 +194,8 @@ u32 omap2_clksel_round_rate_div(struct clk_hw_omap *clk,
 				u32 *new_div);
 u8 omap2_clksel_find_parent_index(struct clk_hw *hw);
 unsigned long omap2_clksel_recalc(struct clk_hw *hw, unsigned long parent_rate);
-long omap2_clksel_round_rate(struct clk_hw *hw, unsigned long target_rate,
-				unsigned long *parent_rate);
+int omap2_clksel_round_rate(struct clk_hw *hw, unsigned long *target_rate,
+			    unsigned long *parent_rate);
 int omap2_clksel_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate);
 int omap2_clksel_set_parent(struct clk_hw *hw, u8 field_val);
diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index 44e57ec..7a6fb45 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -480,6 +480,7 @@ long omap3_noncore_dpll_determine_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
 	struct dpll_data *dd;
+	int ret;
 
 	if (!hw || !rate)
 		return -EINVAL;
@@ -492,7 +493,10 @@ long omap3_noncore_dpll_determine_rate(struct clk_hw *hw, unsigned long rate,
 	    (dd->modes & (1 << DPLL_LOW_POWER_BYPASS))) {
 		*best_parent_clk = __clk_get_hw(dd->clk_bypass);
 	} else {
-		rate = omap2_dpll_round_rate(hw, rate, best_parent_rate);
+		ret = omap2_dpll_round_rate(hw, &rate, best_parent_rate);
+		if (ret)
+			return ret;
+
 		*best_parent_clk = __clk_get_hw(dd->clk_ref);
 	}
 
@@ -768,27 +772,33 @@ int omap3_clkoutx2_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
-long omap3_clkoutx2_round_rate(struct clk_hw *hw, unsigned long rate,
+int omap3_clkoutx2_round_rate(struct clk_hw *hw, unsigned long *rate,
 		unsigned long *prate)
 {
 	const struct dpll_data *dd;
 	u32 v;
 	struct clk_hw_omap *pclk = NULL;
 
-	if (!*prate)
+	if (!*prate) {
+		*rate = 0;
 		return 0;
+	}
 
 	pclk = omap3_find_clkoutx2_dpll(hw);
 
-	if (!pclk)
+	if (!pclk) {
+		*rate = 0;
 		return 0;
+	}
 
 	dd = pclk->dpll_data;
 
 	/* TYPE J does not have a clkoutx2 */
 	if (dd->flags & DPLL_J_TYPE) {
-		*prate = __clk_round_rate(__clk_get_parent(pclk->hw.clk), rate);
-		return *prate;
+		*prate = __clk_round_rate(__clk_get_parent(pclk->hw.clk),
+					  *rate);
+		*rate = *prate;
+		return 0;
 	}
 
 	WARN_ON(!dd->enable_mask);
@@ -803,12 +813,13 @@ long omap3_clkoutx2_round_rate(struct clk_hw *hw, unsigned long rate,
 	if (__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT) {
 		unsigned long best_parent;
 
-		best_parent = (rate / 2);
+		best_parent = (*rate / 2);
 		*prate = __clk_round_rate(__clk_get_parent(hw->clk),
 				best_parent);
 	}
 
-	return *prate * 2;
+	*rate = *prate * 2;
+	return 0;
 }
 
 /* OMAP3/4 non-CORE DPLL clkops */
diff --git a/arch/arm/mach-omap2/dpll44xx.c b/arch/arm/mach-omap2/dpll44xx.c
index f231be0..afd3284 100644
--- a/arch/arm/mach-omap2/dpll44xx.c
+++ b/arch/arm/mach-omap2/dpll44xx.c
@@ -146,11 +146,12 @@ unsigned long omap4_dpll_regm4xen_recalc(struct clk_hw *hw,
  * M-dividers) upon success, -EINVAL if @clk is null or not a DPLL, or
  * ~0 if an error occurred in omap2_dpll_round_rate().
  */
-long omap4_dpll_regm4xen_round_rate(struct clk_hw *hw,
-				    unsigned long target_rate,
-				    unsigned long *parent_rate)
+int omap4_dpll_regm4xen_round_rate(struct clk_hw *hw,
+				   unsigned long *target_rate,
+				   unsigned long *parent_rate)
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
+	unsigned long rate = *target_rate;
 	struct dpll_data *dd;
 	long r;
 
@@ -166,7 +167,7 @@ long omap4_dpll_regm4xen_round_rate(struct clk_hw *hw,
 	 * target rate without using the 4X multiplier.
 	 */
 	r = omap2_dpll_round_rate(hw, target_rate, NULL);
-	if (r != ~0)
+	if (!r)
 		goto out;
 
 	/*
@@ -174,9 +175,9 @@ long omap4_dpll_regm4xen_round_rate(struct clk_hw *hw,
 	 * this time see if using the 4X multiplier can help. Enabling the
 	 * 4X multiplier is equivalent to dividing the target rate by 4.
 	 */
-	r = omap2_dpll_round_rate(hw, target_rate / OMAP4430_REGM4XEN_MULT,
-				  NULL);
-	if (r == ~0)
+	rate = *target_rate / OMAP4430_REGM4XEN_MULT;
+	r = omap2_dpll_round_rate(hw, &rate, NULL);
+	if (r)
 		return r;
 
 	dd->last_rounded_rate *= OMAP4430_REGM4XEN_MULT;
@@ -184,8 +185,9 @@ long omap4_dpll_regm4xen_round_rate(struct clk_hw *hw,
 
 out:
 	omap4_dpll_lpmode_recalc(dd);
+	*target_rate = dd->last_rounded_rate;
 
-	return dd->last_rounded_rate;
+	return 0;
 }
 
 /**
@@ -209,6 +211,7 @@ long omap4_dpll_regm4xen_determine_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
 	struct dpll_data *dd;
+	int ret;
 
 	if (!hw || !rate)
 		return -EINVAL;
@@ -221,8 +224,11 @@ long omap4_dpll_regm4xen_determine_rate(struct clk_hw *hw, unsigned long rate,
 	    (dd->modes & (1 << DPLL_LOW_POWER_BYPASS))) {
 		*best_parent_clk = __clk_get_hw(dd->clk_bypass);
 	} else {
-		rate = omap4_dpll_regm4xen_round_rate(hw, rate,
-						      best_parent_rate);
+		ret = omap4_dpll_regm4xen_round_rate(hw, &rate,
+						     best_parent_rate);
+		if (ret)
+			return ret;
+
 		*best_parent_clk = __clk_get_hw(dd->clk_ref);
 	}
 
diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index f61158c..774ac3b 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -507,12 +507,19 @@ static unsigned long spc_recalc_rate(struct clk_hw *hw,
 	return freq * 1000;
 }
 
-static long spc_round_rate(struct clk_hw *hw, unsigned long drate,
+static int spc_round_rate(struct clk_hw *hw, unsigned long *drate,
 		unsigned long *parent_rate)
 {
 	struct clk_spc *spc = to_clk_spc(hw);
+	long ret;
 
-	return ve_spc_round_performance(spc->cluster, drate);
+	ret = ve_spc_round_performance(spc->cluster, *drate);
+	if (ret < 0)
+		return ret;
+
+	*drate = ret;
+
+	return 0;
 }
 
 static int spc_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/arch/mips/alchemy/common/clock.c b/arch/mips/alchemy/common/clock.c
index 6a98d2c..d697d8f 100644
--- a/arch/mips/alchemy/common/clock.c
+++ b/arch/mips/alchemy/common/clock.c
@@ -202,24 +202,27 @@ static int alchemy_clk_aux_setr(struct clk_hw *hw,
 	return 0;
 }
 
-static long alchemy_clk_aux_roundr(struct clk_hw *hw,
-					    unsigned long rate,
+static int alchemy_clk_aux_roundr(struct clk_hw *hw,
+					    unsigned long *rate,
 					    unsigned long *parent_rate)
 {
 	struct alchemy_auxpll_clk *a = to_auxpll_clk(hw);
 	unsigned long mult;
 
-	if (!rate || !*parent_rate)
+	if (!*rate || !*parent_rate) {
+		*rate = 0;
 		return 0;
+	}
 
-	mult = rate / (*parent_rate);
+	mult = *rate / (*parent_rate);
 
 	if (mult && (mult < 7))
 		mult = 7;
 	if (mult > a->maxmult)
 		mult = a->maxmult;
 
-	return (*parent_rate) * mult;
+	*rate = (*parent_rate) * mult;
+	return 0;
 }
 
 static struct clk_ops alchemy_clkops_aux = {
diff --git a/drivers/clk/at91/clk-h32mx.c b/drivers/clk/at91/clk-h32mx.c
index 152dcb3..e48f31e 100644
--- a/drivers/clk/at91/clk-h32mx.c
+++ b/drivers/clk/at91/clk-h32mx.c
@@ -49,21 +49,25 @@ static unsigned long clk_sama5d4_h32mx_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long clk_sama5d4_h32mx_round_rate(struct clk_hw *hw, unsigned long rate,
-				       unsigned long *parent_rate)
+static int clk_sama5d4_h32mx_round_rate(struct clk_hw *hw,
+					unsigned long *rate,
+					unsigned long *parent_rate)
 {
 	unsigned long div;
 
-	if (rate > *parent_rate)
-		return *parent_rate;
-	div = *parent_rate / 2;
-	if (rate < div)
-		return div;
+	if (*rate > *parent_rate) {
+		*rate = *parent_rate;
+		return 0;
+	}
 
-	if (rate - div < *parent_rate - rate)
-		return div;
+	div = *parent_rate / 2;
+	if (*rate < div || (*rate - div) < (*parent_rate - *rate)) {
+		*rate = div;
+		return 0;
+	}
 
-	return *parent_rate;
+	*rate = *parent_rate;
+	return 0;
 }
 
 static int clk_sama5d4_h32mx_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
index 597fed4..d990ae0 100644
--- a/drivers/clk/at91/clk-peripheral.c
+++ b/drivers/clk/at91/clk-peripheral.c
@@ -227,9 +227,9 @@ clk_sam9x5_peripheral_recalc_rate(struct clk_hw *hw,
 	return parent_rate >> periph->div;
 }
 
-static long clk_sam9x5_peripheral_round_rate(struct clk_hw *hw,
-					     unsigned long rate,
-					     unsigned long *parent_rate)
+static int clk_sam9x5_peripheral_round_rate(struct clk_hw *hw,
+					    unsigned long *rate,
+					    unsigned long *parent_rate)
 {
 	int shift = 0;
 	unsigned long best_rate;
@@ -238,8 +238,10 @@ static long clk_sam9x5_peripheral_round_rate(struct clk_hw *hw,
 	unsigned long cur_diff;
 	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
 
-	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max)
-		return *parent_rate;
+	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max) {
+		*rate = *parent_rate;
+		return 0;
+	}
 
 	if (periph->range.max) {
 		for (; shift < PERIPHERAL_MAX_SHIFT; shift++) {
@@ -249,28 +251,31 @@ static long clk_sam9x5_peripheral_round_rate(struct clk_hw *hw,
 		}
 	}
 
-	if (rate >= cur_rate)
-		return cur_rate;
+	if (*rate >= cur_rate) {
+		*rate = cur_rate;
+		return 0;
+	}
 
-	best_diff = cur_rate - rate;
+	best_diff = cur_rate - *rate;
 	best_rate = cur_rate;
 	for (; shift < PERIPHERAL_MAX_SHIFT; shift++) {
 		cur_rate = *parent_rate >> shift;
-		if (cur_rate < rate)
-			cur_diff = rate - cur_rate;
+		if (cur_rate < *rate)
+			cur_diff = *rate - cur_rate;
 		else
-			cur_diff = cur_rate - rate;
+			cur_diff = cur_rate - *rate;
 
 		if (cur_diff < best_diff) {
 			best_diff = cur_diff;
 			best_rate = cur_rate;
 		}
 
-		if (!best_diff || cur_rate < rate)
+		if (!best_diff || cur_rate < *rate)
 			break;
 	}
 
-	return best_rate;
+	*rate = best_rate;
+	return 0;
 }
 
 static int clk_sam9x5_peripheral_set_rate(struct clk_hw *hw,
diff --git a/drivers/clk/at91/clk-pll.c b/drivers/clk/at91/clk-pll.c
index 6ec79db..e7754eb 100644
--- a/drivers/clk/at91/clk-pll.c
+++ b/drivers/clk/at91/clk-pll.c
@@ -260,13 +260,19 @@ static long clk_pll_get_best_div_mul(struct clk_pll *pll, unsigned long rate,
 	return bestrate;
 }
 
-static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-					unsigned long *parent_rate)
+static int clk_pll_round_rate(struct clk_hw *hw, unsigned long *rate,
+			      unsigned long *parent_rate)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
+	long ret;
 
-	return clk_pll_get_best_div_mul(pll, rate, *parent_rate,
-					NULL, NULL, NULL);
+	ret = clk_pll_get_best_div_mul(pll, *rate, *parent_rate,
+				       NULL, NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	*rate = ret;
+	return 0;
 }
 
 static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/at91/clk-plldiv.c b/drivers/clk/at91/clk-plldiv.c
index ea22656..c267214 100644
--- a/drivers/clk/at91/clk-plldiv.c
+++ b/drivers/clk/at91/clk-plldiv.c
@@ -36,21 +36,23 @@ static unsigned long clk_plldiv_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long clk_plldiv_round_rate(struct clk_hw *hw, unsigned long rate,
-					unsigned long *parent_rate)
+static int clk_plldiv_round_rate(struct clk_hw *hw, unsigned long *rate,
+				 unsigned long *parent_rate)
 {
 	unsigned long div;
 
-	if (rate > *parent_rate)
-		return *parent_rate;
-	div = *parent_rate / 2;
-	if (rate < div)
-		return div;
+	if (*rate > *parent_rate) {
+		*rate = *parent_rate;
+		return 0;
+	}
 
-	if (rate - div < *parent_rate - rate)
-		return div;
+	div = *parent_rate / 2;
+	if (*rate < div || (*rate - div) < (*parent_rate - *rate))
+		*rate = div;
+	else
+		*rate = *parent_rate;
 
-	return *parent_rate;
+	return 0;
 }
 
 static int clk_plldiv_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/at91/clk-smd.c b/drivers/clk/at91/clk-smd.c
index 144d47e..cd0f6d2 100644
--- a/drivers/clk/at91/clk-smd.c
+++ b/drivers/clk/at91/clk-smd.c
@@ -43,26 +43,32 @@ static unsigned long at91sam9x5_clk_smd_recalc_rate(struct clk_hw *hw,
 	return parent_rate / (smddiv + 1);
 }
 
-static long at91sam9x5_clk_smd_round_rate(struct clk_hw *hw, unsigned long rate,
-					  unsigned long *parent_rate)
+static int at91sam9x5_clk_smd_round_rate(struct clk_hw *hw,
+					 unsigned long *rate,
+					 unsigned long *parent_rate)
 {
 	unsigned long div;
 	unsigned long bestrate;
 	unsigned long tmp;
 
-	if (rate >= *parent_rate)
-		return *parent_rate;
+	if (*rate >= *parent_rate) {
+		*rate = *parent_rate;
+		return 0;
+	}
 
-	div = *parent_rate / rate;
-	if (div > SMD_MAX_DIV)
-		return *parent_rate / (SMD_MAX_DIV + 1);
+	div = *parent_rate / *rate;
+	if (div > SMD_MAX_DIV) {
+		*rate = *parent_rate / (SMD_MAX_DIV + 1);
+		return 0;
+	}
 
 	bestrate = *parent_rate / div;
 	tmp = *parent_rate / (div + 1);
-	if (bestrate - rate > rate - tmp)
+	if (bestrate - *rate > *rate - tmp)
 		bestrate = tmp;
 
-	return bestrate;
+	*rate = bestrate;
+	return 0;
 }
 
 static int at91sam9x5_clk_smd_set_parent(struct clk_hw *hw, u8 index)
diff --git a/drivers/clk/at91/clk-usb.c b/drivers/clk/at91/clk-usb.c
index a23ac0c..02599e6 100644
--- a/drivers/clk/at91/clk-usb.c
+++ b/drivers/clk/at91/clk-usb.c
@@ -56,22 +56,26 @@ static unsigned long at91sam9x5_clk_usb_recalc_rate(struct clk_hw *hw,
 	return DIV_ROUND_CLOSEST(parent_rate, (usbdiv + 1));
 }
 
-static long at91sam9x5_clk_usb_round_rate(struct clk_hw *hw, unsigned long rate,
-					  unsigned long *parent_rate)
+static int at91sam9x5_clk_usb_round_rate(struct clk_hw *hw,
+					 unsigned long *rate,
+					 unsigned long *parent_rate)
 {
 	unsigned long div;
 
-	if (!rate)
+	if (!*rate)
 		return -EINVAL;
 
-	if (rate >= *parent_rate)
-		return *parent_rate;
+	if (*rate >= *parent_rate) {
+		*rate = *parent_rate;
+		return 0;
+	}
 
-	div = DIV_ROUND_CLOSEST(*parent_rate, rate);
+	div = DIV_ROUND_CLOSEST(*parent_rate, *rate);
 	if (div > SAM9X5_USB_MAX_DIV + 1)
 		div = SAM9X5_USB_MAX_DIV + 1;
 
-	return DIV_ROUND_CLOSEST(*parent_rate, div);
+	*rate = DIV_ROUND_CLOSEST(*parent_rate, div);
+	return 0;
 }
 
 static int at91sam9x5_clk_usb_set_parent(struct clk_hw *hw, u8 index)
@@ -235,8 +239,9 @@ static unsigned long at91rm9200_clk_usb_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long at91rm9200_clk_usb_round_rate(struct clk_hw *hw, unsigned long rate,
-					  unsigned long *parent_rate)
+static int at91rm9200_clk_usb_round_rate(struct clk_hw *hw,
+					 unsigned long *rate,
+					 unsigned long *parent_rate)
 {
 	struct at91rm9200_clk_usb *usb = to_at91rm9200_clk_usb(hw);
 	struct clk *parent = __clk_get_parent(hw->clk);
@@ -252,13 +257,13 @@ static long at91rm9200_clk_usb_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (!usb->divisors[i])
 			continue;
 
-		tmp_parent_rate = rate * usb->divisors[i];
+		tmp_parent_rate = *rate * usb->divisors[i];
 		tmp_parent_rate = __clk_round_rate(parent, tmp_parent_rate);
 		tmprate = DIV_ROUND_CLOSEST(tmp_parent_rate, usb->divisors[i]);
-		if (tmprate < rate)
-			tmpdiff = rate - tmprate;
+		if (tmprate < *rate)
+			tmpdiff = *rate - tmprate;
 		else
-			tmpdiff = tmprate - rate;
+			tmpdiff = tmprate - *rate;
 
 		if (bestdiff < 0 || bestdiff > tmpdiff) {
 			bestrate = tmprate;
@@ -270,7 +275,8 @@ static long at91rm9200_clk_usb_round_rate(struct clk_hw *hw, unsigned long rate,
 			break;
 	}
 
-	return bestrate;
+	*rate = bestrate;
+	return 0;
 }
 
 static int at91rm9200_clk_usb_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index e619285..3509d50 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -405,7 +405,7 @@ static int axi_clkgen_set_rate(struct clk_hw *clk_hw,
 	return 0;
 }
 
-static long axi_clkgen_round_rate(struct clk_hw *hw, unsigned long rate,
+static int axi_clkgen_round_rate(struct clk_hw *hw, unsigned long *rate,
 	unsigned long *parent_rate)
 {
 	unsigned int d, m, dout;
@@ -415,7 +415,8 @@ static long axi_clkgen_round_rate(struct clk_hw *hw, unsigned long rate,
 	if (d == 0 || dout == 0 || m == 0)
 		return -EINVAL;
 
-	return *parent_rate / d * m / dout;
+	*rate = *parent_rate / d * m / dout;
+	return 0;
 }
 
 static unsigned long axi_clkgen_recalc_rate(struct clk_hw *clk_hw,
diff --git a/drivers/clk/clk-cdce706.c b/drivers/clk/clk-cdce706.c
index c386ad2..f110959 100644
--- a/drivers/clk/clk-cdce706.c
+++ b/drivers/clk/clk-cdce706.c
@@ -187,8 +187,8 @@ static unsigned long cdce706_pll_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long cdce706_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *parent_rate)
+static int cdce706_pll_round_rate(struct clk_hw *hw, unsigned long *rate,
+				  unsigned long *parent_rate)
 {
 	struct cdce706_hw_data *hwd = to_hw_data(hw);
 	unsigned long mul, div;
@@ -196,9 +196,9 @@ static long cdce706_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 
 	dev_dbg(&hwd->dev_data->client->dev,
 		"%s, rate: %lu, parent_rate: %lu\n",
-		__func__, rate, *parent_rate);
+		__func__, *rate, *parent_rate);
 
-	rational_best_approximation(rate, *parent_rate,
+	rational_best_approximation(*rate, *parent_rate,
 				    CDCE706_PLL_N_MAX, CDCE706_PLL_M_MAX,
 				    &mul, &div);
 	hwd->mul = mul;
@@ -210,7 +210,8 @@ static long cdce706_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 
 	res = (u64)*parent_rate * hwd->mul;
 	do_div(res, hwd->div);
-	return res;
+	*rate = res;
+	return 0;
 }
 
 static int cdce706_pll_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -292,8 +293,8 @@ static unsigned long cdce706_divider_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long cdce706_divider_round_rate(struct clk_hw *hw, unsigned long rate,
-				       unsigned long *parent_rate)
+static int cdce706_divider_round_rate(struct clk_hw *hw, unsigned long *rate,
+				      unsigned long *parent_rate)
 {
 	struct cdce706_hw_data *hwd = to_hw_data(hw);
 	struct cdce706_dev_data *cdce = hwd->dev_data;
@@ -301,31 +302,31 @@ static long cdce706_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 
 	dev_dbg(&hwd->dev_data->client->dev,
 		"%s, rate: %lu, parent_rate: %lu\n",
-		__func__, rate, *parent_rate);
+		__func__, *rate, *parent_rate);
 
-	rational_best_approximation(rate, *parent_rate,
+	rational_best_approximation(*rate, *parent_rate,
 				    1, CDCE706_DIVIDER_DIVIDER_MAX,
 				    &mul, &div);
 	if (!mul)
 		div = CDCE706_DIVIDER_DIVIDER_MAX;
 
 	if (__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT) {
-		unsigned long best_diff = rate;
+		unsigned long best_diff = *rate;
 		unsigned long best_div = 0;
 		struct clk *gp_clk = cdce->clkin_clk[cdce->clkin[0].parent];
 		unsigned long gp_rate = gp_clk ? clk_get_rate(gp_clk) : 0;
 
-		for (div = CDCE706_PLL_FREQ_MIN / rate; best_diff &&
-		     div <= CDCE706_PLL_FREQ_MAX / rate; ++div) {
+		for (div = CDCE706_PLL_FREQ_MIN / *rate; best_diff &&
+		     div <= CDCE706_PLL_FREQ_MAX / *rate; ++div) {
 			unsigned long n, m;
 			unsigned long diff;
 			unsigned long div_rate;
 			u64 div_rate64;
 
-			if (rate * div < CDCE706_PLL_FREQ_MIN)
+			if (*rate * div < CDCE706_PLL_FREQ_MIN)
 				continue;
 
-			rational_best_approximation(rate * div, gp_rate,
+			rational_best_approximation(*rate * div, gp_rate,
 						    CDCE706_PLL_N_MAX,
 						    CDCE706_PLL_M_MAX,
 						    &n, &m);
@@ -333,7 +334,7 @@ static long cdce706_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 			do_div(div_rate64, m);
 			do_div(div_rate64, div);
 			div_rate = div_rate64;
-			diff = max(div_rate, rate) - min(div_rate, rate);
+			diff = max(div_rate, *rate) - min(div_rate, *rate);
 
 			if (diff < best_diff) {
 				best_diff = diff;
@@ -348,8 +349,8 @@ static long cdce706_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 
 		dev_dbg(&hwd->dev_data->client->dev,
 			"%s, altering parent rate: %lu -> %lu\n",
-			__func__, *parent_rate, rate * div);
-		*parent_rate = rate * div;
+			__func__, *parent_rate, *rate * div);
+		*parent_rate = *rate * div;
 	}
 	hwd->div = div;
 
@@ -357,7 +358,8 @@ static long cdce706_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 		"%s, divider: %d, div: %lu\n",
 		__func__, hwd->idx, div);
 
-	return *parent_rate / div;
+	*rate = *parent_rate / div;
+	return 0;
 }
 
 static int cdce706_divider_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -425,11 +427,11 @@ static unsigned long cdce706_clkout_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long cdce706_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *parent_rate)
+static int cdce706_clkout_round_rate(struct clk_hw *hw, unsigned long *rate,
+				     unsigned long *parent_rate)
 {
-	*parent_rate = rate;
-	return rate;
+	*parent_rate = *rate;
+	return 0;
 }
 
 static int cdce706_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
index 956b7e5..f56a71d 100644
--- a/drivers/clk/clk-composite.c
+++ b/drivers/clk/clk-composite.c
@@ -68,10 +68,10 @@ static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_hw *mux_hw = composite->mux_hw;
 	struct clk *parent;
 	unsigned long parent_rate;
-	long tmp_rate, best_rate = 0;
+	unsigned long tmp_rate, best_rate = 0;
 	unsigned long rate_diff;
 	unsigned long best_rate_diff = ULONG_MAX;
-	int i;
+	int ret, i;
 
 	if (rate_hw && rate_ops && rate_ops->determine_rate) {
 		__clk_hw_set_clk(rate_hw, hw);
@@ -88,8 +88,12 @@ static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 			*best_parent_p = __clk_get_hw(parent);
 			*best_parent_rate = __clk_get_rate(parent);
 
-			return rate_ops->round_rate(rate_hw, rate,
-						    best_parent_rate);
+			ret = rate_ops->round_rate(rate_hw, &rate,
+						   best_parent_rate);
+			if (ret)
+				return ret;
+
+			return rate;
 		}
 
 		for (i = 0; i < __clk_get_num_parents(mux_hw->clk); i++) {
@@ -99,9 +103,10 @@ static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 
 			parent_rate = __clk_get_rate(parent);
 
-			tmp_rate = rate_ops->round_rate(rate_hw, rate,
-							&parent_rate);
-			if (tmp_rate < 0)
+			tmp_rate = rate;
+			ret = rate_ops->round_rate(rate_hw, &tmp_rate,
+						   &parent_rate);
+			if (ret < 0)
 				continue;
 
 			rate_diff = abs(rate - tmp_rate);
@@ -130,8 +135,8 @@ static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 	}
 }
 
-static long clk_composite_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static int clk_composite_round_rate(struct clk_hw *hw, unsigned long *rate,
+				     unsigned long *prate)
 {
 	struct clk_composite *composite = to_clk_composite(hw);
 	const struct clk_ops *rate_ops = composite->rate_ops;
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 25006a8..f646a0c 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -329,19 +329,20 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	return bestdiv;
 }
 
-long divider_round_rate(struct clk_hw *hw, unsigned long rate,
-			unsigned long *prate, const struct clk_div_table *table,
-			u8 width, unsigned long flags)
+int divider_round_rate(struct clk_hw *hw, unsigned long *rate,
+		       unsigned long *prate, const struct clk_div_table *table,
+		       u8 width, unsigned long flags)
 {
 	int div;
 
-	div = clk_divider_bestdiv(hw, rate, prate, table, width, flags);
+	div = clk_divider_bestdiv(hw, *rate, prate, table, width, flags);
 
-	return DIV_ROUND_UP(*prate, div);
+	*rate = DIV_ROUND_UP(*prate, div);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(divider_round_rate);
 
-static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_divider_round_rate(struct clk_hw *hw, unsigned long *rate,
 				unsigned long *prate)
 {
 	struct clk_divider *divider = to_clk_divider(hw);
@@ -352,7 +353,8 @@ static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 		bestdiv = readl(divider->reg) >> divider->shift;
 		bestdiv &= div_mask(divider->width);
 		bestdiv = _get_div(divider->table, bestdiv, divider->flags);
-		return DIV_ROUND_UP(*prate, bestdiv);
+		*rate = DIV_ROUND_UP(*prate, bestdiv);
+		return 0;
 	}
 
 	return divider_round_rate(hw, rate, prate, divider->table,
diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
index d9e3f67..ff936d0 100644
--- a/drivers/clk/clk-fixed-factor.c
+++ b/drivers/clk/clk-fixed-factor.c
@@ -36,7 +36,7 @@ static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
 	return (unsigned long)rate;
 }
 
-static long clk_factor_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_factor_round_rate(struct clk_hw *hw, unsigned long *rate,
 				unsigned long *prate)
 {
 	struct clk_fixed_factor *fix = to_clk_fixed_factor(hw);
@@ -44,12 +44,13 @@ static long clk_factor_round_rate(struct clk_hw *hw, unsigned long rate,
 	if (__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT) {
 		unsigned long best_parent;
 
-		best_parent = (rate / fix->mult) * fix->div;
+		best_parent = (*rate / fix->mult) * fix->div;
 		*prate = __clk_round_rate(__clk_get_parent(hw->clk),
 				best_parent);
 	}
 
-	return (*prate / fix->div) * fix->mult;
+	*rate = (*prate / fix->div) * fix->mult;
+	return 0;
 }
 
 static int clk_factor_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
index 6aa72d9..1f1ba3e 100644
--- a/drivers/clk/clk-fractional-divider.c
+++ b/drivers/clk/clk-fractional-divider.c
@@ -45,24 +45,26 @@ static unsigned long clk_fd_recalc_rate(struct clk_hw *hw,
 	return ret;
 }
 
-static long clk_fd_round_rate(struct clk_hw *hw, unsigned long rate,
-			      unsigned long *prate)
+static int clk_fd_round_rate(struct clk_hw *hw, unsigned long *rate,
+			     unsigned long *prate)
 {
 	struct clk_fractional_divider *fd = to_clk_fd(hw);
 	unsigned maxn = (fd->nmask >> fd->nshift) + 1;
 	unsigned div;
 
-	if (!rate || rate >= *prate)
-		return *prate;
+	if (!*rate || *rate >= *prate) {
+		*rate = *prate;
+		return 0;
+	}
 
-	div = gcd(*prate, rate);
+	div = gcd(*prate, *rate);
 
 	while ((*prate / div) > maxn) {
 		div <<= 1;
-		rate <<= 1;
+		*rate <<= 1;
 	}
 
-	return rate;
+	return 0;
 }
 
 static int clk_fd_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 2e7e9d9..f26d1b0 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -142,15 +142,16 @@ static void clk_pll_calc(unsigned long rate, unsigned long ref_freq,
 	*pdivf = divf;
 }
 
-static long clk_pll_round_rate(struct clk_hw *hwclk, unsigned long rate,
-			       unsigned long *parent_rate)
+static int clk_pll_round_rate(struct clk_hw *hwclk, unsigned long *rate,
+			      unsigned long *parent_rate)
 {
 	u32 divq, divf;
 	unsigned long ref_freq = *parent_rate;
 
-	clk_pll_calc(rate, ref_freq, &divq, &divf);
+	clk_pll_calc(*rate, ref_freq, &divq, &divf);
 
-	return (ref_freq * (divf + 1)) / (1 << divq);
+	*rate = (ref_freq * (divf + 1)) / (1 << divq);
+	return 0;
 }
 
 static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
@@ -239,16 +240,17 @@ static unsigned long clk_periclk_recalc_rate(struct clk_hw *hwclk,
 	return parent_rate / div;
 }
 
-static long clk_periclk_round_rate(struct clk_hw *hwclk, unsigned long rate,
-				   unsigned long *parent_rate)
+static int clk_periclk_round_rate(struct clk_hw *hwclk, unsigned long *rate,
+				  unsigned long *parent_rate)
 {
 	u32 div;
 
-	div = *parent_rate / rate;
+	div = *parent_rate / *rate;
 	div++;
 	div &= ~0x1;
 
-	return *parent_rate / div;
+	*rate = *parent_rate / div;
+	return 0;
 }
 
 static int clk_periclk_set_rate(struct clk_hw *hwclk, unsigned long rate,
diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 3b2a66f..8fad555 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -446,30 +446,30 @@ static unsigned long si5351_pll_recalc_rate(struct clk_hw *hw,
 	return (unsigned long)rate;
 }
 
-static long si5351_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *parent_rate)
+static int si5351_pll_round_rate(struct clk_hw *hw, unsigned long *rate,
+				 unsigned long *parent_rate)
 {
 	struct si5351_hw_data *hwdata =
 		container_of(hw, struct si5351_hw_data, hw);
 	unsigned long rfrac, denom, a, b, c;
 	unsigned long long lltmp;
 
-	if (rate < SI5351_PLL_VCO_MIN)
-		rate = SI5351_PLL_VCO_MIN;
-	if (rate > SI5351_PLL_VCO_MAX)
-		rate = SI5351_PLL_VCO_MAX;
+	if (*rate < SI5351_PLL_VCO_MIN)
+		*rate = SI5351_PLL_VCO_MIN;
+	if (*rate > SI5351_PLL_VCO_MAX)
+		*rate = SI5351_PLL_VCO_MAX;
 
 	/* determine integer part of feedback equation */
-	a = rate / *parent_rate;
+	a = *rate / *parent_rate;
 
 	if (a < SI5351_PLL_A_MIN)
-		rate = *parent_rate * SI5351_PLL_A_MIN;
+		*rate = *parent_rate * SI5351_PLL_A_MIN;
 	if (a > SI5351_PLL_A_MAX)
-		rate = *parent_rate * SI5351_PLL_A_MAX;
+		*rate = *parent_rate * SI5351_PLL_A_MAX;
 
 	/* find best approximation for b/c = fVCO mod fIN */
 	denom = 1000 * 1000;
-	lltmp = rate % (*parent_rate);
+	lltmp = *rate % (*parent_rate);
 	lltmp *= denom;
 	do_div(lltmp, *parent_rate);
 	rfrac = (unsigned long)lltmp;
@@ -492,15 +492,15 @@ static long si5351_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 	lltmp *= b;
 	do_div(lltmp, c);
 
-	rate  = (unsigned long)lltmp;
-	rate += *parent_rate * a;
+	*rate  = (unsigned long)lltmp;
+	*rate += *parent_rate * a;
 
 	dev_dbg(&hwdata->drvdata->client->dev,
 		"%s - %s: a = %lu, b = %lu, c = %lu, parent_rate = %lu, rate = %lu\n",
 		__func__, __clk_get_name(hwdata->hw.clk), a, b, c,
-		*parent_rate, rate);
+		*parent_rate, *rate);
 
-	return rate;
+	return 0;
 }
 
 static int si5351_pll_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -639,8 +639,8 @@ static unsigned long si5351_msynth_recalc_rate(struct clk_hw *hw,
 	return (unsigned long)rate;
 }
 
-static long si5351_msynth_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *parent_rate)
+static int si5351_msynth_round_rate(struct clk_hw *hw, unsigned long *rate,
+				    unsigned long *parent_rate)
 {
 	struct si5351_hw_data *hwdata =
 		container_of(hw, struct si5351_hw_data, hw);
@@ -649,17 +649,17 @@ static long si5351_msynth_round_rate(struct clk_hw *hw, unsigned long rate,
 	int divby4;
 
 	/* multisync6-7 can only handle freqencies < 150MHz */
-	if (hwdata->num >= 6 && rate > SI5351_MULTISYNTH67_MAX_FREQ)
-		rate = SI5351_MULTISYNTH67_MAX_FREQ;
+	if (hwdata->num >= 6 && *rate > SI5351_MULTISYNTH67_MAX_FREQ)
+		*rate = SI5351_MULTISYNTH67_MAX_FREQ;
 
 	/* multisync frequency is 1MHz .. 160MHz */
-	if (rate > SI5351_MULTISYNTH_MAX_FREQ)
-		rate = SI5351_MULTISYNTH_MAX_FREQ;
-	if (rate < SI5351_MULTISYNTH_MIN_FREQ)
-		rate = SI5351_MULTISYNTH_MIN_FREQ;
+	if (*rate > SI5351_MULTISYNTH_MAX_FREQ)
+		*rate = SI5351_MULTISYNTH_MAX_FREQ;
+	if (*rate < SI5351_MULTISYNTH_MIN_FREQ)
+		*rate = SI5351_MULTISYNTH_MIN_FREQ;
 
 	divby4 = 0;
-	if (rate > SI5351_MULTISYNTH_DIVBY4_FREQ)
+	if (*rate > SI5351_MULTISYNTH_DIVBY4_FREQ)
 		divby4 = 1;
 
 	/* multisync can set pll */
@@ -670,7 +670,7 @@ static long si5351_msynth_round_rate(struct clk_hw *hw, unsigned long rate,
 		 */
 		if (divby4 == 0) {
 			lltmp = SI5351_PLL_VCO_MAX;
-			do_div(lltmp, rate);
+			do_div(lltmp, *rate);
 			a = (unsigned long)lltmp;
 		} else
 			a = 4;
@@ -678,18 +678,18 @@ static long si5351_msynth_round_rate(struct clk_hw *hw, unsigned long rate,
 		b = 0;
 		c = 1;
 
-		*parent_rate = a * rate;
+		*parent_rate = a * *rate;
 	} else {
 		unsigned long rfrac, denom;
 
 		/* disable divby4 */
 		if (divby4) {
-			rate = SI5351_MULTISYNTH_DIVBY4_FREQ;
+			*rate = SI5351_MULTISYNTH_DIVBY4_FREQ;
 			divby4 = 0;
 		}
 
 		/* determine integer part of divider equation */
-		a = *parent_rate / rate;
+		a = *parent_rate / *rate;
 		if (a < SI5351_MULTISYNTH_A_MIN)
 			a = SI5351_MULTISYNTH_A_MIN;
 		if (hwdata->num >= 6 && a > SI5351_MULTISYNTH67_A_MAX)
@@ -699,9 +699,9 @@ static long si5351_msynth_round_rate(struct clk_hw *hw, unsigned long rate,
 
 		/* find best approximation for b/c = fVCO mod fOUT */
 		denom = 1000 * 1000;
-		lltmp = (*parent_rate) % rate;
+		lltmp = (*parent_rate) % *rate;
 		lltmp *= denom;
-		do_div(lltmp, rate);
+		do_div(lltmp, *rate);
 		rfrac = (unsigned long)lltmp;
 
 		b = 0;
@@ -716,7 +716,7 @@ static long si5351_msynth_round_rate(struct clk_hw *hw, unsigned long rate,
 	lltmp  = *parent_rate;
 	lltmp *= c;
 	do_div(lltmp, a * c + b);
-	rate  = (unsigned long)lltmp;
+	*rate  = (unsigned long)lltmp;
 
 	/* calculate parameters */
 	if (divby4) {
@@ -734,9 +734,9 @@ static long si5351_msynth_round_rate(struct clk_hw *hw, unsigned long rate,
 	dev_dbg(&hwdata->drvdata->client->dev,
 		"%s - %s: a = %lu, b = %lu, c = %lu, divby4 = %d, parent_rate = %lu, rate = %lu\n",
 		__func__, __clk_get_name(hwdata->hw.clk), a, b, c, divby4,
-		*parent_rate, rate);
+		*parent_rate, *rate);
 
-	return rate;
+	return 0;
 }
 
 static int si5351_msynth_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -983,57 +983,57 @@ static unsigned long si5351_clkout_recalc_rate(struct clk_hw *hw,
 	return parent_rate >> rdiv;
 }
 
-static long si5351_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *parent_rate)
+static int si5351_clkout_round_rate(struct clk_hw *hw, unsigned long *rate,
+				    unsigned long *parent_rate)
 {
 	struct si5351_hw_data *hwdata =
 		container_of(hw, struct si5351_hw_data, hw);
 	unsigned char rdiv;
 
 	/* clkout6/7 can only handle output freqencies < 150MHz */
-	if (hwdata->num >= 6 && rate > SI5351_CLKOUT67_MAX_FREQ)
-		rate = SI5351_CLKOUT67_MAX_FREQ;
+	if (hwdata->num >= 6 && *rate > SI5351_CLKOUT67_MAX_FREQ)
+		*rate = SI5351_CLKOUT67_MAX_FREQ;
 
 	/* clkout freqency is 8kHz - 160MHz */
-	if (rate > SI5351_CLKOUT_MAX_FREQ)
-		rate = SI5351_CLKOUT_MAX_FREQ;
-	if (rate < SI5351_CLKOUT_MIN_FREQ)
-		rate = SI5351_CLKOUT_MIN_FREQ;
+	if (*rate > SI5351_CLKOUT_MAX_FREQ)
+		*rate = SI5351_CLKOUT_MAX_FREQ;
+	if (*rate < SI5351_CLKOUT_MIN_FREQ)
+		*rate = SI5351_CLKOUT_MIN_FREQ;
 
 	/* request frequency if multisync master */
 	if (__clk_get_flags(hwdata->hw.clk) & CLK_SET_RATE_PARENT) {
 		/* use r divider for frequencies below 1MHz */
 		rdiv = SI5351_OUTPUT_CLK_DIV_1;
-		while (rate < SI5351_MULTISYNTH_MIN_FREQ &&
+		while (*rate < SI5351_MULTISYNTH_MIN_FREQ &&
 		       rdiv < SI5351_OUTPUT_CLK_DIV_128) {
 			rdiv += 1;
-			rate *= 2;
+			*rate *= 2;
 		}
-		*parent_rate = rate;
+		*parent_rate = *rate;
 	} else {
 		unsigned long new_rate, new_err, err;
 
 		/* round to closed rdiv */
 		rdiv = SI5351_OUTPUT_CLK_DIV_1;
 		new_rate = *parent_rate;
-		err = abs(new_rate - rate);
+		err = abs(new_rate - *rate);
 		do {
 			new_rate >>= 1;
-			new_err = abs(new_rate - rate);
+			new_err = abs(new_rate - *rate);
 			if (new_err > err || rdiv == SI5351_OUTPUT_CLK_DIV_128)
 				break;
 			rdiv++;
 			err = new_err;
 		} while (1);
 	}
-	rate = *parent_rate >> rdiv;
+	*rate = *parent_rate >> rdiv;
 
 	dev_dbg(&hwdata->drvdata->client->dev,
 		"%s - %s: rdiv = %u, parent_rate = %lu, rate = %lu\n",
 		__func__, __clk_get_name(hwdata->hw.clk), (1 << rdiv),
-		*parent_rate, rate);
+		*parent_rate, *rate);
 
-	return rate;
+	return 0;
 }
 
 static int si5351_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
index fc167b3..0680863 100644
--- a/drivers/clk/clk-si570.c
+++ b/drivers/clk/clk-si570.c
@@ -245,7 +245,7 @@ static unsigned long si570_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long si570_round_rate(struct clk_hw *hw, unsigned long rate,
+static int si570_round_rate(struct clk_hw *hw, unsigned long *rate,
 		unsigned long *parent_rate)
 {
 	int err;
@@ -253,26 +253,26 @@ static long si570_round_rate(struct clk_hw *hw, unsigned long rate,
 	unsigned int n1, hs_div;
 	struct clk_si570 *data = to_clk_si570(hw);
 
-	if (!rate)
+	if (!*rate)
 		return 0;
 
-	if (div64_u64(abs(rate - data->frequency) * 10000LL,
+	if (div64_u64(abs(*rate - data->frequency) * 10000LL,
 				data->frequency) < 35) {
-		rfreq = div64_u64((data->rfreq * rate) +
+		rfreq = div64_u64((data->rfreq * *rate) +
 				div64_u64(data->frequency, 2), data->frequency);
 		n1 = data->n1;
 		hs_div = data->hs_div;
 
 	} else {
-		err = si570_calc_divs(rate, data, &rfreq, &n1, &hs_div);
+		err = si570_calc_divs(*rate, data, &rfreq, &n1, &hs_div);
 		if (err) {
 			dev_err(&data->i2c_client->dev,
 					"unable to round rate\n");
-			return 0;
+			*rate = 0;
 		}
 	}
 
-	return rate;
+	return 0;
 }
 
 /**
diff --git a/drivers/clk/clk-u300.c b/drivers/clk/clk-u300.c
index 406bfc1..5e3163b 100644
--- a/drivers/clk/clk-u300.c
+++ b/drivers/clk/clk-u300.c
@@ -628,22 +628,27 @@ syscon_clk_recalc_rate(struct clk_hw *hw,
 	}
 }
 
-static long
-syscon_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+static int
+syscon_clk_round_rate(struct clk_hw *hw, unsigned long *rate,
 		      unsigned long *prate)
 {
 	struct clk_syscon *sclk = to_syscon(hw);
 
-	if (sclk->clk_val != U300_SYSCON_SBCER_CPU_CLK_EN)
-		return *prate;
+	if (sclk->clk_val != U300_SYSCON_SBCER_CPU_CLK_EN) {
+		*rate = *prate;
+		return 0;
+	}
 	/* We really only support setting the rate of the CPU clock */
-	if (rate <= 13000000)
-		return 13000000;
-	if (rate <= 52000000)
-		return 52000000;
-	if (rate <= 104000000)
-		return 104000000;
-	return 208000000;
+	if (*rate <= 13000000)
+		*rate = 13000000;
+	else if (*rate <= 52000000)
+		*rate = 52000000;
+	else if (*rate <= 104000000)
+		*rate = 104000000;
+	else
+		*rate = 208000000;
+
+	return 0;
 }
 
 static int syscon_clk_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -1037,26 +1042,28 @@ mclk_clk_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long
-mclk_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+static int
+mclk_clk_round_rate(struct clk_hw *hw, unsigned long *rate,
 		    unsigned long *prate)
 {
-	if (rate <= 18900000)
-		return 18900000;
-	if (rate <= 20800000)
-		return 20800000;
-	if (rate <= 23100000)
-		return 23100000;
-	if (rate <= 26000000)
-		return 26000000;
-	if (rate <= 29700000)
-		return 29700000;
-	if (rate <= 34700000)
-		return 34700000;
-	if (rate <= 41600000)
-		return 41600000;
-	/* Highest rate */
-	return 52000000;
+	if (*rate <= 18900000)
+		*rate = 18900000;
+	else if (*rate <= 20800000)
+		*rate = 20800000;
+	else if (*rate <= 23100000)
+		*rate = 23100000;
+	else if (*rate <= 26000000)
+		*rate = 26000000;
+	else if (*rate <= 29700000)
+		*rate = 29700000;
+	else if (*rate <= 34700000)
+		*rate = 34700000;
+	else if (*rate <= 41600000)
+		*rate = 41600000;
+	else
+		*rate = 52000000;
+
+	return 0;
 }
 
 static int mclk_clk_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index 37e9288..221eec3 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -137,19 +137,19 @@ static unsigned long vt8500_dclk_recalc_rate(struct clk_hw *hw,
 	return parent_rate / div;
 }
 
-static long vt8500_dclk_round_rate(struct clk_hw *hw, unsigned long rate,
+static int vt8500_dclk_round_rate(struct clk_hw *hw, unsigned long *rate,
 				unsigned long *prate)
 {
 	struct clk_device *cdev = to_clk_device(hw);
 	u32 divisor;
 
-	if (rate == 0)
+	if (*rate == 0)
 		return 0;
 
-	divisor = *prate / rate;
+	divisor = *prate / *rate;
 
 	/* If prate / rate would be decimal, incr the divisor */
-	if (rate * divisor < *prate)
+	if (*rate * divisor < *prate)
 		divisor++;
 
 	/*
@@ -160,7 +160,8 @@ static long vt8500_dclk_round_rate(struct clk_hw *hw, unsigned long rate,
 		divisor = 64 * ((divisor / 64) + 1);
 	}
 
-	return *prate / divisor;
+	*rate = *prate / divisor;
+	return 0;
 }
 
 static int vt8500_dclk_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -579,8 +580,8 @@ static int vtwm_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
-static long vtwm_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static int vtwm_pll_round_rate(struct clk_hw *hw, unsigned long *rate,
+			       unsigned long *prate)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
 	u32 filter, mul, div1, div2;
@@ -588,26 +589,28 @@ static long vtwm_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 
 	switch (pll->type) {
 	case PLL_TYPE_VT8500:
-		vt8500_find_pll_bits(rate, *prate, &mul, &div1);
+		vt8500_find_pll_bits(*rate, *prate, &mul, &div1);
 		round_rate = VT8500_BITS_TO_FREQ(*prate, mul, div1);
 		break;
 	case PLL_TYPE_WM8650:
-		wm8650_find_pll_bits(rate, *prate, &mul, &div1, &div2);
+		wm8650_find_pll_bits(*rate, *prate, &mul, &div1, &div2);
 		round_rate = WM8650_BITS_TO_FREQ(*prate, mul, div1, div2);
 		break;
 	case PLL_TYPE_WM8750:
-		wm8750_find_pll_bits(rate, *prate, &filter, &mul, &div1, &div2);
+		wm8750_find_pll_bits(*rate, *prate, &filter, &mul, &div1,
+				     &div2);
 		round_rate = WM8750_BITS_TO_FREQ(*prate, mul, div1, div2);
 		break;
 	case PLL_TYPE_WM8850:
-		wm8850_find_pll_bits(rate, *prate, &mul, &div1, &div2);
+		wm8850_find_pll_bits(*rate, *prate, &mul, &div1, &div2);
 		round_rate = WM8850_BITS_TO_FREQ(*prate, mul, div1, div2);
 		break;
 	default:
 		round_rate = 0;
 	}
 
-	return round_rate;
+	*rate = round_rate;
+	return 0;
 }
 
 static unsigned long vtwm_pll_recalc_rate(struct clk_hw *hw,
diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index ef67719..23db1b5 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -142,18 +142,19 @@ static unsigned long wm831x_fll_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long wm831x_fll_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *unused)
+static int wm831x_fll_round_rate(struct clk_hw *hw, unsigned long *rate,
+				 unsigned long *unused)
 {
 	int best = 0;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_fll_auto_rates); i++)
-		if (abs(wm831x_fll_auto_rates[i] - rate) <
-		    abs(wm831x_fll_auto_rates[best] - rate))
+		if (abs(wm831x_fll_auto_rates[i] - *rate) <
+		    abs(wm831x_fll_auto_rates[best] - *rate))
 			best = i;
 
-	return wm831x_fll_auto_rates[best];
+	*rate = wm831x_fll_auto_rates[best];
+	return 0;
 }
 
 static int wm831x_fll_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/clk-xgene.c b/drivers/clk/clk-xgene.c
index dd8a62d..27460e3 100644
--- a/drivers/clk/clk-xgene.c
+++ b/drivers/clk/clk-xgene.c
@@ -367,7 +367,7 @@ static int xgene_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	return parent_rate / divider_save;
 }
 
-static long xgene_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+static int xgene_clk_round_rate(struct clk_hw *hw, unsigned long *rate,
 				unsigned long *prate)
 {
 	struct xgene_clk *pclk = to_xgene_clk(hw);
@@ -376,14 +376,15 @@ static long xgene_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (pclk->param.divider_reg) {
 		/* Let's compute the divider */
-		if (rate > parent_rate)
-			rate = parent_rate;
-		divider = parent_rate / rate;   /* Rounded down */
+		if (*rate > parent_rate)
+			*rate = parent_rate;
+		divider = parent_rate / *rate;   /* Rounded down */
 	} else {
 		divider = 1;
 	}
 
-	return parent_rate / divider;
+	*rate = parent_rate / divider;
+	return 0;
 }
 
 const struct clk_ops xgene_clk_ops = {
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index fa5a00e..1462ddc 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1146,9 +1146,12 @@ static unsigned long clk_core_round_rate_nolock(struct clk_core *clk,
 		return clk->ops->determine_rate(clk->hw, rate,
 						min_rate, max_rate,
 						&parent_rate, &parent_hw);
-	} else if (clk->ops->round_rate)
-		return clk->ops->round_rate(clk->hw, rate, &parent_rate);
-	else if (clk->flags & CLK_SET_RATE_PARENT)
+	} else if (clk->ops->round_rate) {
+		if (clk->ops->round_rate(clk->hw, &rate, &parent_rate))
+			return 0;
+
+		return rate;
+	} else if (clk->flags & CLK_SET_RATE_PARENT)
 		return clk_core_round_rate_nolock(clk->parent, rate, min_rate,
 						  max_rate);
 	else
@@ -1640,8 +1643,10 @@ static struct clk_core *clk_calc_new_rates(struct clk_core *clk,
 						    &parent_hw);
 		parent = parent_hw ? parent_hw->core : NULL;
 	} else if (clk->ops->round_rate) {
-		new_rate = clk->ops->round_rate(clk->hw, rate,
-						&best_parent_rate);
+		if (clk->ops->round_rate(clk->hw, &new_rate,
+					 &best_parent_rate))
+			return NULL;
+
 		if (new_rate < min_rate || new_rate > max_rate)
 			return NULL;
 	} else if (!parent || !(clk->flags & CLK_SET_RATE_PARENT)) {
diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index 584a992..6652983 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -24,7 +24,7 @@
 
 #define to_clk_factor(hw) container_of(hw, struct mmp_clk_factor, hw)
 
-static long clk_factor_round_rate(struct clk_hw *hw, unsigned long drate,
+static int clk_factor_round_rate(struct clk_hw *hw, unsigned long *drate,
 		unsigned long *prate)
 {
 	struct mmp_clk_factor *factor = to_clk_factor(hw);
@@ -35,17 +35,19 @@ static long clk_factor_round_rate(struct clk_hw *hw, unsigned long drate,
 		prev_rate = rate;
 		rate = (((*prate / 10000) * factor->ftbl[i].den) /
 			(factor->ftbl[i].num * factor->masks->factor)) * 10000;
-		if (rate > drate)
+		if (rate > *drate)
 			break;
 	}
 	if ((i == 0) || (i == factor->ftbl_cnt)) {
-		return rate;
+		*drate = rate;
 	} else {
-		if ((drate - prev_rate) > (rate - drate))
-			return rate;
+		if ((*drate - prev_rate) > (rate - *drate))
+			*drate = rate;
 		else
-			return prev_rate;
+			*drate = prev_rate;
 	}
+
+	return 0;
 }
 
 static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
diff --git a/drivers/clk/mvebu/clk-corediv.c b/drivers/clk/mvebu/clk-corediv.c
index d1e5863..c5aee2f 100644
--- a/drivers/clk/mvebu/clk-corediv.c
+++ b/drivers/clk/mvebu/clk-corediv.c
@@ -132,19 +132,20 @@ static unsigned long clk_corediv_recalc_rate(struct clk_hw *hwclk,
 	return parent_rate / div;
 }
 
-static long clk_corediv_round_rate(struct clk_hw *hwclk, unsigned long rate,
+static int clk_corediv_round_rate(struct clk_hw *hwclk, unsigned long *rate,
 			       unsigned long *parent_rate)
 {
 	/* Valid ratio are 1:4, 1:5, 1:6 and 1:8 */
 	u32 div;
 
-	div = *parent_rate / rate;
+	div = *parent_rate / *rate;
 	if (div < 4)
 		div = 4;
 	else if (div > 6)
 		div = 8;
 
-	return *parent_rate / div;
+	*rate = *parent_rate / div;
+	return 0;
 }
 
 static int clk_corediv_set_rate(struct clk_hw *hwclk, unsigned long rate,
diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
index 3821a88..0279b50 100644
--- a/drivers/clk/mvebu/clk-cpu.c
+++ b/drivers/clk/mvebu/clk-cpu.c
@@ -57,19 +57,20 @@ static unsigned long clk_cpu_recalc_rate(struct clk_hw *hwclk,
 	return parent_rate / div;
 }
 
-static long clk_cpu_round_rate(struct clk_hw *hwclk, unsigned long rate,
-			       unsigned long *parent_rate)
+static int clk_cpu_round_rate(struct clk_hw *hwclk, unsigned long *rate,
+			      unsigned long *parent_rate)
 {
 	/* Valid ratio are 1:1, 1:2 and 1:3 */
 	u32 div;
 
-	div = *parent_rate / rate;
+	div = *parent_rate / *rate;
 	if (div == 0)
 		div = 1;
 	else if (div > 3)
 		div = 3;
 
-	return *parent_rate / div;
+	*rate = *parent_rate / div;
+	return 0;
 }
 
 static int clk_cpu_off_set_rate(struct clk_hw *hwclk, unsigned long rate,
diff --git a/drivers/clk/mxs/clk-div.c b/drivers/clk/mxs/clk-div.c
index 90e1da9..3677e51 100644
--- a/drivers/clk/mxs/clk-div.c
+++ b/drivers/clk/mxs/clk-div.c
@@ -47,8 +47,8 @@ static unsigned long clk_div_recalc_rate(struct clk_hw *hw,
 	return div->ops->recalc_rate(&div->divider.hw, parent_rate);
 }
 
-static long clk_div_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *prate)
+static int clk_div_round_rate(struct clk_hw *hw, unsigned long *rate,
+			      unsigned long *prate)
 {
 	struct clk_div *div = to_clk_div(hw);
 
diff --git a/drivers/clk/mxs/clk-frac.c b/drivers/clk/mxs/clk-frac.c
index e6aa6b5..86fc3bb 100644
--- a/drivers/clk/mxs/clk-frac.c
+++ b/drivers/clk/mxs/clk-frac.c
@@ -49,18 +49,18 @@ static unsigned long clk_frac_recalc_rate(struct clk_hw *hw,
 	return (parent_rate >> frac->width) * div;
 }
 
-static long clk_frac_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static int clk_frac_round_rate(struct clk_hw *hw, unsigned long *rate,
+			       unsigned long *prate)
 {
 	struct clk_frac *frac = to_clk_frac(hw);
 	unsigned long parent_rate = *prate;
 	u32 div;
 	u64 tmp;
 
-	if (rate > parent_rate)
+	if (*rate > parent_rate)
 		return -EINVAL;
 
-	tmp = rate;
+	tmp = *rate;
 	tmp <<= frac->width;
 	do_div(tmp, parent_rate);
 	div = tmp;
@@ -68,7 +68,8 @@ static long clk_frac_round_rate(struct clk_hw *hw, unsigned long rate,
 	if (!div)
 		return -EINVAL;
 
-	return (parent_rate >> frac->width) * div;
+	*rate = (parent_rate >> frac->width) * div;
+	return 0;
 }
 
 static int clk_frac_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/mxs/clk-ref.c b/drivers/clk/mxs/clk-ref.c
index 4adeed6..e0d6529 100644
--- a/drivers/clk/mxs/clk-ref.c
+++ b/drivers/clk/mxs/clk-ref.c
@@ -64,15 +64,15 @@ static unsigned long clk_ref_recalc_rate(struct clk_hw *hw,
 	return tmp;
 }
 
-static long clk_ref_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *prate)
+static int clk_ref_round_rate(struct clk_hw *hw, unsigned long *rate,
+			      unsigned long *prate)
 {
 	unsigned long parent_rate = *prate;
 	u64 tmp = parent_rate;
 	u8 frac;
 
-	tmp = tmp * 18 + rate / 2;
-	do_div(tmp, rate);
+	tmp = tmp * 18 + *rate / 2;
+	do_div(tmp, *rate);
 	frac = tmp;
 
 	if (frac < 18)
@@ -83,8 +83,9 @@ static long clk_ref_round_rate(struct clk_hw *hw, unsigned long rate,
 	tmp = parent_rate;
 	tmp *= 18;
 	do_div(tmp, frac);
+	*rate = tmp;
 
-	return tmp;
+	return 0;
 }
 
 static int clk_ref_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/qcom/clk-regmap-divider.c b/drivers/clk/qcom/clk-regmap-divider.c
index 5348491..1720da4 100644
--- a/drivers/clk/qcom/clk-regmap-divider.c
+++ b/drivers/clk/qcom/clk-regmap-divider.c
@@ -23,8 +23,8 @@ static inline struct clk_regmap_div *to_clk_regmap_div(struct clk_hw *hw)
 	return container_of(to_clk_regmap(hw), struct clk_regmap_div, clkr);
 }
 
-static long div_round_rate(struct clk_hw *hw, unsigned long rate,
-			   unsigned long *prate)
+static int div_round_rate(struct clk_hw *hw, unsigned long *rate,
+			  unsigned long *prate)
 {
 	struct clk_regmap_div *divider = to_clk_regmap_div(hw);
 
diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index f8d3baf..bd408ef 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -63,8 +63,8 @@ static const struct rockchip_pll_rate_table *rockchip_get_pll_settings(
 	return NULL;
 }
 
-static long rockchip_pll_round_rate(struct clk_hw *hw,
-			    unsigned long drate, unsigned long *prate)
+static int rockchip_pll_round_rate(struct clk_hw *hw,
+			    unsigned long *drate, unsigned long *prate)
 {
 	struct rockchip_clk_pll *pll = to_rockchip_clk_pll(hw);
 	const struct rockchip_pll_rate_table *rate_table = pll->rate_table;
@@ -72,12 +72,15 @@ static long rockchip_pll_round_rate(struct clk_hw *hw,
 
 	/* Assumming rate_table is in descending order */
 	for (i = 0; i < pll->rate_count; i++) {
-		if (drate >= rate_table[i].rate)
-			return rate_table[i].rate;
+		if (*drate >= rate_table[i].rate) {
+			*drate = rate_table[i].rate;
+			return 0;
+		}
 	}
 
 	/* return minimum supported value */
-	return rate_table[i - 1].rate;
+	*drate = rate_table[i - 1].rate;
+	return 0;
 }
 
 /*
diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 9d70e5c..0128de2 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -42,8 +42,8 @@ static const struct samsung_pll_rate_table *samsung_get_pll_settings(
 	return NULL;
 }
 
-static long samsung_pll_round_rate(struct clk_hw *hw,
-			unsigned long drate, unsigned long *prate)
+static int samsung_pll_round_rate(struct clk_hw *hw,
+			unsigned long *drate, unsigned long *prate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	const struct samsung_pll_rate_table *rate_table = pll->rate_table;
@@ -51,12 +51,15 @@ static long samsung_pll_round_rate(struct clk_hw *hw,
 
 	/* Assumming rate_table is in descending order */
 	for (i = 0; i < pll->rate_count; i++) {
-		if (drate >= rate_table[i].rate)
-			return rate_table[i].rate;
+		if (*drate >= rate_table[i].rate) {
+			*drate = rate_table[i].rate;
+			return 0;
+		}
 	}
 
 	/* return minimum supported value */
-	return rate_table[i - 1].rate;
+	*drate = rate_table[i - 1].rate;
+	return 0;
 }
 
 /*
diff --git a/drivers/clk/shmobile/clk-div6.c b/drivers/clk/shmobile/clk-div6.c
index 036a692..d31ae3d 100644
--- a/drivers/clk/shmobile/clk-div6.c
+++ b/drivers/clk/shmobile/clk-div6.c
@@ -97,12 +97,13 @@ static unsigned int cpg_div6_clock_calc_div(unsigned long rate,
 	return clamp_t(unsigned int, div, 1, 64);
 }
 
-static long cpg_div6_clock_round_rate(struct clk_hw *hw, unsigned long rate,
+static int cpg_div6_clock_round_rate(struct clk_hw *hw, unsigned long *rate,
 				      unsigned long *parent_rate)
 {
-	unsigned int div = cpg_div6_clock_calc_div(rate, *parent_rate);
+	unsigned int div = cpg_div6_clock_calc_div(*rate, *parent_rate);
 
-	return *parent_rate / div;
+	*rate = *parent_rate / div;
+	return 0;
 }
 
 static int cpg_div6_clock_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/shmobile/clk-rcar-gen2.c b/drivers/clk/shmobile/clk-rcar-gen2.c
index acfb6d7..57581a9 100644
--- a/drivers/clk/shmobile/clk-rcar-gen2.c
+++ b/drivers/clk/shmobile/clk-rcar-gen2.c
@@ -68,8 +68,8 @@ static unsigned long cpg_z_clk_recalc_rate(struct clk_hw *hw,
 	return div_u64((u64)parent_rate * mult, 32);
 }
 
-static long cpg_z_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *parent_rate)
+static int cpg_z_clk_round_rate(struct clk_hw *hw, unsigned long *rate,
+				unsigned long *parent_rate)
 {
 	unsigned long prate  = *parent_rate;
 	unsigned int mult;
@@ -77,10 +77,11 @@ static long cpg_z_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 	if (!prate)
 		prate = 1;
 
-	mult = div_u64((u64)rate * 32, prate);
+	mult = div_u64((u64)*rate * 32, prate);
 	mult = clamp(mult, 1U, 32U);
 
-	return *parent_rate / 32 * mult;
+	*rate = *parent_rate / 32 * mult;
+	return 0;
 }
 
 static int cpg_z_clk_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/sirf/clk-common.c b/drivers/clk/sirf/clk-common.c
index 37af51c..68a7889 100644
--- a/drivers/clk/sirf/clk-common.c
+++ b/drivers/clk/sirf/clk-common.c
@@ -91,7 +91,7 @@ static unsigned long pll_clk_recalc_rate(struct clk_hw *hw,
 	}
 }
 
-static long pll_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+static int pll_clk_round_rate(struct clk_hw *hw, unsigned long *rate,
 	unsigned long *parent_rate)
 {
 	unsigned long fin, nf, nr, od;
@@ -101,9 +101,9 @@ static long pll_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 	 * fout = fin * nf / (nr * od);
 	 * set od = 1, nr = fin/MHz, so fout = nf * MHz
 	 */
-	rate = rate - rate % MHZ;
+	*rate = *rate - *rate % MHZ;
 
-	nf = rate / MHZ;
+	nf = *rate / MHZ;
 	if (nf > BIT(13))
 		nf = BIT(13);
 	if (nf < 1)
@@ -119,7 +119,8 @@ static long pll_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 	dividend = (u64)fin * nf;
 	do_div(dividend, nr * od);
 
-	return (long)dividend;
+	*rate = dividend;
+	return 0;
 }
 
 static int pll_clk_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -158,7 +159,7 @@ static int pll_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
-static long cpu_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+static int cpu_clk_round_rate(struct clk_hw *hw, unsigned long *rate,
 	unsigned long *parent_rate)
 {
 	/*
@@ -347,7 +348,7 @@ static unsigned long dmn_clk_recalc_rate(struct clk_hw *hw,
 	}
 }
 
-static long dmn_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+static int dmn_clk_round_rate(struct clk_hw *hw, unsigned long *rate,
 	unsigned long *parent_rate)
 {
 	unsigned long fin;
@@ -355,7 +356,7 @@ static long dmn_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 	unsigned bits = (strcmp(hw->init->name, "mem") == 0) ? 3 : 4;
 
 	fin = *parent_rate;
-	ratio = fin / rate;
+	ratio = fin / *rate;
 
 	if (ratio < 2)
 		ratio = 2;
@@ -365,7 +366,8 @@ static long dmn_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 	wait = (ratio >> 1) - 1;
 	hold = ratio - wait - 2;
 
-	return fin / (wait + hold + 2);
+	*rate = fin / (wait + hold + 2);
+	return 0;
 }
 
 static int dmn_clk_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/spear/clk-aux-synth.c b/drivers/clk/spear/clk-aux-synth.c
index bdfb442..1a93f6a 100644
--- a/drivers/clk/spear/clk-aux-synth.c
+++ b/drivers/clk/spear/clk-aux-synth.c
@@ -52,14 +52,20 @@ static unsigned long aux_calc_rate(struct clk_hw *hw, unsigned long prate,
 			(rtbl[index].yscale * eq)) * 10000;
 }
 
-static long clk_aux_round_rate(struct clk_hw *hw, unsigned long drate,
+static int clk_aux_round_rate(struct clk_hw *hw, unsigned long *drate,
 		unsigned long *prate)
 {
 	struct clk_aux *aux = to_clk_aux(hw);
 	int unused;
+	long ret;
 
-	return clk_round_rate_index(hw, drate, *prate, aux_calc_rate,
+	ret = clk_round_rate_index(hw, *drate, *prate, aux_calc_rate,
 			aux->rtbl_cnt, &unused);
+	if (ret < 0)
+		return ret;
+
+	*drate = ret;
+	return 0;
 }
 
 static unsigned long clk_aux_recalc_rate(struct clk_hw *hw,
diff --git a/drivers/clk/spear/clk-frac-synth.c b/drivers/clk/spear/clk-frac-synth.c
index dffd4ce..d4098c8 100644
--- a/drivers/clk/spear/clk-frac-synth.c
+++ b/drivers/clk/spear/clk-frac-synth.c
@@ -55,14 +55,20 @@ static unsigned long frac_calc_rate(struct clk_hw *hw, unsigned long prate,
 	return prate;
 }
 
-static long clk_frac_round_rate(struct clk_hw *hw, unsigned long drate,
+static int clk_frac_round_rate(struct clk_hw *hw, unsigned long *drate,
 		unsigned long *prate)
 {
 	struct clk_frac *frac = to_clk_frac(hw);
 	int unused;
+	long ret;
 
-	return clk_round_rate_index(hw, drate, *prate, frac_calc_rate,
+	ret = clk_round_rate_index(hw, *drate, *prate, frac_calc_rate,
 			frac->rtbl_cnt, &unused);
+	if (ret < 0)
+		return ret;
+
+	*drate = ret;
+	return 0;
 }
 
 static unsigned long clk_frac_recalc_rate(struct clk_hw *hw,
diff --git a/drivers/clk/spear/clk-gpt-synth.c b/drivers/clk/spear/clk-gpt-synth.c
index 1afc18c..ea3328b 100644
--- a/drivers/clk/spear/clk-gpt-synth.c
+++ b/drivers/clk/spear/clk-gpt-synth.c
@@ -42,14 +42,20 @@ static unsigned long gpt_calc_rate(struct clk_hw *hw, unsigned long prate,
 	return prate;
 }
 
-static long clk_gpt_round_rate(struct clk_hw *hw, unsigned long drate,
+static int clk_gpt_round_rate(struct clk_hw *hw, unsigned long *drate,
 		unsigned long *prate)
 {
 	struct clk_gpt *gpt = to_clk_gpt(hw);
 	int unused;
+	long ret;
 
-	return clk_round_rate_index(hw, drate, *prate, gpt_calc_rate,
+	ret = clk_round_rate_index(hw, *drate, *prate, gpt_calc_rate,
 			gpt->rtbl_cnt, &unused);
+	if (ret < 0)
+		return ret;
+
+	*drate = ret;
+	return 0;
 }
 
 static unsigned long clk_gpt_recalc_rate(struct clk_hw *hw,
diff --git a/drivers/clk/spear/clk-vco-pll.c b/drivers/clk/spear/clk-vco-pll.c
index 1b9b65b..08b1411 100644
--- a/drivers/clk/spear/clk-vco-pll.c
+++ b/drivers/clk/spear/clk-vco-pll.c
@@ -113,12 +113,18 @@ static long clk_pll_round_rate_index(struct clk_hw *hw, unsigned long drate,
 	return rate;
 }
 
-static long clk_pll_round_rate(struct clk_hw *hw, unsigned long drate,
+static int clk_pll_round_rate(struct clk_hw *hw, unsigned long *drate,
 				unsigned long *prate)
 {
 	int unused;
+	long ret;
 
-	return clk_pll_round_rate_index(hw, drate, prate, &unused);
+	ret = clk_pll_round_rate_index(hw, *drate, prate, &unused);
+	if (ret < 0)
+		return ret;
+
+	*drate = ret;
+	return 0;
 }
 
 static unsigned long clk_pll_recalc_rate(struct clk_hw *hw, unsigned long
@@ -179,14 +185,20 @@ static inline unsigned long vco_calc_rate(struct clk_hw *hw,
 	return pll_calc_rate(vco->rtbl, prate, index, NULL);
 }
 
-static long clk_vco_round_rate(struct clk_hw *hw, unsigned long drate,
+static int clk_vco_round_rate(struct clk_hw *hw, unsigned long *drate,
 		unsigned long *prate)
 {
 	struct clk_vco *vco = to_clk_vco(hw);
 	int unused;
+	long ret;
 
-	return clk_round_rate_index(hw, drate, *prate, vco_calc_rate,
+	ret = clk_round_rate_index(hw, *drate, *prate, vco_calc_rate,
 			vco->rtbl_cnt, &unused);
+	if (ret < 0)
+		return ret;
+
+	*drate = ret;
+	return 0;
 }
 
 static unsigned long clk_vco_recalc_rate(struct clk_hw *hw,
diff --git a/drivers/clk/st/clk-flexgen.c b/drivers/clk/st/clk-flexgen.c
index bf12a25..d04278b 100644
--- a/drivers/clk/st/clk-flexgen.c
+++ b/drivers/clk/st/clk-flexgen.c
@@ -100,20 +100,21 @@ clk_best_div(unsigned long parent_rate, unsigned long rate)
 	return parent_rate / rate + ((rate > (2*(parent_rate % rate))) ? 0 : 1);
 }
 
-static long flexgen_round_rate(struct clk_hw *hw, unsigned long rate,
+static int flexgen_round_rate(struct clk_hw *hw, unsigned long *rate,
 				   unsigned long *prate)
 {
 	unsigned long div;
 
 	/* Round div according to exact prate and wished rate */
-	div = clk_best_div(*prate, rate);
+	div = clk_best_div(*prate, *rate);
 
 	if (__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT) {
-		*prate = rate * div;
-		return rate;
+		*prate = *rate * div;
+		return 0;
 	}
 
-	return *prate / div;
+	*rate = *prate / div;
+	return 0;
 }
 
 unsigned long flexgen_recalc_rate(struct clk_hw *hw,
diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index af94ed8..7c70049 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -548,21 +548,22 @@ int clk_fs660c32_vco_get_params(unsigned long input,
 	return 0;
 }
 
-static long quadfs_pll_fs660c32_round_rate(struct clk_hw *hw, unsigned long rate
-		, unsigned long *prate)
+static int quadfs_pll_fs660c32_round_rate(struct clk_hw *hw,
+					  unsigned long *rate,
+					  unsigned long *prate)
 {
 	struct stm_fs params;
 
-	if (!clk_fs660c32_vco_get_params(*prate, rate, &params))
-		clk_fs660c32_vco_get_rate(*prate, &params, &rate);
+	if (!clk_fs660c32_vco_get_params(*prate, *rate, &params))
+		clk_fs660c32_vco_get_rate(*prate, &params, rate);
 
 	pr_debug("%s: %s new rate %ld [sdiv=0x%x,md=0x%x,pe=0x%x,nsdiv3=%u]\n",
 		 __func__, __clk_get_name(hw->clk),
-		 rate, (unsigned int)params.sdiv,
+		 *rate, (unsigned int)params.sdiv,
 		 (unsigned int)params.mdiv,
 		 (unsigned int)params.pe, (unsigned int)params.nsdiv);
 
-	return rate;
+	return 0;
 }
 
 static int quadfs_pll_fs660c32_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -953,19 +954,19 @@ static unsigned long quadfs_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long quadfs_round_rate(struct clk_hw *hw, unsigned long rate,
+static int quadfs_round_rate(struct clk_hw *hw, unsigned long *rate,
 				     unsigned long *prate)
 {
 	struct stm_fs params;
 
-	rate = quadfs_find_best_rate(hw, rate, *prate, &params);
+	*rate = quadfs_find_best_rate(hw, *rate, *prate, &params);
 
 	pr_debug("%s: %s new rate %ld [sdiv=0x%x,md=0x%x,pe=0x%x,nsdiv3=%u]\n",
 		 __func__, __clk_get_name(hw->clk),
-		 rate, (unsigned int)params.sdiv, (unsigned int)params.mdiv,
+		 *rate, (unsigned int)params.sdiv, (unsigned int)params.mdiv,
 			 (unsigned int)params.pe, (unsigned int)params.nsdiv);
 
-	return rate;
+	return 0;
 }
 
 
diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index 9a15ec3..2bbcb7b 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -190,7 +190,7 @@ static int clkgena_divmux_set_rate(struct clk_hw *hw, unsigned long rate,
 	return clk_divider_ops.set_rate(div_hw, rate, parent_rate);
 }
 
-static long clkgena_divmux_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clkgena_divmux_round_rate(struct clk_hw *hw, unsigned long *rate,
 				   unsigned long *prate)
 {
 	struct clkgena_divmux *genamux = to_clkgena_divmux(hw);
diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-factors.c
index 8c20190..5865300 100644
--- a/drivers/clk/sunxi/clk-factors.c
+++ b/drivers/clk/sunxi/clk-factors.c
@@ -69,14 +69,17 @@ static unsigned long clk_factors_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long clk_factors_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *parent_rate)
+static int clk_factors_round_rate(struct clk_hw *hw, unsigned long *rate,
+				  unsigned long *parent_rate)
 {
 	struct clk_factors *factors = to_clk_factors(hw);
-	factors->get_factors((u32 *)&rate, (u32)*parent_rate,
+	u32 tmp_rate = *rate;
+
+	factors->get_factors(&tmp_rate, (u32)*parent_rate,
 			     NULL, NULL, NULL, NULL);
 
-	return rate;
+	*rate = tmp_rate;
+	return 0;
 }
 
 static long clk_factors_determine_rate(struct clk_hw *hw, unsigned long rate,
@@ -100,7 +103,8 @@ static long clk_factors_determine_rate(struct clk_hw *hw, unsigned long rate,
 		else
 			parent_rate = __clk_get_rate(parent);
 
-		child_rate = clk_factors_round_rate(hw, rate, &parent_rate);
+		child_rate = rate;
+		clk_factors_round_rate(hw, &child_rate, &parent_rate);
 
 		if (child_rate <= rate && child_rate > best_child_rate) {
 			best_parent = parent;
diff --git a/drivers/clk/tegra/clk-audio-sync.c b/drivers/clk/tegra/clk-audio-sync.c
index c0f7843..0224256 100644
--- a/drivers/clk/tegra/clk-audio-sync.c
+++ b/drivers/clk/tegra/clk-audio-sync.c
@@ -28,15 +28,15 @@ static unsigned long clk_sync_source_recalc_rate(struct clk_hw *hw,
 	return sync->rate;
 }
 
-static long clk_sync_source_round_rate(struct clk_hw *hw, unsigned long rate,
-				       unsigned long *prate)
+static int clk_sync_source_round_rate(struct clk_hw *hw, unsigned long *rate,
+				      unsigned long *prate)
 {
 	struct tegra_clk_sync_source *sync = to_clk_sync_source(hw);
 
-	if (rate > sync->max_rate)
+	if (*rate > sync->max_rate)
 		return -EINVAL;
 	else
-		return rate;
+		return 0;
 }
 
 static int clk_sync_source_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/tegra/clk-divider.c b/drivers/clk/tegra/clk-divider.c
index 59a5714..9e5ca82 100644
--- a/drivers/clk/tegra/clk-divider.c
+++ b/drivers/clk/tegra/clk-divider.c
@@ -85,23 +85,28 @@ static unsigned long clk_frac_div_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long clk_frac_div_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_frac_div_round_rate(struct clk_hw *hw, unsigned long *rate,
 				   unsigned long *prate)
 {
 	struct tegra_clk_frac_div *divider = to_clk_frac_div(hw);
 	int div, mul;
 	unsigned long output_rate = *prate;
 
-	if (!rate)
-		return output_rate;
+	if (!*rate) {
+		*rate = output_rate;
+		return 0;
+	}
 
-	div = get_div(divider, rate, output_rate);
-	if (div < 0)
-		return *prate;
+	div = get_div(divider, *rate, output_rate);
+	if (div < 0) {
+		*rate = *prate;
+		return 0;
+	}
 
 	mul = get_mul(divider);
 
-	return DIV_ROUND_UP(output_rate * mul, div + mul);
+	*rate = DIV_ROUND_UP(output_rate * mul, div + mul);
+	return 0;
 }
 
 static int clk_frac_div_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index d84ae49..5a262f5 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -56,8 +56,8 @@ static unsigned long clk_periph_recalc_rate(struct clk_hw *hw,
 	return div_ops->recalc_rate(div_hw, parent_rate);
 }
 
-static long clk_periph_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static int clk_periph_round_rate(struct clk_hw *hw, unsigned long *rate,
+				 unsigned long *prate)
 {
 	struct tegra_clk_periph *periph = to_clk_periph(hw);
 	const struct clk_ops *div_ops = periph->div_ops;
diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index bfef9ab..a73bdb3 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -623,24 +623,29 @@ static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	return ret;
 }
 
-static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_pll_round_rate(struct clk_hw *hw, unsigned long *rate,
 			unsigned long *prate)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 	struct tegra_clk_pll_freq_table cfg;
 
-	if (pll->params->flags & TEGRA_PLL_FIXED)
-		return pll->params->fixed_rate;
+	if (pll->params->flags & TEGRA_PLL_FIXED) {
+		*rate = pll->params->fixed_rate;
+		return 0;
+	}
 
 	/* PLLM is used for memory; we do not change rate */
-	if (pll->params->flags & TEGRA_PLLM)
-		return __clk_get_rate(hw->clk);
+	if (pll->params->flags & TEGRA_PLLM) {
+		*rate = __clk_get_rate(hw->clk);
+		return 0;
+	}
 
-	if (_get_table_rate(hw, &cfg, rate, *prate) &&
-	    _calc_rate(hw, &cfg, rate, *prate))
+	if (_get_table_rate(hw, &cfg, *rate, *prate) &&
+	    _calc_rate(hw, &cfg, *rate, *prate))
 		return -EINVAL;
 
-	return cfg.output_rate;
+	*rate = cfg.output_rate;
+	return 0;
 }
 
 static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
@@ -1001,25 +1006,28 @@ static int clk_pllxc_set_rate(struct clk_hw *hw, unsigned long rate,
 	return ret;
 }
 
-static long clk_pll_ramp_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_pll_ramp_round_rate(struct clk_hw *hw, unsigned long *rate,
 				unsigned long *prate)
 {
 	struct tegra_clk_pll_freq_table cfg;
 	int ret = 0, p_div;
 	u64 output_rate = *prate;
 
-	ret = _pll_ramp_calc_pll(hw, &cfg, rate, *prate);
+	ret = _pll_ramp_calc_pll(hw, &cfg, *rate, *prate);
 	if (ret < 0)
 		return ret;
 
 	p_div = _hw_to_p_div(hw, cfg.p);
-	if (p_div < 0)
-		return p_div;
+	if (p_div < 0) {
+		*rate = p_div;
+		return 0;
+	}
 
 	output_rate *= cfg.n;
 	do_div(output_rate, cfg.m * p_div);
 
-	return output_rate;
+	*rate = output_rate;
+	return 0;
 }
 
 static int clk_pllm_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -1272,12 +1280,13 @@ static unsigned long clk_pllre_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long clk_pllre_round_rate(struct clk_hw *hw, unsigned long rate,
+static int clk_pllre_round_rate(struct clk_hw *hw, unsigned long *rate,
 				 unsigned long *prate)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 
-	return _pllre_calc_rate(pll, NULL, rate, *prate);
+	*rate = _pllre_calc_rate(pll, NULL, *rate, *prate);
+	return 0;
 }
 
 static int clk_plle_tegra114_enable(struct clk_hw *hw)
diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index 59bb4b3..cdf1d17 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -124,16 +124,17 @@ static unsigned long atl_clk_recalc_rate(struct clk_hw *hw,
 	return parent_rate / cdesc->divider;
 }
 
-static long atl_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *parent_rate)
+static int atl_clk_round_rate(struct clk_hw *hw, unsigned long *rate,
+			      unsigned long *parent_rate)
 {
 	unsigned divider;
 
-	divider = (*parent_rate + rate / 2) / rate;
+	divider = (*parent_rate + *rate / 2) / *rate;
 	if (divider > DRA7_ATL_DIVIDER_MASK + 1)
 		divider = DRA7_ATL_DIVIDER_MASK + 1;
 
-	return *parent_rate / divider;
+	*rate = *parent_rate / divider;
+	return 0;
 }
 
 static int atl_clk_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/ti/composite.c b/drivers/clk/ti/composite.c
index 3654f61..eddad41 100644
--- a/drivers/clk/ti/composite.c
+++ b/drivers/clk/ti/composite.c
@@ -36,8 +36,8 @@ static unsigned long ti_composite_recalc_rate(struct clk_hw *hw,
 	return ti_clk_divider_ops.recalc_rate(hw, parent_rate);
 }
 
-static long ti_composite_round_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long *prate)
+static int ti_composite_round_rate(struct clk_hw *hw, unsigned long *rate,
+				   unsigned long *prate)
 {
 	return -EINVAL;
 }
diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index ff5f117..6044251 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -200,13 +200,14 @@ static int ti_clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	return bestdiv;
 }
 
-static long ti_clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *prate)
+static int ti_clk_divider_round_rate(struct clk_hw *hw, unsigned long *rate,
+				     unsigned long *prate)
 {
 	int div;
-	div = ti_clk_divider_bestdiv(hw, rate, prate);
+	div = ti_clk_divider_bestdiv(hw, *rate, prate);
 
-	return DIV_ROUND_UP(*prate, div);
+	*rate = DIV_ROUND_UP(*prate, div);
+	return 0;
 }
 
 static int ti_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
index bf63c96..1e1aa2d 100644
--- a/drivers/clk/ux500/clk-prcmu.c
+++ b/drivers/clk/ux500/clk-prcmu.c
@@ -80,11 +80,18 @@ static unsigned long clk_prcmu_recalc_rate(struct clk_hw *hw,
 	return prcmu_clock_rate(clk->cg_sel);
 }
 
-static long clk_prcmu_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *parent_rate)
+static int clk_prcmu_round_rate(struct clk_hw *hw, unsigned long *rate,
+				unsigned long *parent_rate)
 {
 	struct clk_prcmu *clk = to_clk_prcmu(hw);
-	return prcmu_round_clock_rate(clk->cg_sel, rate);
+	long ret;
+
+	ret = prcmu_round_clock_rate(clk->cg_sel, *rate);
+	if (ret < 0)
+		return ret;
+
+	*rate = ret;
+	return 0;
 }
 
 static int clk_prcmu_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
index bc96f10..6404e61 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -91,14 +91,15 @@ static unsigned long icst_recalc_rate(struct clk_hw *hw,
 	return icst->rate;
 }
 
-static long icst_round_rate(struct clk_hw *hw, unsigned long rate,
-			    unsigned long *prate)
+static int icst_round_rate(struct clk_hw *hw, unsigned long *rate,
+			   unsigned long *prate)
 {
 	struct clk_icst *icst = to_icst(hw);
 	struct icst_vco vco;
 
-	vco = icst_hz_to_vco(icst->params, rate);
-	return icst_hz(icst->params, vco);
+	vco = icst_hz_to_vco(icst->params, *rate);
+	*rate = icst_hz(icst->params, vco);
+	return 0;
 }
 
 static int icst_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/versatile/clk-vexpress-osc.c b/drivers/clk/versatile/clk-vexpress-osc.c
index 765f1e0..b507758 100644
--- a/drivers/clk/versatile/clk-vexpress-osc.c
+++ b/drivers/clk/versatile/clk-vexpress-osc.c
@@ -39,18 +39,18 @@ static unsigned long vexpress_osc_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long vexpress_osc_round_rate(struct clk_hw *hw, unsigned long rate,
+static int vexpress_osc_round_rate(struct clk_hw *hw, unsigned long *rate,
 		unsigned long *parent_rate)
 {
 	struct vexpress_osc *osc = to_vexpress_osc(hw);
 
-	if (WARN_ON(osc->rate_min && rate < osc->rate_min))
-		rate = osc->rate_min;
+	if (WARN_ON(osc->rate_min && *rate < osc->rate_min))
+		*rate = osc->rate_min;
 
-	if (WARN_ON(osc->rate_max && rate > osc->rate_max))
-		rate = osc->rate_max;
+	if (WARN_ON(osc->rate_max && *rate > osc->rate_max))
+		*rate = osc->rate_max;
 
-	return rate;
+	return 0;
 }
 
 static int vexpress_osc_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/clk/zynq/pll.c b/drivers/clk/zynq/pll.c
index 00d72fb..b62d298 100644
--- a/drivers/clk/zynq/pll.c
+++ b/drivers/clk/zynq/pll.c
@@ -60,18 +60,19 @@ struct zynq_pll {
  * @prate:	Clock frequency of parent clock
  * Returns frequency closest to @rate the hardware can generate.
  */
-static long zynq_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+static int zynq_pll_round_rate(struct clk_hw *hw, unsigned long *rate,
 		unsigned long *prate)
 {
 	u32 fbdiv;
 
-	fbdiv = DIV_ROUND_CLOSEST(rate, *prate);
+	fbdiv = DIV_ROUND_CLOSEST(*rate, *prate);
 	if (fbdiv < PLL_FBDIV_MIN)
 		fbdiv = PLL_FBDIV_MIN;
 	else if (fbdiv > PLL_FBDIV_MAX)
 		fbdiv = PLL_FBDIV_MAX;
 
-	return *prate * fbdiv;
+	*rate = *prate * fbdiv;
+	return 0;
 }
 
 /**
diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index 4216e47..0695428 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -423,17 +423,20 @@ static unsigned long clk_tve_di_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long clk_tve_di_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static int clk_tve_di_round_rate(struct clk_hw *hw, unsigned long *rate,
+				 unsigned long *prate)
 {
 	unsigned long div;
 
-	div = *prate / rate;
+	div = *prate / *rate;
 	if (div >= 4)
-		return *prate / 4;
+		*rate = *prate / 4;
 	else if (div >= 2)
-		return *prate / 2;
-	return *prate;
+		*rate = *prate / 2;
+	else
+		*rate = *prate;
+
+	return 0;
 }
 
 static int clk_tve_di_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c b/drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c
index eeed006..97cdcb4 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c
@@ -336,11 +336,12 @@ static unsigned long hdmi_pll_recalc_rate(struct clk_hw *hw,
 	return phy_8960->pixclk;
 }
 
-static long hdmi_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+static int hdmi_pll_round_rate(struct clk_hw *hw, unsigned long *rate,
 		unsigned long *parent_rate)
 {
-	const struct pll_rate *pll_rate = find_rate(rate);
-	return pll_rate->rate;
+	const struct pll_rate *pll_rate = find_rate(*rate);
+	*rate = pll_rate->rate;
+	return 0;
 }
 
 static int hdmi_pll_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c
index ce42459..c89b109 100644
--- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c
+++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c
@@ -109,11 +109,12 @@ static unsigned long mpd4_lvds_pll_recalc_rate(struct clk_hw *hw,
 	return lvds_pll->pixclk;
 }
 
-static long mpd4_lvds_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+static int mpd4_lvds_pll_round_rate(struct clk_hw *hw, unsigned long *rate,
 		unsigned long *parent_rate)
 {
-	const struct pll_rate *pll_rate = find_rate(rate);
-	return pll_rate->rate;
+	const struct pll_rate *pll_rate = find_rate(*rate);
+	*rate = pll_rate->rate;
+	return 0;
 }
 
 static int mpd4_lvds_pll_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index deca809..4d5ba85 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -231,11 +231,11 @@ static u32 isp_xclk_calc_divider(unsigned long *rate, unsigned long parent_rate)
 	return divider;
 }
 
-static long isp_xclk_round_rate(struct clk_hw *hw, unsigned long rate,
+static int isp_xclk_round_rate(struct clk_hw *hw, unsigned long *rate,
 				unsigned long *parent_rate)
 {
-	isp_xclk_calc_divider(&rate, *parent_rate);
-	return rate;
+	isp_xclk_calc_divider(rate, *parent_rate);
+	return 0;
 }
 
 static int isp_xclk_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index b936bb4..5e6f5a5 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -316,15 +316,19 @@ static unsigned long hym8563_clkout_recalc_rate(struct clk_hw *hw,
 	return clkout_rates[ret];
 }
 
-static long hym8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *prate)
+static int hym8563_clkout_round_rate(struct clk_hw *hw, unsigned long *rate,
+				     unsigned long *prate)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(clkout_rates); i++)
-		if (clkout_rates[i] <= rate)
-			return clkout_rates[i];
+	for (i = 0; i < ARRAY_SIZE(clkout_rates); i++) {
+		if (clkout_rates[i] <= *rate) {
+			*rate = clkout_rates[i];
+			return 0;
+		}
+	}
 
+	*rate = 0;
 	return 0;
 }
 
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 5591ea7..1213b0b 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -173,8 +173,8 @@ struct clk_ops {
 	void		(*disable_unused)(struct clk_hw *hw);
 	unsigned long	(*recalc_rate)(struct clk_hw *hw,
 					unsigned long parent_rate);
-	long		(*round_rate)(struct clk_hw *hw, unsigned long rate,
-					unsigned long *parent_rate);
+	int		(*round_rate)(struct clk_hw *hw, unsigned long *rate,
+				      unsigned long *parent_rate);
 	long		(*determine_rate)(struct clk_hw *hw,
 					  unsigned long rate,
 					  unsigned long min_rate,
@@ -365,7 +365,7 @@ extern const struct clk_ops clk_divider_ops;
 unsigned long divider_recalc_rate(struct clk_hw *hw, unsigned long parent_rate,
 		unsigned int val, const struct clk_div_table *table,
 		unsigned long flags);
-long divider_round_rate(struct clk_hw *hw, unsigned long rate,
+int divider_round_rate(struct clk_hw *hw, unsigned long *rate,
 		unsigned long *prate, const struct clk_div_table *table,
 		u8 width, unsigned long flags);
 int divider_get_val(unsigned long rate, unsigned long parent_rate,
diff --git a/include/linux/clk/ti.h b/include/linux/clk/ti.h
index 6784400..3b2406c 100644
--- a/include/linux/clk/ti.h
+++ b/include/linux/clk/ti.h
@@ -277,9 +277,9 @@ long omap3_noncore_dpll_determine_rate(struct clk_hw *hw,
 				       struct clk_hw **best_parent_clk);
 unsigned long omap4_dpll_regm4xen_recalc(struct clk_hw *hw,
 					 unsigned long parent_rate);
-long omap4_dpll_regm4xen_round_rate(struct clk_hw *hw,
-				    unsigned long target_rate,
-				    unsigned long *parent_rate);
+int omap4_dpll_regm4xen_round_rate(struct clk_hw *hw,
+				   unsigned long *target_rate,
+				   unsigned long *parent_rate);
 long omap4_dpll_regm4xen_determine_rate(struct clk_hw *hw,
 					unsigned long rate,
 					unsigned long min_rate,
@@ -288,14 +288,14 @@ long omap4_dpll_regm4xen_determine_rate(struct clk_hw *hw,
 					struct clk_hw **best_parent_clk);
 u8 omap2_init_dpll_parent(struct clk_hw *hw);
 unsigned long omap3_dpll_recalc(struct clk_hw *hw, unsigned long parent_rate);
-long omap2_dpll_round_rate(struct clk_hw *hw, unsigned long target_rate,
-			   unsigned long *parent_rate);
+int omap2_dpll_round_rate(struct clk_hw *hw, unsigned long *target_rate,
+			  unsigned long *parent_rate);
 void omap2_init_clk_clkdm(struct clk_hw *clk);
 unsigned long omap3_clkoutx2_recalc(struct clk_hw *hw,
 				    unsigned long parent_rate);
 int omap3_clkoutx2_set_rate(struct clk_hw *hw, unsigned long rate,
 					unsigned long parent_rate);
-long omap3_clkoutx2_round_rate(struct clk_hw *hw, unsigned long rate,
+int omap3_clkoutx2_round_rate(struct clk_hw *hw, unsigned long *rate,
 		unsigned long *prate);
 int omap2_clkops_enable_clkdm(struct clk_hw *hw);
 void omap2_clkops_disable_clkdm(struct clk_hw *hw);
-- 
1.9.1

