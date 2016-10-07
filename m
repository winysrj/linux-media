Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50767 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936361AbcJGQBT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:19 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 12/22] [media] tc358743: put lanes in STOP state before starting streaming
Date: Fri,  7 Oct 2016 18:00:57 +0200
Message-Id: <20161007160107.5074-13-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without calling tc358743_set_csi from the new prepare_stream callback
(or calling tc358743_s_dv_timings or tc358743_set_fmt from userspace
after stopping the stream), the i.MX6 MIPI CSI2 input fails waiting
for lanes to enter STOP state when streaming is started again.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 1e3a0dd2..dfa45d2 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1463,6 +1463,14 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int tc358743_prepare_stream(struct v4l2_subdev *sd)
+{
+	/* Put all lanes in PL-11 state (STOPSTATE) */
+	tc358743_set_csi(sd);
+
+	return 0;
+}
+
 static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	enable_stream(sd, enable);
@@ -1637,6 +1645,7 @@ static const struct v4l2_subdev_video_ops tc358743_video_ops = {
 	.g_dv_timings = tc358743_g_dv_timings,
 	.query_dv_timings = tc358743_query_dv_timings,
 	.g_mbus_config = tc358743_g_mbus_config,
+	.prepare_stream = tc358743_prepare_stream,
 	.s_stream = tc358743_s_stream,
 };
 
-- 
2.9.3

