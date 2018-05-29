Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:39045 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935749AbeE2PGr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 11:06:47 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 7/8] media: rcar-vin: Handle 'hsync-as-de' property
Date: Tue, 29 May 2018 17:05:58 +0200
Message-Id: <1527606359-19261-8-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse and handle 'hsync-as-de' custom property and set the CHS flag during
the VIN interface setup.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
v3:
- new patch
- use the new custom property to set the CHS bit
---
 drivers/media/platform/rcar-vin/rcar-core.c | 6 ++++++
 drivers/media/platform/rcar-vin/rcar-dma.c  | 6 ++++++
 drivers/media/platform/rcar-vin/rcar-vin.h  | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 3062171..71710b8 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -589,6 +589,7 @@ static int rvin_parallel_parse_v4l2(struct device *dev,
 	struct rvin_dev *vin = dev_get_drvdata(dev);
 	struct rvin_parallel_entity *rvpe =
 		container_of(asd, struct rvin_parallel_entity, asd);
+	const struct fwnode_handle *fwnode = vep->base.local_fwnode;

 	if (vep->base.port || vep->base.id)
 		return -ENOTCONN;
@@ -610,6 +611,11 @@ static int rvin_parallel_parse_v4l2(struct device *dev,
 		return -EINVAL;
 	}

+	if (fwnode_property_read_bool(fwnode, "renesas,hsync-as-de"))
+		vin->parallel->chs = true;
+	else
+		vin->parallel->chs = false;
+
 	return 0;
 }

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 9145b56..01d0737 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -124,6 +124,7 @@
 #define VNDMR2_VPS		(1 << 30)
 #define VNDMR2_HPS		(1 << 29)
 #define VNDMR2_CES		(1 << 28)
+#define VNDMR2_CHS		(1 << 23)
 #define VNDMR2_FTEV		(1 << 17)
 #define VNDMR2_VLV(n)		((n & 0xf) << 12)

@@ -703,6 +704,11 @@ static int rvin_setup(struct rvin_dev *vin)
 		/* Data Enable Polarity Select */
 		if (vin->parallel->mbus_flags & V4L2_MBUS_DATA_ENABLE_LOW)
 			dmr2 |= VNDMR2_CES;
+
+		/* Use HSYNC as data-enable signal */
+		if (vin->parallel->mbus_type == V4L2_MBUS_PARALLEL &&
+		    vin->parallel->chs)
+			dmr2 |= VNDMR2_CHS;
 	}

 	/*
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 8bc3704..846f978 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -78,6 +78,7 @@ struct rvin_video_format {
  * @subdev:	subdevice matched using async framework
  * @mbus_type:	media bus type
  * @mbus_flags:	media bus configuration flags
+ * @chs:	use HSYNC as data-enable flag
  * @source_pad:	source pad of remote subdevice
  * @sink_pad:	sink pad of remote subdevice
  *
@@ -88,6 +89,7 @@ struct rvin_parallel_entity {

 	enum v4l2_mbus_type mbus_type;
 	unsigned int mbus_flags;
+	bool chs;

 	unsigned int source_pad;
 	unsigned int sink_pad;
--
2.7.4
