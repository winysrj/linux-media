Return-Path: <SRS0=sYKt=QJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C3CC282DC
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 12:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDE6620869
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 12:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfBBMK0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 07:10:26 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49169 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbfBBMKY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2019 07:10:24 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.lab.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gpu7i-0008DE-5a; Sat, 02 Feb 2019 13:10:14 +0100
Received: from mfe by dude02.lab.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gpu7e-0002Ow-5s; Sat, 02 Feb 2019 13:10:10 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     robh+dt@kernel.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 4/5] media: tvp5150: make use of generic connector parsing
Date:   Sat,  2 Feb 2019 13:10:03 +0100
Message-Id: <20190202121004.9014-5-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190202121004.9014-1-m.felsch@pengutronix.de>
References: <20190202121004.9014-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Drop the driver specific connector parsing since we can use the generic
parsing provided by the v4l2-fwnode core.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 75 ++++++++++---------------------------
 1 file changed, 20 insertions(+), 55 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 1f0dd9d3655c..f3a2ad00a40d 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -59,10 +59,9 @@ enum tvp5150_pads_state {
 };
 
 struct tvp5150_connector {
+	struct v4l2_fwnode_connector base;
 	struct media_entity ent;
 	struct media_pad pad;
-	unsigned int port_num;
-	bool is_svideo;
 };
 #endif
 
@@ -1310,7 +1309,8 @@ static int tvp5150_link_setup(struct media_entity *entity,
 	/* check if the svideo connector should be enabled */
 	for (i = 0; i < decoder->connectors_num; i++) {
 		if (remote->entity == &decoder->connectors[i].ent) {
-			is_svideo = decoder->connectors[i].is_svideo;
+			is_svideo =
+			   decoder->connectors[i].base.type == V4L2_CON_SVIDEO;
 			break;
 		}
 	}
@@ -1555,8 +1555,9 @@ static int tvp5150_registered(struct v4l2_subdev *sd)
 	for (i = 0; i < decoder->connectors_num; i++) {
 		struct media_entity *con = &decoder->connectors[i].ent;
 		struct media_pad *pad = &decoder->connectors[i].pad;
-		unsigned int port = decoder->connectors[i].port_num;
-		bool is_svideo = decoder->connectors[i].is_svideo;
+		unsigned int port = decoder->connectors[i].base.remote_port;
+		bool is_svideo =
+			decoder->connectors[i].base.type == V4L2_CON_SVIDEO;
 		int flags = i ? 0 : MEDIA_LNK_FL_ENABLED;
 
 		pad->flags = MEDIA_PAD_FL_SOURCE;
@@ -1821,8 +1822,6 @@ static int tvp5150_init(struct i2c_client *c)
 static int tvp5150_add_of_connectors(struct tvp5150 *decoder)
 {
 	struct device *dev = decoder->sd.dev;
-	struct device_node *rp;
-	struct of_endpoint ep;
 	struct tvp5150_connector *connectors;
 	unsigned int connectors_num = decoder->connectors_num;
 	int i, ret;
@@ -1834,22 +1833,15 @@ static int tvp5150_add_of_connectors(struct tvp5150 *decoder)
 		return -ENOMEM;
 
 	for (i = 0; i < connectors_num; i++) {
-		rp = of_graph_get_remote_port_parent(decoder->endpoints[i]);
-		of_graph_parse_endpoint(decoder->endpoints[i], &ep);
-		connectors[i].port_num = ep.port;
-		connectors[i].is_svideo = !!of_device_is_compatible(rp,
-							    "svideo-connector");
-
-		if (connectors[i].is_svideo)
-			connectors[i].ent.function = MEDIA_ENT_F_CONN_SVIDEO;
-		else
-			connectors[i].ent.function = MEDIA_ENT_F_CONN_COMPOSITE;
+		struct v4l2_fwnode_connector *c = &connectors[i].base;
+
+		ret = v4l2_fwnode_parse_connector(
+				   of_fwnode_handle(decoder->endpoints[i]), c);
 
 		connectors[i].ent.flags = MEDIA_ENT_FL_CONNECTOR;
-		ret = of_property_read_string(rp, "label",
-					      &connectors[i].ent.name);
-		if (ret < 0)
-			return ret;
+		connectors[i].ent.function = c->type == V4L2_CON_SVIDEO ?
+			MEDIA_ENT_F_CONN_SVIDEO : MEDIA_ENT_F_CONN_COMPOSITE;
+		connectors[i].ent.name = c->label;
 	}
 
 	decoder->connectors = connectors;
@@ -1890,41 +1882,11 @@ static int tvp5150_mc_init(struct v4l2_subdev *sd)
 	return ret;
 }
 
-static bool tvp5150_of_valid_input(struct device_node *endpoint,
-				unsigned int port, unsigned int id)
-{
-	struct device_node *rp = of_graph_get_remote_port_parent(endpoint);
-	const char *input;
-	int ret;
-
-	/* perform some basic checks needed for later mc_init */
-	switch (port) {
-	case TVP5150_PAD_AIP1A:
-		/* svideo must be connected to endpoint@1  */
-		ret = id ? of_device_is_compatible(rp, "svideo-connector") :
-			   of_device_is_compatible(rp,
-						   "composite-video-connector");
-		if (!ret)
-			return false;
-		break;
-	case TVP5150_PAD_AIP1B:
-		ret = of_device_is_compatible(rp, "composite-video-connector");
-		if (!ret)
-			return false;
-		break;
-	}
-
-	ret = of_property_read_string(rp, "label", &input);
-	if (ret < 0)
-		return false;
-
-	return true;
-}
-
 static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 {
 	struct device *dev = decoder->sd.dev;
 	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
+	struct v4l2_fwnode_connector c;
 	struct device_node *ep_np;
 	unsigned int flags;
 	int ret, i = 0, in = 0;
@@ -1953,10 +1915,13 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 			/* fall through */
 		case TVP5150_PAD_AIP1A:
 		case TVP5150_PAD_AIP1B:
-			if (!tvp5150_of_valid_input(ep_np, ep.port, ep.id)) {
+			ret = v4l2_fwnode_parse_connector(
+						   of_fwnode_handle(ep_np), &c);
+			if (c.type != V4L2_CON_COMPOSITE &&
+			    c.type != V4L2_CON_SVIDEO) {
 				dev_err(dev,
-					"Invalid endpoint %pOF on port %d\n",
-					ep.local_node, ep.port);
+					"Invalid endpoint %d on port %d\n",
+					c.remote_id, c.remote_port);
 				ret = -EINVAL;
 				goto err;
 			}
-- 
2.20.1

