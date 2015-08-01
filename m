Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59708 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbbHAJWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2015 05:22:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 1/4] v4l: atmel-isi: Simplify error handling during DT parsing
Date: Sat,  1 Aug 2015 12:22:53 +0300
Message-Id: <1438420976-7899-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put the endpoint DT node earlier to avoid the need for goto statements
to a cleanup code block in case of errors.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 90701726a06a..9c900d9569e0 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -891,9 +891,10 @@ static int atmel_isi_probe_dt(struct atmel_isi *isi,
 	}
 
 	err = v4l2_of_parse_endpoint(np, &ep);
+	of_node_put(np);
 	if (err) {
 		dev_err(&pdev->dev, "Could not parse the endpoint\n");
-		goto err_probe_dt;
+		return err;
 	}
 
 	switch (ep.bus.parallel.bus_width) {
@@ -907,14 +908,10 @@ static int atmel_isi_probe_dt(struct atmel_isi *isi,
 	default:
 		dev_err(&pdev->dev, "Unsupported bus width: %d\n",
 				ep.bus.parallel.bus_width);
-		err = -EINVAL;
-		goto err_probe_dt;
+		return -EINVAL;
 	}
 
-err_probe_dt:
-	of_node_put(np);
-
-	return err;
+	return 0;
 }
 
 static int atmel_isi_probe(struct platform_device *pdev)
-- 
2.3.6

