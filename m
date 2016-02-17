Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33944 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161552AbcBQPtE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 10:49:04 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH/RFC 2/9] media: adv7604: automatic "default-input" selection
Date: Wed, 17 Feb 2016 16:48:38 +0100
Message-Id: <1455724125-13004-3-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: William Towle <william.towle@codethink.co.uk>

Add logic such that the "default-input" property becomes unnecessary
for chips that only have one suitable input (ADV7611 by design, and
ADV7612 due to commit 7111cddd "[media] media: adv7604: reduce support
to first (digital) input").

Additionally, Ian's documentation in commit bf9c8227 ("[media] media:
adv7604: ability to read default input port from DT") states that the
"default-input" property should reside directly in the node for
adv7612. Hence, also adjust the parsing to make the implementation
consistent with this.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7604.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index f8dd750..2097c48 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2799,7 +2799,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	struct device_node *endpoint;
 	struct device_node *np;
 	unsigned int flags;
-	u32 v;
+	u32 v = -1;
 
 	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
 
@@ -2809,14 +2809,24 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 		return -EINVAL;
 
 	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
-
-	if (!of_property_read_u32(endpoint, "default-input", &v))
-		state->pdata.default_input = v;
-	else
-		state->pdata.default_input = -1;
-
 	of_node_put(endpoint);
 
+	if (of_property_read_u32(np, "default-input", &v)) {
+		/* not specified ... can we choose automatically? */
+		switch (state->info->type) {
+		case ADV7611:
+			v = 0;
+			break;
+		case ADV7612:
+			if (state->info->max_port == ADV76XX_PAD_HDMI_PORT_A)
+				v = 0;
+			/* else is unhobbled, leave unspecified */
+		default:
+			break;
+		}
+	}
+	state->pdata.default_input = v;
+
 	flags = bus_cfg.bus.parallel.flags;
 
 	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
-- 
2.6.4

