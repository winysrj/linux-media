Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:55506 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752869AbbA2QTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:19:52 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/8] Add ability to read default input port from DT
Date: Thu, 29 Jan 2015 16:19:41 +0000
Message-Id: <1422548388-28861-2-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

---
 Documentation/devicetree/bindings/media/i2c/adv7604.txt |    3 +++
 drivers/media/i2c/adv7604.c                             |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index c27cede..bc50da2 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -33,6 +33,9 @@ Optional Properties:
 
   - reset-gpios: Reference to the GPIO connected to the device's reset pin.
 
+  - default-input: Reference to the chip's default input port. This value
+    should match the pad number for the intended device
+
 Optional Endpoint Properties:
 
   The following three properties are defined in video-interfaces.txt and are
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index e43dd2e..6666803 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2686,6 +2686,7 @@ static int adv7604_parse_dt(struct adv7604_state *state)
 	struct device_node *endpoint;
 	struct device_node *np;
 	unsigned int flags;
+	u32 v;
 
 	np = state->i2c_clients[ADV7604_PAGE_IO]->dev.of_node;
 
@@ -2695,6 +2696,12 @@ static int adv7604_parse_dt(struct adv7604_state *state)
 		return -EINVAL;
 
 	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+
+	if (!of_property_read_u32(endpoint, "default-input", &v))
+		state->pdata.default_input = v;
+	else
+		state->pdata.default_input = -1;
+
 	of_node_put(endpoint);
 
 	flags = bus_cfg.bus.parallel.flags;
@@ -2733,7 +2740,6 @@ static int adv7604_parse_dt(struct adv7604_state *state)
 	/* Hardcode the remaining platform data fields. */
 	state->pdata.disable_pwrdnb = 0;
 	state->pdata.disable_cable_det_rst = 0;
-	state->pdata.default_input = -1;
 	state->pdata.blank_data = 1;
 	state->pdata.alt_data_sat = 1;
 	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
-- 
1.7.10.4

