Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33137 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbcGFPkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 11:40:51 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com
Cc: niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v5 1/4] media: adv7604: automatic "default-input" selection
Date: Wed,  6 Jul 2016 17:39:33 +0200
Message-Id: <1467819576-17743-2-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1467819576-17743-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1467819576-17743-1-git-send-email-ulrich.hecht+renesas@gmail.com>
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
index 3f1ab49..2e8f036 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2830,10 +2830,13 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
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

