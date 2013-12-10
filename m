Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4070 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3LJNZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/15] adv7604: return immediately if the new input is equal to what is configured
Date: Tue, 10 Dec 2013 14:23:15 +0100
Message-Id: <65c77e70090837cc68f1ddfef74ee48a9504849d.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
References: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 7d95a28..fa98229 100644
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
1.8.4.rc3

