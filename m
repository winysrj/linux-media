Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34324 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754346AbdLNTJY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:24 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH/RFC v2 14/15] adv748x: csi2: add get_routing support
Date: Thu, 14 Dec 2017 20:08:34 +0100
Message-Id: <20171214190835.7672-15-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To support multiplexed streams the internal routing between the
adv748x sink pad and its source pad needs to be described.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 291b35bef49d41fb..dbefb53f5b8c414d 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -262,10 +262,32 @@ static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
 	return 0;
 }
 
+static int adv748x_csi2_get_routing(struct v4l2_subdev *subdev,
+				    struct v4l2_subdev_routing *routing)
+{
+	struct v4l2_subdev_route *r = routing->routes;
+
+	if (routing->num_routes < 1) {
+		routing->num_routes = 1;
+		return -ENOSPC;
+	}
+
+	routing->num_routes = 1;
+
+	r->sink_pad = ADV748X_CSI2_SINK;
+	r->sink_stream = 0;
+	r->source_pad = ADV748X_CSI2_SOURCE;
+	r->source_stream = 0;
+	r->flags = V4L2_SUBDEV_ROUTE_FL_ACTIVE | V4L2_SUBDEV_ROUTE_FL_IMMUTABLE;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
 	.get_fmt = adv748x_csi2_get_format,
 	.set_fmt = adv748x_csi2_set_format,
 	.get_frame_desc = adv748x_csi2_get_frame_desc,
+	.get_routing = adv748x_csi2_get_routing,
 	.s_stream = adv748x_csi2_s_stream,
 };
 
-- 
2.15.1
