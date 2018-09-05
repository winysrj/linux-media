Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:60677 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbeIET6N (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 15:58:13 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 5/5] media: i2c: adv748x: Register all input subdevices
Date: Wed,  5 Sep 2018 17:27:11 +0200
Message-Id: <1536161231-25221-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1536161231-25221-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1536161231-25221-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The input subdevice registration, being the link between adv728x's inputs
and outputs fixed, happens at output subdevice registration time. In the
current design the TXA output subdevice 'registered()' callback registers
the HDMI input subdevice and the TXB output subdevice 'registered()' callback
registers the AFE input subdevice instead. Media links are created
accordingly to the fixed routing.

As the adv748x driver can now probe with at least a single output port
enabled an input subdevice linked to a disabled output is never registered
to the media graph. Fix this by having the first registered output subdevice
register all the available input subdevices.

This change is necessary to have dynamic routing between the adv748x inputs
and outputs implemented.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 85 +++++++++++++++-----------------
 1 file changed, 40 insertions(+), 45 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 9e9df51..fd4aa9d 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -24,42 +24,6 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
 	return tx_write(tx, ADV748X_CSI_VC_REF, vc << ADV748X_CSI_VC_REF_SHIFT);
 }
 
-/**
- * adv748x_csi2_register_link : Register and link internal entities
- *
- * @tx: CSI2 private entity
- * @v4l2_dev: Video registration device
- * @src: Source subdevice to establish link
- * @src_pad: Pad number of source to link to this @tx
- *
- * Ensure that the subdevice is registered against the v4l2_device, and link the
- * source pad to the sink pad of the CSI2 bus entity.
- */
-static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
-				      struct v4l2_device *v4l2_dev,
-				      struct v4l2_subdev *src,
-				      unsigned int src_pad)
-{
-	int enabled = MEDIA_LNK_FL_ENABLED;
-	int ret;
-
-	/*
-	 * Dynamic linking of the AFE is not supported.
-	 * Register the links as immutable.
-	 */
-	enabled |= MEDIA_LNK_FL_IMMUTABLE;
-
-	if (!src->v4l2_dev) {
-		ret = v4l2_device_register_subdev(v4l2_dev, src);
-		if (ret)
-			return ret;
-	}
-
-	return media_create_pad_link(&src->entity, src_pad,
-				     &tx->sd.entity, ADV748X_CSI2_SINK,
-				     enabled);
-}
-
 /* -----------------------------------------------------------------------------
  * v4l2_subdev_internal_ops
  *
@@ -72,25 +36,56 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
 {
 	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
 	struct adv748x_state *state = tx->state;
+	struct v4l2_subdev *src_sd;
+	unsigned int src_pad;
+	int ret;
 
 	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
 			sd->name);
 
+	/* The first registered CSI-2 registers all input subdevices. */
+	src_sd = &state->hdmi.sd;
+	if (!src_sd->v4l2_dev && is_hdmi_enabled(state)) {
+		ret = v4l2_device_register_subdev(sd->v4l2_dev, src_sd);
+		if (ret)
+			return ret;
+	}
+
+	src_sd = &state->afe.sd;
+	if (!src_sd->v4l2_dev && is_afe_enabled(state)) {
+		ret = v4l2_device_register_subdev(sd->v4l2_dev, src_sd);
+		if (ret)
+			goto err_unregister_hdmi;
+	}
+
 	/*
 	 * The adv748x hardware allows the AFE to route through the TXA, however
 	 * this is not currently supported in this driver.
 	 *
 	 * Link HDMI->TXA, and AFE->TXB directly.
 	 */
-	if (is_txa(tx) && is_hdmi_enabled(state))
-		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
-						  &state->hdmi.sd,
-						  ADV748X_HDMI_SOURCE);
-	if (!is_txa(tx) && is_afe_enabled(state))
-		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
-						  &state->afe.sd,
-						  ADV748X_AFE_SOURCE);
-	return 0;
+	if (is_txa(tx)) {
+		if (!is_hdmi_enabled(state))
+			return 0;
+
+		src_sd = &state->hdmi.sd;
+		src_pad = ADV748X_HDMI_SOURCE;
+	} else {
+		if (!is_afe_enabled(state))
+			return 0;
+
+		src_sd = &state->afe.sd;
+		src_pad = ADV748X_AFE_SOURCE;
+	}
+
+	/* Dynamic linking is not supported, register the links as immutable. */
+	return media_create_pad_link(&src_sd->entity, src_pad, &sd->entity,
+				     ADV748X_CSI2_SINK, MEDIA_LNK_FL_ENABLED |
+				     MEDIA_LNK_FL_IMMUTABLE);
+err_unregister_hdmi:
+	v4l2_device_unregister_subdev(&state->hdmi.sd);
+
+	return ret;
 }
 
 static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
-- 
2.7.4
