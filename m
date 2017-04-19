Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59056
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1762443AbdDSK5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 06:57:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] [media] mtk-vcodec: avoid warnings because of empty macros
Date: Wed, 19 Apr 2017 07:56:34 -0300
Message-Id: <5bc3ebc3c6f57c2b30126f113bc35ec95c6f5b5d.1492599391.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove those gcc warnings:

	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c: In function 'mtk_vcodec_dec_pw_on':
	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c:114:51: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
	   mtk_v4l2_err("pm_runtime_get_sync fail %d", ret);
	                                                   ^

By adding braces.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
index 12480837ff2e..237e144c194f 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
@@ -66,15 +66,15 @@ extern bool mtk_vcodec_dbg;
 
 #else
 
-#define mtk_v4l2_debug(level, fmt, args...)
-#define mtk_v4l2_err(fmt, args...)
-#define mtk_v4l2_debug_enter()
-#define mtk_v4l2_debug_leave()
+#define mtk_v4l2_debug(level, fmt, args...) {}
+#define mtk_v4l2_err(fmt, args...) {}
+#define mtk_v4l2_debug_enter() {}
+#define mtk_v4l2_debug_leave() {}
 
-#define mtk_vcodec_debug(h, fmt, args...)
-#define mtk_vcodec_err(h, fmt, args...)
-#define mtk_vcodec_debug_enter(h)
-#define mtk_vcodec_debug_leave(h)
+#define mtk_vcodec_debug(h, fmt, args...) {}
+#define mtk_vcodec_err(h, fmt, args...) {}
+#define mtk_vcodec_debug_enter(h) {}
+#define mtk_vcodec_debug_leave(h) {}
 
 #endif
 
-- 
2.9.3
