Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:56234 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755074AbeDTN3B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:29:01 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/8] arm: shmobile: Change platform dependency to ARCH_RENESAS
Date: Fri, 20 Apr 2018 15:28:27 +0200
Message-Id: <1524230914-10175-2-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS")
is ARCH_RENESAS a more appropriate platform dependency than the legacy
ARCH_SHMOBILE, hence use the former.

This will allow to drop ARCH_SHMOBILE on ARM in the near future.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/Kconfig  | 2 +-
 arch/arm/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a7f8e7f4b88fdd03..2d34c0a44877e85b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1467,7 +1467,7 @@ config ARM_PSCI
 config ARCH_NR_GPIO
 	int
 	default 2048 if ARCH_SOCFPGA
-	default 1024 if ARCH_BRCMSTB || ARCH_SHMOBILE || ARCH_TEGRA || \
+	default 1024 if ARCH_BRCMSTB || ARCH_RENESAS || ARCH_TEGRA || \
 		ARCH_ZYNQ
 	default 512 if ARCH_EXYNOS || ARCH_KEYSTONE || SOC_OMAP5 || \
 		SOC_DRA7XX || ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5PV210
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index e4e537f27339f7a1..a92f5a876d96839d 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -212,7 +212,7 @@ machine-$(CONFIG_ARCH_S3C24XX)		+= s3c24xx
 machine-$(CONFIG_ARCH_S3C64XX)		+= s3c64xx
 machine-$(CONFIG_ARCH_S5PV210)		+= s5pv210
 machine-$(CONFIG_ARCH_SA1100)		+= sa1100
-machine-$(CONFIG_ARCH_SHMOBILE) 	+= shmobile
+machine-$(CONFIG_ARCH_RENESAS)	 	+= shmobile
 machine-$(CONFIG_ARCH_SIRF)		+= prima2
 machine-$(CONFIG_ARCH_SOCFPGA)		+= socfpga
 machine-$(CONFIG_ARCH_STI)		+= sti
-- 
2.7.4
