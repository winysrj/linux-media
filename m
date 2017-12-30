Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:45487 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdL3BNQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 20:13:16 -0500
Received: by mail-wm0-f68.google.com with SMTP id 9so50432238wme.4
        for <linux-media@vger.kernel.org>; Fri, 29 Dec 2017 17:13:15 -0800 (PST)
From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
To: mturquette@baylibre.com, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org
Cc: pure.logic@nexus-software.ie, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-rpi-kernel@lists.infradead.org,
        patches@opensource.cirrus.com,
        uclinux-h8-devel@lists.sourceforge.jp,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org,
        freedreno@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org
Subject: [PATCH 01/33] clk_ops: change round_rate() to return unsigned long
Date: Sat, 30 Dec 2017 01:12:40 +0000
Message-Id: <1514596392-22270-2-git-send-email-pure.logic@nexus-software.ie>
In-Reply-To: <1514596392-22270-1-git-send-email-pure.logic@nexus-software.ie>
References: <1514596392-22270-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now it is not possible to return a value larger than LONG_MAX on 32
bit systems. You can pass a rate of ULONG_MAX but can't return anything
past LONG_MAX due to the fact both the rounded_rate and negative error
codes are represented in the return value of round_rate().

Most implementations either return zero on error or don't return error
codes at all. A minority of implementations do return a negative number -
typically -EINVAL or -ENODEV.

At the higher level then callers of round_rate() typically and rightly
check for a value of <= 0.

It is possible then to convert round_rate() to an unsigned long return
value and change error code indication for the minority from -ERRORCODE to
a simple 0.

This patch is the first step in making it possible to scale round_rate past
LONG_MAX, later patches will change the previously mentioned minority of
round_rate() implementations to return zero only on error if those
implementations currently return a negative error number. Implementations
that do not return an error code of < 0 will be left as-is.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-clk@vger.kernel.org
Cc: linux-rpi-kernel@lists.infradead.org
Cc: patches@opensource.cirrus.com
Cc: uclinux-h8-devel@lists.sourceforge.jp
Cc: linux-amlogic@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-soc@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mediatek@lists.infradead.org
Cc: freedreno@lists.freedesktop.org
Cc: linux-media@vger.kernel.org
Cc: linux-rtc@vger.kernel.org
---
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c    |  4 ++--
 arch/arm/mach-omap2/clock2xxx.h                 |  4 ++--
 arch/arm/mach-vexpress/spc.c                    |  4 ++--
 arch/mips/alchemy/common/clock.c                |  2 +-
 drivers/clk/at91/clk-audio-pll.c                | 10 ++++++----
 drivers/clk/at91/clk-h32mx.c                    |  5 +++--
 drivers/clk/at91/clk-peripheral.c               |  6 +++---
 drivers/clk/at91/clk-pll.c                      |  2 +-
 drivers/clk/at91/clk-plldiv.c                   |  5 +++--
 drivers/clk/at91/clk-smd.c                      |  5 +++--
 drivers/clk/at91/clk-usb.c                      |  5 +++--
 drivers/clk/axs10x/i2s_pll_clock.c              |  4 ++--
 drivers/clk/axs10x/pll_clock.c                  |  5 +++--
 drivers/clk/bcm/clk-bcm2835.c                   | 11 ++++++-----
 drivers/clk/bcm/clk-iproc-asiu.c                |  5 +++--
 drivers/clk/bcm/clk-iproc-pll.c                 |  8 ++++----
 drivers/clk/clk-axi-clkgen.c                    |  5 +++--
 drivers/clk/clk-cdce706.c                       | 15 +++++++++------
 drivers/clk/clk-cdce925.c                       | 15 +++++++++------
 drivers/clk/clk-composite.c                     |  5 +++--
 drivers/clk/clk-cs2000-cp.c                     |  4 ++--
 drivers/clk/clk-divider.c                       |  5 +++--
 drivers/clk/clk-fixed-factor.c                  |  5 +++--
 drivers/clk/clk-fractional-divider.c            |  4 ++--
 drivers/clk/clk-gemini.c                        |  5 +++--
 drivers/clk/clk-highbank.c                      | 10 ++++++----
 drivers/clk/clk-hsdk-pll.c                      |  4 ++--
 drivers/clk/clk-multiplier.c                    |  5 +++--
 drivers/clk/clk-scpi.c                          |  8 ++++----
 drivers/clk/clk-si514.c                         |  4 ++--
 drivers/clk/clk-si5351.c                        | 15 +++++++++------
 drivers/clk/clk-si570.c                         |  4 ++--
 drivers/clk/clk-stm32f4.c                       | 15 +++++++++------
 drivers/clk/clk-u300.c                          |  4 ++--
 drivers/clk/clk-versaclock5.c                   | 12 ++++++------
 drivers/clk/clk-vt8500.c                        |  9 +++++----
 drivers/clk/clk-wm831x.c                        |  5 +++--
 drivers/clk/clk-xgene.c                         |  9 +++++----
 drivers/clk/h8300/clk-h8s2678.c                 |  4 ++--
 drivers/clk/hisilicon/clk-hi6220-stub.c         |  5 +++--
 drivers/clk/hisilicon/clkdivider-hi6220.c       |  5 +++--
 drivers/clk/imx/clk-busy.c                      |  5 +++--
 drivers/clk/imx/clk-cpu.c                       |  4 ++--
 drivers/clk/imx/clk-fixup-div.c                 |  5 +++--
 drivers/clk/imx/clk-pfd.c                       |  4 ++--
 drivers/clk/imx/clk-pllv2.c                     |  4 ++--
 drivers/clk/imx/clk-pllv3.c                     | 19 +++++++++++--------
 drivers/clk/ingenic/cgu.c                       |  4 ++--
 drivers/clk/ingenic/jz4780-cgu.c                |  5 +++--
 drivers/clk/mediatek/clk-pll.c                  |  4 ++--
 drivers/clk/meson/clk-audio-divider.c           |  6 +++---
 drivers/clk/meson/clk-cpu.c                     |  5 +++--
 drivers/clk/meson/clk-pll.c                     |  5 +++--
 drivers/clk/meson/gxbb-aoclk-32k.c              |  5 +++--
 drivers/clk/microchip/clk-core.c                | 12 ++++++------
 drivers/clk/mmp/clk-frac.c                      |  5 +++--
 drivers/clk/mvebu/clk-corediv.c                 |  5 +++--
 drivers/clk/mvebu/clk-cpu.c                     |  5 +++--
 drivers/clk/mvebu/dove-divider.c                |  4 ++--
 drivers/clk/mxs/clk-div.c                       |  4 ++--
 drivers/clk/mxs/clk-frac.c                      |  4 ++--
 drivers/clk/mxs/clk-ref.c                       |  4 ++--
 drivers/clk/nxp/clk-lpc18xx-cgu.c               |  5 +++--
 drivers/clk/nxp/clk-lpc32xx.c                   | 15 +++++++++------
 drivers/clk/pistachio/clk-pll.c                 |  4 ++--
 drivers/clk/qcom/clk-alpha-pll.c                |  7 ++++---
 drivers/clk/qcom/clk-regmap-divider.c           |  4 ++--
 drivers/clk/qcom/clk-rpm.c                      |  4 ++--
 drivers/clk/qcom/clk-smd-rpm.c                  |  5 +++--
 drivers/clk/qcom/gcc-ipq4019.c                  |  5 +++--
 drivers/clk/renesas/clk-div6.c                  |  5 +++--
 drivers/clk/renesas/clk-rcar-gen2.c             |  4 ++--
 drivers/clk/renesas/rcar-gen2-cpg.c             |  4 ++--
 drivers/clk/renesas/rcar-gen3-cpg.c             |  5 +++--
 drivers/clk/rockchip/clk-ddr.c                  |  6 +++---
 drivers/clk/rockchip/clk-pll.c                  |  5 +++--
 drivers/clk/samsung/clk-cpu.c                   |  5 +++--
 drivers/clk/samsung/clk-pll.c                   |  5 +++--
 drivers/clk/sirf/clk-atlas7.c                   |  4 ++--
 drivers/clk/sirf/clk-common.c                   | 12 ++++++------
 drivers/clk/spear/clk-aux-synth.c               |  4 ++--
 drivers/clk/spear/clk-frac-synth.c              |  4 ++--
 drivers/clk/spear/clk-gpt-synth.c               |  4 ++--
 drivers/clk/spear/clk-vco-pll.c                 | 13 +++++++------
 drivers/clk/spear/clk.c                         |  7 ++++---
 drivers/clk/spear/clk.h                         |  7 ++++---
 drivers/clk/st/clk-flexgen.c                    |  4 ++--
 drivers/clk/st/clkgen-fsyn.c                    | 10 +++++-----
 drivers/clk/st/clkgen-pll.c                     | 10 ++++++----
 drivers/clk/sunxi-ng/ccu_nk.c                   |  4 ++--
 drivers/clk/sunxi-ng/ccu_nkmp.c                 |  4 ++--
 drivers/clk/sunxi-ng/ccu_nm.c                   |  4 ++--
 drivers/clk/tegra/clk-audio-sync.c              |  5 +++--
 drivers/clk/tegra/clk-bpmp.c                    |  5 +++--
 drivers/clk/tegra/clk-divider.c                 |  5 +++--
 drivers/clk/tegra/clk-periph.c                  |  5 +++--
 drivers/clk/tegra/clk-pll.c                     | 13 +++++++------
 drivers/clk/tegra/clk-super.c                   |  4 ++--
 drivers/clk/ti/clk-dra7-atl.c                   |  4 ++--
 drivers/clk/ti/composite.c                      |  5 +++--
 drivers/clk/ti/divider.c                        |  5 +++--
 drivers/clk/ti/fapll.c                          |  9 +++++----
 drivers/clk/ux500/clk-prcmu.c                   |  4 ++--
 drivers/clk/versatile/clk-icst.c                |  4 ++--
 drivers/clk/versatile/clk-vexpress-osc.c        |  5 +++--
 drivers/clk/zte/clk.c                           | 13 +++++++------
 drivers/clk/zynq/pll.c                          |  4 ++--
 drivers/gpu/drm/imx/imx-tve.c                   |  5 +++--
 drivers/gpu/drm/mediatek/mtk_mipi_tx.c          |  5 +++--
 drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c  |  5 +++--
 drivers/gpu/drm/msm/dsi/pll/dsi_pll.c           |  5 +++--
 drivers/gpu/drm/msm/dsi/pll/dsi_pll.h           |  5 +++--
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_14nm.c      |  6 +++---
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_28nm_8960.c |  5 +++--
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8996.c        |  6 +++---
 drivers/gpu/drm/msm/hdmi/hdmi_pll_8960.c        |  4 ++--
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c    |  5 +++--
 drivers/gpu/drm/pl111/pl111_display.c           |  5 +++--
 drivers/gpu/drm/sun4i/sun4i_dotclock.c          |  5 +++--
 drivers/media/platform/omap3isp/isp.c           |  4 ++--
 drivers/rtc/rtc-ac100.c                         |  5 +++--
 drivers/rtc/rtc-ds1307.c                        |  5 +++--
 drivers/rtc/rtc-hym8563.c                       |  5 +++--
 drivers/rtc/rtc-m41t80.c                        |  5 +++--
 drivers/rtc/rtc-pcf8563.c                       |  5 +++--
 include/linux/clk-provider.h                    |  4 ++--
 126 files changed, 417 insertions(+), 330 deletions(-)

diff --git a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
index b64d717..e024600 100644
--- a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
+++ b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
@@ -71,8 +71,8 @@ unsigned long omap2_table_mpu_recalc(struct clk_hw *clk,
  * Some might argue L3-DDR, others ARM, others IVA. This code is simple and
  * just uses the ARM rates.
  */
-long omap2_round_to_table_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *parent_rate)
+unsigned long omap2_round_to_table_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	const struct prcm_config *ptr;
 	long highest_rate;
diff --git a/arch/arm/mach-omap2/clock2xxx.h b/arch/arm/mach-omap2/clock2xxx.h
index a8408f9..a9b73bd 100644
--- a/arch/arm/mach-omap2/clock2xxx.h
+++ b/arch/arm/mach-omap2/clock2xxx.h
@@ -16,8 +16,8 @@ unsigned long omap2_table_mpu_recalc(struct clk_hw *clk,
 				     unsigned long parent_rate);
 int omap2_select_table_rate(struct clk_hw *hw, unsigned long rate,
 			    unsigned long parent_rate);
