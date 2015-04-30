Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53079 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751700AbbD3PaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 11:30:20 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
	Stephen Boyd <sboyd@codeaurora.org>, linux-clk@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
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
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-mips@linux-mips.org, patches@opensource.wolfsonmicro.com,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, spear-devel@list.st.com,
	linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH v2 0/2] clk: adapt ->round_rate()/->determine_rate() prototypes
Date: Thu, 30 Apr 2015 17:30:07 +0200
Message-Id: <1430407809-31147-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

As previously discussed in this thread [1], this series is changing
clk_ops' ->round_rate()/->determine_rate() prototypes to avoid long
overflows when the returned rate is exceeding 2Ghz.

Most of those changes have been compile-tested, but none of them have
been tested on real hardware (the changes are quite simple though).

Best Regards,

Boris

[1]https://lkml.org/lkml/2015/4/14/528

Changes since v1:
- fix an 'uninitialized variable' bug reported by Heiko
- rebased on clk-next

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

Boris Brezillon (2):
  clk: change clk_ops' ->round_rate() prototype
  clk: change clk_ops' ->determine_rate() prototype

 Documentation/clk.txt                        |  8 +--
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
 arch/arm/mach-omap2/dpll3xxx.c               | 45 ++++++++-----
 arch/arm/mach-omap2/dpll44xx.c               | 44 +++++++------
 arch/arm/mach-vexpress/spc.c                 | 11 +++-
 arch/mips/alchemy/common/clock.c             | 76 ++++++++++++++--------
 drivers/clk/at91/clk-h32mx.c                 | 24 ++++---
 drivers/clk/at91/clk-peripheral.c            | 31 +++++----
 drivers/clk/at91/clk-pll.c                   | 14 ++--
 drivers/clk/at91/clk-plldiv.c                | 22 ++++---
 drivers/clk/at91/clk-programmable.c          | 28 ++++----
 drivers/clk/at91/clk-smd.c                   | 24 ++++---
 drivers/clk/at91/clk-usb.c                   | 42 ++++++------
 drivers/clk/bcm/clk-kona.c                   | 24 ++++---
 drivers/clk/clk-axi-clkgen.c                 |  5 +-
 drivers/clk/clk-cdce706.c                    | 46 ++++++-------
 drivers/clk/clk-composite.c                  | 27 ++++----
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
 drivers/clk/clk.c                            | 72 +++++++++++----------
 drivers/clk/hisilicon/clk-hi3620.c           | 22 +++----
 drivers/clk/mmp/clk-frac.c                   | 14 ++--
 drivers/clk/mmp/clk-mix.c                    | 17 ++---
 drivers/clk/mvebu/clk-corediv.c              |  7 +-
 drivers/clk/mvebu/clk-cpu.c                  |  9 +--
 drivers/clk/mxs/clk-div.c                    |  4 +-
 drivers/clk/mxs/clk-frac.c                   | 11 ++--
 drivers/clk/mxs/clk-ref.c                    | 11 ++--
 drivers/clk/qcom/clk-pll.c                   | 12 ++--
 drivers/clk/qcom/clk-rcg.c                   | 32 +++++-----
 drivers/clk/qcom/clk-rcg2.c                  | 54 +++++++++-------
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
 drivers/clk/sunxi/clk-factors.c              | 31 +++++----
 drivers/clk/sunxi/clk-sun6i-ar100.c          | 18 ++++--
 drivers/clk/sunxi/clk-sunxi.c                | 19 +++---
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
 include/linux/clk-provider.h                 | 30 ++++-----
 include/linux/clk/ti.h                       | 32 +++++-----
 83 files changed, 927 insertions(+), 679 deletions(-)

-- 
1.9.1

