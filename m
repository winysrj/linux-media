Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:62835 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751453AbdHGCNy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Aug 2017 22:13:54 -0400
Message-ID: <871soojfl3.wl%kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH][resend] media: ti-vpe: cal: use of_graph_get_remote_endpoint()
To: Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
Date: Mon, 7 Aug 2017 02:13:49 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Now, we can use of_graph_get_remote_endpoint(). Let's use it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 drivers/media/platform/ti-vpe/cal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 177faa3..0c7ddf8 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1702,7 +1702,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 	asd->match.fwnode.fwnode = of_fwnode_handle(sensor_node);
 
-	remote_ep = of_parse_phandle(ep_node, "remote-endpoint", 0);
+	remote_ep = of_graph_get_remote_endpoint(ep_node);
 	if (!remote_ep) {
 		ctx_dbg(3, ctx, "can't get remote-endpoint\n");
 		goto cleanup_exit;
-- 
1.9.1