-long omap2_round_to_table_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *parent_rate);
+unsigned long omap2_round_to_table_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate);
 unsigned long omap2xxx_sys_clk_recalc(struct clk_hw *clk,
 				      unsigned long parent_rate);
 unsigned long omap2_osc_clk_recalc(struct clk_hw *clk,
diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index 21c0642..2d9a5a6 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -505,8 +505,8 @@ static unsigned long spc_recalc_rate(struct clk_hw *hw,
 	return freq * 1000;
 }
 
-static long spc_round_rate(struct clk_hw *hw, unsigned long drate,
-		unsigned long *parent_rate)
+static unsigned long spc_round_rate(struct clk_hw *hw, unsigned long drate,
+				    unsigned long *parent_rate)
 {
 	struct clk_spc *spc = to_clk_spc(hw);
 
diff --git a/arch/mips/alchemy/common/clock.c b/arch/mips/alchemy/common/clock.c
index 6b6f685..8281e7d 100644
--- a/arch/mips/alchemy/common/clock.c
+++ b/arch/mips/alchemy/common/clock.c
@@ -204,7 +204,7 @@ static int alchemy_clk_aux_setr(struct clk_hw *hw,
 	return 0;
 }
 
-static long alchemy_clk_aux_roundr(struct clk_hw *hw,
+static unsigned long alchemy_clk_aux_roundr(struct clk_hw *hw,
 					    unsigned long rate,
 					    unsigned long *parent_rate)
 {
diff --git a/drivers/clk/at91/clk-audio-pll.c b/drivers/clk/at91/clk-audio-pll.c
index da7bafc..56227cb 100644
--- a/drivers/clk/at91/clk-audio-pll.c
+++ b/drivers/clk/at91/clk-audio-pll.c
@@ -273,8 +273,9 @@ static int clk_audio_pll_frac_determine_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long clk_audio_pll_pad_round_rate(struct clk_hw *hw, unsigned long rate,
-					 unsigned long *parent_rate)
+static unsigned long clk_audio_pll_pad_round_rate(struct clk_hw *hw,
+						  unsigned long rate,
+						  unsigned long *parent_rate)
 {
 	struct clk_hw *pclk = clk_hw_get_parent(hw);
 	long best_rate = -EINVAL;
@@ -324,8 +325,9 @@ static long clk_audio_pll_pad_round_rate(struct clk_hw *hw, unsigned long rate,
 	return best_rate;
 }
 
-static long clk_audio_pll_pmc_round_rate(struct clk_hw *hw, unsigned long rate,
-					 unsigned long *parent_rate)
+static unsigned long clk_audio_pll_pmc_round_rate(struct clk_hw *hw,
+						  unsigned long rate,
+						  unsigned long *parent_rate)
 {
 	struct clk_hw *pclk = clk_hw_get_parent(hw);
 	long best_rate = -EINVAL;
diff --git a/drivers/clk/at91/clk-h32mx.c b/drivers/clk/at91/clk-h32mx.c
index e0daa4a..e74b551 100644
--- a/drivers/clk/at91/clk-h32mx.c
+++ b/drivers/clk/at91/clk-h32mx.c
@@ -45,8 +45,9 @@ static unsigned long clk_sama5d4_h32mx_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long clk_sama5d4_h32mx_round_rate(struct clk_hw *hw, unsigned long rate,
-				       unsigned long *parent_rate)
+static unsigned long clk_sama5d4_h32mx_round_rate(struct clk_hw *hw,
+						  unsigned long rate,
+						  unsigned long *parent_rate)
 {
 	unsigned long div;
 
diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
index 7701183..c7b45f9 100644
--- a/drivers/clk/at91/clk-peripheral.c
+++ b/drivers/clk/at91/clk-peripheral.c
@@ -249,9 +249,9 @@ clk_sam9x5_peripheral_recalc_rate(struct clk_hw *hw,
 	return parent_rate >> periph->div;
 }
 
-static long clk_sam9x5_peripheral_round_rate(struct clk_hw *hw,
-					     unsigned long rate,
-					     unsigned long *parent_rate)
+static unsigned long clk_sam9x5_peripheral_round_rate(struct clk_hw *hw,
+						      unsigned long rate,
+						      unsigned long *parent_rate)
 {
 	int shift = 0;
 	unsigned long best_rate;
diff --git a/drivers/clk/at91/clk-pll.c b/drivers/clk/at91/clk-pll.c
index 7d3223f..4e7da3e 100644
--- a/drivers/clk/at91/clk-pll.c
+++ b/drivers/clk/at91/clk-pll.c
@@ -257,7 +257,7 @@ static long clk_pll_get_best_div_mul(struct clk_pll *pll, unsigned long rate,
 	return bestrate;
 }
 
-static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+static unsigned long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 					unsigned long *parent_rate)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
diff --git a/drivers/clk/at91/clk-plldiv.c b/drivers/clk/at91/clk-plldiv.c
index b4afaf2..25ccfc6 100644
--- a/drivers/clk/at91/clk-plldiv.c
+++ b/drivers/clk/at91/clk-plldiv.c
@@ -38,8 +38,9 @@ static unsigned long clk_plldiv_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long clk_plldiv_round_rate(struct clk_hw *hw, unsigned long rate,
-					unsigned long *parent_rate)
+static unsigned long clk_plldiv_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *parent_rate)
 {
 	unsigned long div;
 
diff --git a/drivers/clk/at91/clk-smd.c b/drivers/clk/at91/clk-smd.c
index 965c662..d096a37 100644
--- a/drivers/clk/at91/clk-smd.c
+++ b/drivers/clk/at91/clk-smd.c
@@ -43,8 +43,9 @@ static unsigned long at91sam9x5_clk_smd_recalc_rate(struct clk_hw *hw,
 	return parent_rate / (smddiv + 1);
 }
 
-static long at91sam9x5_clk_smd_round_rate(struct clk_hw *hw, unsigned long rate,
-					  unsigned long *parent_rate)
+static unsigned long at91sam9x5_clk_smd_round_rate(struct clk_hw *hw,
+						   unsigned long rate,
+						   unsigned long *parent_rate)
 {
 	unsigned long div;
 	unsigned long bestrate;
diff --git a/drivers/clk/at91/clk-usb.c b/drivers/clk/at91/clk-usb.c
index 791770a..e737d6e 100644
--- a/drivers/clk/at91/clk-usb.c
+++ b/drivers/clk/at91/clk-usb.c
@@ -273,8 +273,9 @@ static unsigned long at91rm9200_clk_usb_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long at91rm9200_clk_usb_round_rate(struct clk_hw *hw, unsigned long rate,
-					  unsigned long *parent_rate)
+static unsigned long at91rm9200_clk_usb_round_rate(struct clk_hw *hw,
+						   unsigned long rate,
+						   unsigned long *parent_rate)
 {
 	struct at91rm9200_clk_usb *usb = to_at91rm9200_clk_usb(hw);
 	struct clk_hw *parent = clk_hw_get_parent(hw);
diff --git a/drivers/clk/axs10x/i2s_pll_clock.c b/drivers/clk/axs10x/i2s_pll_clock.c
index 02d3bcd..061260c 100644
--- a/drivers/clk/axs10x/i2s_pll_clock.c
+++ b/drivers/clk/axs10x/i2s_pll_clock.c
@@ -110,8 +110,8 @@ static unsigned long i2s_pll_recalc_rate(struct clk_hw *hw,
 	return ((parent_rate / idiv) * fbdiv) / odiv;
 }
 
-static long i2s_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-			unsigned long *prate)
+static unsigned long i2s_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *prate)
 {
 	struct i2s_pll_clk *clk = to_i2s_pll_clk(hw);
 	const struct i2s_pll_cfg *pll_cfg = i2s_pll_get_cfg(*prate);
diff --git a/drivers/clk/axs10x/pll_clock.c b/drivers/clk/axs10x/pll_clock.c
index 25d8c24..27498eb 100644
--- a/drivers/clk/axs10x/pll_clock.c
+++ b/drivers/clk/axs10x/pll_clock.c
@@ -152,8 +152,9 @@ static unsigned long axs10x_pll_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long axs10x_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static unsigned long axs10x_pll_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *prate)
 {
 	int i;
 	long best_rate;
diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index 44301a3..c215dc9 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -554,8 +554,9 @@ static long bcm2835_pll_rate_from_divisors(unsigned long parent_rate,
 	return rate >> A2W_PLL_FRAC_BITS;
 }
 
-static long bcm2835_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *parent_rate)
+static unsigned long bcm2835_pll_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *parent_rate)
 {
 	struct bcm2835_pll *pll = container_of(hw, struct bcm2835_pll, hw);
 	const struct bcm2835_pll_data *data = pll->data;
@@ -785,9 +786,9 @@ static int bcm2835_pll_divider_is_on(struct clk_hw *hw)
 	return !(cprman_read(cprman, data->a2w_reg) & A2W_PLL_CHANNEL_DISABLE);
 }
 
-static long bcm2835_pll_divider_round_rate(struct clk_hw *hw,
-					   unsigned long rate,
-					   unsigned long *parent_rate)
+static unsigned long bcm2835_pll_divider_round_rate(struct clk_hw *hw,
+						    unsigned long rate,
+						    unsigned long *parent_rate)
 {
 	return clk_divider_ops.round_rate(hw, rate, parent_rate);
 }
diff --git a/drivers/clk/bcm/clk-iproc-asiu.c b/drivers/clk/bcm/clk-iproc-asiu.c
index 4360e48..ae40d08 100644
--- a/drivers/clk/bcm/clk-iproc-asiu.c
+++ b/drivers/clk/bcm/clk-iproc-asiu.c
@@ -108,8 +108,9 @@ static unsigned long iproc_asiu_clk_recalc_rate(struct clk_hw *hw,
 	return clk->rate;
 }
 
-static long iproc_asiu_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *parent_rate)
+static unsigned long iproc_asiu_clk_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *parent_rate)
 {
 	unsigned int div;
 
diff --git a/drivers/clk/bcm/clk-iproc-pll.c b/drivers/clk/bcm/clk-iproc-pll.c
index 375d8dd..b5399b2 100644
--- a/drivers/clk/bcm/clk-iproc-pll.c
+++ b/drivers/clk/bcm/clk-iproc-pll.c
@@ -431,8 +431,8 @@ static unsigned long iproc_pll_recalc_rate(struct clk_hw *hw,
 	return clk->rate;
 }
 
-static long iproc_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *parent_rate)
+static unsigned long iproc_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
 {
 	unsigned i;
 	struct iproc_clk *clk = to_iproc_clk(hw);
@@ -535,8 +535,8 @@ static unsigned long iproc_clk_recalc_rate(struct clk_hw *hw,
 	return clk->rate;
 }
 
-static long iproc_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *parent_rate)
+static unsigned long iproc_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
 {
 	unsigned int div;
 
diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index 5e918e7..1da2ba4 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -294,8 +294,9 @@ static int axi_clkgen_set_rate(struct clk_hw *clk_hw,
 	return 0;
 }
 
-static long axi_clkgen_round_rate(struct clk_hw *hw, unsigned long rate,
-	unsigned long *parent_rate)
+static unsigned long axi_clkgen_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *parent_rate)
 {
 	unsigned int d, m, dout;
 
diff --git a/drivers/clk/clk-cdce706.c b/drivers/clk/clk-cdce706.c
index f21d909..998ad47 100644
--- a/drivers/clk/clk-cdce706.c
+++ b/drivers/clk/clk-cdce706.c
@@ -185,8 +185,9 @@ static unsigned long cdce706_pll_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long cdce706_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *parent_rate)
+static unsigned long cdce706_pll_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *parent_rate)
 {
 	struct cdce706_hw_data *hwd = to_hw_data(hw);
 	unsigned long mul, div;
@@ -290,8 +291,9 @@ static unsigned long cdce706_divider_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long cdce706_divider_round_rate(struct clk_hw *hw, unsigned long rate,
-				       unsigned long *parent_rate)
+static unsigned long cdce706_divider_round_rate(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long *parent_rate)
 {
 	struct cdce706_hw_data *hwd = to_hw_data(hw);
 	struct cdce706_dev_data *cdce = hwd->dev_data;
@@ -423,8 +425,9 @@ static unsigned long cdce706_clkout_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long cdce706_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *parent_rate)
+static unsigned long cdce706_clkout_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *parent_rate)
 {
 	*parent_rate = rate;
 	return rate;
diff --git a/drivers/clk/clk-cdce925.c b/drivers/clk/clk-cdce925.c
index 0a7e7d5..341e744 100644
--- a/drivers/clk/clk-cdce925.c
+++ b/drivers/clk/clk-cdce925.c
@@ -142,8 +142,9 @@ static void cdce925_pll_find_rate(unsigned long rate,
 	}
 }
 
-static long cdce925_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *parent_rate)
+static unsigned long cdce925_pll_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *parent_rate)
 {
 	u16 n, m;
 
@@ -434,8 +435,9 @@ static unsigned long cdce925_clk_best_parent_rate(
 	return rate * pdiv_best;
 }
 
-static long cdce925_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *parent_rate)
+static unsigned long cdce925_clk_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *parent_rate)
 {
 	unsigned long l_parent_rate = *parent_rate;
 	u16 divider = cdce925_calc_divider(rate, l_parent_rate);
@@ -487,8 +489,9 @@ static u16 cdce925_y1_calc_divider(unsigned long rate,
 	return (u16)divider;
 }
 
-static long cdce925_clk_y1_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *parent_rate)
+static unsigned long cdce925_clk_y1_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *parent_rate)
 {
 	unsigned long l_parent_rate = *parent_rate;
 	u16 divider = cdce925_y1_calc_divider(rate, l_parent_rate);
diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
index 00269de..f3707c3 100644
--- a/drivers/clk/clk-composite.c
+++ b/drivers/clk/clk-composite.c
@@ -127,8 +127,9 @@ static int clk_composite_determine_rate(struct clk_hw *hw,
 	}
 }
 
