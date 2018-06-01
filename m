Return-path: <linux-media-owner@vger.kernel.org>
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:53545 "EHLO
        mail.osadl.at" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbeFAMsl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 08:48:41 -0400
From: Nicholas Mc Guire <hofrat@opentech.at>
To: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] media: atmel-isi: drop unnecessary while loop
Date: Fri,  1 Jun 2018 12:46:14 +0000
Message-Id: <1527857174-24616-1-git-send-email-hofrat@opentech.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nicholas Mc Guire <hofrat@osadl.org>

As there is no way this can loop it actually makes no sense to have
a while(1){} around the body - all three possible paths end in a return
statement. 

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: commit c1d82b895380 "[media] atmel-isi: move out of soc_camera to atmel"
---

The diff output is unfortunately not that readable - essentially only
the outer while(1){ } was removed. 

Patch was compile tested with: x86_64_defconfig + CONFIG_MEDIA_SUPPORT=y
MEDIA_CAMERA_SUPPORT=y, CONFIG_MEDIA_CONTROLLER=y, V4L_PLATFORM_DRIVERS=y
OF=y, CONFIG_COMPILE_TEST=y, CONFIG_VIDEO_ATMEL_ISI=y

Compile testing atmel-isi.c shows some sparse warnings. Seems to be due to
sizeof operator being applied to a union (not related to the function being
changed though).

Patch is against 4.17-rc7 (localversion-next is next-20180531)

 drivers/media/platform/atmel/atmel-isi.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index e5be21a..85fc7b9 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1106,23 +1106,21 @@ static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
 	struct device_node *ep = NULL;
 	struct device_node *remote;
 
-	while (1) {
-		ep = of_graph_get_next_endpoint(node, ep);
-		if (!ep)
-			return -EINVAL;
-
-		remote = of_graph_get_remote_port_parent(ep);
-		if (!remote) {
-			of_node_put(ep);
-			return -EINVAL;
-		}
+	ep = of_graph_get_next_endpoint(node, ep);
+	if (!ep)
+		return -EINVAL;
 
-		/* Remote node to connect */
-		isi->entity.node = remote;
-		isi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		isi->entity.asd.match.fwnode = of_fwnode_handle(remote);
-		return 0;
+	remote = of_graph_get_remote_port_parent(ep);
+	if (!remote) {
+		of_node_put(ep);
+		return -EINVAL;
 	}
+
+	/* Remote node to connect */
+	isi->entity.node = remote;
+	isi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+	isi->entity.asd.match.fwnode = of_fwnode_handle(remote);
+	return 0;
 }
 
 static int isi_graph_init(struct atmel_isi *isi)
-- 
2.1.4
