Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:58252 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754257AbeFLRXf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 13:23:35 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Niklas Soderlund <niklas.soderlund+renesas@ragnatech.se>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 1/2] media: stm32-dcmi: drop unnecessary while(1) loop
Date: Tue, 12 Jun 2018 19:22:17 +0200
Message-Id: <1528824138-19089-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The while(1) is effectively useless as all possible paths within it
return thus there is no way to loop.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

This is not actually fixing any bug - the while(1){ } will not hurt here
it is though simply unnecessary. Found during code review.

The diff output is not very readable - essentially only the outer
while(1){ } was removed.

Patch was compile tested with: x86_64_defconfig, MEDIA_SUPPORT=y
MEDIA_CAMERA_SUPPORT=y, V4L_PLATFORM_DRIVERS=y, OF=y, COMPILE_TEST=y
CONFIG_VIDEO_STM32_DCMI=y
(There are a number of sparse warnings - not related to the changes though)

Patch is against 4.17.0 (localversion-next is next-20180608)

 drivers/media/platform/stm32/stm32-dcmi.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 2e1933d..70b81d2 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1605,23 +1605,21 @@ static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
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
-		dcmi->entity.node = remote;
-		dcmi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		dcmi->entity.asd.match.fwnode = of_fwnode_handle(remote);
-		return 0;
+	remote = of_graph_get_remote_port_parent(ep);
+	if (!remote) {
+		of_node_put(ep);
+		return -EINVAL;
 	}
+
+	/* Remote node to connect */
+	dcmi->entity.node = remote;
+	dcmi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+	dcmi->entity.asd.match.fwnode = of_fwnode_handle(remote);
+	return 0;
 }
 
 static int dcmi_graph_init(struct stm32_dcmi *dcmi)
-- 
2.1.4
