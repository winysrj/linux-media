Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37661 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946020AbbEENuJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 09:50:09 -0400
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>
CC: <s.nawrocki@samsung.com>, Nikhil Devshatwar <nikhil.nd@ti.com>
Subject: [PATCH] v4l: of: Correct pclk-sample for BT656 bus
Date: Tue, 5 May 2015 19:19:59 +0530
Message-ID: <1430833799-31936-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current v4l2_of_parse_parallel_bus function attempts to parse the
DT properties for the parallel bus as well as BT656 bus.
If the pclk-sample property is defined for the BT656 bus, it is still
marked as a parallel bus.
Fix this by parsing the pclk after the bus_type is selected.
Only when hsync or vsync properties are specified, the bus_type should
be set to V4L2_MBUS_PARALLEL.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
---
 drivers/media/v4l2-core/v4l2-of.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index c52fb96..b27cbb1 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -93,10 +93,6 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 		flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
 			V4L2_MBUS_VSYNC_ACTIVE_LOW;
 
-	if (!of_property_read_u32(node, "pclk-sample", &v))
-		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
-			V4L2_MBUS_PCLK_SAMPLE_FALLING;
-
 	if (!of_property_read_u32(node, "field-even-active", &v))
 		flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
 			V4L2_MBUS_FIELD_EVEN_LOW;
@@ -105,6 +101,10 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 	else
 		endpoint->bus_type = V4L2_MBUS_BT656;
 
+	if (!of_property_read_u32(node, "pclk-sample", &v))
+		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
+			V4L2_MBUS_PCLK_SAMPLE_FALLING;
+
 	if (!of_property_read_u32(node, "data-active", &v))
 		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
 			V4L2_MBUS_DATA_ACTIVE_LOW;
-- 
1.7.9.5

