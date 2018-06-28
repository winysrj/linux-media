Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34309 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967312AbeF1QWI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:22:08 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 17/22] [media] tvp5150: add g_std callback
Date: Thu, 28 Jun 2018 18:20:49 +0200
Message-Id: <20180628162054.25613-18-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add callback to retrieve the current set norm.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 1990aaa17749..3b51b6b67736 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -756,6 +756,15 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	return 0;
 }
 
+static int tvp5150_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+
+	*std = decoder->norm;
+
+	return 0;
+}
+
 static int tvp5150_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
@@ -1417,6 +1426,7 @@ static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_std = tvp5150_s_std,
+	.g_std = tvp5150_g_std,
 	.querystd = tvp5150_querystd,
 	.s_stream = tvp5150_s_stream,
 	.s_routing = tvp5150_s_routing,
-- 
2.17.1