-static long clk_composite_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static unsigned long clk_composite_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *prate)
 {
 	struct clk_composite *composite = to_clk_composite(hw);
 	const struct clk_ops *rate_ops = composite->rate_ops;
diff --git a/drivers/clk/clk-cs2000-cp.c b/drivers/clk/clk-cs2000-cp.c
index e8ea81c..d64178b 100644
--- a/drivers/clk/clk-cs2000-cp.c
+++ b/drivers/clk/clk-cs2000-cp.c
@@ -300,8 +300,8 @@ static unsigned long cs2000_recalc_rate(struct clk_hw *hw,
 	return cs2000_ratio_to_rate(ratio, parent_rate);
 }
 
-static long cs2000_round_rate(struct clk_hw *hw, unsigned long rate,
-			      unsigned long *parent_rate)
+static unsigned long cs2000_round_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long *parent_rate)
 {
 	u32 ratio;
 
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 4ed516c..a26ec7c 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -345,8 +345,9 @@ long divider_round_rate_parent(struct clk_hw *hw, struct clk_hw *parent,
 }
 EXPORT_SYMBOL_GPL(divider_round_rate_parent);
 
-static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long clk_divider_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *prate)
 {
 	struct clk_divider *divider = to_clk_divider(hw);
 	int bestdiv;
diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
index a5d402d..40d32af 100644
--- a/drivers/clk/clk-fixed-factor.c
+++ b/drivers/clk/clk-fixed-factor.c
@@ -35,8 +35,9 @@ static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
 	return (unsigned long)rate;
 }
 
-static long clk_factor_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long clk_factor_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *prate)
 {
 	struct clk_fixed_factor *fix = to_clk_fixed_factor(hw);
 
diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
index fdf625f..b7eb6a9 100644
--- a/drivers/clk/clk-fractional-divider.c
+++ b/drivers/clk/clk-fractional-divider.c
@@ -70,8 +70,8 @@ static void clk_fd_general_approximation(struct clk_hw *hw, unsigned long rate,
 			m, n);
 }
 
-static long clk_fd_round_rate(struct clk_hw *hw, unsigned long rate,
-			      unsigned long *parent_rate)
+static unsigned long clk_fd_round_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long *parent_rate)
 {
 	struct clk_fractional_divider *fd = to_clk_fd(hw);
 	unsigned long m, n;
diff --git a/drivers/clk/clk-gemini.c b/drivers/clk/clk-gemini.c
index 5e66e6c..f385fc2 100644
--- a/drivers/clk/clk-gemini.c
+++ b/drivers/clk/clk-gemini.c
@@ -128,8 +128,9 @@ static unsigned long gemini_pci_recalc_rate(struct clk_hw *hw,
 	return 33000000;
 }
 
-static long gemini_pci_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static unsigned long gemini_pci_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *prate)
 {
 	/* We support 33 and 66 MHz */
 	if (rate < 48000000)
diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 727ed8e..add1423 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -143,8 +143,9 @@ static void clk_pll_calc(unsigned long rate, unsigned long ref_freq,
 	*pdivf = divf;
 }
 
-static long clk_pll_round_rate(struct clk_hw *hwclk, unsigned long rate,
-			       unsigned long *parent_rate)
+static unsigned long clk_pll_round_rate(struct clk_hw *hwclk,
+					unsigned long rate,
+					unsigned long *parent_rate)
 {
 	u32 divq, divf;
 	unsigned long ref_freq = *parent_rate;
@@ -240,8 +241,9 @@ static unsigned long clk_periclk_recalc_rate(struct clk_hw *hwclk,
 	return parent_rate / div;
 }
 
-static long clk_periclk_round_rate(struct clk_hw *hwclk, unsigned long rate,
-				   unsigned long *parent_rate)
+static unsigned long clk_periclk_round_rate(struct clk_hw *hwclk,
+					    unsigned long rate,
+					    unsigned long *parent_rate)
 {
 	u32 div;
 
diff --git a/drivers/clk/clk-hsdk-pll.c b/drivers/clk/clk-hsdk-pll.c
index c4ee280..62c8e18 100644
--- a/drivers/clk/clk-hsdk-pll.c
+++ b/drivers/clk/clk-hsdk-pll.c
@@ -192,8 +192,8 @@ static unsigned long hsdk_pll_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long hsdk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long hsdk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *prate)
 {
 	int i;
 	unsigned long best_rate;
diff --git a/drivers/clk/clk-multiplier.c b/drivers/clk/clk-multiplier.c
index dc037c9..b022707 100644
--- a/drivers/clk/clk-multiplier.c
+++ b/drivers/clk/clk-multiplier.c
@@ -98,8 +98,9 @@ static unsigned long __bestmult(struct clk_hw *hw, unsigned long rate,
 	return bestmult;
 }
 
-static long clk_multiplier_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *parent_rate)
+static unsigned long clk_multiplier_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *parent_rate)
 {
 	struct clk_multiplier *mult = to_clk_multiplier(hw);
 	unsigned long factor = __bestmult(hw, rate, parent_rate,
diff --git a/drivers/clk/clk-scpi.c b/drivers/clk/clk-scpi.c
index 2585472..303dc5e 100644
--- a/drivers/clk/clk-scpi.c
+++ b/drivers/clk/clk-scpi.c
@@ -44,8 +44,8 @@ static unsigned long scpi_clk_recalc_rate(struct clk_hw *hw,
 	return clk->scpi_ops->clk_get_val(clk->id);
 }
 
-static long scpi_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *parent_rate)
+static unsigned long scpi_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *parent_rate)
 {
 	/*
 	 * We can't figure out what rate it will be, so just return the
@@ -104,8 +104,8 @@ static unsigned long scpi_dvfs_recalc_rate(struct clk_hw *hw,
 	return opp->freq;
 }
 
-static long scpi_dvfs_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *parent_rate)
+static unsigned long scpi_dvfs_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
 {
 	struct scpi_clk *clk = to_scpi_clk(hw);
 
diff --git a/drivers/clk/clk-si514.c b/drivers/clk/clk-si514.c
index 09b6718..8d940d0 100644
--- a/drivers/clk/clk-si514.c
+++ b/drivers/clk/clk-si514.c
@@ -209,8 +209,8 @@ static unsigned long si514_recalc_rate(struct clk_hw *hw,
 	return si514_calc_rate(&settings);
 }
 
-static long si514_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *parent_rate)
+static unsigned long si514_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *parent_rate)
 {
 	struct clk_si514_muldiv settings;
 	int err;
diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 20d9076..4a35acd 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -446,8 +446,9 @@ static unsigned long si5351_pll_recalc_rate(struct clk_hw *hw,
 	return (unsigned long)rate;
 }
 
-static long si5351_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *parent_rate)
+static unsigned long si5351_pll_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *parent_rate)
 {
 	struct si5351_hw_data *hwdata =
 		container_of(hw, struct si5351_hw_data, hw);
@@ -644,8 +645,9 @@ static unsigned long si5351_msynth_recalc_rate(struct clk_hw *hw,
 	return (unsigned long)rate;
 }
 
-static long si5351_msynth_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *parent_rate)
+static unsigned long si5351_msynth_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *parent_rate)
 {
 	struct si5351_hw_data *hwdata =
 		container_of(hw, struct si5351_hw_data, hw);
@@ -1000,8 +1002,9 @@ static unsigned long si5351_clkout_recalc_rate(struct clk_hw *hw,
 	return parent_rate >> rdiv;
 }
 
-static long si5351_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *parent_rate)
+static unsigned long si5351_clkout_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *parent_rate)
 {
 	struct si5351_hw_data *hwdata =
 		container_of(hw, struct si5351_hw_data, hw);
diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
index 646af1d..597e5d1 100644
--- a/drivers/clk/clk-si570.c
+++ b/drivers/clk/clk-si570.c
@@ -246,8 +246,8 @@ static unsigned long si570_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long si570_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *parent_rate)
+static unsigned long si570_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *parent_rate)
 {
 	int err;
 	u64 rfreq;
diff --git a/drivers/clk/clk-stm32f4.c b/drivers/clk/clk-stm32f4.c
index 96c6b6b..19a7afa 100644
--- a/drivers/clk/clk-stm32f4.c
+++ b/drivers/clk/clk-stm32f4.c
@@ -354,8 +354,9 @@ static unsigned long clk_apb_mul_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long clk_apb_mul_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *prate)
+static unsigned long clk_apb_mul_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *prate)
 {
 	struct clk_apb_mul *am = to_clk_apb_mul(hw);
 	unsigned long mult = 1;
@@ -570,8 +571,9 @@ static unsigned long stm32f4_pll_recalc(struct clk_hw *hw,
 	return parent_rate * n;
 }
 
-static long stm32f4_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *prate)
+static unsigned long stm32f4_pll_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *prate)
 {
 	struct clk_gate *gate = to_clk_gate(hw);
 	struct stm32f4_pll *pll = to_stm32f4_pll(gate);
@@ -636,8 +638,9 @@ static unsigned long stm32f4_pll_div_recalc_rate(struct clk_hw *hw,
 	return clk_divider_ops.recalc_rate(hw, parent_rate);
 }
 
-static long stm32f4_pll_div_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long stm32f4_pll_div_round_rate(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long *prate)
 {
 	return clk_divider_ops.round_rate(hw, rate, prate);
 }
diff --git a/drivers/clk/clk-u300.c b/drivers/clk/clk-u300.c
index 7b3e192..d988363 100644
--- a/drivers/clk/clk-u300.c
+++ b/drivers/clk/clk-u300.c
@@ -629,7 +629,7 @@ syscon_clk_recalc_rate(struct clk_hw *hw,
 	}
 }
 
-static long
+static unsigned long
 syscon_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 		      unsigned long *prate)
 {
@@ -1039,7 +1039,7 @@ mclk_clk_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long
+static unsigned long
 mclk_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 		    unsigned long *prate)
 {
diff --git a/drivers/clk/clk-versaclock5.c b/drivers/clk/clk-versaclock5.c
index decffb3..2b8ea89 100644
--- a/drivers/clk/clk-versaclock5.c
+++ b/drivers/clk/clk-versaclock5.c
@@ -344,8 +344,8 @@ static unsigned long vc5_pfd_recalc_rate(struct clk_hw *hw,
 		return parent_rate / VC5_REF_DIVIDER_REF_DIV(div);
 }
 
-static long vc5_pfd_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *parent_rate)
+static unsigned long vc5_pfd_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	unsigned long idiv;
 
@@ -422,8 +422,8 @@ static unsigned long vc5_pll_recalc_rate(struct clk_hw *hw,
 	return (parent_rate * div_int) + ((parent_rate * div_frc) >> 24);
 }
 
-static long vc5_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *parent_rate)
+static unsigned long vc5_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	struct vc5_hw_data *hwdata = container_of(hw, struct vc5_hw_data, hw);
 	u32 div_int;
@@ -500,8 +500,8 @@ static unsigned long vc5_fod_recalc_rate(struct clk_hw *hw,
 	return div64_u64((u64)f_in << 24ULL, ((u64)div_int << 24ULL) + div_frc);
 }
 
-static long vc5_fod_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *parent_rate)
+static unsigned long vc5_fod_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	struct vc5_hw_data *hwdata = container_of(hw, struct vc5_hw_data, hw);
 	/* VCO frequency is divided by two before entering FOD */
diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index 4161a6f..43c88f6 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -137,8 +137,9 @@ static unsigned long vt8500_dclk_recalc_rate(struct clk_hw *hw,
 	return parent_rate / div;
 }
 
-static long vt8500_dclk_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long vt8500_dclk_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *prate)
 {
 	struct clk_device *cdev = to_clk_device(hw);
 	u32 divisor;
@@ -603,8 +604,8 @@ static int vtwm_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
-static long vtwm_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long vtwm_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *prate)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
 	u32 filter, mul, div1, div2;
diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index 1467695..be6f98b 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -138,8 +138,9 @@ static unsigned long wm831x_fll_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long wm831x_fll_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *unused)
+static unsigned long wm831x_fll_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *unused)
 {
 	int best = 0;
 	int i;
diff --git a/drivers/clk/clk-xgene.c b/drivers/clk/clk-xgene.c
index 531b030..7a93415 100644
--- a/drivers/clk/clk-xgene.c
+++ b/drivers/clk/clk-xgene.c
@@ -286,8 +286,9 @@ static unsigned long xgene_clk_pmd_recalc_rate(struct clk_hw *hw,
 	return ret;
 }
 
-static long xgene_clk_pmd_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *parent_rate)
+static unsigned long xgene_clk_pmd_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *parent_rate)
 {
 	struct xgene_clk_pmd *fd = to_xgene_clk_pmd(hw);
 	u64 ret, scale;
@@ -609,8 +610,8 @@ static int xgene_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	return parent_rate / divider_save;
 }
 
