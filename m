Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:20065 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbcBJKbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2016 05:31:12 -0500
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id u1AAV42Q025396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2016 10:31:04 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] adv7511: TX_EDID_PRESENT is still 1 after a disconnect
Message-ID: <56BB1168.9000805@cisco.com>
Date: Wed, 10 Feb 2016 11:31:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_TX_EDID_PRESENT control reports if an EDID is present.
The adv7511 however still reported the EDID present after disconnecting
the HDMI cable. Fix the logic regarding this control. This has been wrong
since the driver was added to the kernel.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v3.12 and up
---
 drivers/media/i2c/adv7511.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 97eb4b3..a221651 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1553,7 +1553,6 @@ static void adv7511_check_monitor_present_status(struct v4l2_subdev *sd)
 	/* update read only ctrls */
 	v4l2_ctrl_s_ctrl(state->hotplug_ctrl, adv7511_have_hotplug(sd) ? 0x1 : 0x0);
 	v4l2_ctrl_s_ctrl(state->rx_sense_ctrl, adv7511_have_rx_sense(sd) ? 0x1 : 0x0);
-	v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, state->edid.segments ? 0x1 : 0x0);

 	if ((status & MASK_ADV7511_HPD_DETECT) && ((status & MASK_ADV7511_MSEN_DETECT) || state->edid.segments)) {
 		v4l2_dbg(1, debug, sd, "%s: hotplug and (rx-sense or edid)\n", __func__);
@@ -1583,6 +1582,7 @@ static void adv7511_check_monitor_present_status(struct v4l2_subdev *sd)
 		}
 		adv7511_s_power(sd, false);
 		memset(&state->edid, 0, sizeof(struct adv7511_state_edid));
+		v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, 0x0);
 	}
 }

@@ -1685,6 +1685,7 @@ static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 		}
 		/* one more segment read ok */
 		state->edid.segments = segment + 1;
+		v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, 0x1);
 		if (((state->edid.data[0x7e] >> 1) + 1) > state->edid.segments) {
 			/* Request next EDID segment */
 			v4l2_dbg(1, debug, sd, "%s: request segment %d\n", __func__, state->edid.segments);
@@ -1710,7 +1711,6 @@ static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 		ed.present = true;
 		ed.segment = 0;
 		state->edid_detect_counter++;
-		v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, state->edid.segments ? 0x1 : 0x0);
 		v4l2_subdev_notify(sd, ADV7511_EDID_DETECT, (void *)&ed);
 		return ed.present;
 	}
-- 
2.6.1

