Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36526 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbcDNQSE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 12:18:04 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v3 2/7] media: adv7604: automatic "default-input" selection
Date: Thu, 14 Apr 2016 18:17:45 +0200
Message-Id: <1460650670-20849-3-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1460650670-20849-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1460650670-20849-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: William Towle <william.towle@codethink.co.uk>

Add logic such that the "default-input" property becomes unnecessary
for chips that only have one suitable input (ADV7611 by design, and
ADV7612 due to commit 7111cddd518f ("[media] media: adv7604: reduce
support to first (digital) input").

Additionally, Ian's documentation in commit bf9c82278c34 ("[media]
media: adv7604: ability to read default input port from DT") states
that the "default-input" property should reside directly in the node
for adv7612. Hence, also adjust the parsing to make the implementation
consistent with this.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7604.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 41a1bfc..d722c16 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2788,7 +2788,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	struct device_node *np;
 	unsigned int flags;
 	int ret;
-	u32 v;
+	u32 v = -1;
 
 	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
 
@@ -2810,6 +2810,22 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 
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
2.7.4

