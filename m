Return-path: <linux-media-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:60500 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbeBZSJM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 13:09:12 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] media: platform: Drop OF dependency of VIDEO_RENESAS_VSP1
Date: Mon, 26 Feb 2018 19:09:10 +0100
Message-Id: <1519668550-26082-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDEO_RENESAS_VSP1 depends on ARCH_RENESAS && OF.
As ARCH_RENESAS implies OF, the latter can be dropped.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 614fbef08ddcabb0..2b8b1ad0edd9eb31 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -448,7 +448,7 @@ config VIDEO_RENESAS_FCP
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
-	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
+	depends on ARCH_RENESAS || COMPILE_TEST
 	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_VMALLOC
-- 
2.7.4
