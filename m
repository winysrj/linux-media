Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4593 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab3LJNZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/15] adv7604: set CEC address (SPA) in EDID
Date: Tue, 10 Dec 2013 14:23:12 +0100
Message-Id: <98d775240567829432a4e5054487d925671a6263.1386681716.git.hans.verkuil@cisco.com>
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
 drivers/media/i2c/adv7604.c | 83 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index b53373b..5e40a60 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -72,6 +72,7 @@ struct adv7604_state {
 		u32 present;
 		unsigned blocks;
 	} edid;
+	u16 spa_port_a;
 	struct v4l2_fract aspect_ratio;
 	u32 rgb_quantization_range;
 	struct workqueue_struct *work_queues;
@@ -531,9 +532,6 @@ static inline int edid_write_block(struct v4l2_subdev *sd,
 
 	v4l2_dbg(2, debug, sd, "%s: write EDID block (%d byte)\n", __func__, len);
 
-	/* Disables I2C access to internal EDID ram from DDC port */
-	rep_write_and_or(sd, 0x77, 0xf0, 0x0);
-
 	for (i = 0; !err && i < len; i += I2C_SMBUS_BLOCK_MAX)
 		err = adv_smbus_write_i2c_block_data(state->i2c_edid, i,
 				I2C_SMBUS_BLOCK_MAX, val + i);
@@ -1623,9 +1621,39 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	return 0;
 }
 
+static int get_edid_spa_location(struct v4l2_subdev *sd, const u8 *edid)
+{
+	u8 d;
+
+	if ((edid[0x7e] != 1) ||
+	    (edid[0x80] != 0x02) ||
+	    (edid[0x81] != 0x03)) {
+		return -1;
+	}
+
+	/* search Vendor Specific Data Block (tag 3) */
+	d = edid[0x82] & 0x7f;
+	if (d > 4) {
+		int i = 0x84;
+		int end = 0x80 + d;
+
+		do {
+			u8 tag = edid[i] >> 5;
+			u8 len = edid[i] & 0x1f;
+
+			if ((tag == 3) && (len >= 5))
+				return i + 4;
+			i += len + 1;
+		} while (i < end);
+	}
+	return -1;
+}
+
 static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
 {
 	struct adv7604_state *state = to_state(sd);
+	int spa_loc = get_edid_spa_location(sd, edid->edid);
+	int tmp = 0;
 	int err;
 
 	if (edid->pad > ADV7604_EDID_PORT_D)
@@ -1633,16 +1661,20 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	if (edid->start_block != 0)
 		return -EINVAL;
 	if (edid->blocks == 0) {
-		/* Pull down the hotplug pin */
+		/* Disable hotplug and I2C access to EDID RAM from DDC port */
 		state->edid.present &= ~(1 << edid->pad);
 		v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
-		/* Disables I2C access to internal EDID ram from DDC port */
-		rep_write_and_or(sd, 0x77, 0xf0, 0x0);
-		state->edid.blocks = 0;
+		rep_write_and_or(sd, 0x77, 0xf0, state->edid.present);
+
 		/* Fall back to a 16:9 aspect ratio */
 		state->aspect_ratio.numerator = 16;
 		state->aspect_ratio.denominator = 9;
-		v4l2_dbg(2, debug, sd, "%s: clear edid\n", __func__);
+
+		if (!state->edid.present)
+			state->edid.blocks = 0;
+
+		v4l2_dbg(2, debug, sd, "%s: clear EDID pad %d, edid.present = 0x%x\n",
+				__func__, edid->pad, state->edid.present);
 		return 0;
 	}
 	if (edid->blocks > 2) {
@@ -1652,19 +1684,45 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	if (!edid->edid)
 		return -EINVAL;
 
+	/* Disable hotplug and I2C access to EDID RAM from DDC port */
 	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
-	state->edid.present &= ~(1 << edid->pad);
-	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
+	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&tmp);
+	rep_write_and_or(sd, 0x77, 0xf0, 0x00);
+
+	v4l2_dbg(2, debug, sd, "%s: write EDID pad %d, edid.present = 0x%x\n",
+			__func__, edid->pad, state->edid.present);
+	switch (edid->pad) {
+	case ADV7604_EDID_PORT_A:
+		state->spa_port_a = edid->edid[spa_loc];
+		break;
+	case ADV7604_EDID_PORT_B:
+		rep_write(sd, 0x70, (spa_loc < 0) ? 0 : edid->edid[spa_loc]);
+		rep_write(sd, 0x71, (spa_loc < 0) ? 0 : edid->edid[spa_loc + 1]);
+		break;
+	case ADV7604_EDID_PORT_C:
+		rep_write(sd, 0x72, (spa_loc < 0) ? 0 : edid->edid[spa_loc]);
+		rep_write(sd, 0x73, (spa_loc < 0) ? 0 : edid->edid[spa_loc + 1]);
+		break;
+	case ADV7604_EDID_PORT_D:
+		rep_write(sd, 0x74, (spa_loc < 0) ? 0 : edid->edid[spa_loc]);
+		rep_write(sd, 0x75, (spa_loc < 0) ? 0 : edid->edid[spa_loc + 1]);
+		break;
+	}
+	rep_write(sd, 0x76, (spa_loc < 0) ? 0x00 : spa_loc);
+	rep_write_and_or(sd, 0x77, 0xbf, (spa_loc < 0) ? 0x00 : (spa_loc >> 2) & 0x40);
+
+	if (spa_loc > 0)
+		edid->edid[spa_loc] = state->spa_port_a;
 
 	memcpy(state->edid.edid, edid->edid, 128 * edid->blocks);
 	state->edid.blocks = edid->blocks;
 	state->aspect_ratio = v4l2_calc_aspect_ratio(edid->edid[0x15],
 			edid->edid[0x16]);
-	state->edid.present |= edid->pad;
+	state->edid.present |= 1 << edid->pad;
 
 	err = edid_write_block(sd, 128 * edid->blocks, state->edid.edid);
 	if (err < 0) {
-		v4l2_err(sd, "error %d writing edid\n", err);
+		v4l2_err(sd, "error %d writing edid pad %d\n", err, edid->pad);
 		return err;
 	}
 
@@ -1984,7 +2042,6 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 				      ADI recommended setting [REF_01, c. 2.3.3] */
 	cp_write(sd, 0xc9, 0x2d); /* use prim_mode and vid_std as free run resolution
 				     for digital formats */
-	rep_write(sd, 0x76, 0xc0); /* SPA location for port B, C and D */
 
 	/* TODO from platform data */
 	afe_write(sd, 0xb5, 0x01);  /* Setting MCLK to 256Fs */
-- 
1.8.4.rc3

