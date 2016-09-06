Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34158 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750721AbcIFHvM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 03:51:12 -0400
Received: by mail-pf0-f182.google.com with SMTP id p64so71941319pfb.1
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2016 00:51:11 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: p.zabel@pengutronix.de, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
Subject: [PATCH] [media] coda: add missing header dependencies
Date: Tue,  6 Sep 2016 15:50:56 +0800
Message-Id: <1473148256-25347-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We get 1 warning when building kernel with W=1:
drivers/media/platform/coda/coda-h264.c:22:5: warning: no previous prototype for 'coda_h264_padding' [-Wmissing-prototypes]

In fact, this function is declared in coda.h, so this patch
add missing header dependencies.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/media/platform/coda/coda-h264.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
index 456773a..09dfcca 100644
--- a/drivers/media/platform/coda/coda-h264.c
+++ b/drivers/media/platform/coda/coda-h264.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <coda.h>
 
 static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
 			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80 };
-- 
2.7.4

