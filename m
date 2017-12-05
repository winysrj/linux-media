Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47085 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdLEUl5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Dec 2017 15:41:57 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund+renesas@ragnatech.se,
        laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH] v4l: rcar-csi2: Don't bail out from probe on no ep
Date: Tue,  5 Dec 2017 21:41:48 +0100
Message-Id: <1512506508-17418-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When rcar-csi interface is not connected to any endpoint, it fails and
bails out from probe before registering its own video subdevice.
This prevents rcar-vin registered notifier from completing and no
subdevice is ever registered, also for other properly connected csi
interfaces.

Fix this not returning an error when no endpoint is connected to a csi
interface and let the driver complete its probe function and register its
own video subdevice.

---
Niklas,
   please squash this patch in your next rcar-csi2 series (if you like it ;)

As we have discussed this is particularly useful for gmsl setup, where adv748x
is connected to CSI20 and max9286 to CSI40/CSI41. If we disable adv748x from DTS
we need CSI20 probe to complete anyhow otherwise no subdevice gets registered
for the two deserializers.

Please note we cannot disable CSI20 entirely otherwise VIN's graph parsing
breaks.

Thanks
   j

---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 2793efb..90c4062 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -928,8 +928,8 @@ static int rcar_csi2_parse_dt(struct rcar_csi2 *priv)

 	ep = of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
 	if (!ep) {
-		dev_err(priv->dev, "Not connected to subdevice\n");
-		return -EINVAL;
+		dev_dbg(priv->dev, "Not connected to subdevice\n");
+		return 0;
 	}

 	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
--
2.7.4
