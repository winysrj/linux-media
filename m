Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3985 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3LJPGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 12/22] adv7842: remove connector type. Never used for anything useful
Date: Tue, 10 Dec 2013 16:03:58 +0100
Message-Id: <d5e33c296241725ace588f7b488457f5cb5f9b56.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

May also be wrong if the receiver is connected to more than one connector.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 4 ----
 include/media/adv7842.h     | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 60f2320..8e75c3b 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -82,7 +82,6 @@ struct adv7842_state {
 	bool is_cea_format;
 	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
-	bool connector_hdmi;
 	bool hdmi_port_a;
 
 	/* i2c clients */
@@ -2164,8 +2163,6 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
 
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip power: %s\n", no_power(sd) ? "off" : "on");
-	v4l2_info(sd, "Connector type: %s\n", state->connector_hdmi ?
-			"HDMI" : (is_digital_input(sd) ? "DVI-D" : "DVI-A"));
 	v4l2_info(sd, "HDMI/DVI-D port selected: %s\n",
 			state->hdmi_port_a ? "A" : "B");
 	v4l2_info(sd, "EDID A %s, B %s\n",
@@ -2799,7 +2796,6 @@ static int adv7842_probe(struct i2c_client *client,
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7842_ops);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-	state->connector_hdmi = pdata->connector_hdmi;
 	state->mode = pdata->mode;
 
 	state->hdmi_port_a = pdata->input == ADV7842_SELECT_HDMI_PORT_A;
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index c12de2d..24fed11 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -139,9 +139,6 @@ struct adv7842_sdp_io_sync_adjustment {
 
 /* Platform dependent definition */
 struct adv7842_platform_data {
-	/* connector - HDMI or DVI? */
-	unsigned connector_hdmi:1;
-
 	/* chip reset during probe */
 	unsigned chip_reset:1;
 
-- 
1.8.4.rc3

