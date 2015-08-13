Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:53657 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752573AbbHMLg6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 07:36:58 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: linux-sh@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/3] media: adv7604: automatic "default-input" selection
Date: Thu, 13 Aug 2015 12:36:50 +0100
Message-Id: <1439465811-936-3-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1439465811-936-1-git-send-email-william.towle@codethink.co.uk>
References: <1439465811-936-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
---
 drivers/media/i2c/adv7604.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 5631ec0..5bd81bd 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2799,7 +2799,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	struct device_node *endpoint;
 	struct device_node *np;
 	unsigned int flags;
-	u32 v;
+	u32 v= -1;
 
 	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
 
@@ -2809,14 +2809,25 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
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
+			if (state->info->max_port
+					== ADV76XX_PAD_HDMI_PORT_A)
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
1.7.10.4

