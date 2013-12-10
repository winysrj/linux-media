Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3780 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3LJPGK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 16/22] adv7842: restart STDI once if format is not found.
Date: Tue, 10 Dec 2013 16:04:02 +0100
Message-Id: <421ea59aefceb9d7a029496177adc0eb6e8c12e3.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

The STDI block may measure wrong values, especially for lcvs and lcf.
If the driver can not find any valid timing, the STDI block is restarted
to measure the video timings again. The function will return an error,
but the restart of STDI will generate a new STDI interrupt and the format
detection process will restart.

Copied from adv7604.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 49 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index bff8314..8390b93 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -85,6 +85,7 @@ struct adv7842_state {
 	bool is_cea_format;
 	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
+	bool restart_stdi_once;
 	bool hdmi_port_a;
 
 	/* i2c clients */
@@ -1345,6 +1346,7 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 
 	/* read STDI */
 	if (read_stdi(sd, &stdi)) {
+		state->restart_stdi_once = true;
 		v4l2_dbg(1, debug, sd, "%s: no valid signal\n", __func__);
 		return -ENOLINK;
 	}
@@ -1355,6 +1357,7 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 		uint32_t freq;
 
 		timings->type = V4L2_DV_BT_656_1120;
+
 		bt->width = (hdmi_read(sd, 0x07) & 0x0f) * 256 + hdmi_read(sd, 0x08);
 		bt->height = (hdmi_read(sd, 0x09) & 0x0f) * 256 + hdmi_read(sd, 0x0a);
 		freq = (hdmi_read(sd, 0x06) * 1000000) +
@@ -1391,21 +1394,50 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 		}
 		adv7842_fill_optional_dv_timings_fields(sd, timings);
 	} else {
-		/* Interlaced? */
-		if (stdi.interlaced) {
-			v4l2_dbg(1, debug, sd, "%s: interlaced video not supported\n", __func__);
-			return -ERANGE;
-		}
-
+		/* find format
+		 * Since LCVS values are inaccurate [REF_03, p. 339-340],
+		 * stdi2dv_timings() is called with lcvs +-1 if the first attempt fails.
+		 */
+		if (!stdi2dv_timings(sd, &stdi, timings))
+			goto found;
+		stdi.lcvs += 1;
+		v4l2_dbg(1, debug, sd, "%s: lcvs + 1 = %d\n", __func__, stdi.lcvs);
+		if (!stdi2dv_timings(sd, &stdi, timings))
+			goto found;
+		stdi.lcvs -= 2;
+		v4l2_dbg(1, debug, sd, "%s: lcvs - 1 = %d\n", __func__, stdi.lcvs);
 		if (stdi2dv_timings(sd, &stdi, timings)) {
+			/*
+			 * The STDI block may measure wrong values, especially
+			 * for lcvs and lcf. If the driver can not find any
+			 * valid timing, the STDI block is restarted to measure
+			 * the video timings again. The function will return an
+			 * error, but the restart of STDI will generate a new
+			 * STDI interrupt and the format detection process will
+			 * restart.
+			 */
+			if (state->restart_stdi_once) {
+				v4l2_dbg(1, debug, sd, "%s: restart STDI\n", __func__);
+				/* TODO restart STDI for Sync Channel 2 */
+				/* enter one-shot mode */
+				cp_write_and_or(sd, 0x86, 0xf9, 0x00);
+				/* trigger STDI restart */
+				cp_write_and_or(sd, 0x86, 0xf9, 0x04);
+				/* reset to continuous mode */
+				cp_write_and_or(sd, 0x86, 0xf9, 0x02);
+				state->restart_stdi_once = false;
+				return -ENOLINK;
+			}
 			v4l2_dbg(1, debug, sd, "%s: format not supported\n", __func__);
 			return -ERANGE;
 		}
+		state->restart_stdi_once = true;
 	}
+found:
 
 	if (debug > 1)
-		v4l2_print_dv_timings(sd->name, "adv7842_query_dv_timings: ",
-				      timings, true);
+		v4l2_print_dv_timings(sd->name, "adv7842_query_dv_timings:",
+				timings, true);
 	return 0;
 }
 
@@ -2802,6 +2834,7 @@ static int adv7842_probe(struct i2c_client *client,
 	state->mode = pdata->mode;
 
 	state->hdmi_port_a = pdata->input == ADV7842_SELECT_HDMI_PORT_A;
+	state->restart_stdi_once = true;
 
 	/* i2c access to adv7842? */
 	rev = adv_smbus_read_byte_data_check(client, 0xea, false) << 8 |
-- 
1.8.4.rc3

