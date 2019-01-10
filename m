Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04048C43613
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3FB120660
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfAJOCY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 09:02:24 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39281 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbfAJOCX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 09:02:23 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 0D5EB60016;
        Thu, 10 Jan 2019 14:02:20 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 4/6] media: adv748x: Store the source subdevice in TX
Date:   Thu, 10 Jan 2019 15:02:11 +0100
Message-Id: <20190110140213.5198-5-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c |  2 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c | 13 ++++++++++---
 drivers/media/i2c/adv748x/adv748x.h      |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index ad4e6424753a..200e00f93546 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -254,7 +254,7 @@ static int adv748x_power_up_tx(struct adv748x_csi2 *tx)
 	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
 
 	/* ADI Required Write */
-	if (is_txa(tx)) {
+	if (tx->src == &state->hdmi.sd) {
 		adv748x_write_check(state, page, 0xdb, 0x10, &ret);
 		adv748x_write_check(state, page, 0xd6, 0x07, &ret);
 	} else {
diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 8c3714495e11..353b6b9bf6a7 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -46,9 +46,16 @@ static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
 			return ret;
 	}
 
-	return media_create_pad_link(&src->entity, src_pad,
-				     &tx->sd.entity, ADV748X_CSI2_SINK,
-				     enable ? MEDIA_LNK_FL_ENABLED : 0);
+	ret = media_create_pad_link(&src->entity, src_pad,
+				    &tx->sd.entity, ADV748X_CSI2_SINK,
+				    enable ? MEDIA_LNK_FL_ENABLED : 0);
+	if (ret)
+		return ret;
+
+	if (enable)
+		tx->src = src;
+
+	return 0;
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index ab0c84adbea9..d22270f5e2c1 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -84,6 +84,7 @@ struct adv748x_csi2 {
 	struct media_pad pads[ADV748X_CSI2_NR_PADS];
 	struct v4l2_ctrl_handler ctrl_hdl;
 	struct v4l2_ctrl *pixel_rate;
+	struct v4l2_subdev *src;
 	struct v4l2_subdev sd;
 };
 
-- 
2.20.1

