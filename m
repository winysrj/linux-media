Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:35617 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3JYJeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Oct 2013 05:34:04 -0400
Received: by mail-ee0-f42.google.com with SMTP id b45so2308142eek.1
        for <linux-media@vger.kernel.org>; Fri, 25 Oct 2013 02:34:03 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 25 Oct 2013 17:34:03 +0800
Message-ID: <CAPgLHd-_vCt334cppui8RL4Obfgjz1_JWDHKYjz1J=s90A=oJg@mail.gmail.com>
Subject: [PATCH] [media] saa7164: fix return value check in saa7164_initdev()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, hans.verkuil@cisco.com,
	gregkh@linuxfoundation.org, jkosina@suse.cz, rdunlap@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function kthread_run() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/pci/saa7164/saa7164-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index d37ee37..896bd8b 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1354,9 +1354,11 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 		if (fw_debug) {
 			dev->kthread = kthread_run(saa7164_thread_function, dev,
 				"saa7164 debug");
-			if (!dev->kthread)
+			if (IS_ERR(dev->kthread)) {
+				dev->kthread = NULL;
 				printk(KERN_ERR "%s() Failed to create "
 					"debug kernel thread\n", __func__);
+			}
 		}
 
 	} /* != BOARD_UNKNOWN */

