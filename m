Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33060 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbbESRLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 13:11:46 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: v4l2-core/v4l2-of.c: determine bus_type only on hsync/vsync flags
Date: Tue, 19 May 2015 18:11:23 +0100
Message-Id: <1432055483-23563-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

the bus_type needs to be determined only on the hsync/vsync flags,
this patch fixes the above by moving the check just after hsync/vsync
flags are being set.

Reported-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/v4l2-core/v4l2-of.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index c52fb96..7f89c70 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -93,6 +93,11 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 		flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
 			V4L2_MBUS_VSYNC_ACTIVE_LOW;
 
+	if (flags)
+		endpoint->bus_type = V4L2_MBUS_PARALLEL;
+	else
+		endpoint->bus_type = V4L2_MBUS_BT656;
+
 	if (!of_property_read_u32(node, "pclk-sample", &v))
 		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
 			V4L2_MBUS_PCLK_SAMPLE_FALLING;
@@ -100,10 +105,6 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 	if (!of_property_read_u32(node, "field-even-active", &v))
 		flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
 			V4L2_MBUS_FIELD_EVEN_LOW;
-	if (flags)
-		endpoint->bus_type = V4L2_MBUS_PARALLEL;
-	else
-		endpoint->bus_type = V4L2_MBUS_BT656;
 
 	if (!of_property_read_u32(node, "data-active", &v))
 		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
-- 
2.1.0

