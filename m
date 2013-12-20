Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4701 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3LTJcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 37/50] adv7842: Use defines to select EDID port
Date: Fri, 20 Dec 2013 10:31:30 +0100
Message-Id: <1387531903-20496-38-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 77 ++++++++++++++++++++-------------------------
 include/media/adv7842.h     |  4 +++
 2 files changed, 38 insertions(+), 43 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index ab44897..a26c70c 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -22,8 +22,8 @@
  * References (c = chapter, p = page):
  * REF_01 - Analog devices, ADV7842, Register Settings Recommendations,
  *		Revision 2.5, June 2010
- * REF_02 - Analog devices, Register map documentation, Documentation of
- *		the register maps, Software manual, Rev. F, June 2010
+ * REF_02 - Analog devices, Software User Guide, UG-206,
+ *		ADV7842 I2C Register Maps, Rev. 0, November 2010
  */
 
 
@@ -587,10 +587,10 @@ static void adv7842_delayed_work_enable_hotplug(struct work_struct *work)
 	v4l2_dbg(2, debug, sd, "%s: enable hotplug on ports: 0x%x\n",
 			__func__, present);
 
-	if (present & 0x1)
-		mask |= 0x20; /* port A */
-	if (present & 0x2)
-		mask |= 0x10; /* port B */
+	if (present & (0x04 << ADV7842_EDID_PORT_A))
+		mask |= 0x20;
+	if (present & (0x04 << ADV7842_EDID_PORT_B))
+		mask |= 0x10;
 	io_write_and_or(sd, 0x20, 0xcf, mask);
 }
 
@@ -679,14 +679,12 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct adv7842_state *state = to_state(sd);
 	const u8 *val = state->hdmi_edid.edid;
-	u8 cur_mask = rep_read(sd, 0x77) & 0x0c;
-	u8 mask = port == 0 ? 0x4 : 0x8;
 	int spa_loc = edid_spa_location(val);
 	int err = 0;
 	int i;
 
-	v4l2_dbg(2, debug, sd, "%s: write EDID on port %d (spa at 0x%x)\n",
-			__func__, port, spa_loc);
+	v4l2_dbg(2, debug, sd, "%s: write EDID on port %c (spa at 0x%x)\n",
+			__func__, (port == ADV7842_EDID_PORT_A) ? 'A' : 'B', spa_loc);
 
 	/* HPA disable on port A and B */
 	io_write_and_or(sd, 0x20, 0xcf, 0x00);
@@ -703,44 +701,32 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	if (err)
 		return err;
 
-	if (spa_loc > 0) {
-		if (port == 0) {
-			/* port A SPA */
-			rep_write(sd, 0x72, val[spa_loc]);
-			rep_write(sd, 0x73, val[spa_loc + 1]);
-		} else {
-			/* port B SPA */
-			rep_write(sd, 0x74, val[spa_loc]);
-			rep_write(sd, 0x75, val[spa_loc + 1]);
-		}
-		rep_write(sd, 0x76, spa_loc);
+	if (spa_loc < 0)
+		spa_loc = 0xc0; /* Default value [REF_02, p. 199] */
+
+	if (port == ADV7842_EDID_PORT_A) {
+		rep_write(sd, 0x72, val[spa_loc]);
+		rep_write(sd, 0x73, val[spa_loc + 1]);
 	} else {
-		/* Edid values for SPA location */
-		if (port == 0) {
-			/* port A */
-			rep_write(sd, 0x72, val[0xc0]);
-			rep_write(sd, 0x73, val[0xc1]);
-		} else {
-			/* port B */
-			rep_write(sd, 0x74, val[0xc0]);
-			rep_write(sd, 0x75, val[0xc1]);
-		}
-		rep_write(sd, 0x76, 0xc0);
+		rep_write(sd, 0x74, val[spa_loc]);
+		rep_write(sd, 0x75, val[spa_loc + 1]);
 	}
-	rep_write_and_or(sd, 0x77, 0xbf, 0x00);
+	rep_write(sd, 0x76, spa_loc & 0xff);
+	rep_write_and_or(sd, 0x77, 0xbf, (spa_loc >> 2) & 0x40);
 
 	/* Calculates the checksums and enables I2C access to internal
 	 * EDID ram from HDMI DDC ports
 	 */
-	rep_write_and_or(sd, 0x77, 0xf3, mask | cur_mask);
+	rep_write_and_or(sd, 0x77, 0xf3, state->hdmi_edid.present);
 
 	for (i = 0; i < 1000; i++) {
-		if (rep_read(sd, 0x7d) & mask)
+		if (rep_read(sd, 0x7d) & state->hdmi_edid.present)
 			break;
 		mdelay(1);
 	}
 	if (i == 1000) {
-		v4l_err(client, "error enabling edid on port %d\n", port);
+		v4l_err(client, "error enabling edid on port %c\n",
+				(port == ADV7842_EDID_PORT_A) ? 'A' : 'B');
 		return -EIO;
 	}
 
@@ -1888,7 +1874,7 @@ static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *e)
 	struct adv7842_state *state = to_state(sd);
 	int err = 0;
 
-	if (e->pad > 2)
+	if (e->pad > ADV7842_EDID_PORT_VGA)
 		return -EINVAL;
 	if (e->start_block != 0)
 		return -EINVAL;
@@ -1901,20 +1887,25 @@ static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *e)
 	state->aspect_ratio = v4l2_calc_aspect_ratio(e->edid[0x15],
 			e->edid[0x16]);
 
-	if (e->pad == 2) {
+	switch (e->pad) {
+	case ADV7842_EDID_PORT_VGA:
 		memset(&state->vga_edid.edid, 0, 256);
 		state->vga_edid.present = e->blocks ? 0x1 : 0x0;
 		memcpy(&state->vga_edid.edid, e->edid, 128 * e->blocks);
 		err = edid_write_vga_segment(sd);
-	} else {
-		u32 mask = 0x1<<e->pad;
+		break;
+	case ADV7842_EDID_PORT_A:
+	case ADV7842_EDID_PORT_B:
 		memset(&state->hdmi_edid.edid, 0, 256);
 		if (e->blocks)
-			state->hdmi_edid.present |= mask;
+			state->hdmi_edid.present |= 0x04 << e->pad;
 		else
-			state->hdmi_edid.present &= ~mask;
-		memcpy(&state->hdmi_edid.edid, e->edid, 128*e->blocks);
+			state->hdmi_edid.present &= ~(0x04 << e->pad);
+		memcpy(&state->hdmi_edid.edid, e->edid, 128 * e->blocks);
 		err = edid_write_hdmi_segment(sd, e->pad);
+		break;
+	default:
+		return -EINVAL;
 	}
 	if (err < 0)
 		v4l2_err(sd, "error %d writing edid on port %d\n", err, e->pad);
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index 24fed11..a4851bf 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -225,4 +225,8 @@ struct adv7842_platform_data {
  * deinterlacer. */
 #define ADV7842_CMD_RAM_TEST _IO('V', BASE_VIDIOC_PRIVATE)
 
+#define ADV7842_EDID_PORT_A   0
+#define ADV7842_EDID_PORT_B   1
+#define ADV7842_EDID_PORT_VGA 2
+
 #endif
-- 
1.8.4.4

