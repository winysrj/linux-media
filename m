Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:48469 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbeBHIo2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 03:44:28 -0500
From: Florian Echtler <floe@butterbrot.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at,
        Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 2/4] add default settings and module parameters for video controls
Date: Thu,  8 Feb 2018 09:43:04 +0100
Message-Id: <1518079386-4647-3-git-send-email-floe@butterbrot.org>
In-Reply-To: <1518079386-4647-1-git-send-email-floe@butterbrot.org>
References: <1518079386-4647-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds parameter definitions and module parameters for the four
userspace controls that the SUR40 can currently provide.

Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 8375b06..8a5b031 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -149,6 +149,40 @@ struct sur40_image_header {
 #define SUR40_TOUCH	0x02
 #define SUR40_TAG	0x04
 
+/* video controls */
+#define SUR40_BRIGHTNESS_MAX 0xff
+#define SUR40_BRIGHTNESS_MIN 0x00
+#define SUR40_BRIGHTNESS_DEF 0xff
+
+#define SUR40_CONTRAST_MAX 0x0f
+#define SUR40_CONTRAST_MIN 0x00
+#define SUR40_CONTRAST_DEF 0x0a
+
+#define SUR40_GAIN_MAX 0x09
+#define SUR40_GAIN_MIN 0x00
+#define SUR40_GAIN_DEF 0x08
+
+#define SUR40_BACKLIGHT_MAX 0x01
+#define SUR40_BACKLIGHT_MIN 0x00
+#define SUR40_BACKLIGHT_DEF 0x01
+
+#define sur40_str(s) #s
+#define SUR40_PARAM_RANGE(lo, hi) " (range " sur40_str(lo) "-" sur40_str(hi) ")"
+
+/* module parameters */
+static uint brightness = SUR40_BRIGHTNESS_DEF;
+module_param(brightness, uint, 0644);
+MODULE_PARM_DESC(brightness, "set initial brightness"
+	SUR40_PARAM_RANGE(SUR40_BRIGHTNESS_MIN, SUR40_BRIGHTNESS_MAX));
+static uint contrast = SUR40_CONTRAST_DEF;
+module_param(contrast, uint, 0644);
+MODULE_PARM_DESC(contrast, "set initial contrast"
+	SUR40_PARAM_RANGE(SUR40_CONTRAST_MIN, SUR40_CONTRAST_MAX));
+static uint gain = SUR40_GAIN_DEF;
+module_param(gain, uint, 0644);
+MODULE_PARM_DESC(gain, "set initial gain"
+	SUR40_PARAM_RANGE(SUR40_GAIN_MIN, SUR40_GAIN_MAX));
+
 static const struct v4l2_pix_format sur40_pix_format[] = {
 	{
 		.pixelformat = V4L2_TCH_FMT_TU08,
-- 
2.7.4
