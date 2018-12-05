Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A3BC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6922920892
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:14:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6922920892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbeLEQOZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 11:14:25 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53349 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbeLEQOZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 11:14:25 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7] helo=dude.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gUZoe-0004HI-6Z; Wed, 05 Dec 2018 17:14:24 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v3 1/2] media: tc358743: fix connected/active CSI-2 lane reporting
Date:   Wed,  5 Dec 2018 17:14:13 +0100
Message-Id: <20181205161414.29812-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

g_mbus_config was supposed to indicate all supported lane numbers, not
only the number of those currently in active use. Since the TC358743
can dynamically reduce the number of active lanes if the required
bandwidth allows for it, report all lane numbers up to the connected
number of lanes as supported in pdata mode.
In device tree mode, do not report lane count and clock mode at all, as
the receiver driver can determine these from the device tree.

To allow communicating the number of currently active lanes, add a new
bitfield to the v4l2_mbus_config flags. This is a temporary fix, to be
used only until a better solution is found.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
Changes since v2 [1]:
 - Rebased onto media/master

[1] https://patchwork.kernel.org/patch/9964141/
---
 drivers/media/i2c/tc358743.c  | 30 ++++++++++++++++--------------
 include/media/v4l2-mediabus.h |  9 +++++++++
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 00dc930e049f..b1e1ed4d9e0c 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1606,28 +1606,29 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 			     struct v4l2_mbus_config *cfg)
 {
 	struct tc358743_state *state = to_state(sd);
+	const u32 mask = V4L2_MBUS_CSI2_LANE_MASK;
+
+	if (state->csi_lanes_in_use > state->bus.num_data_lanes)
+		return -EINVAL;
 
 	cfg->type = V4L2_MBUS_CSI2_DPHY;
+	cfg->flags = (state->csi_lanes_in_use << __ffs(mask)) & mask;
 
-	/* Support for non-continuous CSI-2 clock is missing in the driver */
-	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	/* In DT mode, only report the number of active lanes */
+	if (sd->dev->of_node)
+		return 0;
 
-	switch (state->csi_lanes_in_use) {
-	case 1:
+	/* Support for non-continuous CSI-2 clock is missing in pdata mode */
+	cfg->flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+
+	if (state->bus.num_data_lanes > 0)
 		cfg->flags |= V4L2_MBUS_CSI2_1_LANE;
-		break;
-	case 2:
+	if (state->bus.num_data_lanes > 1)
 		cfg->flags |= V4L2_MBUS_CSI2_2_LANE;
-		break;
-	case 3:
+	if (state->bus.num_data_lanes > 2)
 		cfg->flags |= V4L2_MBUS_CSI2_3_LANE;
-		break;
-	case 4:
+	if (state->bus.num_data_lanes > 3)
 		cfg->flags |= V4L2_MBUS_CSI2_4_LANE;
-		break;
-	default:
-		return -EINVAL;
-	}
 
 	return 0;
 }
@@ -2053,6 +2054,7 @@ static int tc358743_probe(struct i2c_client *client,
 	if (pdata) {
 		state->pdata = *pdata;
 		state->bus.flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+		state->bus.num_data_lanes = 4;
 	} else {
 		err = tc358743_probe_of(state);
 		if (err == -ENODEV)
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 66cb746ceeb5..e127e3d1740e 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -71,6 +71,15 @@
 					 V4L2_MBUS_CSI2_CHANNEL_2 | \
 					 V4L2_MBUS_CSI2_CHANNEL_3)
 
+/*
+ * Number of lanes in use, 0 == use all available lanes (default)
+ *
+ * This is a temporary fix for devices that need to reduce the number of active
+ * lanes for certain modes, until g_mbus_config() can be replaced with a better
+ * solution.
+ */
+#define V4L2_MBUS_CSI2_LANE_MASK                (0xf << 10)
+
 /**
  * enum v4l2_mbus_type - media bus type
  * @V4L2_MBUS_UNKNOWN:	unknown bus type, no V4L2 mediabus configuration
-- 
2.19.1

