Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E77C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E92C120660
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbfAJOC0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 09:02:26 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43593 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbfAJOC0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 09:02:26 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id B035360005;
        Thu, 10 Jan 2019 14:02:23 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 6/6] media: adv748x: Implement TX link_setup callback
Date:   Thu, 10 Jan 2019 15:02:13 +0100
Message-Id: <20190110140213.5198-7-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When the adv748x driver is informed about a link being created from HDMI or
AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
sure to implement proper routing management at link setup time, to route
the selected video stream to the desired TX output.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 48 +++++++++++++++++++++++-
 drivers/media/i2c/adv748x/adv748x.h      |  2 +
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 200e00f93546..ea7e5ca48f1a 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -335,6 +335,51 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
 /* -----------------------------------------------------------------------------
  * Media Operations
  */
+static int adv748x_link_setup(struct media_entity *entity,
+			      const struct media_pad *local,
+			      const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *rsd = media_entity_to_v4l2_subdev(remote->entity);
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct adv748x_state *state = v4l2_get_subdevdata(sd);
+	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
+	bool enable = flags & MEDIA_LNK_FL_ENABLED;
+	u8 io10_mask = ADV748X_IO_10_CSI1_EN |
+		       ADV748X_IO_10_CSI4_EN |
+		       ADV748X_IO_10_CSI4_IN_SEL_AFE;
+	u8 io10 = 0;
+
+	/* Refuse to enable multiple links to the same TX at the same time. */
+	if (enable && tx->src)
+		return -EINVAL;
+
+	/* Set or clear the source (HDMI or AFE) and the current TX. */
+	if (rsd == &state->afe.sd)
+		state->afe.tx = enable ? tx : NULL;
+	else
+		state->hdmi.tx = enable ? tx : NULL;
+
+	tx->src = enable ? rsd : NULL;
+
+	if (state->afe.tx) {
+		/* AFE Requires TXA enabled, even when output to TXB */
+		io10 |= ADV748X_IO_10_CSI4_EN;
+		if (is_txa(tx))
+			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
+		else
+			io10 |= ADV748X_IO_10_CSI1_EN;
+	}
+
+	if (state->hdmi.tx)
+		io10 |= ADV748X_IO_10_CSI4_EN;
+
+	return io_clrset(state, ADV748X_IO_10, io10_mask, io10);
+}
+
+static const struct media_entity_operations adv748x_tx_media_ops = {
+	.link_setup	= adv748x_link_setup,
+	.link_validate	= v4l2_subdev_link_validate,
+};
 
 static const struct media_entity_operations adv748x_media_ops = {
 	.link_validate = v4l2_subdev_link_validate,
@@ -516,7 +561,8 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
 		state->client->addr, ident);
 
 	sd->entity.function = function;
-	sd->entity.ops = &adv748x_media_ops;
+	sd->entity.ops = is_tx(adv748x_sd_to_csi2(sd)) ?
+			 &adv748x_tx_media_ops : &adv748x_media_ops;
 }
 
 static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 934a9d9a75c8..b00c1995efb0 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -94,6 +94,7 @@ struct adv748x_csi2 {
 #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
 #define is_txa(_tx) ((_tx) == &(_tx)->state->txa)
 #define is_txb(_tx) ((_tx) == &(_tx)->state->txb)
+#define is_tx(_tx) (is_txa(_tx) || is_txb(_tx))
 
 #define is_afe_enabled(_state)					\
 	((_state)->endpoints[ADV748X_PORT_AIN0] != NULL ||	\
@@ -223,6 +224,7 @@ struct adv748x_state {
 #define ADV748X_IO_10_CSI4_EN		BIT(7)
 #define ADV748X_IO_10_CSI1_EN		BIT(6)
 #define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
+#define ADV748X_IO_10_CSI4_IN_SEL_AFE	BIT(3)
 
 #define ADV748X_IO_CHIP_REV_ID_1	0xdf
 #define ADV748X_IO_CHIP_REV_ID_2	0xe0
-- 
2.20.1

