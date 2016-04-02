Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:45180 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcDBRm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2016 13:42:58 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-renesas-soc@vger.kernel.org, lars@metafoo.de,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 1/3] [media] adv7180: Add g_std operation
Date: Sat,  2 Apr 2016 19:42:18 +0200
Message-Id: <1459618940-8170-2-git-send-email-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
References: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support to get the standard to the adv7180 driver.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv7180.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index ff57c1d..d680d76 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -434,6 +434,15 @@ out:
 	return ret;
 }
 
+static int adv7180_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
+{
+	struct adv7180_state *state = to_state(sd);
+
+	*norm = state->curr_norm;
+
+	return 0;
+}
+
 static int adv7180_set_power(struct adv7180_state *state, bool on)
 {
 	u8 val;
@@ -719,6 +728,7 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.s_std = adv7180_s_std,
+	.g_std = adv7180_g_std,
 	.querystd = adv7180_querystd,
 	.g_input_status = adv7180_g_input_status,
 	.s_routing = adv7180_s_routing,
-- 
2.7.4

