Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:56020 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbcGSOXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:15 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 16/16] [media] rcar-vin: add Gen2 and Gen3 fallback compatibility strings
Date: Tue, 19 Jul 2016 16:21:07 +0200
Message-Id: <20160719142107.22358-17-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are present in the soc-camera version of this driver and it's time
to add them to this driver as well.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index eab3009..e02ce48 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -343,6 +343,8 @@ static const struct of_device_id rvin_of_id_table[] = {
 	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
 	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
+	{ .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
+	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
-- 
2.9.0

