Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:12652 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbeITKuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 06:50:35 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <mchehab@kernel.org>
CC: <d.scheller@gmx.net>, <jasmin@anw.at>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: ddbridge: remove some duplicated include file
Date: Thu, 20 Sep 2018 12:56:36 +0800
Message-ID: <1537419396-29799-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

interrupt.h and io.h have duplicated include. hence just remove
redundant file.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/media/pci/ddbridge/ddbridge.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index f137155..27b46fe 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -20,11 +20,9 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
-#include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/timer.h>
 #include <linux/i2c.h>
-- 
1.7.12.4
