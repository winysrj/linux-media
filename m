Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:53915 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbcKRQRJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 11:17:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [media] v4l: rcar_fdp1: add FCP dependency
Date: Fri, 18 Nov 2016 17:16:05 +0100
Message-Id: <20161118161621.798004-2-arnd@arndb.de>
In-Reply-To: <20161118161621.798004-1-arnd@arndb.de>
References: <20161118161621.798004-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/rcar_fdp1.o: In function `fdp1_pm_runtime_resume':
rcar_fdp1.c:(.text.fdp1_pm_runtime_resume+0x78): undefined reference to `rcar_fcp_enable'
drivers/media/platform/rcar_fdp1.o: In function `fdp1_pm_runtime_suspend':
rcar_fdp1.c:(.text.fdp1_pm_runtime_suspend+0x14): undefined reference to `rcar_fcp_disable'
drivers/media/platform/rcar_fdp1.o: In function `fdp1_probe':
rcar_fdp1.c:(.text.fdp1_probe+0x15c): undefined reference to `rcar_fcp_get'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 3c5a0b6b23a9..cd0cab6e0e31 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -311,6 +311,7 @@ config VIDEO_RENESAS_FDP1
 	tristate "Renesas Fine Display Processor"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
-- 
2.9.0

