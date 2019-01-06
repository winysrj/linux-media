Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D52C43614
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FC7020868
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfAFPy0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 10:54:26 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47597 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfAFPy0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 10:54:26 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 6B9E160004;
        Sun,  6 Jan 2019 15:54:23 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 5/6] media: adv748x: Store the TX sink in HDMI/AFE
Date:   Sun,  6 Jan 2019 16:54:12 +0100
Message-Id: <20190106155413.30666-6-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Both the AFE and HDMI s_stream routines (adv748x_afe_s_stream() and
adv748x_hdmi_s_stream()) have to enable the CSI-2 TX they are streaming video
data to.

With the introduction of dynamic routing between HDMI and AFE entities to
TXA, the video stream sink needs to be set at run time, and not statically
selected as the s_stream functions are currently doing.

To fix this, store a reference to the active CSI-2 TX sink for both HDMI and
AFE sources, and operate on it when starting/stopping the stream.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c | 15 +++++++++++++--
 drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
 drivers/media/i2c/adv748x/adv748x.h      |  4 ++++
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
index 71714634efb0..dbbb1e4d6363 100644
--- a/drivers/media/i2c/adv748x/adv748x-afe.c
+++ b/drivers/media/i2c/adv748x/adv748x-afe.c
@@ -282,7 +282,7 @@ static int adv748x_afe_s_stream(struct v4l2_subdev *sd, int enable)
 			goto unlock;
 	}
 
-	ret = adv748x_tx_power(&state->txb, enable);
+	ret = adv748x_tx_power(afe->tx, enable);
 	if (ret)
 		goto unlock;
 
diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index de3944615e64..c835f6379337 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -88,14 +88,25 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
 						 is_txb(tx));
 		if (ret)
 			return ret;
+
+		/* TXB can output AFE signals only. */
+		if (is_txb(tx))
+			state->afe.tx = tx;
 	}
 
 	/* Register link to HDMI for TXA only. */
 	if (is_txb(tx) || !is_hdmi_enabled(state))
 		return 0;
 
-	return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
-					  ADV748X_HDMI_SOURCE, true);
+	ret = adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
+					 ADV748X_HDMI_SOURCE, true);
+	if (ret)
+		return ret;
+
+	/* The default HDMI output is TXA. */
+	state->hdmi.tx = tx;
+
+	return 0;
 }
 
 static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
index 35d027941482..c557f8fdf11a 100644
--- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
+++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
@@ -358,7 +358,7 @@ static int adv748x_hdmi_s_stream(struct v4l2_subdev *sd, int enable)
 
 	mutex_lock(&state->mutex);
 
-	ret = adv748x_tx_power(&state->txa, enable);
+	ret = adv748x_tx_power(hdmi->tx, enable);
 	if (ret)
 		goto done;
 
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index d8d94053301b..6eb2e4a95eed 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -122,6 +122,8 @@ struct adv748x_hdmi {
 	struct v4l2_dv_timings timings;
 	struct v4l2_fract aspect_ratio;
 
+	struct adv748x_csi2 *tx;
+
 	struct {
 		u8 edid[512];
 		u32 present;
@@ -152,6 +154,8 @@ struct adv748x_afe {
 	struct v4l2_subdev sd;
 	struct v4l2_mbus_framefmt format;
 
+	struct adv748x_csi2 *tx;
+
 	bool streaming;
 	v4l2_std_id curr_norm;
 	unsigned int input;
-- 
2.20.1

