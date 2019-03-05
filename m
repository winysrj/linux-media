Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8911C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 14:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1D7020842
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 14:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfCEOC1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 09:02:27 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49566 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726250AbfCEOC1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 09:02:27 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id CD14A634C7B;
        Tue,  5 Mar 2019 16:01:25 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     akinobu.mita@gmail.com, robert.jarzmik@free.fr, hverkuil@xs4all.nl,
        bparrot@ti.com
Subject: [PATCH v1.1 4/4] ti-vpe: Parse local endpoint for properties, not the remote one
Date:   Tue,  5 Mar 2019 16:02:24 +0200
Message-Id: <20190305140224.25889-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190305135602.24199-5-sakari.ailus@linux.intel.com>
References: <20190305135602.24199-5-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

ti-vpe driver parsed the remote endpoints for properties but ignored the
local ones. Fix this by parsing the local endpoint properties instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1:

- Remove of_node_put(remote_ep) as well, the only remaining reference to it.

 drivers/media/platform/ti-vpe/cal.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index fc3c212b96e1..8d075683e448 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1643,8 +1643,7 @@ of_get_next_endpoint(const struct device_node *parent,
 static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 {
 	struct platform_device *pdev = ctx->dev->pdev;
-	struct device_node *ep_node, *port, *remote_ep,
-			*sensor_node, *parent;
+	struct device_node *ep_node, *port, *sensor_node, *parent;
 	struct v4l2_fwnode_endpoint *endpoint;
 	struct v4l2_async_subdev *asd;
 	u32 regval = 0;
@@ -1657,7 +1656,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 
 	ep_node = NULL;
 	port = NULL;
-	remote_ep = NULL;
 	sensor_node = NULL;
 	ret = -EINVAL;
 
@@ -1703,12 +1701,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 	asd->match.fwnode = of_fwnode_handle(sensor_node);
 
-	remote_ep = of_graph_get_remote_endpoint(ep_node);
-	if (!remote_ep) {
-		ctx_dbg(3, ctx, "can't get remote-endpoint\n");
-		goto cleanup_exit;
-	}
-	v4l2_fwnode_endpoint_parse(of_fwnode_handle(remote_ep), endpoint);
+	v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_node), endpoint);
 
 	if (endpoint->bus_type != V4L2_MBUS_CSI2_DPHY) {
 		ctx_err(ctx, "Port:%d sub-device %pOFn is not a CSI2 device\n",
@@ -1759,7 +1752,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	sensor_node = NULL;
 
 cleanup_exit:
-	of_node_put(remote_ep);
 	of_node_put(sensor_node);
 	of_node_put(ep_node);
 	of_node_put(port);
-- 
2.11.0

