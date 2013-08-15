Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1217 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3HOLh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 07:37:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/12] adv7604: improve log_status for HDMI/DVI-D signals
Date: Thu, 15 Aug 2013 13:36:26 +0200
Message-Id: <4159f6550340a6d21944a438cf601cb674f65947.1376566340.git.hans.verkuil@cisco.com>
In-Reply-To: <1376566594-427-1-git-send-email-hverkuil@xs4all.nl>
References: <1376566594-427-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b1134caad54251cdfc8191a446a160ecc986f9b9.1376566340.git.hans.verkuil@cisco.com>
References: <b1134caad54251cdfc8191a446a160ecc986f9b9.1376566340.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Don't log if there is no signal.

If there is a signal, then also log HDCP and audio status.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 6ffe25a..34fcdf3 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1758,6 +1758,9 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 		adv7604_print_timings(sd, &timings, "Detected format:", true);
 	adv7604_print_timings(sd, &state->timings, "Configured format:", true);
 
+	if (no_signal(sd))
+		return 0;
+
 	v4l2_info(sd, "-----Color space-----\n");
 	v4l2_info(sd, "RGB quantization range ctrl: %s\n",
 			rgb_quantization_range_txt[state->rgb_quantization_range]);
@@ -1767,18 +1770,41 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 			(reg_io_0x02 & 0x02) ? "RGB" : "YCbCr",
 			(reg_io_0x02 & 0x04) ? "(16-235)" : "(0-255)",
 			((reg_io_0x02 & 0x04) ^ (reg_io_0x02 & 0x01)) ?
-					"enabled" : "disabled");
+				"enabled" : "disabled");
 	v4l2_info(sd, "Color space conversion: %s\n",
 			csc_coeff_sel_rb[cp_read(sd, 0xfc) >> 4]);
 
-	/* Digital video */
-	if (DIGITAL_INPUT) {
-		v4l2_info(sd, "-----HDMI status-----\n");
-		v4l2_info(sd, "HDCP encrypted content: %s\n",
-				hdmi_read(sd, 0x05) & 0x40 ? "true" : "false");
-		if (is_hdmi(sd))
-			v4l2_info(sd, "deep color mode: %s\n",
-					deep_color_mode_txt[(hdmi_read(sd, 0x0b) >> 5) & 0x3]);
+	if (!DIGITAL_INPUT)
+		return 0;
+
+	v4l2_info(sd, "-----%s status-----\n", is_hdmi(sd) ? "HDMI" : "DVI-D");
+	v4l2_info(sd, "HDCP encrypted content: %s\n", (hdmi_read(sd, 0x05) & 0x40) ? "true" : "false");
+	v4l2_info(sd, "HDCP keys read: %s%s\n",
+			(hdmi_read(sd, 0x04) & 0x20) ? "yes" : "no",
+			(hdmi_read(sd, 0x04) & 0x10) ? "ERROR" : "");
+	if (!is_hdmi(sd)) {
+		bool audio_pll_locked = hdmi_read(sd, 0x04) & 0x01;
+		bool audio_sample_packet_detect = hdmi_read(sd, 0x18) & 0x01;
+		bool audio_mute = io_read(sd, 0x65) & 0x40;
+
+		v4l2_info(sd, "Audio: pll %s, samples %s, %s\n",
+				audio_pll_locked ? "locked" : "not locked",
+				audio_sample_packet_detect ? "detected" : "not detected",
+				audio_mute ? "muted" : "enabled");
+		if (audio_pll_locked && audio_sample_packet_detect) {
+			v4l2_info(sd, "Audio format: %s\n",
+					(hdmi_read(sd, 0x07) & 0x20) ? "multi-channel" : "stereo");
+		}
+		v4l2_info(sd, "Audio CTS: %u\n", (hdmi_read(sd, 0x5b) << 12) +
+				(hdmi_read(sd, 0x5c) << 8) +
+				(hdmi_read(sd, 0x5d) & 0xf0));
+		v4l2_info(sd, "Audio N: %u\n", ((hdmi_read(sd, 0x5d) & 0x0f) << 16) +
+				(hdmi_read(sd, 0x5e) << 8) +
+				hdmi_read(sd, 0x5f));
+		v4l2_info(sd, "AV Mute: %s\n", (hdmi_read(sd, 0x04) & 0x40) ? "on" : "off");
+
+		v4l2_info(sd, "Deep color mode: %s\n", deep_color_mode_txt[(hdmi_read(sd, 0x0b) & 0x60) >> 5]);
+
 		print_avi_infoframe(sd);
 	}
 
-- 
1.8.3.2

