Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4335 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3LTJbz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 04/50] ad9389b: retry setup if the state is inconsistent
Date: Fri, 20 Dec 2013 10:30:57 +0100
Message-Id: <1387531903-20496-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Retry setup if the device is powered off when it should be powered on. This
state can be caused by rapid hotplug toggles.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index cca7758..83225d6 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -904,7 +904,7 @@ static void ad9389b_notify_monitor_detect(struct v4l2_subdev *sd)
 	v4l2_subdev_notify(sd, AD9389B_MONITOR_DETECT, (void *)&mdt);
 }
 
-static void ad9389b_check_monitor_present_status(struct v4l2_subdev *sd)
+static void ad9389b_update_monitor_present_status(struct v4l2_subdev *sd)
 {
 	struct ad9389b_state *state = get_ad9389b_state(sd);
 	/* read hotplug and rx-sense state */
@@ -947,6 +947,31 @@ static void ad9389b_check_monitor_present_status(struct v4l2_subdev *sd)
 	ad9389b_s_ctrl(state->hdmi_mode_ctrl);
 }
 
+static void ad9389b_check_monitor_present_status(struct v4l2_subdev *sd)
+{
+	struct ad9389b_state *state = get_ad9389b_state(sd);
+	int retry = 0;
+
+	ad9389b_update_monitor_present_status(sd);
+
+	/*
+	 * Rapid toggling of the hotplug may leave the chip powered off,
+	 * even if we think it is on. In that case reset and power up again.
+	 */
+	while (state->power_on && (ad9389b_rd(sd, 0x41) & 0x40)) {
+		if (++retry > 5) {
+			v4l2_err(sd, "retried %d times, give up\n", retry);
+			return;
+		}
+		v4l2_dbg(1, debug, sd, "%s: reset and re-check status (%d)\n", __func__, retry);
+		ad9389b_notify_monitor_detect(sd);
+		cancel_delayed_work_sync(&state->edid_handler);
+		memset(&state->edid, 0, sizeof(struct ad9389b_state_edid));
+		ad9389b_s_power(sd, false);
+		ad9389b_update_monitor_present_status(sd);
+	}
+}
+
 static bool edid_block_verify_crc(u8 *edid_block)
 {
 	u8 sum = 0;
-- 
1.8.4.4

