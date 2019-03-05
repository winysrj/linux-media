Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EC2C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2E4F208E4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfCESwF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:52:05 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:60353 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfCESwE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:52:04 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 135EE200002;
        Tue,  5 Mar 2019 18:52:00 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 24/31] adv748x: csi2: only allow formats on sink pads
Date:   Tue,  5 Mar 2019 19:51:43 +0100
Message-Id: <20190305185150.20776-25-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Once the CSI-2 subdevice of the ADV748X becomes aware of multiplexed
streams the format of the source pad is of no value as it carries
multiple streams. Prepare for this by explicitly denying setting a
format on anything but the sink pad.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 25798d723174..1abe34183d7d 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -183,6 +183,9 @@ static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
 	struct adv748x_state *state = tx->state;
 	struct v4l2_mbus_framefmt *mbusformat;
 
+	if (sdformat->pad != ADV748X_CSI2_SINK)
+		return -EINVAL;
+
 	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
 						 sdformat->which);
 	if (!mbusformat)
@@ -206,6 +209,9 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *mbusformat;
 	int ret = 0;
 
+	if (sdformat->pad != ADV748X_CSI2_SINK)
+		return -EINVAL;
+
 	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
 						 sdformat->which);
 	if (!mbusformat)
@@ -213,24 +219,8 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
 
 	mutex_lock(&state->mutex);
 
-	if (sdformat->pad == ADV748X_CSI2_SOURCE) {
-		const struct v4l2_mbus_framefmt *sink_fmt;
-
-		sink_fmt = adv748x_csi2_get_pad_format(sd, cfg,
-						       ADV748X_CSI2_SINK,
-						       sdformat->which);
-
-		if (!sink_fmt) {
-			ret = -EINVAL;
-			goto unlock;
-		}
-
-		sdformat->format = *sink_fmt;
-	}
-
 	*mbusformat = sdformat->format;
 
-unlock:
 	mutex_unlock(&state->mutex);
 
 	return ret;
-- 
2.20.1

