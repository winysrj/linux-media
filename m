Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:51667 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935454AbeE2PGf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 11:06:35 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 3/8] media: v4l2-fwnode: parse 'data-enable-active' prop
Date: Tue, 29 May 2018 17:05:54 +0200
Message-Id: <1527606359-19261-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse the newly defined 'data-enable-active' property in parallel endpoint
parsing function.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---
v3:
- new patch
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 4 ++++
 include/media/v4l2-mediabus.h         | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 3f77aa3..6105191 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -154,6 +154,10 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 		flags |= v ? V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH :
 			V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW;

+	if (!fwnode_property_read_u32(fwnode, "data-enable-active", &v))
+		flags |= v ? V4L2_MBUS_DATA_ENABLE_HIGH :
+			V4L2_MBUS_DATA_ENABLE_LOW;
+
 	bus->flags = flags;

 }
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 4d8626c..4bbb5f3 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -45,6 +45,8 @@
 /* Active state of Sync-on-green (SoG) signal, 0/1 for LOW/HIGH respectively. */
 #define V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH		BIT(12)
 #define V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW		BIT(13)
+#define V4L2_MBUS_DATA_ENABLE_HIGH		BIT(14)
+#define V4L2_MBUS_DATA_ENABLE_LOW		BIT(15)

 /* Serial flags */
 /* How many lanes the client can use */
--
2.7.4
