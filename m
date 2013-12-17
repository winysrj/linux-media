Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1094 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3LQNT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 08:19:56 -0500
Message-ID: <52B04F02.1000507@xs4all.nl>
Date: Tue, 17 Dec 2013 14:17:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 25/22] adv7842: initialize timings to CEA 640x480p59.94.
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl> <9e9eaa702db4b0e0626dbf7200578e66d8281312.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <9e9eaa702db4b0e0626dbf7200578e66d8281312.1386687810.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This timing must be supported by all HDMI equipment, so that's a
reasonable default.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 2eb4058..4bd6915 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2930,6 +2930,8 @@ static int adv7842_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct adv7842_state *state;
+	static const struct v4l2_dv_timings cea640x480 =
+		V4L2_DV_BT_CEA_640X480P59_94;
 	struct adv7842_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_subdev *sd;
@@ -2956,6 +2958,7 @@ static int adv7842_probe(struct i2c_client *client,
 
 	/* platform data */
 	state->pdata = *pdata;
+	state->timings = cea640x480;
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7842_ops);
-- 
1.8.4.rc3


