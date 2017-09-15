Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:57544 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbdIOH5J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 03:57:09 -0400
Subject: [PATCH 6/9] [media] tm6000: Use common error handling code in
 tm6000_cards_setup()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Sean Young <sean@mess.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Message-ID: <1a2f24a8-6365-cd56-caaf-ff3dbadbd8e7@users.sourceforge.net>
Date: Fri, 15 Sep 2017 09:56:31 +0200
MIME-Version: 1.0
In-Reply-To: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 14 Sep 2017 16:26:42 +0200

Add a jump target so that a bit of exception handling can be better reused
in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/tm6000/tm6000-cards.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 72dd6b80394f..502e0b38b7f1 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -872,15 +872,14 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 		for (i = 0; i < 2; i++) {
 			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 						dev->gpio.tuner_reset, 0x00);
-			if (rc < 0) {
-				printk(KERN_ERR "Error %i doing tuner reset\n", rc);
-				return rc;
-			}
+			if (rc < 0)
+				goto report_failure;
 
 			msleep(10); /* Just to be conservative */
 			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 						dev->gpio.tuner_reset, 0x01);
 			if (rc < 0) {
+report_failure:
 				printk(KERN_ERR "Error %i doing tuner reset\n", rc);
 				return rc;
 			}
-- 
2.14.1
