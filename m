Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3954 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3HSOom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 03/20] adv7604: pixel-clock depends on deep-color-mode
Date: Mon, 19 Aug 2013 16:44:12 +0200
Message-Id: <1376923469-30694-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

The frequency calculation has to take deep-color mode into account.

While we're at it, also log the deep-color mode in log_status.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d093092..6ffe25a 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -992,6 +992,11 @@ static inline bool no_lock_tmds(struct v4l2_subdev *sd)
 	return (io_read(sd, 0x6a) & 0xe0) != 0xe0;
 }
 
+static inline bool is_hdmi(struct v4l2_subdev *sd)
+{
+	return hdmi_read(sd, 0x05) & 0x80;
+}
+
 static inline bool no_lock_sspd(struct v4l2_subdev *sd)
 {
 	/* TODO channel 2 */
@@ -1244,12 +1249,21 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
 
 	if (DIGITAL_INPUT) {
+		uint32_t freq;
+
 		timings->type = V4L2_DV_BT_656_1120;
 
 		bt->width = (hdmi_read(sd, 0x07) & 0x0f) * 256 + hdmi_read(sd, 0x08);
 		bt->height = (hdmi_read(sd, 0x09) & 0x0f) * 256 + hdmi_read(sd, 0x0a);
-		bt->pixelclock = (hdmi_read(sd, 0x06) * 1000000) +
+		freq = (hdmi_read(sd, 0x06) * 1000000) +
 			((hdmi_read(sd, 0x3b) & 0x30) >> 4) * 250000;
+		if (is_hdmi(sd)) {
+			/* adjust for deep color mode */
+			unsigned bits_per_channel = ((hdmi_read(sd, 0x0b) & 0x60) >> 4) + 8;
+
+			freq = freq * 8 / bits_per_channel;
+		}
+		bt->pixelclock = freq;
 		bt->hfrontporch = (hdmi_read(sd, 0x20) & 0x03) * 256 +
 			hdmi_read(sd, 0x21);
 		bt->hsync = (hdmi_read(sd, 0x22) & 0x03) * 256 +
@@ -1637,7 +1651,7 @@ static void print_avi_infoframe(struct v4l2_subdev *sd)
 	u8 avi_len;
 	u8 avi_ver;
 
-	if (!(hdmi_read(sd, 0x05) & 0x80)) {
+	if (!is_hdmi(sd)) {
 		v4l2_info(sd, "receive DVI-D signal (AVI infoframe not supported)\n");
 		return;
 	}
@@ -1698,6 +1712,12 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 		"RGB limited range (16-235)",
 		"RGB full range (0-255)",
 	};
+	char *deep_color_mode_txt[4] = {
+		"8-bits per channel",
+		"10-bits per channel",
+		"12-bits per channel",
+		"16-bits per channel (not supported)"
+	};
 
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip power: %s\n", no_power(sd) ? "off" : "on");
@@ -1756,7 +1776,9 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 		v4l2_info(sd, "-----HDMI status-----\n");
 		v4l2_info(sd, "HDCP encrypted content: %s\n",
 				hdmi_read(sd, 0x05) & 0x40 ? "true" : "false");
-
+		if (is_hdmi(sd))
+			v4l2_info(sd, "deep color mode: %s\n",
+					deep_color_mode_txt[(hdmi_read(sd, 0x0b) >> 5) & 0x3]);
 		print_avi_infoframe(sd);
 	}
 
-- 
1.8.3.2

