Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:51966 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbeK0I5D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 03:57:03 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab+samsung@kernel.org, jasmin@anw.at
Subject: [PATCH] media: adv7604 added include of linux/interrupt.h
Date: Mon, 26 Nov 2018 23:01:09 +0100
Message-Id: <20181126220109.29743-1-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

On older Kernels (prior to 4.15) irqreturn_t and devm_request_threaded_irq
is not defined when compiling adv7604.c. It seems more recent Kernels
include it via another header which is included by adv7604.c.
Now we include linux/interrupt.h explicitly to get the type also defined
for Kernels prior to 4.15.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/i2c/adv7604.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 43d27edac636..dfb4400f0445 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -27,6 +27,7 @@
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <linux/regmap.h>
+#include <linux/interrupt.h>
 
 #include <media/i2c/adv7604.h>
 #include <media/cec.h>
-- 
2.17.1
