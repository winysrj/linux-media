Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51321 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967320AbeF1QWA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:22:00 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 16/22] [media] tvp5150: add querystd
Date: Thu, 28 Jun 2018 18:20:48 +0200
Message-Id: <20180628162054.25613-17-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

Add the querystd video_op and make it return V4L2_STD_UNKNOWN while the
TVP5150 is not locked to a signal.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 99d887936ea0..1990aaa17749 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -796,6 +796,15 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 	}
 }
 
+static int tvp5150_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+
+	*std_id = decoder->lock ? tvp5150_read_std(sd) : V4L2_STD_UNKNOWN;
+
+	return 0;
+}
+
 static const struct v4l2_event tvp5150_ev_fmt = {
 	.type = V4L2_EVENT_SOURCE_CHANGE,
 	.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
@@ -1408,6 +1417,7 @@ static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_std = tvp5150_s_std,
+	.querystd = tvp5150_querystd,
 	.s_stream = tvp5150_s_stream,
 	.s_routing = tvp5150_s_routing,
 	.g_mbus_config = tvp5150_g_mbus_config,
-- 
2.17.1
