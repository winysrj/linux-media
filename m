Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49371 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbbDFUS7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2015 16:18:59 -0400
Message-ID: <5522EA2F.1090003@codeaurora.org>
Date: Mon, 06 Apr 2015 13:18:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 05/14] clkdev: use clk_hw internally
References: <20150403171149.GC13898@n2100.arm.linux.org.uk> <E1Ye59E-0001BB-7z@rmk-PC.arm.linux.org.uk>
In-Reply-To: <E1Ye59E-0001BB-7z@rmk-PC.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/15 10:12, Russell King wrote:
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Some commit text would be nice for us 5 years from now when we wonder
why this patch was applied.

I suspect the commit text would go like this:

clk_add_alias() calls clk_get() followed by clk_put() but in between
those two calls it saves away the struct clk pointer to a clk_lookup
structure. This leaves the 'clk' member of the clk_lookup pointing at
freed memory on configurations where CONFIG_COMMON_CLK=y. This is a
problem because clk_get_sys() will eventually try to dereference the
freed pointer by calling __clk_get_hw() on it. Fix this by saving away
the struct clk_hw pointer instead of the struct clk pointer so that when
we try to create a per-user struct clk in clk_get_sys() we don't
dereference a junk pointer.

Now the question is does any of this matter for the 4.0 release. From
what I can tell, the answer is no.

$ git grep 'clk_add_alias' v4.0-rc6
v4.0-rc6:arch/arm/mach-davinci/da850.c:         clk_add_alias("async", da850_cpufreq_device.name,
v4.0-rc6:arch/arm/mach-omap1/board-nokia770.c:  clk_add_alias("hwa_sys_ck", NULL, "bclk", NULL);
v4.0-rc6:arch/arm/mach-pxa/eseries.c:   clk_add_alias("CLK_CK48M", e740_t7l66xb_device.name,
v4.0-rc6:arch/arm/mach-pxa/eseries.c:   clk_add_alias("CLK_CK3P6MI", e750_tc6393xb_device.name,
v4.0-rc6:arch/arm/mach-pxa/eseries.c:   clk_add_alias("CLK_CK3P6MI", e800_tc6393xb_device.name,
v4.0-rc6:arch/arm/mach-pxa/lubbock.c:   clk_add_alias("SA1111_CLK", NULL, "GPIO11_CLK", NULL);
v4.0-rc6:arch/arm/mach-pxa/tosa.c:      clk_add_alias("CLK_CK3P6MI", tc6393xb_device.name, "GPIO11_CLK", NULL);
v4.0-rc6:arch/mips/alchemy/common/clock.c:                      clk_add_alias(t->alias, NULL, t->base, NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("wdt", NULL, "ahb", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("uart", NULL, "ahb", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("wdt", NULL, "ahb", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("uart", NULL, "ahb", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("wdt", NULL, "ahb", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("uart", NULL, "ahb", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("wdt", NULL, "ahb", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("uart", NULL, "ref", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("wdt", NULL, "ref", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("uart", NULL, "ref", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("wdt", NULL, "ref", NULL);
v4.0-rc6:arch/mips/ath79/clock.c:       clk_add_alias("uart", NULL, "ref", NULL);
v4.0-rc6:arch/sh/kernel/cpu/clock-cpg.c:        clk_add_alias("fck", "sh-tmu-sh3.0", "peripheral_clk", NULL);
v4.0-rc6:arch/sh/kernel/cpu/clock-cpg.c:        clk_add_alias("fck", "sh-tmu.0", "peripheral_clk", NULL);
v4.0-rc6:arch/sh/kernel/cpu/clock-cpg.c:        clk_add_alias("fck", "sh-tmu.1", "peripheral_clk", NULL);
v4.0-rc6:arch/sh/kernel/cpu/clock-cpg.c:        clk_add_alias("fck", "sh-tmu.2", "peripheral_clk", NULL);
v4.0-rc6:arch/sh/kernel/cpu/clock-cpg.c:        clk_add_alias("fck", "sh-mtu2", "peripheral_clk", NULL);
v4.0-rc6:arch/sh/kernel/cpu/clock-cpg.c:        clk_add_alias("fck", "sh-cmt-16.0", "peripheral_clk", NULL);
v4.0-rc6:arch/sh/kernel/cpu/clock-cpg.c:        clk_add_alias("fck", "sh-cmt-32.0", "peripheral_clk", NULL);
v4.0-rc6:arch/sh/kernel/cpu/clock-cpg.c:        clk_add_alias("sci_ick", NULL, "peripheral_clk", NULL);

All of these architectures and platforms have CONFIG_COMMON_CLK=n, so
there doesn't seem to be any regression that these patches are fixing.
That isn't to say the patches are bad, just that they aren't urgent for
the upcoming release.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

