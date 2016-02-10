Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:52151 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992AbcBJLcc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2016 06:32:32 -0500
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id ED886180EBF
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2016 12:32:26 +0100 (CET)
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] adv7511: TX_EDID_PRESENT is still 1 after a disconnect
Message-ID: <56BB1FC9.5080801@xs4all.nl>
Date: Wed, 10 Feb 2016 12:32:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_TX_EDID_PRESENT control reports if an EDID is present.
The adv7511 however still reported the EDID present after disconnecting
the HDMI cable. Fix the logic regarding this control. And when the EDID
is disconnected also call ADV7511_EDID_DETECT to notify the bridge driver.
This was also missing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v3.12 and up
---

Changes since v1:

- the ADV7511_EDID_DETECT notify was also not called on disconnect.

---
 drivers/media/i2c/adv7511.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 471fd23..08d2c6b 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1161,12 +1161,23 @@ static void adv7511_dbg_dump_edid(int lvl, int debug, struct v4l2_subdev *sd, in
 	}
 }

+static void adv7511_notify_no_edid(struct v4l2_subdev *sd)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+	struct adv7511_edid_detect ed;
+
+	/* We failed to read the EDID, so send an event for this. */
+	ed.present = false;
+	ed.segment = adv7511_rd(sd, 0xc4);
+	v4l2_subdev_notify(sd, ADV7511_EDID_DETECT, (void *)&ed);
+	v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, 0x0);
+}
+
 static void adv7511_edid_handler(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct adv7511_state *state = container_of(dwork, struct adv7511_state, edid_handler);
 	struct v4l2_subdev *sd = &state->sd;
-	struct adv7511_edid_detect ed;

 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);

@@ -1191,9 +1202,7 @@ static void adv7511_edid_handler(struct work_struct *work)
 	}

 	/* We failed to read the EDID, so send an event for this. */
-	ed.present = false;
-	ed.segment = adv7511_rd(sd, 0xc4);
-	v4l2_subdev_notify(sd, ADV7511_EDID_DETECT, (void *)&ed);
+	adv7511_notify_no_edid(sd);
 	v4l2_dbg(1, debug, sd, "%s: no edid found\n", __func__);
 }

@@ -1264,7 +1273,6 @@ static void adv7511_check_monitor_present_status(struct v4l2_subdev *sd)
 	/* update read only ctrls */
 	v4l2_ctrl_s_ctrl(state->hotplug_ctrl, adv7511_have_hotplug(sd) ? 0x1 : 0x0);
 	v4l2_ctrl_s_ctrl(state->rx_sense_ctrl, adv7511_have_rx_sense(sd) ? 0x1 : 0x0);
-	v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, state->edid.segments ? 0x1 : 0x0);

 	if ((status & MASK_ADV7511_HPD_DETECT) && ((status & MASK_ADV7511_MSEN_DETECT) || state->edid.segments)) {
 		v4l2_dbg(1, debug, sd, "%s: hotplug and (rx-sense or edid)\n", __func__);
@@ -1294,6 +1302,7 @@ static void adv7511_check_monitor_present_status(struct v4l2_subdev *sd)
 		}
 		adv7511_s_power(sd, false);
 		memset(&state->edid, 0, sizeof(struct adv7511_state_edid));
+		adv7511_notify_no_edid(sd);
 	}
 }

@@ -1370,6 +1379,7 @@ static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 		}
 		/* one more segment read ok */
 		state->edid.segments = segment + 1;
+		v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, 0x1);
 		if (((state->edid.data[0x7e] >> 1) + 1) > state->edid.segments) {
 			/* Request next EDID segment */
 			v4l2_dbg(1, debug, sd, "%s: request segment %d\n", __func__, state->edid.segments);
@@ -1389,7 +1399,6 @@ static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 		ed.present = true;
 		ed.segment = 0;
 		state->edid_detect_counter++;
-		v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, state->edid.segments ? 0x1 : 0x0);
 		v4l2_subdev_notify(sd, ADV7511_EDID_DETECT, (void *)&ed);
 		return ed.present;
 	}
