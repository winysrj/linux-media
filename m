Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4687 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3LTJcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 15/50] adv7604: improve EDID handling
Date: Fri, 20 Dec 2013 10:31:08 +0100
Message-Id: <1387531903-20496-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

- split edid_write_block()
- do not use edid->edid before the validity check
- Return -EINVAL if edid->pad is invalid
- Save both registers for SPA port A
- Set SPA location to default value if it is not found

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 94 ++++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 44 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d8061c5..501f40f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -72,7 +72,7 @@ struct adv7604_state {
 		u32 present;
 		unsigned blocks;
 	} edid;
-	u16 spa_port_a;
+	u16 spa_port_a[2];
 	struct v4l2_fract aspect_ratio;
 	u32 rgb_quantization_range;
 	struct workqueue_struct *work_queues;
@@ -510,22 +510,9 @@ static inline int edid_read_block(struct v4l2_subdev *sd, unsigned len, u8 *val)
 	return 0;
 }
 
-static void adv7604_delayed_work_enable_hotplug(struct work_struct *work)
-{
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct adv7604_state *state = container_of(dwork, struct adv7604_state,
-						delayed_work_enable_hotplug);
-	struct v4l2_subdev *sd = &state->sd;
-
-	v4l2_dbg(2, debug, sd, "%s: enable hotplug\n", __func__);
-
-	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
-}
-
 static inline int edid_write_block(struct v4l2_subdev *sd,
 					unsigned len, const u8 *val)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct adv7604_state *state = to_state(sd);
 	int err = 0;
 	int i;
@@ -535,24 +522,19 @@ static inline int edid_write_block(struct v4l2_subdev *sd,
 	for (i = 0; !err && i < len; i += I2C_SMBUS_BLOCK_MAX)
 		err = adv_smbus_write_i2c_block_data(state->i2c_edid, i,
 				I2C_SMBUS_BLOCK_MAX, val + i);
-	if (err)
-		return err;
+	return err;
+}
 
-	/* adv7604 calculates the checksums and enables I2C access to internal
-	   EDID RAM from DDC port. */
-	rep_write_and_or(sd, 0x77, 0xf0, state->edid.present);
+static void adv7604_delayed_work_enable_hotplug(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct adv7604_state *state = container_of(dwork, struct adv7604_state,
+						delayed_work_enable_hotplug);
+	struct v4l2_subdev *sd = &state->sd;
 
-	for (i = 0; i < 1000; i++) {
-		if (rep_read(sd, 0x7d) & state->edid.present)
-			break;
-		mdelay(1);
-	}
-	if (i == 1000) {
-		v4l_err(client, "error enabling edid (0x%x)\n", state->edid.present);
-		return -EIO;
-	}
+	v4l2_dbg(2, debug, sd, "%s: enable hotplug\n", __func__);
 
-	return 0;
+	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
 }
 
 static inline int hdmi_read(struct v4l2_subdev *sd, u8 reg)
@@ -1621,7 +1603,7 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	return 0;
 }
 
