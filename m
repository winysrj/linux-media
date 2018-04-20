Return-path: <linux-media-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:38444 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755019AbeDTN27 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:28:59 -0400
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
Subject: [PATCH/RFC 7/8] ARM: shmobile: Remove the ARCH_SHMOBILE Kconfig symbol
Date: Fri, 20 Apr 2018 15:28:33 +0200
Message-Id: <1524230914-10175-8-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All drivers for Renesas ARM SoCs have gained proper ARCH_RENESAS
platform dependencies.  Hence finish the conversion from ARCH_SHMOBILE
to ARCH_RENESAS for Renesas 32-bit ARM SoCs, as started by commit
9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This depends on the previous patches in this series, hence the RFC.

JFTR, after this, the following symbols for drivers supporting only
Renesas SuperH "SH-Mobile" SoCs can no longer be selected:
  - CONFIG_KEYBOARD_SH_KEYSC,
  - CONFIG_VIDEO_SH_VOU,
  - CONFIG_VIDEO_SH_MOBILE_CEU,
  - CONFIG_DRM_SHMOBILE[*],
  - CONFIG_FB_SH_MOBILE_MERAM.
(changes for a shmobile_defconfig .config)

[*] CONFIG_DRM_SHMOBILE has a dependency on ARM, but it was never wired
    up.  From the use of sh_mobile_meram, I guess it was meant for
    SH-Mobile AP4 on Mackerel or AP4EVB, which are long gone.
    So the only remaining upstream platforms that could make use of it
    are legacy SuperH SH-Mobile SoCs?
---
 arch/arm/mach-shmobile/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 96672da02f5f17b9..d892c5b52b6f5627 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -1,6 +1,3 @@
-config ARCH_SHMOBILE
-	bool
-
 config PM_RMOBILE
 	bool
 	select PM
@@ -30,7 +27,6 @@ menuconfig ARCH_RENESAS
 	bool "Renesas ARM SoCs"
 	depends on ARCH_MULTI_V7 && MMU
 	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
-	select ARCH_SHMOBILE
 	select ARM_GIC
 	select GPIOLIB
 	select HAVE_ARM_SCU if SMP
-- 
2.7.4
