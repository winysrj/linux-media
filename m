Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:51001 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751666AbdBMJYl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 04:24:41 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mats Randgaard <matrandg@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/2] [media] tc358743: put lanes in STOP state before starting streaming
Date: Mon, 13 Feb 2017 10:24:36 +0100
Message-Id: <1486977877-26206-1-git-send-email-p.zabel@pengutronix.de>
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
