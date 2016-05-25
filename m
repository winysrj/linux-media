Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:35836 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbcEYTTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 15:19:53 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 7/8] [media] rcar-vin: enable Gen3
Date: Wed, 25 May 2016 21:10:08 +0200
Message-Id: <1464203409-1279-8-git-send-email-niklas.soderlund@ragnatech.se>
In-Reply-To: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/Kconfig     | 2 +-
 drivers/media/platform/rcar-vin/rcar-core.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index b2ff2d4..ca3ea91 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -5,7 +5,7 @@ config VIDEO_RCAR_VIN
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Support for Renesas R-Car Video Input (VIN) driver.
-	  Supports R-Car Gen2 SoCs.
+	  Supports R-Car Gen2 and Gen3 SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rcar-vin.
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index d901ad0..520690c 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -26,6 +26,7 @@
 #include "rcar-vin.h"
 
 static const struct of_device_id rvin_of_id_table[] = {
+	{ .compatible = "renesas,vin-r8a7795", .data = (void *)RCAR_GEN3 },
 	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
-- 
2.8.2

