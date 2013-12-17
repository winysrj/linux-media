Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4750 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3LQNRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 08:17:43 -0500
Message-ID: <52B04E7D.8020004@xs4all.nl>
Date: Tue, 17 Dec 2013 14:15:41 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 18/15] adv7604: initialize timings to CEA 640x480p59.94.
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl> <785a2a2445d00fa190ea7cea4671c43fb68e2da5.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <785a2a2445d00fa190ea7cea4671c43fb68e2da5.1386681716.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This timing must be supported by all HDMI equipment, so that's a
reasonable default.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 3f40616..f063162 100644
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
1.8.4.rc3


