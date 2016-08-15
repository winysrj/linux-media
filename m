Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:54338 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbcHOPHS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 11:07:18 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	sergei.shtylyov@cogentembedded.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 05/10] [media] rcar-vin: return correct error from platform_get_irq()
Date: Mon, 15 Aug 2016 17:06:30 +0200
Message-Id: <20160815150635.22637-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a error from the original driver where the wrong error code is
returned if the driver fails to get a IRQ number from
platform_get_irq().

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index a1eb26b..3941134 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -282,8 +282,8 @@ static int rcar_vin_probe(struct platform_device *pdev)
 		return PTR_ERR(vin->base);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
-		return ret;
+	if (irq < 0)
+		return irq;
 
 	ret = rvin_dma_probe(vin, irq);
 	if (ret)
-- 
2.9.2

