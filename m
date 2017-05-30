Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35546 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751331AbdE3I7s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 04:59:48 -0400
Received: by mail-pf0-f177.google.com with SMTP id n23so66568525pfb.2
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 01:59:48 -0700 (PDT)
From: Hirokazu Honda <hiroh@chromium.org>
To: Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Hirokazu Honda <hiroh@chromium.org>
Subject: [PATCH] mtk-vcodec: Show mtk driver error without DEBUG definition
Date: Tue, 30 May 2017 17:59:31 +0900
Message-Id: <20170530085931.187344-1-hiroh@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A driver error message is shown without DEBUG definition
to find an error and debug easily.

Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
index 237e144c194f..06c254f5c171 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
@@ -32,6 +32,15 @@ extern int mtk_v4l2_dbg_level;
 extern bool mtk_vcodec_dbg;
 
 
+#define mtk_v4l2_err(fmt, args...)                \
+	pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
+	       ##args)
+
+#define mtk_vcodec_err(h, fmt, args...)					\
+	pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",		\
+	       ((struct mtk_vcodec_ctx *)h->ctx)->id, __func__, ##args)
+
+
 #if defined(DEBUG)
 
 #define mtk_v4l2_debug(level, fmt, args...)				 \
@@ -41,11 +50,6 @@ extern bool mtk_vcodec_dbg;
 				level, __func__, __LINE__, ##args);	 \
 	} while (0)
 
-#define mtk_v4l2_err(fmt, args...)                \
-	pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
-	       ##args)
-
-
 #define mtk_v4l2_debug_enter()  mtk_v4l2_debug(3, "+")
 #define mtk_v4l2_debug_leave()  mtk_v4l2_debug(3, "-")
 
@@ -57,22 +61,16 @@ extern bool mtk_vcodec_dbg;
 				__func__, ##args);			\
 	} while (0)
 
-#define mtk_vcodec_err(h, fmt, args...)					\
-	pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",		\
-	       ((struct mtk_vcodec_ctx *)h->ctx)->id, __func__, ##args)
-
 #define mtk_vcodec_debug_enter(h)  mtk_vcodec_debug(h, "+")
 #define mtk_vcodec_debug_leave(h)  mtk_vcodec_debug(h, "-")
 
 #else
 
 #define mtk_v4l2_debug(level, fmt, args...) {}
-#define mtk_v4l2_err(fmt, args...) {}
 #define mtk_v4l2_debug_enter() {}
 #define mtk_v4l2_debug_leave() {}
 
 #define mtk_vcodec_debug(h, fmt, args...) {}
-#define mtk_vcodec_err(h, fmt, args...) {}
 #define mtk_vcodec_debug_enter(h) {}
 #define mtk_vcodec_debug_leave(h) {}
 
-- 
2.13.0.219.gdb65acc882-goog
