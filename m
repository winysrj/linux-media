Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:39336 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbbFGKdC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 06:33:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/6] adv7604: log alt-gamma and HDMI colorspace
Date: Sun,  7 Jun 2015 12:32:35 +0200
Message-Id: <1433673155-20179-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
References: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Log the alternate gamma state and the HDMI colorspace that the adv
device detected.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c04e0dd..daf9386 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2222,6 +2222,14 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 		"invalid", "invalid", "invalid", "invalid", "invalid",
 		"invalid", "invalid", "automatic"
 	};
+	static const char * const hdmi_color_space_txt[16] = {
+		"RGB limited range (16-235)", "RGB full range (0-255)",
+		"YCbCr Bt.601 (16-235)", "YCbCr Bt.709 (16-235)",
+		"xvYCC Bt.601", "xvYCC Bt.709",
+		"YCbCr Bt.601 (0-255)", "YCbCr Bt.709 (0-255)",
+		"sYCC", "Adobe YCC 601", "AdobeRGB", "invalid", "invalid",
+		"invalid", "invalid", "invalid"
+	};
 	static const char * const rgb_quantization_range_txt[] = {
 		"Automatic",
 		"RGB limited range (16-235)",
@@ -2289,11 +2297,12 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 			rgb_quantization_range_txt[state->rgb_quantization_range]);
 	v4l2_info(sd, "Input color space: %s\n",
 			input_color_space_txt[reg_io_0x02 >> 4]);
-	v4l2_info(sd, "Output color space: %s %s, saturator %s\n",
+	v4l2_info(sd, "Output color space: %s %s, saturator %s, alt-gamma %s\n",
 			(reg_io_0x02 & 0x02) ? "RGB" : "YCbCr",
 			(reg_io_0x02 & 0x04) ? "(16-235)" : "(0-255)",
 			(((reg_io_0x02 >> 2) & 0x01) ^ (reg_io_0x02 & 0x01)) ?
-				"enabled" : "disabled");
+				"enabled" : "disabled",
+			(reg_io_0x02 & 0x08) ? "enabled" : "disabled");
 	v4l2_info(sd, "Color space conversion: %s\n",
 			csc_coeff_sel_rb[cp_read(sd, info->cp_csc) >> 4]);
 
@@ -2330,6 +2339,7 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 		v4l2_info(sd, "AV Mute: %s\n", (hdmi_read(sd, 0x04) & 0x40) ? "on" : "off");
 
 		v4l2_info(sd, "Deep color mode: %s\n", deep_color_mode_txt[(hdmi_read(sd, 0x0b) & 0x60) >> 5]);
+		v4l2_info(sd, "HDMI colorspace: %s\n", hdmi_color_space_txt[hdmi_read(sd, 0x53) & 0xf]);
 
 		adv76xx_log_infoframes(sd);
 	}
-- 
2.1.4

