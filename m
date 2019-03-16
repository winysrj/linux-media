Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E93C10F0C
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B876218E0
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfCPPrl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 11:47:41 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:35781 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfCPPrl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 11:47:41 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id E6F9C1BF20E;
        Sat, 16 Mar 2019 15:47:37 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dave.stevenson@raspberrypi.org
Subject: [RFC 3/5] media: adv748x: Make lanes number depend on routing
Date:   Sat, 16 Mar 2019 16:47:59 +0100
Message-Id: <20190316154801.20460-4-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use the TXA routing information to configure the number of active CSI-2
data lanes. When routing AFE through TXA limit the number of data lanes
to 1, while in the canonical HDMI->TXA routing use all the physically
available ones.

The number of lanes collected from the 'data-lanes' DT property is now
used as a the number of physically available data lanes, while the
'num_lanes' variable contains the number of active ones.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 19 ++++++++++++++++++-
 drivers/media/i2c/adv748x/adv748x.h      |  1 +
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 02135741b1a6..f91c7b83f1bf 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -350,6 +350,8 @@ static int adv748x_link_setup(struct media_entity *entity,
 	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
 	bool enable = flags & MEDIA_LNK_FL_ENABLED;
 	u8 csi4_in_sel = 0;
+	u8 num_lanes;
+	int ret;
 
 	/* Refuse to enable multiple links to the same TX at the same time. */
 	if (enable && tx->src)
@@ -373,10 +375,23 @@ static int adv748x_link_setup(struct media_entity *entity,
 			csi4_in_sel |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
 		else
 			csi4_in_sel |= ADV748X_IO_10_CSI1_EN;
+
+		num_lanes = 1;
 	}
 
-	if (state->hdmi.tx)
+	if (state->hdmi.tx) {
 		csi4_in_sel |= ADV748X_IO_10_CSI4_EN;
+		num_lanes = tx->available_lanes;
+	}
+
+	/* Update the number of active lanes if it has changed. */
+	if (num_lanes != tx->num_lanes) {
+		tx->num_lanes = num_lanes;
+		ret = adv748x_write(state, tx->page, 0x00,
+				    0x80 | tx->num_lanes);
+		if (ret)
+			return ret;
+	}
 
 	state->csi4_in_sel = csi4_in_sel;
 
@@ -608,6 +623,7 @@ static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
 		}
 
 		state->txa.num_lanes = num_lanes;
+		state->txa.available_lanes = num_lanes;
 		adv_dbg(state, "TXA: using %u lanes\n", state->txa.num_lanes);
 	}
 
@@ -619,6 +635,7 @@ static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
 		}
 
 		state->txb.num_lanes = num_lanes;
+		state->txb.available_lanes = num_lanes;
 		adv_dbg(state, "TXB: using %u lanes\n", state->txb.num_lanes);
 	}
 
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 27c116d09284..6e5c2cb421fe 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -80,6 +80,7 @@ struct adv748x_csi2 {
 	unsigned int page;
 	unsigned int port;
 	unsigned int num_lanes;
+	unsigned int available_lanes;
 
 	struct media_pad pads[ADV748X_CSI2_NR_PADS];
 	struct v4l2_ctrl_handler ctrl_hdl;
-- 
2.21.0

