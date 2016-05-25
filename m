Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:35839 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbcEYTTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 15:19:54 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 8/8] [media] rcar-vin: add Gen2 and Gen3 fallback compatibility strings
Date: Wed, 25 May 2016 21:10:09 +0200
Message-Id: <1464203409-1279-9-git-send-email-niklas.soderlund@ragnatech.se>
In-Reply-To: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

These are present in the soc-camera version of this driver and it's time
to add them to this driver as well.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 520690c..87041db 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -33,6 +33,8 @@ static const struct of_device_id rvin_of_id_table[] = {
 	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
 	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
+	{ .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
+	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
-- 
2.8.2