-static long xgene_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long xgene_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *prate)
 {
 	struct xgene_clk *pclk = to_xgene_clk(hw);
 	unsigned long parent_rate = *prate;
diff --git a/drivers/clk/h8300/clk-h8s2678.c b/drivers/clk/h8300/clk-h8s2678.c
index fc24b0b..e531612 100644
--- a/drivers/clk/h8300/clk-h8s2678.c
+++ b/drivers/clk/h8300/clk-h8s2678.c
@@ -33,8 +33,8 @@ static unsigned long pll_recalc_rate(struct clk_hw *hw,
 	return parent_rate * mul;
 }
 
-static long pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long pll_round_rate(struct clk_hw *hw, unsigned long rate,
+				    unsigned long *prate)
 {
 	int i, m = -1;
 	long offset[3];
diff --git a/drivers/clk/hisilicon/clk-hi6220-stub.c b/drivers/clk/hisilicon/clk-hi6220-stub.c
index 329a092..1a2d64d 100644
--- a/drivers/clk/hisilicon/clk-hi6220-stub.c
+++ b/drivers/clk/hisilicon/clk-hi6220-stub.c
@@ -165,8 +165,9 @@ static int hi6220_stub_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	return ret;
 }
 
-static long hi6220_stub_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *parent_rate)
+static unsigned long hi6220_stub_clk_round_rate(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long *parent_rate)
 {
 	struct hi6220_stub_clk *stub_clk = to_stub_clk(hw);
 	unsigned long new_rate = rate / 1000;  /* kHz */
diff --git a/drivers/clk/hisilicon/clkdivider-hi6220.c b/drivers/clk/hisilicon/clkdivider-hi6220.c
index a1c1f68..5d771e9 100644
--- a/drivers/clk/hisilicon/clkdivider-hi6220.c
+++ b/drivers/clk/hisilicon/clkdivider-hi6220.c
@@ -59,8 +59,9 @@ static unsigned long hi6220_clkdiv_recalc_rate(struct clk_hw *hw,
 				   CLK_DIVIDER_ROUND_CLOSEST);
 }
 
-static long hi6220_clkdiv_round_rate(struct clk_hw *hw, unsigned long rate,
-					unsigned long *prate)
+static unsigned long hi6220_clkdiv_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *prate)
 {
 	struct hi6220_clk_divider *dclk = to_hi6220_clk_divider(hw);
 
diff --git a/drivers/clk/imx/clk-busy.c b/drivers/clk/imx/clk-busy.c
index 6df3389..2ee1cd3 100644
--- a/drivers/clk/imx/clk-busy.c
+++ b/drivers/clk/imx/clk-busy.c
@@ -51,8 +51,9 @@ static unsigned long clk_busy_divider_recalc_rate(struct clk_hw *hw,
 	return busy->div_ops->recalc_rate(&busy->div.hw, parent_rate);
 }
 
-static long clk_busy_divider_round_rate(struct clk_hw *hw, unsigned long rate,
-					unsigned long *prate)
+static unsigned long clk_busy_divider_round_rate(struct clk_hw *hw,
+						 unsigned long rate,
+						 unsigned long *prate)
 {
 	struct clk_busy_divider *busy = to_clk_busy_divider(hw);
 
diff --git a/drivers/clk/imx/clk-cpu.c b/drivers/clk/imx/clk-cpu.c
index 9d46eac..02db30a 100644
--- a/drivers/clk/imx/clk-cpu.c
+++ b/drivers/clk/imx/clk-cpu.c
@@ -35,8 +35,8 @@ static unsigned long clk_cpu_recalc_rate(struct clk_hw *hw,
 	return clk_get_rate(cpu->div);
 }
 
-static long clk_cpu_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *prate)
+static unsigned long clk_cpu_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *prate)
 {
 	struct clk_cpu *cpu = to_clk_cpu(hw);
 
diff --git a/drivers/clk/imx/clk-fixup-div.c b/drivers/clk/imx/clk-fixup-div.c
index ce572273..d6c98de 100644
--- a/drivers/clk/imx/clk-fixup-div.c
+++ b/drivers/clk/imx/clk-fixup-div.c
@@ -47,8 +47,9 @@ static unsigned long clk_fixup_div_recalc_rate(struct clk_hw *hw,
 	return fixup_div->ops->recalc_rate(&fixup_div->divider.hw, parent_rate);
 }
 
-static long clk_fixup_div_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *prate)
+static unsigned long clk_fixup_div_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *prate)
 {
 	struct clk_fixup_div *fixup_div = to_clk_fixup_div(hw);
 
diff --git a/drivers/clk/imx/clk-pfd.c b/drivers/clk/imx/clk-pfd.c
index 04a3e78..4898469 100644
--- a/drivers/clk/imx/clk-pfd.c
+++ b/drivers/clk/imx/clk-pfd.c
@@ -67,8 +67,8 @@ static unsigned long clk_pfd_recalc_rate(struct clk_hw *hw,
 	return tmp;
 }
 
-static long clk_pfd_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *prate)
+static unsigned long clk_pfd_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *prate)
 {
 	u64 tmp = *prate;
 	u8 frac;
diff --git a/drivers/clk/imx/clk-pllv2.c b/drivers/clk/imx/clk-pllv2.c
index 85b5cbe..fe9c1fa 100644
--- a/drivers/clk/imx/clk-pllv2.c
+++ b/drivers/clk/imx/clk-pllv2.c
@@ -178,8 +178,8 @@ static int clk_pllv2_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
-static long clk_pllv2_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *prate)
+static unsigned long clk_pllv2_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *prate)
 {
 	u32 dp_op, dp_mfd, dp_mfn;
 
diff --git a/drivers/clk/imx/clk-pllv3.c b/drivers/clk/imx/clk-pllv3.c
index 9af62ee..b2d8dc5 100644
--- a/drivers/clk/imx/clk-pllv3.c
+++ b/drivers/clk/imx/clk-pllv3.c
@@ -121,8 +121,8 @@ static unsigned long clk_pllv3_recalc_rate(struct clk_hw *hw,
 	return (div == 1) ? parent_rate * 22 : parent_rate * 20;
 }
 
-static long clk_pllv3_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *prate)
+static unsigned long clk_pllv3_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *prate)
 {
 	unsigned long parent_rate = *prate;
 
@@ -169,8 +169,9 @@ static unsigned long clk_pllv3_sys_recalc_rate(struct clk_hw *hw,
 	return parent_rate * div / 2;
 }
 
-static long clk_pllv3_sys_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *prate)
+static unsigned long clk_pllv3_sys_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *prate)
 {
 	unsigned long parent_rate = *prate;
 	unsigned long min_rate = parent_rate * 54 / 2;
@@ -230,8 +231,9 @@ static unsigned long clk_pllv3_av_recalc_rate(struct clk_hw *hw,
 	return parent_rate * div + (unsigned long)temp64;
 }
 
-static long clk_pllv3_av_round_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long *prate)
+static unsigned long clk_pllv3_av_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *prate)
 {
 	unsigned long parent_rate = *prate;
 	unsigned long min_rate = parent_rate * 27;
@@ -359,8 +361,9 @@ static unsigned long clk_pllv3_vf610_recalc_rate(struct clk_hw *hw,
 	return clk_pllv3_vf610_mf_to_rate(parent_rate, mf);
 }
 
-static long clk_pllv3_vf610_round_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long *prate)
+static unsigned long clk_pllv3_vf610_round_rate(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long *prate)
 {
 	struct clk_pllv3_vf610_mf mf = clk_pllv3_vf610_rate_to_mf(*prate, rate);
 
diff --git a/drivers/clk/ingenic/cgu.c b/drivers/clk/ingenic/cgu.c
index ab39363..3dee806 100644
--- a/drivers/clk/ingenic/cgu.c
+++ b/drivers/clk/ingenic/cgu.c
@@ -152,7 +152,7 @@ ingenic_pll_calc(const struct ingenic_cgu_clk_info *clk_info,
 	return div_u64((u64)parent_rate * m, n * od);
 }
 
-static long
+static unsigned long
 ingenic_pll_round_rate(struct clk_hw *hw, unsigned long req_rate,
 		       unsigned long *prate)
 {
@@ -357,7 +357,7 @@ ingenic_clk_calc_div(const struct ingenic_cgu_clk_info *clk_info,
 	return div;
 }
 
-static long
+static unsigned long
 ingenic_clk_round_rate(struct clk_hw *hw, unsigned long req_rate,
 		       unsigned long *parent_rate)
 {
diff --git a/drivers/clk/ingenic/jz4780-cgu.c b/drivers/clk/ingenic/jz4780-cgu.c
index ac3585e..1f23173 100644
--- a/drivers/clk/ingenic/jz4780-cgu.c
+++ b/drivers/clk/ingenic/jz4780-cgu.c
@@ -150,8 +150,9 @@ static unsigned long jz4780_otg_phy_recalc_rate(struct clk_hw *hw,
 	return parent_rate;
 }
 
-static long jz4780_otg_phy_round_rate(struct clk_hw *hw, unsigned long req_rate,
-				      unsigned long *parent_rate)
+static unsigned long jz4780_otg_phy_round_rate(struct clk_hw *hw,
+					       unsigned long req_rate,
+					       unsigned long *parent_rate)
 {
 	if (req_rate < 15600000)
 		return 12000000;
diff --git a/drivers/clk/mediatek/clk-pll.c b/drivers/clk/mediatek/clk-pll.c
index f54e401..a068e55 100644
--- a/drivers/clk/mediatek/clk-pll.c
+++ b/drivers/clk/mediatek/clk-pll.c
@@ -199,8 +199,8 @@ static unsigned long mtk_pll_recalc_rate(struct clk_hw *hw,
 	return __mtk_pll_recalc_rate(pll, parent_rate, pcw, postdiv);
 }
 
-static long mtk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *prate)
+static unsigned long mtk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *prate)
 {
 	struct mtk_clk_pll *pll = to_mtk_clk_pll(hw);
 	u32 pcw = 0;
diff --git a/drivers/clk/meson/clk-audio-divider.c b/drivers/clk/meson/clk-audio-divider.c
index 6c07db0..396a938 100644
--- a/drivers/clk/meson/clk-audio-divider.c
+++ b/drivers/clk/meson/clk-audio-divider.c
@@ -73,9 +73,9 @@ static unsigned long audio_divider_recalc_rate(struct clk_hw *hw,
 	return DIV_ROUND_UP_ULL((u64)parent_rate, divider);
 }
 
-static long audio_divider_round_rate(struct clk_hw *hw,
-				     unsigned long rate,
-				     unsigned long *parent_rate)
+static unsigned long audio_divider_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *parent_rate)
 {
 	struct meson_clk_audio_divider *adiv =
 		to_meson_clk_audio_divider(hw);
diff --git a/drivers/clk/meson/clk-cpu.c b/drivers/clk/meson/clk-cpu.c
index f8b2b7e..83c36c6 100644
--- a/drivers/clk/meson/clk-cpu.c
+++ b/drivers/clk/meson/clk-cpu.c
@@ -54,8 +54,9 @@
 #define to_meson_clk_cpu_hw(_hw) container_of(_hw, struct meson_clk_cpu, hw)
 #define to_meson_clk_cpu_nb(_nb) container_of(_nb, struct meson_clk_cpu, clk_nb)
 
-static long meson_clk_cpu_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *prate)
+static unsigned long meson_clk_cpu_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *prate)
 {
 	struct meson_clk_cpu *clk_cpu = to_meson_clk_cpu_hw(hw);
 
diff --git a/drivers/clk/meson/clk-pll.c b/drivers/clk/meson/clk-pll.c
index 0134155..3d5b663 100644
--- a/drivers/clk/meson/clk-pll.c
+++ b/drivers/clk/meson/clk-pll.c
@@ -87,8 +87,9 @@ static unsigned long meson_clk_pll_recalc_rate(struct clk_hw *hw,
 	return rate_mhz * 1000000;
 }
 
-static long meson_clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *parent_rate)
+static unsigned long meson_clk_pll_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *parent_rate)
 {
 	struct meson_clk_pll *pll = to_meson_clk_pll(hw);
 	const struct pll_rate_table *rate_table = pll->rate_table;
diff --git a/drivers/clk/meson/gxbb-aoclk-32k.c b/drivers/clk/meson/gxbb-aoclk-32k.c
index 491634d..0fd5b6c 100644
--- a/drivers/clk/meson/gxbb-aoclk-32k.c
+++ b/drivers/clk/meson/gxbb-aoclk-32k.c
@@ -120,8 +120,9 @@ static const struct cec_32k_freq_table *find_cec_32k_freq(unsigned long rate,
 	return NULL;
 }
 
-static long aoclk_cec_32k_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *prate)
+static unsigned long aoclk_cec_32k_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *prate)
 {
 	const struct cec_32k_freq_table *freq = find_cec_32k_freq(rate,
 								  *prate);
diff --git a/drivers/clk/microchip/clk-core.c b/drivers/clk/microchip/clk-core.c
index c3b3014..70665c8 100644
--- a/drivers/clk/microchip/clk-core.c
+++ b/drivers/clk/microchip/clk-core.c
@@ -162,8 +162,8 @@ static unsigned long pbclk_recalc_rate(struct clk_hw *hw,
 	return parent_rate / pbclk_read_pbdiv(pb);
 }
 
-static long pbclk_round_rate(struct clk_hw *hw, unsigned long rate,
-			     unsigned long *parent_rate)
+static unsigned long pbclk_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *parent_rate)
 {
 	return calc_best_divided_rate(rate, *parent_rate,
 				      PB_DIV_MAX, PB_DIV_MIN);
@@ -377,8 +377,8 @@ static unsigned long roclk_recalc_rate(struct clk_hw *hw,
 	return roclk_calc_rate(parent_rate, rodiv, rotrim);
 }
 
-static long roclk_round_rate(struct clk_hw *hw, unsigned long rate,
-			     unsigned long *parent_rate)
+static unsigned long roclk_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *parent_rate)
 {
 	u32 rotrim, rodiv;
 
@@ -670,8 +670,8 @@ static unsigned long spll_clk_recalc_rate(struct clk_hw *hw,
 	return rate64;
 }
 
-static long spll_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *parent_rate)
+static unsigned long spll_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *parent_rate)
 {
 	struct pic32_sys_pll *pll = clkhw_to_spll(hw);
 
diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index cb43d54..af18643 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -24,8 +24,9 @@
 
 #define to_clk_factor(hw) container_of(hw, struct mmp_clk_factor, hw)
 
-static long clk_factor_round_rate(struct clk_hw *hw, unsigned long drate,
-		unsigned long *prate)
+static unsigned long clk_factor_round_rate(struct clk_hw *hw,
+					   unsigned long drate,
+					   unsigned long *prate)
 {
 	struct mmp_clk_factor *factor = to_clk_factor(hw);
 	unsigned long rate = 0, prev_rate;
diff --git a/drivers/clk/mvebu/clk-corediv.c b/drivers/clk/mvebu/clk-corediv.c
index 8491979..fa47909 100644
--- a/drivers/clk/mvebu/clk-corediv.c
+++ b/drivers/clk/mvebu/clk-corediv.c
@@ -136,8 +136,9 @@ static unsigned long clk_corediv_recalc_rate(struct clk_hw *hwclk,
 	return parent_rate / div;
 }
 
-static long clk_corediv_round_rate(struct clk_hw *hwclk, unsigned long rate,
-			       unsigned long *parent_rate)
+static unsigned long clk_corediv_round_rate(struct clk_hw *hwclk,
+					    unsigned long rate,
+					    unsigned long *parent_rate)
 {
 	/* Valid ratio are 1:4, 1:5, 1:6 and 1:8 */
 	u32 div;
diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
index 072aa38..2d9e7ab 100644
--- a/drivers/clk/mvebu/clk-cpu.c
+++ b/drivers/clk/mvebu/clk-cpu.c
@@ -58,8 +58,9 @@ static unsigned long clk_cpu_recalc_rate(struct clk_hw *hwclk,
 	return parent_rate / div;
 }
 
-static long clk_cpu_round_rate(struct clk_hw *hwclk, unsigned long rate,
-			       unsigned long *parent_rate)
+static unsigned long clk_cpu_round_rate(struct clk_hw *hwclk,
+					unsigned long rate,
+					unsigned long *parent_rate)
 {
 	/* Valid ratio are 1:1, 1:2 and 1:3 */
 	u32 div;
diff --git a/drivers/clk/mvebu/dove-divider.c b/drivers/clk/mvebu/dove-divider.c
index 7e35c89..234ba0a 100644
--- a/drivers/clk/mvebu/dove-divider.c
+++ b/drivers/clk/mvebu/dove-divider.c
@@ -108,8 +108,8 @@ static unsigned long dove_recalc_rate(struct clk_hw *hw, unsigned long parent)
 	return rate;
 }
 
-static long dove_round_rate(struct clk_hw *hw, unsigned long rate,
-			    unsigned long *parent)
+static unsigned long dove_round_rate(struct clk_hw *hw, unsigned long rate,
+				     unsigned long *parent)
 {
 	struct dove_clk *dc = to_dove_clk(hw);
 	unsigned long parent_rate = *parent;
diff --git a/drivers/clk/mxs/clk-div.c b/drivers/clk/mxs/clk-div.c
index ccebd01..60a8cc8 100644
--- a/drivers/clk/mxs/clk-div.c
+++ b/drivers/clk/mxs/clk-div.c
@@ -46,8 +46,8 @@ static unsigned long clk_div_recalc_rate(struct clk_hw *hw,
 	return div->ops->recalc_rate(&div->divider.hw, parent_rate);
 }
 
-static long clk_div_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *prate)
+static unsigned long clk_div_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *prate)
 {
 	struct clk_div *div = to_clk_div(hw);
 
diff --git a/drivers/clk/mxs/clk-frac.c b/drivers/clk/mxs/clk-frac.c
index 27b3372..f57281f 100644
--- a/drivers/clk/mxs/clk-frac.c
+++ b/drivers/clk/mxs/clk-frac.c
@@ -50,8 +50,8 @@ static unsigned long clk_frac_recalc_rate(struct clk_hw *hw,
 	return tmp_rate >> frac->width;
 }
 
-static long clk_frac_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long clk_frac_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *prate)
 {
 	struct clk_frac *frac = to_clk_frac(hw);
 	unsigned long parent_rate = *prate;
diff --git a/drivers/clk/mxs/clk-ref.c b/drivers/clk/mxs/clk-ref.c
index 495f99b..c3eb948 100644
--- a/drivers/clk/mxs/clk-ref.c
+++ b/drivers/clk/mxs/clk-ref.c
@@ -63,8 +63,8 @@ static unsigned long clk_ref_recalc_rate(struct clk_hw *hw,
 	return tmp;
 }
 
-static long clk_ref_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *prate)
+static unsigned long clk_ref_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *prate)
 {
 	unsigned long parent_rate = *prate;
 	u64 tmp = parent_rate;
diff --git a/drivers/clk/nxp/clk-lpc18xx-cgu.c b/drivers/clk/nxp/clk-lpc18xx-cgu.c
index 2531174..e08bad9 100644
--- a/drivers/clk/nxp/clk-lpc18xx-cgu.c
+++ b/drivers/clk/nxp/clk-lpc18xx-cgu.c
@@ -373,8 +373,9 @@ static unsigned long lpc18xx_pll0_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long lpc18xx_pll0_round_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long *prate)
+static unsigned long lpc18xx_pll0_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *prate)
 {
 	unsigned long m;
 
diff --git a/drivers/clk/nxp/clk-lpc32xx.c b/drivers/clk/nxp/clk-lpc32xx.c
index 7b359af..81ab57d 100644
--- a/drivers/clk/nxp/clk-lpc32xx.c
+++ b/drivers/clk/nxp/clk-lpc32xx.c
@@ -583,8 +583,9 @@ static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	return regmap_update_bits(clk_regmap, clk->reg, 0x1FFFF, val);
 }
 
