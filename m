Return-path: <linux-media-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:43574 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388007AbeGKO2J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 10:28:09 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] v4l: rcar_fdp1: Enable compilation on Gen2 platforms
Date: Wed, 11 Jul 2018 16:23:32 +0200
Message-Id: <20180711142332.4324-1-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Commit 1d3897143815 ("[media] v4l: rcar_fdp1: add FCP dependency") fixed
a compilation breakage when the optional VIDEO_RENESAS_FCP dependency is
compiled as a module while the rcar_fdp1 driver is built in. As a side
effect it disabled compilation on Gen2 by disallowing the valid
combination ARCH_RENESAS && !VIDEO_RENESAS_FCP. Fix it by handling the
dependency the same way the vsp1 driver did in commit 199946731fa4
("[media] vsp1: clarify FCP dependency").

Fixes: 1d3897143815 ("[media] v4l: rcar_fdp1: add FCP dependency")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 210b44a457eb66f0..84cb97eccb2a52bc 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -385,7 +385,7 @@ config VIDEO_RENESAS_FDP1
 	tristate "Renesas Fine Display Processor"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_RENESAS || COMPILE_TEST
-	depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
+	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
-- 
2.17.1
