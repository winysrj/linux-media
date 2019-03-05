Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E623C4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEFF1208E4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfCESwI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:52:08 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:49199 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728753AbfCESwH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:52:07 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 1ECB220000C;
        Tue,  5 Mar 2019 18:52:04 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH v3 27/31] adv748x: afe: add routing support
Date:   Tue,  5 Mar 2019 19:51:46 +0100
Message-Id: <20190305185150.20776-28-jacopo+renesas@jmondi.org>
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

The adv748x afe has eight analog sink pads, currently one of them is
chosen to be the active route based on device tree configuration. With
the new routing API it's possible to expose and change which of the
eight sink pads are routed to the source pad.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-afe.c | 65 +++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
index dbbb1e4d6363..3f770f71413f 100644
--- a/drivers/media/i2c/adv748x/adv748x-afe.c
+++ b/drivers/media/i2c/adv748x/adv748x-afe.c
@@ -39,6 +39,9 @@
 #define ADV748X_AFE_STD_PAL_SECAM			0xe
 #define ADV748X_AFE_STD_PAL_SECAM_PED			0xf
 
+#define ADV748X_AFE_ROUTES_MAX ((ADV748X_AFE_SINK_AIN7 - \
+				ADV748X_AFE_SINK_AIN0) + 1)
+
 static int adv748x_afe_read_ro_map(struct adv748x_state *state, u8 reg)
 {
 	int ret;
@@ -383,10 +386,72 @@ static int adv748x_afe_set_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int adv748x_afe_get_routing(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_krouting *routing)
+{
+	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
+	struct v4l2_subdev_route *r = routing->routes;
+	unsigned int i;
+
+	/* There is one possible route from each sink */
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
+				   struct v4l2_subdev_krouting *routing)
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
2.20.1

