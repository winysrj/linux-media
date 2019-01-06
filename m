Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A089C43612
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D87AA20868
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfAFPy2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 10:54:28 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35463 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfAFPy1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 10:54:27 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 94B9360005;
        Sun,  6 Jan 2019 15:54:24 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 6/6] media: adv748x: Implement TX link_setup callback
Date:   Sun,  6 Jan 2019 16:54:13 +0100
Message-Id: <20190106155413.30666-7-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
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
 drivers/media/i2c/adv748x/adv748x-core.c | 57 +++++++++++++++++++++++-
 drivers/media/i2c/adv748x/adv748x.h      |  2 +
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 200e00f93546..a586bf393558 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -335,6 +335,60 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
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
+	u8 io10;
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
+	if (!enable)
+		return 0;
+
+	/* Change video stream routing, according to the newly enabled link. */
+	io10 = io_read(state, ADV748X_IO_10);
+	if (rsd == &state->afe.sd) {
+		/*
+		 * Set AFE->TXA routing and power off TXB if AFE goes to TXA.
+		 * if AFE goes to TXB, we need both TXA and TXB powered on.
+		 */
+		io10 &= ~ADV748X_IO_10_CSI1_EN;
+		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
+		if (is_txa(tx))
+			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
+		else
+			io10 |= ADV748X_IO_10_CSI4_EN |
+				ADV748X_IO_10_CSI1_EN;
+	} else {
+		/* Clear AFE->TXA routing and power up TXA. */
+		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
+		io10 |= ADV748X_IO_10_CSI4_EN;
+	}
+	io_write(state, ADV748X_IO_10, io10);
+
+	return 0;
+}
+
+static const struct media_entity_operations adv748x_tx_media_ops = {
+	.link_setup	= adv748x_link_setup,
+	.link_validate	= v4l2_subdev_link_validate,
+};
 
 static const struct media_entity_operations adv748x_media_ops = {
 	.link_validate = v4l2_subdev_link_validate,
@@ -516,7 +570,8 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
 		state->client->addr, ident);
 
 	sd->entity.function = function;
-	sd->entity.ops = &adv748x_media_ops;
+	sd->entity.ops = is_tx(adv748x_sd_to_csi2(sd)) ?
+			 &adv748x_tx_media_ops : &adv748x_media_ops;
 }
 
 static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 6eb2e4a95eed..eb19c6cbbb4e 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -93,6 +93,7 @@ struct adv748x_csi2 {
 
 #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
 #define __is_tx(_tx, _ab) ((_tx) == &(_tx)->state->tx##_ab)
+#define is_tx(_tx) (is_txa(_tx) || is_txb(_tx))
 #define is_txa(_tx) __is_tx(_tx, a)
 #define is_txb(_tx) __is_tx(_tx, b)
 
@@ -224,6 +225,7 @@ struct adv748x_state {
 #define ADV748X_IO_10_CSI4_EN		BIT(7)
 #define ADV748X_IO_10_CSI1_EN		BIT(6)
 #define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
+#define ADV748X_IO_10_CSI4_IN_SEL_AFE	BIT(3)
 
 #define ADV748X_IO_CHIP_REV_ID_1	0xdf
 #define ADV748X_IO_CHIP_REV_ID_2	0xe0
-- 
2.20.1

