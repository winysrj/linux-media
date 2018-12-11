Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB4EC5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC60F20851
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC60F20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbeLKPQk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:16:40 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:51813 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbeLKPQj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:16:39 -0500
X-Originating-IP: 2.224.242.101
Received: from w540.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 7EACCC0014;
        Tue, 11 Dec 2018 15:16:37 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 5/5] media: adv748x: Implement link_setup callback
Date:   Tue, 11 Dec 2018 16:16:13 +0100
Message-Id: <1544541373-30044-6-git-send-email-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
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
 drivers/media/i2c/adv748x/adv748x-core.c | 63 +++++++++++++++++++++++++++++++-
 drivers/media/i2c/adv748x/adv748x.h      |  1 +
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index f3aabbccdfb5..08dc0e89b053 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -335,9 +335,70 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
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
+	struct adv748x_csi2 *tx;
+	struct media_link *link;
+	u8 io10;
+
+	/*
+	 * For each link setup from [HDMI|AFE] to TX we receive two
+	 * notifications: "[HDMI|AFE]->TX" and "TX<-[HDMI|AFE]".
+	 *
+	 * Use the second notification form to make sure we're linking
+	 * to a TX and find out from where, to set up routing properly.
+	 */
+	if ((sd != &state->txa.sd && sd != &state->txb.sd) ||
+	    !(flags & MEDIA_LNK_FL_ENABLED))
+		return 0;
+	tx = adv748x_sd_to_csi2(sd);
+
+	/*
+	 * Now that we're sure we're operating on one of the two TXs,
+	 * make sure there are no enabled links ending there from
+	 * either HDMI or AFE (this can only happens for TXA though).
+	 */
+	if (is_txa(tx))
+		list_for_each_entry(link, &entity->links, list)
+			if (link->sink->entity == entity &&
+			    link->flags & MEDIA_LNK_FL_ENABLED)
+				return -EINVAL;
+
+	/* Change video stream routing, according to the newly created link. */
+	io10 = io_read(state, ADV748X_IO_10);
+	if (rsd == &state->afe.sd) {
+		state->afe.tx = tx;
+
+		/*
+		 * If AFE is routed to TXA, make sure TXB is off;
+		 * If AFE goes to TXB, we need TXA powered on.
+		 */
+		if (is_txa(tx)) {
+			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
+			io10 &= ~ADV748X_IO_10_CSI1_EN;
+		} else {
+			io10 |= ADV748X_IO_10_CSI4_EN |
+				ADV748X_IO_10_CSI1_EN;
+		}
+	} else {
+		state->hdmi.tx = tx;
+		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
+	}
+	io_write(state, ADV748X_IO_10, io10);
+
+	tx->rsd = rsd;
+
+	return 0;
+}
 
 static const struct media_entity_operations adv748x_media_ops = {
-	.link_validate = v4l2_subdev_link_validate,
+	.link_setup	= adv748x_link_setup,
+	.link_validate	= v4l2_subdev_link_validate,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 0ee3b8d5c795..63a17c31c169 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -220,6 +220,7 @@ struct adv748x_state {
 #define ADV748X_IO_10_CSI4_EN		BIT(7)
 #define ADV748X_IO_10_CSI1_EN		BIT(6)
 #define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
+#define ADV748X_IO_10_CSI4_IN_SEL_AFE	0x08
 
 #define ADV748X_IO_CHIP_REV_ID_1	0xdf
 #define ADV748X_IO_CHIP_REV_ID_2	0xe0
-- 
2.7.4

