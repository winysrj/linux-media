Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:41562 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752937AbeBEOhb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 09:37:31 -0500
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux-input@vger.kernel.org, modin@yuri.at,
        Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 5/5] add default control values as module parameters
Date: Mon,  5 Feb 2018 15:29:41 +0100
Message-Id: <1517840981-12280-6-git-send-email-floe@butterbrot.org>
In-Reply-To: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
References: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index c4b7cf1..d612f3f 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -173,6 +173,14 @@ int sur40_v4l2_contrast   = SUR40_CONTRAST_DEF;   /* blacklevel   */
 int sur40_v4l2_gain       = SUR40_GAIN_DEF;       /* gain         */
 int sur40_v4l2_backlight  = 1;                    /* preprocessor */
 
+/* module parameters */
+static uint irlevel = SUR40_BRIGHTNESS_DEF;
+module_param(irlevel, uint, 0644);
+MODULE_PARM_DESC(irlevel, "set default irlevel");
+static uint vsvideo = SUR40_VSVIDEO_DEF;
+module_param(vsvideo, uint, 0644);
+MODULE_PARM_DESC(vsvideo, "set default vsvideo");
+
 static const struct v4l2_pix_format sur40_pix_format[] = {
 	{
 		.pixelformat = V4L2_TCH_FMT_TU08,
@@ -372,6 +380,11 @@ static void sur40_open(struct input_polled_dev *polldev)
 
 	dev_dbg(sur40->dev, "open\n");
 	sur40_init(sur40);
+
+	/* set default values */
+	sur40_set_irlevel(sur40, irlevel);
+	sur40_set_vsvideo(sur40, vsvideo);
+	sur40_set_preprocessor(sur40, SUR40_BACKLIGHT_DEF);
 }
 
 /* Disable device, polling has stopped. */
-- 
2.7.4
