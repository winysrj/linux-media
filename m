Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:52043 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdIOHtB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 03:49:01 -0400
Subject: [PATCH 1/9] [media] tm6000: Delete seven error messages for a failed
 memory allocation
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
Message-ID: <00911f7a-7533-1da3-24d4-e3ab7d7a8104@users.sourceforge.net>
Date: Fri, 15 Sep 2017 09:48:18 +0200
MIME-Version: 1.0
In-Reply-To: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 14 Sep 2017 14:34:39 +0200

Omit extra messages for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/tm6000/tm6000-cards.c |  1 -
 drivers/media/usb/tm6000/tm6000-dvb.c   |  5 +----
 drivers/media/usb/tm6000/tm6000-video.c | 13 +++----------
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 2537643a1808..817bae8cb6a1 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1210,4 +1210,3 @@ static int tm6000_usb_probe(struct usb_interface *interface,
-		printk(KERN_ERR "tm6000" ": out of memory!\n");
 		usb_put_dev(usbdev);
 		return -ENOMEM;
 	}
diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 097ac321b7e1..61a4e0a52716 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -137,5 +137,4 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 		usb_free_urb(dvb->bulk_urb);
-		printk(KERN_ERR "tm6000: couldn't allocate transfer buffer!\n");
 		return -ENOMEM;
 	}
 
@@ -403,7 +402,5 @@ static int dvb_init(struct tm6000_core *dev)
-	if (!dvb) {
-		printk(KERN_INFO "Cannot allocate memory\n");
+	if (!dvb)
 		return -ENOMEM;
-	}
 
 	dev->dvb = dvb;
 
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index ec8c4d2534dc..701494e72edc 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -477,13 +477,9 @@ static int tm6000_alloc_urb_buffers(struct tm6000_core *dev)
-	if (!dev->urb_buffer) {
-		tm6000_err("cannot allocate memory for urb buffers\n");
+	if (!dev->urb_buffer)
 		return -ENOMEM;
-	}
 
 	dev->urb_dma = kmalloc(sizeof(dma_addr_t *)*num_bufs, GFP_KERNEL);
-	if (!dev->urb_dma) {
-		tm6000_err("cannot allocate memory for urb dma pointers\n");
+	if (!dev->urb_dma)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < num_bufs; i++) {
 		dev->urb_buffer[i] = usb_alloc_coherent(
@@ -601,12 +597,9 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
-	if (!dev->isoc_ctl.urb) {
-		tm6000_err("cannot alloc memory for usb buffers\n");
+	if (!dev->isoc_ctl.urb)
 		return -ENOMEM;
-	}
 
 	dev->isoc_ctl.transfer_buffer = kmalloc(sizeof(void *)*num_bufs,
 				   GFP_KERNEL);
 	if (!dev->isoc_ctl.transfer_buffer) {
-		tm6000_err("cannot allocate memory for usbtransfer\n");
 		kfree(dev->isoc_ctl.urb);
 		return -ENOMEM;
 	}
-- 
2.14.1
