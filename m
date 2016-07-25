Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34549 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbcGYTTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 15:19:38 -0400
Received: by mail-lf0-f51.google.com with SMTP id l69so135191826lfg.1
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2016 12:19:37 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH] rcar-vin: add R-Car gen2 fallback compatibility string
Date: Mon, 25 Jul 2016 22:19:33 +0300
Message-ID: <2381051.RUpesOs1q9@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Such fallback string is present in the 'soc_camera' version of the R-Car VIN
driver, so need  to add it here as well...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against the 'media_tree.git' repo's 'master' branch.
This patch conflicts with Niklas Soderlund's former patch "[media] rcar-vin:
add  Gen2 and Gen3 fallback compatibility strings"), I got his consent about
splitting the gen2 part  of that patch to a separate patch...

 drivers/media/platform/rcar-vin/rcar-core.c |    1 +
 1 file changed, 1 insertion(+)

Index: media_tree/drivers/media/platform/rcar-vin/rcar-core.c
===================================================================
--- media_tree.orig/drivers/media/platform/rcar-vin/rcar-core.c
+++ media_tree/drivers/media/platform/rcar-vin/rcar-core.c
@@ -209,6 +209,7 @@ static const struct of_device_id rvin_of
 	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
 	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
+	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);

