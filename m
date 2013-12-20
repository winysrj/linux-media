Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4696 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3LTJcH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 36/50] adv7842: remove connector type. Never used for anything useful
Date: Fri, 20 Dec 2013 10:31:29 +0100
Message-Id: <1387531903-20496-37-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
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
index f16437c..ab44897 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -82,7 +82,6 @@ struct adv7842_state {
 	bool is_cea_format;
 	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
-	bool connector_hdmi;
 	bool hdmi_port_a;
 
 	/* i2c clients */
@@ -2166,8 +2165,6 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
 
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip power: %s\n", no_power(sd) ? "off" : "on");
-	v4l2_info(sd, "Connector type: %s\n", state->connector_hdmi ?
-			"HDMI" : (is_digital_input(sd) ? "DVI-D" : "DVI-A"));
 	v4l2_info(sd, "HDMI/DVI-D port selected: %s\n",
 			state->hdmi_port_a ? "A" : "B");
 	v4l2_info(sd, "EDID A %s, B %s\n",
@@ -2801,7 +2798,6 @@ static int adv7842_probe(struct i2c_client *client,
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
1.8.4.4

