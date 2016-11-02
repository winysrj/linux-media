Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49495 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754501AbcKBN3r (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:47 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 25/32] media: rcar-vin: enable CSI2 group subdevices in lookup helpers
Date: Wed,  2 Nov 2016 14:23:22 +0100
Message-Id: <20161102132329.436-26-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the subdevice helpers look not only at the local digital subdevice
but also for the CSI2 group subdevices which can be present on Gen3.

Which CSI2 group subdevices are found depends on the CSI2 subgroup
routing which is stored in the CHSEL register of the subgroup master
(VIN0 for VIN0-3 and VIN4 for VIN4-7). The lookup functions look at this
value and returns the correct information or NULL if there is no
attached subdevices for the current routing for this device.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 66 ++++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  2 +-
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 06876a8..f382f91 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -330,9 +330,73 @@ static void rvin_group_delete(struct rvin_dev *vin)
  * Subdevice helpers
  */
 
+static int rvin_group_vin_to_csi(struct rvin_dev *vin)
+{
+	int i, vin_num, vin_master, chsel, csi;
+
+	/*
+	 * Only try to translate to a CSI2 number if there is a enabled
+	 * link from the VIN sink pad. However if there are no links at
+	 * all we are at probe time so ignore the need for enabled links
+	 * to be able to make a better guess of initial format
+	 */
+	if (vin->pads[RVIN_SINK].entity->num_links &&
+	    !media_entity_remote_pad(&vin->pads[RVIN_SINK]))
+		return -1;
+
+	/* Find which VIN we are */
+	vin_num = -1;
+	for (i = 0; i < RCAR_VIN_NUM; i++)
+		if (vin == vin->group->vin[i])
+			vin_num = i;
+
+	if (vin_num == -1)
+		return -1;
+
+	vin_master = vin_num < 4 ? 0 : 4;
+	if (!vin->group->vin[vin_master])
+		return -1;
+
+	chsel = rvin_get_chsel(vin->group->vin[vin_master]);
+
+	csi = vin->info->chsels[vin_num][chsel].csi;
+	if (csi >= RVIN_CSI_MAX)
+		return -1;
+
+	if (!vin->group->source[csi].subdev || !vin->group->bridge[csi].subdev)
+		return -1;
+
+	return csi;
+}
+
 struct rvin_graph_entity *vin_to_entity(struct rvin_dev *vin)
 {
-	return &vin->digital;
+	int csi;
+
+	/* If there is a digital subdev use it */
+	if (vin->digital.subdev)
+		return &vin->digital;
+
+	csi = rvin_group_vin_to_csi(vin);
+	if (csi < 0)
+		return NULL;
+
+	return &vin->group->source[csi];
+}
+
+struct v4l2_subdev *vin_to_source(struct rvin_dev *vin)
+{
+	int csi;
+
+	/* If there is a digital subdev use it */
+	if (vin->digital.subdev)
+		return vin->digital.subdev;
+
+	csi = rvin_group_vin_to_csi(vin);
+	if (csi < 0)
+		return NULL;
+
+	return vin->group->source[csi].subdev;
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index cd7d959..2f1e087 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -207,7 +207,7 @@ struct rvin_dev {
 };
 
 struct rvin_graph_entity *vin_to_entity(struct rvin_dev *vin);
-#define vin_to_source(vin)		vin->digital.subdev
+struct v4l2_subdev *vin_to_source(struct rvin_dev *vin);
 
 /* Debug */
 #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
-- 
2.10.2

