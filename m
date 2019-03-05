Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383EAC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 139B7208E4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbfCESwH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:52:07 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:60353 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbfCESwG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:52:06 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D753720000B;
        Tue,  5 Mar 2019 18:52:03 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 26/31] adv748x: csi2: add internal routing configuration
Date:   Tue,  5 Mar 2019 19:51:45 +0100
Message-Id: <20190305185150.20776-27-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Add support to get and set the internal routing between the adv748x
CSI-2 transmitters sink pad and its multiplexed source pad. This routing
includes which stream of the multiplexed pad to use, allowing the user
to select which CSI-2 virtual channel to use when transmitting the
stream.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 65 ++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index d8f7cbee86e7..13454af72c6e 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -14,6 +14,8 @@
 
 #include "adv748x.h"
 
+#define ADV748X_CSI2_ROUTES_MAX 4
+
 struct adv748x_csi2_format {
 	unsigned int code;
 	unsigned int datatype;
@@ -253,10 +255,73 @@ static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
 	return 0;
 }
 
+static int adv748x_csi2_get_routing(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_krouting *routing)
+{
+	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
+	struct v4l2_subdev_route *r = routing->routes;
+	unsigned int vc;
+
+	if (routing->num_routes < ADV748X_CSI2_ROUTES_MAX) {
+		routing->num_routes = ADV748X_CSI2_ROUTES_MAX;
+		return -ENOSPC;
+	}
+
+	routing->num_routes = ADV748X_CSI2_ROUTES_MAX;
+
+	for (vc = 0; vc < ADV748X_CSI2_ROUTES_MAX; vc++) {
+		r->sink_pad = ADV748X_CSI2_SINK;
+		r->sink_stream = 0;
+		r->source_pad = ADV748X_CSI2_SOURCE;
+		r->source_stream = vc;
+		r->flags = vc == tx->vc ? V4L2_SUBDEV_ROUTE_FL_ACTIVE : 0;
+		r++;
+	}
+
+	return 0;
+}
+
+static int adv748x_csi2_set_routing(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_krouting *routing)
+{
+	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
+	struct v4l2_subdev_route *r = routing->routes;
+	unsigned int i;
+	int vc = -1;
+
+	if (routing->num_routes > ADV748X_CSI2_ROUTES_MAX)
+		return -ENOSPC;
+
+	for (i = 0; i < routing->num_routes; i++) {
+		if (r->sink_pad != ADV748X_CSI2_SINK ||
+		    r->sink_stream != 0 ||
+		    r->source_pad != ADV748X_CSI2_SOURCE ||
+		    r->source_stream >= ADV748X_CSI2_ROUTES_MAX)
+			return -EINVAL;
+
+		if (r->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE) {
+			if (vc != -1)
+				return -EMLINK;
+
+			vc = r->source_stream;
+		}
+		r++;
+	}
+
+	if (vc != -1)
+		tx->vc = vc;
+
+	adv748x_csi2_set_virtual_channel(tx, tx->vc);
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
 	.get_fmt = adv748x_csi2_get_format,
 	.set_fmt = adv748x_csi2_set_format,
 	.get_frame_desc = adv748x_csi2_get_frame_desc,
+	.get_routing = adv748x_csi2_get_routing,
+	.set_routing = adv748x_csi2_set_routing,
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.20.1

