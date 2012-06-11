Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38141 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2FKKZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 06:25:17 -0400
Received: by dady13 with SMTP id y13so5198450dad.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 03:25:16 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, snjw23@gmail.com,
	kyungmin.park@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/3] [media] s5p-tv: Replace printk with pr_* functions
Date: Mon, 11 Jun 2012 15:43:52 +0530
Message-Id: <1339409634-13657-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printk with pr_* functions to silence checkpatch warnings.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-tv/hdmi_drv.c    |    6 ++++--
 drivers/media/video/s5p-tv/mixer_drv.c   |    6 +++---
 drivers/media/video/s5p-tv/mixer_video.c |    4 +++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index 20cb6ee..8a9cf43 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -11,6 +11,8 @@
  * or (at your option) any later version
  */
 
+#define pr_fmt(fmt) "s5p-tv (hdmi_drv): " fmt
+
 #ifdef CONFIG_VIDEO_SAMSUNG_S5P_HDMI_DEBUG
 #define DEBUG
 #endif
@@ -161,12 +163,12 @@ static irqreturn_t hdmi_irq_handler(int irq, void *dev_data)
 	intc_flag = hdmi_read(hdev, HDMI_INTC_FLAG);
 	/* clearing flags for HPD plug/unplug */
 	if (intc_flag & HDMI_INTC_FLAG_HPD_UNPLUG) {
-		printk(KERN_INFO "unplugged\n");
+		pr_info("unplugged\n");
 		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
 			HDMI_INTC_FLAG_HPD_UNPLUG);
 	}
 	if (intc_flag & HDMI_INTC_FLAG_HPD_PLUG) {
-		printk(KERN_INFO "plugged\n");
+		pr_info("plugged\n");
 		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
 			HDMI_INTC_FLAG_HPD_PLUG);
 	}
diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
index edca065..a15ca05 100644
--- a/drivers/media/video/s5p-tv/mixer_drv.c
+++ b/drivers/media/video/s5p-tv/mixer_drv.c
@@ -461,10 +461,10 @@ static struct platform_driver mxr_driver __refdata = {
 static int __init mxr_init(void)
 {
 	int i, ret;
-	static const char banner[] __initconst = KERN_INFO
+	static const char banner[] __initconst =
 		"Samsung TV Mixer driver, "
 		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
-	printk(banner);
+	pr_info("%s\n", banner);
 
 	/* Loading auxiliary modules */
 	for (i = 0; i < ARRAY_SIZE(mxr_output_conf); ++i)
@@ -472,7 +472,7 @@ static int __init mxr_init(void)
 
 	ret = platform_driver_register(&mxr_driver);
 	if (ret != 0) {
-		printk(KERN_ERR "registration of MIXER driver failed\n");
+		pr_err("s5p-tv: registration of MIXER driver failed\n");
 		return -ENXIO;
 	}
 
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 33fde2a..b17409b 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -11,6 +11,8 @@
  * or (at your option) any later version
  */
 
+#define pr_fmt(fmt) "s5p-tv (mixer): " fmt
+
 #include "mixer.h"
 
 #include <media/v4l2-ioctl.h>
@@ -1036,7 +1038,7 @@ void mxr_base_layer_release(struct mxr_layer *layer)
 
 static void mxr_vfd_release(struct video_device *vdev)
 {
-	printk(KERN_INFO "video device release\n");
+	pr_info("video device release\n");
 }
 
 struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
-- 
1.7.4.1

