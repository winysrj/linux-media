Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:46493 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbeIQQ6G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 12:58:06 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v3 4/4] media: i2c: adv748x: Register only enabled inputs
Date: Mon, 17 Sep 2018 13:30:57 +0200
Message-Id: <1537183857-29173-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1537183857-29173-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1537183857-29173-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv748x assumes input endpoints are always enabled, and registers
a subdevice for each of them when the corresponding output subdevice
is registered.

Fix this by conditionally registering the input subdevice only if it is
actually described in device tree.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c |  6 +++---
 drivers/media/i2c/adv748x/adv748x.h      | 10 ++++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 034fd93..9e9df51 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -82,15 +82,15 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
 	 *
 	 * Link HDMI->TXA, and AFE->TXB directly.
 	 */
-	if (is_txa(tx)) {
+	if (is_txa(tx) && is_hdmi_enabled(state))
 		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
 						  &state->hdmi.sd,
 						  ADV748X_HDMI_SOURCE);
-	} else {
+	if (!is_txa(tx) && is_afe_enabled(state))
 		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
 						  &state->afe.sd,
 						  ADV748X_AFE_SOURCE);
-	}
+	return 0;
 }
 
 static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index eeadf05..a34004e 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -94,6 +94,16 @@ struct adv748x_csi2 {
 #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
 #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
 #define is_txa(_tx) ((_tx) == &(_tx)->state->txa)
+#define is_afe_enabled(_state)					\
+	((_state)->endpoints[ADV748X_PORT_AIN0] != NULL ||	\
+	 (_state)->endpoints[ADV748X_PORT_AIN1] != NULL ||	\
+	 (_state)->endpoints[ADV748X_PORT_AIN2] != NULL ||	\
+	 (_state)->endpoints[ADV748X_PORT_AIN3] != NULL ||	\
+	 (_state)->endpoints[ADV748X_PORT_AIN4] != NULL ||	\
+	 (_state)->endpoints[ADV748X_PORT_AIN5] != NULL ||	\
+	 (_state)->endpoints[ADV748X_PORT_AIN6] != NULL ||	\
+	 (_state)->endpoints[ADV748X_PORT_AIN7] != NULL)
+#define is_hdmi_enabled(_state) ((_state)->endpoints[ADV748X_PORT_HDMI] != NULL)
 
 enum adv748x_hdmi_pads {
 	ADV748X_HDMI_SINK,
-- 
2.7.4
