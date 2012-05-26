Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34999 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2EZPMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 11:12:10 -0400
Received: by pbbrp8 with SMTP id rp8so2921071pbb.19
        for <linux-media@vger.kernel.org>; Sat, 26 May 2012 08:12:10 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-fimc: Add missing static storage class
Date: Sat, 26 May 2012 20:41:54 +0530
Message-Id: <1338045114-2477-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warnings:

drivers/media/video/s5p-fimc/fimc-lite-reg.c:218:6: warning: symbol
'flite_hw_set_out_order' was not declared. Should it be static?

drivers/media/video/s5p-fimc/fimc-mdevice.c:183:5: warning: symbol '__fimc_pipeline_shutdown' was not declared. Should it be static?
drivers/media/video/s5p-fimc/fimc-mdevice.c:1013:12: warning: symbol 'fimc_md_init' was not declared. Should it be static?
drivers/media/video/s5p-fimc/fimc-mdevice.c:1024:13: warning: symbol 'fimc_md_exit' was not declared. Should it be static?

drivers/media/video/s5p-fimc/fimc-core.c:466:5: warning: symbol 'fimc_set_color_effect' was not declared. Should it be static?

drivers/media/video/s5p-fimc/fimc-capture.c:1163:5: warning: symbol 'enclosed_rectangle' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-capture.c  |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.c     |    2 +-
 drivers/media/video/s5p-fimc/fimc-lite-reg.c |    2 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c  |    7 ++++---
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 516cd5b..b7caaf5 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1160,7 +1160,7 @@ static int fimc_cap_g_selection(struct file *file, void *fh,
 }
 
 /* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
-int enclosed_rectangle(struct v4l2_rect *a, struct v4l2_rect *b)
+static int enclosed_rectangle(struct v4l2_rect *a, struct v4l2_rect *b)
 {
 	if (a->left < b->left || a->top < b->top)
 		return 0;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index c2d621c..02c82c7 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -463,7 +463,7 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 	    f->fmt->color, f->dma_offset.y_h, f->dma_offset.y_v);
 }
 
-int fimc_set_color_effect(struct fimc_ctx *ctx, enum v4l2_colorfx colorfx)
+static int fimc_set_color_effect(struct fimc_ctx *ctx, enum v4l2_colorfx colorfx)
 {
 	struct fimc_effect *effect = &ctx->effect;
 
diff --git a/drivers/media/video/s5p-fimc/fimc-lite-reg.c b/drivers/media/video/s5p-fimc/fimc-lite-reg.c
index 419adfb..f996e94 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite-reg.c
@@ -215,7 +215,7 @@ void flite_hw_set_camera_bus(struct fimc_lite *dev,
 	flite_hw_set_camera_port(dev, s_info->mux_id);
 }
 
-void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
+static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
 {
 	static const u32 pixcode[4][2] = {
 		{ V4L2_MBUS_FMT_YUYV8_2X8, FLITE_REG_CIODMAFMT_YCBYCR },
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 52cef48..e65bb28 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -180,7 +180,7 @@ EXPORT_SYMBOL_GPL(fimc_pipeline_initialize);
  * sensor clock.
  * Called with the graph mutex held.
  */
-int __fimc_pipeline_shutdown(struct fimc_pipeline *p)
+static int __fimc_pipeline_shutdown(struct fimc_pipeline *p)
 {
 	int ret = 0;
 
@@ -1010,7 +1010,7 @@ static struct platform_driver fimc_md_driver = {
 	}
 };
 
-int __init fimc_md_init(void)
+static int __init fimc_md_init(void)
 {
 	int ret;
 
@@ -1021,7 +1021,8 @@ int __init fimc_md_init(void)
 
 	return platform_driver_register(&fimc_md_driver);
 }
-void __exit fimc_md_exit(void)
+
+static void __exit fimc_md_exit(void)
 {
 	platform_driver_unregister(&fimc_md_driver);
 	fimc_unregister_driver();
-- 
1.7.5.4

