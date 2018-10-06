Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:58494 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727580AbeJFO1A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 Oct 2018 10:27:00 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: YueHaibing <yuehaibing@huawei.com>, <linux-media@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] media: imx-pxp: remove duplicated include from imx-pxp.c
Date: Sat, 6 Oct 2018 07:36:02 +0000
Message-ID: <1538811362-80425-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/media/platform/imx-pxp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index b76cd0e..229c23a 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
-#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/sched.h>
