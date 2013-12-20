Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2436 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab3LTJcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 38/50] adv7842: mute audio before switching inputs to avoid noise/pops
Date: Fri, 20 Dec 2013 10:31:31 +0100
Message-Id: <1387531903-20496-39-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index a26c70c..bbd80ac 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -20,10 +20,13 @@
 
 /*
  * References (c = chapter, p = page):
- * REF_01 - Analog devices, ADV7842, Register Settings Recommendations,
- *		Revision 2.5, June 2010
+ * REF_01 - Analog devices, ADV7842,
+ *		Register Settings Recommendations, Rev. 1.9, April 2011
  * REF_02 - Analog devices, Software User Guide, UG-206,
  *		ADV7842 I2C Register Maps, Rev. 0, November 2010
+ * REF_03 - Analog devices, Hardware User Guide, UG-214,
+ *		ADV7842 Fast Switching 2:1 HDMI 1.4 Receiver with 3D-Comb
+ *		Decoder and Digitizer , Rev. 0, January 2011
  */
 
 
@@ -491,6 +494,11 @@ static inline int hdmi_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state->i2c_hdmi, reg, val);
 }
 
+static inline int hdmi_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+{
+	return hdmi_write(sd, reg, (hdmi_read(sd, reg) & mask) | val);
+}
+
 static inline int cp_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7842_state *state = to_state(sd);
@@ -1459,14 +1467,12 @@ static void enable_input(struct v4l2_subdev *sd)
 	case ADV7842_MODE_SDP:
 	case ADV7842_MODE_COMP:
 	case ADV7842_MODE_RGB:
-		/* enable */
 		io_write(sd, 0x15, 0xb0);   /* Disable Tristate of Pins (no audio) */
 		break;
 	case ADV7842_MODE_HDMI:
-		/* enable */
-		hdmi_write(sd, 0x1a, 0x0a); /* Unmute audio */
 		hdmi_write(sd, 0x01, 0x00); /* Enable HDMI clock terminators */
 		io_write(sd, 0x15, 0xa0);   /* Disable Tristate of Pins */
+		hdmi_write_and_or(sd, 0x1a, 0xef, 0x00); /* Unmute audio */
 		break;
 	default:
 		v4l2_dbg(2, debug, sd, "%s: Unknown mode %d\n",
@@ -1477,9 +1483,9 @@ static void enable_input(struct v4l2_subdev *sd)
 
 static void disable_input(struct v4l2_subdev *sd)
 {
-	/* disable */
+	hdmi_write_and_or(sd, 0x1a, 0xef, 0x10); /* Mute audio [REF_01, c. 2.2.2] */
+	msleep(16); /* 512 samples with >= 32 kHz sample rate [REF_03, c. 8.29] */
 	io_write(sd, 0x15, 0xbe);   /* Tristate all outputs from video core */
-	hdmi_write(sd, 0x1a, 0x1a); /* Mute audio */
 	hdmi_write(sd, 0x01, 0x78); /* Disable HDMI clock terminators */
 }
 
@@ -2432,6 +2438,9 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 			pdata->replicate_av_codes << 1 |
 			pdata->invert_cbcr << 0);
 
+	/* HDMI audio */
+	hdmi_write_and_or(sd, 0x1a, 0xf1, 0x08); /* Wait 1 s before unmute */
+
 	/* Drive strength */
 	io_write_and_or(sd, 0x14, 0xc0, pdata->drive_strength.data<<4 |
 			pdata->drive_strength.clock<<2 |
-- 
1.8.4.4

