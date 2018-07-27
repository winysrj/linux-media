Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:37484 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbeG0Eih (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 00:38:37 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org, brad@nextdimension.cc, hverkuil@xs4all.nl,
        arvind.yadav.cs@gmail.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] media: pci: cx23885: Replace mdelay() with msleep() in cx23885_reset()
Date: Fri, 27 Jul 2018 11:18:46 +0800
Message-Id: <20180727031846.3157-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx23885_reset() is never called in atomic context.
It calls mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 019fac49db5b..9c08d3a9716f 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -635,7 +635,7 @@ static void cx23885_reset(struct cx23885_dev *dev)
 	cx_write(CLK_DELAY, cx_read(CLK_DELAY) & 0x80000000);
 	cx_write(PAD_CTRL, 0x00500300);
 
-	mdelay(100);
+	msleep(100);
 
 	cx23885_sram_channel_setup(dev, &dev->sram_channels[SRAM_CH01],
 		720*4, 0);
-- 
2.17.0
