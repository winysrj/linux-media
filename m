Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56671 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754270AbdBHLOZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Feb 2017 06:14:25 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] [media] tc358743: put lanes in STOP state before starting streaming
Date: Wed,  8 Feb 2017 11:53:37 +0100
Message-Id: <20170208105338.4100-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without calling tc358743_set_csi after stopping streaming (or calling
tc358743_s_dv_timings or tc358743_set_fmt from userspace after stopping
the stream), the i.MX6 MIPI CSI2 input fails waiting for lanes to enter
STOP state when streaming is started again.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index f569a05fe1054..64a97bbbd00a8 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1459,6 +1459,10 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	enable_stream(sd, enable);
+	if (!enable) {
+		/* Put all lanes in PL-11 state (STOPSTATE) */
+		tc358743_set_csi(sd);
+	}
 
 	return 0;
 }
-- 
2.11.0

