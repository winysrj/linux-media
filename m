Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:12602 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728842AbeIROIE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 10:08:04 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <mchehab@kernel.org>
CC: <m@bues.ch>, <eescook@chromium.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH] media: remove redundant include moduleparam.h
Date: Tue, 18 Sep 2018 16:24:03 +0800
Message-ID: <1537259043-44265-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module.h already contained moduleparam.h,  so it is safe to remove
the redundant include.

The issue is detected with the help of Coccinelle.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/media/dvb-frontends/tda18271c2dd.c | 1 -
 drivers/media/pci/cx23885/cx23885-i2c.c    | 1 -
 drivers/media/pci/mantis/mantis_cards.c    | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index 5ce5861..eeb2318 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -20,7 +20,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index dd67135..51a1002 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -18,7 +18,6 @@
 #include "cx23885.h"
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <asm/io.h>
diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index 7eb75cb..e544bb9 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -19,7 +19,6 @@
 */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-- 
1.7.12.4
