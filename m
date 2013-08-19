Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3359 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3HSOom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/20] adv7604: debounce "format change" notifications
Date: Mon, 19 Aug 2013 16:44:11 +0200
Message-Id: <1376923469-30694-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

The bridge driver is only notified when the input status has changed
since the previous interrupt.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 3ec7ec0..d093092 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -77,6 +77,7 @@ struct adv7604_state {
 	struct delayed_work delayed_work_enable_hotplug;
 	bool connector_hdmi;
 	bool restart_stdi_once;
+	u32 prev_input_status;
 
 	/* i2c clients */
 	struct i2c_client *i2c_avlink;
@@ -1535,6 +1536,7 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
 	struct adv7604_state *state = to_state(sd);
 	u8 fmt_change, fmt_change_digital, tx_5v;
+	u32 input_status;
 
 	/* format change */
 	fmt_change = io_read(sd, 0x43) & 0x98;
@@ -1545,9 +1547,18 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 		io_write(sd, 0x6c, fmt_change_digital);
 	if (fmt_change || fmt_change_digital) {
 		v4l2_dbg(1, debug, sd,
-			"%s: ADV7604_FMT_CHANGE, fmt_change = 0x%x, fmt_change_digital = 0x%x\n",
+			"%s: fmt_change = 0x%x, fmt_change_digital = 0x%x\n",
 			__func__, fmt_change, fmt_change_digital);
-		v4l2_subdev_notify(sd, ADV7604_FMT_CHANGE, NULL);
+
+		adv7604_g_input_status(sd, &input_status);
+		if (input_status != state->prev_input_status) {
+			v4l2_dbg(1, debug, sd,
+				"%s: input_status = 0x%x, prev_input_status = 0x%x\n",
+				__func__, input_status, state->prev_input_status);
+			state->prev_input_status = input_status;
+			v4l2_subdev_notify(sd, ADV7604_FMT_CHANGE, NULL);
+		}
+
 		if (handled)
 			*handled = true;
 	}
@@ -1953,6 +1964,10 @@ static int adv7604_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
+	/* initialize variables */
+	state->restart_stdi_once = true;
+	state->prev_input_status = ~0;
+
 	/* platform data */
 	if (!pdata) {
 		v4l_err(client, "No platform data!\n");
@@ -2036,7 +2051,6 @@ static int adv7604_probe(struct i2c_client *client,
 		v4l2_err(sd, "failed to create all i2c clients\n");
 		goto err_i2c;
 	}
-	state->restart_stdi_once = true;
 
 	/* work queues */
 	state->work_queues = create_singlethread_workqueue(client->name);
-- 
1.8.3.2

