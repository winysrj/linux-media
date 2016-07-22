Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36560 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbcGVJJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 05:09:31 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	william.towle@codethink.co.uk, geert@linux-m68k.org,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v6 1/4] media: adv7604: automatic "default-input" selection
Date: Fri, 22 Jul 2016 11:09:11 +0200
Message-Id: <1469178554-20719-2-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fall back to input 0 if "default-input" property is not present.

Additionally, documentation in commit bf9c82278c34 ("[media]
media: adv7604: ability to read default input port from DT") states
that the "default-input" property should reside directly in the node
for adv7612. Hence, also adjust the parsing to make the implementation
consistent with this.

Based on patch by William Towle <william.towle@codethink.co.uk>.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7604.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 4003831..055c9df 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3077,10 +3077,13 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	if (!of_property_read_u32(endpoint, "default-input", &v))
 		state->pdata.default_input = v;
 	else
-		state->pdata.default_input = -1;
+		state->pdata.default_input = 0;
 
 	of_node_put(endpoint);
 
+	if (!of_property_read_u32(np, "default-input", &v))
+		state->pdata.default_input = v;
+
 	flags = bus_cfg.bus.parallel.flags;
 
 	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
-- 
2.7.4

