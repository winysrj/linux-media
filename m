Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:61306 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934676AbaH0Ncr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 09:32:47 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so234339wes.14
        for <linux-media@vger.kernel.org>; Wed, 27 Aug 2014 06:32:46 -0700 (PDT)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH v2] Add support for definition of register maps in DT in ADV7604
Date: Wed, 27 Aug 2014 15:32:35 +0200
Message-Id: <1409146355-15035-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for DT parsing of register maps adresses.
This allows multiple adv76xx devices on the same bus.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 .../devicetree/bindings/media/i2c/adv7604.txt      | 12 ++++
 drivers/media/i2c/adv7604.c                        | 71 ++++++++++++++++++----
 2 files changed, 71 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index c27cede..21146cb 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -32,6 +32,18 @@ The digital output port node must contain at least one endpoint.
 Optional Properties:
 
   - reset-gpios: Reference to the GPIO connected to the device's reset pin.
+  - adv7604-addr-avlink: Programmed address for avlink register map
+  - adv7604-addr-cec: Programmed address for cec register map
+  - adv7604-addr-infoframe: Programmed address for infoframe register map
+  - adv7604-addr-esdp: Programmed address for esdp register map
+  - adv7604-addr-dpp: Programmed address for dpp register map
+  - adv7604-addr-afe: Programmed address for afe register map
+  - adv7604-addr-rep: Programmed address for rep register map
+  - adv7604-addr-edid: Programmed address for edid register map
+  - adv7604-addr-hdmi: Programmed address for hdmi register map
+  - adv7604-addr-test: Programmed address for test register map
+  - adv7604-addr-cp: Programmed address for cp register map
+  - adv7604-addr-vdp: Programmed address for vdp register map
 
 Optional Endpoint Properties:
 
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d4fa213..d15a05f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2718,18 +2718,65 @@ static int adv7604_parse_dt(struct adv7604_state *state)
 	state->pdata.int1_config = ADV7604_INT1_CONFIG_DISABLED;
 
 	/* Use the default I2C addresses. */
-	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
-	state->pdata.i2c_addresses[ADV7604_PAGE_CEC] = 0x40;
-	state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME] = 0x3e;
-	state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] = 0x38;
-	state->pdata.i2c_addresses[ADV7604_PAGE_DPP] = 0x3c;
-	state->pdata.i2c_addresses[ADV7604_PAGE_AFE] = 0x26;
-	state->pdata.i2c_addresses[ADV7604_PAGE_REP] = 0x32;
-	state->pdata.i2c_addresses[ADV7604_PAGE_EDID] = 0x36;
-	state->pdata.i2c_addresses[ADV7604_PAGE_HDMI] = 0x34;
-	state->pdata.i2c_addresses[ADV7604_PAGE_TEST] = 0x30;
-	state->pdata.i2c_addresses[ADV7604_PAGE_CP] = 0x22;
-	state->pdata.i2c_addresses[ADV7604_PAGE_VDP] = 0x24;
+	of_property_read_u32(np, "adv7604-addr-avlink",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK])
+		state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
+
+	of_property_read_u32(np, "adv7604-addr-cec",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_CEC]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_CEC])
+		state->pdata.i2c_addresses[ADV7604_PAGE_CEC] = 0x40;
+
+	of_property_read_u32(np, "adv7604-addr-infoframe",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME])
+		state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME] = 0x3e;
+
+	of_property_read_u32(np, "adv7604-addr-esdp",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_ESDP]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_ESDP])
+		state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] = 0x38;
+
+	of_property_read_u32(np, "adv7604-addr-dpp",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_DPP]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_DPP])
+		state->pdata.i2c_addresses[ADV7604_PAGE_DPP] = 0x3c;
+
+	of_property_read_u32(np, "adv7604-addr-afe",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_AFE]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_AFE])
+		state->pdata.i2c_addresses[ADV7604_PAGE_AFE] = 0x26;
+
+	of_property_read_u32(np, "adv7604-addr-rep",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_REP]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_REP])
+		state->pdata.i2c_addresses[ADV7604_PAGE_REP] = 0x32;
+
+	of_property_read_u32(np, "adv7604-addr-edid",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_EDID]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_EDID])
+		state->pdata.i2c_addresses[ADV7604_PAGE_EDID] = 0x36;
+
+	of_property_read_u32(np, "adv7604-addr-hdmi",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_HDMI]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_HDMI])
+		state->pdata.i2c_addresses[ADV7604_PAGE_HDMI] = 0x34;
+
+	of_property_read_u32(np, "adv7604-addr-test",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_TEST]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_TEST])
+		state->pdata.i2c_addresses[ADV7604_PAGE_TEST] = 0x30;
+
+	of_property_read_u32(np, "adv7604-addr-cp",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_CP]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_CP])
+		state->pdata.i2c_addresses[ADV7604_PAGE_CP] = 0x22;
+
+	of_property_read_u32(np, "adv7604-addr-vdp",
+			&state->pdata.i2c_addresses[ADV7604_PAGE_VDP]);
+	if (!state->pdata.i2c_addresses[ADV7604_PAGE_VDP])
+		state->pdata.i2c_addresses[ADV7604_PAGE_VDP] = 0x24;
 
 	/* Hardcode the remaining platform data fields. */
 	state->pdata.disable_pwrdnb = 0;
-- 
2.0.4

