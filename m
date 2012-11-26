Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab2KZEzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:55:52 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so4742413pad.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:55:51 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 6/9] [media] s5p-tv: Add missing braces around sizeof in hdmi_drv.c
Date: Mon, 26 Nov 2012 10:19:05 +0530
Message-Id: <1353905348-15475-7-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following checkpatch warnings:

WARNING: sizeof *fmt should be sizeof(*fmt)
WARNING: sizeof *res should be sizeof(*res)
WARNING: sizeof *res should be sizeof(*res)
WARNING: sizeof sd->name should be sizeof(sd->name)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 8a9cf43..c48eadf 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -656,7 +656,7 @@ static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
 	dev_dbg(hdev->dev, "%s\n", __func__);
 	if (!hdev->cur_conf)
 		return -EINVAL;
-	memset(fmt, 0, sizeof *fmt);
+	memset(fmt, 0, sizeof(*fmt));
 	fmt->width = t->hact.end - t->hact.beg;
 	fmt->height = t->vact[0].end - t->vact[0].beg;
 	fmt->code = V4L2_MBUS_FMT_FIXED; /* means RGB888 */
@@ -760,7 +760,7 @@ static void hdmi_resources_cleanup(struct hdmi_device *hdev)
 		clk_put(res->sclk_hdmi);
 	if (!IS_ERR_OR_NULL(res->hdmi))
 		clk_put(res->hdmi);
-	memset(res, 0, sizeof *res);
+	memset(res, 0, sizeof(*res));
 }
 
 static int hdmi_resources_init(struct hdmi_device *hdev)
@@ -777,7 +777,7 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
 
 	dev_dbg(dev, "HDMI resource init\n");
 
-	memset(res, 0, sizeof *res);
+	memset(res, 0, sizeof(*res));
 	/* get clocks, power */
 
 	res->hdmi = clk_get(dev, "hdmi");
@@ -955,7 +955,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	v4l2_subdev_init(sd, &hdmi_sd_ops);
 	sd->owner = THIS_MODULE;
 
-	strlcpy(sd->name, "s5p-hdmi", sizeof sd->name);
+	strlcpy(sd->name, "s5p-hdmi", sizeof(sd->name));
 	hdmi_dev->cur_preset = HDMI_DEFAULT_PRESET;
 	/* FIXME: missing fail preset is not supported */
 	hdmi_dev->cur_conf = hdmi_preset2timings(hdmi_dev->cur_preset);
-- 
1.7.4.1

