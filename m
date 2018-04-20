Return-path: <linux-media-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:35932 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755043AbeDTN3A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:29:00 -0400
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
Subject: [PATCH 6/8] ASoC: sh: Update menu title and platform dependency
Date: Fri, 20 Apr 2018 15:28:32 +0200
Message-Id: <1524230914-10175-7-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the menu title to refer to "Renesas SoCs" instead of "SuperH", as
both SuperH and ARM SoCs are supported.

Since commit 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS")
is ARCH_RENESAS a more appropriate platform dependency for Renesas ARM
SoCs than the legacy ARCH_SHMOBILE, hence use the former.
Renesas SuperH SH-Mobile SoCs are still covered by the SUPERH
dependency.

This will allow to drop ARCH_SHMOBILE on ARM and ARM64 in the near
future.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 sound/soc/sh/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/Kconfig b/sound/soc/sh/Kconfig
index 1aa5cd77ca24a06f..c1b7fb91e3063f2b 100644
--- a/sound/soc/sh/Kconfig
+++ b/sound/soc/sh/Kconfig
@@ -1,5 +1,5 @@
-menu "SoC Audio support for SuperH"
-	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
+menu "SoC Audio support for Renesas SoCs"
+	depends on SUPERH || ARCH_RENESAS || COMPILE_TEST
 
 config SND_SOC_PCM_SH7760
 	tristate "SoC Audio support for Renesas SH7760"
-- 
2.7.4
