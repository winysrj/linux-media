Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34428 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754356AbdLNTJZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:25 -0500
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
Subject: [PATCH/RFC v2 15/15] adv748x: afe: add routing support
Date: Thu, 14 Dec 2017 20:08:35 +0100
Message-Id: <20171214190835.7672-16-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv748x afe have eight analog sink pads, currently one of them is
chosen to be the active route based on device tree configuration. Whit
the new routeing API it's possible to control which of the eight sink
pads are routed to the source pad.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-afe.c | 66 +++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
index 5188178588c9067d..5dda85c707f6efd7 100644
--- a/drivers/media/i2c/adv748x/adv748x-afe.c
+++ b/drivers/media/i2c/adv748x/adv748x-afe.c
@@ -43,6 +43,9 @@
 #define ADV748X_AFE_STD_PAL_SECAM			0xe
 #define ADV748X_AFE_STD_PAL_SECAM_PED			0xf
 
+#define ADV748X_AFE_ROUTES_MAX ((ADV748X_AFE_SINK_AIN7 - \
+				ADV748X_AFE_SINK_AIN0) + 1)
+
 static int adv748x_afe_read_ro_map(struct adv748x_state *state, u8 reg)
 {
 	int ret;
@@ -386,10 +389,73 @@ static int adv748x_afe_set_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+
+static int adv748x_afe_get_routing(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_routing *routing)
+{
+	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
+	struct v4l2_subdev_route *r = routing->routes;
+	unsigned int i;
+
+	/* There are one possible route from each sink */
+	if (routing->num_routes < ADV748X_AFE_ROUTES_MAX) {
+		routing->num_routes = ADV748X_AFE_ROUTES_MAX;
+		return -ENOSPC;
+	}
+
+	routing->num_routes = ADV748X_AFE_ROUTES_MAX;
+
+	for (i = ADV748X_AFE_SINK_AIN0; i <= ADV748X_AFE_SINK_AIN7; i++) {
+		r->sink_pad = i;
+		r->sink_stream = 0;
+		r->source_pad = ADV748X_AFE_SOURCE;
+		r->source_stream = 0;
+		r->flags = afe->input == i ? V4L2_SUBDEV_ROUTE_FL_ACTIVE : 0;
+		r++;
+	}
+
+	return 0;
+}
+
+static int adv748x_afe_set_routing(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_routing *routing)
+{
+	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
+	struct v4l2_subdev_route *r = routing->routes;
+	int input = -1;
+	unsigned int i;
+
+	if (routing->num_routes > ADV748X_AFE_ROUTES_MAX)
+		return -ENOSPC;
+
+	for (i = 0; i < routing->num_routes; i++) {
+		if (r->sink_pad > ADV748X_AFE_SINK_AIN7 ||
+		    r->sink_stream != 0 ||
+		    r->source_pad != ADV748X_AFE_SOURCE ||
+		    r->source_stream != 0)
+			return -EINVAL;
+
+		if (r->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE) {
+			if (input != -1)
+				return -EMLINK;
+
+			input = r->sink_pad;
+		}
+		r++;
+	}
+
+	if (input != -1)
+		afe->input = input;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops adv748x_afe_pad_ops = {
 	.enum_mbus_code = adv748x_afe_enum_mbus_code,
 	.set_fmt = adv748x_afe_set_format,
 	.get_fmt = adv748x_afe_get_format,
+	.get_routing = adv748x_afe_get_routing,
+	.set_routing = adv748x_afe_set_routing,
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.15.1
