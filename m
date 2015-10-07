Return-path: <linux-media-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:55439 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbbJGKjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2015 06:39:40 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 1/2] [media] rcar_vin: Remove obsolete r8a779x-vin platform_device_id entries
Date: Wed,  7 Oct 2015 12:39:35 +0200
Message-Id: <1444214376-26931-2-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1444214376-26931-1-git-send-email-geert+renesas@glider.be>
References: <1444214376-26931-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit a483dcbfa21f919c ("ARM: shmobile: lager: Remove legacy
board support"), R-Car Gen2 SoCs are only supported in generic DT-only
ARM multi-platform builds.  The driver doesn't need to match platform
devices by name anymore, hence remove the corresponding
platform_device_id entry.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
---
v2:
  - Add Acked-by.
---
 drivers/media/platform/soc_camera/rcar_vin.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 71dd71c0bd1f..4069587ae8b6 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1846,8 +1846,6 @@ MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
 #endif
 
 static struct platform_device_id rcar_vin_id_table[] = {
-	{ "r8a7791-vin",  RCAR_GEN2 },
-	{ "r8a7790-vin",  RCAR_GEN2 },
 	{ "r8a7779-vin",  RCAR_H1 },
 	{ "r8a7778-vin",  RCAR_M1 },
 	{ "uPD35004-vin", RCAR_E1 },
-- 
1.9.1

