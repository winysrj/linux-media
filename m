Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48997 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab2EYRjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 13:39:09 -0400
Received: by dady13 with SMTP id y13so1530415dad.19
        for <linux-media@vger.kernel.org>; Fri, 25 May 2012 10:39:08 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/4] [media] s5p-fimc: Add missing static storage class in fimc-lite-reg.c file
Date: Fri, 25 May 2012 23:08:50 +0530
Message-Id: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:
drivers/media/video/s5p-fimc/fimc-lite-reg.c:218:6: warning: symbol
'flite_hw_set_out_order' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-lite-reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.7.5.4