-static long clk_hclk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long *parent_rate)
+static unsigned long clk_hclk_pll_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *parent_rate)
 {
 	struct lpc32xx_pll_clk *clk = to_lpc32xx_pll_clk(hw);
 	u64 m_i, o = rate, i = *parent_rate, d = (u64)rate << 6;
@@ -646,8 +647,9 @@ static long clk_hclk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 	return o;
 }
 
-static long clk_usb_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *parent_rate)
+static unsigned long clk_usb_pll_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *parent_rate)
 {
 	struct lpc32xx_pll_clk *clk = to_lpc32xx_pll_clk(hw);
 	struct clk_hw *usb_div_hw, *osc_hw;
@@ -959,8 +961,9 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 				   divider->flags);
 }
 
-static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long clk_divider_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *prate)
 {
 	struct lpc32xx_clk_div *divider = to_lpc32xx_div(hw);
 	unsigned int bestdiv;
diff --git a/drivers/clk/pistachio/clk-pll.c b/drivers/clk/pistachio/clk-pll.c
index 7e8daab..05fadea 100644
--- a/drivers/clk/pistachio/clk-pll.c
+++ b/drivers/clk/pistachio/clk-pll.c
@@ -142,8 +142,8 @@ pll_get_params(struct pistachio_clk_pll *pll, unsigned long fref,
 	return NULL;
 }
 
-static long pll_round_rate(struct clk_hw *hw, unsigned long rate,
-			   unsigned long *parent_rate)
+static unsigned long pll_round_rate(struct clk_hw *hw, unsigned long rate,
+				    unsigned long *parent_rate)
 {
 	struct pistachio_clk_pll *pll = to_pistachio_pll(hw);
 	unsigned int i;
diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index 47a1da3..4ddf8b31 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -411,8 +411,9 @@ static int clk_alpha_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
-static long clk_alpha_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *prate)
+static unsigned long clk_alpha_pll_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *prate)
 {
 	struct clk_alpha_pll *pll = to_clk_alpha_pll(hw);
 	u32 l;
@@ -472,7 +473,7 @@ static const struct clk_div_table clk_alpha_div_table[] = {
 	{ }
 };
 
-static long
+static unsigned long
 clk_alpha_pll_postdiv_round_rate(struct clk_hw *hw, unsigned long rate,
 				 unsigned long *prate)
 {
diff --git a/drivers/clk/qcom/clk-regmap-divider.c b/drivers/clk/qcom/clk-regmap-divider.c
index 5348491..21bf297 100644
--- a/drivers/clk/qcom/clk-regmap-divider.c
+++ b/drivers/clk/qcom/clk-regmap-divider.c
@@ -23,8 +23,8 @@ static inline struct clk_regmap_div *to_clk_regmap_div(struct clk_hw *hw)
 	return container_of(to_clk_regmap(hw), struct clk_regmap_div, clkr);
 }
 
-static long div_round_rate(struct clk_hw *hw, unsigned long rate,
-			   unsigned long *prate)
+static unsigned long div_round_rate(struct clk_hw *hw, unsigned long rate,
+				    unsigned long *prate)
 {
 	struct clk_regmap_div *divider = to_clk_regmap_div(hw);
 
diff --git a/drivers/clk/qcom/clk-rpm.c b/drivers/clk/qcom/clk-rpm.c
index c60f61b..62c7597 100644
--- a/drivers/clk/qcom/clk-rpm.c
+++ b/drivers/clk/qcom/clk-rpm.c
@@ -354,8 +354,8 @@ static int clk_rpm_set_rate(struct clk_hw *hw,
 	return ret;
 }
 
-static long clk_rpm_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *parent_rate)
+static unsigned long clk_rpm_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	/*
 	 * RPM handles rate rounding and we don't have a way to
diff --git a/drivers/clk/qcom/clk-smd-rpm.c b/drivers/clk/qcom/clk-smd-rpm.c
index c26d900..0ce935b 100644
--- a/drivers/clk/qcom/clk-smd-rpm.c
+++ b/drivers/clk/qcom/clk-smd-rpm.c
@@ -348,8 +348,9 @@ static int clk_smd_rpm_set_rate(struct clk_hw *hw, unsigned long rate,
 	return ret;
 }
 
-static long clk_smd_rpm_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *parent_rate)
+static unsigned long clk_smd_rpm_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *parent_rate)
 {
 	/*
 	 * RPM handles rate rounding and we don't have a way to
diff --git a/drivers/clk/qcom/gcc-ipq4019.c b/drivers/clk/qcom/gcc-ipq4019.c
index 46cb256..804231b 100644
--- a/drivers/clk/qcom/gcc-ipq4019.c
+++ b/drivers/clk/qcom/gcc-ipq4019.c
@@ -1258,8 +1258,9 @@ static const struct clk_fepll_vco gcc_fepll_vco = {
  * It looks up the frequency table and returns the next higher frequency
  * supported in hardware.
  */
-static long clk_cpu_div_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *p_rate)
+static unsigned long clk_cpu_div_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *p_rate)
 {
 	struct clk_fepll *pll = to_clk_fepll(hw);
 	struct clk_hw *p_hw;
diff --git a/drivers/clk/renesas/clk-div6.c b/drivers/clk/renesas/clk-div6.c
index 151336d..260de92 100644
--- a/drivers/clk/renesas/clk-div6.c
+++ b/drivers/clk/renesas/clk-div6.c
@@ -105,8 +105,9 @@ static unsigned int cpg_div6_clock_calc_div(unsigned long rate,
 	return clamp_t(unsigned int, div, 1, 64);
 }
 
-static long cpg_div6_clock_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *parent_rate)
+static unsigned long cpg_div6_clock_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *parent_rate)
 {
 	unsigned int div = cpg_div6_clock_calc_div(rate, *parent_rate);
 
diff --git a/drivers/clk/renesas/clk-rcar-gen2.c b/drivers/clk/renesas/clk-rcar-gen2.c
index d14cbe1..485182b9 100644
--- a/drivers/clk/renesas/clk-rcar-gen2.c
+++ b/drivers/clk/renesas/clk-rcar-gen2.c
@@ -69,8 +69,8 @@ static unsigned long cpg_z_clk_recalc_rate(struct clk_hw *hw,
 	return div_u64((u64)parent_rate * mult, 32);
 }
 
-static long cpg_z_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *parent_rate)
+static unsigned long cpg_z_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
 {
 	unsigned long prate  = *parent_rate;
 	unsigned int mult;
diff --git a/drivers/clk/renesas/rcar-gen2-cpg.c b/drivers/clk/renesas/rcar-gen2-cpg.c
index feb1457..594eff2 100644
--- a/drivers/clk/renesas/rcar-gen2-cpg.c
+++ b/drivers/clk/renesas/rcar-gen2-cpg.c
@@ -65,8 +65,8 @@ static unsigned long cpg_z_clk_recalc_rate(struct clk_hw *hw,
 	return div_u64((u64)parent_rate * mult, 32);
 }
 
-static long cpg_z_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *parent_rate)
+static unsigned long cpg_z_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
 {
 	unsigned long prate  = *parent_rate;
 	unsigned int mult;
diff --git a/drivers/clk/renesas/rcar-gen3-cpg.c b/drivers/clk/renesas/rcar-gen3-cpg.c
index 0904886..017b34f 100644
--- a/drivers/clk/renesas/rcar-gen3-cpg.c
+++ b/drivers/clk/renesas/rcar-gen3-cpg.c
@@ -175,8 +175,9 @@ static unsigned int cpg_sd_clock_calc_div(struct sd_clock *clock,
 	return clamp_t(unsigned int, div, clock->div_min, clock->div_max);
 }
 
-static long cpg_sd_clock_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *parent_rate)
+static unsigned long cpg_sd_clock_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *parent_rate)
 {
 	struct sd_clock *clock = to_sd_clock(hw);
 	unsigned int div = cpg_sd_clock_calc_div(clock, rate, *parent_rate);
diff --git a/drivers/clk/rockchip/clk-ddr.c b/drivers/clk/rockchip/clk-ddr.c
index e807535..181053b 100644
--- a/drivers/clk/rockchip/clk-ddr.c
+++ b/drivers/clk/rockchip/clk-ddr.c
@@ -64,9 +64,9 @@ rockchip_ddrclk_sip_recalc_rate(struct clk_hw *hw,
 	return res.a0;
 }
 
-static long rockchip_ddrclk_sip_round_rate(struct clk_hw *hw,
-					   unsigned long rate,
-					   unsigned long *prate)
+static unsigned long rockchip_ddrclk_sip_round_rate(struct clk_hw *hw,
+						    unsigned long rate,
+						    unsigned long *prate)
 {
 	struct arm_smccc_res res;
 
diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index dd0433d..7963322 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -69,8 +69,9 @@ static const struct rockchip_pll_rate_table *rockchip_get_pll_settings(
 	return NULL;
 }
 
-static long rockchip_pll_round_rate(struct clk_hw *hw,
-			    unsigned long drate, unsigned long *prate)
+static unsigned long rockchip_pll_round_rate(struct clk_hw *hw,
+					     unsigned long drate,
+					     unsigned long *prate)
 {
 	struct rockchip_clk_pll *pll = to_rockchip_clk_pll(hw);
 	const struct rockchip_pll_rate_table *rate_table = pll->rate_table;
diff --git a/drivers/clk/samsung/clk-cpu.c b/drivers/clk/samsung/clk-cpu.c
index d2c99d8..e94d5dd 100644
--- a/drivers/clk/samsung/clk-cpu.c
+++ b/drivers/clk/samsung/clk-cpu.c
@@ -104,8 +104,9 @@ static void wait_until_mux_stable(void __iomem *mux_reg, u32 mux_pos,
 }
 
 /* common round rate callback useable for all types of CPU clocks */
-static long exynos_cpuclk_round_rate(struct clk_hw *hw,
-			unsigned long drate, unsigned long *prate)
+static unsigned long exynos_cpuclk_round_rate(struct clk_hw *hw,
+					      unsigned long drate,
+					      unsigned long *prate)
 {
 	struct clk_hw *parent = clk_hw_get_parent(hw);
 	*prate = clk_hw_round_rate(parent, drate);
diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 1c4c7a3..ebdddb0 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -48,8 +48,9 @@ static const struct samsung_pll_rate_table *samsung_get_pll_settings(
 	return NULL;
 }
 
-static long samsung_pll_round_rate(struct clk_hw *hw,
-			unsigned long drate, unsigned long *prate)
+static unsigned long samsung_pll_round_rate(struct clk_hw *hw,
+					    unsigned long drate,
+					    unsigned long *prate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	const struct samsung_pll_rate_table *rate_table = pll->rate_table;
diff --git a/drivers/clk/sirf/clk-atlas7.c b/drivers/clk/sirf/clk-atlas7.c
index be012b4..99703d4 100644
--- a/drivers/clk/sirf/clk-atlas7.c
+++ b/drivers/clk/sirf/clk-atlas7.c
@@ -535,8 +535,8 @@ static unsigned long dto_clk_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long dto_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-	unsigned long *parent_rate)
+static unsigned long dto_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	u64 dividend = rate * DTO_RESL_DOUBLE;
 
diff --git a/drivers/clk/sirf/clk-common.c b/drivers/clk/sirf/clk-common.c
index d8f9efa..3ce6741 100644
--- a/drivers/clk/sirf/clk-common.c
+++ b/drivers/clk/sirf/clk-common.c
@@ -93,8 +93,8 @@ static unsigned long pll_clk_recalc_rate(struct clk_hw *hw,
 	}
 }
 
-static long pll_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-	unsigned long *parent_rate)
+static unsigned long pll_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	unsigned long fin, nf, nr, od;
 	u64 dividend;
@@ -160,8 +160,8 @@ static int pll_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
-static long cpu_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-	unsigned long *parent_rate)
+static unsigned long cpu_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	/*
 	 * SiRF SoC has not cpu clock control,
@@ -349,8 +349,8 @@ static unsigned long dmn_clk_recalc_rate(struct clk_hw *hw,
 	}
 }
 
-static long dmn_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-	unsigned long *parent_rate)
+static unsigned long dmn_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	unsigned long fin;
 	unsigned ratio, wait, hold;
diff --git a/drivers/clk/spear/clk-aux-synth.c b/drivers/clk/spear/clk-aux-synth.c
index 9064104..536134d 100644
--- a/drivers/clk/spear/clk-aux-synth.c
+++ b/drivers/clk/spear/clk-aux-synth.c
@@ -52,8 +52,8 @@ static unsigned long aux_calc_rate(struct clk_hw *hw, unsigned long prate,
 			(rtbl[index].yscale * eq)) * 10000;
 }
 
-static long clk_aux_round_rate(struct clk_hw *hw, unsigned long drate,
-		unsigned long *prate)
+static unsigned long clk_aux_round_rate(struct clk_hw *hw, unsigned long drate,
+					unsigned long *prate)
 {
 	struct clk_aux *aux = to_clk_aux(hw);
 	int unused;
diff --git a/drivers/clk/spear/clk-frac-synth.c b/drivers/clk/spear/clk-frac-synth.c
index 229c96d..c9d551c 100644
--- a/drivers/clk/spear/clk-frac-synth.c
+++ b/drivers/clk/spear/clk-frac-synth.c
@@ -55,8 +55,8 @@ static unsigned long frac_calc_rate(struct clk_hw *hw, unsigned long prate,
 	return prate;
 }
 
-static long clk_frac_round_rate(struct clk_hw *hw, unsigned long drate,
-		unsigned long *prate)
+static unsigned long clk_frac_round_rate(struct clk_hw *hw, unsigned long drate,
+					 unsigned long *prate)
 {
 	struct clk_frac *frac = to_clk_frac(hw);
 	int unused;
diff --git a/drivers/clk/spear/clk-gpt-synth.c b/drivers/clk/spear/clk-gpt-synth.c
index 28262f4..5cb8c69 100644
--- a/drivers/clk/spear/clk-gpt-synth.c
+++ b/drivers/clk/spear/clk-gpt-synth.c
@@ -42,8 +42,8 @@ static unsigned long gpt_calc_rate(struct clk_hw *hw, unsigned long prate,
 	return prate;
 }
 
-static long clk_gpt_round_rate(struct clk_hw *hw, unsigned long drate,
-		unsigned long *prate)
+static unsigned long clk_gpt_round_rate(struct clk_hw *hw, unsigned long drate,
+					unsigned long *prate)
 {
 	struct clk_gpt *gpt = to_clk_gpt(hw);
 	int unused;
diff --git a/drivers/clk/spear/clk-vco-pll.c b/drivers/clk/spear/clk-vco-pll.c
index c08dec3..d168897 100644
--- a/drivers/clk/spear/clk-vco-pll.c
+++ b/drivers/clk/spear/clk-vco-pll.c
@@ -81,8 +81,9 @@ static unsigned long pll_calc_rate(struct pll_rate_tbl *rtbl,
 	return rate * 10000;
 }
 
-static long clk_pll_round_rate_index(struct clk_hw *hw, unsigned long drate,
-				unsigned long *prate, int *index)
+static unsigned long clk_pll_round_rate_index(struct clk_hw *hw,
+					      unsigned long drate,
+					      unsigned long *prate, int *index)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
 	unsigned long prev_rate, vco_prev_rate, rate = 0;
@@ -113,8 +114,8 @@ static long clk_pll_round_rate_index(struct clk_hw *hw, unsigned long drate,
 	return rate;
 }
 
-static long clk_pll_round_rate(struct clk_hw *hw, unsigned long drate,
-				unsigned long *prate)
+static unsigned long clk_pll_round_rate(struct clk_hw *hw, unsigned long drate,
+					unsigned long *prate)
 {
 	int unused;
 
@@ -179,8 +180,8 @@ static inline unsigned long vco_calc_rate(struct clk_hw *hw,
 	return pll_calc_rate(vco->rtbl, prate, index, NULL);
 }
 
-static long clk_vco_round_rate(struct clk_hw *hw, unsigned long drate,
-		unsigned long *prate)
+static unsigned long clk_vco_round_rate(struct clk_hw *hw, unsigned long drate,
+					unsigned long *prate)
 {
 	struct clk_vco *vco = to_clk_vco(hw);
 	int unused;
diff --git a/drivers/clk/spear/clk.c b/drivers/clk/spear/clk.c
index 157fe09..335af3b 100644
--- a/drivers/clk/spear/clk.c
+++ b/drivers/clk/spear/clk.c
@@ -13,9 +13,10 @@
 #include <linux/types.h>
 #include "clk.h"
 
-long clk_round_rate_index(struct clk_hw *hw, unsigned long drate,
-		unsigned long parent_rate, clk_calc_rate calc_rate, u8 rtbl_cnt,
-		int *index)
+unsigned long clk_round_rate_index(struct clk_hw *hw, unsigned long drate,
+				   unsigned long parent_rate,
+				   clk_calc_rate calc_rate, u8 rtbl_cnt,
+				   int *index)
 {
 	unsigned long prev_rate, rate = 0;
 
diff --git a/drivers/clk/spear/clk.h b/drivers/clk/spear/clk.h
index af0e25f..c8b81f2 100644
--- a/drivers/clk/spear/clk.h
+++ b/drivers/clk/spear/clk.h
@@ -127,8 +127,9 @@ struct clk *clk_register_vco_pll(const char *vco_name, const char *pll_name,
 		spinlock_t *lock, struct clk **pll_clk,
 		struct clk **vco_gate_clk);
 
-long clk_round_rate_index(struct clk_hw *hw, unsigned long drate,
-		unsigned long parent_rate, clk_calc_rate calc_rate, u8 rtbl_cnt,
-		int *index);
+unsigned long clk_round_rate_index(struct clk_hw *hw, unsigned long drate,
+				   unsigned long parent_rate,
+				   clk_calc_rate calc_rate, u8 rtbl_cnt,
+				   int *index);
 
 #endif /* __SPEAR_CLK_H */
diff --git a/drivers/clk/st/clk-flexgen.c b/drivers/clk/st/clk-flexgen.c
index 918ba31..682ba23 100644
--- a/drivers/clk/st/clk-flexgen.c
+++ b/drivers/clk/st/clk-flexgen.c
@@ -111,8 +111,8 @@ clk_best_div(unsigned long parent_rate, unsigned long rate)
 	return parent_rate / rate + ((rate > (2*(parent_rate % rate))) ? 0 : 1);
 }
 
