Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC91C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A345420851
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A345420851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbeLKPQi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:16:38 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:51813 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbeLKPQh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:16:37 -0500
X-Originating-IP: 2.224.242.101
Received: from w540.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id AA350C0004;
        Tue, 11 Dec 2018 15:16:34 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/5] media: adv748x: Store the source subdevice in TX
Date:   Tue, 11 Dec 2018 16:16:11 +0100
Message-Id: <1544541373-30044-4-git-send-email-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The power_up_tx() procedure needs to set a few registers conditionally to
the selected video source, but it currently checks for the provided tx to
be either TXA or TXB.

With the introduction of dynamic routing between HDMI and AFE entities to
TXA, checking which TX the function is operating on is not meaningful anymore.

To fix this, store the subdevice of the source providing video data to the
CSI-2 TX in the 'struct adv748x_csi2' representing the TX and check on it.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 2 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c | 3 +++
 drivers/media/i2c/adv748x/adv748x.h      | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 5495dc7891e8..f3aabbccdfb5 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -254,7 +254,7 @@ static int adv748x_power_up_tx(struct adv748x_csi2 *tx)
 	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
 
 	/* ADI Required Write */
-	if (is_txa(tx)) {
+	if (tx->rsd == &state->hdmi.sd) {
 		adv748x_write_check(state, page, 0xdb, 0x10, &ret);
 		adv748x_write_check(state, page, 0xd6, 0x07, &ret);
 	} else {
diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 4d1aefc2c8d0..307966f4c736 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -46,6 +46,9 @@ static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
 			return ret;
 	}
 
+	if (flags & MEDIA_LNK_FL_ENABLED)
+		tx->rsd = src;
+
 	return media_create_pad_link(&src->entity, src_pad,
 				     &tx->sd.entity, ADV748X_CSI2_SINK,
 				     flags);
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index b482c7fe6957..387002d6da65 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -85,6 +85,7 @@ struct adv748x_csi2 {
 	struct v4l2_ctrl_handler ctrl_hdl;
 	struct v4l2_ctrl *pixel_rate;
 	struct v4l2_subdev sd;
+	struct v4l2_subdev *rsd;
 };
 
 #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
-- 
2.7.4

