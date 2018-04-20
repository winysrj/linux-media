Return-path: <linux-media-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:36030 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755060AbeDTN3A (ORCPT
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
Subject: [PATCH 4/8] sh_eth: Change platform check to CONFIG_ARCH_RENESAS
Date: Fri, 20 Apr 2018 15:28:30 +0200
Message-Id: <1524230914-10175-5-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS")
is CONFIG_ARCH_RENESAS a more appropriate platform check than the legacy
CONFIG_ARCH_SHMOBILE, hence use the former.

Renesas SuperH SH-Mobile SoCs are still covered by the CONFIG_CPU_SH4
check.

This will allow to drop ARCH_SHMOBILE on ARM and ARM64 in the near
future.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/renesas/sh_eth.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.h b/drivers/net/ethernet/renesas/sh_eth.h
index a5b792ce2ae7d046..1bf930d4a1e52c18 100644
--- a/drivers/net/ethernet/renesas/sh_eth.h
+++ b/drivers/net/ethernet/renesas/sh_eth.h
@@ -163,7 +163,7 @@ enum {
 };
 
 /* Driver's parameters */
-#if defined(CONFIG_CPU_SH4) || defined(CONFIG_ARCH_SHMOBILE)
+#if defined(CONFIG_CPU_SH4) || defined(CONFIG_ARCH_RENESAS)
 #define SH_ETH_RX_ALIGN		32
 #else
 #define SH_ETH_RX_ALIGN		2
-- 
2.7.4
