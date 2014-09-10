Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58766 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaIJK6e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 06:58:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Grant Likely <grant.likely@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/8] [media] soc_camera: Do not decrement endpoint node refcount in the loop
Date: Wed, 10 Sep 2014 12:58:21 +0200
Message-Id: <1410346708-5125-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1410346708-5125-1-git-send-email-p.zabel@pengutronix.de>
References: <1410346708-5125-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for a following patch, stop decrementing the endpoint node
refcount in the loop. This temporarily leaks a reference to the endpoint node,
which will be fixed by having of_graph_get_next_endpoint decrement the refcount
of its prev argument instead.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/soc_camera/soc_camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f4308fe..f752489 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1696,11 +1696,11 @@ static void scan_of_host(struct soc_camera_host *ici)
 		if (!i)
 			soc_of_bind(ici, epn, ren->parent);
 
-		of_node_put(epn);
 		of_node_put(ren);
 
 		if (i) {
 			dev_err(dev, "multiple subdevices aren't supported yet!\n");
+			of_node_put(epn);
 			break;
 		}
 	}
-- 
2.1.0

