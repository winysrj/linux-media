Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:63007 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbdIOHvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 03:51:08 -0400
Subject: [PATCH 3/9] [media] tm6000: Use common error handling code in
 tm6000_usb_probe()
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
Message-ID: <8d2722c0-98cf-4447-51ae-039d04dae185@users.sourceforge.net>
Date: Fri, 15 Sep 2017 09:50:43 +0200
MIME-Version: 1.0
In-Reply-To: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 14 Sep 2017 16:00:47 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/tm6000/tm6000-cards.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index ef37fb1f05e4..e18632056976 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1200,15 +1200,15 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	nr = find_first_zero_bit(&tm6000_devused, TM6000_MAXBOARDS);
 	if (nr >= TM6000_MAXBOARDS) {
 		printk(KERN_ERR "tm6000: Supports only %i tm60xx boards.\n", TM6000_MAXBOARDS);
-		usb_put_dev(usbdev);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto put_device;
 	}
 
 	/* Create and initialize dev struct */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
-		usb_put_dev(usbdev);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto put_device;
 	}
 	spin_lock_init(&dev->slock);
 	mutex_init(&dev->usb_lock);
@@ -1331,9 +1331,10 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	printk(KERN_ERR "tm6000: Error %d while registering\n", rc);
 
 	clear_bit(nr, &tm6000_devused);
-	usb_put_dev(usbdev);
 
 	kfree(dev);
+put_device:
+	usb_put_dev(usbdev);
 	return rc;
 }
 
-- 
2.14.1