-static long flexgen_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *prate)
+static unsigned long flexgen_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *prate)
 {
 	unsigned long div;
 
diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index 14819d9..f6a1a85 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -318,9 +318,9 @@ static int clk_fs660c32_vco_get_params(unsigned long input,
 	return 0;
 }
 
-static long quadfs_pll_fs660c32_round_rate(struct clk_hw *hw,
-					   unsigned long rate,
-					   unsigned long *prate)
+static unsigned long quadfs_pll_fs660c32_round_rate(struct clk_hw *hw,
+						    unsigned long rate,
+						    unsigned long *prate)
 {
 	struct stm_fs params;
 
@@ -757,8 +757,8 @@ static unsigned long quadfs_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long quadfs_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *prate)
+static unsigned long quadfs_round_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long *prate)
 {
 	struct stm_fs params;
 
diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
index 25bda48..64ac4e1 100644
--- a/drivers/clk/st/clkgen-pll.c
+++ b/drivers/clk/st/clkgen-pll.c
@@ -351,8 +351,9 @@ static unsigned long recalc_stm_pll3200c32(struct clk_hw *hw,
 	return rate;
 }
 
-static long round_rate_stm_pll3200c32(struct clk_hw *hw, unsigned long rate,
-		unsigned long *prate)
+static unsigned long round_rate_stm_pll3200c32(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *prate)
 {
 	struct stm_pll params;
 
@@ -505,8 +506,9 @@ static unsigned long recalc_stm_pll4600c28(struct clk_hw *hw,
 	return rate;
 }
 
-static long round_rate_stm_pll4600c28(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *prate)
+static unsigned long round_rate_stm_pll4600c28(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *prate)
 {
 	struct stm_pll params;
 
diff --git a/drivers/clk/sunxi-ng/ccu_nk.c b/drivers/clk/sunxi-ng/ccu_nk.c
index 2485bda..031f934 100644
--- a/drivers/clk/sunxi-ng/ccu_nk.c
+++ b/drivers/clk/sunxi-ng/ccu_nk.c
@@ -93,8 +93,8 @@ static unsigned long ccu_nk_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long ccu_nk_round_rate(struct clk_hw *hw, unsigned long rate,
-			      unsigned long *parent_rate)
+static unsigned long ccu_nk_round_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long *parent_rate)
 {
 	struct ccu_nk *nk = hw_to_ccu_nk(hw);
 	struct _ccu_nk _nk;
diff --git a/drivers/clk/sunxi-ng/ccu_nkmp.c b/drivers/clk/sunxi-ng/ccu_nkmp.c
index e58c957..62fbba7 100644
--- a/drivers/clk/sunxi-ng/ccu_nkmp.c
+++ b/drivers/clk/sunxi-ng/ccu_nkmp.c
@@ -110,8 +110,8 @@ static unsigned long ccu_nkmp_recalc_rate(struct clk_hw *hw,
 	return (parent_rate * n * k >> p) / m;
 }
 
-static long ccu_nkmp_round_rate(struct clk_hw *hw, unsigned long rate,
-			      unsigned long *parent_rate)
+static unsigned long ccu_nkmp_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *parent_rate)
 {
 	struct ccu_nkmp *nkmp = hw_to_ccu_nkmp(hw);
 	struct _ccu_nkmp _nkmp;
diff --git a/drivers/clk/sunxi-ng/ccu_nm.c b/drivers/clk/sunxi-ng/ccu_nm.c
index 7620aa9..0f5beb4 100644
--- a/drivers/clk/sunxi-ng/ccu_nm.c
+++ b/drivers/clk/sunxi-ng/ccu_nm.c
@@ -101,8 +101,8 @@ static unsigned long ccu_nm_recalc_rate(struct clk_hw *hw,
 	return parent_rate * n / m;
 }
 
-static long ccu_nm_round_rate(struct clk_hw *hw, unsigned long rate,
-			      unsigned long *parent_rate)
+static unsigned long ccu_nm_round_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long *parent_rate)
 {
 	struct ccu_nm *nm = hw_to_ccu_nm(hw);
 	struct _ccu_nm _nm;
diff --git a/drivers/clk/tegra/clk-audio-sync.c b/drivers/clk/tegra/clk-audio-sync.c
index 92d04ce..9784d58 100644
--- a/drivers/clk/tegra/clk-audio-sync.c
+++ b/drivers/clk/tegra/clk-audio-sync.c
@@ -28,8 +28,9 @@ static unsigned long clk_sync_source_recalc_rate(struct clk_hw *hw,
 	return sync->rate;
 }
 
-static long clk_sync_source_round_rate(struct clk_hw *hw, unsigned long rate,
-				       unsigned long *prate)
+static unsigned long clk_sync_source_round_rate(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long *prate)
 {
 	struct tegra_clk_sync_source *sync = to_clk_sync_source(hw);
 
diff --git a/drivers/clk/tegra/clk-bpmp.c b/drivers/clk/tegra/clk-bpmp.c
index a896692..0c1197b 100644
--- a/drivers/clk/tegra/clk-bpmp.c
+++ b/drivers/clk/tegra/clk-bpmp.c
@@ -167,8 +167,9 @@ static unsigned long tegra_bpmp_clk_recalc_rate(struct clk_hw *hw,
 	return response.rate;
 }
 
-static long tegra_bpmp_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *parent_rate)
+static unsigned long tegra_bpmp_clk_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *parent_rate)
 {
 	struct tegra_bpmp_clk *clk = to_tegra_bpmp_clk(hw);
 	struct cmd_clk_round_rate_response response;
diff --git a/drivers/clk/tegra/clk-divider.c b/drivers/clk/tegra/clk-divider.c
index 16e0aee..d827943 100644
--- a/drivers/clk/tegra/clk-divider.c
+++ b/drivers/clk/tegra/clk-divider.c
@@ -84,8 +84,9 @@ static unsigned long clk_frac_div_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long clk_frac_div_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *prate)
+static unsigned long clk_frac_div_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *prate)
 {
 	struct tegra_clk_frac_div *divider = to_clk_frac_div(hw);
 	int div, mul;
diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index 9475c00..e68104c 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -55,8 +55,9 @@ static unsigned long clk_periph_recalc_rate(struct clk_hw *hw,
 	return div_ops->recalc_rate(div_hw, parent_rate);
 }
 
-static long clk_periph_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static unsigned long clk_periph_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *prate)
 {
 	struct tegra_clk_periph *periph = to_clk_periph(hw);
 	const struct clk_ops *div_ops = periph->div_ops;
diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 7c369e2..b4a7d30 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -824,8 +824,8 @@ static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	return ret;
 }
 
-static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-			unsigned long *prate)
+static unsigned long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *prate)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 	struct tegra_clk_pll_freq_table cfg;
@@ -1307,8 +1307,9 @@ static int clk_pllxc_set_rate(struct clk_hw *hw, unsigned long rate,
 	return ret;
 }
 
