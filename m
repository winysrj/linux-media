Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58647 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2FKKZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 06:25:26 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so5391906pbb.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 03:25:26 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, snjw23@gmail.com,
	kyungmin.park@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/3] [media] s5p-fimc: Replace printk with pr_* functions
Date: Mon, 11 Jun 2012 15:43:54 +0530
Message-Id: <1339409634-13657-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1339409634-13657-1-git-send-email-sachin.kamat@linaro.org>
References: <1339409634-13657-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printk with pr_* functions to silence checkpatch warnings.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 95b27ae..c22fb0a 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -28,7 +28,7 @@
 #include <media/s5p_fimc.h>
 
 #define err(fmt, args...) \
-	printk(KERN_ERR "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
+	pr_err("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
 
 #define dbg(fmt, args...) \
 	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
-- 
1.7.4.1

