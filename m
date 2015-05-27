Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:52391 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751857AbbE0QK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 12:10:59 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 06/15] media: adv7604: ability to read default input port from DT
Date: Wed, 27 May 2015 17:10:44 +0100
Message-Id: <1432743053-13479-7-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
References: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

Adds support to the adv7604 driver for specifying the default input
port in the Device tree. If no value is provided, the driver will be
unable to select an input without help from userspace.

Tested-by: William Towle <william.towle@codethink.co.uk>
Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
---
 Documentation/devicetree/bindings/media/i2c/adv7604.txt |    3 +++
 drivers/media/i2c/adv7604.c                             |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index 7eafdbc..8337f75 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -47,6 +47,7 @@ Optional Endpoint Properties:
   If none of hsync-active, vsync-active and pclk-sample is specified the
   endpoint will use embedded BT.656 synchronization.
 
+  - default-input: Select which input is selected after reset.
 
 Example:
 
@@ -60,6 +61,8 @@ Example:
 		#address-cells = <1>;
 		#size-cells = <0>;
 
+		default-input = <0>;
+
 		port@0 {
 			reg = <0>;
 		};
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c5a1566..ec8161d 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2745,6 +2745,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	struct device_node *endpoint;
 	struct device_node *np;
 	unsigned int flags;
+	u32 v;
 
 	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
 
@@ -2754,6 +2755,12 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
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
@@ -2792,7 +2799,6 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	/* Hardcode the remaining platform data fields. */
 	state->pdata.disable_pwrdnb = 0;
 	state->pdata.disable_cable_det_rst = 0;
-	state->pdata.default_input = -1;
 	state->pdata.blank_data = 1;
 	state->pdata.alt_data_sat = 1;
 	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
-- 
1.7.10.4

