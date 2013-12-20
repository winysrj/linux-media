Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3906 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab3LTJcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 17/50] adv7604: return immediately if the new input is equal to what is configured
Date: Fri, 20 Dec 2013 10:31:10 +0100
Message-Id: <1387531903-20496-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c85f86c..4e7d39a 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1479,7 +1479,11 @@ static int adv7604_s_routing(struct v4l2_subdev *sd,
 {
 	struct adv7604_state *state = to_state(sd);
 
-	v4l2_dbg(2, debug, sd, "%s: input %d", __func__, input);
+	v4l2_dbg(2, debug, sd, "%s: input %d, selected input %d",
+			__func__, input, state->selected_input);
+
+	if (input == state->selected_input)
+		return 0;
 
 	state->selected_input = input;
 
@@ -1524,6 +1528,8 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	u8 fmt_change, fmt_change_digital, tx_5v;
 	u32 input_status;
 
+	v4l2_dbg(2, debug, sd, "%s: ", __func__);
+
 	/* format change */
 	fmt_change = io_read(sd, 0x43) & 0x98;
 	if (fmt_change)
@@ -2124,6 +2130,7 @@ static int adv7604_probe(struct i2c_client *client,
 	/* initialize variables */
 	state->restart_stdi_once = true;
 	state->prev_input_status = ~0;
+	state->selected_input = ~0;
 
 	/* platform data */
 	if (!pdata) {
-- 
1.8.4.4

