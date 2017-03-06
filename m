Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44666 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753177AbdCFScd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 13:32:33 -0500
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH -next] media/platform/mtk-jpeg: add slab.h to fix build errors
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Bin Liu <bin.liu@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e2c7cefc-707c-5d9b-4f1f-fb4a2cc15e14@infradead.org>
Date: Mon, 6 Mar 2017 10:32:22 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Include <linux/slab.h> to fix these build errors:

../drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c: In function 'mtk_jpeg_open':
../drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1017:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
  ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
../drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1017:6: warning: assignment makes pointer from integer without a cast [enabled by default]
  ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
../drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1047:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
  kfree(ctx);

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ming Hsiu Tsai <minghsiu.tsai@mediatek.com>
Cc: Rick Chang <rick.chang@mediatek.com>
Cc: Bin Liu <bin.liu@mediatek.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
---
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20170306.orig/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ linux-next-20170306/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -22,6 +22,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-mem2mem.h>
