Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:59792 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754049AbeBFVB6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 16:01:58 -0500
From: Florian Echtler <floe@butterbrot.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at,
        Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 5/5] add module parameters for default values
Date: Tue,  6 Feb 2018 22:01:45 +0100
Message-Id: <1517950905-5015-6-git-send-email-floe@butterbrot.org>
In-Reply-To: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
References: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To allow setting custom parameters for the sensor directly at startup, the
three primary controls are exposed as module parameters in this patch.

Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 66ef7e6..d1fcb95 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -167,6 +167,17 @@ struct sur40_image_header {
 #define SUR40_BACKLIGHT_MIN 0x00
 #define SUR40_BACKLIGHT_DEF 0x01
 
+/* module parameters */
+static uint brightness = SUR40_BRIGHTNESS_DEF;
+module_param(brightness, uint, 0644);
+MODULE_PARM_DESC(brightness, "set default brightness");
+static uint contrast = SUR40_CONTRAST_DEF;
+module_param(contrast, uint, 0644);
+MODULE_PARM_DESC(contrast, "set default contrast");
+static uint gain = SUR40_GAIN_DEF;
+module_param(gain, uint, 0644);
+MODULE_PARM_DESC(contrast, "set default gain");
+
 static const struct v4l2_pix_format sur40_pix_format[] = {
 	{
 		.pixelformat = V4L2_TCH_FMT_TU08,
@@ -374,6 +385,11 @@ static void sur40_open(struct input_polled_dev *polldev)
 
 	dev_dbg(sur40->dev, "open\n");
 	sur40_init(sur40);
+
+	/* set default values */
+	sur40_set_irlevel(sur40, brightness & 0xFF);
+	sur40_set_vsvideo(sur40, ((contrast & 0x0F) << 4) | (gain & 0x0F));
+	sur40_set_preprocessor(sur40, SUR40_BACKLIGHT_DEF);
 }
 
 /* Disable device, polling has stopped. */
-- 
2.7.4
