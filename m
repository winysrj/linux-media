Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2440 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab3LTJcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 49/50] adv7842: initialize timings to CEA 640x480p59.94.
Date: Fri, 20 Dec 2013 10:31:42 +0100
Message-Id: <1387531903-20496-50-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This timing must be supported by all HDMI equipment, so that's a
reasonable default.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 7898686..515a870 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2936,6 +2936,8 @@ static int adv7842_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct adv7842_state *state;
+	static const struct v4l2_dv_timings cea640x480 =
+		V4L2_DV_BT_CEA_640X480P59_94;
 	struct adv7842_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_subdev *sd;
@@ -2962,6 +2964,7 @@ static int adv7842_probe(struct i2c_client *client,
 
 	/* platform data */
 	state->pdata = *pdata;
+	state->timings = cea640x480;
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7842_ops);
-- 
1.8.4.4