-static int get_edid_spa_location(struct v4l2_subdev *sd, const u8 *edid)
+static int get_edid_spa_location(const u8 *edid)
 {
 	u8 d;
 
@@ -1652,9 +1634,10 @@ static int get_edid_spa_location(struct v4l2_subdev *sd, const u8 *edid)
 static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
 {
 	struct adv7604_state *state = to_state(sd);
-	int spa_loc = get_edid_spa_location(sd, edid->edid);
+	int spa_loc;
 	int tmp = 0;
 	int err;
+	int i;
 
 	if (edid->pad > ADV7604_EDID_PORT_D)
 		return -EINVAL;
@@ -1684,35 +1667,43 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	if (!edid->edid)
 		return -EINVAL;
 
+	v4l2_dbg(2, debug, sd, "%s: write EDID pad %d, edid.present = 0x%x\n",
+			__func__, edid->pad, state->edid.present);
+
 	/* Disable hotplug and I2C access to EDID RAM from DDC port */
 	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&tmp);
 	rep_write_and_or(sd, 0x77, 0xf0, 0x00);
 
-	v4l2_dbg(2, debug, sd, "%s: write EDID pad %d, edid.present = 0x%x\n",
-			__func__, edid->pad, state->edid.present);
+	spa_loc = get_edid_spa_location(edid->edid);
+	if (spa_loc < 0)
+		spa_loc = 0xc0; /* Default value [REF_02, p. 116] */
+
 	switch (edid->pad) {
 	case ADV7604_EDID_PORT_A:
-		state->spa_port_a = edid->edid[spa_loc];
+		state->spa_port_a[0] = edid->edid[spa_loc];
+		state->spa_port_a[1] = edid->edid[spa_loc + 1];
 		break;
 	case ADV7604_EDID_PORT_B:
-		rep_write(sd, 0x70, (spa_loc < 0) ? 0 : edid->edid[spa_loc]);
-		rep_write(sd, 0x71, (spa_loc < 0) ? 0 : edid->edid[spa_loc + 1]);
+		rep_write(sd, 0x70, edid->edid[spa_loc]);
+		rep_write(sd, 0x71, edid->edid[spa_loc + 1]);
 		break;
 	case ADV7604_EDID_PORT_C:
-		rep_write(sd, 0x72, (spa_loc < 0) ? 0 : edid->edid[spa_loc]);
-		rep_write(sd, 0x73, (spa_loc < 0) ? 0 : edid->edid[spa_loc + 1]);
+		rep_write(sd, 0x72, edid->edid[spa_loc]);
+		rep_write(sd, 0x73, edid->edid[spa_loc + 1]);
 		break;
 	case ADV7604_EDID_PORT_D:
-		rep_write(sd, 0x74, (spa_loc < 0) ? 0 : edid->edid[spa_loc]);
-		rep_write(sd, 0x75, (spa_loc < 0) ? 0 : edid->edid[spa_loc + 1]);
+		rep_write(sd, 0x74, edid->edid[spa_loc]);
+		rep_write(sd, 0x75, edid->edid[spa_loc + 1]);
 		break;
+	default:
+		return -EINVAL;
 	}
-	rep_write(sd, 0x76, (spa_loc < 0) ? 0x00 : spa_loc);
-	rep_write_and_or(sd, 0x77, 0xbf, (spa_loc < 0) ? 0x00 : (spa_loc >> 2) & 0x40);
+	rep_write(sd, 0x76, spa_loc & 0xff);
+	rep_write_and_or(sd, 0x77, 0xbf, (spa_loc >> 2) & 0x40);
 
-	if (spa_loc > 0)
-		edid->edid[spa_loc] = state->spa_port_a;
+	edid->edid[spa_loc] = state->spa_port_a[0];
+	edid->edid[spa_loc + 1] = state->spa_port_a[1];
 
 	memcpy(state->edid.edid, edid->edid, 128 * edid->blocks);
 	state->edid.blocks = edid->blocks;
@@ -1726,6 +1717,21 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 		return err;
 	}
 
+	/* adv7604 calculates the checksums and enables I2C access to internal
+	   EDID RAM from DDC port. */
+	rep_write_and_or(sd, 0x77, 0xf0, state->edid.present);
+
+	for (i = 0; i < 1000; i++) {
+		if (rep_read(sd, 0x7d) & state->edid.present)
+			break;
+		mdelay(1);
+	}
+	if (i == 1000) {
+		v4l2_err(sd, "error enabling edid (0x%x)\n", state->edid.present);
+		return -EIO;
+	}
+
+
 	/* enable hotplug after 100 ms */
 	queue_delayed_work(state->work_queues,
 			&state->delayed_work_enable_hotplug, HZ / 10);
-- 
1.8.4.4

