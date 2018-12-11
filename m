Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5F9C5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E92F20851
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E92F20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbeLKPQg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:16:36 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44635 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbeLKPQg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:16:36 -0500
X-Originating-IP: 2.224.242.101
Received: from w540.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 403E8C001C;
        Tue, 11 Dec 2018 15:16:33 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 2/5] media: adv748x: csi2: Link AFE with TXA and TXB
Date:   Tue, 11 Dec 2018 16:16:10 +0100
Message-Id: <1544541373-30044-3-git-send-email-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The ADV748x chip supports routing AFE output to either TXA or TXB.
In order to support run-time configuration of video stream path, create an
additional (not enabled) "AFE:8->TXA:0" link, and remove the IMMUTABLE flag
from existing ones.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 48 ++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 6ce21542ed48..4d1aefc2c8d0 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -27,6 +27,7 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
  * @v4l2_dev: Video registration device
  * @src: Source subdevice to establish link
  * @src_pad: Pad number of source to link to this @tx
+ * @flags: Flags for the newly created link
  *
  * Ensure that the subdevice is registered against the v4l2_device, and link the
  * source pad to the sink pad of the CSI2 bus entity.
@@ -34,17 +35,11 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
 static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
 				      struct v4l2_device *v4l2_dev,
 				      struct v4l2_subdev *src,
-				      unsigned int src_pad)
+				      unsigned int src_pad,
+				      unsigned int flags)
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
+				     flags);
 }

 /* -----------------------------------------------------------------------------
@@ -68,24 +63,41 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
 {
 	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
 	struct adv748x_state *state = tx->state;
+	int ret;

 	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
 			sd->name);

 	/*
-	 * The adv748x hardware allows the AFE to route through the TXA, however
-	 * this is not currently supported in this driver.
+	 * Link TXA to HDMI and AFE, and TXB to AFE only as TXB cannot output
+	 * HDMI.
 	 *
-	 * Link HDMI->TXA, and AFE->TXB directly.
+	 * The HDMI->TXA link is enabled by default, as the AFE->TXB is.
 	 */
-	if (is_txa(tx) && is_hdmi_enabled(state))
-		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
-						  &state->hdmi.sd,
-						  ADV748X_HDMI_SOURCE);
-	if (!is_txa(tx) && is_afe_enabled(state))
+	if (is_txa(tx)) {
+		if (is_hdmi_enabled(state)) {
+			ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
+							 &state->hdmi.sd,
+							 ADV748X_HDMI_SOURCE,
+							 MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+		}
+
+		if (is_afe_enabled(state)) {
+			ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
+							 &state->afe.sd,
+							 ADV748X_AFE_SOURCE,
+							 0);
+			if (ret)
+				return ret;
+		}
+	} else if (is_afe_enabled(state))
 		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
 						  &state->afe.sd,
-						  ADV748X_AFE_SOURCE);
+						  ADV748X_AFE_SOURCE,
+						  MEDIA_LNK_FL_ENABLED);
+
 	return 0;
 }

--
2.7.4

