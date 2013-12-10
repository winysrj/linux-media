Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2809 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab3LJNZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 11/15] adv7604: remove debouncing of ADV7604_FMT_CHANGE events
Date: Tue, 10 Dec 2013 14:23:16 +0100
Message-Id: <c45feeec3d9d029208672ec398e90c644c2f38ad.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
References: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

ADV7604_FMT_CHANGE events was debounced in adv7604_isr() to avoid
that a receiver with a unstable input signal would block the event
handling for other inputs. This solution was prone to errors.

A better protection agains interrupt blocking is to delay the call
of the interrupt service routine in the adv7604 driver if too many
interrupts are received within a given time.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index fa98229..50f0279 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -78,7 +78,6 @@ struct adv7604_state {
 	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
 	bool restart_stdi_once;
-	u32 prev_input_status;
 
 	/* i2c clients */
 	struct i2c_client *i2c_avlink;
@@ -1524,9 +1523,7 @@ static int adv7604_g_mbus_fmt(struct v4l2_subdev *sd,
 
 static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
-	struct adv7604_state *state = to_state(sd);
 	u8 fmt_change, fmt_change_digital, tx_5v;
-	u32 input_status;
 
 	v4l2_dbg(2, debug, sd, "%s: ", __func__);
 
@@ -1534,22 +1531,17 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	fmt_change = io_read(sd, 0x43) & 0x98;
 	if (fmt_change)
 		io_write(sd, 0x44, fmt_change);
+
 	fmt_change_digital = is_digital_input(sd) ? (io_read(sd, 0x6b) & 0xc0) : 0;
 	if (fmt_change_digital)
 		io_write(sd, 0x6c, fmt_change_digital);
+
 	if (fmt_change || fmt_change_digital) {
 		v4l2_dbg(1, debug, sd,
 			"%s: fmt_change = 0x%x, fmt_change_digital = 0x%x\n",
 			__func__, fmt_change, fmt_change_digital);
 
-		adv7604_g_input_status(sd, &input_status);
-		if (input_status != state->prev_input_status) {
-			v4l2_dbg(1, debug, sd,
-				"%s: input_status = 0x%x, prev_input_status = 0x%x\n",
-				__func__, input_status, state->prev_input_status);
-			state->prev_input_status = input_status;
-			v4l2_subdev_notify(sd, ADV7604_FMT_CHANGE, NULL);
-		}
+		v4l2_subdev_notify(sd, ADV7604_FMT_CHANGE, NULL);
 
 		if (handled)
 			*handled = true;
@@ -2129,7 +2121,6 @@ static int adv7604_probe(struct i2c_client *client,
 
 	/* initialize variables */
 	state->restart_stdi_once = true;
-	state->prev_input_status = ~0;
 	state->selected_input = ~0;
 
 	/* platform data */
-- 
1.8.4.rc3

