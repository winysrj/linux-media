Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33311 "EHLO
        mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934735AbcIXF3u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Sep 2016 01:29:50 -0400
Received: by mail-pa0-f53.google.com with SMTP id hm5so46318128pac.0
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2016 22:29:50 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: p.zabel@pengutronix.de, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
Subject: [PATCH] [media] coda: add missing header dependencies
Date: Sat, 24 Sep 2016 13:29:34 +0800
Message-Id: <1474694974-2976-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We get 1 warning when building kernel with W=1:
drivers/media/platform/coda/coda-h264.c:21:5: warning: no previous prototype for 'coda_h264_padding' [-Wmissing-prototypes]

In fact, this function is declared in drivers/media/platform/coda/coda.h,
so this patch adds missing header dependencies.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/media/platform/coda/coda-h264.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
index 456773a..6d6f555 100644
--- a/drivers/media/platform/coda/coda-h264.c
+++ b/drivers/media/platform/coda/coda-h264.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include "coda.h"
 
 static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
 			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80 };
-- 
2.7.4