-static long clk_pll_ramp_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long clk_pll_ramp_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *prate)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 	struct tegra_clk_pll_freq_table cfg;
@@ -1549,8 +1550,8 @@ static unsigned long clk_pllre_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long clk_pllre_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *prate)
+static unsigned long clk_pllre_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *prate)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 
diff --git a/drivers/clk/tegra/clk-super.c b/drivers/clk/tegra/clk-super.c
index 84267cf..a8fa71e 100644
--- a/drivers/clk/tegra/clk-super.c
+++ b/drivers/clk/tegra/clk-super.c
@@ -126,8 +126,8 @@ const struct clk_ops tegra_clk_super_mux_ops = {
 	.set_parent = clk_super_set_parent,
 };
 
-static long clk_super_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *parent_rate)
+static unsigned long clk_super_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
 {
 	struct tegra_clk_super_mux *super = to_clk_super_mux(hw);
 	struct clk_hw *div_hw = &super->frac_div.hw;
diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index 1488154..bd689ce 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -128,8 +128,8 @@ static unsigned long atl_clk_recalc_rate(struct clk_hw *hw,
 	return parent_rate / cdesc->divider;
 }
 
-static long atl_clk_round_rate(struct clk_hw *hw, unsigned long rate,
-			       unsigned long *parent_rate)
+static unsigned long atl_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
 {
 	unsigned divider;
 
diff --git a/drivers/clk/ti/composite.c b/drivers/clk/ti/composite.c
index beea894..2477cf1 100644
--- a/drivers/clk/ti/composite.c
+++ b/drivers/clk/ti/composite.c
@@ -34,8 +34,9 @@ static unsigned long ti_composite_recalc_rate(struct clk_hw *hw,
 	return ti_clk_divider_ops.recalc_rate(hw, parent_rate);
 }
 
-static long ti_composite_round_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long *prate)
+static unsigned long ti_composite_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *prate)
 {
 	return -EINVAL;
 }
diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index 77f93f6..a194250 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -227,8 +227,9 @@ static int ti_clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	return bestdiv;
 }
 
-static long ti_clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *prate)
+static unsigned long ti_clk_divider_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *prate)
 {
 	int div;
 	div = ti_clk_divider_bestdiv(hw, rate, prate);
diff --git a/drivers/clk/ti/fapll.c b/drivers/clk/ti/fapll.c
index 071af44..2e74437 100644
--- a/drivers/clk/ti/fapll.c
+++ b/drivers/clk/ti/fapll.c
@@ -220,8 +220,8 @@ static int ti_fapll_set_div_mult(unsigned long rate,
 	return 0;
 }
 
-static long ti_fapll_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *parent_rate)
+static unsigned long ti_fapll_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *parent_rate)
 {
 	u32 pre_div_p, mult_n;
 	int error;
@@ -405,8 +405,9 @@ static u32 ti_fapll_synth_set_frac_rate(struct fapll_synth *synth,
 	return post_div_m;
 }
 
-static long ti_fapll_synth_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *parent_rate)
+static unsigned long ti_fapll_synth_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *parent_rate)
 {
 	struct fapll_synth *synth = to_synth(hw);
 	struct fapll_data *fd = synth->fd;
diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
index 9d1f2d4..8eb7c7a 100644
--- a/drivers/clk/ux500/clk-prcmu.c
+++ b/drivers/clk/ux500/clk-prcmu.c
@@ -80,8 +80,8 @@ static unsigned long clk_prcmu_recalc_rate(struct clk_hw *hw,
 	return prcmu_clock_rate(clk->cg_sel);
 }
 
-static long clk_prcmu_round_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *parent_rate)
+static unsigned long clk_prcmu_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
 {
 	struct clk_prcmu *clk = to_clk_prcmu(hw);
 	return prcmu_round_clock_rate(clk->cg_sel, rate);
diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
index dafe7a4..2fb3cdc 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -248,8 +248,8 @@ static unsigned long icst_recalc_rate(struct clk_hw *hw,
 	return icst->rate;
 }
 
-static long icst_round_rate(struct clk_hw *hw, unsigned long rate,
-			    unsigned long *prate)
+static unsigned long icst_round_rate(struct clk_hw *hw, unsigned long rate,
+				     unsigned long *prate)
 {
 	struct clk_icst *icst = to_icst(hw);
 	struct icst_vco vco;
diff --git a/drivers/clk/versatile/clk-vexpress-osc.c b/drivers/clk/versatile/clk-vexpress-osc.c
index e7a868b..0d02097 100644
--- a/drivers/clk/versatile/clk-vexpress-osc.c
+++ b/drivers/clk/versatile/clk-vexpress-osc.c
@@ -39,8 +39,9 @@ static unsigned long vexpress_osc_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
-static long vexpress_osc_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *parent_rate)
+static unsigned long vexpress_osc_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *parent_rate)
 {
 	struct vexpress_osc *osc = to_vexpress_osc(hw);
 
diff --git a/drivers/clk/zte/clk.c b/drivers/clk/zte/clk.c
index b820317..df91842 100644
--- a/drivers/clk/zte/clk.c
+++ b/drivers/clk/zte/clk.c
@@ -78,8 +78,8 @@ static unsigned long zx_pll_recalc_rate(struct clk_hw *hw,
 	return zx_pll->lookup_table[idx].rate;
 }
 
-static long zx_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-			      unsigned long *prate)
+static unsigned long zx_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long *prate)
 {
 	struct clk_zx_pll *zx_pll = to_clk_zx_pll(hw);
 	int idx;
@@ -241,8 +241,8 @@ static unsigned long zx_audio_recalc_rate(struct clk_hw *hw,
 	return calc_rate(reg, parent_rate);
 }
 
-static long zx_audio_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long zx_audio_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *prate)
 {
 	u32 reg;
 
@@ -404,8 +404,9 @@ static unsigned long zx_audio_div_recalc_rate(struct clk_hw *hw,
 	return audio_calc_rate(zx_audio_div, reg_frac, reg_int, parent_rate);
 }
 
-static long zx_audio_div_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long zx_audio_div_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *prate)
 {
 	struct clk_zx_audio_divider *zx_audio_div = to_clk_zx_audio_div(hw);
 	struct zx_clk_audio_div_table divt;
diff --git a/drivers/clk/zynq/pll.c b/drivers/clk/zynq/pll.c
index 00d72fb..827a375 100644
--- a/drivers/clk/zynq/pll.c
+++ b/drivers/clk/zynq/pll.c
@@ -60,8 +60,8 @@ struct zynq_pll {
  * @prate:	Clock frequency of parent clock
  * Returns frequency closest to @rate the hardware can generate.
  */
-static long zynq_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *prate)
+static unsigned long zynq_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *prate)
 {
 	u32 fbdiv;
 
diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index bc27c26..8533bd5 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -402,8 +402,9 @@ static unsigned long clk_tve_di_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long clk_tve_di_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static unsigned long clk_tve_di_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *prate)
 {
 	unsigned long div;
 
diff --git a/drivers/gpu/drm/mediatek/mtk_mipi_tx.c b/drivers/gpu/drm/mediatek/mtk_mipi_tx.c
index 90e9131..b7e920c 100644
--- a/drivers/gpu/drm/mediatek/mtk_mipi_tx.c
+++ b/drivers/gpu/drm/mediatek/mtk_mipi_tx.c
@@ -289,8 +289,9 @@ static void mtk_mipi_tx_pll_unprepare(struct clk_hw *hw)
 			       RG_DSI_MPPLL_DIV_MSK);
 }
 
