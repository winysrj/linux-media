Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3540 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab3LTJcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 25/50] adv7604: initialize timings to CEA 640x480p59.94.
Date: Fri, 20 Dec 2013 10:31:18 +0100
Message-Id: <1387531903-20496-26-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This timing must be supported by all HDMI equipment, so that's a
reasonable default.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index be9699e..71c8570 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2207,6 +2207,8 @@ static struct i2c_client *adv7604_dummy_client(struct v4l2_subdev *sd,
 static int adv7604_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
+	static const struct v4l2_dv_timings cea640x480 =
+		V4L2_DV_BT_CEA_640X480P59_94;
 	struct adv7604_state *state;
 	struct adv7604_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_ctrl_handler *hdl;
@@ -2234,7 +2236,8 @@ static int adv7604_probe(struct i2c_client *client,
 		v4l_err(client, "No platform data!\n");
 		return -ENODEV;
 	}
-	memcpy(&state->pdata, pdata, sizeof(state->pdata));
+	state->pdata = *pdata;
+	state->timings = cea640x480;
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7604_ops);
-- 
1.8.4.4

