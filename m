Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49322 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbdAaMIx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 07:08:53 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2] v4l: of: check for unique lanes in data-lanes and clock-lanes
Date: Tue, 31 Jan 2017 13:08:31 +0100
Message-Id: <20170131120831.11283-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All lanes in data-lanes and clock-lanes properties should be unique. Add
a check for this in v4l2_of_parse_csi_bus() and print a warning if
duplicated lanes are found.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---

Changes since v1:

- Do not return -EINVAL if a duplicate is found. Sakari pointed out 
  there are drivers where the number of lanes matter but not the actual 
  lane numbers. Updated commit message to highlight that only a warning 
  is printed.
- Switched to a bitmask to track lanes used instead of a nested loop, 
  thanks Laurent for the suggestion.


 drivers/media/v4l2-core/v4l2-of.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 93b33681776ca427..4f59f442dd0a64c9 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -26,7 +26,7 @@ static int v4l2_of_parse_csi_bus(const struct device_node *node,
 	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
 	struct property *prop;
 	bool have_clk_lane = false;
-	unsigned int flags = 0;
+	unsigned int flags = 0, lanes_used = 0;
 	u32 v;
 
 	prop = of_find_property(node, "data-lanes", NULL);
@@ -38,6 +38,12 @@ static int v4l2_of_parse_csi_bus(const struct device_node *node,
 			lane = of_prop_next_u32(prop, lane, &v);
 			if (!lane)
 				break;
+
+			if (lanes_used & BIT(v))
+				pr_warn("%s: duplicated lane %u in data-lanes\n",
+					node->full_name, v);
+			lanes_used |= BIT(v);
+
 			bus->data_lanes[i] = v;
 		}
 		bus->num_data_lanes = i;
@@ -63,6 +69,11 @@ static int v4l2_of_parse_csi_bus(const struct device_node *node,
 	}
 
 	if (!of_property_read_u32(node, "clock-lanes", &v)) {
+		if (lanes_used & BIT(v))
+			pr_warn("%s: duplicated lane %u in clock-lanes\n",
+				node->full_name, v);
+		lanes_used |= BIT(v);
+
 		bus->clock_lane = v;
 		have_clk_lane = true;
 	}
-- 
2.11.0

