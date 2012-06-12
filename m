Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46135 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2FLGXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 02:23:46 -0400
Received: by pbbrp8 with SMTP id rp8so354857pbb.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 23:23:45 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, snjw23@gmail.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-fimc: Replace custom err() macro with v4l2_err() macro
Date: Tue, 12 Jun 2012 11:42:26 +0530
Message-Id: <1339481546-24491-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace custom err() macro with v4l2_err() macro.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-core.h |    3 ---
 drivers/media/video/s5p-fimc/fimc-reg.c  |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 95b27ae..808ccc6 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -27,9 +27,6 @@
 #include <media/v4l2-mediabus.h>
 #include <media/s5p_fimc.h>
 
-#define err(fmt, args...) \
-	printk(KERN_ERR "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
-
 #define dbg(fmt, args...) \
 	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
 
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 1fc4ce8..3a82eac 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -683,7 +683,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			cfg |= FIMC_REG_CIGCTRL_CAM_JPEG;
 			break;
 		default:
-			v4l2_err(fimc->vid_cap.vfd,
+			v4l2_err(vid_cap->vfd,
 				 "Not supported camera pixel format: %d",
 				 vid_cap->mf.code);
 			return -EINVAL;
@@ -699,7 +699,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 	} else if (cam->bus_type == FIMC_LCD_WB) {
 		cfg |= FIMC_REG_CIGCTRL_CAMIF_SELWB;
 	} else {
-		err("invalid camera bus type selected\n");
+		v4l2_err(vid_cap->vfd, "Invalid camera bus type selected\n");
 		return -EINVAL;
 	}
 	writel(cfg, fimc->regs + FIMC_REG_CIGCTRL);
-- 
1.7.4.1

