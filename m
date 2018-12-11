Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B3EC07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B09622084E
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B09622084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbeLKPQj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:16:39 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44635 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbeLKPQj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:16:39 -0500
X-Originating-IP: 2.224.242.101
Received: from w540.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 226CAC0005;
        Tue, 11 Dec 2018 15:16:35 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 4/5] media: adv748x: Store the TX sink in HDMI/AFE
Date:   Tue, 11 Dec 2018 16:16:12 +0100
Message-Id: <1544541373-30044-5-git-send-email-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
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

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c | 19 ++++++++++++++-----
 drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
 drivers/media/i2c/adv748x/adv748x.h      |  4 ++++
 4 files changed, 20 insertions(+), 7 deletions(-)

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
index 307966f4c736..0d6344a51795 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -85,6 +85,9 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
 							 MEDIA_LNK_FL_ENABLED);
 			if (ret)
 				return ret;
+
+			/* The default HDMI output is TXA. */
+			state->hdmi.tx = tx;
 		}
 
 		if (is_afe_enabled(state)) {
@@ -95,11 +98,17 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
 			if (ret)
 				return ret;
 		}
-	} else if (is_afe_enabled(state))
-		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
-						  &state->afe.sd,
-						  ADV748X_AFE_SOURCE,
-						  MEDIA_LNK_FL_ENABLED);
+	} else if (is_afe_enabled(state)) {
+		ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
+						 &state->afe.sd,
+						 ADV748X_AFE_SOURCE,
+						 MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+
+		/* The default AFE output is TXB. */
+		state->afe.tx = tx;
+	}
 
 	return 0;
 }
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
index 387002d6da65..0ee3b8d5c795 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -118,6 +118,8 @@ struct adv748x_hdmi {
 	struct v4l2_dv_timings timings;
 	struct v4l2_fract aspect_ratio;
 
+	struct adv748x_csi2 *tx;
+
 	struct {
 		u8 edid[512];
 		u32 present;
@@ -148,6 +150,8 @@ struct adv748x_afe {
 	struct v4l2_subdev sd;
 	struct v4l2_mbus_framefmt format;
 
+	struct adv748x_csi2 *tx;
+
 	bool streaming;
 	v4l2_std_id curr_norm;
 	unsigned int input;
-- 
2.7.4

