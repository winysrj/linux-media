Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D88C43444
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A94E20868
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfAFPyY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 10:54:24 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40351 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfAFPyY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 10:54:24 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 3D1A860003;
        Sun,  6 Jan 2019 15:54:22 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 4/6] media: adv748x: Store the source subdevice in TX
Date:   Sun,  6 Jan 2019 16:54:11 +0100
Message-Id: <20190106155413.30666-5-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
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
index 9d391d6f752e..de3944615e64 100644
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
index bc2da1b5ce29..d8d94053301b 100644
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

