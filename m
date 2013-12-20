Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4398 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab3LTJcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 16/50] adv7604: remove connector type. Never used for anything useful.
Date: Fri, 20 Dec 2013 10:31:09 +0100
Message-Id: <1387531903-20496-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

May also be wrong if the receiver is connected to more than one connector.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 4 ----
 include/media/adv7604.h     | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 501f40f..c85f86c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -77,7 +77,6 @@ struct adv7604_state {
 	u32 rgb_quantization_range;
 	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
-	bool connector_hdmi;
 	bool restart_stdi_once;
 	u32 prev_input_status;
 
@@ -1817,8 +1816,6 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip power: %s\n", no_power(sd) ? "off" : "on");
-	v4l2_info(sd, "Connector type: %s\n", state->connector_hdmi ?
-			"HDMI" : (is_digital_input(sd) ? "DVI-D" : "DVI-A"));
 	v4l2_info(sd, "EDID enabled port A: %s, B: %s, C: %s, D: %s\n",
 			((rep_read(sd, 0x7d) & 0x01) ? "Yes" : "No"),
 			((rep_read(sd, 0x7d) & 0x02) ? "Yes" : "No"),
@@ -2138,7 +2135,6 @@ static int adv7604_probe(struct i2c_client *client,
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7604_ops);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-	state->connector_hdmi = pdata->connector_hdmi;
 
 	/* i2c access to adv7604? */
 	if (adv_smbus_read_byte_data_check(client, 0xfb, false) != 0x68) {
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 22fd1ac..baf7250 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -86,9 +86,6 @@ enum adv7604_drive_strength {
 
 /* Platform dependent definition */
 struct adv7604_platform_data {
-	/* connector - HDMI or DVI? */
-	unsigned connector_hdmi:1;
-
 	/* DIS_PWRDNB: 1 if the PWRDNB pin is unused and unconnected */
 	unsigned disable_pwrdnb:1;
 
-- 
1.8.4.4