-static long mtk_mipi_tx_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				       unsigned long *prate)
+static unsigned long mtk_mipi_tx_pll_round_rate(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long *prate)
 {
 	return clamp_val(rate, 50000000, 1250000000);
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c b/drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c
index 51cb9cf..3a031bd 100644
--- a/drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c
+++ b/drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c
@@ -345,8 +345,9 @@ static int mtk_hdmi_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
-static long mtk_hdmi_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long *parent_rate)
+static unsigned long mtk_hdmi_pll_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *parent_rate)
 {
 	struct mtk_hdmi_phy *hdmi_phy = to_mtk_hdmi_phy(hw);
 
diff --git a/drivers/gpu/drm/msm/dsi/pll/dsi_pll.c b/drivers/gpu/drm/msm/dsi/pll/dsi_pll.c
index bc289f5..a8ceb80 100644
--- a/drivers/gpu/drm/msm/dsi/pll/dsi_pll.c
+++ b/drivers/gpu/drm/msm/dsi/pll/dsi_pll.c
@@ -56,8 +56,9 @@ static void dsi_pll_disable(struct msm_dsi_pll *pll)
 /*
  * DSI PLL Helper functions
  */
-long msm_dsi_pll_helper_clk_round_rate(struct clk_hw *hw,
-		unsigned long rate, unsigned long *parent_rate)
+unsigned long msm_dsi_pll_helper_clk_round_rate(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long *parent_rate)
 {
 	struct msm_dsi_pll *pll = hw_clk_to_pll(hw);
 
diff --git a/drivers/gpu/drm/msm/dsi/pll/dsi_pll.h b/drivers/gpu/drm/msm/dsi/pll/dsi_pll.h
index f63e7ad..66e5a2a 100644
--- a/drivers/gpu/drm/msm/dsi/pll/dsi_pll.h
+++ b/drivers/gpu/drm/msm/dsi/pll/dsi_pll.h
@@ -74,8 +74,9 @@ static inline void pll_write_ndelay(void __iomem *reg, u32 data, u32 delay_ns)
  */
 
 /* clock callbacks */
-long msm_dsi_pll_helper_clk_round_rate(struct clk_hw *hw,
-		unsigned long rate, unsigned long *parent_rate);
+unsigned long msm_dsi_pll_helper_clk_round_rate(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long *parent_rate);
 int msm_dsi_pll_helper_clk_prepare(struct clk_hw *hw);
 void msm_dsi_pll_helper_clk_unprepare(struct clk_hw *hw);
 /* misc */
diff --git a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_14nm.c b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_14nm.c
index fe15aa6..eba0a32 100644
--- a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_14nm.c
@@ -701,9 +701,9 @@ static unsigned long dsi_pll_14nm_postdiv_recalc_rate(struct clk_hw *hw,
 				   postdiv->flags);
 }
 
-static long dsi_pll_14nm_postdiv_round_rate(struct clk_hw *hw,
-					    unsigned long rate,
-					    unsigned long *prate)
+static unsigned long dsi_pll_14nm_postdiv_round_rate(struct clk_hw *hw,
+						     unsigned long rate,
+						     unsigned long *prate)
 {
 	struct dsi_pll_14nm_postdiv *postdiv = to_pll_14nm_postdiv(hw);
 	struct dsi_pll_14nm *pll_14nm = postdiv->pll;
diff --git a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_28nm_8960.c b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_28nm_8960.c
index 4900845..f081731 100644
--- a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_28nm_8960.c
+++ b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_28nm_8960.c
@@ -252,8 +252,9 @@ static unsigned int get_vco_mul_factor(unsigned long byte_clk_rate)
 		return 8;
 }
 
-static long clk_bytediv_round_rate(struct clk_hw *hw, unsigned long rate,
-				   unsigned long *prate)
+static unsigned long clk_bytediv_round_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *prate)
 {
 	unsigned long best_parent;
 	unsigned int factor;
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_phy_8996.c b/drivers/gpu/drm/msm/hdmi/hdmi_phy_8996.c
index 0df504c..46ca7a5 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy_8996.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy_8996.c
@@ -636,9 +636,9 @@ static int hdmi_8996_pll_prepare(struct clk_hw *hw)
 	return 0;
 }
 
-static long hdmi_8996_pll_round_rate(struct clk_hw *hw,
-				     unsigned long rate,
-				     unsigned long *parent_rate)
+static unsigned long hdmi_8996_pll_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *parent_rate)
 {
 	if (rate < HDMI_PCLK_MIN_FREQ)
 		return HDMI_PCLK_MIN_FREQ;
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_pll_8960.c b/drivers/gpu/drm/msm/hdmi/hdmi_pll_8960.c
index 9959075..a0c3650 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_pll_8960.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_pll_8960.c
@@ -382,8 +382,8 @@ static unsigned long hdmi_pll_recalc_rate(struct clk_hw *hw,
 	return pll->pixclk;
 }
 
-static long hdmi_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *parent_rate)
+static unsigned long hdmi_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *parent_rate)
 {
 	const struct pll_rate *pll_rate = find_rate(rate);
 
diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c
index ce42459..fdbbef3 100644
--- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c
+++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c
@@ -109,8 +109,9 @@ static unsigned long mpd4_lvds_pll_recalc_rate(struct clk_hw *hw,
 	return lvds_pll->pixclk;
 }
 
-static long mpd4_lvds_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *parent_rate)
+static unsigned long mpd4_lvds_pll_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *parent_rate)
 {
 	const struct pll_rate *pll_rate = find_rate(rate);
 	return pll_rate->rate;
diff --git a/drivers/gpu/drm/pl111/pl111_display.c b/drivers/gpu/drm/pl111/pl111_display.c
index 06c4bf7..d7e99d9 100644
--- a/drivers/gpu/drm/pl111/pl111_display.c
+++ b/drivers/gpu/drm/pl111/pl111_display.c
@@ -338,8 +338,9 @@ static int pl111_clk_div_choose_div(struct clk_hw *hw, unsigned long rate,
 	return best_div;
 }
 
-static long pl111_clk_div_round_rate(struct clk_hw *hw, unsigned long rate,
-				     unsigned long *prate)
+static unsigned long pl111_clk_div_round_rate(struct clk_hw *hw,
+					      unsigned long rate,
+					      unsigned long *prate)
 {
 	int div = pl111_clk_div_choose_div(hw, rate, prate, true);
 
diff --git a/drivers/gpu/drm/sun4i/sun4i_dotclock.c b/drivers/gpu/drm/sun4i/sun4i_dotclock.c
index d401156..4bb7ae7 100644
--- a/drivers/gpu/drm/sun4i/sun4i_dotclock.c
+++ b/drivers/gpu/drm/sun4i/sun4i_dotclock.c
@@ -70,8 +70,9 @@ static unsigned long sun4i_dclk_recalc_rate(struct clk_hw *hw,
 	return parent_rate / val;
 }
 
-static long sun4i_dclk_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *parent_rate)
+static unsigned long sun4i_dclk_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *parent_rate)
 {
 	unsigned long best_parent = 0;
 	u8 best_div = 1;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index b7ff384..3461f9d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -243,8 +243,8 @@ static u32 isp_xclk_calc_divider(unsigned long *rate, unsigned long parent_rate)
 	return divider;
 }
 
-static long isp_xclk_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *parent_rate)
+static unsigned long isp_xclk_round_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long *parent_rate)
 {
 	isp_xclk_calc_divider(&rate, *parent_rate);
 	return rate;
diff --git a/drivers/rtc/rtc-ac100.c b/drivers/rtc/rtc-ac100.c
index 9e33618..0bd0685 100644
--- a/drivers/rtc/rtc-ac100.c
+++ b/drivers/rtc/rtc-ac100.c
@@ -146,8 +146,9 @@ static unsigned long ac100_clkout_recalc_rate(struct clk_hw *hw,
 				   CLK_DIVIDER_POWER_OF_TWO);
 }
 
-static long ac100_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long prate)
+static unsigned long ac100_clkout_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long prate)
 {
 	unsigned long best_rate = 0, tmp_rate, tmp_prate;
 	int i;
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 923dde9..d6fb29d 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1166,8 +1166,9 @@ static unsigned long ds3231_clk_sqw_recalc_rate(struct clk_hw *hw,
 	return ds3231_clk_sqw_rates[rate_sel];
 }
 
-static long ds3231_clk_sqw_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *prate)
+static unsigned long ds3231_clk_sqw_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *prate)
 {
 	int i;
 
diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index e5ad527..426b1f7 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -313,8 +313,9 @@ static unsigned long hym8563_clkout_recalc_rate(struct clk_hw *hw,
 	return clkout_rates[ret];
 }
 
-static long hym8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *prate)
+static unsigned long hym8563_clkout_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *prate)
 {
 	int i;
 
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index c90fba3..40a89e3 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -469,8 +469,9 @@ static unsigned long m41t80_sqw_recalc_rate(struct clk_hw *hw,
 	return sqw_to_m41t80_data(hw)->freq;
 }
 
-static long m41t80_sqw_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static unsigned long m41t80_sqw_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *prate)
 {
 	if (rate >= M41T80_SQW_MAX_FREQ)
 		return M41T80_SQW_MAX_FREQ;
diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 3efc86c..57b12cb 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -425,8 +425,9 @@ static unsigned long pcf8563_clkout_recalc_rate(struct clk_hw *hw,
 	return clkout_rates[buf];
 }
 
-static long pcf8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *prate)
+static unsigned long pcf8563_clkout_round_rate(struct clk_hw *hw,
+					       unsigned long rate,
+					       unsigned long *prate)
 {
 	int i;
 
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 7c925e6..79b1d6e 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -200,8 +200,8 @@ struct clk_ops {
 	void		(*disable_unused)(struct clk_hw *hw);
 	unsigned long	(*recalc_rate)(struct clk_hw *hw,
 					unsigned long parent_rate);
-	long		(*round_rate)(struct clk_hw *hw, unsigned long rate,
-					unsigned long *parent_rate);
+	unsigned long	(*round_rate)(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *parent_rate);
 	int		(*determine_rate)(struct clk_hw *hw,
 					  struct clk_rate_request *req);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
-- 
2.7.4
