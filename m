Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34259 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934038AbcIOMO7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 08:14:59 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, ulrich.hecht+renesas@gmail.com,
        laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk
Subject: [PATCH v7 1/2] media: adv7604: automatic "default-input" selection
Date: Thu, 15 Sep 2016 14:14:45 +0200
Message-Id: <20160915121446.25830-2-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <20160915121446.25830-1-ulrich.hecht+renesas@gmail.com>
References: <20160915121446.25830-1-ulrich.hecht+renesas@gmail.com>
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
2.9.3

