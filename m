Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:38330 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751707AbdAZNNY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jan 2017 08:13:24 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] v4l: of: check for unique lanes in data-lanes and clock-lanes
Date: Thu, 26 Jan 2017 14:12:59 +0100
Message-Id: <20170126131259.5621-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All lines in data-lanes and clock-lanes properties must be unique.
Instead of drivers checking for this add it to the generic parser.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-of.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 93b33681776c..1042db6bb996 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -32,12 +32,19 @@ static int v4l2_of_parse_csi_bus(const struct device_node *node,
 	prop = of_find_property(node, "data-lanes", NULL);
 	if (prop) {
 		const __be32 *lane = NULL;
-		unsigned int i;
+		unsigned int i, n;
 
 		for (i = 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
 			lane = of_prop_next_u32(prop, lane, &v);
 			if (!lane)
 				break;
+			for (n = 0; n < i; n++) {
+				if (bus->data_lanes[n] == v) {
+					pr_warn("%s: duplicated lane %u in data-lanes\n",
+						node->full_name, v);
+					return -EINVAL;
+				}
+			}
 			bus->data_lanes[i] = v;
 		}
 		bus->num_data_lanes = i;
@@ -63,6 +70,15 @@ static int v4l2_of_parse_csi_bus(const struct device_node *node,
 	}
 
 	if (!of_property_read_u32(node, "clock-lanes", &v)) {
+		unsigned int n;
+
+		for (n = 0; n < bus->num_data_lanes; n++) {
+			if (bus->data_lanes[n] == v) {
+				pr_warn("%s: duplicated lane %u in clock-lanes\n",
+					node->full_name, v);
+				return -EINVAL;
+			}
+		}
 		bus->clock_lane = v;
 		have_clk_lane = true;
 	}
-- 
2.11.0

