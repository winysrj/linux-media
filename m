Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1B7C43612
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04D0420660
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbfAJOCX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 09:02:23 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34587 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbfAJOCX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 09:02:23 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id B6BF660013;
        Thu, 10 Jan 2019 14:02:19 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 3/6] media: adv748x: csi2: Link AFE with TXA and TXB
Date:   Thu, 10 Jan 2019 15:02:10 +0100
Message-Id: <20190110140213.5198-4-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The ADV748x chip supports routing AFE output to either TXA or TXB.
In order to support run-time configuration of video stream path, create an
additional (not enabled) "AFE:8->TXA:0" link, and remove the IMMUTABLE flag
from existing ones.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 44 +++++++++++++-----------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index b6b5d8c7ea7c..8c3714495e11 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -27,6 +27,7 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
  * @v4l2_dev: Video registration device
  * @src: Source subdevice to establish link
  * @src_pad: Pad number of source to link to this @tx
+ * @enable: Link enabled flag
  *
  * Ensure that the subdevice is registered against the v4l2_device, and link the
  * source pad to the sink pad of the CSI2 bus entity.
@@ -34,17 +35,11 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
 static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
 				      struct v4l2_device *v4l2_dev,
 				      struct v4l2_subdev *src,
-				      unsigned int src_pad)
+				      unsigned int src_pad,
+				      bool enable)
 {
-	int enabled = MEDIA_LNK_FL_ENABLED;
 	int ret;
 
-	/*
-	 * Dynamic linking of the AFE is not supported.
-	 * Register the links as immutable.
-	 */
-	enabled |= MEDIA_LNK_FL_IMMUTABLE;
-
 	if (!src->v4l2_dev) {
 		ret = v4l2_device_register_subdev(v4l2_dev, src);
 		if (ret)
@@ -53,7 +48,7 @@ static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
 
 	return media_create_pad_link(&src->entity, src_pad,
 				     &tx->sd.entity, ADV748X_CSI2_SINK,
-				     enabled);
+				     enable ? MEDIA_LNK_FL_ENABLED : 0);
 }
 
 /* -----------------------------------------------------------------------------
@@ -68,25 +63,32 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
 {
 	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
 	struct adv748x_state *state = tx->state;
+	int ret;
 
 	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
 			sd->name);
 
 	/*
-	 * The adv748x hardware allows the AFE to route through the TXA, however
-	 * this is not currently supported in this driver.
+	 * Link TXA to AFE and HDMI, and TXB to AFE only as TXB cannot output
+	 * HDMI.
 	 *
-	 * Link HDMI->TXA, and AFE->TXB directly.
+	 * The HDMI->TXA link is enabled by default, as is the AFE->TXB one.
 	 */
-	if (is_txa(tx) && is_hdmi_enabled(state))
-		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
-						  &state->hdmi.sd,
-						  ADV748X_HDMI_SOURCE);
-	if (is_txb(tx) && is_afe_enabled(state))
-		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
-						  &state->afe.sd,
-						  ADV748X_AFE_SOURCE);
-	return 0;
+	if (is_afe_enabled(state)) {
+		ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
+						 &state->afe.sd,
+						 ADV748X_AFE_SOURCE,
+						 is_txb(tx));
+		if (ret)
+			return ret;
+	}
+
+	/* Register link to HDMI for TXA only. */
+	if (is_txb(tx) || !is_hdmi_enabled(state))
+		return 0;
+
+	return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
+					  ADV748X_HDMI_SOURCE, true);
 }
 
 static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
-- 
2.20.1

