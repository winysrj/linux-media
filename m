Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58647 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2FKKZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 06:25:22 -0400
Received: by pbbrp8 with SMTP id rp8so5391906pbb.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 03:25:22 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, snjw23@gmail.com,
	kyungmin.park@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/3] [media] s5p-mfc: Replace printk with pr_* functions
Date: Mon, 11 Jun 2012 15:43:53 +0530
Message-Id: <1339409634-13657-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1339409634-13657-1-git-send-email-sachin.kamat@linaro.org>
References: <1339409634-13657-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printk with pr_* functions to silence checkpatch warnings.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h |    6 +++---
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c   |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_debug.h b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
index ecb8616..fea2c6e 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
@@ -23,7 +23,7 @@ extern int debug;
 #define mfc_debug(level, fmt, args...)				\
 	do {							\
 		if (debug >= level)				\
-			printk(KERN_DEBUG "%s:%d: " fmt,	\
+			pr_debug("%s:%d: " fmt,	\
 				__func__, __LINE__, ##args);	\
 	} while (0)
 #else
@@ -35,13 +35,13 @@ extern int debug;
 
 #define mfc_err(fmt, args...)				\
 	do {						\
-		printk(KERN_ERR "%s:%d: " fmt,		\
+		pr_err("%s:%d: " fmt,		\
 		       __func__, __LINE__, ##args);	\
 	} while (0)
 
 #define mfc_info(fmt, args...)				\
 	do {						\
-		printk(KERN_INFO "%s:%d: " fmt,		\
+		pr_info("%s:%d: " fmt,		\
 		       __func__, __LINE__, ##args);	\
 	} while (0)
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
index e6217cb..6d3f398 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -12,6 +12,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) "s5p-mfc: " fmt
+
 #include "regs-mfc.h"
 #include "s5p_mfc_cmd.h"
 #include "s5p_mfc_common.h"
@@ -187,8 +189,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
 		if (IS_ERR(ctx->bank1_buf)) {
 			ctx->bank1_buf = NULL;
-			printk(KERN_ERR
-			       "Buf alloc for decoding failed (port A)\n");
+			pr_err("Buf alloc for decoding failed (port A)\n");
 			return -ENOMEM;
 		}
 		ctx->bank1_phys = s5p_mfc_mem_cookie(
-- 
1.7.4.1

